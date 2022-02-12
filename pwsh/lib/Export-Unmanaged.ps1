param(
  [Parameter(Mandatory=$true)]
  [string]$Path,
  [Parameter(Mandatory=$true)]
  [string]$Name
)

pac solution export `
  --path $Path `
  --name $Name `
  --async
