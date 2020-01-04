--[[

This plugin is a tool to help players track mobs and specific effects on mobs.  Reference page is :
    https://www.lotrointerface.com/downloads/fileinfo.php?id=1015

]]

import "Turbine.Gameplay"
import "Turbine.UI" 
import "Turbine.UI.Lotro"
import "Grimmerthan.DebuffVitals.Constants"
import "Grimmerthan.DebuffVitals.CommandLine"
import "Grimmerthan.DebuffVitals.EffectFrame"
import "Grimmerthan.DebuffVitals.Handlers"
import "Grimmerthan.DebuffVitals.LoadSave"
import "Grimmerthan.DebuffVitals.Menu"
import "Grimmerthan.DebuffVitals.OptionsPanel"
import "Grimmerthan.DebuffVitals.TargetFrame"
import "Grimmerthan.DebuffVitals.TargetFrameUtilities"
import "Grimmerthan.DebuffVitals.Utilities"
import "Grimmerthan.DebuffVitals.VindarPatch"

-- ------------------------------------------------------------------------
-- Doing Stuff!
-- 1) loads any stored configuration
-- 2) generate a set of interesting effects
-- 3) generate intial effect frames
-- ------------------------------------------------------------------------

FrameID = 0
FrameWidth = DEFAULT_WIDTH
ControlHeight = DEFAULT_HEIGHT
EffectsModulus = DEFAULT_EFFECTS_MODULUS
LockedPosition = DEFAULT_LOCKED_POSITION
SaveFramePositions = DEFAULT_SAVE_FRAME_POSITIONS
CurrentTarget = nil

-- Any frames loaded from the root of the save file
loadedFrames = {}

-- The current set of frames 
TargetFrames = {}

-- The collection of sets of frames.  These can be manipulated (activate, delete, etc).
TargetFrameSets = {}

-- The complete list of tracked effects available
TrackedEffects = {}

-- The base right-click context menu
FrameMenu = TargetFrameMenu()

-- Create the list of known effects
for k = 1, #DEFAULT_EFFECTS do
    TrackedEffects[#TrackedEffects + 1] = {DEFAULT_EFFECTS[k][1], DEFAULT_EFFECTS[k][2], DEFAULT_EFFECTS[k][3], 
                                           DEFAULT_EFFECTS[k][4], DEFAULT_EFFECTS[k][5]}
end

-- The options panel in plugins manager
OP = OptionsPanel()

LocalUser = Turbine.Gameplay.LocalPlayer.GetInstance()
AddCallback(LocalUser, "TargetChanged", TargetChangeHandler); 

-- The subset of effects that are 'interesting' (enabled in options panel and
--      considered in a target frame)
EffectsSet = {}

LoadSettings()

CreateFrames()