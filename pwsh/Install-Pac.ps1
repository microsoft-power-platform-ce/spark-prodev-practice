if (Get-Command pac -ErrorAction Ignore)
{
  exit
}

$platform = & $PSScriptRoot/Get-Platform.ps1
Write-Host "Platform: $platform"
switch($platform) {
  "azdops" {
    $destinationFolder = $env:AGENT_TEMPDIRECTORY
    $operatingSystem = $env:AGENT_OS
  }
  "github" {
    $destinationFolder = $env:RUNNER_TEMP
    $operatingSystem = $env:RUNNER_OS
  }
}

Write-Host "downloading pac..."

$packageId = switch ($operatingSystem) {
  "Linux" { "Microsoft.PowerApps.CLI.Core.linux-x64" }
  { @("Darwin", "macOS") -contains $_ } {
    "Microsoft.PowerApps.CLI.Core.osx-x64"
  }
  { $_ -match "^Windows" } { "Microsoft.PowerApps.CLI" }
}
Write-Host "package id: $packageId"

$id = $packageId.ToLower()
$packageInfo = Invoke-RestMethod `
  "https://api.nuget.org/v3/registration5-semver1/$id/index.json"
$version = $packageInfo.items[0].upper
Write-Host "latest version: $version"

if(!(Test-Path $destinationFolder)) {
  New-Item $destinationFolder `
    -ItemType Directory
}

Invoke-WebRequest `
  -Uri "https://api.nuget.org/v3-flatcontainer/$id/$version/$id.$version.nupkg" `
  -OutFile "$destinationFolder/$packageId.zip"
Write-Host "downloaded $packageId.zip"

Expand-Archive `
  "$destinationFolder/$packageId.zip" `
  "$destinationFolder/$packageId"
Write-Host "extracted to $packageId"

Copy-Item `
  "$destinationFolder/$packageId/tools" `
  "$destinationFolder/pac" `
  -Recurse
Write-Host "copied tools subfolder to $destinationFolder/pac"

if (Get-Command chmod -ErrorAction Ignore) {
  Write-Host "making pac executable"
  chmod 777 "$destinationFolder/pac/pac"
}

Write-Host "disabling telemetry"
Invoke-Expression "$destinationFolder/pac/pac telemetry disable"

Write-Host "Prepending pac folder to system path"
& $PSScriptRoot/Add-Path.ps1 "$destinationFolder/pac"

Set-Alias `
  -Name pac `
  -Value "$destinationFolder/pac/pac" `
  -Scope Global
