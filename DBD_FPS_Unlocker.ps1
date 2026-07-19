# DBD FPS Unlocker v1.0.0
# Portable WPF utility for Windows 10/11. No installation or administrator rights required.

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$script:Version = "1.0.0"
$script:Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$script:ConfigRoot = Join-Path $env:LOCALAPPDATA "DeadByDaylight\Saved\Config"
$script:AppRoot = Join-Path $env:LOCALAPPDATA "DBD FPS Unlocker"
$script:BackupRoot = Join-Path $script:AppRoot "Backups"
$script:SettingsFile = Join-Path $script:AppRoot "settings.json"
$script:LegacyAppRoot = Join-Path $env:LOCALAPPDATA "DBD FPS Tool"
$script:LegacyBackupRoot = Join-Path $script:LegacyAppRoot "Backups"
$script:LegacySettingsFile = Join-Path $script:LegacyAppRoot "settings.json"
$script:Initializing = $true
$script:Busy = $false
$script:Configs = @()
$script:CurrentLanguage = "en"

$script:Translations = @{
    en = @{
        title = "DBD FPS Unlocker"
        subtitle = "Focused, safe FPS configuration for Dead by Daylight"
        language = "Language"
        config = "Game installation"
        statusChecking = "Checking configuration..."
        statusFound = "Configuration detected"
        statusMissing = "DBD configuration not found"
        gameClosed = "Dead by Daylight is closed — ready to edit"
        gameRunning = "Dead by Daylight is running — close it before applying changes"
        target = "Target FPS"
        detected = "Detected configuration"
        waiting = "Waiting..."
        actualNote = "This verifies the configuration files, not the actual FPS displayed by the game."
        method = "FPS method"
        safeTitle = "Standard — FPS limit only"
        safeDesc = "Sets a normal FPS ceiling. It does not change game timing or force DBD to reach the selected value."
        fixedTitle = "Experimental — changes engine timing"
        fixedDesc = "Forces Unreal Engine to calculate time around the selected rate. This can cause slow motion if that rate is not maintained."
        options = "Options"
        vsync = "In-game V-Sync"
        keep = "Keep current setting"
        off = "Off"
        on = "On"
        lock = "Use Read-only only if DBD resets the value"
        lockDesc = "Read-only is not dangerous, but settings changed inside DBD may not save."
        warningNormal = "Up to 120 FPS uses the normal configuration method."
        warningHighSafe = "Above 120 FPS is experimental. Standard mode is safer, but DBD may still stay at 120 FPS."
        warningFixed = "Fixed Frame Rate is experimental and can cause slow-motion behavior if the PC cannot maintain the selected FPS."
        apply = "Apply FPS settings"
        refresh = "Refresh"
        restore = "Restore latest"
        unlock = "Unlock files"
        openConfig = "Open config"
        openBackups = "Open backups"
        log = "Activity log"
        footer = "Portable • No installation • No administrator rights • Windows 10/11"
        noConfig = "No supported Dead by Daylight configuration was found.`n`nOpen the game once, close it, and reopen this tool."
        closeGame = "Dead by Daylight is currently running.`n`nClose the game completely and try again."
        invalidFps = "Enter a whole FPS value between 30 and 360."
        confirmHigh = "The selected value is above 120 FPS. Dead by Daylight may ignore it and remain capped at 120.`n`nApply anyway?"
        confirmFixed = "Experimental Fixed Frame Rate can affect game timing or cause slow-motion behavior when the selected FPS is not maintained.`n`nApply anyway?"
        success = "Settings were applied successfully."
        applyFailed = "The change failed. The previous files were restored automatically."
        restoreConfirm = "Restore the latest backup for the selected configuration?"
        restoreSuccess = "The latest backup was restored successfully."
        noBackup = "No backup created by DBD FPS Unlocker was found for this configuration."
        unlockSuccess = "The configuration files are now unlocked. Settings changed inside DBD can be saved again."
        filesMissing = "The selected configuration files no longer exist. Press Refresh."
        info = "Information"
        warning = "Warning"
        error = "Error"
        platformSteam = "Steam"
        platformEpic = "Epic Games"
        platformMicrosoft = "Microsoft Store"
        platformLegacy = "Legacy"
        configLine = "Game: {0} FPS  |  Engine: {1} FPS  |  Method: {2}  |  V-Sync: {3}  |  Read-only: {4}"
        methodStandard = "Standard"
        methodFixed = "Fixed"
        methodUnknown = "Unknown"
        valueMissing = "not set"
        yes = "Yes"
        no = "No"
        keepLog = "Kept the current V-Sync setting."
        backupCreated = "Backup created: {0}"
        updated = "Updated: {0}"
        restored = "Restored from: {0}"
        rollback = "Automatic rollback completed."
        liveConfig = "Selected configuration: {0}"
        gameStateClosed = "Game process: closed"
        gameStateRunning = "Game process: running"
        readOnlyOn = "Read-only enabled."
        readOnlyOff = "Read-only disabled."

        helpLabel = "HOVER HELP"
        helpDefaultTitle = "Recommended setup path"
        helpDefaultText = "Choose an FPS that matches your monitor refresh rate. Start with the standard method, apply the change and check the real FPS inside an actual match. If DBD still stays at 120 FPS, close the game and try the experimental method."
        helpDefaultRec = "For a 165 Hz monitor: choose 165 FPS. Use Read-only only if DBD resets the value. If the experimental method causes slow motion or strange movement, restore the latest backup."
        helpFpsTitle = "Target FPS — what number should I use?"
        helpFpsText = "This is the FPS value written to the configuration. A good starting point is the refresh rate of the monitor, such as 165 for a 165 Hz display. Setting 240 or 360 on a 165 Hz monitor normally adds load without giving you 240 or 360 visible refreshes."
        helpFpsRec = "Set the target to your monitor refresh rate first. Do not jump to 240 or 360 just because the computer can render it."
        helpSafeTitle = "Standard method — a normal ceiling"
        helpSafeText = "This writes ordinary FPS-limit values such as FrameRateLimit and t.MaxFPS. It only tells the engine not to exceed the selected number. It does not change the speed of time, animations or gameplay. DBD may still enforce its own 120 FPS cap."
        helpSafeRec = "Always try this method first. It is the safest option. If the game remains at 120 FPS, the setting was written correctly but DBD ignored the higher limit."
        helpFixedTitle = "Experimental method — not a normal FPS cap"
        helpFixedText = "This enables bUseFixedFrameRate and gives Unreal Engine a fixed rate. The engine can use that number for time calculations, so this is fundamentally different from a normal limit. If the PC cannot maintain the chosen rate, gameplay can feel slow, uneven or incorrectly timed."
        helpFixedRec = "Use it only after the standard method fails. Select your real monitor rate, test one match and restore immediately if movement, animations or timing feel wrong."
        helpVsyncTitle = "In-game V-Sync"
        helpVsyncText = "V-Sync synchronizes frames with the display to reduce tearing, but it can add input delay. Keep current setting leaves the existing DBD value untouched. Off disables it inside DBD; On enables it."
        helpVsyncRec = "For G-SYNC or FreeSync, a common starting point is V-Sync off inside DBD and synchronization managed in the GPU control panel. When unsure, choose Keep current setting."
        helpReadOnlyTitle = "Read-only — prevents DBD from overwriting the files"
        helpReadOnlyText = "Windows marks GameUserSettings.ini and Engine.ini as non-writable. This does not damage the files or the computer. It can stop DBD from restoring its old values, but changes made later in the game's settings menu may not save."
        helpReadOnlyRec = "Leave it disabled at first. Enable it only if the FPS value is reset after launching or closing DBD."
        helpInstallTitle = "Game installation / configuration folder"
        helpInstallText = "Choose the live configuration used by your copy of DBD. Steam normally uses WindowsClient, Epic uses EGS and Microsoft Store can use WinGDKClient. The tool changes only the selected folder."
        helpInstallRec = "Use the automatically detected entry that matches the store where you own and launch DBD."
        helpApplyTitle = "Apply FPS settings"
        helpApplyText = "The tool creates a backup, unlocks the two INI files temporarily, writes the selected settings, reads them again to verify the change and restores the backup automatically if verification fails."
        helpApplyRec = "Close DBD before pressing Apply. After success, launch the game and verify the FPS during an actual match rather than only in the menu."
        helpRestoreTitle = "Restore latest"
        helpRestoreText = "Restores the most recent backup created immediately before an Apply operation for the selected installation. It also restores the previous Read-only state."
        helpRestoreRec = "Use this if the game feels slow, animations look wrong, settings stop saving or you simply want to undo the last change."
        helpUnlockTitle = "Unlock files"
        helpUnlockText = "Removes the Read-only attribute from the two configuration files without changing the FPS values currently written inside them."
        helpUnlockRec = "Use this before changing graphics settings inside DBD when the files were previously locked."


        helpLanguageTitle = "Interface language"
        helpLanguageText = "Changes the language and text direction of this tool only. It does not change the language of Dead by Daylight."
        helpLanguageRec = "Choose Hebrew for a full right-to-left interface, or any other language you prefer."
        helpDetectedTitle = "Detected values — file verification, not live performance"
        helpDetectedText = "This box reads the current FPS, method, V-Sync and Read-only values from the selected INI files. It cannot confirm what DBD is actually rendering while the game is running."
        helpDetectedRec = "Use an in-game, Steam or NVIDIA FPS counter during a real match to verify the actual result."
        helpRefreshTitle = "Refresh the detected configuration"
        helpRefreshText = "Scans the supported live DBD folders again and rereads the current INI values. It does not modify any setting."
        helpRefreshRec = "Use this after launching or closing DBD, after changing a file manually, or when the displayed values look outdated."

        legacyCleaned = "Previous DBD FPS Unlocker blocks were cleaned safely."
    }
    he = @{
        title = "כלי FPS ל־DBD"
        subtitle = "הגדרת FPS פשוטה ובטוחה ל־Dead by Daylight"
        language = "שפה"
        config = "גרסת המשחק"
        statusChecking = "בודק את קובצי ההגדרות..."
        statusFound = "קובצי ההגדרות נמצאו"
        statusMissing = "קובצי DBD לא נמצאו"
        gameClosed = "Dead by Daylight סגור — אפשר לבצע שינוי"
        gameRunning = "Dead by Daylight פועל — סגור אותו לפני ביצוע שינוי"
        target = "FPS רצוי"
        detected = "הערכים שנמצאו"
        waiting = "ממתין לבדיקה..."
        actualNote = "הכלי מאמת את הקבצים בלבד, לא את ה־FPS שמופיע בפועל בתוך המשחק."
        method = "שיטת ההגדרה"
        safeTitle = "רגילה — רק מגבלת FPS"
        safeDesc = "מגדירה תקרת FPS רגילה בלבד. היא אינה משנה את תזמון המשחק ואינה מכריחה את DBD להגיע לערך שבחרת."
        fixedTitle = "ניסיונית — משנה את תזמון המנוע"
        fixedDesc = "מכריחה את Unreal Engine לחשב את הזמן לפי הקצב שנבחר. אם המחשב לא שומר עליו, המשחק עלול להרגיש בהילוך איטי."
        options = "אפשרויות"
        vsync = "V-Sync בתוך המשחק"
        keep = "השאר ללא שינוי"
        off = "כבוי"
        on = "פעיל"
        lock = "השתמש ב־Read-only רק אם DBD מחזיר את הערך"
        lockDesc = "Read-only אינו מסוכן, אבל הגדרות שתשנה בתוך DBD עלולות לא להישמר."
        warningNormal = "עד 120 FPS הכלי משתמש בשיטת ההגדרה הרגילה."
        warningHighSafe = "מעל 120 FPS זו הגדרה ניסיונית. השיטה הרגילה בטוחה יותר, אבל DBD עלול עדיין להישאר על 120."
        warningFixed = "Fixed Frame Rate הוא ניסיוני ועלול לגרום להילוך איטי אם המחשב לא מצליח לשמור על ה־FPS שנבחר."
        apply = "החל את הגדרות ה־FPS"
        refresh = "רענון"
        restore = "שחזור אחרון"
        unlock = "בטל נעילה"
        openConfig = "פתח הגדרות"
        openBackups = "פתח גיבויים"
        log = "יומן פעילות"
        footer = "נייד • ללא התקנה • ללא הרשאות מנהל • Windows 10/11"
        noConfig = "לא נמצאו קובצי הגדרות נתמכים של Dead by Daylight.`n`nפתח את המשחק פעם אחת, סגור אותו ופתח מחדש את הכלי."
        closeGame = "Dead by Daylight פועל כרגע.`n`nסגור את המשחק לחלוטין ונסה שוב."
        invalidFps = "יש להזין מספר FPS שלם בין 30 ל־360."
        confirmHigh = "בחרת ערך גבוה מ־120 FPS. ייתכן ש־Dead by Daylight יתעלם ממנו ויישאר מוגבל ל־120.`n`nלהמשיך בכל זאת?"
        confirmFixed = "Fixed Frame Rate ניסיוני יכול להשפיע על קצב המשחק או לגרום להילוך איטי כאשר המחשב לא שומר על ה־FPS שנבחר.`n`nלהמשיך בכל זאת?"
        success = "ההגדרות הוחלו בהצלחה."
        applyFailed = "השינוי נכשל. הקבצים הקודמים שוחזרו אוטומטית."
        restoreConfirm = "לשחזר את הגיבוי האחרון של גרסת המשחק שנבחרה?"
        restoreSuccess = "הגיבוי האחרון שוחזר בהצלחה."
        noBackup = "לא נמצא גיבוי שנוצר באמצעות DBD FPS Unlocker עבור גרסה זו."
        unlockSuccess = "הנעילה בוטלה. אפשר שוב לשמור שינויים שתבצע מתוך DBD."
        filesMissing = "קובצי ההגדרות שנבחרו כבר אינם קיימים. לחץ על רענון."
        info = "מידע"
        warning = "אזהרה"
        error = "שגיאה"
        platformSteam = "Steam"
        platformEpic = "Epic Games"
        platformMicrosoft = "Microsoft Store"
        platformLegacy = "גרסה ישנה"
        configLine = "משחק: {0} FPS  |  מנוע: {1} FPS  |  שיטה: {2}  |  V-Sync: {3}  |  Read-only: {4}"
        methodStandard = "רגילה"
        methodFixed = "Fixed"
        methodUnknown = "לא ידוע"
        valueMissing = "לא הוגדר"
        yes = "כן"
        no = "לא"
        keepLog = "הגדרת V-Sync הנוכחית נשמרה ללא שינוי."
        backupCreated = "נוצר גיבוי: {0}"
        updated = "עודכן: {0}"
        restored = "שוחזר מתוך: {0}"
        rollback = "השחזור האוטומטי הסתיים."
        liveConfig = "תיקיית ההגדרות שנבחרה: {0}"
        gameStateClosed = "תהליך המשחק: סגור"
        gameStateRunning = "תהליך המשחק: פועל"
        readOnlyOn = "Read-only הופעל."
        readOnlyOff = "Read-only כבוי."

        helpLabel = "הסבר בהעברת העכבר"
        helpDefaultTitle = "מה מומלץ לעשות כדי שזה יעבוד נכון?"
        helpDefaultText = "בחר FPS שמתאים לקצב הרענון של המסך. התחל בשיטה הרגילה, החל את השינוי ובדוק את ה־FPS בפועל בתוך משחק אמיתי. אם DBD עדיין נשאר על 120, סגור את המשחק ורק אז נסה את השיטה הניסיונית."
        helpDefaultRec = "למסך 165Hz בחר 165 FPS. הפעל Read-only רק אם DBD מחזיר את הערך. אם השיטה הניסיונית גורמת להילוך איטי או לתנועה מוזרה — בצע שחזור אחרון."
        helpFpsTitle = "FPS רצוי — איזה מספר לבחור?"
        helpFpsText = "זה המספר שהכלי כותב לקובצי ההגדרות. נקודת ההתחלה הנכונה היא קצב הרענון של המסך, למשל 165 למסך 165Hz. בחירה ב־240 או 360 במסך 165Hz בדרך כלל רק מעמיסה יותר, בלי שהמסך יוכל להציג 240 או 360 רענונים."
        helpFpsRec = "התחל עם קצב הרענון האמיתי של המסך. אל תבחר 240 או 360 רק משום שהמחשב מסוגל לייצר יותר פריימים."
        helpSafeTitle = "השיטה הרגילה — תקרת FPS רגילה"
        helpSafeText = "השיטה כותבת ערכי הגבלה רגילים כמו FrameRateLimit ו־t.MaxFPS. היא רק אומרת למנוע לא לעבור את המספר שבחרת. היא אינה משנה את מהירות הזמן, האנימציות או המשחקיות. DBD עדיין עלול לאכוף בעצמו תקרה של 120 FPS."
        helpSafeRec = "תמיד מתחילים בשיטה הזאת. היא הבטוחה ביותר. אם המשחק נשאר על 120, זה לא אומר שהכלי נכשל — ייתכן שההגדרה נכתבה אך DBD התעלם מהערך הגבוה."
        helpFixedTitle = "השיטה הניסיונית — אינה מגבלת FPS רגילה"
        helpFixedText = "השיטה מפעילה bUseFixedFrameRate ונותנת ל־Unreal Engine קצב קבוע. המנוע עשוי להשתמש במספר הזה גם בחישובי זמן, ולכן זו פעולה שונה לגמרי מתקרת FPS רגילה. אם המחשב אינו שומר על הקצב שנבחר, המשחק עלול להרגיש איטי, לא אחיד או עם תזמון שגוי."
        helpFixedRec = "השתמש בה רק לאחר שהשיטה הרגילה לא עברה את 120. בחר את קצב המסך האמיתי, בדוק משחק אחד ושחזר מיד אם התנועה, האנימציות או הקצב מרגישים לא תקינים."
        helpVsyncTitle = "V-Sync בתוך המשחק"
        helpVsyncText = "V-Sync מסנכרן את הפריימים עם המסך כדי להפחית קריעות תמונה, אבל הוא יכול להוסיף השהיית קלט. השאר ללא שינוי אינו נוגע בערך הקיים; כבוי מבטל אותו בתוך DBD; פעיל מפעיל אותו."
        helpVsyncRec = "עם G-SYNC או FreeSync, נקודת התחלה נפוצה היא V-Sync כבוי בתוך DBD וניהול הסנכרון דרך לוח הבקרה של הכרטיס. כאשר אינך בטוח, בחר השאר ללא שינוי."
        helpReadOnlyTitle = "Read-only — מונע מ־DBD לדרוס את הקבצים"
        helpReadOnlyText = "Windows מסמן את GameUserSettings.ini ואת Engine.ini כקבצים שאסור לכתוב אליהם. זה אינו פוגע בקבצים או במחשב. זה עשוי למנוע מ־DBD להחזיר ערכים ישנים, אך שינויים שתבצע אחר כך בתפריט ההגדרות של המשחק עלולים לא להישמר."
        helpReadOnlyRec = "השאר כבוי בניסיון הראשון. הפעל אותו רק אם ערך ה־FPS חוזר אחורה לאחר פתיחה או סגירה של DBD."
        helpInstallTitle = "גרסת המשחק ותיקיית ההגדרות"
        helpInstallText = "בחר את תיקיית ההגדרות הפעילה של העותק שלך. Steam משתמש בדרך כלל ב־WindowsClient, Epic ב־EGS ו־Microsoft Store עשוי להשתמש ב־WinGDKClient. הכלי משנה רק את התיקייה שנבחרה."
        helpInstallRec = "בחר את האפשרות שזוהתה אוטומטית ומתאימה לחנות שממנה אתה מפעיל את DBD."
        helpApplyTitle = "החל את הגדרות ה־FPS"
        helpApplyText = "הכלי יוצר גיבוי, מבטל זמנית את הנעילה, כותב את הערכים שנבחרו, קורא אותם מחדש כדי לוודא שהשינוי הצליח ומחזיר את הגיבוי אוטומטית אם האימות נכשל."
        helpApplyRec = "סגור את DBD לפני הלחיצה. לאחר הצלחה, פתח את המשחק ובדוק את ה־FPS בתוך משחק אמיתי ולא רק בתפריט."
        helpRestoreTitle = "שחזור אחרון"
        helpRestoreText = "מחזיר את הגיבוי האחרון שנוצר מיד לפני פעולת Apply עבור גרסת המשחק שנבחרה. גם מצב ה־Read-only הקודם מוחזר."
        helpRestoreRec = "השתמש בזה אם המשחק מרגיש איטי, האנימציות נראות לא תקינות, ההגדרות אינן נשמרות או שאתה פשוט רוצה לבטל את השינוי האחרון."
        helpUnlockTitle = "בטל נעילה"
        helpUnlockText = "מסיר את תכונת Read-only משני קובצי ההגדרות, בלי לשנות את ערכי ה־FPS שכבר כתובים בהם."
        helpUnlockRec = "השתמש בזה לפני שינוי הגדרות גרפיקה מתוך DBD כאשר הקבצים ננעלו קודם."


        helpLanguageTitle = "שפת הממשק"
        helpLanguageText = "משנה רק את השפה ואת כיוון הטקסט של הכלי. היא אינה משנה את השפה של Dead by Daylight."
        helpLanguageRec = "בחר עברית לממשק מלא מימין לשמאל, או כל שפה אחרת שנוחה לך."
        helpDetectedTitle = "הערכים שנמצאו — בדיקת קבצים, לא ביצועים בזמן אמת"
        helpDetectedText = "האזור קורא את ערכי ה־FPS, השיטה, V-Sync ו־Read-only מתוך קובצי ה־INI שנבחרו. הוא אינו יכול לאשר כמה FPS המשחק באמת מציג בזמן שהוא פועל."
        helpDetectedRec = "כדי לבדוק את התוצאה בפועל, השתמש במונה FPS של המשחק, Steam או NVIDIA בתוך משחק אמיתי."
        helpRefreshTitle = "רענון קובצי ההגדרות"
        helpRefreshText = "סורק שוב את תיקיות DBD הנתמכות וקורא מחדש את ערכי ה־INI. הפעולה אינה משנה שום הגדרה."
        helpRefreshRec = "השתמש בזה לאחר פתיחה או סגירה של DBD, לאחר שינוי ידני בקובץ או כאשר הערכים המוצגים אינם מעודכנים."

        legacyCleaned = "הגדרות ישנות של הכלי נוקו באופן בטוח."
    }
    es = @{
        title = "Herramienta FPS para DBD"
        subtitle = "Configuración sencilla y segura de FPS para Dead by Daylight"
        language = "Idioma"
        config = "Instalación del juego"
        statusChecking = "Comprobando la configuración..."
        statusFound = "Configuración detectada"
        statusMissing = "No se encontró la configuración de DBD"
        gameClosed = "Dead by Daylight está cerrado — listo para editar"
        gameRunning = "Dead by Daylight está abierto — ciérralo antes de aplicar cambios"
        target = "FPS objetivo"
        detected = "Configuración detectada"
        waiting = "Esperando..."
        actualNote = "Esto verifica los archivos, no los FPS reales mostrados por el juego."
        method = "Método de FPS"
        safeTitle = "Estándar — solo limita FPS"
        safeDesc = "Usa los valores normales. Por encima de 120 FPS el juego puede seguir limitado."
        fixedTitle = "Experimental — cambia el tiempo del motor"
        fixedDesc = "Puede superar límites, pero puede afectar al tiempo del juego si no se mantienen los FPS."
        options = "Opciones"
        vsync = "V-Sync del juego"
        keep = "Mantener ajuste actual"
        off = "Desactivado"
        on = "Activado"
        lock = "Usar solo lectura solo si DBD restablece el valor"
        lockDesc = "Solo lectura no es peligroso, pero los cambios dentro de DBD pueden no guardarse."
        warningNormal = "Hasta 120 FPS se utiliza el método normal."
        warningHighSafe = "Más de 120 FPS es experimental. El modo estándar es más seguro, pero DBD puede seguir en 120."
        warningFixed = "Fixed Frame Rate es experimental y puede causar cámara lenta si no se mantienen los FPS elegidos."
        apply = "Aplicar ajustes de FPS"
        refresh = "Actualizar"
        restore = "Restaurar último"
        unlock = "Desbloquear"
        openConfig = "Abrir configuración"
        openBackups = "Abrir copias"
        log = "Registro de actividad"
        footer = "Portátil • Sin instalación • Sin permisos de administrador • Windows 10/11"
        noConfig = "No se encontró una configuración compatible de Dead by Daylight.`n`nAbre el juego una vez, ciérralo y vuelve a abrir la herramienta."
        closeGame = "Dead by Daylight está abierto.`n`nCierra el juego completamente e inténtalo de nuevo."
        invalidFps = "Introduce un número entero entre 30 y 360."
        confirmHigh = "El valor elegido supera 120 FPS. Dead by Daylight puede ignorarlo y seguir limitado a 120.`n`n¿Aplicar de todos modos?"
        confirmFixed = "Fixed Frame Rate puede afectar al tiempo del juego o causar cámara lenta si no se mantienen los FPS.`n`n¿Aplicar de todos modos?"
        success = "Los ajustes se aplicaron correctamente."
        applyFailed = "El cambio falló. Los archivos anteriores se restauraron automáticamente."
        restoreConfirm = "¿Restaurar la copia más reciente de la configuración seleccionada?"
        restoreSuccess = "La copia más reciente se restauró correctamente."
        noBackup = "No se encontró una copia creada por DBD FPS Unlocker para esta configuración."
        unlockSuccess = "Los archivos están desbloqueados. Los cambios dentro de DBD pueden volver a guardarse."
        filesMissing = "Los archivos seleccionados ya no existen. Pulsa Actualizar."
        info = "Información"
        warning = "Advertencia"
        error = "Error"
        platformSteam = "Steam"
        platformEpic = "Epic Games"
        platformMicrosoft = "Microsoft Store"
        platformLegacy = "Antiguo"
        configLine = "Juego: {0} FPS  |  Motor: {1} FPS  |  Método: {2}  |  V-Sync: {3}  |  Solo lectura: {4}"
        methodStandard = "Estándar"
        methodFixed = "Fixed"
        methodUnknown = "Desconocido"
        valueMissing = "sin definir"
        yes = "Sí"
        no = "No"
        keepLog = "Se mantuvo el ajuste actual de V-Sync."
        backupCreated = "Copia creada: {0}"
        updated = "Actualizado: {0}"
        restored = "Restaurado desde: {0}"
        rollback = "Restauración automática completada."
        liveConfig = "Configuración seleccionada: {0}"
        gameStateClosed = "Proceso del juego: cerrado"
        gameStateRunning = "Proceso del juego: abierto"
        readOnlyOn = "Solo lectura activado."
        readOnlyOff = "Solo lectura desactivado."

        helpLabel = "AYUDA AL PASAR EL RATÓN"
        helpDefaultTitle = "Ruta recomendada"
        helpDefaultText = "Elige los FPS según la frecuencia del monitor. Prueba primero el método estándar y comprueba los FPS dentro de una partida. Si DBD sigue en 120, cierra el juego y prueba el método experimental."
        helpDefaultRec = "Usa solo lectura únicamente si DBD restablece el valor. Restaura la copia si el modo experimental causa cámara lenta."
        helpFpsTitle = "FPS objetivo"
        helpFpsText = "Empieza con la frecuencia real del monitor. Un monitor de 165 Hz debería probar primero 165 FPS."
        helpFpsRec = "No elijas 240 o 360 solo porque el PC pueda renderizarlos."
        helpSafeTitle = "Método estándar"
        helpSafeText = "Solo establece un límite normal de FPS y no modifica el tiempo del juego. DBD puede seguir limitado a 120."
        helpSafeRec = "Prueba siempre este método primero."
        helpFixedTitle = "Método experimental"
        helpFixedText = "Activa una frecuencia fija usada por Unreal Engine para cálculos de tiempo. Puede causar cámara lenta si no se mantiene."
        helpFixedRec = "Úsalo solo si el método estándar sigue en 120."
        helpVsyncTitle = "V-Sync del juego"
        helpVsyncText = "Reduce el tearing, pero puede añadir latencia. Mantener no cambia el valor actual."
        helpVsyncRec = "Con G-SYNC o FreeSync, suele probarse desactivado dentro del juego."
        helpReadOnlyTitle = "Solo lectura"
        helpReadOnlyText = "Impide que DBD sobrescriba los archivos, pero los cambios hechos dentro del juego pueden no guardarse."
        helpReadOnlyRec = "Déjalo desactivado al principio."
        helpInstallTitle = "Instalación del juego"
        helpInstallText = "Selecciona la carpeta activa correspondiente a Steam, Epic o Microsoft Store."
        helpInstallRec = "Usa la entrada detectada que coincida con tu tienda."
        helpApplyTitle = "Aplicar"
        helpApplyText = "Crea una copia, escribe, verifica y restaura automáticamente si algo falla."
        helpApplyRec = "Cierra DBD antes de aplicar."
        helpRestoreTitle = "Restaurar"
        helpRestoreText = "Restaura la copia más reciente anterior a Apply."
        helpRestoreRec = "Úsalo si el juego se siente extraño."
        helpUnlockTitle = "Desbloquear archivos"
        helpUnlockText = "Quita el atributo de solo lectura sin cambiar los FPS."
        helpUnlockRec = "Úsalo antes de cambiar ajustes dentro de DBD."


        helpLanguageTitle = "Idioma de la interfaz"
        helpLanguageText = "Cambia solo el idioma de esta herramienta, no el idioma de Dead by Daylight."
        helpLanguageRec = "Elige el idioma que te resulte más cómodo."
        helpDetectedTitle = "Valores detectados"
        helpDetectedText = "Lee los archivos INI; no confirma los FPS reales mientras el juego está abierto."
        helpDetectedRec = "Comprueba los FPS reales dentro de una partida."
        helpRefreshTitle = "Actualizar configuración"
        helpRefreshText = "Vuelve a leer las carpetas y valores de DBD sin modificarlos."
        helpRefreshRec = "Úsalo cuando los datos parezcan antiguos."

        legacyCleaned = "Los bloques antiguos de la herramienta se limpiaron de forma segura."
    }
    de = @{
        title = "DBD FPS Unlocker"
        subtitle = "Einfache und sichere FPS-Konfiguration für Dead by Daylight"
        language = "Sprache"
        config = "Spielinstallation"
        statusChecking = "Konfiguration wird geprüft..."
        statusFound = "Konfiguration gefunden"
        statusMissing = "DBD-Konfiguration nicht gefunden"
        gameClosed = "Dead by Daylight ist geschlossen — bereit"
        gameRunning = "Dead by Daylight läuft — vor Änderungen schließen"
        target = "Ziel-FPS"
        detected = "Erkannte Konfiguration"
        waiting = "Warten..."
        actualNote = "Geprüft werden die Dateien, nicht die tatsächlich im Spiel angezeigten FPS."
        method = "FPS-Methode"
        safeTitle = "Standard — nur FPS-Limit"
        safeDesc = "Verwendet normale Konfigurationswerte. Über 120 FPS kann das Spiel weiterhin begrenzt bleiben."
        fixedTitle = "Experimentell — verändert das Engine-Timing"
        fixedDesc = "Kann Grenzen umgehen, aber das Spieltempo beeinflussen, wenn die FPS nicht gehalten werden."
        options = "Optionen"
        vsync = "V-Sync im Spiel"
        keep = "Aktuelle Einstellung behalten"
        off = "Aus"
        on = "Ein"
        lock = "Schreibschutz nur nutzen, wenn DBD den Wert zurücksetzt"
        lockDesc = "Schreibschutz ist nicht gefährlich, aber Änderungen im Spiel werden eventuell nicht gespeichert."
        warningNormal = "Bis 120 FPS wird die normale Konfigurationsmethode verwendet."
        warningHighSafe = "Über 120 FPS ist experimentell. Standard ist sicherer, DBD kann aber bei 120 bleiben."
        warningFixed = "Eine feste Bildrate ist experimentell und kann Zeitlupen verursachen, wenn die gewählten FPS nicht gehalten werden."
        apply = "FPS-Einstellungen anwenden"
        refresh = "Aktualisieren"
        restore = "Letzte Sicherung"
        unlock = "Dateien entsperren"
        openConfig = "Konfiguration öffnen"
        openBackups = "Sicherungen öffnen"
        log = "Aktivitätsprotokoll"
        footer = "Portabel • Keine Installation • Keine Administratorrechte • Windows 10/11"
        noConfig = "Keine unterstützte Dead-by-Daylight-Konfiguration gefunden.`n`nSpiel einmal öffnen, schließen und das Tool neu starten."
        closeGame = "Dead by Daylight läuft derzeit.`n`nSpiel vollständig schließen und erneut versuchen."
        invalidFps = "Eine ganze FPS-Zahl zwischen 30 und 360 eingeben."
        confirmHigh = "Der gewählte Wert liegt über 120 FPS. DBD kann ihn ignorieren und bei 120 bleiben.`n`nTrotzdem anwenden?"
        confirmFixed = "Eine feste Bildrate kann das Spieltempo beeinflussen oder Zeitlupen verursachen, wenn die FPS nicht gehalten werden.`n`nTrotzdem anwenden?"
        success = "Einstellungen wurden erfolgreich angewendet."
        applyFailed = "Änderung fehlgeschlagen. Die vorherigen Dateien wurden automatisch wiederhergestellt."
        restoreConfirm = "Die neueste Sicherung für die ausgewählte Konfiguration wiederherstellen?"
        restoreSuccess = "Die neueste Sicherung wurde erfolgreich wiederhergestellt."
        noBackup = "Für diese Konfiguration wurde keine Sicherung von DBD FPS Unlocker gefunden."
        unlockSuccess = "Die Dateien sind entsperrt. Änderungen im Spiel können wieder gespeichert werden."
        filesMissing = "Die ausgewählten Dateien existieren nicht mehr. Aktualisieren drücken."
        info = "Information"
        warning = "Warnung"
        error = "Fehler"
        platformSteam = "Steam"
        platformEpic = "Epic Games"
        platformMicrosoft = "Microsoft Store"
        platformLegacy = "Veraltet"
        configLine = "Spiel: {0} FPS  |  Engine: {1} FPS  |  Methode: {2}  |  V-Sync: {3}  |  Schreibschutz: {4}"
        methodStandard = "Standard"
        methodFixed = "Fest"
        methodUnknown = "Unbekannt"
        valueMissing = "nicht gesetzt"
        yes = "Ja"
        no = "Nein"
        keepLog = "Die aktuelle V-Sync-Einstellung wurde beibehalten."
        backupCreated = "Sicherung erstellt: {0}"
        updated = "Aktualisiert: {0}"
        restored = "Wiederhergestellt aus: {0}"
        rollback = "Automatische Wiederherstellung abgeschlossen."
        liveConfig = "Ausgewählte Konfiguration: {0}"
        gameStateClosed = "Spielprozess: geschlossen"
        gameStateRunning = "Spielprozess: läuft"
        readOnlyOn = "Schreibschutz aktiviert."
        readOnlyOff = "Schreibschutz deaktiviert."

        helpLabel = "HILFE BEIM DARÜBERFAHREN"
        helpDefaultTitle = "Empfohlener Ablauf"
        helpDefaultText = "FPS passend zur Monitorfrequenz wählen. Zuerst Standard testen und die echten FPS in einem Match prüfen. Bleibt DBD bei 120, Spiel schließen und experimentell testen."
        helpDefaultRec = "Schreibschutz nur aktivieren, wenn DBD den Wert zurücksetzt. Bei Zeitlupe die letzte Sicherung wiederherstellen."
        helpFpsTitle = "Ziel-FPS"
        helpFpsText = "Mit der echten Monitorfrequenz beginnen, zum Beispiel 165 FPS bei 165 Hz."
        helpFpsRec = "Nicht unnötig 240 oder 360 wählen."
        helpSafeTitle = "Standardmethode"
        helpSafeText = "Setzt nur ein normales FPS-Limit und verändert nicht das Spieltempo. DBD kann bei 120 bleiben."
        helpSafeRec = "Immer zuerst ausprobieren."
        helpFixedTitle = "Experimentelle Methode"
        helpFixedText = "Aktiviert eine feste Rate für Zeitberechnungen der Unreal Engine. Bei zu niedriger Leistung kann Zeitlupe entstehen."
        helpFixedRec = "Nur verwenden, wenn Standard bei 120 bleibt."
        helpVsyncTitle = "V-Sync im Spiel"
        helpVsyncText = "Reduziert Tearing, kann aber Eingabeverzögerung erhöhen. Beibehalten verändert nichts."
        helpVsyncRec = "Bei G-SYNC oder FreeSync wird im Spiel oft Aus getestet."
        helpReadOnlyTitle = "Schreibschutz"
        helpReadOnlyText = "Verhindert das Überschreiben durch DBD, kann aber das Speichern von Einstellungen im Spiel blockieren."
        helpReadOnlyRec = "Zuerst deaktiviert lassen."
        helpInstallTitle = "Spielinstallation"
        helpInstallText = "Aktiven Ordner für Steam, Epic oder Microsoft Store auswählen."
        helpInstallRec = "Den automatisch erkannten Eintrag der eigenen Plattform wählen."
        helpApplyTitle = "Anwenden"
        helpApplyText = "Erstellt Sicherung, schreibt, prüft und stellt bei Fehlern automatisch wieder her."
        helpApplyRec = "DBD vorher schließen."
        helpRestoreTitle = "Wiederherstellen"
        helpRestoreText = "Stellt die letzte Sicherung vor Apply wieder her."
        helpRestoreRec = "Bei ungewöhnlichem Spielverhalten verwenden."
        helpUnlockTitle = "Dateien entsperren"
        helpUnlockText = "Entfernt den Schreibschutz, ohne die FPS-Werte zu ändern."
        helpUnlockRec = "Vor Änderungen im DBD-Menü verwenden."


        helpLanguageTitle = "Sprache der Oberfläche"
        helpLanguageText = "Ändert nur die Sprache dieses Tools, nicht die Sprache von Dead by Daylight."
        helpLanguageRec = "Die bevorzugte Sprache auswählen."
        helpDetectedTitle = "Erkannte Werte"
        helpDetectedText = "Liest die INI-Dateien, bestätigt aber nicht die tatsächlich laufenden FPS."
        helpDetectedRec = "Die echten FPS in einem Match prüfen."
        helpRefreshTitle = "Konfiguration aktualisieren"
        helpRefreshText = "Liest DBD-Ordner und INI-Werte erneut, ohne etwas zu ändern."
        helpRefreshRec = "Bei veralteten Anzeigen verwenden."

        legacyCleaned = "Alte Tool-Blöcke wurden sicher entfernt."
    }
    fr = @{
        title = "Outil FPS pour DBD"
        subtitle = "Configuration FPS simple et sûre pour Dead by Daylight"
        language = "Langue"
        config = "Installation du jeu"
        statusChecking = "Vérification de la configuration..."
        statusFound = "Configuration détectée"
        statusMissing = "Configuration DBD introuvable"
        gameClosed = "Dead by Daylight est fermé — prêt"
        gameRunning = "Dead by Daylight est ouvert — fermez-le avant les modifications"
        target = "FPS cible"
        detected = "Configuration détectée"
        waiting = "En attente..."
        actualNote = "Cet outil vérifie les fichiers, pas les FPS réellement affichés par le jeu."
        method = "Méthode FPS"
        safeTitle = "Standard — limite FPS uniquement"
        safeDesc = "Utilise les valeurs normales. Au-dessus de 120 FPS, le jeu peut rester limité."
        fixedTitle = "Expérimental — modifie le timing du moteur"
        fixedDesc = "Peut contourner des limites, mais affecter le temps du jeu si les FPS ne sont pas maintenus."
        options = "Options"
        vsync = "V-Sync dans le jeu"
        keep = "Conserver le réglage actuel"
        off = "Désactivée"
        on = "Activée"
        lock = "Utiliser la lecture seule uniquement si DBD réinitialise la valeur"
        lockDesc = "La lecture seule n'est pas dangereuse, mais les changements dans DBD peuvent ne pas être enregistrés."
        warningNormal = "Jusqu'à 120 FPS, la méthode normale est utilisée."
        warningHighSafe = "Au-dessus de 120 FPS, le réglage est expérimental. Le mode standard est plus sûr, mais DBD peut rester à 120."
        warningFixed = "La fréquence fixe est expérimentale et peut causer un effet de ralenti si les FPS choisis ne sont pas maintenus."
        apply = "Appliquer les réglages FPS"
        refresh = "Actualiser"
        restore = "Restaurer la dernière"
        unlock = "Déverrouiller"
        openConfig = "Ouvrir la configuration"
        openBackups = "Ouvrir les sauvegardes"
        log = "Journal d'activité"
        footer = "Portable • Sans installation • Sans droits administrateur • Windows 10/11"
        noConfig = "Aucune configuration Dead by Daylight compatible n'a été trouvée.`n`nLancez le jeu une fois, fermez-le puis rouvrez l'outil."
        closeGame = "Dead by Daylight est en cours d'exécution.`n`nFermez complètement le jeu et réessayez."
        invalidFps = "Saisissez un nombre entier entre 30 et 360."
        confirmHigh = "La valeur choisie dépasse 120 FPS. DBD peut l'ignorer et rester limité à 120.`n`nAppliquer quand même ?"
        confirmFixed = "La fréquence fixe peut affecter le temps du jeu ou causer un ralenti si les FPS ne sont pas maintenus.`n`nAppliquer quand même ?"
        success = "Les réglages ont été appliqués."
        applyFailed = "La modification a échoué. Les fichiers précédents ont été restaurés automatiquement."
        restoreConfirm = "Restaurer la sauvegarde la plus récente pour la configuration sélectionnée ?"
        restoreSuccess = "La sauvegarde la plus récente a été restaurée."
        noBackup = "Aucune sauvegarde créée par DBD FPS Unlocker n'a été trouvée pour cette configuration."
        unlockSuccess = "Les fichiers sont déverrouillés. Les changements dans DBD peuvent à nouveau être enregistrés."
        filesMissing = "Les fichiers sélectionnés n'existent plus. Cliquez sur Actualiser."
        info = "Information"
        warning = "Avertissement"
        error = "Erreur"
        platformSteam = "Steam"
        platformEpic = "Epic Games"
        platformMicrosoft = "Microsoft Store"
        platformLegacy = "Ancien"
        configLine = "Jeu : {0} FPS  |  Moteur : {1} FPS  |  Méthode : {2}  |  V-Sync : {3}  |  Lecture seule : {4}"
        methodStandard = "Standard"
        methodFixed = "Fixe"
        methodUnknown = "Inconnue"
        valueMissing = "non défini"
        yes = "Oui"
        no = "Non"
        keepLog = "Le réglage V-Sync actuel a été conservé."
        backupCreated = "Sauvegarde créée : {0}"
        updated = "Mis à jour : {0}"
        restored = "Restauré depuis : {0}"
        rollback = "Restauration automatique terminée."
        liveConfig = "Configuration sélectionnée : {0}"
        gameStateClosed = "Processus du jeu : fermé"
        gameStateRunning = "Processus du jeu : ouvert"
        readOnlyOn = "Lecture seule activée."
        readOnlyOff = "Lecture seule désactivée."

        helpLabel = "AIDE AU SURVOL"
        helpDefaultTitle = "Procédure recommandée"
        helpDefaultText = "Choisissez les FPS selon le taux de rafraîchissement de l'écran. Testez d'abord la méthode standard dans une vraie partie. Si DBD reste à 120, fermez le jeu puis essayez la méthode expérimentale."
        helpDefaultRec = "N'activez la lecture seule que si DBD réinitialise la valeur. Restaurez la sauvegarde en cas de ralenti."
        helpFpsTitle = "FPS cible"
        helpFpsText = "Commencez par le taux réel de l'écran, par exemple 165 FPS pour 165 Hz."
        helpFpsRec = "Ne choisissez pas inutilement 240 ou 360."
        helpSafeTitle = "Méthode standard"
        helpSafeText = "Définit seulement une limite FPS normale et ne modifie pas le temps du jeu. DBD peut rester à 120."
        helpSafeRec = "Toujours tester cette méthode en premier."
        helpFixedTitle = "Méthode expérimentale"
        helpFixedText = "Active une fréquence fixe utilisée par Unreal Engine pour les calculs de temps. Un ralenti peut apparaître si elle n'est pas maintenue."
        helpFixedRec = "À utiliser uniquement si la méthode standard reste à 120."
        helpVsyncTitle = "V-Sync dans le jeu"
        helpVsyncText = "Réduit le tearing mais peut ajouter de la latence. Conserver ne change pas le réglage actuel."
        helpVsyncRec = "Avec G-SYNC ou FreeSync, on teste souvent V-Sync désactivée dans le jeu."
        helpReadOnlyTitle = "Lecture seule"
        helpReadOnlyText = "Empêche DBD d'écraser les fichiers, mais peut bloquer l'enregistrement des réglages dans le jeu."
        helpReadOnlyRec = "Laissez-la désactivée au premier essai."
        helpInstallTitle = "Installation du jeu"
        helpInstallText = "Sélectionnez le dossier actif de Steam, Epic ou Microsoft Store."
        helpInstallRec = "Choisissez l'entrée détectée correspondant à votre plateforme."
        helpApplyTitle = "Appliquer"
        helpApplyText = "Crée une sauvegarde, écrit, vérifie et restaure automatiquement en cas d'échec."
        helpApplyRec = "Fermez DBD avant d'appliquer."
        helpRestoreTitle = "Restaurer"
        helpRestoreText = "Restaure la sauvegarde la plus récente créée avant Apply."
        helpRestoreRec = "À utiliser si le jeu semble anormal."
        helpUnlockTitle = "Déverrouiller"
        helpUnlockText = "Retire la lecture seule sans modifier les valeurs FPS."
        helpUnlockRec = "À utiliser avant de modifier les réglages dans DBD."


        helpLanguageTitle = "Langue de l'interface"
        helpLanguageText = "Modifie uniquement la langue de cet outil, pas celle de Dead by Daylight."
        helpLanguageRec = "Choisissez la langue qui vous convient."
        helpDetectedTitle = "Valeurs détectées"
        helpDetectedText = "Lit les fichiers INI, mais ne confirme pas les FPS réellement affichés."
        helpDetectedRec = "Vérifiez les FPS dans une vraie partie."
        helpRefreshTitle = "Actualiser la configuration"
        helpRefreshText = "Relit les dossiers et valeurs INI de DBD sans les modifier."
        helpRefreshRec = "À utiliser lorsque l'affichage semble obsolète."

        legacyCleaned = "Les anciens blocs de l'outil ont été nettoyés en toute sécurité."
    }
}

