# How It Works

## Configuration discovery

The application checks only direct, known folders under:

```text
%LOCALAPPDATA%\DeadByDaylight\Saved\Config
```

Supported folder names:

- `WindowsClient`
- `EGS`
- `WinGDKClient`
- `WindowsNoEditor`
- `Windows`

The scan is intentionally non-recursive so backup folders cannot be mistaken for live configuration folders.

## Apply transaction

When Apply is pressed:

1. The tool verifies DBD is closed.
2. It creates a timestamped backup.
3. It temporarily removes Read-only from the target files.
4. It updates `GameUserSettings.ini`.
5. It removes only blocks created by this tool or its earlier private versions from `Engine.ini`.
6. It appends one clean configuration block.
7. It writes through temporary files.
8. It reads the files again and verifies required values.
9. It restores Read-only when requested.
10. If any step fails, it attempts an automatic rollback.

## Standard method

The standard method writes:

```ini
FrameRateLimit=<target>
FPSLimit=<target>
FPSLimitMode=0
```

and an Engine.ini block containing:

```ini
[SystemSettings]
t.MaxFPS=<target>
```

## Experimental method

The experimental method also writes:

```ini
[/Script/Engine.Engine]
bSmoothFrameRate=False
bUseFixedFrameRate=True
FixedFrameRate=<target>
```

This can alter how Unreal Engine calculates time and should not be treated as a normal frame limiter.

## V-Sync

The default choice is **Keep current setting**. In that mode, the tool does not modify `bUseVSync`.

## Read-only

When selected, Windows marks both target files as Read-only after a successful apply. This can reduce silent resets, but changes made in the DBD settings menu may not save.
