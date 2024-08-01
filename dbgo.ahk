#Requires AutoHotkey v2.0+
dbgo(_subject?, _message?) {
    OutputDebug("[_ " (_subject ?? A_ScriptName) " _] " (_message ?? (A_Hour ":" A_Min ":" A_Sec ":" A_MSec)) "`n")
}