function T {
    param([Parameter(Mandatory = $true)][string]$Key)
    $languageTable = $script:Translations[$script:CurrentLanguage]
    if ($languageTable -and $languageTable.ContainsKey($Key)) {
        return [string]$languageTable[$Key]
    }
    return [string]$script:Translations["en"][$Key]
}

function Format-T {
    param(
        [Parameter(Mandatory = $true)][string]$Key,
        [object[]]$Arguments
    )
    return [string]::Format((T $Key), $Arguments)
}

function Add-Log {
    param([string]$Text)
    $stamp = Get-Date -Format "HH:mm:ss"
    $script:LogTextBox.AppendText(("[{0}] {1}`r`n" -f $stamp, $Text))
    $script:LogTextBox.ScrollToEnd()
}

function Show-Message {
    param(
        [string]$Text,
        [ValidateSet("Info", "Warning", "Error", "Question")][string]$Type = "Info"
    )

    $icon = [System.Windows.MessageBoxImage]::Information
    $buttons = [System.Windows.MessageBoxButton]::OK
    $title = T "info"

    switch ($Type) {
        "Warning" {
            $icon = [System.Windows.MessageBoxImage]::Warning
            $title = T "warning"
        }
        "Error" {
            $icon = [System.Windows.MessageBoxImage]::Error
            $title = T "error"
        }
        "Question" {
            $icon = [System.Windows.MessageBoxImage]::Question
            $buttons = [System.Windows.MessageBoxButton]::YesNo
            $title = T "warning"
        }
    }

    return [System.Windows.MessageBox]::Show($script:Window, $Text, $title, $buttons, $icon)
}

