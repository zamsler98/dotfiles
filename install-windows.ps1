#Requires -Version 5.1
<#
.SYNOPSIS
    Creates symlinks from Windows config locations to dotfiles in this repo.
.DESCRIPTION
    Run this script from the repo, or from anywhere — it auto-detects the repo root.
    Requires either Administrator privileges or Developer Mode enabled.
.EXAMPLE
    .\install-windows.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Configuration: Add new mappings here ---
# Each entry: @{ Source = path relative to repo root; Target = absolute Windows path }
$Mappings = @(
    @{
        Source = ".config\nvim"
        Target = "$env:LOCALAPPDATA\nvim"
    }
)

# --- Helper Functions ---

function Test-SymlinkCapability {
    # Check if we can create symlinks (admin or developer mode)
    $devMode = $false
    try {
        $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
        $val = Get-ItemProperty -Path $regPath -Name AllowDevelopmentWithoutDevLicense -ErrorAction SilentlyContinue
        if ($val.AllowDevelopmentWithoutDevLicense -eq 1) {
            $devMode = $true
        }
    } catch {}

    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )

    if (-not $isAdmin -and -not $devMode) {
        Write-Error "Cannot create symlinks. Either run as Administrator or enable Developer Mode in Windows Settings."
        exit 1
    }
}

function New-SymlinkMapping {
    param(
        [string]$Source,
        [string]$Target
    )

    if (-not (Test-Path $Source)) {
        Write-Warning "Source not found, skipping: $Source"
        return
    }

    if (Test-Path $Target) {
        $item = Get-Item $Target -Force
        if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            $existingTarget = $item.Target
            if ($existingTarget -eq $Source) {
                Write-Host "  [OK] Already linked: $Target -> $Source" -ForegroundColor Green
                return
            }
        }
        Write-Warning "Target already exists, skipping: $Target"
        Write-Warning "  Remove it manually if you want to re-create the symlink."
        return
    }

    # Ensure parent directory exists
    $parent = Split-Path -Parent $Target
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    # Determine if source is a directory or file
    $isDir = (Get-Item $Source).PSIsContainer
    if ($isDir) {
        New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null
    } else {
        New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null
    }

    Write-Host "  [LINKED] $Target -> $Source" -ForegroundColor Cyan
}

# --- Main ---

$RepoRoot = $PSScriptRoot
Write-Host "Dotfiles repo: $RepoRoot" -ForegroundColor Yellow
Write-Host ""

Test-SymlinkCapability

Write-Host "Creating symlinks..." -ForegroundColor Yellow
Write-Host ""

foreach ($mapping in $Mappings) {
    $source = Join-Path $RepoRoot $mapping.Source
    $target = $mapping.Target

    Write-Host "  $($mapping.Source)" -ForegroundColor White -NoNewline
    Write-Host " -> " -NoNewline
    Write-Host "$target" -ForegroundColor White
    New-SymlinkMapping -Source $source -Target $target
    Write-Host ""
}

Write-Host "Done!" -ForegroundColor Green
