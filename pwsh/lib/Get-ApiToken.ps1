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

$response = Invoke-RestMethod `
  -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" `
  -Body "client_id=$ClientId&scope=$Url/.default&grant_type=client_credentials&client_secret=$ClientSecret" `
  -Headers @{
    "Content-type" = "application/x-www-form-urlencoded"
  } `
  -Method Post

Write-Output $response.access_token