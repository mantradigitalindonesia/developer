# 🚀 Quick Start Guide - Auto-Commit

Get started in 30 seconds!

## Windows Users - Quickest Method

### Step 1: Use PowerShell (Recommended)
```powershell
# Navigate to your repository
cd c:\your\repo\path

# Run the PowerShell script
.\commit.ps1
```

### Step 2: Or Use Command Prompt
```cmd
# Navigate to your repository
cd c:\your\repo\path

# Run the batch file
commit.bat
```

## macOS/Linux Users

### Step 1: Use Python
```bash
# Navigate to your repository
cd /path/to/repo

# Run the Python script
python3 auto-commit.py
```

### Step 2: Or Use Node.js
```bash
# Make sure Node.js is installed
node auto-commit.js
```

## Common Workflow

```bash
# 1. Make your changes
# ... edit files ...

# 2. Stage changes
git add .

# 3. Auto-generate commit message (choose one):
# Windows PowerShell:
.\commit.ps1

# Windows Command Prompt:
commit.bat

# macOS/Linux:
python3 auto-commit.py
# or
node auto-commit.js

# 4. Confirm the message (press 'y' to commit)
✅ Do you want to commit with this message? (y/n): y

# ✓ Done! Your commit is created.
```

## Add to Your PATH (Optional - Make It Available Globally)

### Windows - PowerShell

```powershell
# Open PowerShell as Administrator
# Find where auto-commit.js is located (e.g., c:\Users\inbox\OneDrive\Dokumen\GitHub)

# Create a shortcut or batch file in a PATH directory
# Or add the folder to PATH:
[Environment]::SetEnvironmentVariable("Path", "$env:Path;c:\Users\inbox\OneDrive\Dokumen\GitHub", "User")

# Then restart PowerShell and use:
commit.ps1
```

### Windows - Command Prompt

```cmd
# Add folder to PATH in Environment Variables
setx PATH "%PATH%;c:\Users\inbox\OneDrive\Dokumen\GitHub"

# Then use:
commit.bat
```

### macOS/Linux

```bash
# Add to your shell profile (~/.bashrc, ~/.zshrc, etc.)
alias acommit="python3 /path/to/auto-commit.py"

# Then use:
acommit
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "No staged changes" | Run `git add .` first |
| "Not a git repository" | You're not in a git folder. Run `git init` |
| PowerShell execution policy error | Run: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` |
| Python not found | Install Python from python.org or use Node.js version |
| Node.js not found | Install Node.js from nodejs.org or use Python version |

## What Happens Next?

When you run the script:

1. ✅ Analyzes your staged changes
2. 📝 Generates a meaningful commit message
3. 🎯 Shows you the message and what files changed
4. ❓ Asks for your confirmation
5. ✓ Creates the commit if you approve

## Example Output

```
═══════════════════════════════════════════════
✨ Generated Commit Message:
═══════════════════════════════════════════════

feat: add new functionality

Files changed: 2
Lines added: 156
Lines removed: 23

Modified files:
- src/components/Header.js
- src/styles/header.css

═══════════════════════════════════════════════

✅ Do you want to commit with this message? (y/n): y

✓ Commit created successfully!
```

## Pro Tips

💡 **Tip 1:** Stage related changes together for better commit messages
```bash
git add src/components/   # All component changes
node auto-commit.js        # Will generate feature commit
```

💡 **Tip 2:** Stage one file at a time for precise messages
```bash
git add package.json       # Dependency update
node auto-commit.js        # Will generate chore commit
```

💡 **Tip 3:** Use without confirmation for automation
```powershell
# PowerShell with -Force flag
.\commit.ps1 -Force
```

## File Overview

- **auto-commit.js** - JavaScript/Node.js version
- **auto-commit.py** - Python version  
- **commit.bat** - Windows batch wrapper
- **commit.ps1** - Windows PowerShell script
- **AUTO_COMMIT_GUIDE.md** - Full documentation
- **QUICK_START.md** - This file!

## Next Steps

1. ✅ Choose your preferred method (recommended: PowerShell for Windows)
2. ✅ Run it once with some staged changes
3. ✅ Add to your workflow
4. ✅ (Optional) Configure git hooks for automatic use

---

**Need help?** Read AUTO_COMMIT_GUIDE.md for advanced options and customization.
