# Game Rules and Ban-Risk Notes

This document expands the short risk section at the bottom of the main README.

## Bottom line

DBD FPS Unlocker is an unofficial configuration editor. It is not approved, endorsed or guaranteed safe by Behaviour Interactive or Easy Anti-Cheat.

There are many long-running community reports of players changing FPS-related INI values without penalties, but those reports are anecdotal. They cannot override the current EULA, game-ban rules or a future anti-cheat change.

## Official policy references

### Game Bans

Behaviour Interactive lists the use of third-party tools that create an unintended unfair advantage as bannable.

https://support.deadbydaylight.com/hc/en-us/articles/45521322753428-Game-Bans

### EULA

The EULA prohibits unauthorized modification of BHVR services and exploitation of undocumented behavior for competitive advantage.

https://deadbydaylight.com/eula/

### Public staff statements about configuration editing

In 2020, a BHVR Community Manager advised against altering files, stated that doing so could trigger an EAC ban and said BHVR might be unable to unban the user.

https://forums.bhvr.com/dead-by-daylight/discussion/181346/editing-config-files

In a 2018 forum response, a BHVR developer said users would not be actively hunted down for unlocking framerate and that nobody had been banned for it at that time, while still describing file editing as use at your own risk.

https://forums.bhvr.com/dead-by-daylight/discussion/36387/could-we-get-an-offical-respond-to-unlocking-fps

These statements are old and should not be treated as a permanent guarantee.

## Community reports

Examples of users reporting no issues include:

- Nearly two years of FPS-related INI editing:
  https://forums.bhvr.com/dead-by-daylight/discussion/128567/question-about-ini-files
- Years of uncapped FPS without problems:
  https://forums.bhvr.com/dead-by-daylight/discussion/172932/vsync-and-fps-cap
- Roughly 800 hours at 120 FPS:
  https://steamcommunity.com/app/381210/discussions/0/3800526843213219849/
- Additional long-term community discussion:
  https://forums.bhvr.com/dead-by-daylight/discussion/37041/how-do-i-unlock-my-fps

These are personal claims, not verified safety studies.

## Verified FPS-only bans

No credible public source was found during preparation that conclusively demonstrated a ban caused solely by the specific FPS and V-Sync INI changes made by this project.

It would be misleading to convert that lack of evidence into a claim of zero risk.

## Scope of this project

The program is designed to change only:

- FPS limit values
- The optional fixed-frame-rate setting
- In-game V-Sync
- The Windows Read-only attribute on the two configuration files

The project deliberately does not include visibility modifications, fog removal, save editing, progression manipulation, cosmetic unlocking, code injection, memory editing or game-binary modification.

Contributors must not expand the project into those areas.
