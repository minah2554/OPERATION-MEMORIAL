# ============================================================
# deploy.ps1  —  OPERATION: MEMORIAL 자동 배포 스크립트
# 사용법: .\deploy.ps1 "커밋 메시지"
# ============================================================

param(
    [string]$Message = "update: auto deploy $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
)

$ErrorActionPreference = "Stop"
$ProjectDir = $PSScriptRoot

Set-Location $ProjectDir

Write-Host ""
Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   OPERATION: MEMORIAL — AUTO DEPLOY      ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ── 1. Git commit & push ────────────────────────────────────
Write-Host "[1/3] GitHub 커밋 & 푸시..." -ForegroundColor Yellow
git add -A
$status = git status --porcelain
if ($status) {
    git commit -m $Message
    git push origin main
    Write-Host "  ✓ GitHub 푸시 완료" -ForegroundColor Green
} else {
    Write-Host "  ℹ 변경사항 없음, 푸시 건너뜀" -ForegroundColor Gray
}

# ── 2. Vercel 배포 ──────────────────────────────────────────
Write-Host ""
Write-Host "[2/3] Vercel 배포..." -ForegroundColor Yellow
vercel --prod --yes 2>&1 | ForEach-Object {
    if ($_ -match "Production:") {
        Write-Host "  ✓ Vercel URL: $_" -ForegroundColor Green
    } elseif ($_ -match "Error") {
        Write-Host "  ✗ $_" -ForegroundColor Red
    }
}
Write-Host "  ✓ Vercel 배포 완료" -ForegroundColor Green

# ── 3. Firebase Hosting 배포 ────────────────────────────────
Write-Host ""
Write-Host "[3/3] Firebase Hosting 배포..." -ForegroundColor Yellow
firebase deploy --only hosting 2>&1 | ForEach-Object {
    if ($_ -match "Hosting URL:") {
        Write-Host "  ✓ Firebase URL: $_" -ForegroundColor Green
    } elseif ($_ -match "Error") {
        Write-Host "  ✗ $_" -ForegroundColor Red
    }
}
Write-Host "  ✓ Firebase Hosting 배포 완료" -ForegroundColor Green

Write-Host ""
Write-Host "══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  배포 완료! 아래 URL에서 확인하세요." -ForegroundColor Cyan
Write-Host "  · Vercel  : https://operation-memorial.vercel.app" -ForegroundColor White
Write-Host "  · Firebase: https://operation-memorial.web.app" -ForegroundColor White
Write-Host "══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
