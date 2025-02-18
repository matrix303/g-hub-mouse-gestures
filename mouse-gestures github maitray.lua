--[[
Author: Mark van den Berg
Version: 0.9 (Revised)
Date: 01-05-2020 (Revised 2025-02-17)

Special credits to https://github.com/wookiefriseur for showing a way to do this for windows gestures which inspired this script
For some windows gestures check https://github.com/wookiefriseur/LogitechMouseGestures

This script wil let you use a button on your mouse to act like the "Gesture button" from Logitech Options.
It will also let you use another button on your mouse for navigating between browser pages using gestures.

The default settings below will be for the multytasking gestures from macOS
 - Up 		Mission Control 	(Control+Up-Arrow)
 - Down 	Application Windows (Control+Down-Arrow)
 - Left 	move right a space 	(Control+Right-Arrow)
 - Right 	move left a space 	(Control+Left-Arrow)

The default settings below will be for the navigation gestures for in browsers
 - Up 		{ no action }
 - Down 	{ no action }
 - Left 	next page 		(Command+Right-Bracket)
 - Right 	previous page 	(Command+Left-Bracket)
]]--


-- The button your gestures are mapped to G1 = 1, G2 = 2 etc..
gestureButtonNumber = 5;

-- The button navigation actions are mapped to G1 = 1, G2 = 2 etc..
navigationButtonNumber = 4;

-- The minimal horizontal/vertical distance your mouse needs to be moved for the gesture to recognize in pixels
minimalHorizontalMovement = 100;
minimalVerticalMovement = 100;

-- Default values for 
horizontalStartingPosistion = 0;
verticalStartingPosistion = 0;
horizontalEndingPosistion = 0;
verticalEndingPosistion = 0;

-- Delay between keypresses in millies
delay = 20

-- Here you can enable/disable features of the script
missionControlEnabled = true
applicationWindowsEnabled = true
moveBetweenSpacesEnabled = true
browserNavigationEnabled = true

-- Toggles debugging messages
debuggingEnabeld = false

-- Flag to track if a gesture has been performed
local gesturePerformed = false

-- --- Original OnEvent Function (for Gesture Movement) ---
function originalOnEvent(event, arg, family)
    if event == "MOUSE_BUTTON_PRESSED" and (arg == gestureButtonNumber or arg == navigationButtonNumber) then
        if debuggingEnabeld then OutputLogMessage("\nEvent: " .. event .. " for button: " .. arg .. "\n") end

        -- Get stating mouse posistion
        horizontalStartingPosistion, verticalStartingPosistion = GetMousePosition()
        gesturePerformed = false -- Reset the flag on button press

        if debuggingEnabeld then
            OutputLogMessage("Horizontal starting posistion: " .. horizontalStartingPosistion .. "\n")
            OutputLogMessage("Vertical starting posistion: " .. verticalStartingPosistion .. "\n")
        end
    end

    if event == "MOUSE_BUTTON_RELEASED" and (arg == gestureButtonNumber or arg == navigationButtonNumber) then
        if debuggingEnabeld then OutputLogMessage("\nEvent: " .. event .. " for button: " .. arg .. "\n") end

        -- Get ending mouse posistion
        horizontalEndingPosistion, verticalEndingPosistion = GetMousePosition()

        if debuggingEnabeld then
            OutputLogMessage("Horizontal ending posistion: " .. horizontalEndingPosistion .. "\n")
            OutputLogMessage("Vertical ending posistion: " .. verticalEndingPosistion .. "\n")
        end

        -- Calculate differences between start and end posistions
        horizontalDifference = horizontalStartingPosistion - horizontalEndingPosistion
        verticalDifference = verticalStartingPosistion - verticalEndingPosistion

        -- Determine the direction of the mouse and if the mouse moved far enough
        if horizontalDifference > minimalHorizontalMovement then gesturePerformed = mouseMovedLeft(arg) end
        if horizontalDifference < -minimalHorizontalMovement then gesturePerformed = mouseMovedRight(arg) end
        if verticalDifference > minimalVerticalMovement then gesturePerformed = mouseMovedDown(arg) end
        if verticalDifference < -minimalVerticalMovement then gesturePerformed = mouseMovedUp(arg) end
    end
    return gesturePerformed
