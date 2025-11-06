#!/usr/bin/env node
import * as fs from 'fs';
import * as path from 'path';

interface SkillRule {
  type: string;
  priority: string;
  promptTriggers: {
    keywords: string[];
    intentPatterns: string[];
  };
}

interface SkillRules {
  [skillName: string]: SkillRule;
}

interface MarketplacePlugin {
  name: string;
  skills?: string[];
}

interface Marketplace {
  plugins: MarketplacePlugin[];
}

function getAvailableSkills(hookDir: string): Set<string> {
  const availableSkills = new Set<string>();

  // Navigate up to find marketplace.json
  let currentDir = hookDir;
  for (let i = 0; i < 5; i++) {
    currentDir = path.dirname(currentDir);
    const marketplacePath = path.join(currentDir, '.claude-plugin', 'marketplace.json');

    if (fs.existsSync(marketplacePath)) {
      try {
        const marketplace: Marketplace = JSON.parse(fs.readFileSync(marketplacePath, 'utf-8'));

        for (const plugin of marketplace.plugins) {
          if (plugin.skills) {
            for (const skillPath of plugin.skills) {
              // Extract skill name from path like "./git-commit" -> "git-commit"
              const skillName = path.basename(skillPath);
              availableSkills.add(skillName);
            }
          }
        }
        break;
      } catch (e) {
        // Continue searching
      }
    }
  }

  return availableSkills;
}

function analyzePrompt(userPrompt: string, skillRulesPath: string, availableSkills: Set<string>): string[] {
  const skillRules: SkillRules = JSON.parse(
    fs.readFileSync(skillRulesPath, 'utf-8')
  );

  const activatedSkills: string[] = [];
  const promptLower = userPrompt.toLowerCase();

  for (const [skillName, rule] of Object.entries(skillRules)) {
    // Only check skills that are actually available
    if (!availableSkills.has(skillName)) {
      continue;
    }

    let matched = false;

    // Check keyword matches
    for (const keyword of rule.promptTriggers.keywords) {
      if (promptLower.includes(keyword.toLowerCase())) {
        matched = true;
        break;
      }
    }

    // Check intent pattern matches
    if (!matched) {
      for (const pattern of rule.promptTriggers.intentPatterns) {
        const regex = new RegExp(pattern, 'i');
        if (regex.test(userPrompt)) {
          matched = true;
          break;
        }
      }
    }

    if (matched) {
      activatedSkills.push(skillName);
    }
  }

  return activatedSkills;
}

function formatSkillReminder(skills: string[]): string {
  if (skills.length === 0) {
    return '';
  }

  const reminderLines = [
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
    '🎯 SKILL ACTIVATION CHECK',
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
    '',
  ];

  for (const skill of skills) {
    reminderLines.push(`Recommended: Use ${skill} skill`);
  }

  reminderLines.push('');
  reminderLines.push('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  return reminderLines.join('\n');
}

// Main execution
const userPrompt = process.argv[2] || '';
const hookDir = path.dirname(new URL(import.meta.url).pathname);
const skillRulesPath = path.join(hookDir, 'skill-rules.json');

const availableSkills = getAvailableSkills(hookDir);
const activatedSkills = analyzePrompt(userPrompt, skillRulesPath, availableSkills);
const reminder = formatSkillReminder(activatedSkills);

if (reminder) {
  console.log(reminder);
}
