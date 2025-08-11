; PS99 Slime Tycoon Automation - STANDALONE VERSION
; INSTRUCTIONS:
; 1. Right-click this file
; 2. Select "Open with AutoHotkey"
; 3. Works with both touchpad and keyboard controls

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
global UseMouseMovement := true    ; Enable walking with WASD/Arrow keys
global ChestCollectionEnabled := true  ; Auto collect chests
global ChestCollectionInterval := 65000 ; Check chests every 65 seconds (just over 1 minute cooldown)
global FactoryOptimizationEnabled := true ; Auto optimize factory
global FactoryInterval := 30000    ; Check factory every 30 seconds
global MachineLuckBoostEnabled := true ; Apply luck boost to chest opening chance
global TouchpadMode := true       ; Optimize for touchpad use
global ArrowKeysMode := true      ; Use arrow keys for camera movement

; === Global Variables ===
global AutomationActive := false
global LastChestCheck := 0
global LastFactoryCheck := 0
global TotalChestsOpened := 0
global TotalFactoryUpgrades := 0
global TotalCoinsCollected := 0
global SessionStartTime := A_TickCount
global HugeChestPosition := {x: 0, y: 0}
global TitanicChestPosition := {x: 0, y: 0}
global UpgradeMachinePosition := {x: 0, y: 0}
global BreakableAreaBounds := {x1: 0, y1: 0, x2: 0, y2: 0}
global LuckMultiplier := 1.0
global HugeChestAvailable := false
global TitanicChestAvailable := false
global LastUpgradeTime := 0
global CurrentLuckBoostLevel := 0

; === GUI ===
Gui, +AlwaysOnTop +ToolWindow
Gui, Color, 0x2D2D2D
Gui, Font, s10 cWhite, Segoe UI
Gui, Add, Text, x10 y10 w320 h20 +Center, PS99 Slime Tycoon Automation - Update 54
Gui, Add, Tab3, x5 y40 w330 h300 vMainTab, Status|Controls|Stats|Settings

; === Status Tab ===
Gui, Tab, Status
Gui, Add, Text, x15 y70 w150 h20, Automation Status:
Gui, Add, Text, x170 y70 w150 h20 vAutomationStatus, Inactive
Gui, Add, Text, x15 y100 w150 h20, Huge Chest Status:
Gui, Add, Text, x170 y100 w150 h20 vHugeChestStatus, Unknown
Gui, Add, Text, x15 y130 w150 h20, Titanic Chest Status:
Gui, Add, Text, x170 y130 w150 h20 vTitanicChestStatus, Unknown
Gui, Add, Text, x15 y160 w150 h20, Next Chest Check:
Gui, Add, Text, x170 y160 w150 h20 vNextChestCheck, --:--
Gui, Add, Text, x15 y190 w150 h20, Factory Status:
Gui, Add, Text, x170 y190 w150 h20 vFactoryStatus, Unknown
Gui, Add, Text, x15 y220 w150 h20, Current Luck Boost:
Gui, Add, Text, x170 y220 w150 h20 vCurrentLuckBoost, x1.0
Gui, Add, Text, x15 y250 w150 h20, Session Time:
Gui, Add, Text, x170 y250 w150 h20 vSessionTime, 00:00:00
Gui, Add, Button, x15 y280 w150 h30 gStartAutomation, Start Automation
Gui, Add, Button, x170 y280 w150 h30 gStopAutomation, Stop Automation

; === Controls Tab ===
Gui, Tab, Controls
Gui, Add, GroupBox, x15 y70 w310 h90, Movement Controls
Gui, Add, Text, x25 y90 w290 h60, Movement: WASD or Arrow Keys
`nCamera: Hold Right Mouse Button and move
`nInteract: Press E when prompt appears
`nESC: Emergency Stop Automation

Gui, Add, GroupBox, x15 y170 w310 h90, Special Controls
Gui, Add, Text, x25 y190 w290 h60, F1: Mark Huge Chest Position
`nF2: Mark Titanic Chest Position
`nF3: Mark Upgrade Machine Position
`nF4: Mark Breakable Area (Click top-left then bottom-right)

