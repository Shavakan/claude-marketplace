---
description: Clean dependencies - remove unused, fix security issues, update outdated, deduplicate
---

# Clean Up Dependencies

Remove unused packages, update outdated deps, fix security vulnerabilities, deduplicate dependencies.

## Execute

**1. Scan and report:**

```markdown
# Dependency Audit

## Unused Packages ([X] found)
- [ ] `lodash` - imported nowhere
- [ ] `moment` - replaced by date-fns, still in package.json
- [ ] `axios@old` - using fetch now

## Security Issues ([X] found)
- [ ] `axios@0.21.0` - CVE-2021-3749 (upgrade to 1.6.0+)
- [ ] `semver@5.7.0` - CVE-2022-25883 (upgrade to 7.5.2+)

## Outdated ([X] packages)
- [ ] `react@17.0.2` - current: 18.3.1
- [ ] `typescript@4.9.0` - current: 5.3.3
- [ ] `vitest@0.34.0` - current: 1.0.4

## Duplicate Dependencies ([X] found)
- [ ] `lodash@4.17.21` and `lodash@4.17.20` (dedupe)
- [ ] Multiple versions of `@types/node`

## Missing Peer Dependencies ([X] warnings)
- [ ] `eslint-plugin-react` requires `eslint@^8.0.0`

Impact: ~X packages removable, Y security fixes, Z updates
Bundle reduction: ~N KB
```

**2. Ask confirmation:**
```
Clean up dependencies?

Unused: Remove X packages
Security: Fix Y vulnerabilities (critical: Z)
Outdated: Update N packages
Duplicates: Dedupe M packages

□ Yes, clean all
□ Critical only (security + unused)
□ Review first
```

**3. Execute safely:**

**Remove unused:**
```bash
npm uninstall lodash moment
# or
pnpm remove lodash moment
```

**Fix security:**
```bash
npm audit fix
# or manual:
npm install axios@latest
```

**Update outdated:**
```bash
npm update
# or specific:
npm install react@latest typescript@latest
```

**Deduplicate:**
```bash
npm dedupe
```

**4. Test after each change:**
- Remove/update package → Install → Run tests → Pass? Commit : Revert

**Detection:**

**Unused packages:**
- List all packages in package.json
- Grep each import across codebase
- Check if used in build scripts/config
- Flag if 0 references

**Security issues:**
```bash
npm audit
# or
pnpm audit
```

**Outdated packages:**
```bash
npm outdated
# or
pnpm outdated
```

**Duplicates:**
```bash
npm ls <package>
```

**Safety rules:**

**Before removing:**
- Check not used in configs (webpack, vite, etc.)
- Check not used in scripts (package.json scripts)
- Check not used by other packages (transitive dep)
- Verify tests still pass

**Before updating:**
- Check breaking changes in changelog
- Update major versions carefully
- Test thoroughly after update
- Update TypeScript types if needed

**Output:**
```
✓ Dependencies Cleaned

Removed unused:
- lodash
- moment
- old-package

Fixed security:
- axios@0.21.0 → 1.6.2 (CVE-2021-3749)
- semver@5.7.0 → 7.5.4 (CVE-2022-25883)

Updated:
- react@17.0.2 → 18.3.1
- typescript@4.9.0 → 5.3.3
- vitest@0.34.0 → 1.0.4

Deduplicated:
- lodash (2 versions → 1)
- @types/node (3 versions → 1)

Impact:
- 3 packages removed
- 2 security fixes applied
- 12 packages updated
- Bundle reduced by ~45KB

Tests: All passing ✓
Security: 0 vulnerabilities ✓
```

## Commands by Package Manager

**npm:**
```bash
npm install              # Install deps
npm uninstall <pkg>      # Remove package
npm update               # Update all
npm update <pkg>         # Update specific
npm audit                # Security check
npm audit fix            # Auto-fix security
npm dedupe               # Deduplicate
npm outdated             # Show outdated
```

**pnpm:**
```bash
pnpm install
pnpm remove <pkg>
pnpm update
pnpm update <pkg>
pnpm audit
pnpm audit --fix
pnpm dedupe
pnpm outdated
```

**yarn:**
```bash
yarn install
yarn remove <pkg>
yarn upgrade
yarn upgrade <pkg>
yarn audit
yarn audit --fix
yarn dedupe
yarn outdated
```

## Related

- `/shavakan.cleanup` - Full audit
- `/shavakan.cleanup.dead-code` - Remove unused code
