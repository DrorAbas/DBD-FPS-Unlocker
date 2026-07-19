# Contributing

Thanks for helping improve DBD FPS Unlocker.

## Before opening a pull request

- Open an issue for large changes.
- Keep changes focused.
- Do not add telemetry, advertising or background network requests.
- Do not add code injection, memory editing, anti-cheat interaction or game binary modification.
- Preserve backup and rollback behavior.
- Preserve the clear warning for experimental fixed-frame-rate mode.
- Test on Windows 10 or Windows 11.
- State which DBD platform/config folder was tested.

## Pull request checklist

- [ ] The application starts successfully.
- [ ] DBD was closed during apply/restore testing.
- [ ] A backup was created.
- [ ] Written values were verified.
- [ ] Restore Latest was tested.
- [ ] Read-only behavior was tested when changed.
- [ ] No unrelated files were modified.
- [ ] AI assistance was disclosed when materially used.

## Code style

- Prefer readable PowerShell over clever one-liners.
- Keep UI strings in the translation tables.
- Keep platform detection explicit and non-recursive.
- Never scan backup folders as live game configurations.
- Keep the application portable.

## Translations

Translations currently include English, Hebrew, Spanish, German and French.

Translation improvements should preserve meaning, especially warnings about:

- The 120 FPS limitation
- Fixed-frame-rate timing risks
- Read-only behavior
- The need to close DBD before changes
