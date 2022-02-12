$platform = & $PSScriptRoot/Get-Platform.ps1
switch($platform) {
  "azdops" {
    Write-Output "$env:BUILD_ARTIFACTSTAGINGDIRECTORY"
  }
  "github" {
    $artifactDir = "$env:RUNNER_TEMP/artifact"
    New-Item $artifactDir -ItemType Directory | Out-Null
    Write-Output $artifactDir
  }
}