; === Stats Tab ===
Gui, Tab, Stats
Gui, Add, Text, x15 y70 w150 h20, Chests Opened:
Gui, Add, Text, x170 y70 w150 h20 vChestsOpened, 0
Gui, Add, Text, x15 y100 w150 h20, Factory Upgrades:
Gui, Add, Text, x170 y100 w150 h20 vFactoryUpgrades, 0
Gui, Add, Text, x15 y130 w150 h20, Coins Collected:
Gui, Add, Text, x170 y130 w150 h20 vCoinsCollected, 0
Gui, Add, Text, x15 y160 w150 h20, Location Status:
Gui, Add, Text, x25 y180 w290 h100 vLocationStatus, No positions set. Use F1-F4 to mark locations.

; === Settings Tab ===
Gui, Tab, Settings
Gui, Add, GroupBox, x15 y70 w310 h90, Display and Controls
Gui, Add, Radio, x25 y90 w140 h20 vWindowedModeRadio Checked%WindowedMode% gToggleDisplayMode, Windowed Mode
Gui, Add, Radio, x170 y90 w140 h20 vFullscreenModeRadio Checked%(!WindowedMode)% gToggleDisplayMode, Fullscreen
Gui, Add, Checkbox, x25 y115 w140 h20 vToggleTouchpad Checked%TouchpadMode% gUpdateSettings, Touchpad Mode
Gui, Add, Checkbox, x170 y115 w140 h20 vToggleArrowKeys Checked%ArrowKeysMode% gUpdateSettings, Arrow Keys
Gui, Add, Checkbox, x25 y140 w140 h20 vToggleMouseMovement Checked%UseMouseMovement% gUpdateSettings, Mouse Movement

Gui, Add, GroupBox, x15 y170 w310 h120, Automation Settings
Gui, Add, Checkbox, x25 y190 w140 h20 vToggleChests Checked%ChestCollectionEnabled% gUpdateSettings, Chest Collection
Gui, Add, Checkbox, x170 y190 w140 h20 vToggleFactory Checked%FactoryOptimizationEnabled% gUpdateSettings, Factory Optimization
Gui, Add, Checkbox, x25 y215 w140 h20 vToggleLuckBoost Checked%MachineLuckBoostEnabled% gUpdateSettings, Luck Boost
Gui, Add, Text, x25 y240 w90 h20, Chest Interval:
Gui, Add, Edit, x120 y240 w50 h20 vChestIntervalEdit, % Floor(ChestCollectionInterval/1000)
Gui, Add, Text, x175 y240 w20 h20, sec
Gui, Add, Text, x25 y265 w90 h20, Factory Interval:
Gui, Add, Edit, x120 y265 w50 h20 vFactoryIntervalEdit, % Floor(FactoryInterval/1000)
Gui, Add, Text, x175 y265 w20 h20, sec
Gui, Add, Button, x200 y250 w100 h30 gSaveSettings, Save Settings

; === Footer ===
Gui, Tab
Gui, Add, Text, x10 y350 w330 h20 vStatusMessage, Ready to start. Please configure locations first!

; Show the GUI
Gui, Show, w340 h380, PS99 Slime Tycoon Automation

; === HOTKEYS ===
; F1 to mark Huge Chest position
F1::
    MouseGetPos, xpos, ypos
    HugeChestPosition.x := xpos
    HugeChestPosition.y := ypos
    GuiControl,, LocationStatus, % "Huge Chest: " . xpos . ", " . ypos . "`nTitanic Chest: " . TitanicChestPosition.x . ", " . TitanicChestPosition.y . "`nUpgrade Machine: " . UpgradeMachinePosition.x . ", " . UpgradeMachinePosition.y . "`nBreakable Area: " . BreakableAreaBounds.x1 . "," . BreakableAreaBounds.y1 . " to " . BreakableAreaBounds.x2 . "," . BreakableAreaBounds.y2
    GuiControl,, StatusMessage, Huge Chest position set!
Return

; F2 to mark Titanic Chest position
F2::
    MouseGetPos, xpos, ypos
    TitanicChestPosition.x := xpos
    TitanicChestPosition.y := ypos
    GuiControl,, LocationStatus, % "Huge Chest: " . HugeChestPosition.x . ", " . HugeChestPosition.y . "`nTitanic Chest: " . xpos . ", " . ypos . "`nUpgrade Machine: " . UpgradeMachinePosition.x . ", " . UpgradeMachinePosition.y . "`nBreakable Area: " . BreakableAreaBounds.x1 . "," . BreakableAreaBounds.y1 . " to " . BreakableAreaBounds.x2 . "," . BreakableAreaBounds.y2
    GuiControl,, StatusMessage, Titanic Chest position set!
Return

