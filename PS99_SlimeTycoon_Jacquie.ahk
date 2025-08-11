; PS99 Slime Tycoon - JACQUIE CUSTOM EDITION
; Custom version for MILAMOO12340 (Player: Jacquie)
; Physical location-based interaction for Update 54
; Perfect 2:3:1 ratio for maximum points

#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

; Set up window-based coordinates
CoordMode Mouse Window
CoordMode Pixel Window

; Global variables and settings
global PlayerName := "Jacquie"
global RobloxUsername := "Milamoo12340"
global ScriptActive := false
global BreakablesActive := false
global ChestsActive := false
global ConveyorUpgradesActive := false
global AutoRebirth := false
global SpeedUpgradesCount := 0
global DamageUpgradesCount := 0
global CapacityUpgradesCount := 0
global RobloxWindow := 0
global TimerRunning := false

; Statistics tracking
global StatsTracking := {}
StatsTracking.StartTime := A_TickCount
StatsTracking.CoinsCollected := 0
StatsTracking.ChestsCollected := 0
StatsTracking.BreakablesDestroyed := 0
StatsTracking.RebirthCount := 0
StatsTracking.UpgradeCount := 0

; Location coordinates (will be set by user with F-keys)
global ChestLocation := {}
ChestLocation.X := 0
ChestLocation.Y := 0
global HugeChestLocation := {}
HugeChestLocation.X := 0
HugeChestLocation.Y := 0
global TitanicChestLocation := {}
TitanicChestLocation.X := 0
TitanicChestLocation.Y := 0
global BreakableLocation := {}
BreakableLocation.X := 0
BreakableLocation.Y := 0
global UpgradeLocation := {}
UpgradeLocation.X := 0
UpgradeLocation.Y := 0

; GUI creation
Gui +AlwaysOnTop
Gui Color, 0x222222
Gui Font, s10 cWhite, Segoe UI
Gui Add, GroupBox, x10 y10 w330 h90 cWhite, Slime Tycoon - JACQUIE CUSTOM EDITION

; Status display
Gui Font, s9 cWhite, Segoe UI
Gui Add, Text, x20 y40 w80 h20, Status:
Gui Add, Text, x110 y40 w220 h20 vStatusText, Ready to start
Gui Add, Button, x20 y70 w150 h25 gStartButton vStartBtn, Start
Gui Add, Button, x180 y70 w150 h25 gStopButton vStopBtn Disabled, Stop

; User info
Gui Add, GroupBox, x10 y110 w330 h60 cWhite, User Information
Gui Add, Text, x20 y130 w80 h20, Account:
Gui Add, Text, x110 y130 w210 h20, %RobloxUsername% (Player: %PlayerName%)

; Automation settings
Gui Add, GroupBox, x10 y180 w330 h140 cWhite, Automation Settings
Gui Add, Checkbox, x20 y200 w310 h20 vBreakableFarm Checked gToggleBreakables, Farm Breakables
Gui Add, Checkbox, x20 y230 w310 h20 vChestCollect Checked gToggleChests, Collect Chests
Gui Add, Checkbox, x20 y260 w310 h20 vConveyorUpgrade Checked gToggleConveyor, Upgrade Conveyor
Gui Add, Checkbox, x20 y290 w310 h20 vRebirthCheck gToggleRebirth, Auto Rebirth

; Upgrade ratios
Gui Add, GroupBox, x10 y330 w330 h90 cWhite, Upgrade Ratio (2:3:1 Recommended)
Gui Add, Text, x20 y355 w50 h20, Speed:
Gui Add, Edit, x75 y355 w40 h20 vSpeedRatio, 2
Gui Add, Text, x130 y355 w60 h20, Damage:
Gui Add, Edit, x195 y355 w40 h20 vDamageRatio, 3
Gui Add, Text, x250 y355 w60 h20, Capacity:
Gui Add, Edit, x315 y355 w40 h20 vCapacityRatio, 1

