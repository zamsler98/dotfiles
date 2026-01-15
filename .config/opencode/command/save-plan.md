---
description: Save the current plan to a file for later use.
agent: build
---

Write the current plan as a clear, detailed, and actionable Markdown file. Break the plan into specific tasks that could be directly given to another AI to implement in code. Each task should be concise, self-contained, and easy to follow.
Structure the file with headings or bullet points to organize the tasks logically. Include any dependencies or order of execution if relevant.
Save the file in the .plans directory of the repository. Name the file descriptively and include a timestamp in the filename using the format YYYYMMDD_HHMMSS (e.g., project_launch_plan_20260115_094208.md).
If the .plans directory does not exist, create it before saving the file.
After saving, return only the file name, not the path or file contents.
