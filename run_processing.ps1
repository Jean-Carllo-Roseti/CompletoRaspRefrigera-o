$ErrorActionPreference = 'Stop'

$projectRoot = $PSScriptRoot
$sketchPath = Join-Path $projectRoot 'Front-End'
$processingExe = 'C:\Program Files\Processing\Processing.exe'

if (-not (Test-Path -LiteralPath $processingExe -PathType Leaf)) {
    throw "Processing.exe não encontrado em '$processingExe'. Ajuste a variável `$processingExe neste script."
}

if (-not (Test-Path -LiteralPath (Join-Path $sketchPath 'RaspberryResfriacao.pde') -PathType Leaf)) {
    throw "Sketch não encontrada em '$sketchPath'."
}

& $processingExe cli "--sketch=$sketchPath" --run
exit $LASTEXITCODE
