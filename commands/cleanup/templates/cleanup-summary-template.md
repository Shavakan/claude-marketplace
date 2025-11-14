# Cleanup Summary Report

**Operation:** {{OPERATION_NAME}}
**Started:** {{START_TIME}}
**Completed:** {{END_TIME}}
**Duration:** {{DURATION}}

---

## Changes Made

{{CHANGES_SUMMARY}}

---

## Commits Created

{{COMMITS_LIST}}

---

## Files Modified

- **Total files changed:** {{FILES_CHANGED}}
- **Lines added:** {{LINES_ADDED}}
- **Lines removed:** {{LINES_REMOVED}}

### Modified Files List

{{MODIFIED_FILES_LIST}}

---

## Test Results

**Baseline Tests:**
- Status: {{BASELINE_STATUS}}
- Command: `{{TEST_CMD}}`

**Final Tests:**
- Status: {{FINAL_STATUS}}
- All tests passing: {{TESTS_PASSING}}

---

## Safety

- **Backup Branch:** {{BACKUP_BRANCH}}
- **Atomic Commits:** {{COMMIT_COUNT}}
- **Rollbacks:** {{ROLLBACK_COUNT}}

---

## Impact

{{IMPACT_SUMMARY}}

---

## Backup Information

The backup branch `{{BACKUP_BRANCH}}` has been created and contains the state before cleanup.

**Keep backup?**
- Yes: Branch preserved for safety
- No: Delete with `git branch -D {{BACKUP_BRANCH}}`
