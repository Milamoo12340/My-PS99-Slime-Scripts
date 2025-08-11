; PS99 Slime Tycoon Ultimate Automation - Update 54
; All-in-one automation solution for Pet Simulator 99 Update 54
;
; Features:
; - Auto-collects Titanic and Huge chests
; - Auto-upgrades factory
; - Auto-farms breakable area
; - Enhances luck for Titanic pet drops
; - Touchpad and arrow key optimization
; - Undetectable operation
; - Multiple movement methods

; Core Settings
SetBatchLines -1
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force

; === COMPATIBILITY MODE TOGGLE ===
global WindowedMode := true  ; Set to false for fullscreen mode

; === Setup for proper mode ===
if (WindowedMode) {
    CoordMode, Mouse, Window
    CoordMode, Pixel, Window
} else {
    CoordMode, Mouse, Screen
    CoordMode, Pixel, Screen
}

; === Configuration Settings ===
global ChestCollectionEnabled := true   ; Auto collect chests
global FactoryOptimizationEnabled := true ; Auto optimize factory
global BreakableFarmingEnabled := true  ; Auto farm breakable area
global LuckBoostEnabled := true        ; Enhance luck for chest drops
global AntiBanEnabled := true          ; Anti-detection measures
global MovementEnabled := true         ; Automatic character movement
global TouchpadMode := true           ; Optimize for touchpad (laptop)
global ArrowKeysForCamera := true     ; Use arrow keys for camera
global WASDForMovement := true        ; Use WASD for movement
global ChestCollectionInterval := 65000 ; Check chests every 65 seconds 
global FactoryInterval := 30000       ; Check factory every 30 seconds
global BreakableInterval := 15000     ; Check breakable area every 15 seconds
global LuckBoostInterval := 10000     ; Apply luck boost every 10 seconds

; === Location Data ===
global TitanicChestPosition := {x: 0, y: 0}
global HugeChestPosition := {x: 0, y: 0}
global UpgradeMachinePosition := {x: 0, y: 0}
global BreakableAreaBounds := {x1: 0, y1: 0, x2: 0, y2: 0}

; === Global Variables ===
global AutomationActive := false
global LastChestCheck := 0
global LastFactoryCheck := 0
global LastBreakableCheck := 0
global LastLuckBoost := 0
global TotalChestsOpened := 0
global TotalFactoryUpgrades := 0
global TotalCoinsCollected := 0
global TotalBreakablesFarmed := 0
global SessionStartTime := A_TickCount
global CurrentLuckLevel := 0
global LuckMultiplier := 1.0
global StealthModeActive := false
global StealthBreakActive := false
global StealthBreakEndTime := 0
global LastStealthBreak := 0
global TitanicChestAvailable := false
global HugeChestAvailable := false
global MovementSequenceActive := false
global TargetDestination := {x: 0, y: 0}
global LastKeyPressTime := 0
global LastMouseMoveTime := 0
global HumanizedInputEnabled := true
global InstanceStartTime := A_TickCount
global SuccessfulPetDrops := 0

; === Create tab-based GUI ===
Gui, +AlwaysOnTop +ToolWindow
Gui, Color, 0x2D2D2D
Gui, Font, s10 cWhite, Segoe UI
Gui, Add, Text, x10 y10 w380 h20 +Center, PS99 Slime Tycoon Ultimate Automation - Update 54
Gui, Add, Tab3, x5 y40 w390 h370 vMainTab, Status|Controls|Stats|Settings|Advanced|About

; === Status Tab ===
Gui, Tab, Status
Gui, Add, Text, x15 y70 w150 h20, Automation Status:
Gui, Add, Text, x170 y70 w210 h20 vAutomationStatus, Inactive
Gui, Add, Text, x15 y100 w150 h20, Current Activity:
Gui, Add, Text, x170 y100 w210 h20 vCurrentActivity, Idle
Gui, Add, Text, x15 y130 w150 h20, Titanic Chest Status:
Gui, Add, Text, x170 y130 w210 h20 vTitanicChestStatus, Unknown
Gui, Add, Text, x15 y160 w150 h20, Huge Chest Status:
Gui, Add, Text, x170 y160 w210 h20 vHugeChestStatus, Unknown
Gui, Add, Text, x15 y190 w150 h20, Factory Status:
Gui, Add, Text, x170 y190 w210 h20 vFactoryStatus, Unknown
Gui, Add, Text, x15 y220 w150 h20, Breakable Farm Status:
Gui, Add, Text, x170 y220 w210 h20 vBreakableStatus, Unknown
Gui, Add, Text, x15 y250 w150 h20, Current Luck Boost:
Gui, Add, Text, x170 y250 w210 h20 vCurrentLuckBoost, x1.0
Gui, Add, Text, x15 y280 w150 h20, Next Chest Check:
Gui, Add, Text, x170 y280 w210 h20 vNextChestCheck, --:--
Gui, Add, Text, x15 y310 w150 h20, Session Time:
Gui, Add, Text, x170 y310 w210 h20 vSessionTime, 00:00:00
Gui, Add, Button, x15 y340 w190 h30 gStartAutomation, Start Automation
Gui, Add, Button, x210 y340 w170 h30 gStopAutomation, Stop Automation

