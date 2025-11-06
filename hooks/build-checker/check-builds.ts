#!/usr/bin/env node
import * as fs from 'fs';
import * as path from 'path';
import * as os from 'os';
import { execSync } from 'child_process';

const EDIT_LOG = '/tmp/claude-code-edits.txt';

interface BuildResult {
  language: string;
  command: string;
  errors: string[];
  success: boolean;
}

function detectProjectType(dir: string): string | null {
  if (fs.existsSync(path.join(dir, 'package.json'))) return 'typescript';
  if (fs.existsSync(path.join(dir, 'go.mod'))) return 'go';
  if (fs.existsSync(path.join(dir, 'pyproject.toml'))) return 'python';
  if (fs.existsSync(path.join(dir, 'setup.py'))) return 'python';
  if (fs.existsSync(path.join(dir, 'requirements.txt'))) return 'python';
  return null;
}

function findProjectRoot(filePath: string): string | null {
  let dir = path.dirname(filePath);

  while (dir !== '/' && dir !== '.') {
    const projectType = detectProjectType(dir);
    if (projectType) return dir;
    dir = path.dirname(dir);
  }

  return null;
}

function runBuild(projectRoot: string, projectType: string): BuildResult {
  const result: BuildResult = {
    language: projectType,
    command: '',
    errors: [],
    success: false
  };

  try {
    let output = '';

    switch (projectType) {
      case 'typescript':
        result.command = 'tsc --noEmit || npm run build || pnpm build';
        try {
          execSync('tsc --noEmit', { cwd: projectRoot, encoding: 'utf-8', stdio: 'pipe' });
          result.success = true;
        } catch (e: any) {
          output = e.stdout || e.stderr || e.message;
        }
        break;

      case 'go':
        result.command = 'go build ./...';
        try {
          execSync('go build ./...', { cwd: projectRoot, encoding: 'utf-8', stdio: 'pipe' });
          result.success = true;
        } catch (e: any) {
          output = e.stdout || e.stderr || e.message;
        }
        break;

      case 'python':
        result.command = 'mypy . || python -m py_compile';
        try {
          // Try mypy first
          execSync('mypy .', { cwd: projectRoot, encoding: 'utf-8', stdio: 'pipe' });
          result.success = true;
        } catch (e: any) {
          output = e.stdout || e.stderr || e.message;
          // Fallback to py_compile
          try {
            execSync('find . -name "*.py" -exec python -m py_compile {} +', {
              cwd: projectRoot,
              encoding: 'utf-8',
              stdio: 'pipe'
            });
            result.success = true;
            output = '';
          } catch (e2: any) {
            output += '\n' + (e2.stdout || e2.stderr || e2.message);
          }
        }
        break;
    }

    if (output) {
      result.errors = output.split('\n').filter(line =>
        line.includes('error') ||
        line.includes('Error') ||
        line.includes('ERROR') ||
        /:\d+:\d+/.test(line) // error with line:col
      );
    }

  } catch (e: any) {
    result.errors.push(e.message);
  }

  return result;
}

function formatOutput(results: BuildResult[]): void {
  if (results.length === 0) return;

  const hasErrors = results.some(r => !r.success || r.errors.length > 0);

  if (!hasErrors) return;

  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('🔨 BUILD CHECK RESULTS');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  for (const result of results) {
    if (!result.success || result.errors.length > 0) {
      console.log(`❌ ${result.language.toUpperCase()}: ${result.errors.length} error(s)\n`);
      console.log(`   Command: ${result.command}\n`);

      const displayErrors = result.errors.slice(0, 5);
      for (const error of displayErrors) {
        console.log(`   ${error}`);
      }

      if (result.errors.length > 5) {
        console.log(`\n   ... and ${result.errors.length - 5} more errors`);
        console.log('\n   💡 Recommend: Launch build-error-resolver agent');
      }
      console.log();
    }
  }

  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
}

// Main execution
try {
  if (!fs.existsSync(EDIT_LOG)) {
    process.exit(0);
  }

  const fileList = fs.readFileSync(EDIT_LOG, 'utf-8')
    .split('\n')
    .filter(f => f.trim().length > 0);

  // Clear log
  fs.unlinkSync(EDIT_LOG);

  if (fileList.length === 0) {
    process.exit(0);
  }

  // Find unique project roots
  const projectRoots = new Map<string, string>();

  for (const file of fileList) {
    const root = findProjectRoot(file);
    if (root) {
      const type = detectProjectType(root);
      if (type) {
        projectRoots.set(root, type);
      }
    }
  }

  // Run builds
  const results: BuildResult[] = [];
  for (const [root, type] of projectRoots.entries()) {
    results.push(runBuild(root, type));
  }

  formatOutput(results);
} catch (e) {
  // Silently fail - don't break the workflow
}
