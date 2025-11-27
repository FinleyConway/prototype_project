# Secure Coding Practices

This document provides practical coding standards for the development team.  
It focuses only on **how code should be written**, avoiding duplication with the main SECURITY.md policy.

_Last updated: November 2025_

---

## 1. Password & Authentication Code

- Always hash and salt passwords using the project’s authentication utility.
- Never compare plaintext passwords; always compare hashed values.
- Keep authentication logic in dedicated functions (not inside UI widgets).
- Avoid predictable values in OTP generation; use randomised values.

---

## 2. Input Validation in Code

- Apply validation functions to all text fields (email, username, password).
- Use the shared validators from `validators.dart` to maintain consistency.
- Reject empty, malformed, or weak inputs before hitting the database.
- Avoid passing unsafe values directly into queries.

---

## 3. Database & Query Safety

- Do not store unnecessary fields such as unused personal data.
- Use parameterised queries (e.g., `whereArgs`) to prevent injection.
- Keep database creation, inserts, and queries inside the data models.
- Never commit SQLite database files to the repository.

---

## 4. Code Structure & Separation

- Keep UI code separate from business logic (e.g., validation, hashing, DB operations).
- Place authentication logic inside `/utils/auth.dart`.
- Place database logic inside `/context/` or `/models/`.
- Avoid mixing backend logic in widget build methods.

---

## 5. Error Handling in Code

- Do not expose technical error details in SnackBars or on-screen messages.
- Use `try` / `catch` blocks around authentication and DB operations.
- Log internal errors during development but remove them for release builds.

---

## 6. Collaboration & Version Control

- Create feature branches for backend changes (e.g., `auth-fixes`, `otp-update`).
- Write clear commit messages explaining what was fixed or changed.
- Do not commit build files or database files (use `.gitignore`).
- Request review from a teammate before merging authentication-related changes.

---

## Summary

These secure coding standards support safer backend development and consistent practices across the project.  
They complement (but do not repeat) the broader guidelines in .github/SECURITY.md
