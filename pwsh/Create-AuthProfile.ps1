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

pac auth create `
  --url $Url `
  --applicationId $ClientId `
  --clientSecret $ClientSecret `
  --tenant $TenantId
