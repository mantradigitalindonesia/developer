@echo off
REM Auto-commit message generator for Windows
REM Usage: commit [optional message]

node "%~dp0auto-commit.js" %*
pause