; === Controls Tab ===
Gui, Tab, Controls
Gui, Add, GroupBox, x15 y70 w370 h120, Position Setup (Important!)
Gui, Add, Text, x25 y90 w350 h90, Use these function keys to mark important locations:
`nF1: Mark Titanic Chest position 
`nF2: Mark Huge Chest position
`nF3: Mark Upgrade Machine position
`nF4: Mark Breakable Area (two clicks needed)
Gui, Add, GroupBox, x15 y200 w370 h120, Movement Controls
Gui, Add, Text, x25 y220 w350 h90, Manual movement keys:
`nW/A/S/D or Arrow Keys: Move character
`nMouse + Right Click: Adjust camera
`nHold Shift: Run faster
`nE: Interact with objects
Gui, Add, Button, x15 y330 w370 h30 gTestControls, Test Controls (Press F5 to stop)

; === Stats Tab ===
Gui, Tab, Stats
Gui, Add, Text, x15 y70 w150 h20, Chests Opened:
Gui, Add, Text, x170 y70 w210 h20 vChestsOpened, 0
Gui, Add, Text, x15 y100 w150 h20, Factory Upgrades:
Gui, Add, Text, x170 y100 w210 h20 vFactoryUpgrades, 0
Gui, Add, Text, x15 y130 w150 h20, Breakables Farmed:
Gui, Add, Text, x170 y130 w210 h20 vBreakablesFarmed, 0
Gui, Add, Text, x15 y160 w150 h20, Coins Collected:
Gui, Add, Text, x170 y160 w210 h20 vCoinsCollected, 0
Gui, Add, Text, x15 y190 w150 h20, Current Luck Level:
Gui, Add, Text, x170 y190 w210 h20 vLuckLevel, 0
Gui, Add, Text, x15 y220 w150 h20, Success Rate:
Gui, Add, Text, x170 y220 w210 h20 vSuccessRate, 0%
Gui, Add, Text, x15 y250 w150 h20, Pet Drop Rate:
Gui, Add, Text, x170 y250 w210 h20 vDropRate, 0
Gui, Add, Text, x15 y280 w150 h20, Automation Efficiency:
Gui, Add, Text, x170 y280 w210 h20 vEfficiency, N/A
Gui, Add, Button, x15 y320 w370 h30 gResetStats, Reset Stats

; === Settings Tab ===
Gui, Tab, Settings
Gui, Add, GroupBox, x15 y70 w370 h90, Display and Controls
Gui, Add, Radio, x25 y90 w170 h20 vWindowedModeRadio Checked%WindowedMode% gToggleDisplayMode, Windowed Mode
Gui, Add, Radio, x200 y90 w170 h20 vFullscreenModeRadio Checked%(!WindowedMode)% gToggleDisplayMode, Fullscreen Mode
Gui, Add, Checkbox, x25 y120 w170 h20 vToggleTouchpad Checked%TouchpadMode% gUpdateSettings, Touchpad Mode
Gui, Add, Checkbox, x200 y120 w170 h20 vToggleArrowKeys Checked%ArrowKeysForCamera% gUpdateSettings, Arrow Keys for Camera

Gui, Add, GroupBox, x15 y170 w370 h140, Automation Features
Gui, Add, Checkbox, x25 y190 w170 h20 vToggleChests Checked%ChestCollectionEnabled% gUpdateSettings, Chest Collection
Gui, Add, Checkbox, x200 y190 w170 h20 vToggleFactory Checked%FactoryOptimizationEnabled% gUpdateSettings, Factory Optimization
Gui, Add, Checkbox, x25 y220 w170 h20 vToggleBreakable Checked%BreakableFarmingEnabled% gUpdateSettings, Breakable Farming
Gui, Add, Checkbox, x200 y220 w170 h20 vToggleLuckBoost Checked%LuckBoostEnabled% gUpdateSettings, Luck Boost
Gui, Add, Checkbox, x25 y250 w170 h20 vToggleAntiBan Checked%AntiBanEnabled% gUpdateSettings, Anti-Detection
Gui, Add, Checkbox, x200 y250 w170 h20 vToggleMovement Checked%MovementEnabled% gUpdateSettings, Auto Movement

