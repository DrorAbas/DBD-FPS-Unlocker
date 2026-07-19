# Security Policy

## Supported version

Only the newest published release is supported.

## Reporting a vulnerability

Do not include sensitive information in a public issue.

Send a private message to the repository owner through an available GitHub contact method and include:

- A clear description of the issue
- The affected version
- Reproduction steps
- Potential impact
- Suggested mitigation, when available

Please allow reasonable time for investigation before public disclosure.

## Security model

DBD FPS Unlocker:

- Reads and writes local INI configuration files
- Creates local backups
- Does not require administrator privileges
- Does not connect to the internet
- Does not inject into the game
- Does not modify game executables
- Does not interact with Easy Anti-Cheat

The launcher uses a process-scoped PowerShell execution-policy bypass because some Windows systems block unsigned local scripts. It does not run `Set-ExecutionPolicy` and does not persistently change system policy.

## Antivirus detections

Unsigned PowerShell utilities that edit configuration files may be flagged heuristically. A detection should be investigated rather than automatically ignored.

Users can inspect every source file in the repository before running it.
