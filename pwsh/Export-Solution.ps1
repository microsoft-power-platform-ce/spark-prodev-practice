param(
  [Parameter(Mandatory=$true)]
  [string]$Name,
  [string]$Path = "./$Name.zip",
  [string]$PackageType = "Both",
  [Parameter(Mandatory=$true)]
  [string]$Url,
  [Parameter(Mandatory=$true)]
  [string]$ClientId,
  [Parameter(Mandatory=$true)]
  [string]$ClientSecret,
  [Parameter(Mandatory=$true)]
  [string]$TenantId
)

1..2 | ForEach-Object -Parallel {
  switch ($_) {
    1 {
      
    }
    2 {
      Write-Host "Started Job 2"
      Start-Sleep 5
      Write-Host "Finished Job 2"
    }
  }
}
