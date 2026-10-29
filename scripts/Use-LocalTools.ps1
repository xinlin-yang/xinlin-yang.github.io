# Dot-source from PowerShell: . .\scripts\Use-LocalTools.ps1
# Changes only this PowerShell session; it does not install software.
$projectRoot = Split-Path -Parent $PSScriptRoot
$toolConfigPath = Join-Path $projectRoot '.local-tools\toolchain.json'
if (-not (Test-Path -LiteralPath $toolConfigPath)) {
    throw 'Local toolchain is missing. See STAGE1_REPORT.md before setting it up.'
}
$toolConfig = Get-Content -LiteralPath $toolConfigPath -Raw | ConvertFrom-Json
foreach ($toolPath in @($toolConfig.node_path, (Join-Path $projectRoot '.local-tools\hugo\hugo.exe'), (Join-Path $projectRoot '.local-tools\go\bin\go.exe'), (Join-Path $projectRoot '.local-tools\bin\pnpm.cmd'))) {
    if (-not (Test-Path -LiteralPath $toolPath)) { throw "Missing local tool: $toolPath" }
}
$nodeDirectory = Split-Path -Parent $toolConfig.node_path
$env:PATH = "$projectRoot\.local-tools\bin;$projectRoot\.local-tools\hugo;$projectRoot\.local-tools\go\bin;$nodeDirectory;$env:PATH"
$env:GOPATH = "$projectRoot\.local-tools\cache\gopath"
$env:GOMODCACHE = "$projectRoot\.local-tools\cache\gomod"
$env:GOCACHE = "$projectRoot\.local-tools\cache\gobuild"
$env:HUGO_CACHEDIR = "$projectRoot\.local-tools\cache\hugo"
$env:GOTELEMETRY = 'off'
$env:GOTOOLCHAIN = 'local'
$env:npm_config_cache = "$projectRoot\.local-tools\cache\npm"
$env:PNPM_HOME = "$projectRoot\.local-tools\bin"