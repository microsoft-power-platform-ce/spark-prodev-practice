if ([string]::IsNullOrEmpty($env:GITHUB_PATH))
{
  Write-Output "azdops"
} else {
  Write-Output "github"
}
