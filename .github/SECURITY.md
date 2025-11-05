# Security Policy

## Overview
This Flutter project is a **prototype app for care providers** only.  
It is still under development and does not collect or use any real patient data.

## Security Guidelines
- Keep all project files private unless approved for sharing.
- Do not hardcode or upload any API keys, passwords, or credentials to GitHub.
- Avoid storing personal or sensitive data in the app or database.
- Use **HTTPS** for any test or API communication.
- Regularly update dependencies using:
  ```bash
  flutter pub upgrade
  ```
  
Review permissions before adding new ones (e.g., camera, location, etc.).

## Developer Practices

- Always test locally before pushing code to the main branch.

- Write clear commit messages and avoid committing unnecessary files.

- Use .gitignore to keep build files, credentials, and environment files out of Git.

- Report any unexpected security or privacy issues to the team lead as soon as possible.

## Reporting Issues

- If you notice a security issue or bug:

- Do not post it publicly.

- Inform the project lead or send a message in the team group chat.

- Provide a short summary and steps to reproduce the issue.

Last updated: November 2025
