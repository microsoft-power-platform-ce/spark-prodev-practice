if ([string]::IsNullOrEmpty($GITHUB_PATH))
{
  Write-Output "azdops"
} else {
  Write-Output "github"
}
