---
description: Implement code changes according to the plan (no building/testing)
subtask: true
---

Read the plan file at: .opencode/plans/$ARGUMENTS-plan.md

Your role: **Implementation Only** - Do NOT build or test

## Implementation Process

1. **Understand the Plan:**
   - Read the entire plan carefully
   - Note the implementation steps and their order
   - Identify file paths and specific changes needed
   - Check dependencies between steps

2. **Follow Our Architecture:**
   - CCPTasksStore is single source of truth for state
   - ViewModels observe stores, never hold state directly
   - Use extension functions for domain logic
   - Follow Jetpack Compose best practices
   - Use coroutines for async operations

3. **Implement Phase by Phase:**
   - Work through phases in order (Phase 1, 2, 3...)
   - Complete all steps in a phase before moving to next
   - Follow the exact file paths specified in the plan
   - Make changes exactly as described in each step's "Action"
   - Stay faithful to existing code patterns in the project

4. **Handle Each Step:**
   For each implementation step:
   - State which step you're working on
   - Make the specific changes described
   - Keep changes minimal and focused
   - Preserve existing functionality
   - Follow the "Why" to understand intent

5. **Code Quality:**
   - Use exact file paths from the plan
   - Follow Kotlin conventions
   - Add proper error handling
   - Use meaningful variable/function names
   - Keep functions focused and small (<50 lines)
   - Avoid deep nesting (max 4 levels)

6. **Report Back:**
   When implementation is complete, report:
   - All files created/modified (with paths)
   - Which phases were completed
   - Implementation approach taken
   - Any deviations from plan (with reasons)
   - Any blockers or issues encountered
   - What still needs to be done (if anything)

## What NOT to Do:
- ? Do NOT run tests (that's /verify's job)
- ? Do NOT run gradle build (that's /verify's job)
- ? Do NOT review code quality (that's @reviewer's job)
- ? Do NOT commit changes (orchestrator does that)
- ? Do NOT stray from the plan without good reason

## Edge Cases to Consider:
- Null safety
- Empty lists/collections
- Configuration changes (Android lifecycle)
- Process death and state restoration
- Concurrent operations

Remember: Your job is pure implementation. Build, test, and review are handled by other commands/agents.