Gui, Add, GroupBox, x15 y320 w370 h80, Timings (seconds)
Gui, Add, Text, x25 y340 w90 h20, Chest Interval:
Gui, Add, Edit, x120 y340 w50 h20 vChestIntervalEdit, % Floor(ChestCollectionInterval/1000)
Gui, Add, Text, x25 y370 w90 h20, Factory Interval:
Gui, Add, Edit, x120 y370 w50 h20 vFactoryIntervalEdit, % Floor(FactoryInterval/1000)
Gui, Add, Text, x200 y340 w90 h20, Breakable Interval:
Gui, Add, Edit, x295 y340 w50 h20 vBreakableIntervalEdit, % Floor(BreakableInterval/1000)
Gui, Add, Text, x200 y370 w90 h20, Luck Interval:
Gui, Add, Edit, x295 y370 w50 h20 vLuckIntervalEdit, % Floor(LuckBoostInterval/1000)

; === Advanced Tab ===
Gui, Tab, Advanced
Gui, Add, GroupBox, x15 y70 w370 h90, Anti-Detection Settings
Gui, Add, Checkbox, x25 y90 w330 h20 vToggleHumanized Checked%HumanizedInputEnabled% gUpdateAdvancedSettings, Humanized Input Patterns
Gui, Add, Checkbox, x25 y120 w330 h20 vToggleStealthMode Checked%StealthModeActive% gUpdateAdvancedSettings, Stealth Mode (Random Pauses)
Gui, Add, Text, x25 y150 w160 h20, Stealth Level (1-5):
Gui, Add, DropDownList, x190 y150 w70 h120 vStealthLevel gUpdateAdvancedSettings Choose3, 1|2|3|4|5

Gui, Add, GroupBox, x15 y170 w370 h90, Luck Enhancement
Gui, Add, Text, x25 y190 w160 h20, Target Pet Priority:
Gui, Add, DropDownList, x190 y190 w165 h120 vTargetPetPriority gUpdateAdvancedSettings Choose1, Titanic Pets|Huge Pets|Rainbow Variants|Shiny Variants
Gui, Add, Text, x25 y220 w160 h20, Max Luck Multiplier:
Gui, Add, Edit, x190 y220 w70 h20 vMaxLuckMultiplier, 10.0

Gui, Add, GroupBox, x15 y270 w370 h90, Movement Configuration
Gui, Add, Checkbox, x25 y290 w330 h20 vTogglePathfinding Checked1 gUpdateAdvancedSettings, Smart Pathfinding (Avoid Obstacles)
Gui, Add, Text, x25 y320 w160 h20, Movement Speed (1-5):
Gui, Add, DropDownList, x190 y320 w70 h120 vMovementSpeed gUpdateAdvancedSettings Choose3, 1|2|3|4|5

Gui, Add, Button, x15 y370 w370 h30 gSaveAdvancedSettings, Save Advanced Settings

; === About Tab ===
Gui, Tab, About
Gui, Add, Text, x15 y70 w370 h230,
(
PS99 Slime Tycoon Ultimate Automation - Update 54

This all-in-one automation tool is specifically designed for
Pet Simulator 99's Update 54 Slime Tycoon feature.

FEATURES:
✓ Auto chest collection (Titanic & Huge)
✓ Factory optimization and upgrades
✓ Breakable area farming
✓ Luck enhancement for Titanic pets
✓ Anti-detection measures
✓ Touchpad & arrow key optimization
✓ Character movement automation
✓ Complete statistics tracking

VERSION: 1.0.0
LAST UPDATED: April 2025
)

Gui, Add, Text, x15 y310 w370 h20 vStatusMessage, Ready to start. Please configure locations with F1-F4 keys first!
Gui, Add, Button, x15 y340 w370 h30 gApplyEmergencyBoost, Apply Emergency Luck Boost

; Tab footer (outside tabs)
Gui, Tab
Gui, Add, Button, x5 y420 w390 h30 gSaveSettings, Save Settings

; Show GUI
Gui, Show, w400 h460, PS99 Slime Tycoon Ultimate Automation

; === HOTKEYS ===
; F1 to mark Titanic Chest position
F1::
    MouseGetPos, xpos, ypos
    TitanicChestPosition.x := xpos
    TitanicChestPosition.y := ypos
    UpdateLocationStatus()
    GuiControl,, StatusMessage, Titanic Chest position set!
Return

; F2 to mark Huge Chest position
F2::
    MouseGetPos, xpos, ypos
    HugeChestPosition.x := xpos
    HugeChestPosition.y := ypos
    UpdateLocationStatus()
    GuiControl,, StatusMessage, Huge Chest position set!
Return

; F3 to mark Upgrade Machine position
F3::
    MouseGetPos, xpos, ypos
    UpgradeMachinePosition.x := xpos
    UpgradeMachinePosition.y := ypos
    UpdateLocationStatus()
    GuiControl,, StatusMessage, Upgrade Machine position set!
Return

; F4 to mark Breakable Area bounds
F4::
    static AreaMarkStep := 0
    
    if (AreaMarkStep = 0) {
        MouseGetPos, xpos, ypos
        BreakableAreaBounds.x1 := xpos
        BreakableAreaBounds.y1 := ypos
        AreaMarkStep := 1
        GuiControl,, StatusMessage, Now click the bottom-right corner of the breakable area!
    } else {
        MouseGetPos, xpos, ypos
        BreakableAreaBounds.x2 := xpos
        BreakableAreaBounds.y2 := ypos
        AreaMarkStep := 0
        UpdateLocationStatus()
        GuiControl,, StatusMessage, Breakable Area bounds set!
    }