function Ensure-AppFolders {
    New-Item -Path $script:AppRoot -ItemType Directory -Force | Out-Null
    New-Item -Path $script:BackupRoot -ItemType Directory -Force | Out-Null

    # One-time compatibility migration from the earlier private "DBD FPS Tool" builds.
    if (-not (Test-Path $script:SettingsFile) -and (Test-Path $script:LegacySettingsFile)) {
        Copy-Item -LiteralPath $script:LegacySettingsFile -Destination $script:SettingsFile -Force -ErrorAction SilentlyContinue
    }
}

function Load-AppSettings {
    $defaults = [ordered]@{
        Language = ""
        Fps = 165
        Method = "safe"
        Vsync = "keep"
        LockFiles = $false
        ConfigFolder = ""
    }

    try {
        if (Test-Path $script:SettingsFile) {
            $loaded = Get-Content -LiteralPath $script:SettingsFile -Raw | ConvertFrom-Json
            foreach ($property in $defaults.Keys) {
                if ($null -ne $loaded.$property) {
                    $defaults[$property] = $loaded.$property
                }
            }
        }
    }
    catch {
        # Corrupt settings should never prevent the tool from opening.
    }

    if ([string]::IsNullOrWhiteSpace([string]$defaults.Language)) {
        $culture = [System.Globalization.CultureInfo]::CurrentUICulture.TwoLetterISOLanguageName.ToLowerInvariant()
        if ($script:Translations.ContainsKey($culture)) {
            $defaults.Language = $culture
        } else {
            $defaults.Language = "en"
        }
    }

    return [pscustomobject]$defaults
}

