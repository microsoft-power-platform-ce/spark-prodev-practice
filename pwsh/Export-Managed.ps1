param(
  [Parameter(Mandatory=$true)]
  [string]$PackageType,
  [Parameter(Mandatory=$true)]
  [string]$Path,
  [Parameter(Mandatory=$true)]
  [string]$Name
)

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
