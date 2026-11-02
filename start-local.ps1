$ErrorActionPreference = 'Stop'

$projectRoot = $PSScriptRoot
Push-Location $projectRoot
try {
    python backend\server.py
    if ($LASTEXITCODE -ne 0) {
        throw "SpiceVilla exited with code $LASTEXITCODE."
    }
} finally {
    Pop-Location
}
