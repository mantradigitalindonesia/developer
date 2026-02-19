# Auto-commit message generator for PowerShell
# Usage: .\commit.ps1

param(
    [switch]$Force = $false
)

# Check if in git repository
try {
    $null = git rev-parse --git-dir
} catch {
    Write-Host "Error: Not a git repository" -ForegroundColor Red
    exit 1
}

# Get staged files
try {
    [string[]]$files = git diff --cached --name-only
} catch {
    Write-Host "Error: No staged changes found. Stage your changes first with: git add ." -ForegroundColor Red
    exit 1
}

if (-not $files -or $files[0] -eq "") {
    Write-Host "Error: No staged changes found. Stage your changes first with: git add ." -ForegroundColor Red
    exit 1
}

# Get detailed diff
$diff = git diff --cached

Write-Host "📝 Analyzing staged changes...`n" -ForegroundColor Cyan

# Analyze changes
$stats = @{
    addedLines = ($diff -split "`n" | Where-Object { $_ -match "^\+" } | Measure-Object).Count - $files.Count
    removedLines = ($diff -split "`n" | Where-Object { $_ -match "^-" } | Measure-Object).Count - $files.Count
    testFiles = ($files | Where-Object { $_ -match "\.test\.|\.spec\." } | Measure-Object).Count
    docFiles = ($files | Where-Object { $_ -match "\.(md|txt|rst)$" } | Measure-Object).Count
}

$fileCount = $files.Count
$hasChoreType = $files | Where-Object { $_ -match "package\.json|requirements\.txt" }
$hasFeatType = $files | Where-Object { $_ -match "\.(js|ts|jsx|tsx|py|java)$" }

# Determine commit type
$commitType = "chore"
if ($stats.testFiles -gt 0) {
    $commitType = "test"
} elseif ($stats.docFiles -eq $fileCount) {
    $commitType = "docs"
} elseif ($hasFeatType) {
    $commitType = "feat"
}

# Generate subject
$subject = ""
$isSmallChange = $fileCount -le 3

if ($stats.docFiles -eq $fileCount) {
    $subject = "$commitType`: update documentation"
} elseif ($stats.testFiles -gt 0) {
    $subject = "$commitType`: add/update tests"
} elseif ($stats.addedLines -gt $stats.removedLines * 2) {
    $subject = "$commitType`: add new functionality"
} elseif ($stats.removedLines -gt $stats.addedLines) {
    $subject = "$commitType`: remove unused code"
} elseif ($isSmallChange -and $fileCount -eq 1) {
    $fileName = Split-Path -Leaf $files[0]
    $subject = "$commitType`: update $fileName"
} else {
    $subject = "$commitType`: refactor code structure"
}

# Generate body
$body = "`nFiles changed: $fileCount`n"
$body += "Lines added: $($stats.addedLines)`n"
$body += "Lines removed: $($stats.removedLines)`n"

if ($fileCount -le 5) {
    $body += "`nModified files:`n"
    foreach ($file in $files) {
        $body += "- $file`n"
    }
}

$message = $subject + $body

# Display message
Write-Host "═════════════════════════════════════════" -ForegroundColor Yellow
Write-Host "✨ Generated Commit Message:" -ForegroundColor Green
Write-Host "═════════════════════════════════════════" -ForegroundColor Yellow
Write-Host ""
Write-Host $message
Write-Host ""
Write-Host "═════════════════════════════════════════" -ForegroundColor Yellow

# Ask for confirmation
if ($Force) {
    $response = "y"
} else {
    $response = Read-Host "`n✅ Do you want to commit with this message? (y/n)"
}

if ($response -eq "y" -or $response -eq "yes") {
    try {
        git commit -m $message | Out-Host
        Write-Host "`n✓ Commit created successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Error creating commit" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "`nCommit cancelled." -ForegroundColor Yellow
}
