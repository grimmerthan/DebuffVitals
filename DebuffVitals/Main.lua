--[[

This plugin is a tool to help players track mobs and specific effects on mobs.  This plugins :
- shows current level, name, morale, and power
- shows presence and timers of specific and selected effects
- resizable
- position lockable
- track corruption counts, for specific boss fights

Future works include:   
(up next) - re-order effects
(up next) - right click context menu for effect selection
(up next) - allow different effects for each frame
- morale/power bar at bottom
- add more effects as requested or apparent
- fix issues (please find some)
- localization
- player buff tracking, eg, stun immunity
- creep-side versions
- look into garbage collection for possible memory concerns

]]

import "Turbine.Gameplay"
import "Turbine.UI" 
import "Turbine.UI.Lotro"
import "Grimmerthan.DebuffVitals.Constants"
import "Grimmerthan.DebuffVitals.EffectFrame"
import "Grimmerthan.DebuffVitals.Handlers"
import "Grimmerthan.DebuffVitals.Menu"
import "Grimmerthan.DebuffVitals.OptionsPanel"
import "Grimmerthan.DebuffVitals.TargetFrame"
import "Grimmerthan.DebuffVitals.Utilities"
import "Grimmerthan.DebuffVitals.VindarPatch"

-- ------------------------------------------------------------------------
-- Unloading Plugin
-- ------------------------------------------------------------------------
function Turbine.Plugin.Unload()
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Plugin unload") end
    RemoveCallback(LocalUser, "TargetChanged", TargetHandler)
    
    for key, frame in pairs (TargetFrames) do
        if frame.Target then 
            RemoveCallback(frame.Target, "MoraleChanged", MoraleChangedHandler);
            RemoveCallback(frame.Target, "BaseMaxMoraleChanged", MoraleChangedHandler);
            RemoveCallback(frame.Target, "MaxMoraleChanged", MoraleChangedHandler);
            RemoveCallback(frame.Target, "MaxTemporaryMoraleChanged", MoraleChangedHandler);
            RemoveCallback(frame.Target, "TemporaryMoraleChanged", MoraleChangedHandler);
            RemoveCallback(frame.Target, "PowerChanged", PowerChangedHandler);
            RemoveCallback(frame.Target, "BaseMaxPowerChanged", PowerChangedHandler);
            RemoveCallback(frame.Target, "MaxPowerChanged", PowerChangedHandler);
            RemoveCallback(frame.Target, "MaxTemporaryPowerChanged", PowerChangedHandler);
            RemoveCallback(frame.Target, "TemporaryPowerChanged", PowerChangedHandler);
        end
        if frame.Effects then
            RemoveCallback(frame.Effects, "EffectAdded", EffectsChangedHandler);
            RemoveCallback(frame.Effects, "EffectRemoved", EffectsChangedHandler);
            RemoveCallback(frame.Effects, "EffectsCleared", EffectsChangedHandler);   
        end
    end    
end

-- ------------------------------------------------------------------------
-- Target Utilities
-- ------------------------------------------------------------------------
function AddNewTarget()
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering AddNewTargetFrame...") end
    FrameID = FrameID + 1
    TargetFrames[FrameID] = TargetFrame(FrameID)
    TargetChangeHandler ()
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting AddNewTargetFrame...") end
    return TargetFrames[FrameID]
end

function RemoveTarget(ID)
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering RemoveTargetFrame...") end
    for key, frame in pairs (TargetFrames) do 
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("frame.GetID(frame) == ID //"..tostring (frame.ID).." == "..tostring(ID)) end
        if frame.ID == ID then
            if DEBUG_ENABLED then Turbine.Shell.WriteLine("Removing : "..tostring (ID)) end
            if not frame.Locked then
                if DEBUG_ENABLED then Turbine.Shell.WriteLine("Processing Removal...") end
                frame:SetVisible(false)
                TargetFrames[key] = nil
            end
            break
        end
    end
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting RemoveTargetFrame...") end
end

-- ------------------------------------------------------------------------
-- Doing Stuff!
-- 1) loads any stored configuration
-- 2) generate a set of interesting effects
-- 3) generate intial effect frames
-- ------------------------------------------------------------------------

TargetFrames = {}
TrackedEffects = {}
EffectsSet = {}
GroupedEffectsSet = {}
FrameID = 0
FrameWidth = DEFAULT_WIDTH
ControlHeight = DEFAULT_HEIGHT
LockedPosition = DEFAULT_LOCKED_POSITION
SaveFramePositions = DEFAULT_SAVE_FRAME_POSITIONS
FramePositions = {}
ShowMorale = DEFAULT_SHOW_MORALE
ShowPower = DEFAULT_SHOW_POWER

LocalUser = Turbine.Gameplay.LocalPlayer.GetInstance()

LoadSettings{}

GenerateEnabledSet()

--GenerateGroupedSet()

AddCallback(LocalUser, "TargetChanged", TargetChangeHandler);

MenuItems = CreateMenu()

--for i = 1, PreLoadedCount do
for i = 1, 1 do

    target = AddNewTarget()

    if FramePositions[i] then
        if FramePositions[i][1] + target:GetWidth() < Turbine.UI.Display:GetWidth() and 
           FramePositions[i][2] + target:GetHeight() < Turbine.UI.Display:GetHeight() then      
            target:SetPosition(FramePositions[i][1],FramePositions[i][2])
        end
    end
end

