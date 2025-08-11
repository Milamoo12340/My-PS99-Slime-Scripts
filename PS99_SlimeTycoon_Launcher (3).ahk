; PS99 Slime Tycoon & Multi-Feature Launcher
; Works with any version of AutoHotkey
; Comprehensive launcher for Update 54 content

; Basic Settings
SetBatchLines -1
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force

; Create GUI
Gui, +AlwaysOnTop +ToolWindow
Gui, Color, 0x2D2D2D
Gui, Font, s10 cWhite, Segoe UI
Gui, Add, GroupBox, x10 y10 w380 h90, Select Feature to Launch
Gui, Add, Radio, x20 y35 w180 h20 vMultiAccount Checked, Multi-Account Manager
Gui, Add, Radio, x20 y60 w180 h20 vSlimeTycoon, Slime Tycoon Optimizer
Gui, Add, Radio, x205 y35 w180 h20 vMining, Mining Automation
Gui, Add, Radio, x205 y60 w180 h20 vLuckBoost, Luck Enhancement

Gui, Add, GroupBox, x10 y110 w380 h90, Configuration Options
Gui, Add, Checkbox, x20 y135 w180 h20 vEnableAntiDetection Checked, Enable Anti-Detection
Gui, Add, Text, x205 y135 w90 h20, Detection Level:
Gui, Add, DropDownList, x295 y135 w85 h120 vAntiDetectLevel Choose3, 1|2|3|4|5
Gui, Add, Checkbox, x20 y160 w180 h20 vAutoLaunch, Launch Roblox Automatically
Gui, Add, Text, x205 y160 w90 h20, Launch Delay:
Gui, Add, Edit, x295 y160 w50 h20 vLaunchDelay, 5
Gui, Add, Text, x350 y160 w30 h20, sec

Gui, Add, GroupBox, x10 y210 w380 h110, Quick Settings
Gui, Add, Text, x20 y235 w120 h20, Optimization Focus:
Gui, Add, DropDownList, x145 y235 w235 h120 vOptimizationFocus Choose1, Balanced (Recommended)|Maximum Conveyor Points|Maximum Damage Output

Gui, Add, Text, x20 y265 w120 h20, Target Priority:
Gui, Add, DropDownList, x145 y265 w235 h120 vTargetPriority Choose1, Titanic & Huge Pets|Rainbow Variants|Shiny Variants|All Rare Types

Gui, Add, Text, x20 y295 w120 h20, Game Stage:
Gui, Add, DropDownList, x145 y295 w235 h120 vGameStage Choose1, Auto-Detect|Early Game (0-20)|Mid Game (21-50)|Late Game (51+)

Gui, Add, Button, x10 y330 w380 h40 gLaunchFeature, LAUNCH SELECTED FEATURE

Gui, Show, w400 h380, PS99 Ultimate Feature Launcher
return

LaunchFeature:
    Gui, Submit, NoHide
    
    if (MultiAccount) {
        Launch("PS99_MultiAccount_Manager.ahk")
    } else if (SlimeTycoon) {
        Launch("PS99_SlimeTycoon_Optimizer.ahk")
    } else if (Mining) {
        Launch("PS99StealthMiner.ahk")
    } else if (LuckBoost) {
        Launch("PS99_EnhancedLuckAPI_Helper.ahk")
    }
return

Launch(script) {
    ; Check if script exists
    if (!FileExist(script)) {
        MsgBox, 16, Error, Could not find script: %script%
        return
    }
    
    ; Launch the script
    Run, %script%
    
    ; Confirmation
    MsgBox, 64, Success, Successfully launched: %script%
    
    ; Close this launcher
    ExitApp
}

GuiClose:
GuiEscape:
    ExitApp
return
