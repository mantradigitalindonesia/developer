# Auto-Commit Message Generator

Automatically generate meaningful git commit messages based on your code changes.

## Features

✨ **Smart Analysis**
- Analyzes staged git changes
- Detects file types and change patterns
- Follows conventional commit format
- Generates descriptive commit messages

🎯 **Multiple Formats**
- Node.js version (auto-commit.js)
- Python version (auto-commit.py)
- Windows batch wrapper (commit.bat)
- PowerShell version (commit.ps1)

## Installation

### Option 1: Node.js Version (Recommended)

**Requirements:**
- Node.js installed on your system

**Setup:**
```bash
# Scripts are already in your GitHub folder
# Add to PATH or use directly
node auto-commit.js
```

### Option 2: Python Version

**Requirements:**
- Python 3.6+ installed

**Setup:**
```bash
# Make executable on macOS/Linux
chmod +x auto-commit.py

# Run directly
python auto-commit.py
```

### Option 3: Windows Batch (Easiest for Windows)

**Setup:**
1. Double-click `commit.bat` or run from command line:
```cmd
commit.bat
```

### Option 4: Add to Git Hooks (Advanced)

Create `.git/hooks/prepare-commit-msg` (non-executable on Windows):

```
#!/bin/bash
exec < /dev/tty
node "$(git rev-parse --git-dir)/../auto-commit.js"
```

## Usage

### Basic Usage

1. **Stage your changes:**
```bash
git add .
```

2. **Run the auto-commit tool:**
- **Node.js:** `node auto-commit.js`
- **Python:** `python auto-commit.py`
- **Windows:** Double-click `commit.bat` or run `commit` in CMD
- **PowerShell:** `./commit.ps1`

3. **Review the generated message** and confirm with `y/n`

### Example Output

```
═══════════════════════════════════════
✨ Generated Commit Message:
═══════════════════════════════════════

feat: add new functionality

Files changed: 3
Lines added: 420
Lines removed: 45

Modified files:
- src/components/Button.tsx
- src/styles/button.css
- tests/button.test.tsx

═══════════════════════════════════════

✅ Do you want to commit with this message? (y/n): y

✓ Commit created successfully!
```

## How It Works

The tool analyzes:

1. **Changed Files**
   - Detects test files (.test.js, .spec.js)
   - Detects documentation files (.md, .txt)
   - Counts total files modified

2. **Code Changes**
   - Counts lines added and removed
   - Detects if mostly additions (new feature) or removals (cleanup)

3. **Commit Type** (Conventional Commits)
   - `feat` - New feature
   - `fix` - Bug fix
   - `docs` - Documentation changes
   - `test` - Test changes
   - `refactor` - Code refactoring
   - `chore` - Dependency or build changes
   - `perf` - Performance improvements
   - `ci` - CI/CD changes
   - `style` - Code style changes

## Customization

### Modify Commit Logic (Node.js)

Edit the `generateMessage()` function in `auto-commit.js`:

```javascript
function generateMessage(analysis) {
  const { fileCount, stats, files, types } = analysis;
  
  // Customize logic here
  let subject = "your custom subject";
  let body = "your custom body";
  
  return subject + (body ? "\n" + body : "");
}
```

### Modify Commit Logic (Python)

Edit the `generate_commit_message()` function in `auto-commit.py`:

```python
def generate_commit_message(analysis: Dict) -> str:
    # Customize logic here
    subject = "your custom subject"
    body = "your custom body"
    
    return subject + (f"\n{body}" if body else "")
```

## Troubleshooting

### "Not a git repository" error
- Make sure you're in a git repository folder
- Run `git init` if needed

### "No staged changes found"
- Stage your changes first: `git add .`
- Or stage specific files: `git add src/file.js`

### Node.js not found
- Install Node.js from https://nodejs.org/
- Or use the Python version instead

### Python not found
- Install Python 3 from https://www.python.org/
- Or use the Node.js version instead

## Tips & Tricks

✅ **Best Practices:**
- Keep commits focused on one change
- Use meaningful file changes for better messages
- Stage related changes together
- Review the generated message before confirming

📝 **Manual Override:**
- If you don't like the generated message, press `n`
- Use `git commit -m "your message"` for manual commits

🔄 **Integration:**
- Add to your git workflow scripts
- Combine with `git add .` for faster commits
- Use in CI/CD pipelines with automated approval

## Version Comparison

| Feature | Node.js | Python | Batch |
|---------|---------|--------|-------|
| No dependencies* | ✓ | ✓ | ✓ |
| Fast execution | ✓ | ✓ | ✓ |
| Easy to customize | ○ | ✓ | ✗ |
| Works on Windows | ✓ | ✓ | ✓ |
| Works on macOS/Linux | ✓ | ✓ | ✗ |

*Node.js and Python are required by their respective scripts

## Support

For issues or improvements, feel free to:
1. Edit the scripts directly
2. Add more sophisticated logic
3. Integrate with AI APIs (OpenAI, Claude, etc.)

---

**Created:** 2026
**License:** MIT