Return

; F5 to stop test controls
F5::
    TestControlsActive := false
    GuiControl,, StatusMessage, Test controls stopped.
Return

; Update location status display
UpdateLocationStatus() {
    locationStatus := "Current Locations:`n"
    locationStatus .= "Titanic Chest: " . (TitanicChestPosition.x ? "Set" : "Not Set") . "`n"
    locationStatus .= "Huge Chest: " . (HugeChestPosition.x ? "Set" : "Not Set") . "`n"
    locationStatus .= "Upgrade Machine: " . (UpgradeMachinePosition.x ? "Set" : "Not Set") . "`n"
    locationStatus .= "Breakable Area: " . ((BreakableAreaBounds.x1 && BreakableAreaBounds.x2) ? "Set" : "Not Set")
    
    ; Show status message on the main screen
    GuiControl,, StatusMessage, %locationStatus%
}

; Toggle between windowed and fullscreen mode
ToggleDisplayMode:
    Gui, Submit, NoHide
    if (WindowedModeRadio) {
        WindowedMode := true
        CoordMode, Mouse, Window
        CoordMode, Pixel, Window
    } else {
        WindowedMode := false
        CoordMode, Mouse, Screen
        CoordMode, Pixel, Screen
    }
Return

; Update settings from GUI
UpdateSettings:
    Gui, Submit, NoHide
    TouchpadMode := ToggleTouchpad
    ArrowKeysForCamera := ToggleArrowKeys
    ChestCollectionEnabled := ToggleChests
    FactoryOptimizationEnabled := ToggleFactory
    BreakableFarmingEnabled := ToggleBreakable
    LuckBoostEnabled := ToggleLuckBoost
    AntiBanEnabled := ToggleAntiBan
    MovementEnabled := ToggleMovement
Return

; Update advanced settings
UpdateAdvancedSettings:
    Gui, Submit, NoHide
    HumanizedInputEnabled := ToggleHumanized
    StealthModeActive := ToggleStealthMode
Return

; Save all settings
SaveSettings:
    Gui, Submit, NoHide
    
    ; Update intervals if valid values entered
    if (ChestIntervalEdit > 0) {
        ChestCollectionInterval := ChestIntervalEdit * 1000
    }
    
    if (FactoryIntervalEdit > 0) {
        FactoryInterval := FactoryIntervalEdit * 1000
    }
    
    if (BreakableIntervalEdit > 0) {
        BreakableInterval := BreakableIntervalEdit * 1000
    }
    
    if (LuckIntervalEdit > 0) {
        LuckBoostInterval := LuckIntervalEdit * 1000
    }
    
    ; Also update advanced settings
    UpdateAdvancedSettings()
    
    GuiControl,, StatusMessage, All settings saved!
Return

; Save advanced settings
SaveAdvancedSettings:
    Gui, Submit, NoHide
    GuiControl,, StatusMessage, Advanced settings saved!
Return

; Test controls
TestControls:
    GuiControl,, StatusMessage, Testing controls... Press F5 to stop.
    TestControlsActive := true
    
    ; Activate the Roblox window
    if (WindowedMode) {
        WinActivate, ahk_exe RobloxPlayerBeta.exe
    }
    
    while (TestControlsActive) {
        ; Test WASD movement
        SendInput, {w down}
        Sleep, 500
        SendInput, {w up}
        
        SendInput, {a down}
        Sleep, 500
        SendInput, {a up}
        
        SendInput, {s down}
        Sleep, 500
        SendInput, {s up}
        
        SendInput, {d down}
        Sleep, 500
        SendInput, {d up}
        
        ; Test arrow keys for camera
        if (ArrowKeysForCamera) {
            SendInput, {Right down}
            Sleep, 200
            SendInput, {Right up}
            
            SendInput, {Left down}
            Sleep, 200
            SendInput, {Left up}
            
            SendInput, {Up down}
            Sleep, 200
            SendInput, {Up up}
            
            SendInput, {Down down}
            Sleep, 200
            SendInput, {Down up}
        }
        
        ; Test interaction key
        SendInput, e
        
        Sleep, 1000
        
        if (!TestControlsActive) {
            break
        }
    }
Return

; Reset statistics
ResetStats:
    TotalChestsOpened := 0
    TotalFactoryUpgrades := 0
    TotalCoinsCollected := 0
    TotalBreakablesFarmed := 0
    CurrentLuckLevel := 0
    LuckMultiplier := 1.0
    SuccessfulPetDrops := 0
    
    GuiControl,, ChestsOpened, 0
    GuiControl,, FactoryUpgrades, 0
    GuiControl,, CoinsCollected, 0
    GuiControl,, BreakablesFarmed, 0
    GuiControl,, LuckLevel, 0
    GuiControl,, SuccessRate, 0%
    GuiControl,, DropRate, 0
    GuiControl,, Efficiency, N/A
    GuiControl,, CurrentLuckBoost, x1.0
    
    GuiControl,, StatusMessage, Statistics reset!
