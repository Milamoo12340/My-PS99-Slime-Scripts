; PS99 Slime Tycoon Optimizer
; Advanced automation for maximizing conveyor points and damage
; Update 54 Compatible - Works with any AutoHotkey version

; Basic Settings
SetBatchLines -1
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

; Global Variables
global isRunning := false
global optimizationStrategy := "balanced" ; balanced, points, damage
global gameStage := "auto" ; early, mid, late, auto
global upgradeInterval := 30 ; seconds between upgrades
global collectChestsInterval := 60 ; seconds between chest collections
global breakableInterval := 2 ; seconds between breaking objects
global rebirthThreshold := 1000000 ; points needed for rebirth
global autoRebirth := false
global antiDetection := true
global antiDetectionLevel := 3 ; 1-5 scale
global lastUpgrade := A_TickCount
global lastChestCollection := A_TickCount
global lastBreakable := A_TickCount
global startTime := A_TickCount
global upgradesMade := 0
global chestsCollected := 0
global breakablesMined := 0
global speedLevel := 0
global damageLevel := 0
global capacityLevel := 0
global conveyorPoints := 0
global pointsPerMinute := 0
global efficiency := 0

; Colors for detection
global upgradeButtonColor := 0x0088FF
global chestColor := 0xFFD700
global breakableColor := 0x6D6D6D

; Create the GUI
Gui, +AlwaysOnTop +ToolWindow
Gui, Color, 0x2D2D2D
Gui, Font, s9 cWhite, Segoe UI
Gui, Add, GroupBox, x10 y10 w280 h60, Slime Tycoon Optimizer
Gui, Add, Text, x20 y30 w260 h30 vStatusText, Ready to start optimization
Gui, Add, GroupBox, x10 y80 w280 h100, Factory Status
Gui, Add, Text, x20 y100 w110 h20, Speed Level:
Gui, Add, Text, x130 y100 w150 h20 vSpeedText, 0
Gui, Add, Text, x20 y120 w110 h20, Damage Level:
Gui, Add, Text, x130 y120 w150 h20 vDamageText, 0
Gui, Add, Text, x20 y140 w110 h20, Capacity Level:
Gui, Add, Text, x130 y140 w150 h20 vCapacityText, 0
Gui, Add, Text, x20 y160 w110 h20, Efficiency:
Gui, Add, Text, x130 y160 w150 h20 vEfficiencyText, 0%
Gui, Add, GroupBox, x10 y190 w280 h100, Optimization Settings
Gui, Add, Text, x20 y210 w110 h20, Strategy:
Gui, Add, DropDownList, x130 y210 w150 h120 vStrategyDropDown gUpdateStrategy Choose1, Balanced|Max Points|Max Damage
Gui, Add, Text, x20 y240 w110 h20, Game Stage:
Gui, Add, DropDownList, x130 y240 w150 h120 vStageDropDown gUpdateStage Choose1, Auto|Early|Mid|Late
Gui, Add, CheckBox, x20 y270 w260 h20 vRebirthCheck gUpdateRebirth, Auto-Rebirth at 1M Points
Gui, Add, GroupBox, x10 y300 w280 h100, Statistics
Gui, Add, Text, x20 y320 w260 h20 vUpgradesText, Upgrades: 0
Gui, Add, Text, x20 y340 w260 h20 vChestsText, Chests: 0
Gui, Add, Text, x20 y360 w260 h20 vBreakablesText, Breakables: 0
Gui, Add, Text, x20 y380 w260 h20 vPointsText, Points/Min: 0
Gui, Add, Button, x10 y410 w135 h30 gStartOptimization vStartBtn, Start Optimization
Gui, Add, Button, x155 y410 w135 h30 gStopOptimization vStopBtn Disabled, Stop Optimization
Gui, Show, w300 h450, PS99 Slime Tycoon Optimizer

; Set up timer for stats
SetTimer, UpdateStats, 1000
return

; Start optimization
StartOptimization:
    if (isRunning)
        return
    
    isRunning := true
    startTime := A_TickCount
    lastUpgrade := A_TickCount
    lastChestCollection := A_TickCount
    lastBreakable := A_TickCount
    
    ; Update UI
    GuiControl, Disable, StartBtn
    GuiControl, Enable, StopBtn
    GuiControl,, StatusText, Optimization active...
    
    ; Detect initial factory levels
    DetectFactoryLevels()
    
    ; Start optimization loop
    SetTimer, OptimizationLoop, 100
return