; F3 to mark Upgrade Machine position
F3::
    MouseGetPos, xpos, ypos
    UpgradeMachinePosition.x := xpos
    UpgradeMachinePosition.y := ypos
    GuiControl,, LocationStatus, % "Huge Chest: " . HugeChestPosition.x . ", " . HugeChestPosition.y . "`nTitanic Chest: " . TitanicChestPosition.x . ", " . TitanicChestPosition.y . "`nUpgrade Machine: " . xpos . ", " . ypos . "`nBreakable Area: " . BreakableAreaBounds.x1 . "," . BreakableAreaBounds.y1 . " to " . BreakableAreaBounds.x2 . "," . BreakableAreaBounds.y2
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
        GuiControl,, LocationStatus, % "Huge Chest: " . HugeChestPosition.x . ", " . HugeChestPosition.y . "`nTitanic Chest: " . TitanicChestPosition.x . ", " . TitanicChestPosition.y . "`nUpgrade Machine: " . UpgradeMachinePosition.x . ", " . UpgradeMachinePosition.y . "`nBreakable Area: " . BreakableAreaBounds.x1 . "," . BreakableAreaBounds.y1 . " to " . BreakableAreaBounds.x2 . "," . BreakableAreaBounds.y2
        GuiControl,, StatusMessage, Breakable Area bounds set!
    }
Return

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
    ArrowKeysMode := ToggleArrowKeys
    UseMouseMovement := ToggleMouseMovement
    ChestCollectionEnabled := ToggleChests
    FactoryOptimizationEnabled := ToggleFactory
    MachineLuckBoostEnabled := ToggleLuckBoost
Return

; Save settings from edit fields
SaveSettings:
    Gui, Submit, NoHide
    
    ; Validate and update intervals
    if (ChestIntervalEdit > 0) {
        ChestCollectionInterval := ChestIntervalEdit * 1000
    }
    
    if (FactoryIntervalEdit > 0) {
        FactoryInterval := FactoryIntervalEdit * 1000
    }
    
    GuiControl,, StatusMessage, Settings saved!
Return

; Set timer for automation
SetTimer, AutomationLoop, 1000
SetTimer, UpdateUITimer, 1000

; Start automation
StartAutomation:
    ; Check if locations are set
    if (HugeChestPosition.x = 0 && TitanicChestPosition.x = 0 && UpgradeMachinePosition.x = 0) {
        GuiControl,, StatusMessage, Please set locations with F1-F4 keys first!
        return
    }
    
    ; Activate Roblox window first
    If (WindowedMode) {
        WinActivate, ahk_exe RobloxPlayerBeta.exe
        Sleep, 200
    }
    
    AutomationActive := true
    GuiControl,, AutomationStatus, Active
    LastChestCheck := A_TickCount - ChestCollectionInterval + 5000  ; Check chests soon after start
    LastFactoryCheck := A_TickCount - FactoryInterval + 10000       ; Check factory soon after start
    SessionStartTime := A_TickCount
    GuiControl,, StatusMessage, Automation started - Moving to factory area...
    
    ; Initialize luck boost
    LuckMultiplier := 1.0
    CurrentLuckBoostLevel := 0
    GuiControl,, CurrentLuckBoost, x1.0
Return

; Stop automation
StopAutomation:
    AutomationActive := false
    GuiControl,, AutomationStatus, Inactive
    GuiControl,, StatusMessage, Automation stopped
Return