function Save-AppSettings {
    try {
        Ensure-AppFolders
        $selectedConfig = Get-SelectedConfig
        $settings = [ordered]@{
            Language = $script:CurrentLanguage
            Fps = Get-RequestedFps -Silent
            Method = $(if ($script:FixedMethodRadio.IsChecked) { "fixed" } else { "safe" })
            Vsync = Get-VsyncChoice
            LockFiles = [bool]$script:LockFilesCheck.IsChecked
            ConfigFolder = $(if ($selectedConfig) { $selectedConfig.FolderName } else { "" })
        }
        [System.IO.File]::WriteAllText(
            $script:SettingsFile,
            ($settings | ConvertTo-Json),
            $script:Utf8NoBom
        )
    }
    catch {
        # Saving preferences is optional.
    }
}

function Get-PlatformLabelKey {
    param([string]$FolderName)
    switch ($FolderName) {
        "WindowsClient" { return "platformSteam" }
        "EGS" { return "platformEpic" }
        "WinGDKClient" { return "platformMicrosoft" }
        default { return "platformLegacy" }
    }
}

function Get-DbdConfigs {
    if (-not (Test-Path $script:ConfigRoot)) {
        return @()
    }

    $allowed = @("WindowsClient", "EGS", "WinGDKClient", "WindowsNoEditor", "Windows")
    $configs = @()

    foreach ($folder in @(Get-ChildItem -LiteralPath $script:ConfigRoot -Directory -ErrorAction SilentlyContinue)) {
        if ($allowed -notcontains $folder.Name) {
            continue
        }

        $gus = Join-Path $folder.FullName "GameUserSettings.ini"
        if (-not (Test-Path $gus)) {
            continue
        }

        $configs += [pscustomobject]@{
            FolderName = $folder.Name
            ConfigDir = $folder.FullName
            GameUserSettings = $gus
            EngineIni = Join-Path $folder.FullName "Engine.ini"
        }
    }

    return @($configs | Sort-Object FolderName)
}

