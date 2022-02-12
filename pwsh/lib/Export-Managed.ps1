param(
  [Parameter(Mandatory=$true)]
  [string]$PackageType,
  [Parameter(Mandatory=$true)]
  [string]$Path,
  [Parameter(Mandatory=$true)]
  [string]$Name
)

& $PSScriptRoot/Install-Pac.ps1

if ($PackageType -eq "Both") {
  $managedPath = ($Path -Replace "\.zip$", "_managed.zip")
} else {
  $managedPath = $Path
}
pac solution export `
  --path $managedPath `
  --name $Name `
  --managed `
  --async
