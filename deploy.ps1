# OPERATION: MEMORIAL Auto Deploy Script
param(
    [string]$Message = "update: auto deploy"
)

$ErrorActionPreference = "Continue"
$ProjectDir = $PSScriptRoot
Set-Location $ProjectDir

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " OPERATION: MEMORIAL - AUTO DEPLOY" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Git commit and push
Write-Host "[1/3] Git Add, Commit & Push..." -ForegroundColor Yellow
git add -A
$status = git status --porcelain
if ($status) {
    git commit -m "$Message"
    git push origin main
    Write-Host "  -> GitHub push completed." -ForegroundColor Green
} else {
    Write-Host "  -> No git changes detected." -ForegroundColor Gray
}

# 2. Vercel deploy
Write-Host "[2/3] Vercel Deploy..." -ForegroundColor Yellow
vercel --prod --yes
Write-Host "  -> Vercel deployment completed." -ForegroundColor Green

# 3. Firebase Hosting deploy
Write-Host "[3/3] Firebase Deploy..." -ForegroundColor Yellow
firebase deploy --only hosting
Write-Host "  -> Firebase deployment completed." -ForegroundColor Green

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Deployment Complete!" -ForegroundColor Cyan
Write-Host " Vercel URL   : https://operation-memorial.vercel.app" -ForegroundColor White
Write-Host " Firebase URL : https://operation-memorial.web.app" -ForegroundColor White
Write-Host "==========================================" -ForegroundColor Cyan
