; PS99 SLIME TYCOON DOMINATOR
; Ultimate Slime Blob Destruction System
; Custom version for Milamoo12340 (Jacquie)

#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
CoordMode Mouse Screen
#KeyHistory 0  ; Disable key history for lower detectable footprint

; =================== GLOBAL VARIABLES ===================
global SLIME_VERSION := "5.3.2"  ; Current version
global USERNAME := "milamoo12340"  ; Roblox username
global DISPLAY_NAME := "Jacquie"  ; Roblox display name
global Active := false
global AreaCenterX := 0
global AreaCenterY := 0
global AreaWidth := 500
global AreaHeight := 500
global RobloxHwnd := 0  ; Handle to Roblox window
global WindowLeft := 0  ; Left position of Roblox window
global WindowTop := 0   ; Top position of Roblox window
global WindowWidth := 0 ; Width of Roblox window
global WindowHeight := 0 ; Height of Roblox window
global GridSize := 10  ; Ultra-fine grid for maximum coverage
global BreakDelay := 1  ; Ultra-fast click delay (milliseconds)
global PowerAmount := 150  ; Maximum tap power multiplier
global ComboPoints := 0  ; Combo system
global ComboMultiplier := 1.0  ; Combo damage multiplier
global ComboDecayRate := 0.02  ; How fast combo decays (lower = better)
global LastBreakTime := 0  ; For combo tracking
global SlimesDestroyed := 0
global PointsEarned := 0
global StartTime := 0
global LeaderboardPosition := 0
global LastLeaderboardCheck := 0
global UseQuantumBreak := true  ; Multi-point breaking
global UseHyperspeed := true  ; Accelerated breaking
global UseColorDetection := true  ; Detect slime blobs by color
global UsePatternRecognition := true  ; Recognize patterns of slimes
global UseComboOptimizer := true  ; Optimize combo building
global UsePriorityTargeting := true  ; Target high-value slimes first
global UseAdaptiveTiming := true  ; Adapt timing for maximum efficiency
global SlimeDetectionRadius := 10  ; Radius for color detection
global SlimeColorTolerance := 20  ; Color tolerance (0-255)
global SlimeOrangeColor := [255, 165, 0]  ; RGB for orange slime blobs
global ScanResolution := 5  ; Pixels between scan points
global SlimeDetectionThreshold := 0.8  ; Required match percentage
global LastScanTime := 0  ; Last time full scan was performed
global ScanInterval := 1000  ; Milliseconds between scans
global TargetSlimes := []  ; Array of detected slimes
global HighValueSlimes := []  ; Array of high-value slimes
global SlimeValues := {}  ; Values of different slime types
global ExecutionMode := 5  ; 1=Balanced, 2=Speed, 3=Power, 4=Stealth, 5=Extreme
global DetectionAvoidanceLevel := 100  ; How aggressive anti-detection is
global RapidClickMode := true  ; Use rapid clicks for high DPS
global PulseMode := false  ; Pulse mode for wider coverage
global PulseCycleTime := 200  ; Pulse cycle time (ms)
global PulsePhase := 0  ; Current pulse phase
global PulseMaxRadius := 200  ; Maximum pulse radius
global PulseGrowthRate := 5  ; Pulse growth rate
global PulsePoints := 8  ; Points around pulse circle
global PulseIntensity := 5  ; Clicks per pulse point
global BurstMode := false  ; Burst mode for maximum damage
global BurstDuration := 5000  ; Burst duration (ms)
global BurstStartTime := 0  ; When burst started
global BurstIntensity := 10  ; Burst intensity multiplier
global SwipeMode := false  ; Swipe mode for line clearing
global SwipeLength := 200  ; Swipe length
global SwipeAngle := 0  ; Current swipe angle
global SwipeSpeed := 5  ; Swipe speed
global ThreadCount := 8  ; Number of simulation threads
global ColorDetectionEnabled := true  ; Detect slimes by color
global SlimeOrangeLower := [220, 120, 0]  ; Lower RGB bounds for orange
global SlimeOrangeUpper := [255, 200, 60]  ; Upper RGB bounds for orange
global PointsOverlayEnabled := true  ; Show points overlay
global ComboOverlayEnabled := true  ; Show combo overlay
global LeaderboardOverlayEnabled := true  ; Show leaderboard overlay
global ClickSequence := []  ; Sequence of optimized clicks
global OptimalClickPatterns := []  ; Optimal click patterns
global LastPointsUpdate := 0  ; Last time points were updated
global CurrentPointsPerSecond := 0  ; Current points per second
global MaxPointsPerSecond := 0  ; Maximum points per second achieved
global PowerCurve := [1.0, 1.5, 2.0, 3.0, 5.0, 8.0, 13.0, 21.0]  ; Power curve based on Fibonacci
global PowerCurveIndex := 0  ; Current index in power curve
global PatternRecognitionData := {}  ; Data for pattern recognition
global HighEfficiencyZones := []  ; Zones with high efficiency
global OptimalComboSequence := [1, 1, 2, 3, 5, 8, 5, 3, 2, 1]  ; Optimal combo sequence
global ComboSequenceIndex := 0  ; Current index in combo sequence
global MouseAcceleration := 0  ; Mouse acceleration factor
global MouseDecceleration := 0  ; Mouse decceleration factor
global MouseJitter := 0  ; Mouse jitter factor
global MouseSmoothing := 2  ; Mouse smoothing factor
global MousePrediction := true  ; Predict slime movement
global MousePredictionFactor := 0.5  ; Prediction factor
global SlimeRespawnTime := {}  ; Respawn times for slimes
global SlimePriorities := {}  ; Priorities for different slimes
global ActiveBonusMultiplier := 1.0  ; Active bonus multiplier
global ServerBonusActive := false  ; If server bonus is active
global TimeBonusActive := false  ; If time bonus is active
global EggBonusActive := false  ; If egg bonus is active
global BonusMultiplierTotal := 1.0  ; Total bonus multiplier
global LeaderboardData := []  ; Leaderboard data
global LeaderboardUpdateInterval := 5000  ; Leaderboard update interval (ms)
global BreakSequence := []  ; Sequence of breaks to perform
global SequenceIndex := 0  ; Current index in sequence
global AdaptiveTargeting := true  ; Adapt targeting based on results
global TargetHistory := []  ; History of targets
global HistorySize := 100  ; Size of target history
global HistoryIndex := 0  ; Current index in history
global TargetSuccess := {}  ; Success rate for targets
global TargetValue := {}  ; Value of targets
global OptimizationEnabled := true  ; Enable optimization
global OptimizationInterval := 10000  ; Optimization interval (ms)
global LastOptimizationTime := 0  ; Last optimization time
global PerformanceMetrics := {}  ; Performance metrics
global SlimeHealthMap := {}  ; Map of slime health
global SlimeHealthDecay := 0.1  ; Health decay rate
global SlimeHealthRegen := 0.05  ; Health regeneration rate
global SlimeRespawnMap := {}  ; Map of slime respawn times
global SlimeDeathAnimationTime := 200  ; Time for death animation (ms)
global SlimeRespawnAnimationTime := 500  ; Time for respawn animation (ms)
global ScoreMultipliers := [1.0, 1.5, 2.0, 3.0, 5.0]  ; Score multipliers
global ScoreMultiplierThresholds := [0, 10, 25, 50, 100]  ; Thresholds for multipliers
global CurrentScoreMultiplier := 1.0  ; Current score multiplier
global StreakCounter := 0  ; Current streak
global MaxStreak := 0  ; Maximum streak achieved
global InstantBreakEnabled := true  ; Enable instant break
global InstantBreakCooldown := 10000  ; Cooldown for instant break (ms)
global LastInstantBreak := 0  ; Last time instant break was used
global InstantBreakReadyPct := 0  ; Percentage ready for instant break
global ComboExpiryTime := 2000  ; Time before combo expires (ms)
global SimulatedServerLatency := 0  ; Simulated server latency
global AdaptiveLatencyCompensation := true  ; Compensate for latency
global LatencyMeasurements := []  ; Latency measurements
global AvgLatency := 0  ; Average latency
global SimulatedClientFPS := 60  ; Simulated client FPS
global FPSAdaptation := true  ; Adapt to client FPS
global SlimeLifecycleTracking := true  ; Track slime lifecycle
global SlimeLifecycleMap := {}  ; Map of slime lifecycle
global SlimeActivityHeatmap := []  ; Heatmap of slime activity
global HeatmapResolution := 20  ; Resolution of heatmap
global HeatmapEnabled := true  ; Enable heatmap
global HeatmapFading := true  ; Enable heatmap fading
global HeatmapFadingRate := 0.1  ; Heatmap fading rate
global HeatmapUpdateInterval := 1000  ; Heatmap update interval (ms)
global LastHeatmapUpdate := 0  ; Last heatmap update
global HeatmapVisualization := false  ; Enable heatmap visualization
global HotspotThreshold := 0.7  ; Threshold for hotspots
global MaxHotspots := 10  ; Maximum number of hotspots
global HotspotPrioritization := true  ; Prioritize hotspots
global DiagnosticMode := false  ; Diagnostic mode
global DiagnosticData := {}  ; Diagnostic data
global DiagnosticInterval := 5000  ; Diagnostic interval (ms)
global LastDiagnosticTime := 0  ; Last diagnostic time
global DiagnosticDisplay := false  ; Display diagnostics
global PerformanceTracking := true  ; Track performance
global LastPerformanceTime := 0  ; Last performance measurement time
global PerformanceData := []  ; Performance data
global PerformanceHistory := []  ; History of performance
global PerformanceHistorySize := 100  ; Size of performance history
global PerformanceHistoryIndex := 0  ; Current index in performance history
global PerformanceUpdateInterval := 1000  ; Performance update interval (ms)
global AccuracyTracking := true  ; Track accuracy
global AccuracyHistory := []  ; History of accuracy
global AccuracyHistorySize := 100  ; Size of accuracy history
global AccuracyHistoryIndex := 0  ; Current index in accuracy history
global AccuracyUpdateInterval := 1000  ; Accuracy update interval (ms)
global PredictionEnabled := true  ; Enable prediction
global PredictionHorizon := 5  ; Prediction horizon
global PredictionModel := {}  ; Prediction model
global PredictionHistory := []  ; History of predictions
global PredictionHistorySize := 100  ; Size of prediction history
global PredictionHistoryIndex := 0  ; Current index in prediction history
global PredictionUpdateInterval := 1000  ; Prediction update interval (ms)
global LastPredictionTime := 0  ; Last prediction time
global ReinforcementLearning := true  ; Enable reinforcement learning
global ReinforcementModel := {}  ; Reinforcement learning model
global ReinforcementInterval := 10000  ; Reinforcement interval (ms)
global LastReinforcementTime := 0  ; Last reinforcement time
global ReinforcementDecay := 0.1  ; Reinforcement decay rate
global ReinforcementLearningRate := 0.1  ; Reinforcement learning rate
global ReinforcementExplorationRate := 0.1  ; Reinforcement exploration rate
global ReinforcementExplorationDecay := 0.01  ; Reinforcement exploration decay

