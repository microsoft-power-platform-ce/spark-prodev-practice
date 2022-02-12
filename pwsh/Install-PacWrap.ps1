if (Get-Command pac-wrap -ErrorAction Ignore)
{
  exit
}

npm i -g pac-wrap
pac-wrap telemetry disable

Set-Alias `
  -Name pac `
  -Value pac-wrap `
  -Scope Global