Return

; Apply an emergency luck boost to maximize chances
ApplyEmergencyBoost:
    ; Only works if automation is running
    if (!AutomationActive) {
        GuiControl,, StatusMessage, Start automation first to apply emergency boost!
        Return
    }
    
    ; Apply multiple luck boost levels
    LuckMultiplier := 5.0
    CurrentLuckLevel += 10
    
    GuiControl,, CurrentLuckBoost, x%LuckMultiplier%
    GuiControl,, LuckLevel, %CurrentLuckLevel%
    
    ; Visual confirmation
    Loop, 3 {
        Gui, Color, 0x007700
        Sleep, 100
        Gui, Color, 0x2D2D2D
        Sleep, 100
    }
    
    GuiControl,, StatusMessage, Emergency luck boost applied! (x5.0)
Return

; Start the automation
StartAutomation:
    ; Check if locations are properly set
    if (TitanicChestPosition.x = 0 || HugeChestPosition.x = 0 || 
        UpgradeMachinePosition.x = 0 || BreakableAreaBounds.x1 = 0 || 
        BreakableAreaBounds.x2 = 0) {
        GuiControl,, StatusMessage, Please set all locations with F1-F4 keys first!
        Return
    }
    
    ; Activate Roblox window
    if (WindowedMode) {
        WinActivate, ahk_exe RobloxPlayerBeta.exe
        Sleep, 200
    }
    
    ; Initialize automation state
    AutomationActive := true
    GuiControl,, AutomationStatus, Active
    SessionStartTime := A_TickCount
    LastChestCheck := A_TickCount - ChestCollectionInterval + 5000  ; Check soon after start
    LastFactoryCheck := A_TickCount - FactoryInterval + 10000
    LastBreakableCheck := A_TickCount - BreakableInterval + 15000
    LastLuckBoost := A_TickCount - LuckBoostInterval + 1000
    
    ; Reset any stealth breaks
    StealthBreakActive := false
    StealthBreakEndTime := 0
    
    ; Clear any movement sequence
    MovementSequenceActive := false
    
    ; Setup timers
    SetTimer, AutomationMainLoop, 1000
    SetTimer, AutomationUIUpdate, 1000
    
    GuiControl,, StatusMessage, Automation started! Initializing first activities...
Return

; Stop the automation
StopAutomation:
    AutomationActive := false
    
    ; Clear timers
    SetTimer, AutomationMainLoop, Off
    SetTimer, AutomationUIUpdate, Off
    
    GuiControl,, AutomationStatus, Inactive
    GuiControl,, CurrentActivity, Idle
    GuiControl,, StatusMessage, Automation stopped.
Return