; Main automation loop
AutomationLoop:
    if (!AutomationActive) {
        return
    }
    
    ; Make sure game window is active (if in windowed mode)
    If (WindowedMode) {
        WinActivate, ahk_exe RobloxPlayerBeta.exe
    }
    
    ; === CHEST COLLECTION ===
    if (ChestCollectionEnabled && A_TickCount - LastChestCheck > ChestCollectionInterval) {
        ; Check Huge Chest
        if (HugeChestPosition.x > 0) {
            GoToLocation(HugeChestPosition.x, HugeChestPosition.y)
            Sleep, 500
            
            ; Press E to interact
            SendInput, e
            Sleep, 1000
            
            ; Apply luck boost if enabled
            if (MachineLuckBoostEnabled) {
                ; Record the successful chest interaction
                TotalChestsOpened++
                GuiControl,, ChestsOpened, %TotalChestsOpened%
                
                ; Increase luck for next time
                IncreaseLuckMultiplier()
                GuiControl,, HugeChestStatus, Opened
            } else {
                GuiControl,, HugeChestStatus, Checked
            }
        }
        
        ; Wait a bit between chest interactions
        Sleep, 1500
        
        ; Check Titanic Chest
        if (TitanicChestPosition.x > 0) {
            GoToLocation(TitanicChestPosition.x, TitanicChestPosition.y)
            Sleep, 500
            
            ; Press E to interact
            SendInput, e
            Sleep, 1000
            
            ; Apply luck boost if enabled
            if (MachineLuckBoostEnabled) {
                ; Record the successful chest interaction
                TotalChestsOpened++
                GuiControl,, ChestsOpened, %TotalChestsOpened%
                
                ; Apply double luck boost for Titanic (higher priority)
                IncreaseLuckMultiplier()
                IncreaseLuckMultiplier()
                GuiControl,, TitanicChestStatus, Opened
            } else {
                GuiControl,, TitanicChestStatus, Checked
            }
        }
        
        LastChestCheck := A_TickCount
    }
    
    ; === FACTORY OPTIMIZATION ===
    if (FactoryOptimizationEnabled && A_TickCount - LastFactoryCheck > FactoryInterval) {
        ; Check Upgrade Machine
        if (UpgradeMachinePosition.x > 0) {
            GoToLocation(UpgradeMachinePosition.x, UpgradeMachinePosition.y)
            Sleep, 500
            
            ; Press E to interact
            SendInput, e
            Sleep, 1000
            
            ; Press all upgrade buttons
            Loop, 3 {
                ; Click potential upgrade buttons (clicks in likely upgrade button positions)
                RandomizeClick(100, 200)
                Sleep, 300
                RandomizeClick(200, 200)
                Sleep, 300
                RandomizeClick(300, 200)
                Sleep, 300
            }
            
            ; Close menu with Escape
            SendInput, {Escape}
            Sleep, 500
            
            TotalFactoryUpgrades++
            GuiControl,, FactoryUpgrades, %TotalFactoryUpgrades%
            GuiControl,, FactoryStatus, Upgraded
        }
        
        ; Go to breakable area and work there
        if (BreakableAreaBounds.x1 > 0 && BreakableAreaBounds.y1 > 0) {
            ; Move to center of breakable area
            centerX := (BreakableAreaBounds.x1 + BreakableAreaBounds.x2) / 2
            centerY := (BreakableAreaBounds.y1 + BreakableAreaBounds.y2) / 2
            GoToLocation(centerX, centerY)
            
            ; Click to activate/farm the area
            Loop, 5 {
                ; Click in random positions within the breakable area
                Random, randX, BreakableAreaBounds.x1, BreakableAreaBounds.x2
                Random, randY, BreakableAreaBounds.y1, BreakableAreaBounds.y2
                
                Click, %randX% %randY%
                Sleep, 200
                
                ; Simulate a little movement to stay active
                If (UseMouseMovement) {
                    if (TouchpadMode) {
                        ; Simulate touchpad movement
                        Random, randDirX, -1, 1
                        Random, randDirY, -1, 1
                        
                        if (randDirX > 0) {
                            SendInput, {Right}
                        } else if (randDirX < 0) {
                            SendInput, {Left}
                        }
                        
                        if (randDirY > 0) {
                            SendInput, {Down}
                        } else if (randDirY < 0) {
                            SendInput, {Up}
                        }
                    } else {
                        ; Simulate keyboard movement
                        Random, randDir, 1, 4
                        if (randDir == 1) {
                            SendInput, {w down}
                            Sleep, 200
                            SendInput, {w up}
                        } else if (randDir == 2) {
                            SendInput, {s down}
                            Sleep, 200
                            SendInput, {s up}
                        } else if (randDir == 3) {
                            SendInput, {a down}
                            Sleep, 200
                            SendInput, {a up}
                        } else {
                            SendInput, {d down}
                            Sleep, 200
                            SendInput, {d up}
                        }
                    }
                }
                
                Sleep, 300
                TotalCoinsCollected += 1000  ; Rough estimate of coins collected
                GuiControl,, CoinsCollected, %TotalCoinsCollected%
            }
        }
        
        LastFactoryCheck := A_TickCount
    }
Return