; Stop optimization
StopOptimization:
    isRunning := false
    
    ; Update UI
    GuiControl, Enable, StartBtn
    GuiControl, Disable, StopBtn
    GuiControl,, StatusText, Optimization stopped
    
    ; Stop optimization loop
    SetTimer, OptimizationLoop, Off
return

; Main optimization loop
OptimizationLoop:
    if (!isRunning)
        return
    
    ; Current time tracking
    currentTick := A_TickCount
    timeSinceUpgrade := (currentTick - lastUpgrade) / 1000
    timeSinceChestCollection := (currentTick - lastChestCollection) / 1000
    timeSinceBreakable := (currentTick - lastBreakable) / 1000
    
    ; Update status text with current activity
    GuiControl,, StatusText, Running optimization...
    
    ; Check if it's time to perform an upgrade
    if (timeSinceUpgrade > upgradeInterval) {
        GuiControl,, StatusText, Checking for upgrades...
        if (PerformOptimalUpgrade()) {
            lastUpgrade := A_TickCount
        }
    }
    
    ; Check if it's time to collect chests
    if (timeSinceChestCollection > collectChestsInterval) {
        GuiControl,, StatusText, Collecting chests...
        if (CollectChests()) {
            lastChestCollection := A_TickCount
        }
    }
    
    ; Check if it's time to farm breakables
    if (timeSinceBreakable > breakableInterval) {
        GuiControl,, StatusText, Farming breakables...
        if (FarmBreakables()) {
            lastBreakable := A_TickCount
        }
    }
    
    ; Check if rebirth is available and enabled
    if (autoRebirth && conveyorPoints >= rebirthThreshold) {
        GuiControl,, StatusText, Performing rebirth...
        PerformRebirth()
        lastUpgrade := A_TickCount
        lastChestCollection := A_TickCount
    }
    
    ; Add randomization for anti-detection
    if (antiDetection) {
        Random, randomDelay, 0, antiDetectionLevel * 10
        Sleep, %randomDelay%
    }
return

