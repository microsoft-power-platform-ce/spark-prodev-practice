param(
  [Parameter(Mandatory=$true)]
  [string]$Name,
  [string]$Path = "./$Name.zip",
  [string]$Folder = "solutions/$Name/src"
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

function Export-Managed
{
  pac solution export `
    --path (
        if ($PackageType -eq "Both") {
          ($Path -Replace "\.zip$", "_managed.zip")
        } else {
          $Path
        }
      ) `
    --name $Name `
    --managed `
    --async
}

function Export-Unmanaged
{
  pac solution export `
    --path $Path `
    --name $Name `
    --async
}

switch($PackageType)
{
  "Both" {
    1..2 | ForEach-Object -Parallel {
      switch ($_) {
        1 { Export-Managed }
        2 { Export-Unmanaged }
      }
    }
  }
  "Managed" { Export-Managed }
  "Unmanaged" { Export-Unmanaged }
}

pac solution unpack `
  --zipfile $Path `
  --folder $Folder `
  --packagetype $PackageType `
  --allowDelete
