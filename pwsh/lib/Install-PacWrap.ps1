if (Get-Command pac-wrap -ErrorAction Ignore)
{
  exit
}

npm i -g pac-wrap

& $PSScriptRoot/Add-Path.ps1 (pac-wrap folder)

Set-Alias `
  -Name pac `
  -Value pac-wrap `
  -Scope Global

pac telemetry disable