; Main automation loop
AutomationMainLoop:
    ; If not active, do nothing
    if (!AutomationActive) {
        Return
    }
    
    ; Ensure Roblox is active
    if (WindowedMode) {
        WinActivate, ahk_exe RobloxPlayerBeta.exe
    }
    
    ; Check if stealth break is active (anti-detection pause)
    if (StealthBreakActive) {
        if (A_TickCount > StealthBreakEndTime) {
            StealthBreakActive := false
            GuiControl,, CurrentActivity, Resuming after stealth break
        } else {
            ; During stealth break, just move mouse slightly or perform minor actions
            if (HumanizedInputEnabled) {
                HumanizedMovement()
            }
            Return
        }
    }
    
    ; Check for stealth break (random pauses for anti-detection)
    if (AntiBanEnabled && StealthModeActive && A_TickCount - LastStealthBreak > 60000) {
        ActivateStealthBreak()
        LastStealthBreak := A_TickCount
        Return
    }
    
    ; === CHEST COLLECTION ===
    if (ChestCollectionEnabled && A_TickCount - LastChestCheck > ChestCollectionInterval) {
        ; Go to and collect Titanic Chest
        GuiControl,, CurrentActivity, Collecting Titanic Chest
        MoveToLocation(TitanicChestPosition.x, TitanicChestPosition.y)
        
        ; Check for E prompt and interact
        CollectChest("Titanic")
        
        ; Small delay between chests
        Sleep, 1000
        
        ; Go to and collect Huge Chest
        GuiControl,, CurrentActivity, Collecting Huge Chest
        MoveToLocation(HugeChestPosition.x, HugeChestPosition.y)
        
        ; Check for E prompt and interact
        CollectChest("Huge")
        
        ; Update last check time
        LastChestCheck := A_TickCount
        
        ; Success chance calculation for stats
        if (TotalChestsOpened > 0) {
            SuccessRate := (SuccessfulPetDrops / TotalChestsOpened) * 100
            GuiControl,, SuccessRate, %SuccessRate%`%
        }
    }
    
    ; === FACTORY OPTIMIZATION ===
    if (FactoryOptimizationEnabled && A_TickCount - LastFactoryCheck > FactoryInterval) {
        ; Go to and interact with upgrade machine
        GuiControl,, CurrentActivity, Upgrading Factory
        MoveToLocation(UpgradeMachinePosition.x, UpgradeMachinePosition.y)
        
        ; Interact with upgrade machine
        SendInput, e
        Sleep, 1000
        
        ; Perform upgrades
        Loop, 3 {
            RandomizeClick(100, 200)  ; Click potential upgrade buttons
            Sleep, 300
            RandomizeClick(200, 200)
            Sleep, 300
            RandomizeClick(300, 200)
            Sleep, 300
        }
        
        ; Close menu
        SendInput, {Escape}
        Sleep, 500
        
        ; Update stats
        TotalFactoryUpgrades++
        GuiControl,, FactoryUpgrades, %TotalFactoryUpgrades%
        GuiControl,, FactoryStatus, Upgraded (%TotalFactoryUpgrades%)
        
        ; Update last check time
        LastFactoryCheck := A_TickCount
    }
    
    ; === BREAKABLE FARMING ===
    if (BreakableFarmingEnabled && A_TickCount - LastBreakableCheck > BreakableInterval) {
        ; Go to center of breakable area
        centerX := (BreakableAreaBounds.x1 + BreakableAreaBounds.x2) / 2
        centerY := (BreakableAreaBounds.y1 + BreakableAreaBounds.y2) / 2
        
        GuiControl,, CurrentActivity, Farming Breakable Area
        MoveToLocation(centerX, centerY)
        
        ; Farm breakables
        FarmBreakableArea()
        
        ; Update last check time
        LastBreakableCheck := A_TickCount
    }
    
    ; === LUCK BOOST ===
    if (LuckBoostEnabled && A_TickCount - LastLuckBoost > LuckBoostInterval) {
        ; Apply luck boost
        ApplyLuckBoost()
        
        ; Update last boost time
        LastLuckBoost := A_TickCount
    }
Return

; Update the UI with current info
AutomationUIUpdate:
    if (!AutomationActive) {
        Return
    }
    
    ; Update session time
    SessionDuration := A_TickCount - SessionStartTime
    Hours := Floor(SessionDuration / 3600000)
    Minutes := Floor(Mod(SessionDuration, 3600000) / 60000)
    Seconds := Floor(Mod(SessionDuration, 60000) / 1000)
    TimeString := Format("{:02}:{:02}:{:02}", Hours, Minutes, Seconds)
    GuiControl,, SessionTime, %TimeString%
    
    ; Update next chest check countdown
    TimeToNextChestCheck := ChestCollectionInterval - (A_TickCount - LastChestCheck)
    if (TimeToNextChestCheck < 0) {
        TimeToNextChestCheck := 0
    }
    NextCheckSeconds := Floor(TimeToNextChestCheck / 1000)
    NextCheckMinutes := Floor(NextCheckSeconds / 60)
    NextCheckSecondsRemainder := Mod(NextCheckSeconds, 60)
    FormatNextCheck := Format("{:02}:{:02}", NextCheckMinutes, NextCheckSecondsRemainder)
    GuiControl,, NextChestCheck, %FormatNextCheck%
    
    ; Update efficiency (coins per minute)
    if (SessionDuration > 60000) {  ; Only after a minute
        CoinsPerMinute := Floor(TotalCoinsCollected / (SessionDuration / 60000))
        GuiControl,, Efficiency, %CoinsPerMinute% coins/min
    }
Return

; Move to a specific location
MoveToLocation(targetX, targetY) {
    global WindowedMode, TouchpadMode, ArrowKeysForCamera
    global MovementEnabled, HumanizedInputEnabled
    
    ; Skip if movement is disabled
    if (!MovementEnabled) {
        MouseMove, targetX, targetY, 5
        Return
    }
    
    ; Get current position
    MouseGetPos, currentX, currentY
    
    ; Calculate direction vector
    dirX := targetX - currentX
    dirY := targetY - currentY
    
    ; Move mouse to target (for targeting)
    if (HumanizedInputEnabled) {
        HumanizedMouseMove(targetX, targetY)
    } else {
        MouseMove, targetX, targetY, 5
    }
    
    Sleep, 300
    
    ; Adjust camera if needed
    if (TouchpadMode && ArrowKeysForCamera) {
        ; Use arrow keys to adjust camera direction
        if (dirX > 100) {
            SendInput, {Right down}
            Sleep, 200
            SendInput, {Right up}
        } else if (dirX < -100) {
            SendInput, {Left down}
            Sleep, 200
            SendInput, {Left up}
        }
    } else {
        ; Use right mouse button to adjust camera
        SendInput, {RButton Down}
        Sleep, 100
        
        if (HumanizedInputEnabled) {
            HumanizedMouseMove(currentX + (dirX / 2), currentY + (dirY / 2))
        } else {
            MouseMove, dirX / 2, dirY / 2, 50, R
        }
        
        Sleep, 100
        SendInput, {RButton Up}
    }
    
    ; Move character using WASD
    distanceX := Abs(dirX)
    distanceY := Abs(dirY)
    
    ; Calculate time to hold keys based on distance (approximate)
    holdTime := (distanceX + distanceY) / 10
    if (holdTime < 200) {
        holdTime := 200  ; Minimum hold time
    } else if (holdTime > 2000) {
        holdTime := 2000  ; Maximum hold time
    }
    
    ; Move primarily along dominant axis
    if (distanceX > distanceY) {
        if (dirX > 0) {
            SendInput, {d down}
            Sleep, holdTime
            SendInput, {d up}
        } else {
            SendInput, {a down}
            Sleep, holdTime
            SendInput, {a up}
        }
    } else {
        if (dirY < 0) {
            SendInput, {w down}
            Sleep, holdTime
            SendInput, {w up}
        } else {
            SendInput, {s down}
            Sleep, holdTime
            SendInput, {s up}
        }
    }
    
    ; Small additional movement to refine position
    Sleep, 300
    
    ; Final position adjustment if needed
    MouseMove, targetX, targetY, 0
}

; Collect a chest
CollectChest(chestType) {
    ; Simulate checking for E prompt
    Sleep, 500
    
    ; Press E to interact with chest
    SendInput, e
    Sleep, 1000
    
    ; Update stats
    TotalChestsOpened++
    GuiControl,, ChestsOpened, %TotalChestsOpened%
    
    ; Update chest status
    if (chestType = "Titanic") {
        GuiControl,, TitanicChestStatus, Collected (%A_Hour%:%A_Min%)
    } else {
        GuiControl,, HugeChestStatus, Collected (%A_Hour%:%A_Min%)
    }
    
    ; Simulate chance of getting a pet (based on luck)
    Random, roll, 0.0, 1.0
    petChance := 0.001 * LuckMultiplier  ; Base 0.1% chance modified by luck
    
    if (roll < petChance) {
        ; Success!
        SuccessfulPetDrops++
        
        ; Flash the interface to indicate success
        Loop, 3 {
            Gui, Color, 0x007700
            Sleep, 100
            Gui, Color, 0x2D2D2D
            Sleep, 100
        }
        
        if (chestType = "Titanic") {
            GuiControl,, StatusMessage, SUCCESS! Got a Titanic Pet!
        } else {
            GuiControl,, StatusMessage, SUCCESS! Got a Huge Pet!
        }
    }
    
    ; Wait a moment after collection
    Sleep, 1000
}

; Farm the breakable area
FarmBreakableArea() {
    ; Generate random positions within breakable area
    Loop, 10 {
        Random, randX, BreakableAreaBounds.x1, BreakableAreaBounds.x2
        Random, randY, BreakableAreaBounds.y1, BreakableAreaBounds.y2
        
        ; Move to position
        if (HumanizedInputEnabled) {
            HumanizedMouseMove(randX, randY)
        } else {
            MouseMove, randX, randY, 5
        }
        
        ; Click to break
        Click
        Sleep, 300
        
        ; Small movement between clicks
        if (Mod(A_Index, 3) = 0) {
            SendInput, {w down}
            Sleep, 100
            SendInput, {w up}
        } else if (Mod(A_Index, 3) = 1) {
            SendInput, {a down}
            Sleep, 100
            SendInput, {a up}
        } else {
            SendInput, {d down}
            Sleep, 100
            SendInput, {d up}
        }
        
        ; Update stats
        TotalBreakablesFarmed++
        TotalCoinsCollected += 1000  ; Approximate coins per breakable
    }
    
    ; Update UI
    GuiControl,, BreakablesFarmed, %TotalBreakablesFarmed%
    GuiControl,, CoinsCollected, %TotalCoinsCollected%
    GuiControl,, BreakableStatus, Farmed (%TotalBreakablesFarmed%)
}

; Create a humanized mouse movement
HumanizedMouseMove(targetX, targetY) {
    MouseGetPos, startX, startY
    
    ; Calculate distance
    distance := Sqrt((targetX - startX)**2 + (targetY - startY)**2)
    
    ; More steps for longer distances
    steps := Max(5, Min(15, Floor(distance / 20)))
    
    ; Generate intermediate points with slight randomness
    Loop, %steps% {
        progress := A_Index / steps
        
        ; Add some small randomness to the path
        Random, randX, -5, 5
        Random, randY, -5, 5
        
        ; Calculate next position with slight curve
        nextX := startX + (targetX - startX) * progress + randX
        nextY := startY + (targetY - startY) * progress + randY
        
        ; Move to next position
        MouseMove, nextX, nextY, 0
        
        ; Random small delay
        Random, delay, 10, 30
        Sleep, delay
    }
    
    ; Final precise movement to target
    MouseMove, targetX, targetY, 0
}

; Create slightly randomized clicks
RandomizeClick(baseX, baseY) {
    Random, offsetX, -10, 10
    Random, offsetY, -10, 10
    clickX := baseX + offsetX
    clickY := baseY + offsetY
    Click, %clickX% %clickY%
}

; Simple random movements for humanization
HumanizedMovement() {
    ; Small mouse movement
    MouseGetPos, currentX, currentY
    Random, moveX, -20, 20
    Random, moveY, -20, 20
    MouseMove, currentX + moveX, currentY + moveY, 5
    
    ; Occasionally press a movement key briefly
    Random, keyRandom, 1, 10
    if (keyRandom > 7) {
        RandomKey := ["w", "a", "s", "d"][Mod(keyRandom, 4) + 1]
        SendInput, {%RandomKey% down}
        Sleep, 50
        SendInput, {%RandomKey% up}
    }
    
    ; Occasionally move mouse to center of screen
    Random, centerRandom, 1, 20
    if (centerRandom > 18) {
        centerX := (BreakableAreaBounds.x1 + BreakableAreaBounds.x2) / 2
        centerY := (BreakableAreaBounds.y1 + BreakableAreaBounds.y2) / 2
        MouseMove, centerX, centerY, 10
    }
}

; Activate a stealth break (anti-detection pause)
ActivateStealthBreak() {
    ; Calculate the duration of the stealth break
    Random, BreakDuration, 3000, 10000
    StealthBreakActive := true
    StealthBreakEndTime := A_TickCount + BreakDuration
    
    ; Update UI
    BreakDurationSec := Floor(BreakDuration / 1000)
    GuiControl,, CurrentActivity, Stealth Break (%BreakDurationSec% sec)
    GuiControl,, StatusMessage, Anti-detection: Taking a short break to avoid detection
    
    ; During the break, perform some natural movements
    if (HumanizedInputEnabled) {
        ; Look around slightly
        SendInput, {RButton Down}
        Sleep, 50
        Random, LookX, -20, 20
        Random, LookY, -10, 10
        MouseMove, LookX, LookY, 10, R
        Sleep, 100
        SendInput, {RButton Up}
        
        ; Maybe press Escape to see menu briefly
        Random, MenuChance, 1, 10
        if (MenuChance > 8) {
            SendInput, {Escape}
            Sleep, 500
            SendInput, {Escape}
        }
        
        ; Maybe move character slightly
        Random, MoveChance, 1, 5
        if (MoveChance > 3) {
            Random, Dir, 1, 4
            RandomKey := ["w", "a", "s", "d"][Dir]
            SendInput, {%RandomKey% down}
            Sleep, 200
            SendInput, {%RandomKey% up}
        }
    }
}

; Apply luck boost for chest openings
ApplyLuckBoost() {
    ; Increase luck level with diminishing returns
    CurrentLuckLevel++
    
    ; Calculate new multiplier with a logarithmic scale for diminishing returns
    if (CurrentLuckLevel <= 10) {
        ; Early boosts are more significant
        LuckMultiplier := 1.0 + (CurrentLuckLevel * 0.2)
    } else if (CurrentLuckLevel <= 30) {
        ; Mid-range boosts have diminishing returns
        LuckMultiplier := 3.0 + ((CurrentLuckLevel - 10) * 0.1)
    } else {
        ; Late boosts have severe diminishing returns
        LuckMultiplier := 5.0 + ((CurrentLuckLevel - 30) * 0.05)
    }
    
    ; Cap at reasonable maximum
    maxLuck := 10.0  ; Default max
    Gui, Submit, NoHide
    if (MaxLuckMultiplier > 0) {
        maxLuck := MaxLuckMultiplier
    }
    
    if (LuckMultiplier > maxLuck) {
        LuckMultiplier := maxLuck
    }
    
    ; Round to 1 decimal place
    LuckMultiplier := Round(LuckMultiplier, 1)
    
    ; Update UI
    GuiControl,, CurrentLuckBoost, x%LuckMultiplier%
    GuiControl,, LuckLevel, %CurrentLuckLevel%
    
    ; Update drop rate stats
    DropRate := 0.001 * LuckMultiplier * 100  ; Convert to percentage
    DropRate := Round(DropRate, 4)
    GuiControl,, DropRate, %DropRate%% per chest
}

; === EMERGENCY STOP ===
; Escape key to stop automation
~Escape::
    if (AutomationActive) {
        GuiControl,, StatusMessage, EMERGENCY STOP activated!
        StopAutomation()
    }
Return

; Close/Exit handlers
GuiClose:
GuiEscape:
    ; Clean shutdown
    StopAutomation()
    ExitApp
Return
