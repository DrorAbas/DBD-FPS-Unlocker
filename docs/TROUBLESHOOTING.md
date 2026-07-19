# Troubleshooting

## The GUI does not open

Run:

```text
DBD_FPS_Unlocker_Diagnostic.cmd
```

Copy the full error into a bug report.

## PowerShell says the script is not digitally signed

Use the included visible launcher:

```text
Start_DBD_FPS_Unlocker.cmd
```

It uses a process-only execution-policy bypass and does not change the permanent Windows policy.

## Antivirus reports the tool

Do not blindly ignore the warning.

- Confirm the files came from the official repository.
- Review `DBD_FPS_Unlocker.ps1`.
- Submit the file to your antivirus vendor when you believe the detection is false.
- Do not run modified copies from unknown upload sites.

The project is not code-signed.

## The tool says the settings were applied, but DBD stays at 120 FPS

This is a known limitation. DBD may enforce its own cap regardless of the INI values.

Verify FPS during a real match. A successful file verification proves only that the settings were written.

## The game feels slow or strange

1. Close DBD.
2. Open the tool.
3. Click **Restore latest**.
4. Use the standard method afterward.

This symptom can occur with experimental fixed-frame-rate mode when the selected rate is not maintained.

## DBD settings no longer save

The INI files may be Read-only.

Close DBD and click **Unlock files**.

## No configuration is detected

Launch DBD once, close it completely and press Refresh.

Confirm that this folder exists:

```text
%LOCALAPPDATA%\DeadByDaylight\Saved\Config
```

## Which FPS should I choose?

Start with the refresh rate of the monitor:

- 120 Hz → 120 FPS
- 144 Hz → 144 FPS
- 165 Hz → 165 FPS
- 240 Hz → 240 FPS

Higher values can increase GPU load and may provide little benefit beyond the display refresh rate.
