#Include aini.ahk

ahkay_opts_dir := A_AppData "\ahkay"
if not DirExist(ahkay_opts_dir)
    DirCreate(ahkay_opts_dir)
/** @var {aini} ahkay */
ahkay := aini(ahkay_opts_dir "\ahkay.ini")
ahkay.UpdateSections("startup", "misc")
ahkay["startup"].UpdateDefaults(Map(
    "shortcut", true,
    "shortcut_file", A_AppData "\Microsoft\Windows\Start Menu\Programs\Startup\ahkay.ahk.lnk"
))