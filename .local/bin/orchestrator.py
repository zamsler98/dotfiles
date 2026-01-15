#!/usr/bin/env python3
import sys
import os
import subprocess

MAX_RETRIES = 3

def run_command(cmd, input_text=None):
    """
    Runs a shell command.
    Returns (success_flag, output). success_flag=True if command succeeded.
    """
    try:
        result = subprocess.run(
            cmd,
            input=input_text,
            text=True,
            check=True,
            capture_output=True
        )
        return True, result.stdout
    except subprocess.CalledProcessError as e:
        return False, (e.stdout or "") + "\n" + (e.stderr or "")

def run_build_and_test():
    """
    Runs 'cargo build' and 'cargo test'.
    Returns (success_flag, output) where output is from failing command if any.
    """
    print("Running cargo build...")
    success, output = run_command(["cargo", "build"])
    if not success:
        print("Build failed!")
        return False, output

    print("Running cargo test...")
    success, output = run_command(["cargo", "test"])
    if not success:
        print("Tests failed!")
        return False, output

    print("Build and tests succeeded.")
    return True, ""

def report_issue(output):
    """
    Sends the failing output to OpenCode issue-reporter agent.
    Returns the output from issue-reporter (assumes it returns text).
    """
    print("Reporting issue via OpenCode issue-reporter...")
    success, reporter_output = run_command(
        ["opencode", "run", "--agent", "issue-reporter"],
        input_text=output
    )
    if not success:
        print("Failed to report issue!")
    return reporter_output

def fix_errors(session_id, issues):
    """
    Pass the issues to the code-writing agent to fix using session ID.
    Returns the output from the code agent.
    """
    print(f"Passing issues back to code-writing agent (session {session_id})...")
    success, output = run_command(
        ["opencode", "run", "-s", session_id, "--command", "fix-errors"],
        input_text=issues
    )
    if not success:
        print("Code-writing agent failed!")
    return output

def get_session_id(title):
    """
    Returns the Session ID for a given title.
    """
    success, result = run_command(["opencode", "session", "list", "-n", "10"])
    if not success:
        print("Failed to list OpenCode sessions!")
        return None

    for line in result.splitlines():
        if "Session ID" in line or not line.strip():
            continue
        parts = line.split(maxsplit=2)
        if len(parts) >= 2 and parts[1] == title:
            return parts[0]
    return None

def commit_changes(plan_file):
    """
    Stages all changes and generates a commit message using OpenCode.
    Then commits using git.
    """
    # Stage all changes
    print("Staging all changes...")
    success, output = run_command(["git", "add", "-A"])
    if not success:
        print(f"Failed to stage changes:\n{output}")
        return False

    # Read the plan file
    with open(plan_file, "r", encoding="utf-8") as f:
        plan_contents = f.read()

    # Generate commit message
    print("Generating commit message via OpenCode...")
    success, commit_msg = run_command(
        ["opencode", "run", "--command", "git-commit-msg"],
        input_text=plan_contents
    )
    if not success or not commit_msg.strip():
        print(f"Failed to generate commit message, output:\n{commit_msg}")
        return False

    commit_msg = commit_msg.strip()
    print(f"Commit message generated:\n{commit_msg}")

    # Commit
    print("Committing changes...")
    success, output = run_command(["git", "commit", "-m", commit_msg])
    if not success:
        print(f"Git commit failed:\n{output}")
        return False

    print("Changes committed successfully.")
    return True

def main():
    if len(sys.argv) != 2:
        print("Usage: python orchestrator.py <plan.md>")
        sys.exit(1)

    plan_file = sys.argv[1]
    if not os.path.isfile(plan_file):
        print(f"Error: File '{plan_file}' does not exist.")
        sys.exit(1)

    plan_name = os.path.splitext(os.path.basename(plan_file))[0]

    print(f"Running OpenCode agent with plan '{plan_file}' and title '{plan_name}'...")
    success, _ = run_command([
        "opencode", "run",
        "--command", "implement-plan",
        plan_file,
        "--title", plan_name
    ])
    if not success:
        print("Initial code agent run failed!")
        sys.exit(1)

    session_id = get_session_id(plan_name)
    if not session_id:
        print(f"No session found for plan '{plan_name}'.")
        sys.exit(1)

    # --- Main build/test/fix loop ---
    for attempt in range(1, MAX_RETRIES + 1):
        print(f"\n--- Attempt {attempt} ---")
        success, output = run_build_and_test()
        if success:
            print("Build and tests succeeded! Proceeding to commit...")
            if not commit_changes(plan_file):
                print("Failed to commit changes.")
                sys.exit(1)
            sys.exit(0)

        # Build/tests failed, report issue
        issue_report = report_issue(output)
        if not issue_report.strip():
            issue_report = output  # fallback if reporter returns nothing

        # Pass issues back to code-writing agent to fix
        fix_output = fix_errors(session_id, issue_report)
        print(f"Code agent applied fixes:\n{fix_output}")

    print(f"Failed after {MAX_RETRIES} attempts. Please fix manually.")
    sys.exit(1)

if __name__ == "__main__":
    main()
