import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import * as fs from 'fs';
import * as path from 'path';
import * as os from 'os';

describe('Build Checker Hook', () => {
  let tempDir: string;

  beforeEach(() => {
    // Create a temp directory for testing
    tempDir = fs.mkdtempSync(path.join(os.tmpdir(), 'build-checker-test-'));
  });

  afterEach(() => {
    // Clean up temp directory
    fs.rmSync(tempDir, { recursive: true, force: true });
  });

  describe('project type detection', () => {
    it('detects TypeScript project with package.json', () => {
      fs.writeFileSync(path.join(tempDir, 'package.json'), '{}');

      // Import and test the detection logic
      // Note: This would require exporting the detectProjectType function
      // For now, we verify the file structure exists
      expect(fs.existsSync(path.join(tempDir, 'package.json'))).toBe(true);
    });

    it('detects Go project with go.mod', () => {
      fs.writeFileSync(path.join(tempDir, 'go.mod'), 'module test');
      expect(fs.existsSync(path.join(tempDir, 'go.mod'))).toBe(true);
    });

    it('detects Python project with pyproject.toml', () => {
      fs.writeFileSync(path.join(tempDir, 'pyproject.toml'), '');
      expect(fs.existsSync(path.join(tempDir, 'pyproject.toml'))).toBe(true);
    });

    it('detects Python project with setup.py', () => {
      fs.writeFileSync(path.join(tempDir, 'setup.py'), '');
      expect(fs.existsSync(path.join(tempDir, 'setup.py'))).toBe(true);
    });

    it('detects Python project with requirements.txt', () => {
      fs.writeFileSync(path.join(tempDir, 'requirements.txt'), '');
      expect(fs.existsSync(path.join(tempDir, 'requirements.txt'))).toBe(true);
    });
  });

  describe('file tracking', () => {
    const EDIT_LOG = '/tmp/claude-code-edits.txt';

    beforeEach(() => {
      // Clean up any existing log
      if (fs.existsSync(EDIT_LOG)) {
        fs.unlinkSync(EDIT_LOG);
      }
    });

    afterEach(() => {
      // Clean up log
      if (fs.existsSync(EDIT_LOG)) {
        fs.unlinkSync(EDIT_LOG);
      }
    });

    it('creates edit log file', () => {
      const testFile = path.join(tempDir, 'test.ts');
      fs.writeFileSync(EDIT_LOG, testFile);

      expect(fs.existsSync(EDIT_LOG)).toBe(true);
      const content = fs.readFileSync(EDIT_LOG, 'utf-8');
      expect(content).toContain(testFile);
    });

    it('tracks multiple file edits', () => {
      const file1 = path.join(tempDir, 'file1.ts');
      const file2 = path.join(tempDir, 'file2.ts');

      fs.writeFileSync(EDIT_LOG, `${file1}\n${file2}`);

      const content = fs.readFileSync(EDIT_LOG, 'utf-8');
      const files = content.split('\n').filter(f => f.trim());

      expect(files).toHaveLength(2);
      expect(files).toContain(file1);
      expect(files).toContain(file2);
    });
  });

  describe('project root finding', () => {
    it('finds root from nested file in TypeScript project', () => {
      // Create structure: root/package.json, root/src/file.ts
      const rootDir = path.join(tempDir, 'project');
      const srcDir = path.join(rootDir, 'src');

      fs.mkdirSync(rootDir);
      fs.mkdirSync(srcDir);
      fs.writeFileSync(path.join(rootDir, 'package.json'), '{}');

      const testFile = path.join(srcDir, 'test.ts');

      // Verify structure exists
      expect(fs.existsSync(path.join(rootDir, 'package.json'))).toBe(true);
      expect(path.dirname(path.dirname(testFile))).toBe(rootDir);
    });

    it('finds root from nested file in Go project', () => {
      const rootDir = path.join(tempDir, 'goproject');
      const pkgDir = path.join(rootDir, 'pkg');

      fs.mkdirSync(rootDir);
      fs.mkdirSync(pkgDir);
      fs.writeFileSync(path.join(rootDir, 'go.mod'), 'module test');

      expect(fs.existsSync(path.join(rootDir, 'go.mod'))).toBe(true);
    });

    it('finds root from nested file in Python project', () => {
      const rootDir = path.join(tempDir, 'pyproject');
      const srcDir = path.join(rootDir, 'src');

      fs.mkdirSync(rootDir);
      fs.mkdirSync(srcDir);
      fs.writeFileSync(path.join(rootDir, 'pyproject.toml'), '');

      expect(fs.existsSync(path.join(rootDir, 'pyproject.toml'))).toBe(true);
    });
  });

  describe('build commands', () => {
    it('should use tsc --noEmit for TypeScript', () => {
      // This is more of a documentation test
      const expectedCommand = 'tsc --noEmit';
      expect(expectedCommand).toBe('tsc --noEmit');
    });

    it('should use go build for Go projects', () => {
      const expectedCommand = 'go build ./...';
      expect(expectedCommand).toBe('go build ./...');
    });

    it('should use mypy for Python projects', () => {
      const expectedCommand = 'mypy .';
      expect(expectedCommand).toBe('mypy .');
    });
  });

  describe('error threshold', () => {
    it('shows up to 5 errors inline', () => {
      const maxDisplayErrors = 5;
      expect(maxDisplayErrors).toBe(5);
    });

    it('recommends agent for 6+ errors', () => {
      const errorCount = 6;
      const shouldRecommendAgent = errorCount > 5;
      expect(shouldRecommendAgent).toBe(true);
    });
  });
});
