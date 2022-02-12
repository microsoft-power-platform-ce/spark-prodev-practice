param(
  [Parameter(Mandatory=$true)]
  [string]$Name,
  [string]$Path = "./$Name.zip",
  [string]$Folder = "solutions/$Name/src",
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

& $PSScriptRoot/Create-AuthProfile.ps1 `
  -Url $Url `
  -ClientId $ClientId `
  -ClientSecret $ClientSecret `
  -TenantId $TenantId

switch($PackageType)
{
  "Both" {
    1..2 | ForEach-Object -Parallel {
      switch ($_) {
        1 {
          & $PSScriptRoot/Export-Managed.ps1 `
            -PackageType $using:PackageType `
            -Path $using:Path `
            -Name $using:Name
        }
        2 {
          & $PSScriptRoot/Export-Unmanaged.ps1 `
            -Path $using:Path `
            -Name $using:Name
        }
      }
    }
  }
  "Managed" {
    & $PSScriptRoot/Export-Managed.ps1 `
      -PackageType $PackageType `
      -Path $Path `
      -Name $Name
  }
  "Unmanaged" {
    & $PSScriptRoot/Export-Unmanaged.ps1 `
      -Path $Path `
      -Name $Name
  }
}

pac solution unpack `
  --zipfile $Path `
  --folder $Folder `
  --packagetype $PackageType `
  --allowDelete
