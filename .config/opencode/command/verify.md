---
description: Build project and run tests to verify implementation
subtask: true
---

Your role: **Build and Test** - Verify the implementation works

## Verification Process

1. **Clean Build:**
   - Run: `./gradlew clean`
   - Ensure clean state before testing

2. **Compile Check:**
   - Run: `./gradlew compileDebugKotlin`
   - Verify no compilation errors
   - If errors found, report them clearly with file and line numbers

3. **Run Tests:**
   - Run: `./gradlew test`
   - Capture full output
   - Note pass/fail counts

4. **Analyze Results:**
   
   **If tests pass:**
   - Report total test count
   - Confirm all tests green
   - Note any warnings from build output
   
   **If tests fail:**
   - List each failing test with:
     * Test class and method name
     * Failure reason/assertion message
     * Relevant stack trace lines
   - Analyze the failures:
     * Are they related to recent changes?
     * What's the root cause?
     * Is it a test issue or implementation issue?

5. **Attempt One Fix (if needed):**
   If tests fail and the issue is clear:
   - Make ONE targeted fix attempt
   - Re-run tests: `./gradlew test`
   - Report results of retry
   
   If issue is unclear or fix doesn't work:
   - DO NOT keep trying
   - Report the problem clearly for orchestrator to handle

6. **Check Code Quality (Basic):**
   - Run lint if available: `./gradlew lint` (optional)
   - Note any critical warnings

7. **Report Back:**
   Provide clear summary:
   - ? Build status: Success/Failed
   - ? Test results: X passed, Y failed
   - ? Any failures with details
   - ? Any build warnings
   - ? Fix attempts made (if any)
   - ? Current status: Ready for review / Needs fixes

## What NOT to Do:
- ? Do NOT modify implementation beyond one targeted test fix
- ? Do NOT review architecture (that's @reviewer's job)
- ? Do NOT commit changes
- ? Do NOT run multiple fix attempts - report issues instead

## Build Troubleshooting:

**If compilation fails:**
- Report exact error message
- Identify file and line number
- Don't guess at fixes - report to orchestrator

**If tests timeout:**
- Note which tests timed out
- Check if it's a known flaky test
- Report for orchestrator decision

**If Gradle daemon issues:**
- Try: `./gradlew --stop` then retry
- Report if issues persist

Remember: Your job is verification and one fix attempt max. Complex issues go back to the orchestrator.
```

## Updated Directory Structure
```
.opencode/
ÃÄÄ agent/
³   ÀÄÄ reviewer.md         (only reviewer needed now)
ÃÄÄ command/
³   ÃÄÄ save-plan.md        (saves the plan)
³   ÃÄÄ execute-plan.md     (orchestrator)
³   ÃÄÄ implement.md        (implementation only)
³   ÀÄÄ verify.md           (build & test only)
ÀÄÄ plans/
    ÀÄÄ (your plan files)

AGENTS.md