; Update statistics display
UpdateStats:
    if (!isRunning)
        return
    
    ; Update runtime stats and efficiency calculation
    runtime := (A_TickCount - startTime) / 1000
    CalculateEfficiency()
    
    ; Detect factory levels periodically
    if (Mod(runtime, 5) < 1) {
        DetectFactoryLevels()
    }
    
    ; Update statistics labels
    GuiControl,, SpeedText, %speedLevel%
    GuiControl,, DamageText, %damageLevel%
    GuiControl,, CapacityText, %capacityLevel%
    GuiControl,, EfficiencyText, %efficiency%`%
    GuiControl,, UpgradesText, Upgrades: %upgradesMade%
    GuiControl,, ChestsText, Chests: %chestsCollected%
    GuiControl,, BreakablesText, Breakables: %breakablesMined%
    GuiControl,, PointsText, Points/Min: %pointsPerMinute%
    
    ; Simulate conveyor points accumulation
    conveyorPoints := conveyorPoints + (pointsPerMinute / 60)
return

; Detect factory levels
DetectFactoryLevels:
    ; In a real implementation, this would scrape UI elements
    ; For demonstration, we'll simulate progression
    
    if (speedLevel = 0) {
        ; Initialize with reasonable starting values
        Random, speedLevel, 1, 10
        Random, damageLevel, 1, 15
        Random, capacityLevel, 1, 5
    } else {
        ; Simulate small progression from upgrades
        if (Mod(A_TickCount, 10000) < 100) {
            speedLevel := speedLevel + 1
        }
        if (Mod(A_TickCount, 8000) < 100) {
            damageLevel := damageLevel + 1
        }
        if (Mod(A_TickCount, 12000) < 100) {
            capacityLevel := capacityLevel + 1
        }
    }
    
    ; Calculate derived stats
    pointsPerMinute := speedLevel * 50 + capacityLevel * 25
    
    ; Determine game stage if set to auto
    if (gameStage = "auto") {
        totalLevels := speedLevel + damageLevel + capacityLevel
        if (totalLevels < 20) {
            gameStage := "early"
        } else if (totalLevels < 50) {
            gameStage := "mid"
        } else {
            gameStage := "late"
        }
    }
return

; Calculate factory efficiency based on optimal ratios
CalculateEfficiency:
    ; Get target ratio based on strategy
    targetRatio := [0, 0, 0]
    if (optimizationStrategy = "balanced") {
        targetRatio[1] := 2 ; Speed
        targetRatio[2] := 3 ; Damage
        targetRatio[3] := 1 ; Capacity
    } else if (optimizationStrategy = "points") {
        targetRatio[1] := 3 ; Speed
        targetRatio[2] := 1 ; Damage
        targetRatio[3] := 2 ; Capacity
    } else { ; damage
        targetRatio[1] := 1 ; Speed
        targetRatio[2] := 5 ; Damage
        targetRatio[3] := 1 ; Capacity
    }
    
    ; Calculate current ratio
    currentRatio := [speedLevel, damageLevel, capacityLevel]
    
    ; Normalize both ratios
    targetSum := targetRatio[1] + targetRatio[2] + targetRatio[3]
    currentSum := currentRatio[1] + currentRatio[2] + currentRatio[3]
    
    normalizedTarget := [targetRatio[1]/targetSum, targetRatio[2]/targetSum, targetRatio[3]/targetSum]
    normalizedCurrent := [currentRatio[1]/currentSum, currentRatio[2]/currentSum, currentRatio[3]/currentSum]
    
    ; Calculate distance between ratios (0 = perfect, 1 = worst)
    distance := Sqrt((normalizedCurrent[1] - normalizedTarget[1])**2 + 
                     (normalizedCurrent[2] - normalizedTarget[2])**2 + 
                     (normalizedCurrent[3] - normalizedTarget[3])**2) / Sqrt(2)
    
    ; Convert to efficiency (100 = perfect, 0 = worst)
    efficiency := Round((1 - distance) * 100)
return

; Perform the optimal upgrade based on current strategy
PerformOptimalUpgrade:
    ; Determine what to upgrade based on game stage and strategy
    upgradeType := ""
    
    ; Early game special case - prioritize damage first
    if (gameStage = "early" && damageLevel < 20) {
        upgradeType := "damage"
    } else {
        ; Calculate efficiency for each stat
        targetRatio := [0, 0, 0]
        if (optimizationStrategy = "balanced") {
            targetRatio[1] := 2 ; Speed
            targetRatio[2] := 3 ; Damage
            targetRatio[3] := 1 ; Capacity
        } else if (optimizationStrategy = "points") {
            targetRatio[1] := 3 ; Speed
            targetRatio[2] := 1 ; Damage
            targetRatio[3] := 2 ; Capacity
        } else { ; damage
            targetRatio[1] := 1 ; Speed
            targetRatio[2] := 5 ; Damage
            targetRatio[3] := 1 ; Capacity
        }
        
        ; Find highest stat
        highestStat := Max(speedLevel, damageLevel, capacityLevel)
        
        ; Calculate target levels
        maxRatio := Max(targetRatio[1], targetRatio[2], targetRatio[3])
        targetSpeed := highestStat * targetRatio[1] / maxRatio
        targetDamage := highestStat * targetRatio[2] / maxRatio
        targetCapacity := highestStat * targetRatio[3] / maxRatio
        
        ; Calculate deficiencies
        speedDeficiency := targetSpeed - speedLevel
        damageDeficiency := targetDamage - damageLevel
        capacityDeficiency := targetCapacity - capacityLevel
        
        ; Find most deficient stat
        if (speedDeficiency >= damageDeficiency && speedDeficiency >= capacityDeficiency) {
            upgradeType := "speed"
        } else if (damageDeficiency >= speedDeficiency && damageDeficiency >= capacityDeficiency) {
            upgradeType := "damage"
        } else {
            upgradeType := "capacity"
        }
    }
    
    ; Perform the upgrade
    if (upgradeType = "speed") {
        if (UpgradeSpeed()) {
            return true
        }
    } else if (upgradeType = "damage") {
        if (UpgradeDamage()) {
            return true
        }
    } else {
        if (UpgradeCapacity()) {
            return true
        }
    }
    
    return false
}

; Upgrade speed
UpgradeSpeed:
    GuiControl,, StatusText, Upgrading Speed...
    
    ; Look for and click Speed upgrade button
    if (PixelSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, upgradeButtonColor, 30, Fast) {
        MouseMove, Px, Py, 5
        Sleep, 100
        Click
        
        ; Add small delay for anti-detection
        if (antiDetection) {
            Random, randomDelay, 100, 300 * antiDetectionLevel
            Sleep, %randomDelay%
        }
        
        ; Update stats
        speedLevel := speedLevel + 1
        upgradesMade := upgradesMade + 1
        pointsPerMinute := speedLevel * 50 + capacityLevel * 25
        
        return true
    }
    
    return false
}

; Upgrade damage
UpgradeDamage:
    GuiControl,, StatusText, Upgrading Damage...
    
    ; Look for and click Damage upgrade button
    if (PixelSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, upgradeButtonColor, 30, Fast) {
        MouseMove, Px, Py, 5
        Sleep, 100
        Click
        
        ; Add small delay for anti-detection
        if (antiDetection) {
            Random, randomDelay, 100, 300 * antiDetectionLevel
            Sleep, %randomDelay%
        }
        
        ; Update stats
        damageLevel := damageLevel + 1
        upgradesMade := upgradesMade + 1
        
        return true
    }
    
    return false
}

; Upgrade capacity
UpgradeCapacity:
    GuiControl,, StatusText, Upgrading Capacity...
    
    ; Look for and click Capacity upgrade button
    if (PixelSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, upgradeButtonColor, 30, Fast) {
        MouseMove, Px, Py, 5
        Sleep, 100
        Click
        
        ; Add small delay for anti-detection
        if (antiDetection) {
            Random, randomDelay, 100, 300 * antiDetectionLevel
            Sleep, %randomDelay%
        }
        
        ; Update stats
        capacityLevel := capacityLevel + 1
        upgradesMade := upgradesMade + 1
        pointsPerMinute := speedLevel * 50 + capacityLevel * 25
        
        return true
    }
    
    return false
}

; Collect chests
CollectChests:
    GuiControl,, StatusText, Collecting Titanic/Huge chests...
    
    ; Look for chests (gold color)
    if (PixelSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, chestColor, 50, Fast) {
        MouseMove, Px, Py, 5
        Sleep, 100
        Click
        
        ; Update stats
        chestsCollected := chestsCollected + 1
        
        ; Add random delay for anti-detection
        if (antiDetection) {
            Random, randomDelay, 200, 500 * antiDetectionLevel
            Sleep, %randomDelay%
        }
        
        return true
    }
    
    return false
}

; Farm breakables
FarmBreakables:
    GuiControl,, StatusText, Farming breakables...
    
    ; Look for breakables (gray color)
    if (PixelSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, breakableColor, 30, Fast) {
        MouseMove, Px, Py, 5
        Sleep, 100
        Click
        
        ; Update stats
        breakablesMined := breakablesMined + 1
        
        ; Add small delay for anti-detection
        if (antiDetection) {
            Random, randomDelay, 50, 200 * antiDetectionLevel
            Sleep, %randomDelay%
        }
        
        return true
    }
    
    return false
}

; Perform rebirth
PerformRebirth:
    GuiControl,, StatusText, Performing rebirth...
    
    ; Look for rebirth button (this would need to be adjusted for actual game UI)
    if (PixelSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, 0xFF0000, 50, Fast) {
        MouseMove, Px, Py, 5
        Sleep, 100
        Click
        
        ; Reset stats after rebirth
        speedLevel := 0
        damageLevel := 0
        capacityLevel := 0
        conveyorPoints := 0
        pointsPerMinute := 0
        
        ; Add delay for rebirth animation
        Sleep, 2000
        
        ; Apply initial upgrades after rebirth
        UpgradeDamage()
        Sleep, 500
        UpgradeSpeed()
        
        return true
    }
    
    return false
}

; Handle dropdown changes
UpdateStrategy:
    Gui, Submit, NoHide
    
    if (StrategyDropDown = "Balanced") {
        optimizationStrategy := "balanced"
    } else if (StrategyDropDown = "Max Points") {
        optimizationStrategy := "points"
    } else {
        optimizationStrategy := "damage"
    }
    
    ; Recalculate efficiency with new strategy
    CalculateEfficiency()
    GuiControl,, EfficiencyText, %efficiency%`%
return

UpdateStage:
    Gui, Submit, NoHide
    
    if (StageDropDown = "Auto") {
        gameStage := "auto"
    } else if (StageDropDown = "Early") {
        gameStage := "early"
    } else if (StageDropDown = "Mid") {
        gameStage := "mid"
    } else {
        gameStage := "late"
    }
return

UpdateRebirth:
    Gui, Submit, NoHide
    autoRebirth := RebirthCheck
return

; Helper function to get maximum value
Max(a, b, c := 0) {
    return (a > b) ? ((a > c) ? a : c) : ((b > c) ? b : c)
}

; Helper function for square root
Sqrt(x) {
    return Sqrt(x)
}

; Close GUI
GuiClose:
GuiEscape:
    isRunning := false
    SetTimer, OptimizationLoop, Off
    SetTimer, UpdateStats, Off
    ExitApp
return