function Populate-ConfigCombo {
    param([string]$PreferredFolder = "")

    $script:Configs = @(Get-DbdConfigs)
    $script:ConfigCombo.Items.Clear()

    $selectedIndex = 0
    for ($i = 0; $i -lt $script:Configs.Count; $i++) {
        $config = $script:Configs[$i]
        $platform = T (Get-PlatformLabelKey $config.FolderName)
        $display = "{0} — {1}" -f $platform, $config.FolderName
        [void]$script:ConfigCombo.Items.Add($display)

        if ($PreferredFolder -and $config.FolderName -eq $PreferredFolder) {
            $selectedIndex = $i
        }
    }

    if ($script:Configs.Count -gt 0) {
        $script:ConfigCombo.SelectedIndex = $selectedIndex
    }
}

function Get-SelectedConfig {
    $index = $script:ConfigCombo.SelectedIndex
    if ($index -lt 0 -or $index -ge $script:Configs.Count) {
        return $null
    }
    return $script:Configs[$index]
}

function Test-DbdRunning {
    $processes = @(
        Get-Process -ErrorAction SilentlyContinue |
        Where-Object {
            $_.ProcessName -like "*DeadByDaylight*" -or
            $_.ProcessName -like "*DeadByDaylight-Win64-Shipping*"
        }
    )
    return ($processes.Count -gt 0)
}

function Set-FileReadOnly {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][bool]$ReadOnly
    )

    if (Test-Path $Path) {
        (Get-Item -LiteralPath $Path).IsReadOnly = $ReadOnly
    }
}

function Get-IniValue {
    param(
        [string]$Text,
        [string]$Key
    )

    if ([string]::IsNullOrEmpty($Text)) {
        return $null
    }

    $pattern = "(?im)^\s*" + [regex]::Escape($Key) + "\s*=\s*(.*?)\s*$"
    $match = [regex]::Match($Text, $pattern)
    if ($match.Success) {
        return $match.Groups[1].Value.Trim()
    }
    return $null
}

function Set-IniValue {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$Key,
        [Parameter(Mandatory = $true)][string]$Value
    )

    $pattern = "(?im)^\s*" + [regex]::Escape($Key) + "\s*=.*$"
    $replacement = "{0}={1}" -f $Key, $Value

    if ([regex]::IsMatch($Text, $pattern)) {
        return [regex]::Replace($Text, $pattern, $replacement)
    }

    if ($Text.Length -gt 0 -and -not $Text.EndsWith("`n")) {
        $Text += "`r`n"
    }
    return $Text + $replacement + "`r`n"
}

function Remove-OurToolBlocks {
    param([string]$Text)

    $patterns = @(
        "(?s)\r?\n?; BEGIN DBD FPS UNLOCKER.*?; END DBD FPS UNLOCKER\r?\n?",
        "(?s)\r?\n?; BEGIN DBD FPS TOOL V4.*?; END DBD FPS TOOL V4\r?\n?",
        "(?s)\r?\n?; BEGIN DBD FPS GUI.*?; END DBD FPS GUI\r?\n?",
        "(?s)\r?\n?; BEGIN DBD 165 FPS ONE-CLICK.*?; END DBD 165 FPS ONE-CLICK\r?\n?"
    )

    foreach ($pattern in $patterns) {
        $Text = [regex]::Replace($Text, $pattern, "`r`n")
    }

    return $Text.TrimEnd() + "`r`n"
}

function Get-RequestedFps {
    param([switch]$Silent)

    $value = 0
    if (-not [int]::TryParse($script:FpsTextBox.Text.Trim(), [ref]$value)) {
        if (-not $Silent) {
            [void](Show-Message (T "invalidFps") "Warning")
        }
        return 0
    }

    if ($value -lt 30 -or $value -gt 360) {
        if (-not $Silent) {
            [void](Show-Message (T "invalidFps") "Warning")
        }
        return 0
    }

    return $value
}

function Update-PresetStyles {
    $value = Get-RequestedFps -Silent
    $presets = @(
        @($script:Preset120, 120),
        @($script:Preset144, 144),
        @($script:Preset165, 165),
        @($script:Preset240, 240),
        @($script:Preset360, 360)
    )

    foreach ($entry in $presets) {
        $button = $entry[0]
        $target = [int]$entry[1]

        if ($value -eq $target) {
            $button.Background = $script:Window.Resources["NeonBrush"]
            $button.Foreground = $script:Window.Resources["PaperBrush"]
            $button.BorderBrush = $script:Window.Resources["NeonBrush"]
            $button.Effect = $script:Window.Resources["RedGlow"]
        }
        else {
            $button.ClearValue([System.Windows.Controls.Control]::BackgroundProperty)
            $button.ClearValue([System.Windows.Controls.Control]::ForegroundProperty)
            $button.ClearValue([System.Windows.Controls.Control]::BorderBrushProperty)
            $button.ClearValue([System.Windows.UIElement]::EffectProperty)
        }
    }
}

