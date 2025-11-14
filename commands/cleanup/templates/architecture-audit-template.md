# Architecture Audit Report

**Generated:** {{TIMESTAMP}}
**Repository:** {{REPO_ROOT}}
**Branch:** {{CURRENT_BRANCH}}

---

## Summary

- **Total Issues:** {{TOTAL_ISSUES}}
- **God Objects:** {{GOD_COUNT}}
- **Circular Dependencies:** {{CIRCULAR_COUNT}}
- **High Complexity Functions:** {{COMPLEX_COUNT}}
- **Long Parameter Lists:** {{LONG_PARAM_COUNT}}
- **Mixed Concerns:** {{MIXED_COUNT}}

---

## God Objects ({{GOD_COUNT}} found)

Files exceeding 300 lines or with mixed responsibilities:

{{GOD_OBJECTS_LIST}}

---

## Circular Dependencies ({{CIRCULAR_COUNT}} found)

{{CIRCULAR_DEPS_LIST}}

---

## High Complexity Functions ({{COMPLEX_COUNT}} found)

Functions exceeding cyclomatic complexity threshold:

{{COMPLEXITY_LIST}}

---

## Long Parameter Lists ({{LONG_PARAM_COUNT}} found)

Functions with 5+ parameters:

{{LONG_PARAMS_LIST}}

---

## Mixed Concerns ({{MIXED_COUNT}} found)

Files mixing multiple architectural layers:

{{MIXED_CONCERNS_LIST}}

---

## Recommendations

{{RECOMMENDATIONS}}

---

## Next Steps

{{NEXT_STEPS}}
