#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance force
DetectHiddenWindows, On
DetectHiddenText, On
CoordMode Mouse, Screen
CoordMode Pixel, Screen
SetTitleMatchMode, 2
Process, Priority,, High
SetBatchLines, -1
SetKeyDelay, -1, -1
SetControlDelay, -1
SetMouseDelay, -1
SetWinDelay, -1

CommandLine := DllCall("GetCommandLine", "Str")
If !(A_IsAdmin || RegExMatch(CommandLine, " /restart(?!\S)")) {
    Try {
        If (A_IsCompiled)
            Run *RunAs "%A_ScriptFullPath%" /restart
        Else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}

scriptActive := false

F9::
ToggleScript()
Return

XButton2::
if (scriptActive) {
    while GetKeyState("XButton2", "P") {
        Click
        Random, randSleep, 95, 105 ; Рандомизация кликов на ±5 мс
        Sleep randSleep
    }
} else {
    Send {XButton2}
}
Return

ToggleScript() {
    global scriptActive
    scriptActive := !scriptActive
    if (scriptActive) {
        ToolTip, Script is ON, %A_CursorX%, %A_CursorY%
    } else {
        ToolTip, Script is OFF, %A_CursorX%, %A_CursorY%
    }
    SetTimer, RemoveToolTip, -1000
    Return
}

RemoveToolTip:
ToolTip
Return

Menu, Tray, NoStandard
Menu, Tray, DeleteAll
Menu, Tray, Add, Reload, ReloadScript
Menu, Tray, Icon, Reload, shell32.dll, 239, 16
Menu, Tray, Default, Reload
Menu, Tray, Add
Menu, Tray, Add, Exit, ExitScript
Menu, Tray, Icon, Exit, shell32.dll, 28, 16
Menu, Tray, Icon, imageres.dll, 80
Return

ReloadScript:
Reload
Return

ExitScript:
ExitApp
Return
