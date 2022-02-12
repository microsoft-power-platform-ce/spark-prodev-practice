param(
  [Parameter(Mandatory=$true)]
  [string]$Url,
  [Parameter(Mandatory=$true)]
  [string]$ClientId,
  [Parameter(Mandatory=$true)]
  [string]$ClientSecret,
  [Parameter(Mandatory=$true)]
  [string]$TenantId
)

& $PSScriptRoot/Install-Pac.ps1

pac auth create `
  --url $Url `
  --applicationId $ClientId `
  --clientSecret $ClientSecret `
  --tenant $TenantId
