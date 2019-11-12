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
import "Grimmerthan.DebuffVitals.Utilities"
import "Grimmerthan.DebuffVitals.VindarPatch"

local DEBUG_ENABLED = DEBUG_ENABLED
-- ------------------------------------------------------------------------
-- Unloading Plugin
-- ------------------------------------------------------------------------
function Turbine.Plugin.Unload()
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Plugin unload") end
    RemoveCallback(LocalUser, "TargetChanged", TargetHandler)
    
    for k = 1, #TargetFrames do
        local frame = TargetFrames[k]
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
function AddNewTarget(LoadedFrame)
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering AddNewTargetFrame...") end
    FrameID = FrameID + 1

    local NewFrame = TargetFrame(FrameID, LoadedFrame)

    TargetFrame.UpdateTarget(NewFrame)

    TargetFrames[#TargetFrames + 1] = NewFrame

    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting AddNewTargetFrame...") end
end

function RemoveTarget(ID)
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering RemoveTargetFrame...") end

    for k = 1, #TargetFrames do
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("TargetFrames[k].ID: "..tostring(TargetFrames[k].ID).. " | ID: "..tostring(ID)) end
        if TargetFrames[k].ID == ID then
            if not TargetFrames[k].Locked then
                TargetFrames[k]:SetVisible(false)
                table.remove(TargetFrames, k)
            end
            break
        end
    end
    collectgarbage()
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting RemoveTargetFrame...") end
end

function CreateFrames()
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering CreateFrames...") end

    FrameID = 0
    GenerateEnabledSet()

    FrameMenu = TargetFrameMenu()
 
    for k = 1, #TargetFrames do
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("deleting k: "..tostring(k)) end        
        TargetFrames[k]:SetVisible(false)
        TargetFrames[k] = nil
    end
    collectgarbage()

    if #loadedFrames > 0 then
        for k = 1, #loadedFrames do
            AddNewTarget(loadedFrames[k]) 
        end
    else
        AddNewTarget()
    end

    FrameMenu:CreateEffectsMenu()

    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting CreateFrames...") end
end
-- ------------------------------------------------------------------------
-- Doing Stuff!
-- 1) loads any stored configuration
-- 2) generate a set of interesting effects
-- 3) generate intial effect frames
-- ------------------------------------------------------------------------

loadedFrames = {}
TargetFrames = {}
TargetFrameSets = {}
TrackedEffects = {}
EffectsSet = {}
FrameID = 0
FrameWidth = DEFAULT_WIDTH
ControlHeight = DEFAULT_HEIGHT
LockedPosition = DEFAULT_LOCKED_POSITION
SaveFramePositions = DEFAULT_SAVE_FRAME_POSITIONS

LocalUser = Turbine.Gameplay.LocalPlayer.GetInstance()
AddCallback(LocalUser, "TargetChanged", TargetChangeHandler); 

LoadSettings{}

CreateFrames()


for k, v in pairs (TargetFrameSets) do              
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("name: "..tostring(k)); end        
end