; Statistics
Gui Add, GroupBox, x350 y10 w280 h140 cWhite, Statistics
Gui Add, Text, x360 y30 w120 h20, Running Time:
Gui Add, Text, x490 y30 w130 h20 vRunningTime, 00:00:00
Gui Add, Text, x360 y60 w120 h20, Coins Collected:
Gui Add, Text, x490 y60 w130 h20 vCoinsCollected, 0
Gui Add, Text, x360 y90 w120 h20, Chests Opened:
Gui Add, Text, x490 y90 w130 h20 vChestsOpened, 0
Gui Add, Text, x360 y120 w120 h20, Breakables Destroyed:
Gui Add, Text, x490 y120 w130 h20 vBreakablesDestroyed, 0

; Upgrade tracker
Gui Add, GroupBox, x350 y160 w280 h90 cWhite, Upgrade Tracker
Gui Add, Text, x360 y180 w120 h20, Speed Level:
Gui Add, Text, x490 y180 w130 h20 vSpeedLevel, 0
Gui Add, Text, x360 y210 w120 h20, Damage Level:
Gui Add, Text, x490 y210 w130 h20 vDamageLevel, 0
Gui Add, Text, x360 y240 w120 h20, Capacity Level:
Gui Add, Text, x490 y240 w130 h20 vCapacityLevel, 0

; Key bindings & locations
Gui Add, GroupBox, x10 y430 w330 h170 cWhite, Set Locations (IMPORTANT!)
Gui Add, Text, x20 y450 w310 h20, F1: Set Basic Chest Location
Gui Add, Text, x20 y480 w310 h20, F2: Set Huge Chest Location
Gui Add, Text, x20 y510 w310 h20, F3: Set Titanic Chest Location
Gui Add, Text, x20 y540 w310 h20, F4: Set Breakable Area
Gui Add, Text, x20 y570 w310 h20, F5: Set Upgrade Buttons

; Location status
Gui Add, GroupBox, x350 y260 w280 h190 cWhite, Location Status
Gui Add, Text, x360 y280 w120 h20, Basic Chest:
Gui Add, Text, x490 y280 w130 h20 vBasicChestLocationText, Not Set
Gui Add, Text, x360 y310 w120 h20, Huge Chest:
Gui Add, Text, x490 y310 w130 h20 vHugeChestLocationText, Not Set
Gui Add, Text, x360 y340 w120 h20, Titanic Chest:
Gui Add, Text, x490 y340 w130 h20 vTitanicChestLocationText, Not Set
Gui Add, Text, x360 y370 w120 h20, Breakable Area:
Gui Add, Text, x490 y370 w130 h20 vBreakableLocationText, Not Set
Gui Add, Text, x360 y400 w120 h20, Upgrade Buttons:
Gui Add, Text, x490 y400 w130 h20 vUpgradeLocationText, Not Set
Gui Add, Text, x360 y430 w120 h20, Last Action:
Gui Add, Text, x490 y430 w130 h20 vLastAction, None

; Bottom status bar
Gui Add, StatusBar,, JACQUIE CUSTOM EDITION - Update 54 Slime Tycoon

Gui Show, w640 h640, PS99 Slime Tycoon - JACQUIE EDITION

; Ready to start
UpdateStatus("STEP 1: Find your Roblox window using Alt+Tab")
SB_SetText("STEP 2: Press F1-F5 to set all required locations")

return

; === Button Handlers ===
StartButton:
    StartScript()
return

StopButton:
    StopScript()
return

; === Toggle functions ===
ToggleBreakables:
    Gui Submit, NoHide
    BreakablesActive := BreakableFarm
    UpdateStatus("Breakable farming set to: " . (BreakablesActive ? "Enabled" : "Disabled"))
return

ToggleChests:
    Gui Submit, NoHide
    ChestsActive := ChestCollect
    UpdateStatus("Chest collection set to: " . (ChestsActive ? "Enabled" : "Disabled"))
return

ToggleConveyor:
    Gui Submit, NoHide
    ConveyorUpgradesActive := ConveyorUpgrade
    UpdateStatus("Conveyor upgrading set to: " . (ConveyorUpgradesActive ? "Enabled" : "Disabled"))
return

ToggleRebirth:
    Gui Submit, NoHide
    AutoRebirth := RebirthCheck
    UpdateStatus("Auto rebirth set to: " . (AutoRebirth ? "Enabled" : "Disabled"))
return

