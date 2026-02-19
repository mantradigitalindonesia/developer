#!/usr/bin/env node

/**
 * Auto-commit message generator
 * Analyzes git staged changes and generates meaningful commit messages
 */

const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const COMMIT_TYPES = {
  feat: "A new feature",
  fix: "A bug fix",
  docs: "Documentation only changes",
  style: "Changes that don't affect code meaning",
  refactor: "Code change that neither fixes a bug nor adds a feature",
  perf: "Code change that improves performance",
  test: "Adding or updating tests",
  chore: "Changes to build process or dependencies",
  ci: "CI configuration changes",
};

function getDiff() {
  try {
    return execSync("git diff --cached --name-only", { encoding: "utf-8" });
  } catch (e) {
    console.error("Error: Not a git repository or no staged changes");
    process.exit(1);
  }
}

function getDetailedDiff() {
  try {
    return execSync("git diff --cached", { encoding: "utf-8" });
  } catch (e) {
    return "";
  }
}

function analyzeChanges(files, diff) {
  const fileList = files.trim().split("\n").filter(Boolean);
  const stats = {
    added: 0,
    removed: 0,
    modified: 0,
    testFiles: 0,
    docFiles: 0,
    types: new Set(),
  };

  fileList.forEach((file) => {
    if (file.includes(".test.") || file.includes(".spec.")) stats.testFiles++;
    if (file.match(/\.(md|txt|rst)$/i)) stats.docFiles++;

    if (file.includes("package.json")) stats.types.add("chore");
    if (file.match(/\.(js|ts|jsx|tsx|py|java)$/i)) stats.types.add("feat");
  });

  const addedLines = (diff.match(/^\+/gm) || []).length - fileList.length;
  const removedLines = (diff.match(/^-/gm) || []).length - fileList.length;

  return {
    files: fileList,
    fileCount: fileList.length,
    stats: {
      addedLines,
      removedLines,
      testFiles: stats.testFiles,
      docFiles: stats.docFiles,
    },
    types: Array.from(stats.types),
  };
}

function generateMessage(analysis) {
  const { fileCount, stats, files, types } = analysis;

  // Determine commit type
  let commitType = "chore";
  if (stats.testFiles > 0) commitType = "test";
  else if (stats.docFiles === fileCount) commitType = "docs";
  else if (types.includes("feat")) commitType = "feat";

  // Generate subject based on changes
  let subject = "";
  const isSmallChange = fileCount <= 3;

  if (stats.docFiles === fileCount) {
    subject = `${commitType}: update documentation`;
  } else if (stats.testFiles > 0) {
    subject = `${commitType}: add/update tests`;
  } else if (stats.addedLines > stats.removedLines * 2) {
    subject = `${commitType}: add new functionality`;
  } else if (stats.removedLines > stats.addedLines) {
    subject = `${commitType}: remove unused code`;
  } else if (isSmallChange && fileCount === 1) {
    subject = `${commitType}: update ${path.basename(files[0])}`;
  } else {
    subject = `${commitType}: refactor code structure`;
  }

  // Generate body
  let body = `\nFiles changed: ${fileCount}\n`;
  body += `Lines added: ${stats.addedLines}\n`;
  body += `Lines removed: ${stats.removedLines}\n`;

  if (fileCount <= 5) {
    body += `\nModified files:\n`;
    files.forEach((file) => {
      body += `- ${file}\n`;
    });
  }

  return subject + body;
}

function main() {
  console.log("📝 Analyzing staged changes...\n");

  const files = getDiff();
  if (!files.trim()) {
    console.error("Error: No staged changes found. Stage your changes first with: git add .");
    process.exit(1);
  }

  const diff = getDetailedDiff();
  const analysis = analyzeChanges(files, diff);
  const message = generateMessage(analysis);

  console.log("═══════════════════════════════════════");
  console.log("✨ Generated Commit Message:");
  console.log("═══════════════════════════════════════\n");
  console.log(message);
  console.log("\n═══════════════════════════════════════");

  // Ask user if they want to commit
  const readline = require("readline");
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  rl.question(
    "\n✅ Do you want to commit with this message? (y/n): ",
    (answer) => {
      rl.close();
      if (answer.toLowerCase() === "y") {
        try {
          execSync("git commit -m " + JSON.stringify(message), {
            stdio: "inherit",
          });
          console.log("\n✓ Commit created successfully!");
        } catch (e) {
          console.error("Error creating commit");
          process.exit(1);
        }
      } else {
        console.log("\nCommit cancelled.");
      }
    }
  );
}

main();