function Set-FpsValue {
    param([int]$Value)
    $Value = [Math]::Max(30, [Math]::Min(360, $Value))
    $script:FpsTextBox.Text = [string]$Value
    if ([int][Math]::Round($script:FpsSlider.Value) -ne $Value) {
        $script:FpsSlider.Value = $Value
    }
    Update-PresetStyles
    Update-WarningCard
}

function Get-VsyncChoice {
    if ($script:VsyncCombo.SelectedItem -and $script:VsyncCombo.SelectedItem.Tag) {
        return [string]$script:VsyncCombo.SelectedItem.Tag
    }
    return "keep"
}

function New-ConfigBackup {
    param([Parameter(Mandatory = $true)]$Config)

    Ensure-AppFolders
    $configBackupRoot = Join-Path $script:BackupRoot $Config.FolderName
    New-Item -Path $configBackupRoot -ItemType Directory -Force | Out-Null

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss_fff"
    $backupDir = Join-Path $configBackupRoot $timestamp
    New-Item -Path $backupDir -ItemType Directory -Force | Out-Null

    $engineExists = Test-Path $Config.EngineIni
    $manifest = [ordered]@{
        Created = (Get-Date).ToString("o")
        ToolVersion = $script:Version
        FolderName = $Config.FolderName
        ConfigDir = $Config.ConfigDir
        GameUserSettingsReadOnly = (Get-Item -LiteralPath $Config.GameUserSettings).IsReadOnly
        EngineIniExisted = $engineExists
        EngineIniReadOnly = $(if ($engineExists) { (Get-Item -LiteralPath $Config.EngineIni).IsReadOnly } else { $false })
    }

    Copy-Item -LiteralPath $Config.GameUserSettings -Destination (Join-Path $backupDir "GameUserSettings.ini") -Force
    if ($engineExists) {
        Copy-Item -LiteralPath $Config.EngineIni -Destination (Join-Path $backupDir "Engine.ini") -Force
    }

    [System.IO.File]::WriteAllText(
        (Join-Path $backupDir "manifest.json"),
        ($manifest | ConvertTo-Json),
        $script:Utf8NoBom
    )

    $oldBackups = @(
        Get-ChildItem -LiteralPath $configBackupRoot -Directory -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending
    )

    if ($oldBackups.Count -gt 20) {
        $oldBackups | Select-Object -Skip 20 | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }

    Add-Log (Format-T "backupCreated" @($backupDir))
    return $backupDir
}

function Restore-BackupDirectory {
    param(
        [Parameter(Mandatory = $true)]$Config,
        [Parameter(Mandatory = $true)][string]$BackupDir
    )

    $manifestPath = Join-Path $BackupDir "manifest.json"
    if (-not (Test-Path $manifestPath)) {
        throw "Backup manifest is missing."
    }

    $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    $backupGus = Join-Path $BackupDir "GameUserSettings.ini"
    $backupEngine = Join-Path $BackupDir "Engine.ini"

    if (-not (Test-Path $backupGus)) {
        throw "Backup GameUserSettings.ini is missing."
    }

    Set-FileReadOnly -Path $Config.GameUserSettings -ReadOnly $false
    Set-FileReadOnly -Path $Config.EngineIni -ReadOnly $false

    Copy-Item -LiteralPath $backupGus -Destination $Config.GameUserSettings -Force

    if ([bool]$manifest.EngineIniExisted) {
        if (-not (Test-Path $backupEngine)) {
            throw "Backup Engine.ini is missing."
        }
        Copy-Item -LiteralPath $backupEngine -Destination $Config.EngineIni -Force
    }
    elseif (Test-Path $Config.EngineIni) {
        Remove-Item -LiteralPath $Config.EngineIni -Force
    }

    Set-FileReadOnly -Path $Config.GameUserSettings -ReadOnly ([bool]$manifest.GameUserSettingsReadOnly)
    if (Test-Path $Config.EngineIni) {
        Set-FileReadOnly -Path $Config.EngineIni -ReadOnly ([bool]$manifest.EngineIniReadOnly)
    }
}

function Get-LatestBackup {
    param([Parameter(Mandatory = $true)]$Config)

    $roots = @(
        (Join-Path $script:BackupRoot $Config.FolderName),
        (Join-Path $script:LegacyBackupRoot $Config.FolderName)
    )

    $candidates = @()
    foreach ($root in $roots) {
        if (Test-Path $root) {
            $candidates += @(
                Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue
            )
        }
    }

    if ($candidates.Count -eq 0) {
        return $null
    }

    return $candidates |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
}

function Write-ConfigAtomically {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Content
    )

    $directory = Split-Path -Parent $Path
    $tempPath = Join-Path $directory (".dbd_fps_tool_{0}.tmp" -f ([guid]::NewGuid().ToString("N")))
    [System.IO.File]::WriteAllText($tempPath, $Content, $script:Utf8NoBom)
    Move-Item -LiteralPath $tempPath -Destination $Path -Force
}

function Set-UiBusy {
    param([bool]$Busy)
    $script:Busy = $Busy
    $script:ApplyButton.IsEnabled = -not $Busy
    $script:RefreshButton.IsEnabled = -not $Busy
    $script:RestoreButton.IsEnabled = -not $Busy
    $script:UnlockButton.IsEnabled = -not $Busy
    $script:OpenConfigButton.IsEnabled = -not $Busy
    $script:OpenBackupsButton.IsEnabled = -not $Busy
    $script:ConfigCombo.IsEnabled = -not $Busy
    $script:LanguageCombo.IsEnabled = -not $Busy
    $script:Window.Cursor = $(if ($Busy) { [System.Windows.Input.Cursors]::Wait } else { [System.Windows.Input.Cursors]::Arrow })
    [System.Windows.Threading.Dispatcher]::CurrentDispatcher.Invoke(
        [Action]{},
        [System.Windows.Threading.DispatcherPriority]::Background
    )
}

function Update-GameState {
    $running = Test-DbdRunning
    if ($running) {
        $script:GameStateText.Text = T "gameRunning"
        $script:GameStateText.Foreground = "#D74A5B"
    }
    else {
        $script:GameStateText.Text = T "gameClosed"
        $script:GameStateText.Foreground = "#A4ABB1"
    }
}

function Update-WarningCard {
    $fps = Get-RequestedFps -Silent
    if ($fps -eq 0) {
        return
    }

    if ($script:FixedMethodRadio.IsChecked) {
        $script:WarningText.Text = T "warningFixed"
        $script:WarningText.Foreground = "#E6AAB3"
        $script:WarningBorder.Background = "#DD1B0C11"
        $script:WarningBorder.BorderBrush = "#8A71111F"
    }
    elseif ($fps -gt 120) {
        $script:WarningText.Text = T "warningHighSafe"
        $script:WarningText.Foreground = "#E6B98B"
        $script:WarningBorder.Background = "#DD17110D"
        $script:WarningBorder.BorderBrush = "#745C3925"
    }
    else {
        $script:WarningText.Text = T "warningNormal"
        $script:WarningText.Foreground = "#B4C0C7"
        $script:WarningBorder.Background = "#DD0D1216"
        $script:WarningBorder.BorderBrush = "#5B39454D"
    }
}

function Refresh-Configuration {
    param([switch]$Repopulate)

    if ($Repopulate) {
        $current = Get-SelectedConfig
        $preferred = $(if ($current) { $current.FolderName } else { "" })
        Populate-ConfigCombo $preferred
    }

    $config = Get-SelectedConfig
    Update-GameState

    if (-not $config) {
        $script:StatusDot.Fill = "#D74A5B"
        $script:StatusText.Text = T "statusMissing"
        $script:DetectedValues.Text = T "waiting"
        return
    }

    if (-not (Test-Path $config.GameUserSettings)) {
        $script:StatusDot.Fill = "#D74A5B"
        $script:StatusText.Text = T "statusMissing"
        $script:DetectedValues.Text = T "waiting"
        return
    }

    try {
        $gusText = [System.IO.File]::ReadAllText($config.GameUserSettings)
        $engineText = $(if (Test-Path $config.EngineIni) { [System.IO.File]::ReadAllText($config.EngineIni) } else { "" })

        $gameFps = Get-IniValue $gusText "FrameRateLimit"
        if ([string]::IsNullOrWhiteSpace($gameFps)) {
            $gameFps = T "valueMissing"
        }

        $engineFps = Get-IniValue $engineText "t.MaxFPS"
        if ([string]::IsNullOrWhiteSpace($engineFps)) {
            $engineFps = T "valueMissing"
        }

        $fixedValue = Get-IniValue $engineText "bUseFixedFrameRate"
        $method = T "methodUnknown"
        if ($fixedValue -eq "True") {
            $method = T "methodFixed"
        }
        elseif (($engineText -match "; BEGIN DBD FPS UNLOCKER" -or $engineText -match "; BEGIN DBD FPS TOOL V4")) {
            $method = T "methodStandard"
        }

        $vsync = Get-IniValue $gusText "bUseVSync"
        if ([string]::IsNullOrWhiteSpace($vsync)) {
            $vsync = T "valueMissing"
        }

        $gusLocked = (Get-Item -LiteralPath $config.GameUserSettings).IsReadOnly
        $engineLocked = $(if (Test-Path $config.EngineIni) { (Get-Item -LiteralPath $config.EngineIni).IsReadOnly } else { $false })
        $locked = $gusLocked -or $engineLocked
        $lockedText = $(if ($locked) { T "yes" } else { T "no" })

        $script:DetectedValues.Text = Format-T "configLine" @($gameFps, $engineFps, $method, $vsync, $lockedText)
        $script:StatusDot.Fill = "#65B88A"
        $script:StatusText.Text = T "statusFound"
        Add-Log (Format-T "liveConfig" @($config.ConfigDir))
    }
    catch {
        $script:StatusDot.Fill = "#D74A5B"
        $script:StatusText.Text = T "statusMissing"
        $script:DetectedValues.Text = $_.Exception.Message
        Add-Log ("ERROR: {0}" -f $_.Exception.Message)
    }
}

