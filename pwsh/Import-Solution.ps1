param(
  $Name,
  $ArtifactPath = "$(& $PSScriptRoot/lib/Get-ArtifactDownloadPath.ps1 solution-artifact)",
  $ZipFile = "$ArtifactPath/$($Name)_managed.zip",
  $SettingsDescriptor = "",
  $SettingsFile = "$ArtifactPath/config.$SettingsDescriptor.json",
  [Parameter(Mandatory=$true)]
  [string]$Url,
  [Parameter(Mandatory=$true)]
  [string]$ClientId,
  [Parameter(Mandatory=$true)]
  [string]$ClientSecret,
  [Parameter(Mandatory=$true)]
  [string]$TenantId
)

& $PSScriptRoot/lib/Create-AuthProfile.ps1 `
  -Url $Url `
  -ClientId $ClientId `
  -ClientSecret $ClientSecret `
  -TenantId $TenantId

pac solution import `
  --path $ZipFile `
  --activate-plugins `
  --async `
  --settings-file $SettingsFile