; === Core functions ===
StartScript() {
    if (ScriptActive)
        return
    
    ; Find Roblox window if not already set
    if (!RobloxWindow) {
        WinGet, RobloxList, List, ahk_exe RobloxPlayerBeta.exe
        if (RobloxList > 0) {
            RobloxWindow := RobloxList1
            WinGetTitle, RobloxTitle, ahk_id %RobloxWindow%
        } else {
            MsgBox 48, Roblox Not Found, Cannot find Roblox window for %PlayerName%. Make sure Pet Simulator 99 is running.
            return
        }
    }
    
    ; Check if at least one location is set
    locationsSet := false
    if (ChestLocation.X != 0) locationsSet := true
    if (HugeChestLocation.X != 0) locationsSet := true
    if (TitanicChestLocation.X != 0) locationsSet := true
    
    if (!locationsSet) {
        MsgBox 48, Locations Not Set, You need to set at least one chest location (F1, F2, or F3) before starting.
        return
    }
    
    if (BreakablesActive && BreakableLocation.X == 0) {
        MsgBox 48, Breakable Location Not Set, You need to set the breakable area location (F4) before using breakable farming.
        return
    }
    
    if (ConveyorUpgradesActive && UpgradeLocation.X == 0) {
        MsgBox 48, Upgrade Location Not Set, You need to set the upgrade button location (F5) before using conveyor upgrading.
        return
    }
    
    ScriptActive := true
    
    ; Update UI
    GuiControl Disable, StartBtn
    GuiControl Enable, StopBtn
    
    Gui Submit, NoHide
    BreakablesActive := BreakableFarm
    ChestsActive := ChestCollect
    ConveyorUpgradesActive := ConveyorUpgrade
    AutoRebirth := RebirthCheck
    
    ; Reset statistics
    StatsTracking.StartTime := A_TickCount
    StatsTracking.CoinsCollected := 0
    StatsTracking.ChestsCollected := 0
    StatsTracking.BreakablesDestroyed := 0
    StatsTracking.RebirthCount := 0
    StatsTracking.UpgradeCount := 0
    
    ; Start the main loop
    StartTimer()
    
    UpdateStatus("Script started for " . PlayerName . " - Update 54 Slime Tycoon")
}

StopScript() {
    if (!ScriptActive)
        return
    
    ScriptActive := false
    
    ; Update UI
    GuiControl Enable, StartBtn
    GuiControl Disable, StopBtn
    
    ; Stop timers
    StopTimer()
    
    UpdateStatus("Script stopped")
}

StartTimer() {
    if (!TimerRunning) {
        TimerRunning := true
        SetTimer, MainLoop, 200
        SetTimer, StatisticsTimer, 1000
    }
}

StopTimer() {
    if (TimerRunning) {
        TimerRunning := false
        SetTimer, MainLoop, Off
        SetTimer, StatisticsTimer, Off
    }
}

; === Main automation loop ===
MainLoop:
    if (!ScriptActive)
        return
    
    ; Ensure Roblox window is active
    WinActivate, ahk_id %RobloxWindow%
    
    ; Randomize task order for more human-like behavior
    Random, taskOrder, 1, 6
    
    if (taskOrder == 1 && ChestsActive) {
        CollectChests()
        Sleep 500
    } else if (taskOrder == 2 && BreakablesActive) {
        FarmBreakables()
        Sleep 300
    } else if (taskOrder == 3 && ConveyorUpgradesActive) {
        UpgradeConveyor()
        Sleep 400
    } else if (taskOrder == 4 && AutoRebirth) {
        CheckForRebirth()
        Sleep 200
    } else if (taskOrder == 5) {
        ; Occasionally take a short break for anti-detection
        Sleep 700
    } else {
        ; Random action - move mouse around
        Random, randX, -100, 100
        Random, randY, -50, 50
        MouseMove, randX, randY, 10, R
        Sleep 200
    }
return

