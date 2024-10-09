#Include aini.ahk

ahkay := aini("ahkay.ini")
ahkay.UpdateSections("startup", "misc")
ahkay["startup"].UpdateDefaults(Map(
    "shortcut", true,
    "shortcut_file", A_AppData "\Microsoft\Windows\Start Menu\Programs\Startup\ahkay.ahk.lnk"
))