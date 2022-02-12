param(
  [Parameter(Mandatory=$true)]
  [string]$Path,
  [Parameter(Mandatory=$true)]
  [string]$Name
)

& $PSScriptRoot/Install-Pac.ps1

pac solution export `
  --path $Path `
  --name $Name `
  --async