function Apply-FpsSettings {
    if ($script:Busy) {
        return
    }

    $fps = Get-RequestedFps
    if ($fps -eq 0) {
        return
    }

    $config = Get-SelectedConfig
    if (-not $config) {
        [void](Show-Message (T "noConfig") "Error")
        return
    }

    if (Test-DbdRunning) {
        [void](Show-Message (T "closeGame") "Warning")
        return
    }

    if (-not (Test-Path $config.GameUserSettings)) {
        [void](Show-Message (T "filesMissing") "Error")
        return
    }

    $fixedMethod = [bool]$script:FixedMethodRadio.IsChecked

    if ($fixedMethod) {
        $answer = Show-Message (T "confirmFixed") "Question"
        if ($answer -ne [System.Windows.MessageBoxResult]::Yes) {
            return
        }
    }
    elseif ($fps -gt 120) {
        $answer = Show-Message (T "confirmHigh") "Question"
        if ($answer -ne [System.Windows.MessageBoxResult]::Yes) {
            return
        }
    }

    $backupDir = $null
    try {
        Set-UiBusy $true
        $backupDir = New-ConfigBackup $config

        Set-FileReadOnly -Path $config.GameUserSettings -ReadOnly $false
        Set-FileReadOnly -Path $config.EngineIni -ReadOnly $false

        if (-not (Test-Path $config.EngineIni)) {
            [System.IO.File]::WriteAllText($config.EngineIni, "", $script:Utf8NoBom)
        }

        $gusText = [System.IO.File]::ReadAllText($config.GameUserSettings)
        $engineText = [System.IO.File]::ReadAllText($config.EngineIni)

        $fpsFloat = "{0}.000000" -f $fps
        $gusText = Set-IniValue $gusText "FrameRateLimit" $fpsFloat
        $gusText = Set-IniValue $gusText "FPSLimit" ([string]$fps)
        $gusText = Set-IniValue $gusText "FPSLimitMode" "0"

        $vsyncChoice = Get-VsyncChoice
        if ($vsyncChoice -eq "off") {
            $gusText = Set-IniValue $gusText "bUseVSync" "False"
        }
        elseif ($vsyncChoice -eq "on") {
            $gusText = Set-IniValue $gusText "bUseVSync" "True"
        }
        else {
            Add-Log (T "keepLog")
        }

        $engineText = Remove-OurToolBlocks $engineText
        Add-Log (T "legacyCleaned")

        if ($fixedMethod) {
            $toolBlock = @"

; BEGIN DBD FPS UNLOCKER
[/Script/Engine.Engine]
bSmoothFrameRate=False
bUseFixedFrameRate=True
FixedFrameRate=$fpsFloat

[SystemSettings]
t.MaxFPS=$fps
; END DBD FPS UNLOCKER
"@
        }
        else {
            $toolBlock = @"

; BEGIN DBD FPS UNLOCKER
[SystemSettings]
t.MaxFPS=$fps
; END DBD FPS UNLOCKER
"@
        }

        $engineText = $engineText.TrimEnd() + "`r`n" + $toolBlock.TrimStart() + "`r`n"

        Write-ConfigAtomically $config.GameUserSettings $gusText
        Write-ConfigAtomically $config.EngineIni $engineText

        $verifyGus = [System.IO.File]::ReadAllText($config.GameUserSettings)
        $verifyEngine = [System.IO.File]::ReadAllText($config.EngineIni)

        if ((Get-IniValue $verifyGus "FrameRateLimit") -ne $fpsFloat) {
            throw "GameUserSettings.ini verification failed."
        }

        if ((Get-IniValue $verifyEngine "t.MaxFPS") -ne [string]$fps) {
            throw "Engine.ini verification failed."
        }

        if ($fixedMethod -and (Get-IniValue $verifyEngine "bUseFixedFrameRate") -ne "True") {
            throw "Fixed Frame Rate verification failed."
        }

        $lock = [bool]$script:LockFilesCheck.IsChecked
        Set-FileReadOnly -Path $config.GameUserSettings -ReadOnly $lock
        Set-FileReadOnly -Path $config.EngineIni -ReadOnly $lock

        Add-Log (Format-T "updated" @($config.ConfigDir))
        Add-Log $(if ($lock) { T "readOnlyOn" } else { T "readOnlyOff" })

        Save-AppSettings
        Refresh-Configuration
        [void](Show-Message (T "success") "Info")
    }
    catch {
        Add-Log ("ERROR: {0}" -f $_.Exception.Message)
        if ($backupDir -and (Test-Path $backupDir)) {
            try {
                Restore-BackupDirectory $config $backupDir
                Add-Log (T "rollback")
            }
            catch {
                Add-Log ("ROLLBACK ERROR: {0}" -f $_.Exception.Message)
            }
        }
        Refresh-Configuration
        [void](Show-Message ((T "applyFailed") + "`n`n" + $_.Exception.Message) "Error")
    }
    finally {
        Set-UiBusy $false
    }
}

function Restore-LatestBackup {
    if ($script:Busy) {
        return
    }

    $config = Get-SelectedConfig
    if (-not $config) {
        [void](Show-Message (T "noConfig") "Error")
        return
    }

    if (Test-DbdRunning) {
        [void](Show-Message (T "closeGame") "Warning")
        return
    }

    $backup = Get-LatestBackup $config
    if (-not $backup) {
        [void](Show-Message (T "noBackup") "Warning")
        return
    }

    $answer = Show-Message (T "restoreConfirm") "Question"
    if ($answer -ne [System.Windows.MessageBoxResult]::Yes) {
        return
    }

    try {
        Set-UiBusy $true
        Restore-BackupDirectory $config $backup.FullName
        Add-Log (Format-T "restored" @($backup.FullName))
        Refresh-Configuration
        [void](Show-Message (T "restoreSuccess") "Info")
    }
    catch {
        Add-Log ("ERROR: {0}" -f $_.Exception.Message)
        [void](Show-Message $_.Exception.Message "Error")
    }
    finally {
        Set-UiBusy $false
    }
}

function Unlock-SelectedConfig {
    $config = Get-SelectedConfig
    if (-not $config) {
        [void](Show-Message (T "noConfig") "Error")
        return
    }

    if (Test-DbdRunning) {
        [void](Show-Message (T "closeGame") "Warning")
        return
    }

    try {
        Set-FileReadOnly -Path $config.GameUserSettings -ReadOnly $false
        Set-FileReadOnly -Path $config.EngineIni -ReadOnly $false
        Add-Log (T "readOnlyOff")
        Refresh-Configuration
        [void](Show-Message (T "unlockSuccess") "Info")
    }
    catch {
        [void](Show-Message $_.Exception.Message "Error")
    }
}

function Open-SelectedConfig {
    $config = Get-SelectedConfig
    if (-not $config) {
        [void](Show-Message (T "noConfig") "Error")
        return
    }
    Start-Process -FilePath "explorer.exe" -ArgumentList @($config.ConfigDir)
}

function Open-BackupFolder {
    Ensure-AppFolders
    $config = Get-SelectedConfig
    $path = $(if ($config) { Join-Path $script:BackupRoot $config.FolderName } else { $script:BackupRoot })
    New-Item -Path $path -ItemType Directory -Force | Out-Null
    Start-Process -FilePath "explorer.exe" -ArgumentList @($path)
}



function Get-HelpKeys {
    param([string]$Topic)

    $titleKey = "helpDefaultTitle"
    $textKey = "helpDefaultText"
    $recommendationKey = "helpDefaultRec"

    switch ($Topic) {
        "fps" {
            $titleKey = "helpFpsTitle"
            $textKey = "helpFpsText"
            $recommendationKey = "helpFpsRec"
        }
        "safe" {
            $titleKey = "helpSafeTitle"
            $textKey = "helpSafeText"
            $recommendationKey = "helpSafeRec"
        }
        "fixed" {
            $titleKey = "helpFixedTitle"
            $textKey = "helpFixedText"
            $recommendationKey = "helpFixedRec"
        }
        "vsync" {
            $titleKey = "helpVsyncTitle"
            $textKey = "helpVsyncText"
            $recommendationKey = "helpVsyncRec"
        }
        "readonly" {
            $titleKey = "helpReadOnlyTitle"
            $textKey = "helpReadOnlyText"
            $recommendationKey = "helpReadOnlyRec"
        }
        "install" {
            $titleKey = "helpInstallTitle"
            $textKey = "helpInstallText"
            $recommendationKey = "helpInstallRec"
        }
        "apply" {
            $titleKey = "helpApplyTitle"
            $textKey = "helpApplyText"
            $recommendationKey = "helpApplyRec"
        }
        "restore" {
            $titleKey = "helpRestoreTitle"
            $textKey = "helpRestoreText"
            $recommendationKey = "helpRestoreRec"
        }
        "unlock" {
            $titleKey = "helpUnlockTitle"
            $textKey = "helpUnlockText"
            $recommendationKey = "helpUnlockRec"
        }
        "language" {
            $titleKey = "helpLanguageTitle"
            $textKey = "helpLanguageText"
            $recommendationKey = "helpLanguageRec"
        }
        "detected" {
            $titleKey = "helpDetectedTitle"
            $textKey = "helpDetectedText"
            $recommendationKey = "helpDetectedRec"
        }
        "refresh" {
            $titleKey = "helpRefreshTitle"
            $textKey = "helpRefreshText"
            $recommendationKey = "helpRefreshRec"
        }
    }

    return @($titleKey, $textKey, $recommendationKey)
}

function New-HelpToolTip {
    param([string]$Topic)

    $keys = Get-HelpKeys $Topic

    $root = New-Object System.Windows.Controls.StackPanel
    $root.MaxWidth = 390
    if ($script:CurrentLanguage -eq "he") {
        $root.FlowDirection = [System.Windows.FlowDirection]::RightToLeft
    }
    else {
        $root.FlowDirection = [System.Windows.FlowDirection]::LeftToRight
    }

    $eyebrow = New-Object System.Windows.Controls.TextBlock
    $eyebrow.Text = T "helpLabel"
    $eyebrow.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#C21F35")
    $eyebrow.FontSize = 10
    $eyebrow.FontWeight = [System.Windows.FontWeights]::Bold
    $eyebrow.Margin = New-Object System.Windows.Thickness(0, 0, 0, 5)
    [void]$root.Children.Add($eyebrow)

    $title = New-Object System.Windows.Controls.TextBlock
    $title.Text = T $keys[0]
    $title.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FFFFFF")
    $title.FontSize = 15
    $title.FontWeight = [System.Windows.FontWeights]::Bold
    $title.TextWrapping = [System.Windows.TextWrapping]::Wrap
    $title.Margin = New-Object System.Windows.Thickness(0, 0, 0, 7)
    [void]$root.Children.Add($title)

    $body = New-Object System.Windows.Controls.TextBlock
    $body.Text = T $keys[1]
    $body.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#C6CDD2")
    $body.FontSize = 12
    $body.LineHeight = 19
    $body.TextWrapping = [System.Windows.TextWrapping]::Wrap
    [void]$root.Children.Add($body)

    $recommendationBorder = New-Object System.Windows.Controls.Border
    $recommendationBorder.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#331E0D12")
    $recommendationBorder.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#7AC21F35")
    $recommendationBorder.BorderThickness = New-Object System.Windows.Thickness(1)
    $recommendationBorder.CornerRadius = New-Object System.Windows.CornerRadius(3)
    $recommendationBorder.Padding = New-Object System.Windows.Thickness(10, 8, 10, 8)
    $recommendationBorder.Margin = New-Object System.Windows.Thickness(0, 10, 0, 0)

    $recommendation = New-Object System.Windows.Controls.TextBlock
    $recommendation.Text = T $keys[2]
    $recommendation.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#F0D1D6")
    $recommendation.FontSize = 12
    $recommendation.FontWeight = [System.Windows.FontWeights]::SemiBold
    $recommendation.TextWrapping = [System.Windows.TextWrapping]::Wrap
    $recommendationBorder.Child = $recommendation
    [void]$root.Children.Add($recommendationBorder)

    $toolTip = New-Object System.Windows.Controls.ToolTip
    $toolTip.Style = $script:Window.Resources["DbDToolTipStyle"]
    $toolTip.Placement = [System.Windows.Controls.Primitives.PlacementMode]::MousePoint
    $toolTip.HorizontalOffset = 16
    $toolTip.VerticalOffset = 18
    $toolTip.Content = $root

    return $toolTip
}

function Set-HelpToolTip {
    param(
        [Parameter(Mandatory = $true)]$Control,
        [Parameter(Mandatory = $true)][string]$Topic
    )

    $toolTip = New-HelpToolTip $Topic
    [System.Windows.Controls.ToolTipService]::SetToolTip($Control, $toolTip)
    [System.Windows.Controls.ToolTipService]::SetInitialShowDelay($Control, 900)
    [System.Windows.Controls.ToolTipService]::SetBetweenShowDelay($Control, 120)
    [System.Windows.Controls.ToolTipService]::SetShowDuration($Control, 30000)
    [System.Windows.Controls.ToolTipService]::SetShowOnDisabled($Control, $true)
}

