---
description: Save the current implementation plan to a markdown file
---

Save the implementation plan we just created to `.opencode/plans/$ARGUMENTS-plan.md`

Use this exact format:
```markdown
# Implementation Plan: [Feature Name]

## Overview
[2-3 sentence summary of what this feature does and why it's needed]

## Requirements
- [Functional requirement 1]
- [Functional requirement 2]
- [Non-functional requirement (performance, accessibility, etc.)]

## Architecture Changes
- [Component/file affected: path/to/file.kt - description of changes]
- [State management: CCPTasksStore changes needed]
- [UI components: Compose files to create/modify]

## Implementation Steps

### Phase 1: [Foundation/Data Layer/etc.]
1. **[Step Name]** (File: path/to/file.kt)
   - Action: Specific action to take (e.g., "Add sortOrder property to TasksState")
   - Why: Reason for this step (e.g., "Store current sort preference for UI state restoration")
   - Dependencies: None / Requires step X
   - Risk: Low/Medium/High

2. **[Next Step Name]** (File: path/to/another/file.kt)
   - Action: [Specific action]
   - Why: [Reason]
   - Dependencies: [None/Other steps]
   - Risk: [Assessment]

### Phase 2: [Business Logic/ViewModels/etc.]
1. **[Step Name]** (File: path/to/viewmodel.kt)
   - Action: [Specific action]
   - Why: [Reason]
   - Dependencies: [Phase 1 completion]
   - Risk: [Assessment]

### Phase 3: [UI Layer/Testing/etc.]
1. **[Step Name]** (File: path/to/compose/screen.kt)
   - Action: [Specific action]
   - Why: [Reason]
   - Dependencies: [Previous phases]
   - Risk: [Assessment]

## Testing Strategy
- Unit tests: [Specific test files and what they cover]
  - `TasksStoreTest.kt` - Sort logic edge cases
  - `TaskViewModelTest.kt` - State transitions
- Integration tests: [Flows to test]
  - Sort state persistence across configuration changes
  - Empty list behavior
- UI tests (if applicable): [User journeys to test]
  - Toggle sort, verify visual feedback

## Risks & Mitigations
- **Risk**: [Specific risk, e.g., "Sorting large task lists may cause UI lag"]
  - Mitigation: [How to address, e.g., "Implement sorting in background coroutine"]
- **Risk**: [Another risk]
  - Mitigation: [Solution]

## Success Criteria
- [ ] Users can toggle sort by priority
- [ ] Sort state persists across app restarts
- [ ] 300ms fade animation when sort changes
- [ ] All tests pass
- [ ] No performance regression on lists of 1000+ tasks
```

## Planning Guidelines to Follow:

**Requirements Analysis:**
- Understand the feature completely
- Ask clarifying questions if anything is unclear
- Identify success criteria
- List assumptions and constraints

**Architecture Review:**
- Analyze existing codebase structure (reference AGENTS.md patterns)
- Identify affected components (ViewModels, Store, Composables)
- Review similar implementations in the project
- Consider reusable patterns (like our CCPTasksStore pattern)

**Step Breakdown - Each step must have:**
- Clear, specific actions with exact code changes
- File paths (use actual project structure)
- Dependencies between steps
- Estimated complexity/risk
- Potential edge cases

**Implementation Order:**
- Prioritize by dependencies (data layer  business logic  UI)
- Group related changes in phases
- Minimize context switching
- Enable incremental testing after each phase

**Best Practices:**
1. **Be Specific**: Use exact file paths, class names, function names
   - ? "Add `sortByPriority()` extension function to CCPTasksStore"
   - ? "Add sorting functionality"

2. **Consider Edge Cases**: 
   - Empty lists
   - Null values
   - Configuration changes
   - Process death/restoration

3. **Minimize Changes**: Prefer extending over rewriting
   - Follow existing patterns in the codebase
   - Don't introduce new architectural patterns without good reason

4. **Maintain Patterns**: Follow project conventions from AGENTS.md
   - CCPTasksStore for state management
   - Extension functions for domain logic
   - Jetpack Compose best practices

5. **Enable Testing**: Structure changes to be easily testable
   - Pure functions where possible
   - Separate business logic from UI
   - Mock-friendly architecture

6. **Think Incrementally**: Each phase should be verifiable
   - Phase 1 should compile and pass existing tests
   - Phase 2 should add new tests and functionality
   - Phase 3 should integrate everything

7. **Document Decisions**: Explain WHY, not just WHAT
   - "Use extension function to keep sorting logic with domain model"
   - Not just "Create extension function"

**Red Flags to Check in Existing Code:**
- Large functions (>50 lines) - suggest refactoring in plan
- Deep nesting (>4 levels) - flatten if touching this code
- Duplicated code - consolidate if adding similar functionality
- Missing error handling - add it in your implementation
- Hardcoded values - use constants or configuration
- Missing tests - prioritize adding them
- Performance bottlenecks - address if evident

**For Refactors:**
1. Identify specific code smells
2. List concrete improvements needed
3. Preserve existing functionality (add tests first if missing)
4. Create backwards-compatible changes when possible
5. Plan for gradual migration if it's a large change

**Remember:** A great plan is specific, actionable, and considers both the happy path and edge cases. The best plans enable confident, incremental implementation.
