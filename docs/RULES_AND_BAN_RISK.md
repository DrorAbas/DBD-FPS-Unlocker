# Game Rules and Ban-Risk Notes

This document expands the risk section at the bottom of the main README.

## Bottom line

DBD FPS Unlocker is an unofficial configuration editor. It is not approved, endorsed or guaranteed safe by Behaviour Interactive or Easy Anti-Cheat.

Long-running community reports exist from players who changed FPS-related INI values without penalties. Those reports are anecdotal. They cannot override the current EULA, game-ban rules or a future anti-cheat change.

**Use the tool at your own risk. No maintainer, player report or old staff comment can guarantee that an account will never be restricted or banned.**

## Official policy references

### Dead by Daylight game-ban policy

Behaviour Interactive lists tools or methods that provide an unintended unfair advantage as bannable.

- [Dead by Daylight — Game Bans](https://support.deadbydaylight.com/hc/en-us/articles/45521322753428-Game-Bans)

### End User License Agreement

The EULA restricts unauthorized modification of BHVR services and exploitation of undocumented behavior for competitive advantage.

- [Dead by Daylight — End User License Agreement](https://deadbydaylight.com/eula/)

### Public staff statements about configuration editing

- [2020 BHVR Community Manager warning](https://forums.bhvr.com/dead-by-daylight/discussion/181346/editing-config-files): altering files was described as use at the player's own risk, potentially capable of triggering EAC, and not necessarily reversible by support.
- [2022 BHVR Community Manager warning](https://forums.bhvr.com/dead-by-daylight/discussion/314345/is-editing-the-player-settings-in-the-config-file-bannable): editing game files was again described as being at the user's own risk.
- [2018 BHVR developer response about unlocking FPS](https://forums.bhvr.com/dead-by-daylight/discussion/36387/could-we-get-an-offical-respond-to-unlocking-fps): the response said users would not be actively hunted for unlocking framerate and that nobody had been banned for it at that time, while still treating file editing as use at your own risk.

These statements are old and should not be interpreted as permanent approval or a guarantee about current or future anti-cheat behavior.

## Community reports

Examples of users reporting long-term use without a ban include:

- [Players reporting uncapped FPS use since at least 2017 without problems](https://forums.bhvr.com/dead-by-daylight/discussion/282770/is-uncapping-framerate-bannable)
- [Older discussion containing reports of more than one year and multiple years without a ban](https://forums.bhvr.com/dead-by-daylight/discussion/37041/how-do-i-unlock-my-fps)
- [A Steam user reporting roughly 800 hours at 120 FPS without issues](https://steamcommunity.com/app/381210/discussions/0/3800526843213219849/)
- [A community answer describing FPS uncapping as widely used](https://forums.bhvr.com/dead-by-daylight/discussion/258017/how-unlock-fps)

These are personal claims, not verified safety studies or official permission.

## Verified FPS-only bans

No credible public source was found during preparation that conclusively demonstrated a ban caused solely by the specific FPS, V-Sync and Read-only configuration changes made by this project.

That does **not** prove the risk is zero. Public ban claims may omit other software or modifications, evidence may be unavailable, and policies or anti-cheat detection can change.

## Scope of this project

The program is designed to change only:

- FPS limit values
- The optional fixed-frame-rate setting
- In-game V-Sync
- The Windows Read-only attribute on two configuration files

The project deliberately does not include:

- Visibility or fog removal
- Red-stain or brightness advantages
- Save editing
- Progression manipulation
- Cosmetic unlocking
- Code injection
- Memory editing
- Game-binary modification
- Anti-cheat bypassing

Contributors must not expand the project into those areas.

## Risk-reduction guidance

- Download only from the official repository.
- Inspect the included PowerShell source.
- Close Dead by Daylight before applying, restoring or unlocking files.
- Try **Standard — FPS limit only** first.
- Use the experimental fixed-frame-rate method only after understanding its timing risks.
- Never combine the tool with injectors, cheat tools, memory editors or modified game binaries.
- Keep the automatic backups.
- Restore immediately if movement, animation, physics or timing feels wrong.
- Re-check official rules after major DBD or anti-cheat updates.
- Stop using the tool if Behaviour Interactive explicitly prohibits FPS-related configuration edits.

## Technical risks unrelated to account bans

The experimental method enables Unreal Engine fixed-frame-rate timing. When the selected frame rate cannot be maintained, the game can exhibit slow motion, uneven animation, stutter, physics problems or incorrect timing.

The standard method is safer, but DBD may ignore values above 120 FPS. Successful file verification confirms only that the INI values were written; it does not confirm the actual in-game frame rate.