; ====================== CREATE GUI ======================
Gui, +Resize +MinSize400x300
Gui, Color, 282828
Gui, Font, s10 cWhite, Segoe UI
Gui, Add, GroupBox, x10 y10 w300 h100 cWhite, PS99 SLIME TYCOON DOMINATOR

; Status and buttons
Gui, Font, s9 cWhite, Segoe UI
Gui, Add, Text, x20 y30 w80 h20, Status:
Gui, Add, Text, x110 y30 w190 h20 vStatusText, Ready to dominate
Gui, Add, Text, x20 y55 w280 h20, For: %DISPLAY_NAME% (%USERNAME%)
Gui, Add, Button, x20 y80 w140 h25 gStartButton vStartBtn, START DOMINATOR
Gui, Add, Button, x170 y80 w140 h25 gStopButton vStopBtn Disabled, STOP

; Execution mode selector
Gui, Add, GroupBox, x10 y120 w300 h80 cWhite, Execution Mode
Gui, Add, Radio, x20 y145 w90 h20 vBalancedRadio gUpdateExecutionMode Group, Balanced
Gui, Add, Radio, x115 y145 w80 h20 vSpeedRadio gUpdateExecutionMode, Speed
Gui, Add, Radio, x200 y145 w100 h20 vPowerRadio gUpdateExecutionMode, Power
Gui, Add, Radio, x20 y175 w90 h20 vStealthRadio gUpdateExecutionMode, Stealth
Gui, Add, Radio, x115 y175 w90 h20 vExtremeRadio gUpdateExecutionMode Checked, Extreme

; Target area settings
Gui, Add, GroupBox, x10 y210 w300 h90 cWhite, Target Area
Gui, Add, Text, x20 y235 w130, Press F1: Set Center
Gui, Add, Text, x160 y235 w140 vAreaCenterText, Not Set
Gui, Add, Text, x20 y265 w130, Width/Height:
Gui, Add, Edit, x160 y265 w60 h20 vAreaWidthEdit gUpdateAreaWidth, 500
Gui, Add, UpDown, Range50-2000, 500
Gui, Add, Edit, x225 y265 w60 h20 vAreaHeightEdit gUpdateAreaHeight, 500
Gui, Add, UpDown, Range50-2000, 500

; Breaking power settings
Gui, Add, GroupBox, x10 y310 w300 h170 cWhite, Breaking Power Settings
Gui, Add, Text, x20 y335 w130, Base Power:
Gui, Add, Slider, x160 y335 w140 h20 vPowerSlider gUpdatePower Range1-300 TickInterval20, 150
Gui, Add, Text, x20 y365 w130, Combo Decay Rate:
Gui, Add, Slider, x160 y365 w140 h20 vComboDecaySlider gUpdateComboDecay Range1-100 TickInterval5, 2
Gui, Add, Text, x20 y395, Burst Intensity:
Gui, Add, Slider, x160 y395 w140 h20 vBurstIntensitySlider gUpdateBurstIntensity Range10-500 TickInterval10, 300

; Slime targeting methods
Gui, Add, Text, x20 y425 w130, Targeting Method:
Gui, Add, DropDownList, x160 y425 w140 vTargetMethodDropdown gUpdateTargetMethod, Grid||Spiral|Random|Adaptive|Heatmap|Predictive

; Advanced settings
Gui, Add, CheckBox, x20 y455 w140 h20 vQuantumBreakCheck Checked gUpdateQuantumBreak, Quantum Break
Gui, Add, CheckBox, x160 y455 w140 h20 vHyperspeedCheck Checked gUpdateHyperspeed, Hyperspeed
Gui, Add, CheckBox, x20 y475 w140 h20 vColorDetectionCheck Checked gUpdateColorDetection, Color Detection
Gui, Add, CheckBox, x160 y475 w140 h20 vComboOptimizerCheck Checked gUpdateComboOptimizer, Combo Optimizer

; Detection avoidance (stealth) settings
Gui, Add, GroupBox, x10 y490 w300 h90 cWhite, Detection Avoidance
Gui, Add, Text, x20 y515 w130, Avoidance Level:
Gui, Add, Slider, x160 y515 w140 h20 vDetectionAvoidanceSlider gUpdateDetectionAvoidance Range0-100 TickInterval10, 100
Gui, Add, CheckBox, x20 y545 w140 h20 vRandomOffsetCheck Checked gUpdateRandomOffset, Random Offset
Gui, Add, CheckBox, x160 y545 w140 h20 vHumanizeInputCheck Checked gUpdateHumanizeInput, Humanize Input

; Statistics panel
Gui, Add, GroupBox, x320 y10 w300 h170 cWhite, Statistics
Gui, Add, Text, x335 y35 w130 h20, Slimes Destroyed:
Gui, Add, Text, x475 y35 w130 h20 vSlimesDestroyedText, 0
Gui, Add, Text, x335 y65 w130 h20, Points Earned:
Gui, Add, Text, x475 y65 w130 h20 vPointsEarnedText, 0
Gui, Add, Text, x335 y95 w130 h20, Points/Second:
Gui, Add, Text, x475 y95 w130 h20 vPointsPerSecondText, 0
Gui, Add, Text, x335 y125 w130 h20, Current Combo:
Gui, Add, Text, x475 y125 w130 h20 vCurrentComboText, 0x
Gui, Add, Text, x335 y155 w130 h20, Leaderboard Position:
Gui, Add, Text, x475 y155 w130 h20 vLeaderboardPosText, --

; Combo & power meters
Gui, Add, GroupBox, x320 y190 w300 h90 cWhite, Performance Meters
Gui, Add, Text, x335 y215 w70 h20, Combo:
Gui, Add, Progress, x405 y215 w200 h20 vComboMeter cLime, 0
Gui, Add, Text, x335 y245 w70 h20, Power:
Gui, Add, Progress, x405 y245 w200 h20 vPowerMeter cOrange, 50

; Performance metrics & hotspots
Gui, Add, GroupBox, x320 y290 w300 h170 cWhite, Hotspot Analysis
Gui, Add, ListView, x335 y315 w270 h135 Grid vHotspotList, Area|Efficiency|Value|Priority

; Add sample hotspot data
LV_Add("", "Center", "98%", "High", "1")
LV_Add("", "Top-Left", "87%", "Medium", "2")
LV_Add("", "Bottom-Right", "76%", "Medium", "3")
LV_Add("", "Top-Right", "65%", "Low", "4")
LV_Add("", "Bottom-Left", "54%", "Low", "5")

; Special abilities
Gui, Add, GroupBox, x320 y470 w300 h110 cWhite, Special Abilities & Controls
Gui, Add, Button, x335 y495 w130 h25 gTriggerBurstMode, BURST MODE
Gui, Add, Button, x475 y495 w130 h25 gTriggerInstantBreak, INSTANT BREAK
Gui, Add, Button, x335 y530 w130 h25 gTriggerPulseWave, PULSE WAVE
Gui, Add, Button, x475 y530 w130 h25 gTriggerSwipeAttack, SWIPE ATTACK

; Hotkey information
Gui, Add, Text, x335 y560 w270 h20 cYellow, F6 = START, F7 = STOP, F8 = SET WINDOW

; Show the GUI
Gui, Show, w630 h590 Resize, PS99 Slime Tycoon Dominator - %DISPLAY_NAME%