function Apply-AllToolTips {
    foreach ($control in @(
        $script:FpsTextBox,
        $script:FpsSlider,
        $script:Preset120,
        $script:Preset144,
        $script:Preset165,
        $script:Preset240,
        $script:Preset360,
        $script:TargetTitle,
        $script:FpsHelpIcon
    )) {
        Set-HelpToolTip $control "fps"
    }

    foreach ($control in @(
        $script:SafeMethodRadio,
        $script:SafeMethodTitle,
        $script:SafeMethodDesc,
        $script:SafeHelpIcon
    )) {
        Set-HelpToolTip $control "safe"
    }

    foreach ($control in @(
        $script:FixedMethodRadio,
        $script:FixedMethodTitle,
        $script:FixedMethodDesc,
        $script:FixedHelpIcon
    )) {
        Set-HelpToolTip $control "fixed"
    }

    foreach ($control in @(
        $script:VsyncLabel,
        $script:VsyncCombo,
        $script:VsyncHelpIcon
    )) {
        Set-HelpToolTip $control "vsync"
    }

    foreach ($control in @(
        $script:LockFilesCheck,
        $script:LockFilesDesc,
        $script:ReadOnlyHelpIcon
    )) {
        Set-HelpToolTip $control "readonly"
    }

    foreach ($control in @(
        $script:ConfigLabel,
        $script:ConfigCombo,
        $script:ConfigHelpIcon,
        $script:OpenConfigButton
    )) {
        Set-HelpToolTip $control "install"
    }

    foreach ($control in @(
        $script:LanguageLabel,
        $script:LanguageCombo,
        $script:LanguageHelpIcon
    )) {
        Set-HelpToolTip $control "language"
    }

    foreach ($control in @(
        $script:DetectedTitle,
        $script:DetectedValues,
        $script:ActualFpsNote,
        $script:DetectedHelpIcon
    )) {
        Set-HelpToolTip $control "detected"
    }

    Set-HelpToolTip $script:ApplyButton "apply"
    Set-HelpToolTip $script:RestoreButton "restore"
    Set-HelpToolTip $script:OpenBackupsButton "restore"
    Set-HelpToolTip $script:UnlockButton "unlock"
    Set-HelpToolTip $script:RefreshButton "refresh"
}

function Apply-Language {
    param([string]$LanguageCode)

    if (-not $script:Translations.ContainsKey($LanguageCode)) {
        $LanguageCode = "en"
    }

    $script:CurrentLanguage = $LanguageCode

    $script:Window.Title = "{0} v{1}" -f (T "title"), $script:Version
    $script:TitleText.Text = T "title"
    $script:SubtitleText.Text = T "subtitle"
    $script:LanguageLabel.Text = T "language"
    $script:ConfigLabel.Text = T "config"
    $script:StatusText.Text = T "statusChecking"
    $script:TargetTitle.Text = T "target"
    $script:DetectedTitle.Text = T "detected"
    $script:ActualFpsNote.Text = T "actualNote"
    $script:MethodTitle.Text = T "method"
    $script:SafeMethodTitle.Text = T "safeTitle"
    $script:SafeMethodDesc.Text = T "safeDesc"
    $script:FixedMethodTitle.Text = T "fixedTitle"
    $script:FixedMethodDesc.Text = T "fixedDesc"
    $script:OptionsTitle.Text = T "options"
    $script:VsyncLabel.Text = T "vsync"
    $script:LockFilesCheck.Content = T "lock"
    $script:LockFilesDesc.Text = T "lockDesc"
    $script:ApplyButton.Content = T "apply"
    $script:RefreshButton.Content = T "refresh"
    $script:RestoreButton.Content = T "restore"
    $script:UnlockButton.Content = T "unlock"
    $script:OpenConfigButton.Content = T "openConfig"
    $script:OpenBackupsButton.Content = T "openBackups"
    $script:LogExpander.Header = T "log"
    $script:FooterText.Text = T "footer"
    $script:VsyncCombo.Items[0].Content = T "keep"
    $script:VsyncCombo.Items[1].Content = T "off"
    $script:VsyncCombo.Items[2].Content = T "on"

    if ($LanguageCode -eq "he") {
        $script:Window.FlowDirection = [System.Windows.FlowDirection]::RightToLeft
        $script:FpsTextBox.FlowDirection = [System.Windows.FlowDirection]::LeftToRight
        $script:DetectedValues.FlowDirection = [System.Windows.FlowDirection]::RightToLeft
        $script:LogTextBox.FlowDirection = [System.Windows.FlowDirection]::LeftToRight
    }
    else {
        $script:Window.FlowDirection = [System.Windows.FlowDirection]::LeftToRight
        $script:FpsTextBox.FlowDirection = [System.Windows.FlowDirection]::LeftToRight
        $script:DetectedValues.FlowDirection = [System.Windows.FlowDirection]::LeftToRight
        $script:LogTextBox.FlowDirection = [System.Windows.FlowDirection]::LeftToRight
    }

    $current = Get-SelectedConfig
    $preferred = $(if ($current) { $current.FolderName } else { "" })
    Populate-ConfigCombo $preferred
    Update-PresetStyles
    Update-WarningCard
    Refresh-Configuration
    Apply-AllToolTips
}

# Load and parse the XAML.
$xamlPath = Join-Path $PSScriptRoot "DBD_FPS_Unlocker.xaml"
if (-not (Test-Path $xamlPath)) {
    [System.Windows.MessageBox]::Show("DBD_FPS_Unlocker.xaml is missing.", "DBD FPS Unlocker", "OK", "Error") | Out-Null
    exit 1
}

[xml]$xaml = Get-Content -LiteralPath $xamlPath -Raw
$reader = New-Object System.Xml.XmlNodeReader $xaml
$script:Window = [Windows.Markup.XamlReader]::Load($reader)

$controlNames = @(
    "TitleText", "SubtitleText", "LanguageLabel", "LanguageCombo",
    "StatusDot", "StatusText", "GameStateText", "ConfigLabel", "ConfigCombo",
    "TargetTitle", "FpsTextBox", "FpsSlider",
    "Preset120", "Preset144", "Preset165", "Preset240", "Preset360",
    "DetectedTitle", "DetectedValues", "ActualFpsNote",
    "MethodTitle", "SafeMethodRadio", "SafeMethodTitle", "SafeMethodDesc",
    "FixedMethodRadio", "FixedMethodTitle", "FixedMethodDesc",
    "OptionsTitle", "VsyncLabel", "VsyncCombo", "LockFilesCheck", "LockFilesDesc",
    "LanguageHelpIcon", "ConfigHelpIcon", "FpsHelpIcon", "DetectedHelpIcon",
    "SafeHelpIcon", "FixedHelpIcon", "VsyncHelpIcon", "ReadOnlyHelpIcon",
    "WarningBorder", "WarningText", "ApplyButton",
    "RefreshButton", "RestoreButton", "UnlockButton", "OpenConfigButton", "OpenBackupsButton",
    "LogExpander", "LogTextBox", "FooterText"
)

foreach ($name in $controlNames) {
    Set-Variable -Name $name -Value $script:Window.FindName($name) -Scope Script
    if ($null -eq (Get-Variable -Name $name -Scope Script).Value) {
        throw "Required UI control was not found: $name"
    }
}

Ensure-AppFolders
$appSettings = Load-AppSettings

# Initial UI state.
for ($i = 0; $i -lt $script:LanguageCombo.Items.Count; $i++) {
    if ([string]$script:LanguageCombo.Items[$i].Tag -eq [string]$appSettings.Language) {
        $script:LanguageCombo.SelectedIndex = $i
        break
    }
}

Set-FpsValue ([int]$appSettings.Fps)
$script:FixedMethodRadio.IsChecked = ([string]$appSettings.Method -eq "fixed")
$script:SafeMethodRadio.IsChecked = -not [bool]$script:FixedMethodRadio.IsChecked
$script:LockFilesCheck.IsChecked = [bool]$appSettings.LockFiles

for ($i = 0; $i -lt $script:VsyncCombo.Items.Count; $i++) {
    if ([string]$script:VsyncCombo.Items[$i].Tag -eq [string]$appSettings.Vsync) {
        $script:VsyncCombo.SelectedIndex = $i
        break
    }
}

Populate-ConfigCombo ([string]$appSettings.ConfigFolder)
Apply-Language ([string]$appSettings.Language)

# Events.
$script:Preset120.Add_Click({ Set-FpsValue 120 })
$script:Preset144.Add_Click({ Set-FpsValue 144 })
$script:Preset165.Add_Click({ Set-FpsValue 165 })
$script:Preset240.Add_Click({ Set-FpsValue 240 })
$script:Preset360.Add_Click({ Set-FpsValue 360 })

$script:FpsSlider.Add_ValueChanged({
    if ($script:Initializing) {
        return
    }
    $value = [int][Math]::Round($script:FpsSlider.Value)
    if ($script:FpsTextBox.Text -ne [string]$value) {
        $script:FpsTextBox.Text = [string]$value
    }
    Update-PresetStyles
    Update-WarningCard
})

$script:FpsTextBox.Add_LostFocus({
    $value = Get-RequestedFps -Silent
    if ($value -eq 0) {
        Set-FpsValue 165
    }
    else {
        Set-FpsValue $value
    }
})

$script:FpsTextBox.Add_PreviewTextInput({
    param($sender, $eventArgs)
    $eventArgs.Handled = -not ($eventArgs.Text -match "^[0-9]+$")
})

$script:SafeMethodRadio.Add_Checked({ Update-WarningCard })
$script:FixedMethodRadio.Add_Checked({ Update-WarningCard })
$script:ApplyButton.Add_Click({ Apply-FpsSettings })
$script:RefreshButton.Add_Click({ Refresh-Configuration -Repopulate })
$script:RestoreButton.Add_Click({ Restore-LatestBackup })
$script:UnlockButton.Add_Click({ Unlock-SelectedConfig })
$script:OpenConfigButton.Add_Click({ Open-SelectedConfig })
$script:OpenBackupsButton.Add_Click({ Open-BackupFolder })

$script:ConfigCombo.Add_SelectionChanged({
    if (-not $script:Initializing) {
        Refresh-Configuration
        Save-AppSettings
    }
})

$script:VsyncCombo.Add_SelectionChanged({
    if (-not $script:Initializing) {
        Save-AppSettings
    }
})

$script:LockFilesCheck.Add_Checked({ if (-not $script:Initializing) { Save-AppSettings } })
$script:LockFilesCheck.Add_Unchecked({ if (-not $script:Initializing) { Save-AppSettings } })

$script:LanguageCombo.Add_SelectionChanged({
    if ($script:Initializing) {
        return
    }

    $selected = $script:LanguageCombo.SelectedItem
    if ($selected -and $selected.Tag) {
        Apply-Language ([string]$selected.Tag)
        Save-AppSettings
    }
})

$script:Window.Add_Closing({
    Save-AppSettings
})

$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(2)
$timer.Add_Tick({ Update-GameState })
$timer.Start()

$script:Initializing = $false
Update-WarningCard
Apply-AllToolTips
Refresh-Configuration
Add-Log ("DBD FPS Unlocker v{0} started." -f $script:Version)

[void]$script:Window.ShowDialog()
