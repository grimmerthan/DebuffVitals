--[[

check 1) basic layout
check 2) Lock functionality
check 3) target change callback
check 4) morale callback
check 5) power callback
check 6) fire-lore and Frost-lore detection
check 7) timer remaining
8) corruption detection
check 9) other buffs 
check 10) configuration options
11) localization
12) hide morale/power
13) reduce footprint
14) flash timer

]]

import "Turbine.Gameplay"
import "Turbine.UI" 
import "Turbine.UI.Lotro"
import "Grimmerthan.DebuffVitals.Constants"
import "Grimmerthan.DebuffVitals.Debug"
import "Grimmerthan.DebuffVitals.Effects"
import "Grimmerthan.DebuffVitals.EffectFrame"
import "Grimmerthan.DebuffVitals.Handlers"
import "Grimmerthan.DebuffVitals.Menu"
import "Grimmerthan.DebuffVitals.OptionsPanel"
import "Grimmerthan.DebuffVitals.TargetBox"


-- ------------------------------------------------------------------------
-- Unloading Plugin
-- ------------------------------------------------------------------------
function Turbine.Plugin.Unload()
    DebugWriteLine("Plugin unload")
    RemoveCallback(LocalUser, "TargetChanged", TargetHandler)
    
    for key,box in pairs(TargetFrames) do
        if box.Target then 
            RemoveCallback(box.Target, "MoraleChanged", MoraleChangedHandler);
            RemoveCallback(box.Target, "BaseMaxMoraleChanged", MoraleChangedHandler);
            RemoveCallback(box.Target, "MaxMoraleChanged", MoraleChangedHandler);
            RemoveCallback(box.Target, "MaxTemporaryMoraleChanged", MoraleChangedHandler);
            RemoveCallback(box.Target, "TemporaryMoraleChanged", MoraleChangedHandler);
            RemoveCallback(box.Target, "PowerChanged", PowerChangedHandler);
            RemoveCallback(box.Target, "BaseMaxPowerChanged", PowerChangedHandler);
            RemoveCallback(box.Target, "MaxPowerChanged", PowerChangedHandler);
            RemoveCallback(box.Target, "MaxTemporaryPowerChanged", PowerChangedHandler);
            RemoveCallback(box.Target, "TemporaryPowerChanged", PowerChangedHandler);
        end
        if box.Effects then
            RemoveCallback(box.Effects, "EffectAdded", EffectsChangedHandler);
            RemoveCallback(box.Effects, "EffectRemoved", EffectsChangedHandler);
            RemoveCallback(box.Effects, "EffectsCleared", EffectsChangedHandler);   
        end
    end    
end


-- ------------------------------------------------------------------------
-- Callbacks
-- ------------------------------------------------------------------------
function AddCallback(object, event, callback)
    if (object[event] == nil) then
        object[event] = callback;
    else
        if (type(object[event]) == "table") then
            table.insert(object[event], callback);
        else
            object[event] = {object[event], callback};
        end
    end
    return callback;
end

function RemoveCallback(object, event, callback)
    if (object[event] == callback) then
        object[event] = nil;
    else
        if (type(object[event]) == "table") then
            local size = table.getn(object[event]);
            for i = 1, size do
                if (object[event][i] == callback) then
                    table.remove(object[event], i);
                    break;
                end
            end
        end
    end
end

-- ------------------------------------------------------------------------
-- Target Utilities
-- ------------------------------------------------------------------------
function AddNewTarget()
    DebugWriteLine("Entering AddNewTargetFrame...")
    FrameID = FrameID + 1
    TargetFrames[FrameID] = TargetBox(FrameID)
    TargetChangeHandler (NewTarget)
    DebugWriteLine("Exiting AddNewTargetFrame...")
end

function RemoveTarget(ID)
    DebugWriteLine("Entering RemoveTargetFrame...")
    for key,box in pairs(TargetFrames) do 
        DebugWriteLine("TargetBox.GetID(box) == ID //"..tostring (TargetBox.GetID(box).." == "..tostring(ID)))
        if TargetBox.GetID(box) == ID then
            DebugWriteLine("Removing : "..tostring (ID))
            if not TargetBox.IsLocked(box) then
                DebugWriteLine("Processing Removal...")
                TargetBox.DestroyFrame(box)
                table.remove(TargetFrames, key)
            end
            break
        end
    end
    DebugWriteLine("Exiting RemoveTargetFrame...")
end

-- ------------------------------------------------------------------------
-- Doing Stuff!
-- 1) generate effects list (load configuration)
-- 2) generate effect frames
-- ------------------------------------------------------------------------

TargetFrames = {}
TrackedEffects = {}
EffectsSet = {}
FrameID = 0
LocalUser = Turbine.Gameplay.LocalPlayer.GetInstance()
FrameWidth = DEFAULT_WIDTH
ControlHeight = DEFAULT_HEIGHT

LoadEffects{}

GenerateEnabledSet()

AddCallback(LocalUser, "TargetChanged", TargetChangeHandler);

MenuItems = CreateMenu()

AddNewTarget()

--[[
DebugWriteLine("Turbine.UI.Color...")
local text = ""
for key, value in pairs (Turbine.UI.Color) do
    text = text.." "..tostring(key) 
end
    DebugWriteLine(text)

for key, value in pairs (DEFAULT_EFFECTS) do
    DebugWriteLine(tostring(key), tostring(value))
    for key2, value2 in pairs (value) do
        DebugWriteLine(tostring(key2), tostring(value2))
    end    
end
DebugWriteLine("Turbine.Gameplay.Effect...")
for key, value in pairs (Turbine.Gameplay.Effect) do
    DebugWriteLine(tostring(key))
end
DebugWriteLine("Turbine.Gameplay.EffectList...")
for key, value in pairs (Turbine.Gameplay.EffectList) do
    DebugWriteLine(tostring(key))
end
]]--