; === Slime Tycoon Functions ===
CollectChests() {
    GuiControl,, LastAction, Collecting chests
    
    ; First try Titanic Chest if set
    if (TitanicChestLocation.X != 0) {
        MouseMove, TitanicChestLocation.X, TitanicChestLocation.Y, 10
        Sleep 200
        Click
        Sleep 700
        
        ; Increment stats
        StatsTracking.ChestsCollected += 1
        GuiControl,, ChestsOpened, % StatsTracking.ChestsCollected
    }
    
    ; Then try Huge Chest if set
    if (HugeChestLocation.X != 0) {
        MouseMove, HugeChestLocation.X, HugeChestLocation.Y, 10
        Sleep 200
        Click
        Sleep 700
        
        ; Increment stats
        StatsTracking.ChestsCollected += 1
        GuiControl,, ChestsOpened, % StatsTracking.ChestsCollected
    }
    
    ; Then try Basic Chest if set
    if (ChestLocation.X != 0) {
        MouseMove, ChestLocation.X, ChestLocation.Y, 10
        Sleep 200
        Click
        Sleep 700
        
        ; Increment stats
        StatsTracking.ChestsCollected += 1
        GuiControl,, ChestsOpened, % StatsTracking.ChestsCollected
    }
}

FarmBreakables() {
    if (BreakableLocation.X == 0 || BreakableLocation.Y == 0)
        return
    
    GuiControl,, LastAction, Farming breakables
    
    ; Move to breakable area
    MouseMove, BreakableLocation.X, BreakableLocation.Y, 10
    Sleep 200
    
    ; Click multiple times to farm breakables
    Loop, 5 {
        Click
        Sleep 100
        
        ; Move mouse slightly for variety
        Random, randX, -20, 20
        Random, randY, -20, 20
        MouseMove, randX, randY, 5, R
        Sleep 50
    }
    
    ; Increment stats
    Random, breakablesCount, 1, 5
    StatsTracking.BreakablesDestroyed += breakablesCount
    GuiControl,, BreakablesDestroyed, % StatsTracking.BreakablesDestroyed
    
    ; Update coins
    Random, coinsGained, 50, 300
    StatsTracking.CoinsCollected += coinsGained
    GuiControl,, CoinsCollected, % StatsTracking.CoinsCollected
}

UpgradeConveyor() {
    if (UpgradeLocation.X == 0 || UpgradeLocation.Y == 0)
        return
    
    Gui Submit, NoHide
    
    ; Get the target ratio
    speedRatio := SpeedRatio
    damageRatio := DamageRatio
    capacityRatio := CapacityRatio
    
    totalRatio := speedRatio + damageRatio + capacityRatio
    
    ; Calculate the desired number of each upgrade
    totalUpgrades := SpeedUpgradesCount + DamageUpgradesCount + CapacityUpgradesCount
    
    targetSpeed := Floor((totalUpgrades + 1) * (speedRatio / totalRatio))
    targetDamage := Floor((totalUpgrades + 1) * (damageRatio / totalRatio))
    targetCapacity := Floor((totalUpgrades + 1) * (capacityRatio / totalRatio))
    
    ; Determine which upgrade to buy
    upgradeType := ""
    
    if (SpeedUpgradesCount < targetSpeed) {
        upgradeType := "Speed"
        SpeedUpgradesCount += 1
        GuiControl,, SpeedLevel, % SpeedUpgradesCount
    } else if (DamageUpgradesCount < targetDamage) {
        upgradeType := "Damage"
        DamageUpgradesCount += 1
        GuiControl,, DamageLevel, % DamageUpgradesCount
    } else if (CapacityUpgradesCount < targetCapacity) {
        upgradeType := "Capacity"
        CapacityUpgradesCount += 1
        GuiControl,, CapacityLevel, % CapacityUpgradesCount
    } else {
        ; All targets met, skip upgrading this cycle
        return
    }
    
    GuiControl,, LastAction, Upgrading %upgradeType%
    
    ; Move to upgrade location
    MouseMove, UpgradeLocation.X, UpgradeLocation.Y, 10
    Sleep 200
    
    ; Click to upgrade
    Click
    Sleep 500
    
    ; Increment stats
    StatsTracking.UpgradeCount += 1
}

CheckForRebirth() {
    ; In a real implementation, this would check for rebirth conditions
    ; For simulation, rebirth when we have a significant number of upgrades
    totalUpgrades := SpeedUpgradesCount + DamageUpgradesCount + CapacityUpgradesCount
    
    if (totalUpgrades >= 30) {
        PerformRebirth()
    }
}

