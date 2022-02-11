param (
  [Parameter(Mandatory=$true)]
  [string]$OperatingSystem,
  [Parameter(Mandatory=$true)]
  [string]$DestinationFolder,
  [Parameter(Mandatory=$true)]
  [string]$Platform
)

if (Get-Command pac -ErrorAction Ignore)
{
  # exit
}

Write-Host "downloading pac..."

$packageId = switch ($OperatingSystem) {
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

if(!(Test-Path $DestinationFolder)) {
  New-Item $DestinationFolder `
    -ItemType Directory
}

Invoke-WebRequest `
  -Uri "https://api.nuget.org/v3-flatcontainer/$id/$version/$id.$version.nupkg" `
  -OutFile "$DestinationFolder/$packageId.zip"
Write-Host "downloaded $packageId.zip"

Expand-Archive `
  "$DestinationFolder/$packageId.zip" `
  "$DestinationFolder/$packageId"
Write-Host "extracted to $packageId"

Copy-Item `
  "$DestinationFolder/$packageId/tools" `
  "$DestinationFolder/pac" `
  -Recurse
Write-Host "copied tools subfolder to $DestinationFolder/pac"

Write-Host "disabling telemetry"
if (Get-Command chmod -ErrorAction Ignore) {
  chmod 777 "$DestinationFolder/pac/pac"
  Invoke-Expression "$DestinationFolder/pac/pac telemetry disable"
} else {
  Invoke-Expression "$DestinationFolder/pac/pac.exe telemetry disable"
}

Write-Host "Prepending pac folder to system path"
switch ($Platform) {
  "azdops" {
    Write-Host "##vso[task.prependpath]$DestinationFolder/pac"
  }
  "github" {
    Write-Output "$DestinationFolder/pac" |
      Out-File `
        -FilePath $env:GITHUB_PATH `
        -Encoding utf8 `
        -Append
  }
}
