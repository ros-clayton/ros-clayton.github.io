$ErrorActionPreference = "Stop"

$cvDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $cvDir
$quarto = "C:\Program Files\RStudio\resources\app\bin\quarto\bin\quarto.exe"

& $quarto render (Join-Path $cvDir "academic.qmd") --to pdf

$renderedPdf = Join-Path $cvDir "ros-clayton-cv.pdf"
$sitePdf = Join-Path $repoRoot "assets\pdf\ros-clayton-cv.pdf"
Copy-Item -LiteralPath $renderedPdf -Destination $sitePdf -Force

$renderedTex = Join-Path $cvDir "academic.tex"
if (Test-Path $renderedTex) {
  Remove-Item -LiteralPath $renderedTex -Force
}
if (Test-Path $renderedPdf) {
  Remove-Item -LiteralPath $renderedPdf -Force
}

Write-Host "Rendered academic CV to $sitePdf"