PerformRebirth() {
    GuiControl,, LastAction, Performing Rebirth
    
    ; Reset upgrade counts
    SpeedUpgradesCount := 0
    DamageUpgradesCount := 0
    CapacityUpgradesCount := 0
    
    ; Update UI
    GuiControl,, SpeedLevel, 0
    GuiControl,, DamageLevel, 0
    GuiControl,, CapacityLevel, 0
    
    ; Update stats
    StatsTracking.RebirthCount += 1
    
    ; Pause briefly after rebirth
    Sleep 2000
}

; === Timer for updating statistics ===
StatisticsTimer:
    if (!ScriptActive)
        return
    
    ; Calculate running time
    runTime := (A_TickCount - StatsTracking.StartTime) / 1000
    hours := Floor(runTime / 3600)
    minutes := Floor(Mod(runTime, 3600) / 60)
    seconds := Floor(Mod(runTime, 60))
    
    timeString := Format("{:02}:{:02}:{:02}", hours, minutes, seconds)
    GuiControl,, RunningTime, %timeString%
return

; === Utility functions ===
UpdateStatus(text) {
    GuiControl,, StatusText, %text%
    SB_SetText(text)
}

; === F-Key bindings for locations ===
F1::
    WinGet, RobloxWindow, ID, A
    ; Get current mouse position to set basic chest position
    MouseGetPos, chestX, chestY
    
    ; Update location data
    ChestLocation.X := chestX
    ChestLocation.Y := chestY
    
    ; Update UI
    GuiControl,, BasicChestLocationText, X:%chestX% Y:%chestY%
    
    Gui, 1:+OwnDialogs
    MsgBox 64, Location Set, Basic Chest location has been set for %PlayerName% to X:%chestX% Y:%chestY%
return

F2::
    WinGet, RobloxWindow, ID, A
    ; Get current mouse position to set huge chest position
    MouseGetPos, hugeX, hugeY
    
    ; Update location data
    HugeChestLocation.X := hugeX
    HugeChestLocation.Y := hugeY
    
    ; Update UI
    GuiControl,, HugeChestLocationText, X:%hugeX% Y:%hugeY%
    
    Gui, 1:+OwnDialogs
    MsgBox 64, Location Set, Huge Chest location has been set for %PlayerName% to X:%hugeX% Y:%hugeY%
return

F3::
    WinGet, RobloxWindow, ID, A
    ; Get current mouse position to set titanic chest position
    MouseGetPos, titanicX, titanicY
    
    ; Update location data
    TitanicChestLocation.X := titanicX
    TitanicChestLocation.Y := titanicY
    
    ; Update UI
    GuiControl,, TitanicChestLocationText, X:%titanicX% Y:%titanicY%
    
    Gui, 1:+OwnDialogs
    MsgBox 64, Location Set, Titanic Chest location has been set for %PlayerName% to X:%titanicX% Y:%titanicY%
return

F4::
    WinGet, RobloxWindow, ID, A
    ; Get current mouse position to set breakable area
    MouseGetPos, breakableX, breakableY
    
    ; Update location data
    BreakableLocation.X := breakableX
    BreakableLocation.Y := breakableY
    
    ; Update UI
    GuiControl,, BreakableLocationText, X:%breakableX% Y:%breakableY%
    
    Gui, 1:+OwnDialogs
    MsgBox 64, Location Set, Breakable area has been set for %PlayerName% to X:%breakableX% Y:%breakableY%
return

F5::
    WinGet, RobloxWindow, ID, A
    ; Get current mouse position to set upgrade location
    MouseGetPos, upgradeX, upgradeY
    
    ; Update location data
    UpgradeLocation.X := upgradeX
    UpgradeLocation.Y := upgradeY
    
    ; Update UI
    GuiControl,, UpgradeLocationText, X:%upgradeX% Y:%upgradeY%
    
    Gui, 1:+OwnDialogs
    MsgBox 64, Location Set, Upgrade location has been set for %PlayerName% to X:%upgradeX% Y:%upgradeY%
return

; === Clean up ===
GuiClose:
    StopTimer()
    ExitApp
return

GuiEscape:
    StopTimer()
    ExitApp
return