; Create overlay GUI for in-game stats (lightweight)
Gui, 2:+AlwaysOnTop -Caption +ToolWindow +E0x20
Gui, 2:Color, 000000
WinSet, TransColor, 000000 200
Gui, 2:Font, s16 cLime bold, Segoe UI
Gui, 2:Add, Text, vOverlayCombo w200 Center, COMBO: 0x
Gui, 2:Add, Text, vOverlayPower w200 Center, POWER: 100`%
Gui, 2:Add, Text, vOverlayPPS w200 Center, 0/sec
Gui, 2:Add, Text, vOverlayRank w200 Center, RANK: --
Gui, 2:Hide  ; Start hidden by default

; Create damage number overlay
Gui, 3:+AlwaysOnTop -Caption +ToolWindow +E0x20
Gui, 3:Color, 000000
WinSet, TransColor, 000000 220
Gui, 3:Font, s20 cOrange bold, Segoe UI
Gui, 3:Add, Text, vDamageNumber center w200 h40, +0
Gui, 3:Hide

; Create resize handler for GUI
Gui, +LastFound
GuiHandle := WinExist()
DllCall("SetWindowLong", "Ptr", GuiHandle, "Int", -8, "Ptr", RegisterCallback("WndProc"))
WinGet, GuiID, ID

; ====================== WINDOW MANAGEMENT ======================
; Find Roblox window
FindRobloxWindow() {
    ; Use the window info provided by user
    WinGet, RobloxHwnd, ID, ahk_class WINDOWSCLIENT ahk_exe RobloxPlayerBeta.exe
    
    if (!RobloxHwnd) {
        ; Fallback to finding any Roblox window
        WinGet, RobloxHwnd, ID, Roblox ahk_exe RobloxPlayerBeta.exe
    }
    
    if (!RobloxHwnd) {
        UpdateStatus("Cannot find Roblox window. Please make sure Roblox is running.")
        Return false
    }
    
    ; Get window position and size
    WinGetPos, WindowLeft, WindowTop, WindowWidth, WindowHeight, ahk_id %RobloxHwnd%
    
    ; Update status
    UpdateStatus("Found Roblox window: " . WindowWidth . "x" . WindowHeight)
    Return true
}

; Manually set Roblox window
ManuallySetRobloxWindow() {
    MsgBox, 262144, Set Roblox Window, Please click on the Roblox window to select it.
    WinWaitActive, ahk_exe RobloxPlayerBeta.exe,, 10
    if ErrorLevel {
        MsgBox, 262160, Error, Could not detect Roblox window after 10 seconds.
        Return false
    }
    
    WinGet, RobloxHwnd, ID, A
    WinGetClass, WinClass, ahk_id %RobloxHwnd%
    WinGetTitle, WinTitle, ahk_id %RobloxHwnd%
    
    ; Get window position and size
    WinGetPos, WindowLeft, WindowTop, WindowWidth, WindowHeight, ahk_id %RobloxHwnd%
    
    ; Update status
    UpdateStatus("Set Roblox window: " . WinTitle . " (" . WinClass . ") " . WindowWidth . "x" . WindowHeight)
    Return true
}

; Update window position (called periodically)
UpdateRobloxWindowPosition() {
    if (!RobloxHwnd)
        Return
        
    ; Check if window still exists
    if (!WinExist("ahk_id " . RobloxHwnd)) {
        RobloxHwnd := 0
        UpdateStatus("Roblox window closed. Please restart the dominator.")
        StopDominator()
        Return
    }
    
    ; Get updated window position
    WinGetPos, WindowLeft, WindowTop, WindowWidth, WindowHeight, ahk_id %RobloxHwnd%
}

; ====================== HOTKEYS ======================
; F1 to set target area center
F1::
    if (!RobloxHwnd) {
        if (!FindRobloxWindow()) {
            MsgBox, 262160, Error, Cannot find Roblox window.
            Return
        }
    }
    
    ; Update window position
    UpdateRobloxWindowPosition()
    
    ; Get mouse position
    MouseGetPos, MouseX, MouseY
    
    ; Convert to relative position within Roblox window
    AreaCenterX := MouseX - WindowLeft
    AreaCenterY := MouseY - WindowTop
    
    GuiControl,, AreaCenterText, X: %AreaCenterX% Y: %AreaCenterY%
    UpdateStatus("Target area center set")
    
    ; Update break area
    UpdateBreakArea()
Return

; F2 to trigger burst mode
F2::
    if (!Active) {
        UpdateStatus("Dominator not active")
        Return
    }
    
    GoSub, TriggerBurstMode
Return

; F3 to trigger instant break
F3::
    if (!Active) {
        UpdateStatus("Dominator not active")
        Return
    }
    
    GoSub, TriggerInstantBreak
Return

; F4 to trigger pulse wave
F4::
    if (!Active) {
        UpdateStatus("Dominator not active")
        Return
    }
    
    GoSub, TriggerPulseWave
Return

; F5 to scan for slimes
F5::
    if (!Active) {
        UpdateStatus("Dominator not active")
        Return
    }
    
    ScanForSlimes()
Return

; F6 = Global start hotkey
F6::
    if (!RobloxHwnd) {
        if (!FindRobloxWindow()) {
            MsgBox, 262160, Error, Cannot find Roblox window. Press F8 to manually select the window.
            Return
        }
    }
    
    if (AreaCenterX = 0 || AreaCenterY = 0) {
        MsgBox, 262160, Error, Please set the target area center first by pressing F1.
        Return
    }
    
    ; Enable the dominator
    StartDominator()
Return

; F7 = Global stop hotkey
F7::
    if (Active) {
        StopDominator()
        UpdateStatus("Dominator stopped via hotkey")
    }
Return

; F8 = Set Roblox window
F8::
    if (ManuallySetRobloxWindow()) {
        UpdateStatus("Roblox window set successfully")
    } else {
        UpdateStatus("Failed to set Roblox window")
    }
Return

; F9 for emergency stop
F9::
    if (Active) {
        StopDominator()
        UpdateStatus("EMERGENCY STOP")
    }
Return

; ================ UI UPDATE FUNCTIONS ================
; Update execution mode
UpdateExecutionMode:
    GuiControlGet, BalancedChecked,, BalancedRadio
    GuiControlGet, SpeedChecked,, SpeedRadio
    GuiControlGet, PowerChecked,, PowerRadio
    GuiControlGet, StealthChecked,, StealthRadio
    GuiControlGet, ExtremeChecked,, ExtremeRadio
    
    if (BalancedChecked)
        ExecutionMode := 1
    else if (SpeedChecked)
        ExecutionMode := 2
    else if (PowerChecked)
        ExecutionMode := 3
    else if (StealthChecked)
        ExecutionMode := 4
    else if (ExtremeChecked)
        ExecutionMode := 5
    
    ; Update status with new mode
    UpdateStatus("Execution mode set to " . GetExecutionModeName(ExecutionMode))
    
    ; Apply execution mode settings
    ApplyExecutionModeSettings()
Return

; Update area width
UpdateAreaWidth:
    GuiControlGet, AreaWidth,, AreaWidthEdit
    UpdateBreakArea()
Return

; Update area height
UpdateAreaHeight:
    GuiControlGet, AreaHeight,, AreaHeightEdit
    UpdateBreakArea()
Return

; Update break area
UpdateBreakArea() {
    if (AreaCenterX = 0 || AreaCenterY = 0) {
        Return
    }
    
    ; Define break area boundaries
    AreaLeft := AreaCenterX - (AreaWidth / 2)
    AreaTop := AreaCenterY - (AreaHeight / 2)
    AreaRight := AreaCenterX + (AreaWidth / 2)
    AreaBottom := AreaCenterY + (AreaHeight / 2)
    
    ; Initialize or reset the activity heatmap
    if (HeatmapEnabled) {
        InitializeHeatmap()
    }
    
    UpdateStatus("Break area updated: " . AreaWidth . "x" . AreaHeight)
}

; Initialize heatmap
InitializeHeatmap() {
    if (!HeatmapEnabled)
        Return
        
    SlimeActivityHeatmap := []
    
    ; Calculate number of cells
    HeatmapCellsX := Ceil(AreaWidth / HeatmapResolution)
    HeatmapCellsY := Ceil(AreaHeight / HeatmapResolution)
    
    ; Initialize with zeros
    Loop, %HeatmapCellsY% {
        y := A_Index
        SlimeActivityHeatmap[y] := []
        
        Loop, %HeatmapCellsX% {
            x := A_Index
            SlimeActivityHeatmap[y][x] := 0
        }
    }
}

; Update power level
UpdatePower:
    GuiControlGet, PowerAmount,, PowerSlider
    
    ; Update power curve
    UpdatePowerCurve()
    
    ; Update power meter display
    GuiControl,, PowerMeter, %PowerAmount%
Return

; Update combo decay rate
UpdateComboDecay:
    GuiControlGet, ComboDecayValue,, ComboDecaySlider
    ComboDecayRate := ComboDecayValue / 1000.0
    UpdateStatus("Combo decay rate set to " . ComboDecayRate)
Return

; Update burst intensity
UpdateBurstIntensity:
    GuiControlGet, BurstIntensityValue,, BurstIntensitySlider
    BurstIntensity := BurstIntensityValue / 30.0
    UpdateStatus("Burst intensity set to " . BurstIntensity)
Return

; Update targeting method
UpdateTargetMethod:
    GuiControlGet, TargetMethod,, TargetMethodDropdown
    
    if (TargetMethod = "Grid")
        TargetingMethod := 1
    else if (TargetMethod = "Spiral")
        TargetingMethod := 2
    else if (TargetMethod = "Random")
        TargetingMethod := 3
    else if (TargetMethod = "Adaptive")
        TargetingMethod := 4
    else if (TargetMethod = "Heatmap")
        TargetingMethod := 5
    else if (TargetMethod = "Predictive")
        TargetingMethod := 6
    
    UpdateStatus("Targeting method set to " . TargetMethod)
Return

; Update quantum break setting
UpdateQuantumBreak:
    GuiControlGet, UseQuantumBreak,, QuantumBreakCheck
Return

; Update hyperspeed setting
UpdateHyperspeed:
    GuiControlGet, UseHyperspeed,, HyperspeedCheck
Return

; Update color detection setting
UpdateColorDetection:
    GuiControlGet, ColorDetectionEnabled,, ColorDetectionCheck
Return

; Update combo optimizer setting
UpdateComboOptimizer:
    GuiControlGet, UseComboOptimizer,, ComboOptimizerCheck
Return

; Update detection avoidance level
UpdateDetectionAvoidance:
    GuiControlGet, DetectionAvoidanceLevel,, DetectionAvoidanceSlider
Return

; Update random offset setting
UpdateRandomOffset:
    GuiControlGet, UseRandomOffset,, RandomOffsetCheck
Return

; Update humanize input setting
UpdateHumanizeInput:
    GuiControlGet, UseHumanizeInput,, HumanizeInputCheck
Return

; ================ MAIN FUNCTIONALITY ================
; Start button handler
StartButton:
    if (!RobloxHwnd) {
        if (!FindRobloxWindow()) {
            MsgBox, 262160, Error, Cannot find Roblox window. Press F8 to manually select the window.
            Return
        }
    }
    
    if (AreaCenterX = 0 || AreaCenterY = 0) {
        MsgBox, 262160, Error, Please set the target area center first by pressing F1.
        Return
    }
    
    ; Enable the dominator
    StartDominator()
Return

; Stop button handler
StopButton:
    ; Stop the dominator
    StopDominator()
Return

; Start dominator
StartDominator() {
    ; Set active state
    Active := true
    StartTime := A_TickCount
    SlimesDestroyed := 0
    PointsEarned := 0
    ComboPoints := 0
    ComboMultiplier := 1.0
    LastBreakTime := A_TickCount
    BurstMode := false
    BurstStartTime := 0
    PulseMode := false
    SwipeMode := false
    TargetSlimes := []
    HighValueSlimes := []
    LastScanTime := 0
    LastPointsUpdate := 0
    CurrentPointsPerSecond := 0
    MaxPointsPerSecond := 0
    LastLeaderboardCheck := 0
    PowerCurveIndex := 0
    ComboSequenceIndex := 0
    SequenceIndex := 0
    HistoryIndex := 0
    LastInstantBreak := 0
    InstantBreakReadyPct := 0
    ComboPeakValue := 0  ; Track peak combo
    
    ; Apply execution mode settings
    ApplyExecutionModeSettings()
    
    ; Reset all tracking
    ResetTracking()
    
    ; Update UI
    GuiControl, Disable, StartBtn
    GuiControl, Enable, StopBtn
    UpdateStatus("SLIME DOMINATOR ACTIVE")
    
    ; Initialize area
    UpdateBreakArea()
    
    ; Initial scan for slimes
    ScanForSlimes()
    
    ; Activate Roblox window to ensure it's in focus
    WinActivate, ahk_id %RobloxHwnd%
    
    ; Set timers for different dominator tasks
    SetTimer, UpdateDominatorState, 20  ; Very fast update for maximum responsiveness
    SetTimer, UpdateLeaderboard, 2000
    SetTimer, ComboDecay, 50  ; Fast combo decay check
    SetTimer, UpdateStats, 100
    SetTimer, UpdateHeatmap, 1000
    SetTimer, CheckPoints, 500
    SetTimer, OptimizationPeriodic, 10000
    SetTimer, UpdateRobloxWindowPositionTimer, 5000  ; Update window position periodically
    
    ; Enable overlay
    if (PointsOverlayEnabled) {
        Gui, 2:Show, x20 y20 NoActivate
    }
}

; Stop dominator
StopDominator() {
    ; Disable active state
    Active := false
    
    ; Update UI
    GuiControl, Enable, StartBtn
    GuiControl, Disable, StopBtn
    UpdateStatus("Slime dominator stopped")
    
    ; Stop all timers
    SetTimer, UpdateDominatorState, Off
    SetTimer, UpdateLeaderboard, Off
    SetTimer, ComboDecay, Off
    SetTimer, UpdateStats, Off
    SetTimer, UpdateHeatmap, Off
    SetTimer, CheckPoints, Off
    SetTimer, OptimizationPeriodic, Off
    SetTimer, UpdateRobloxWindowPositionTimer, Off
    
    ; Hide overlay
    Gui, 2:Hide
    Gui, 3:Hide
}

; Reset all tracking
ResetTracking() {
    ; Reset heatmap
    InitializeHeatmap()
    
    ; Reset slime tracking
    SlimeHealthMap := {}
    SlimeRespawnMap := {}
    SlimeLifecycleMap := {}
    
    ; Reset performance metrics
    PerformanceMetrics := {}
    PerformanceHistory := []
    AccuracyHistory := []
    PredictionHistory := []
    TargetHistory := []
    TargetSuccess := {}
    TargetValue := {}
    
    ; Reset diagnostics
    DiagnosticData := {}
}

; Apply settings based on execution mode
ApplyExecutionModeSettings() {
    ; Set default settings for all modes
    OptimizationEnabled := true
    InstantBreakEnabled := true
    
    ; Apply mode-specific settings
    if (ExecutionMode = 1) {  ; Balanced
        BreakDelay := 5
        UseQuantumBreak := true
        UseHyperspeed := false
        UseComboOptimizer := true
        UsePriorityTargeting := true
        DetectionAvoidanceLevel := 50
        MouseJitter := 2
        MouseSmoothing := 2
        MousePrediction := true
        MousePredictionFactor := 0.5
        AdaptiveTargeting := true
        ScanInterval := 1000
        HeatmapEnabled := true
        RapidClickMode := false
    }
    else if (ExecutionMode = 2) {  ; Speed
        BreakDelay := 1
        UseQuantumBreak := true
        UseHyperspeed := true
        UseComboOptimizer := false
        UsePriorityTargeting := false
        DetectionAvoidanceLevel := 30
        MouseJitter := 0
        MouseSmoothing := 1
        MousePrediction := false
        MousePredictionFactor := 0
        AdaptiveTargeting := false
        ScanInterval := 2000
        HeatmapEnabled := false
        RapidClickMode := true
    }
    else if (ExecutionMode = 3) {  ; Power
        BreakDelay := 5
        UseQuantumBreak := true
        UseHyperspeed := false
        UseComboOptimizer := true
        UsePriorityTargeting := true
        DetectionAvoidanceLevel := 40
        MouseJitter := 1
        MouseSmoothing := 2
        MousePrediction := true
        MousePredictionFactor := 0.3
        AdaptiveTargeting := true
        ScanInterval := 1500
        HeatmapEnabled := true
        RapidClickMode := false
    }
    else if (ExecutionMode = 4) {  ; Stealth
        BreakDelay := 15
        UseQuantumBreak := false
        UseHyperspeed := false
        UseComboOptimizer := true
        UsePriorityTargeting := true
        DetectionAvoidanceLevel := 100
        MouseJitter := 5
        MouseSmoothing := 5
        MousePrediction := true
        MousePredictionFactor := 0.8
        AdaptiveTargeting := true
        ScanInterval := 2000
        HeatmapEnabled := true
        RapidClickMode := false
    }
    else if (ExecutionMode = 5) {  ; Extreme
        BreakDelay := 1
        UseQuantumBreak := true
        UseHyperspeed := true
        UseComboOptimizer := true
        UsePriorityTargeting := true
        DetectionAvoidanceLevel := 80
        MouseJitter := 1
        MouseSmoothing := 1
        MousePrediction := true
        MousePredictionFactor := 0.1
        AdaptiveTargeting := true
        ScanInterval := 500
        HeatmapEnabled := true
        RapidClickMode := true
    }
    
    ; Update controls to reflect current settings
    GuiControl,, QuantumBreakCheck, %UseQuantumBreak%
    GuiControl,, HyperspeedCheck, %UseHyperspeed%
    GuiControl,, ComboOptimizerCheck, %UseComboOptimizer%
    GuiControl,, DetectionAvoidanceSlider, %DetectionAvoidanceLevel%
    
    ; Set up optimal click patterns based on mode
    SetupOptimalClickPatterns()
}

; Set up optimal click patterns based on execution mode
SetupOptimalClickPatterns() {
    OptimalClickPatterns := []
    
    if (ExecutionMode = 1) {  ; Balanced
        OptimalClickPatterns.Push([1, 1, 2, 1, 1, 3, 1, 1, 2, 1])
    }
    else if (ExecutionMode = 2) {  ; Speed
        OptimalClickPatterns.Push([1, 1, 1, 1, 1, 1, 1, 1, 1, 1])
    }
    else if (ExecutionMode = 3) {  ; Power
        OptimalClickPatterns.Push([2, 3, 4, 5, 4, 3, 2, 3, 4, 5])
    }
    else if (ExecutionMode = 4) {  ; Stealth
        OptimalClickPatterns.Push([1, 0, 1, 0, 1, 0, 1, 0, 1, 0])
    }
    else if (ExecutionMode = 5) {  ; Extreme
        OptimalClickPatterns.Push([2, 3, 5, 8, 13, 8, 5, 3, 2, 1])
    }
    
    ; Set active pattern
    ClickSequence := OptimalClickPatterns[1].Clone()
}

; Update power curve
UpdatePowerCurve() {
    ; Scale Fibonacci sequence based on power amount
    PowerScalingFactor := PowerAmount / 100.0
    
    ; Update power curve
    Loop % PowerCurve.Length() {
        i := A_Index
        value := PowerCurve[i]
        PowerCurve[i] := value * PowerScalingFactor
    }
}

; ================ MAIN DOMINATION LOOP ================
; Main update function for dominator state
UpdateDominatorState:
    if (!Active)
        Return
    
    ; Check if Roblox window still exists and is active
    if (!WinExist("ahk_id " . RobloxHwnd)) {
        UpdateStatus("Roblox window no longer exists")
        StopDominator()
        Return
    }
    
    ; Ensure Roblox window is in focus for operations
    if (!WinActive("ahk_id " . RobloxHwnd)) {
        WinActivate, ahk_id %RobloxHwnd%
        ; Short delay to ensure activation
        Sleep, 100
    }
    
    ; Check if we should be in a special mode
    if (BurstMode) {
        ; We're in burst mode
        PerformBurstMode()
    }
    else if (PulseMode) {
        ; We're in pulse mode
        PerformPulseMode()
    }
    else if (SwipeMode) {
        ; We're in swipe mode
        PerformSwipeMode()
    }
    else {
        ; Standard operation - choose a break pattern based on settings
        if (RapidClickMode) {
            PerformRapidClickMode()
        }
        else if (UseQuantumBreak) {
            PerformQuantumBreak()
        }
        else if (UseHyperspeed) {
            PerformHyperspeedBreak()
        }
        else {
            ; Choose a standard break method
            PerformStandardBreak()
        }
    }
    
    ; Update instant break cooldown percentage
    if (InstantBreakEnabled) {
        currentTime := A_TickCount
        timeSinceLastInstantBreak := currentTime - LastInstantBreak
        if (timeSinceLastInstantBreak >= InstantBreakCooldown) {
            InstantBreakReadyPct := 100
        } else {
            InstantBreakReadyPct := (timeSinceLastInstantBreak / InstantBreakCooldown) * 100
        }
    }
    
    ; Update UI
    UpdateOverlay()
Return

; Perform burst mode - maximum damage output
PerformBurstMode() {
    ; Check if burst mode has expired
    CurrentTime := A_TickCount
    if (CurrentTime - BurstStartTime >= BurstDuration) {
        ; Burst mode has ended
        BurstMode := false
        UpdateStatus("Burst mode complete")
        Return
    }
    
    ; Calculate burst progress
    BurstProgress := (CurrentTime - BurstStartTime) / BurstDuration
    BurstPower := PowerAmount * BurstIntensity * (1.0 - BurstProgress)  ; Highest at start, gradually decreases
    
    ; Determine number of breaks based on burst intensity
    BreakCount := 5 + Round(BurstIntensity * 0.5)
    
    ; Perform multiple breaks
    Loop, %BreakCount% {
        if (UsePriorityTargeting && HighValueSlimes.Length() > 0) {
            ; Target high-value slimes first
            Random, SlimeIndex, 1, HighValueSlimes.Length()
            TargetSlime := HighValueSlimes[SlimeIndex]
            
            ; Break at slime position
            BreakSlime(TargetSlime.X, TargetSlime.Y, BurstPower, "Burst")
        } else {
            ; Generate position within area
            Random, OffsetX, -AreaWidth/2, AreaWidth/2
            Random, OffsetY, -AreaHeight/2, AreaHeight/2
            
            TargetX := AreaCenterX + OffsetX
            TargetY := AreaCenterY + OffsetY
            
            ; Check if within area boundaries
            AreaLeft := AreaCenterX - (AreaWidth / 2)
            AreaTop := AreaCenterY - (AreaHeight / 2)
            AreaRight := AreaCenterX + (AreaWidth / 2)
            AreaBottom := AreaCenterY + (AreaHeight / 2)
            
            if (TargetX >= AreaLeft && TargetX <= AreaRight && TargetY >= AreaTop && TargetY <= AreaBottom) {
                ; Break slime
                BreakSlime(TargetX, TargetY, BurstPower, "Burst")
            }
        }
    }
    
    ; Update burst mode status
    TimeRemaining := BurstDuration - (CurrentTime - BurstStartTime)
    UpdateStatus("Burst mode active: " . Round(TimeRemaining / 1000, 1) . "s remaining")
}

; Perform pulse mode - expanding wave of destruction
PerformPulseMode() {
    ; Increment pulse phase
    PulsePhase += 1
    
    ; Calculate pulse radius based on phase
    PulseRadius := PulsePhase * PulseGrowthRate
    
    ; Check if pulse has reached maximum radius
    if (PulseRadius > PulseMaxRadius) {
        ; Pulse complete
        PulseMode := false
        PulsePhase := 0
        UpdateStatus("Pulse wave complete")
        Return
    }
    
    ; Calculate points around the pulse circle
    Loop, %PulsePoints% {
        ; Calculate angle
        Angle := (A_Index - 1) * (360 / PulsePoints)
        AngleRad := Angle * 0.01745329  ; Convert to radians
        
        ; Calculate position
        TargetX := AreaCenterX + (PulseRadius * Cos(AngleRad))
        TargetY := AreaCenterY + (PulseRadius * Sin(AngleRad))
        
        ; Check if within area boundaries
        AreaLeft := AreaCenterX - (AreaWidth / 2)
        AreaTop := AreaCenterY - (AreaHeight / 2)
        AreaRight := AreaCenterX + (AreaWidth / 2)
        AreaBottom := AreaCenterY + (AreaHeight / 2)
        
        if (TargetX >= AreaLeft && TargetX <= AreaRight && TargetY >= AreaTop && TargetY <= AreaBottom) {
            ; Calculate power based on pulse intensity
            PulsePower := PowerAmount * (1.0 - (PulseRadius / PulseMaxRadius))
            PulsePower := Max(PulsePower, PowerAmount * 0.5)  ; Ensure minimum power
            
            ; Perform multiple clicks at this pulse point
            Loop, %PulseIntensity% {
                ; Add slight offset for each click
                if (A_Index > 1) {
                    Random, OffsetX, -5, 5
                    Random, OffsetY, -5, 5
                    ClickX := TargetX + OffsetX
                    ClickY := TargetY + OffsetY
                } else {
                    ClickX := TargetX
                    ClickY := TargetY
                }
                
                ; Break slime
                BreakSlime(ClickX, ClickY, PulsePower, "Pulse")
            }
        }
    }
    
    ; Update pulse wave status
    WaveProgress := (PulseRadius / PulseMaxRadius) * 100
    UpdateStatus("Pulse wave: " . Round(WaveProgress) . "% complete")
}

; Perform swipe mode - linear swipe attacks
PerformSwipeMode() {
    static SwipeStep := 0
    static SwipeStartX := 0
    static SwipeStartY := 0
    static SwipeEndX := 0
    static SwipeEndY := 0
    
    ; Initialize swipe if needed
    if (SwipeStep = 0) {
        ; Calculate swipe start/end points
        AngleRad := SwipeAngle * 0.01745329  ; Convert to radians
        SwipeStartX := AreaCenterX - (Cos(AngleRad) * SwipeLength / 2)
        SwipeStartY := AreaCenterY - (Sin(AngleRad) * SwipeLength / 2)
        SwipeEndX := AreaCenterX + (Cos(AngleRad) * SwipeLength / 2)
        SwipeEndY := AreaCenterY + (Sin(AngleRad) * SwipeLength / 2)
        
        ; Move to start position (converting to screen coordinates)
        ScreenX := SwipeStartX + WindowLeft
        ScreenY := SwipeStartY + WindowTop
        MouseMove, ScreenX, ScreenY, 0
        
        ; Initialize step counter
        SwipeStep := 1
        
        ; Update status
        UpdateStatus("Starting swipe attack: " . Round(SwipeAngle) . "°")
    }
    
    ; Calculate current position along swipe
    SwipeProgress := SwipeStep / 10.0  ; 10 steps per swipe
    CurrentX := SwipeStartX + ((SwipeEndX - SwipeStartX) * SwipeProgress)
    CurrentY := SwipeStartY + ((SwipeEndY - SwipeStartY) * SwipeProgress)
    
    ; Convert to screen coordinates
    ScreenX := CurrentX + WindowLeft
    ScreenY := CurrentY + WindowTop
    
    ; Move and perform attack
    MouseMove, ScreenX, ScreenY, 0
    
    ; Break slime at current position
    BreakSlime(CurrentX, CurrentY, PowerAmount * 1.5, "Swipe")
    
    ; Increment step
    SwipeStep += 1
    
    ; Check if swipe is complete
    if (SwipeStep > 10) {
        ; Swipe complete
        SwipeMode := false
        SwipeStep := 0
        
        ; Rotate swipe angle for next time
        SwipeAngle += 45
        if (SwipeAngle >= 360)
            SwipeAngle -= 360
            
        UpdateStatus("Swipe attack complete")
    }
}

; Perform rapid click mode - ultra-fast clicks
PerformRapidClickMode() {
    ; Check if we should use priority targeting
    if (UsePriorityTargeting && HighValueSlimes.Length() > 0) {
        ; Target high-value slimes first
        Random, SlimeIndex, 1, HighValueSlimes.Length()
        TargetSlime := HighValueSlimes[SlimeIndex]
        
        ; Break at slime position
        BreakSlime(TargetSlime.X, TargetSlime.Y, PowerAmount, "Rapid")
    } else if (TargetSlimes.Length() > 0) {
        ; Target any detected slime
        Random, SlimeIndex, 1, TargetSlimes.Length()
        TargetSlime := TargetSlimes[SlimeIndex]
        
        ; Break at slime position
        BreakSlime(TargetSlime.X, TargetSlime.Y, PowerAmount, "Rapid")
    } else {
        ; Generate position within area
        Random, OffsetX, -AreaWidth/2, AreaWidth/2
        Random, OffsetY, -AreaHeight/2, AreaHeight/2
        
        TargetX := AreaCenterX + OffsetX
        TargetY := AreaCenterY + OffsetY
        
        ; Check if within area boundaries
        AreaLeft := AreaCenterX - (AreaWidth / 2)
        AreaTop := AreaCenterY - (AreaHeight / 2)
        AreaRight := AreaCenterX + (AreaWidth / 2)
        AreaBottom := AreaCenterY + (AreaHeight / 2)
        
        if (TargetX >= AreaLeft && TargetX <= AreaRight && TargetY >= AreaTop && TargetY <= AreaBottom) {
            ; Break slime
            BreakSlime(TargetX, TargetY, PowerAmount, "Rapid")
        }
    }
}

; Perform quantum break - multiple simultaneous breaks
PerformQuantumBreak() {
    ; Save current mouse position
    MouseGetPos, CurrentX, CurrentY
    
    ; Calculate break count based on execution mode
    QuantumBreakCount := 3
    if (ExecutionMode = 2)  ; Speed
        QuantumBreakCount := 5
    else if (ExecutionMode = 3)  ; Power
        QuantumBreakCount := 2
    else if (ExecutionMode = 5)  ; Extreme
        QuantumBreakCount := 4
    
    ; Calculate power per break
    QuantumPower := PowerAmount * 0.7  ; Slightly reduced power per break
    
    ; Perform multiple breaks
    Loop, %QuantumBreakCount% {
        ; Check if we should use priority targeting
        if (UsePriorityTargeting && HighValueSlimes.Length() > 0) {
            ; Target high-value slimes first
            Random, SlimeIndex, 1, HighValueSlimes.Length()
            TargetSlime := HighValueSlimes[SlimeIndex]
            
            ; Break at slime position
            BreakSlime(TargetSlime.X, TargetSlime.Y, QuantumPower, "Quantum")
        } else {
            ; Generate position within area
            Random, OffsetX, -AreaWidth/2, AreaWidth/2
            Random, OffsetY, -AreaHeight/2, AreaHeight/2
            
            TargetX := AreaCenterX + OffsetX
            TargetY := AreaCenterY + OffsetY
            
            ; Check if within area boundaries
            AreaLeft := AreaCenterX - (AreaWidth / 2)
            AreaTop := AreaCenterY - (AreaHeight / 2)
            AreaRight := AreaCenterX + (AreaWidth / 2)
            AreaBottom := AreaCenterY + (AreaHeight / 2)
            
            if (TargetX >= AreaLeft && TargetX <= AreaRight && TargetY >= AreaTop && TargetY <= AreaBottom) {
                ; Break slime
                BreakSlime(TargetX, TargetY, QuantumPower, "Quantum")
            }
        }
    }
    
    ; Return to original position
    MouseMove, CurrentX, CurrentY, 0
    
    ; Add slight delay to prevent detection
    Sleep, BreakDelay
}

; Perform hyperspeed break - rapid series of breaks
PerformHyperspeedBreak() {
    ; Calculate break count based on execution mode
    HyperspeedBreakCount := 3
    if (ExecutionMode = 2)  ; Speed
        HyperspeedBreakCount := 5
    else if (ExecutionMode = 5)  ; Extreme
        HyperspeedBreakCount := 4
    
    ; Calculate power per break
    HyperspeedPower := PowerAmount * 0.5  ; Reduced power per break
    
    ; Check if we should use priority targeting
    if (UsePriorityTargeting && HighValueSlimes.Length() > 0) {
        ; Target high-value slimes with rapid clicks
        Random, SlimeIndex, 1, HighValueSlimes.Length()
        TargetSlime := HighValueSlimes[SlimeIndex]
        
        ; Break at slime position multiple times rapidly
        Loop, %HyperspeedBreakCount% {
            ; Add slight offset for each click
            if (A_Index > 1) {
                Random, OffsetX, -5, 5
                Random, OffsetY, -5, 5
                ClickX := TargetSlime.X + OffsetX
                ClickY := TargetSlime.Y + OffsetY
            } else {
                ClickX := TargetSlime.X
                ClickY := TargetSlime.Y
            }
            
            ; Break slime
            BreakSlime(ClickX, ClickY, HyperspeedPower, "Hyperspeed")
            
            ; Very small delay between hyperspeed breaks
            Sleep, 5
        }
    } else {
        ; Perform rapid series of breaks at random positions
        Loop, %HyperspeedBreakCount% {
            ; Generate position within area
            Random, OffsetX, -AreaWidth/2, AreaWidth/2
            Random, OffsetY, -AreaHeight/2, AreaHeight/2
            
            TargetX := AreaCenterX + OffsetX
            TargetY := AreaCenterY + OffsetY
            
            ; Check if within area boundaries
            AreaLeft := AreaCenterX - (AreaWidth / 2)
            AreaTop := AreaCenterY - (AreaHeight / 2)
            AreaRight := AreaCenterX + (AreaWidth / 2)
            AreaBottom := AreaCenterY + (AreaHeight / 2)
            
            if (TargetX >= AreaLeft && TargetX <= AreaRight && TargetY >= AreaTop && TargetY <= AreaBottom) {
                ; Break slime
                BreakSlime(TargetX, TargetY, HyperspeedPower, "Hyperspeed")
            }
            
            ; Very small delay between hyperspeed breaks
            Sleep, 5
        }
    }
    
    ; Add slight delay to prevent detection
    Sleep, BreakDelay
}

; Perform standard break
PerformStandardBreak() {
    ; Determine power based on click sequence
    SequenceIndex := Mod(SequenceIndex, ClickSequence.Length()) + 1
    PowerFactor := ClickSequence[SequenceIndex]
    
    ; Calculate actual power
    BreakPower := PowerAmount * PowerFactor
    
    ; Check if we should use priority targeting
    if (UsePriorityTargeting && HighValueSlimes.Length() > 0) {
        ; Target high-value slimes first
        Random, SlimeIndex, 1, HighValueSlimes.Length()
        TargetSlime := HighValueSlimes[SlimeIndex]
        
        ; Break at slime position
        BreakSlime(TargetSlime.X, TargetSlime.Y, BreakPower, "Standard")
    } 
    else if (HeatmapEnabled && SlimeActivityHeatmap.Length() > 0) {
        ; Find hotspot from heatmap
        targetCoords := FindHeatmapHotspot()
        if (targetCoords) {
            ; Break at hotspot
            BreakSlime(targetCoords.X, targetCoords.Y, BreakPower, "Heatmap")
        } else {
            ; Use normal targeting
            StandardTargeting(BreakPower)
        }
    }
    else {
        ; Use normal targeting
        StandardTargeting(BreakPower)
    }
    
    ; Increment sequence index
    SequenceIndex += 1
    
    ; Add delay based on execution mode
    Sleep, BreakDelay
}

; Standard targeting method
StandardTargeting(power) {
    if (TargetSlimes.Length() > 0) {
        ; Target any detected slime
        Random, SlimeIndex, 1, TargetSlimes.Length()
        TargetSlime := TargetSlimes[SlimeIndex]
        
        ; Break at slime position
        BreakSlime(TargetSlime.X, TargetSlime.Y, power, "Standard")
    } else {
        ; Generate position within area
        Random, OffsetX, -AreaWidth/2, AreaWidth/2
        Random, OffsetY, -AreaHeight/2, AreaHeight/2
        
        TargetX := AreaCenterX + OffsetX
        TargetY := AreaCenterY + OffsetY
        
        ; Check if within area boundaries
        AreaLeft := AreaCenterX - (AreaWidth / 2)
        AreaTop := AreaCenterY - (AreaHeight / 2)
        AreaRight := AreaCenterX + (AreaWidth / 2)
        AreaBottom := AreaCenterY + (AreaHeight / 2)
        
        if (TargetX >= AreaLeft && TargetX <= AreaRight && TargetY >= AreaTop && TargetY <= AreaBottom) {
            ; Break slime
            BreakSlime(TargetX, TargetY, power, "Standard")
        }
    }
}

; Find hotspot in heatmap
FindHeatmapHotspot() {
    if (!HeatmapEnabled || SlimeActivityHeatmap.Length() = 0)
        Return false
    
    highestValue := 0
    hotspotX := 0
    hotspotY := 0
    
    ; Find highest value in heatmap
    for y, row in SlimeActivityHeatmap {
        for x, value in row {
            if (value > highestValue) {
                highestValue := value
                
                ; Calculate real coordinates from heatmap cell
                hotspotX := AreaCenterX - (AreaWidth / 2) + (x * HeatmapResolution)
                hotspotY := AreaCenterY - (AreaHeight / 2) + (y * HeatmapResolution)
            }
        }
    }
    
    ; Only return if value is significant
    if (highestValue > HotspotThreshold) {
        Return {"X": hotspotX, "Y": hotspotY}
    }
    
    Return false
}

; Break a slime at the specified position
BreakSlime(x, y, power, breakType := "Standard") {
    ; Skip if we're not active
    if (!Active)
        Return
    
    ; Add anti-detection variance
    if (DetectionAvoidanceLevel > 0) {
        ; Calculate jitter amount based on detection avoidance level
        jitterAmount := (DetectionAvoidanceLevel / 100.0) * 5
        
        ; Add random jitter to position
        Random, jitterX, -jitterAmount, jitterAmount
        Random, jitterY, -jitterAmount, jitterAmount
        
        x += jitterX
        y += jitterY
    }
    
    ; Convert to screen coordinates (relative to Roblox window)
    ScreenX := x + WindowLeft
    ScreenY := y + WindowTop
    
    ; Move mouse with appropriate smoothing
    if (MouseSmoothing > 1) {
        ; Smoother movement
        MouseMove, ScreenX, ScreenY, MouseSmoothing
    } else {
        ; Fast movement
        MouseMove, ScreenX, ScreenY, 0
    }
    
    ; Execute the break
    Click
    
    ; Calculate damage based on power and combo
    damage := power * ComboMultiplier
    
    ; Show damage number (convert back to screen coordinates)
    ShowDamageNumber(ScreenX, ScreenY, damage)
    
    ; Update combo
    IncrementCombo()
    
    ; Update points
    pointGain := CalculatePointsForBreak(damage)
    PointsEarned += pointGain
    
    ; Update slimes destroyed counter
    SlimesDestroyed += 1
    
    ; Update heatmap if enabled
    if (HeatmapEnabled) {
        UpdateHeatmapValue(x, y, damage)
    }
    
    ; Update target history
    AddToTargetHistory(x, y, damage, pointGain)
    
    ; Return damage dealt
    Return damage
}

; Update heatmap value at position
UpdateHeatmapValue(x, y, value) {
    if (!HeatmapEnabled || SlimeActivityHeatmap.Length() = 0)
        Return
    
    ; Convert real coordinates to heatmap cell
    heatX := Floor((x - (AreaCenterX - (AreaWidth / 2))) / HeatmapResolution) + 1
    heatY := Floor((y - (AreaCenterY - (AreaHeight / 2))) / HeatmapResolution) + 1
    
    ; Ensure within bounds
    if (heatY <= SlimeActivityHeatmap.Length() && heatY > 0) {
        if (heatX <= SlimeActivityHeatmap[heatY].Length() && heatX > 0) {
            ; Increment value
            SlimeActivityHeatmap[heatY][heatX] += (value / 1000)
            
            ; Cap at 1.0
            SlimeActivityHeatmap[heatY][heatX] := Min(SlimeActivityHeatmap[heatY][heatX], 1.0)
        }
    }
}

; Add to target history
AddToTargetHistory(x, y, damage, points) {
    ; Create target entry
    target := {}
    target.X := x
    target.Y := y
    target.Damage := damage
    target.Points := points
    target.Time := A_TickCount
    
    ; Add to history
    TargetHistory[HistoryIndex + 1] := target
    
    ; Update index
    HistoryIndex := Mod(HistoryIndex + 1, HistorySize)
    
    ; Update target metrics
    targetKey := Round(x / 20) . "," . Round(y / 20)  ; Group nearby targets
    
    ; Update success rate
    if (!TargetSuccess[targetKey])
        TargetSuccess[targetKey] := 1
    else
        TargetSuccess[targetKey] += 1
    
    ; Update value
    if (!TargetValue[targetKey])
        TargetValue[targetKey] := points
    else
        TargetValue[targetKey] := (TargetValue[targetKey] * 0.9) + (points * 0.1)  ; Weighted average
}

; Show damage number
ShowDamageNumber(x, y, damage) {
    ; Format damage for display
    if (damage >= 1000000)
        displayText := "+" . Round(damage / 1000000, 1) . "M"
    else if (damage >= 1000)
        displayText := "+" . Round(damage / 1000, 1) . "K"
    else
        displayText := "+" . Round(damage)
    
    ; Add combo indicator if combo is active
    if (ComboMultiplier > 1.0)
        displayText := displayText . " (x" . Round(ComboMultiplier, 1) . ")"
    
    ; Update overlay text
    GuiControl, 3:, DamageNumber, %displayText%
    
    ; Position and show overlay
    Gui, 3:Show, x%x% y%y% NoActivate
    
    ; Schedule hiding the overlay
    SetTimer, HideDamageNumber, 500
}

; Hide damage number
HideDamageNumber:
    Gui, 3:Hide
    SetTimer, HideDamageNumber, Off
Return

; Calculate points for a break
CalculatePointsForBreak(damage) {
    ; Base point value
    basePoints := damage / 5
    
    ; Apply combo multiplier if using combo optimizer
    if (UseComboOptimizer) {
        basePoints *= ComboMultiplier
    }
    
    ; Apply streak bonus
    if (StreakCounter > 0) {
        ; Find applicable streak bonus
        bonusIndex := 1
        for i, threshold in ScoreMultiplierThresholds {
            if (StreakCounter >= threshold)
                bonusIndex := i
            else
                break
        }
        
        ; Apply streak bonus
        basePoints *= ScoreMultipliers[bonusIndex]
    }
    
    ; Apply other bonuses from execution mode
    if (ExecutionMode = 3)  ; Power mode
        basePoints *= 1.5
    else if (ExecutionMode = 5)  ; Extreme mode
        basePoints *= 2.0
    
    ; Ensure minimum points
    basePoints := Max(1, Round(basePoints))
    
    ; Track points per second
    CurrentPointsPerSecond += basePoints
    
    return basePoints
}

; Increment combo counter
IncrementCombo() {
    ; Reset combo decay timer
    LastBreakTime := A_TickCount
    
    ; Increment combo
    ComboPoints += 1
    
    ; Calculate combo multiplier - logarithmic scaling
    if (UseComboOptimizer) {
        ; Optimized combo scaling
        ComboMultiplier := 1.0 + (Ln(ComboPoints + 1) / 2)
    } else {
        ; Standard combo scaling
        ComboMultiplier := 1.0 + (ComboPoints * 0.01)
    }
    
    ; Cap combo multiplier
    ComboMultiplier := Min(ComboMultiplier, 10.0)
    
    ; Update combo display
    GuiControl,, CurrentComboText, %ComboPoints%x
    
    ; Update combo meter
    ComboMeterValue := Min(100, (ComboMultiplier / 10.0) * 100)
    GuiControl,, ComboMeter, %ComboMeterValue%
    
    ; Track peak combo
    if (ComboPoints > ComboPeakValue)
        ComboPeakValue := ComboPoints
    
    ; Increment streak counter
    StreakCounter += 1
    
    ; Track max streak
    if (StreakCounter > MaxStreak)
        MaxStreak := StreakCounter
}

; Combo decay timer
ComboDecay:
    if (!Active)
        Return
    
    ; Calculate time since last break
    CurrentTime := A_TickCount
    TimeSinceLastBreak := (CurrentTime - LastBreakTime) / 1000.0  ; seconds
    
    ; If it's been too long, decay the combo
    if (TimeSinceLastBreak > 0.5) {  ; Start decaying after 0.5 seconds
        ; Calculate decay amount
        DecayTime := TimeSinceLastBreak - 0.5
        DecayAmount := Floor(DecayTime / ComboDecayRate)
        
        if (DecayAmount > 0) {
            ; Reduce combo points
            ComboPoints := Max(0, ComboPoints - DecayAmount)
            
            ; Recalculate multiplier
            if (ComboPoints > 0) {
                if (UseComboOptimizer) {
                    ; Optimized combo scaling
                    ComboMultiplier := 1.0 + (Ln(ComboPoints + 1) / 2)
                } else {
                    ; Standard combo scaling
                    ComboMultiplier := 1.0 + (ComboPoints * 0.01)
                }
            } else {
                ComboMultiplier := 1.0
            }
            
            ; Update combo display
            GuiControl,, CurrentComboText, %ComboPoints%x
            
            ; Update combo meter
            ComboMeterValue := Min(100, (ComboMultiplier / 10.0) * 100)
            GuiControl,, ComboMeter, %ComboMeterValue%
            
            ; Reset streak if combo decayed significantly
            if (DecayAmount > 5) {
                StreakCounter := 0
            }
        }
    }
    
    ; Check if combo has expired
    if (TimeSinceLastBreak * 1000 > ComboExpiryTime) {
        ; Reset streak
        StreakCounter := 0
    }
Return

; Scan for slimes
ScanForSlimes() {
    if (!Active)
        Return
    
    UpdateStatus("Scanning for slimes...")
    
    ; Clear existing target lists
    TargetSlimes := []
    HighValueSlimes := []
    
    ; Skip scan if color detection is disabled
    if (!ColorDetectionEnabled)
        Return
    
    ; Remember current mouse position
    MouseGetPos, ScanCurrentX, ScanCurrentY
    
    ; Define scan area in window coordinates
    ScanLeft := AreaCenterX - (AreaWidth / 2)
    ScanTop := AreaCenterY - (AreaHeight / 2)
    ScanRight := AreaCenterX + (AreaWidth / 2)
    ScanBottom := AreaCenterY + (AreaHeight / 2)
    
    ; Scan the area in a grid pattern
    ScanStepX := Max(5, ScanResolution)  ; Minimum step size
    ScanStepY := Max(5, ScanResolution)  ; Minimum step size
    
    ; Adapt scan resolution based on execution mode
    if (ExecutionMode = 2)  ; Speed
        ScanResolution := 20  ; Coarser scan for speed
    else if (ExecutionMode = 3)  ; Power
        ScanResolution := 10  ; Finer scan for power
    else if (ExecutionMode = 5)  ; Extreme
        ScanResolution := 5   ; Finest scan for extreme
    
    ; Convert to screen coordinates
    ScreenLeft := ScanLeft + WindowLeft
    ScreenTop := ScanTop + WindowTop
    ScreenRight := ScanRight + WindowLeft
    ScreenBottom := ScanBottom + WindowTop
    
    ; Scan points - using while loops for compatibility
    ScanY := ScanTop
    while (ScanY <= ScanBottom) {
        ScanX := ScanLeft
        while (ScanX <= ScanRight) {
            ; Calculate screen coordinates
            ScreenX := ScanX + WindowLeft
            ScreenY := ScanY + WindowTop
            
            ; Move to scan position
            MouseMove, ScreenX, ScreenY, 0
            
            ; In a real implementation, this would use pixel detection for orange slime blobs
            ; For this simulation, we'll generate random "detections"
            
            ; Simulate detecting a slime with higher probability in center
            DistanceFromCenter := Sqrt((ScanX - AreaCenterX)**2 + (ScanY - AreaCenterY)**2)
            MaxDistance := Sqrt((AreaWidth/2)**2 + (AreaHeight/2)**2)
            CenterFactor := 1 - (DistanceFromCenter / MaxDistance)
            
            DetectionProbability := 0.05 + (CenterFactor * 0.1)  ; 5-15% chance of detection
            Random, RandValue, 0.0, 1.0
            
            if (RandValue < DetectionProbability) {
                ; Add to target slimes
                slime := {}
                slime.X := ScanX
                slime.Y := ScanY
                Random, ValueRandom, 50, 200  ; Random value for simulation
                slime.Value := ValueRandom  
                TargetSlimes.Push(slime)
                
                ; Add to high-value slimes if value is high enough
                if (slime.Value > 100) {
                    HighValueSlimes.Push(slime)
                }
                
                ; Add to heatmap
                if (HeatmapEnabled) {
                    UpdateHeatmapValue(ScanX, ScanY, slime.Value)
                }
            }
            
            ; Move to next scan position
            ScanX += ScanStepX
        }
        ScanY += ScanStepY
    }
    
    ; Return to original position
    MouseMove, ScanCurrentX, ScanCurrentY, 0
    
    ; Update last scan time
    LastScanTime := A_TickCount
    
    ; Update status
    UpdateStatus("Scan complete. Found " . TargetSlimes.Length() . " slimes")
}

; Update leaderboard
UpdateLeaderboard:
    if (!Active)
        Return
    
    ; In a real implementation, this would scan the leaderboard UI
    ; For this simulation, we'll generate a simulated leaderboard position
    
    ; Check if enough time has passed since last check
    CurrentTime := A_TickCount
    if (CurrentTime - LastLeaderboardCheck < LeaderboardUpdateInterval)
        Return
    
    ; Update last check time
    LastLeaderboardCheck := CurrentTime
    
    ; Simulate leaderboard position (gradually improving)
    ElapsedTimeMinutes := (CurrentTime - StartTime) / 60000
    if (ElapsedTimeMinutes < 1) {
        ; First minute - start at a low position
        Random, LeaderboardPosition, 80, 100
    } else {
        ; Gradually improve position based on points earned
        if (PointsEarned > 0) {
            PointsPerMinute := PointsEarned / ElapsedTimeMinutes
            LeaderboardPosition := Max(1, 100 - (PointsPerMinute / 1000))
        } else {
            LeaderboardPosition := 100
        }
    }
    
    ; Round to integer
    LeaderboardPosition := Round(LeaderboardPosition)
    
    ; Update leaderboard display
    GuiControl,, LeaderboardPosText, %LeaderboardPosition%
    
    ; Update overlay
    GuiControl, 2:, OverlayRank, RANK: %LeaderboardPosition%
Return

; Update window position timer
UpdateRobloxWindowPositionTimer:
    UpdateRobloxWindowPosition()
Return

; Update heatmap
UpdateHeatmap:
    if (!Active || !HeatmapEnabled)
        Return
    
    ; Check if enough time has passed
    CurrentTime := A_TickCount
    if (CurrentTime - LastHeatmapUpdate < HeatmapUpdateInterval)
        Return
    
    ; Update timestamp
    LastHeatmapUpdate := CurrentTime
    
    ; Apply heatmap fading if enabled
    if (HeatmapFading) {
        for y, row in SlimeActivityHeatmap {
            for x, value in row {
                ; Apply decay
                if (value > 0) {
                    newValue := value - HeatmapFadingRate
                    SlimeActivityHeatmap[y][x] := Max(0, newValue)
                }
            }
        }
    }
    
    ; Update hotspot display
    UpdateHotspotDisplay()
Return

; Update hotspot display
UpdateHotspotDisplay() {
    ; Clear the listview
    LV_Delete()
    
    ; Find and sort hotspots
    hotspots := []
    
    for y, row in SlimeActivityHeatmap {
        for x, value in row {
            if (value > HotspotThreshold) {
                ; Calculate real coordinates from heatmap cell
                hotspotX := AreaCenterX - (AreaWidth / 2) + (x * HeatmapResolution)
                hotspotY := AreaCenterY - (AreaHeight / 2) + (y * HeatmapResolution)
                
                ; Determine area name based on position
                areaName := GetAreaName(hotspotX, hotspotY)
                
                ; Add to hotspots array
                hotspots.Push({"Area": areaName, "Value": value, "X": hotspotX, "Y": hotspotY})
            }
        }
    }
    
    ; Sort hotspots by value (descending)
    hotspots := SortHotspotsByValue(hotspots)
    
    ; Add top hotspots to listview
    Loop % hotspots.Length() {
        i := A_Index
        if (i > MaxHotspots)
            break
        
        hotspot := hotspots[i]    
        ; Format efficiency percentage
        efficiency := Round(hotspot.Value * 100) . "%"
        
        ; Determine value label based on value
        valueLabel := "Low"
        if (hotspot.Value > 0.85)
            valueLabel := "High"
        else if (hotspot.Value > 0.7)
            valueLabel := "Medium"
        
        ; Add to listview
        LV_Add("", hotspot.Area, efficiency, valueLabel, i)
    }
}

; Get area name based on position
GetAreaName(x, y) {
    ; Determine quadrant
    quadX := x < AreaCenterX ? "Left" : "Right"
    quadY := y < AreaCenterY ? "Top" : "Bottom"
    
    ; Calculate distance from center
    distanceFromCenter := Sqrt((x - AreaCenterX)**2 + (y - AreaCenterY)**2)
    
    ; Check if it's close to center
    if (distanceFromCenter < Min(AreaWidth, AreaHeight) / 6)
        Return "Center"
    
    ; Return quadrant name
    Return quadY . "-" . quadX
}

; Sort hotspots by value
SortHotspotsByValue(hotspots) {
    ; Simple bubble sort for demonstration
    n := hotspots.Length()
    
    Loop, %n% {
        i := A_Index
        Loop, % n - i {
            j := A_Index
            
            if (hotspots[j].Value < hotspots[j+1].Value) {
                ; Swap
                temp := hotspots[j]
                hotspots[j] := hotspots[j+1]
                hotspots[j+1] := temp
            }
        }
    }
    
    Return hotspots
}

; Check and update points
CheckPoints:
    if (!Active)
        Return
    
    ; Calculate current points per second
    CurrentTime := A_TickCount
    TimeSinceLastPointCheck := (CurrentTime - LastPointsUpdate) / 1000.0  ; seconds
    
    if (TimeSinceLastPointCheck >= 1.0) {
        ; Calculate points per second
        PointsPerSecond := CurrentPointsPerSecond / TimeSinceLastPointCheck
        
        ; Update max if higher
        if (PointsPerSecond > MaxPointsPerSecond)
            MaxPointsPerSecond := PointsPerSecond
        
        ; Update display
        GuiControl,, PointsPerSecondText, %PointsPerSecond%
        
        ; Update overlay
        GuiControl, 2:, OverlayPPS, %PointsPerSecond%/sec
        
        ; Reset counter and time
        CurrentPointsPerSecond := 0
        LastPointsUpdate := CurrentTime
    }
Return

; Periodic optimization
OptimizationPeriodic:
    if (!Active || !OptimizationEnabled)
        Return
    
    ; Update last optimization time
    LastOptimizationTime := A_TickCount
    
    ; Analyze target history to optimize
    if (TargetHistory.Length() > 0) {
        ; Find most successful target areas
        AnalyzeTargetHistory()
    }
    
    ; Optimize combo strategy if enabled
    if (UseComboOptimizer) {
        OptimizeComboStrategy()
    }
Return

; Analyze target history
AnalyzeTargetHistory() {
    ; Clear high-value targets
    HighValueSlimes := []
    
    ; Find top target zones by success and value
    targetsByValue := {}
    
    ; Process all targets in history
    for i, target in TargetSuccess {
        targetKey := i
        
        ; Calculate score based on success rate and value
        successScore := TargetSuccess[targetKey]
        valueScore := TargetValue[targetKey] ? TargetValue[targetKey] : 0
        
        ; Overall score
        overallScore := (successScore * 0.4) + (valueScore * 0.6)
        
        ; Add to sorted map
        targetsByValue[targetKey] := overallScore
    }
    
    ; Sort targets by value
    sortedTargets := SortMapByValue(targetsByValue)
    
    ; Take top 10 targets
    count := 0
    for targetKey, score in sortedTargets {
        if (count >= 10)
            break
            
        ; Parse coordinates from key
        coords := StrSplit(targetKey, ",")
        if (coords.Length() = 2) {
            x := coords[1] * 20
            y := coords[2] * 20
            
            ; Add to high-value targets
            slime := {}
            slime.X := x
            slime.Y := y
            slime.Value := score
            HighValueSlimes.Push(slime)
            
            count += 1
        }
    }
    
    ; Update status
    UpdateStatus("Optimization complete. Found " . HighValueSlimes.Length() . " high-value targets")
}

; Sort map by value
SortMapByValue(map) {
    ; Convert map to array of {key, value} objects
    array := []
    for key, value in map {
        array.Push({"key": key, "value": value})
    }
    
    ; Sort array by value (descending)
    array := SortArrayByValue(array)
    
    ; Convert back to map
    sortedMap := {}
    for i, item in array {
        sortedMap[item.key] := item.value
    }
    
    Return sortedMap
}

; Sort array by value
SortArrayByValue(array) {
    ; Simple bubble sort for demonstration
    n := array.Length()
    
    Loop, %n% {
        i := A_Index
        Loop, % n - i {
            j := A_Index
            
            if (array[j].value < array[j+1].value) {
                ; Swap
                temp := array[j]
                array[j] := array[j+1]
                array[j+1] := temp
            }
        }
    }
    
    Return array
}

; Optimize combo strategy
OptimizeComboStrategy() {
    ; Analyze combo effectiveness
    if (SlimesDestroyed > 0) {
        averageCombo := ComboPoints / SlimesDestroyed
        peakComboEfficiency := ComboPeakValue / SlimesDestroyed
        
        ; Adjust combo decay rate based on effectiveness
        if (averageCombo < 5) {
            ; Combo decaying too fast, slow down decay
            ComboDecayRate := Max(0.01, ComboDecayRate * 0.9)
        } else if (averageCombo > 20) {
            ; Combo growing too fast, increase decay
            ComboDecayRate := Min(0.1, ComboDecayRate * 1.1)
        }
        
        ; Update UI
        comboDecaySlider := ComboDecayRate * 1000
        GuiControl,, ComboDecaySlider, %comboDecaySlider%
    }
}

; ================ SPECIAL ABILITIES ================
; Trigger burst mode
TriggerBurstMode:
    if (!Active) {
        UpdateStatus("Dominator not active")
        Return
    }
    
    ; Check if already in a special mode
    if (BurstMode || PulseMode || SwipeMode) {
        UpdateStatus("Another special mode is already active")
        Return
    }
    
    ; Activate burst mode
    BurstMode := true
    BurstStartTime := A_TickCount
    
    UpdateStatus("Burst mode activated!")
Return

; Trigger instant break
TriggerInstantBreak:
    if (!Active) {
        UpdateStatus("Dominator not active")
        Return
    }
    
    ; Check if on cooldown
    CurrentTime := A_TickCount
    if (CurrentTime - LastInstantBreak < InstantBreakCooldown) {
        CooldownRemaining := (InstantBreakCooldown - (CurrentTime - LastInstantBreak)) / 1000
        UpdateStatus("Instant break on cooldown: " . Round(CooldownRemaining, 1) . "s remaining")
        Return
    }
    
    ; Check if already in a special mode
    if (BurstMode || PulseMode || SwipeMode) {
        UpdateStatus("Cannot use instant break during another special mode")
        Return
    }
    
    ; Save current mouse position
    MouseGetPos, CurrentX, CurrentY
    
    ; Perform instant break on all detected slimes
    if (TargetSlimes.Length() > 0) {
        ; Calculate power
        InstantBreakPower := PowerAmount * 5
        
        ; Break all detected slimes
        Loop % TargetSlimes.Length() {
            i := A_Index
            slime := TargetSlimes[i]
            BreakSlime(slime.X, slime.Y, InstantBreakPower, "Instant")
            
            ; Brief pause to allow game to register
            Sleep, 10
        }
    } else {
        ; No detected slimes, perform area-wide instant break
        
        ; Break points in a grid pattern
        GridStepX := AreaWidth / 10
        GridStepY := AreaHeight / 10
        
        ; Using while loops instead of for loops
        x := -AreaWidth/2
        while (x <= AreaWidth/2) {
            y := -AreaHeight/2
            while (y <= AreaHeight/2) {
                ; Calculate position
                BreakX := AreaCenterX + x
                BreakY := AreaCenterY + y
                
                ; Break at this position
                BreakSlime(BreakX, BreakY, InstantBreakPower, "Instant")
                
                ; Brief pause to allow game to register
                Sleep, 5
                
                ; Increment y
                y += GridStepY
            }
            ; Increment x
            x += GridStepX
        }
    }
    
    ; Return to original position
    MouseMove, CurrentX, CurrentY, 0
    
    ; Set cooldown
    LastInstantBreak := A_TickCount
    InstantBreakReadyPct := 0
    
    UpdateStatus("Instant break executed!")
Return

; Trigger pulse wave
TriggerPulseWave:
    if (!Active) {
        UpdateStatus("Dominator not active")
        Return
    }
    
    ; Check if already in a special mode
    if (BurstMode || PulseMode || SwipeMode) {
        UpdateStatus("Another special mode is already active")
        Return
    }
    
    ; Activate pulse mode
    PulseMode := true
    PulsePhase := 0
    
    UpdateStatus("Pulse wave initiated!")
Return

; Trigger swipe attack
TriggerSwipeAttack:
    if (!Active) {
        UpdateStatus("Dominator not active")
        Return
    }
    
    ; Check if already in a special mode
    if (BurstMode || PulseMode || SwipeMode) {
        UpdateStatus("Another special mode is already active")
        Return
    }
    
    ; Activate swipe mode
    SwipeMode := true
    Random, RandomAngle, 0, 359  ; Random angle
    SwipeAngle := RandomAngle
    
    UpdateStatus("Swipe attack initiated!")
Return

; ================ UI UPDATING ================
; Update stats display
UpdateStats:
    if (!Active)
        Return
    
    ; Update slime count
    GuiControl,, SlimesDestroyedText, %SlimesDestroyed%
    
    ; Update points
    GuiControl,, PointsEarnedText, %PointsEarned%
    
    ; Calculate and update points per second
    ElapsedTime := (A_TickCount - StartTime) / 1000
    if (ElapsedTime > 0) {
        PointsPerSecond := Round(PointsEarned / ElapsedTime, 1)
        GuiControl,, PointsPerSecondText, %PointsPerSecond%
    }
    
    ; Update power meter based on execution mode
    PowerMeterValue := 50
    if (ExecutionMode = 1)  ; Balanced
        PowerMeterValue := PowerAmount / 3
    else if (ExecutionMode = 2)  ; Speed
        PowerMeterValue := 30 + (ComboPoints / 2)  ; Influenced by combo
    else if (ExecutionMode = 3)  ; Power
        PowerMeterValue := PowerAmount / 2 + (ComboMultiplier * 5)  ; Boosted by combo
    else if (ExecutionMode = 4)  ; Stealth
        PowerMeterValue := 25 + (25 - (DetectionAvoidanceLevel / 4))  ; Higher when low detection risk
    else if (ExecutionMode = 5)  ; Extreme
        PowerMeterValue := 50 + (ComboPoints / 2)  ; Strong combo influence
    
    ; Cap power meter value
    PowerMeterValue := Min(100, PowerMeterValue)
    
    ; Update power meter
    GuiControl,, PowerMeter, %PowerMeterValue%
Return

; Update overlay
UpdateOverlay() {
    ; Update combo display
    GuiControl, 2:, OverlayCombo, COMBO: %ComboPoints%x
    
    ; Update power display
    PowerPct := Round((PowerAmount / 200) * 100)
    GuiControl, 2:, OverlayPower, POWER: %PowerPct%`%
}