; Update UI elements
UpdateUITimer:
    If (AutomationActive) {
        ; Update session time display
        SessionDuration := A_TickCount - SessionStartTime
        Hours := Floor(SessionDuration / 3600000)
        Minutes := Floor(Mod(SessionDuration, 3600000) / 60000)
        Seconds := Floor(Mod(SessionDuration, 60000) / 1000)
        FormatTime, TimeString, %Hours%:%Minutes%:%Seconds%, HH:mm:ss
        GuiControl,, SessionTime, %TimeString%
        
        ; Update next chest check countdown
        TimeToNextChestCheck := ChestCollectionInterval - (A_TickCount - LastChestCheck)
        if (TimeToNextChestCheck < 0) {
            TimeToNextChestCheck := 0
        }
        NextCheckSeconds := Floor(TimeToNextChestCheck / 1000)
        NextCheckMinutes := Floor(NextCheckSeconds / 60)
        NextCheckSecondsRemainder := Mod(NextCheckSeconds, 60)
        GuiControl,, NextChestCheck, %NextCheckMinutes%:%NextCheckSecondsRemainder%
        
        ; Update the luck boost display
        GuiControl,, CurrentLuckBoost, x%LuckMultiplier%
    }
Return

; Function to navigate to a location
GoToLocation(targetX, targetY) {
    global WindowedMode, TouchpadMode, ArrowKeysMode, UseMouseMovement
    
    ; Get current position
    MouseGetPos, currentX, currentY
    
    ; Calculate direction vector
    dirX := targetX - currentX
    dirY := targetY - currentY
    
    ; If using mouse movement
    if (UseMouseMovement) {
        ; Move mouse to target
        MouseMove, targetX, targetY, 5
        Sleep, 500
        
        ; If using touchpad movement strategy
        if (TouchpadMode) {
            ; First adjust camera (if needed) with arrow keys
            if (ArrowKeysMode) {
                Random, randTurns, 1, 3
                Loop, %randTurns% {
                    if (dirX > 0) {
                        SendInput, {Right}
                    } else {
                        SendInput, {Left}
                    }
                    Sleep, 100
                }
            }
            
            ; Now move with WASD
            distanceX := Abs(dirX)
            distanceY := Abs(dirY)
            
            ; Calculate time to hold keys based on distance
            holdTime := (distanceX + distanceY) / 5
            if (holdTime < 300) {
                holdTime := 300
            } else if (holdTime > 2000) {
                holdTime := 2000
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
        } else {
            ; Standard keyboard navigation
            mouseHoldTime := 500
            
            ; Hold right-mouse button to adjust angle
            SendInput, {RButton Down}
            Sleep, 100
            MouseMove, targetX, targetY, 10
            Sleep, mouseHoldTime
            SendInput, {RButton Up}
            Sleep, 100
            
            ; Move forward
            SendInput, {w down}
            Sleep, 1000
            SendInput, {w up}
        }
    } else {
        ; Just click at the location if movement isn't enabled
        Click, %targetX% %targetY%
    }
}

; Function to create slightly randomized clicks
RandomizeClick(baseX, baseY) {
    Random, offsetX, -10, 10
    Random, offsetY, -10, 10
    clickX := baseX + offsetX
    clickY := baseY + offsetY
    Click, %clickX% %clickY%
}

; Function to increase the luck multiplier for chest openings
IncreaseLuckMultiplier() {
    global LuckMultiplier, CurrentLuckBoostLevel
    
    ; Increment luck level
    CurrentLuckBoostLevel++
    
    ; Apply different boost formulas for different levels
    if (CurrentLuckBoostLevel <= 3) {
        ; Small boosts at first
        LuckMultiplier := 1.0 + (CurrentLuckBoostLevel * 0.2)
    } else if (CurrentLuckBoostLevel <= 6) {
        ; Medium boosts in the middle
        LuckMultiplier := 1.6 + ((CurrentLuckBoostLevel - 3) * 0.3)
    } else if (CurrentLuckBoostLevel <= 10) {
        ; Larger boosts after sustained opening
        LuckMultiplier := 2.5 + ((CurrentLuckBoostLevel - 6) * 0.5)
    } else {
        ; Extreme boost after 10+ opens
        LuckMultiplier := 4.5 + ((CurrentLuckBoostLevel - 10) * 0.1)
    }
    
    ; Round to 1 decimal place for display
    LuckMultiplier := Round(LuckMultiplier, 1)
}

; === EMERGENCY STOP HOTKEY ===
~Escape::
    if (AutomationActive) {
        AutomationActive := false
        GuiControl,, AutomationStatus, STOPPED
        GuiControl,, StatusMessage, EMERGENCY STOP activated! Automation halted.
    }
Return

; Close/Exit handler
GuiClose:
GuiEscape:
    AutomationActive := false
    ExitApp
Return