end

-- --- Mouse Moved Functions (Modified to return true) ---
function mouseMovedUp(buttonNumber)
    if debuggingEnabeld then OutputLogMessage("mouseMovedUp\n") end

    if buttonNumber == gestureButtonNumber and missionControlEnabled then
        performMissionControlGesture()
        return true -- Indicate gesture performed
    end
    return false
end

function mouseMovedDown(buttonNumber)
    if debuggingEnabeld then OutputLogMessage("mouseMovedDown\n") end

    if buttonNumber == gestureButtonNumber and applicationWindowsEnabled then
        performApplicationWindowsGesture()
        return true -- Indicate gesture performed
    end
     return false
end

function mouseMovedLeft(buttonNumber)
    if debuggingEnabeld then OutputLogMessage("mouseMovedLeft\n") end

    if buttonNumber == gestureButtonNumber and moveBetweenSpacesEnabled then
        performSwipeLeftGesture()
        return true
    end
    if buttonNumber == navigationButtonNumber and browserNavigationEnabled then
        performNextPageGesture()
        return true
    end
     return false
end

function mouseMovedRight(buttonNumber)
    if debuggingEnabeld then OutputLogMessage("mouseMovedRight\n") end

    if buttonNumber == gestureButtonNumber and moveBetweenSpacesEnabled then
        performSwipeRightGesture()
        return true
    end
    if buttonNumber == navigationButtonNumber and browserNavigationEnabled then
        performPreviousPageGesture()
        return true
    end
     return false
end

-- --- Gesture Functions (Unchanged) ---
function performMissionControlGesture()
    if debuggingEnabeld then OutputLogMessage("performMissionControlGesture\n") end
    firstKey = "lctrl"
    secondKey = "up"
    pressTwoKeys(firstKey, secondKey)
end

function performApplicationWindowsGesture()
    if debuggingEnabeld then OutputLogMessage("performApplicationWindowsGesture\n") end
    firstKey = "lctrl"
    secondKey = "down"
    pressTwoKeys(firstKey, secondKey)
end

function performSwipeLeftGesture()
    if debuggingEnabeld then OutputLogMessage("performSwipeLeftGesture\n") end
    firstKey = "lctrl"
    secondKey = "right"
    pressTwoKeys(firstKey, secondKey)
end

function performSwipeRightGesture()
    if debuggingEnabeld then OutputLogMessage("performSwipeRightGesture\n") end
    firstKey = "lctrl"
    secondKey = "left"
    pressTwoKeys(firstKey, secondKey)
end

-- --- Browser Navigation Functions (Unchanged) ---
function performNextPageGesture()
    if debuggingEnabeld then OutputLogMessage("performNextPageGesture\n") end
    firstKey = "lgui"
    secondKey = "rbracket"
    pressTwoKeys(firstKey, secondKey)
end

function performPreviousPageGesture()
    if debuggingEnabeld then OutputLogMessage("performPreviousPageGesture\n") end
    firstKey = "lgui"
    secondKey = "lbracket"
    pressTwoKeys(firstKey, secondKey)
end

-- --- Helper Functions (Unchanged) ---
function pressTwoKeys(firstKey, secondKey)
    PressKey(firstKey)
    Sleep(delay)
    PressKey(secondKey)
    Sleep(delay)
    ReleaseKey(firstKey)
    ReleaseKey(secondKey)
end

function instantMissionControl()
    if debuggingEnabeld then OutputLogMessage("instantMissionControl\n") end
    PressKey("lctrl")
    Sleep(delay)
    PressKey("up")
    Sleep(delay)
    ReleaseKey("up")
    ReleaseKey("lctrl")
end

-- --- Main OnEvent Function (Handles Both Instant Click and Gesture Movement) ---
function OnEvent(event, arg, family)
    local gestureWasPerformed = originalOnEvent(event, arg, family)

    -- Handle instant Mission Control on gesture button *release* only if no gesture was performed
    if event == "MOUSE_BUTTON_RELEASED" and arg == gestureButtonNumber and not gestureWasPerformed then
        instantMissionControl()
    end
end
