#!/usr/bin/env python3
"""
Auto-commit message generator
Analyzes git staged changes and generates meaningful commit messages
"""

import subprocess
import sys
import re
from pathlib import Path
from typing import Tuple, Dict, List


COMMIT_TYPES = {
    "feat": "A new feature",
    "fix": "A bug fix",
    "docs": "Documentation only changes",
    "style": "Changes that don't affect code meaning",
    "refactor": "Code change that neither fixes a bug nor adds a feature",
    "perf": "Code change that improves performance",
    "test": "Adding or updating tests",
    "chore": "Changes to build process or dependencies",
    "ci": "CI configuration changes",
}


def get_staged_files() -> List[str]:
    """Get list of staged files"""
    try:
        output = subprocess.check_output(
            ["git", "diff", "--cached", "--name-only"],
            text=True,
            stderr=subprocess.PIPE
        )
        return [f.strip() for f in output.split("\n") if f.strip()]
    except subprocess.CalledProcessError:
        print("Error: Not a git repository or no staged changes")
        sys.exit(1)


def get_detailed_diff() -> str:
    """Get detailed diff of staged changes"""
    try:
        output = subprocess.check_output(
            ["git", "diff", "--cached"],
            text=True,
            stderr=subprocess.PIPE
        )
        return output
    except subprocess.CalledProcessError:
        return ""


def analyze_changes(files: List[str], diff: str) -> Dict:
    """Analyze changes and categorize them"""
    stats = {
        "added_lines": len(re.findall(r"^\+", diff, re.MULTILINE)) - len(files),
        "removed_lines": len(re.findall(r"^-", diff, re.MULTILINE)) - len(files),
        "test_files": sum(1 for f in files if ".test." in f or ".spec." in f),
        "doc_files": sum(1 for f in files if f.endswith((".md", ".txt", ".rst"))),
    }

    types = set()
    for file in files:
        if "package.json" in file or "requirements.txt" in file:
            types.add("chore")
        if file.endswith((".js", ".ts", ".jsx", ".tsx", ".py", ".java")):
            types.add("feat")

    return {
        "files": files,
        "file_count": len(files),
        "stats": stats,
        "types": list(types),
    }


def generate_commit_message(analysis: Dict) -> str:
    """Generate commit message from analysis"""
    file_count = analysis["file_count"]
    stats = analysis["stats"]
    files = analysis["files"]
    types = analysis["types"]

    # Determine commit type
    commit_type = "chore"
    if stats["test_files"] > 0:
        commit_type = "test"
    elif stats["doc_files"] == file_count:
        commit_type = "docs"
    elif "feat" in types:
        commit_type = "feat"

    # Generate subject
    is_small_change = file_count <= 3

    if stats["doc_files"] == file_count:
        subject = f"{commit_type}: update documentation"
    elif stats["test_files"] > 0:
        subject = f"{commit_type}: add/update tests"
    elif stats["added_lines"] > stats["removed_lines"] * 2:
        subject = f"{commit_type}: add new functionality"
    elif stats["removed_lines"] > stats["added_lines"]:
        subject = f"{commit_type}: remove unused code"
    elif is_small_change and file_count == 1:
        subject = f"{commit_type}: update {Path(files[0]).name}"
    else:
        subject = f"{commit_type}: refactor code structure"

    # Generate body
    body = f"\nFiles changed: {file_count}\n"
    body += f"Lines added: {stats['added_lines']}\n"
    body += f"Lines removed: {stats['removed_lines']}\n"

    if file_count <= 5:
        body += "\nModified files:\n"
        for file in files:
            body += f"- {file}\n"

    return subject + body


def commit_with_message(message: str) -> None:
    """Commit with the generated message"""
    try:
        subprocess.run(
            ["git", "commit", "-m", message],
            check=True,
        )
        print("\n✓ Commit created successfully!")
    except subprocess.CalledProcessError as e:
        print(f"Error creating commit: {e}")
        sys.exit(1)


def main():
    print("📝 Analyzing staged changes...\n")

    files = get_staged_files()
    if not files:
        print("Error: No staged changes found. Stage your changes first with: git add .")
        sys.exit(1)

    diff = get_detailed_diff()
    analysis = analyze_changes(files, diff)
    message = generate_commit_message(analysis)

    print("═" * 43)
    print("✨ Generated Commit Message:")
    print("═" * 43 + "\n")
    print(message)
    print("\n" + "═" * 43)

    # Ask user if they want to commit
    try:
        answer = input("\n✅ Do you want to commit with this message? (y/n): ").strip().lower()
        if answer == "y":
            commit_with_message(message)
        else:
            print("\nCommit cancelled.")
    except KeyboardInterrupt:
        print("\n\nCommit cancelled.")
        sys.exit(0)


if __name__ == "__main__":
    main()