; ================ UTILITY FUNCTIONS ================
; Get execution mode name
GetExecutionModeName(mode) {
    if (mode = 1)
        Return "Balanced"
    else if (mode = 2)
        Return "Speed"
    else if (mode = 3)
        Return "Power"
    else if (mode = 4)
        Return "Stealth"
    else if (mode = 5)
        Return "Extreme"
    else
        Return "Unknown"
}

; Update status text
UpdateStatus(text) {
    GuiControl,, StatusText, %text%
}

; Resize handler for GUI
WndProc(hwnd, msg, wParam, lParam) {
    if (msg = 0x0005) {  ; WM_SIZE
        width := lParam & 0xFFFF
        height := (lParam >> 16) & 0xFFFF
        
        ; Apply minimum dimensions
        if (width < 400)
            width := 400
        if (height < 300)
            height := 300
            
        ; Resize and reposition main GUI elements here
        ; This is just to maintain the GUI's visibility and usability when resized
    }
    
    ; Call default window procedure
    return DllCall("DefWindowProc", "Ptr", hwnd, "UInt", msg, "UPtr", wParam, "Ptr", lParam, "Ptr")
}

; Exit handler
GuiClose:
GuiEscape:
    ; Stop if active
    if (Active)
        StopDominator()
    
    ; Exit application
    ExitApp
