param(
  $Name,
  $ArtifactStagingPath = "$(& $PSScriptRoot/lib/Get-ArtifactStagingPath.ps1)",
  $ZipFile = "$ArtifactStagingPath/$Name.zip",
  $SolutionFolder = "solutions/$Name",
  $SrcFolder = "$SolutionFolder/src",
  $SettingsPath = "$SolutionFolder/config.prod.json",
  $MapPath = "$SolutionFolder/map.xml",
  $PackageType = "Both"
)

& $PSScriptRoot/lib/Install-Pac.ps1

pac solution pack `
  --zipfile $ZipFile `
  --folder $SrcFolder `
  --packagetype $PackageType `
  --map $MapPath

Copy-Item `
  $SettingsPath `
  $ArtifactStagingPath
