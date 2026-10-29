<#
  Builds the publishable site folder from index.template.html.
  Usage: .\build-site.ps1 -SupportEmail you@example.com [-EffectiveDate "29 October 2026"]
  Output: ..\tilecalcu-privacy-site\  (index.html and .nojekyll only). Refuses to write if any {{placeholder}} remains.
#>
param(
    [Parameter(Mandatory)] [string] $SupportEmail,
    [string] $EffectiveDate = (Get-Date).ToString("d MMMM yyyy", [Globalization.CultureInfo]::InvariantCulture)
)
$ErrorActionPreference = "Stop"
if ($SupportEmail -notmatch '^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$') { throw "That is not a valid email address." }
$src = Join-Path $PSScriptRoot "index.template.html"
$out = Join-Path (Split-Path -Parent $PSScriptRoot) "tilecalcu-privacy-site"
New-Item -ItemType Directory -Force $out | Out-Null
$html = [IO.File]::ReadAllText($src, [Text.Encoding]::UTF8).Replace("{{SUPPORT_EMAIL}}", $SupportEmail).Replace("{{EFFECTIVE_DATE}}", $EffectiveDate)
if ($html -match '\{\{|\}\}') { throw "A placeholder is still present." }
[IO.File]::WriteAllText((Join-Path $out "index.html"), $html, (New-Object Text.UTF8Encoding($false)))
[IO.File]::WriteAllText((Join-Path $out ".nojekyll"), "`n", (New-Object Text.UTF8Encoding($false)))
Get-ChildItem $out -Force | Select-Object Name, Length

