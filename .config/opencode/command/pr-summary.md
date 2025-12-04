---
description: Create a name and description for a PR in Git.
agent: build
---

This is a PR for Jira ticket URL: $2. 
Here is the git diff between branch $1 and the current HEAD.
!`git diff $1...HEAD`
I am creating a PR from the current branch to branch $1. Look at the git diff and generate a PR title and description.
Provide only the PR title and description in your response. Do not include any other text.
It should be in the following format:
PR Title: <title>
PR Description: <description>

Start the PR title with the Jira ticket ID found in the URL if it exists. If it does not exist, just create a concise title summarizing the changes.
The description should summarize the changes made in the PR with bullet points.
