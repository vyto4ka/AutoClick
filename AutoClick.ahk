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

Menu, Tray, NoStandard
Menu, Tray, DeleteAll
Menu, Tray, Add, Reload, ReloadScript
Menu, Tray, Icon, Reload, shell32.dll, 239, 16
Menu, Tray, Default, Reload
Menu, Tray, Add
Menu, Tray, Add, Exit, ExitScript

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
mode := "autoclick"

F9::ToggleScript()
F10::SwitchMode()

XButton2::
if (scriptActive) {
    if (mode = "autoclick") {
        while GetKeyState("XButton2", "P") {
            Click
            Random, randSleep, 95, 105
            Sleep randSleep
        }
    } else if (mode = "soljer_11") {
        While GetKeyState("XButton2", "P") {
            ; Начало алгоритма
            Sleep, 260
            if !GetKeyState("XButton2", "P") ; Проверка, была ли отжата кнопка
                Break
            Send {LButton up}
            Send {LButton}
            Sleep, 350
            if !GetKeyState("XButton2", "P")
                Break
            Send {LButton}
            Sleep, 670
            if !GetKeyState("XButton2", "P")
                Break
            Send {LButton}
            if !GetKeyState("XButton2", "P")
                Break
            Send {LButton}
        }
        KeyWait, XButton2, D ; Ждем отпускания кнопки, чтобы сбросить
        Send {LButton up} ; Отпустить кнопку в конце
    }
} else {
    Send {XButton2}
}
Return

SwitchMode() {
    global mode
    mode := (mode = "autoclick") ? "soljer_11" : "autoclick"
    ToolTip, % "Mode: " . mode, %A_CursorX%, %A_CursorY%
    SetTimer, RemoveToolTip, -1000
}

ToggleScript() {
    global scriptActive
    scriptActive := !scriptActive
    ToolTip, % "Script is " . (scriptActive ? "ON" : "OFF"), %A_CursorX%, %A_CursorY%
    SetTimer, RemoveToolTip, -1000
    Return
}

RemoveToolTip:
ToolTip
Return

ReloadScript:
Reload
Return

ExitScript:
ExitApp
Return
