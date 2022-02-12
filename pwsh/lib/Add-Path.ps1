param(
  [Parameter(Mandatory=$true)]
  [string]$path
)

$platform = & $PSScriptRoot/Get-Platform.ps1
switch ($platform) {
  "azdops" {
    Write-Host "##vso[task.prependpath]$path"
  }
  "github" {
    Write-Output "$path" |
      Out-File `
        -FilePath $env:GITHUB_PATH `
        -Encoding utf8 `
        -Append
  }
}
