# DBD FPS Unlocker

> **Dead by Daylight FPS configuration and experimental uncapping tool for Windows.**

[![Platform](https://img.shields.io/badge/platform-Windows%2010%20%7C%2011-2f81f7)](#requirements)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![AI-assisted](https://img.shields.io/badge/created%20with-AI%20assistance-c21f35)](AI_DISCLOSURE.md)
[![Unofficial](https://img.shields.io/badge/status-unofficial-lightgrey)](#unofficial-project)

DBD FPS Unlocker is a portable, open-source GUI for reading, backing up and changing the local FPS-related configuration files used by **Dead by Daylight**.

It supports a normal FPS limit method and a clearly labeled experimental fixed-frame-rate method. The application does not modify game binaries, inject code, bypass anti-cheat or connect to the internet.

> [!IMPORTANT]
> Dead by Daylight may still enforce its own 120 FPS limit. A value written successfully to an INI file does **not** guarantee that the game will render above 120 FPS.

## Created with AI assistance

**This project was created with substantial assistance from AI, including OpenAI's ChatGPT.**

The project owner directed the design, requirements, testing and iteration. AI was used to help generate and revise code, interface text and documentation. The complete disclosure is available in [AI_DISCLOSURE.md](AI_DISCLOSURE.md).

AI-generated code can contain mistakes. Review the source, keep backups and report any issue you find.

## Features

- FPS selector from **30 to 360**
- Presets for 120, 144, 165, 240 and 360 FPS
- Standard FPS limit mode
- Experimental fixed-frame-rate mode
- Automatic detection for common Steam, Epic Games and Microsoft Store config folders
- Backup before every change
- Automatic verification after writing
- Automatic rollback when verification fails
- Restore latest backup
- Optional Read-only protection
- V-Sync: keep current, off or on
- Delayed help tooltips for every important option
- English, Hebrew, Spanish, German and French
- Full right-to-left layout in Hebrew
- No installation
- No administrator rights required
- No network access

## Download and run

1. Download the latest release ZIP from the repository's **Releases** page.
2. Extract the entire ZIP to a normal folder.
3. Close Dead by Daylight completely.
4. Double-click:

```text
Start_DBD_FPS_Unlocker.cmd
```

Keep all extracted files together.

### PowerShell security notice

The visible CMD launcher starts Windows PowerShell with a **process-only** execution-policy bypass:

```text
-ExecutionPolicy Bypass
```

This does not permanently change the Windows execution policy. It applies only to that one PowerShell process and ends when the application closes.

The source is included so users can inspect exactly what runs.

## Recommended setup

For a 165 Hz monitor:

1. Select **165 FPS**.
2. Start with **Standard — FPS limit only**.
3. Leave Read-only disabled on the first attempt.
4. Leave V-Sync unchanged when unsure.
5. Apply, launch DBD and verify the FPS inside a real match.
6. If DBD remains at 120 FPS, close it and test the experimental method.
7. Restore the latest backup immediately if movement, timing or animations feel wrong.

## Standard vs experimental

### Standard — FPS limit only

Writes ordinary configuration values such as:

```ini
FrameRateLimit=165.000000
t.MaxFPS=165
```

This is the safer method. It sets a ceiling and does not intentionally alter engine timing. DBD may still ignore values above 120.

### Experimental — changes engine timing

Additionally writes:

```ini
bUseFixedFrameRate=True
FixedFrameRate=165.000000
```

This is not the same as a normal FPS cap. Unreal Engine may use the selected rate in timing calculations. If the system cannot maintain it, the game can feel slow, uneven or incorrectly timed.

## What the tool changes

Only these local files are edited when present:

```text
%LOCALAPPDATA%\DeadByDaylight\Saved\Config\<platform>\GameUserSettings.ini
%LOCALAPPDATA%\DeadByDaylight\Saved\Config\<platform>\Engine.ini
```

Backups are stored under:

```text
%LOCALAPPDATA%\DBD FPS Unlocker\Backups
```

## Requirements

- Windows 10 or Windows 11
- Windows PowerShell 5.1
- Dead by Daylight launched at least once
- The game must be closed before applying, restoring or unlocking files

## Security and privacy

- No telemetry
- No analytics
- No advertisements
- No internet requests
- No executable injection
- No game binary modification
- No anti-cheat interaction
- No administrator privileges

See [SECURITY.md](SECURITY.md) for reporting security concerns and [docs/RULES_AND_BAN_RISK.md](docs/RULES_AND_BAN_RISK.md) for the expanded rules and ban-risk review.

## Unofficial project

This is an unofficial fan-made utility. It is not affiliated with, endorsed by or sponsored by Behaviour Interactive.

**Dead by Daylight** and related names and trademarks belong to their respective owners. No official game assets are included.

## Known limitations

- Current DBD versions may remain capped at 120 FPS.
- The experimental method may affect timing.
- PowerShell scripts can trigger warnings from aggressive antivirus products.
- The project is not code-signed.
- The GUI has been statically validated, but hardware and Windows policies vary.

## Troubleshooting

See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

For technical details, see [docs/HOW_IT_WORKS.md](docs/HOW_IT_WORKS.md).

## Contributing

Bug reports, translations and carefully tested improvements are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) first.

---

## Rules, ban risk and community reports

> [!CAUTION]
> **Use this tool at your own risk.** Neither this repository nor community reports can guarantee that an account will not be restricted or banned. Anti-cheat behavior, the game's files and Behaviour Interactive's policies can change at any time.

### What the official rules say

Behaviour Interactive's current public ban policy includes bans for tools or methods that provide an unintended unfair advantage. Its EULA also prohibits unauthorized modification of the service and exploiting undocumented behavior for a competitive advantage.

This tool is intentionally limited to local FPS, V-Sync and Read-only configuration. It does **not** remove fog, alter visibility, brighten the red stain, edit progression, unlock cosmetics, modify saves, inject code or bypass anti-cheat.

That limitation does not make its use officially approved.

Official sources:

- [Dead by Daylight — Game Bans](https://support.deadbydaylight.com/hc/en-us/articles/45521322753428-Game-Bans)
- [Dead by Daylight — End User License Agreement](https://deadbydaylight.com/eula/)
- [BHVR Community Manager warning: altering files is done at your own risk and may trigger EAC](https://forums.bhvr.com/dead-by-daylight/discussion/181346/editing-config-files)
- [BHVR developer response: they would not actively hunt users for unlocking FPS, but file editing remained at the user's risk](https://forums.bhvr.com/dead-by-daylight/discussion/36387/could-we-get-an-offical-respond-to-unlocking-fps)

### What players have reported

The following links are **community anecdotes**, not official permission and not proof of future safety:

- [A player reported using an FPS change for almost two years without a ban](https://forums.bhvr.com/dead-by-daylight/discussion/128567/question-about-ini-files)
- [A player reported using an uncapped configuration for years without problems](https://forums.bhvr.com/dead-by-daylight/discussion/172932/vsync-and-fps-cap)
- [A 2023 Steam discussion includes a player reporting roughly 800 hours at 120 FPS without issues](https://steamcommunity.com/app/381210/discussions/0/3800526843213219849/)
- [Older community discussion with users reporting long-term FPS unlocking without a ban](https://forums.bhvr.com/dead-by-daylight/discussion/37041/how-do-i-unlock-my-fps)

### Were people verified as banned only for this FPS change?

During preparation of this README, no credible public case was found that clearly proves an account was banned **solely** for changing the FPS-related INI values used by this tool.

That is not proof that the risk is zero. Ban discussions often lack evidence, may be removed or closed, and account owners may have had unrelated software or modifications running. BHVR has also stated that if an anti-cheat ban is triggered by altered files, support may be unable to reverse it.

### Risk-reduction guidance

- Download only from this repository.
- Review the PowerShell source before running it.
- Close Dead by Daylight before applying or restoring settings.
- Use **Standard — FPS limit only** first.
- Treat **Experimental — changes engine timing** as higher risk to game stability.
- Do not use the tool to remove fog, improve visibility or create any gameplay advantage.
- Do not combine it with injectors, cheat tools, memory editors or modified game binaries.
- Keep the automatically created backups.
- Restore immediately if timing, movement, animations or physics feel wrong.
- Re-check the official rules after major DBD or anti-cheat updates.
- Stop using the tool if Behaviour Interactive explicitly prohibits FPS-related configuration edits.

### Technical risks unrelated to bans

The experimental method can affect Unreal Engine timing. If the chosen frame rate cannot be maintained, the game may exhibit slow motion, uneven animation, stutter, physics problems or incorrect timing. Even the standard method may be ignored by DBD and remain capped at 120 FPS.

## License

Released under the [MIT License](LICENSE).