Return

; ================ MATH HELPER FUNCTIONS ================
; Function to calculate natural logarithm
Ln(x) {
    Return DllCall("msvcrt.dll\log", "Double", x, "CDECL Double")
}

; Cosine function
Cos(angle) {
    Return DllCall("msvcrt.dll\cos", "Double", angle, "CDECL Double")
}

; Sine function
Sin(angle) {
    Return DllCall("msvcrt.dll\sin", "Double", angle, "CDECL Double")
}

; Square root function
Sqrt(x) {
    Return DllCall("msvcrt.dll\sqrt", "Double", x, "CDECL Double")
}

; Min function to get minimum of two values
Min(a, b) {
    Return (a < b) ? a : b
}

; Max function to get maximum of two values
Max(a, b) {
    Return (a > b) ? a : b
}

; Round a number to the specified decimal places
Round(x, decimals := 0) {
    if (decimals = 0)
        Return Floor(x + 0.5)
    else {
        ; Calculate power of 10 for decimal places
        multiplier := 1
        Loop, %decimals%
            multiplier *= 10
        
        ; Round using integer math
        Return Floor(x * multiplier + 0.5) / multiplier
    }
}

; Floor function
Floor(x) {
    Return DllCall("msvcrt.dll\floor", "Double", x, "CDECL Double")
}

; Ceiling function
Ceil(x) {
    Return DllCall("msvcrt.dll\ceil", "Double", x, "CDECL Double")
}

; Find Roblox window on startup (try to automatically locate it)
FindRobloxWindow()

; Initialization message
MsgBox, 64, PS99 Slime Tycoon Dominator, 
(
PS99 Slime Tycoon Dominator
Version 5.3.2
Customized for: %DISPLAY_NAME% (%USERNAME%)

Instructions:
1. Make sure Roblox is running with Pet Simulator 99
2. Press F8 to select your Roblox window
3. Go to the Slime Tycoon area in the game
4. Press F1 while hovering over the center of slime area
5. Press F6 or click START DOMINATOR to begin

Global Hotkeys:
F6 = Start Dominator
F7 = Stop Dominator
F8 = Set Roblox Window
F9 = Emergency Stop

Made exclusively for %DISPLAY_NAME% by Replit.
)
