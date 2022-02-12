param(
  $Name,
  $ZipFile = "$(& $PSScriptRoot/lib/Get-ArtifactStagingPath.ps1)/$Name.zip",
  $Folder = "solutions/$Name/src",
  $PackageType = "Both"
)

& $PSScriptRoot/lib/Install-Pac.ps1

pac solution pack `
  --zipfile $ZipFile `
  --folder $Folder `
  --packagetype $PackageType
