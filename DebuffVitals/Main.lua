--[[

check 1) basic layout
check 2) Lock functionality
check 3) target change callback
4) morale callback
5) power callback
6) fire-lore and Frost-lore detection
7) timer remaining
8) corruption detection
9) other buffs 
10) configuration options
11) localization

]]

import "Turbine.Gameplay"
import "Turbine.UI" 
import "Turbine.UI.Lotro"
import "Grimmerthan.DebuffVitals.Menu"
import "Grimmerthan.DebuffVitals.TargetBox"
import "Grimmerthan.DebuffVitals.Handlers"
import "Grimmerthan.DebuffVitals.EffectFrame"

DebugEnabled = true

function DebugWriteLine (message)
    if DebugEnabled then
        Turbine.Shell.WriteLine(message)
    end
end

-- ------------------------------------------------------------------------
-- Unloading Plugin
-- ------------------------------------------------------------------------
function plugin.Unload()
    DebugWriteLine("Unloading TargetChanged handler")
    RemoveCallback(LocalUser, "TargetChanged", TargetHandler)
    
    for key,box in pairs(targets) do
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
-- targets Utilities
-- ------------------------------------------------------------------------
function CountTargets()
    local number = 0
    for key,box in pairs(targets) do 
        number = number + 1
    end
    return number
end

function AddNewTarget()
    DebugWriteLine("Entering AddNewTargetFrame...")
    Count = Count + 1
--    NewTarget = TargetBox.new(Count)
    NewTarget = TargetBox(Count)
--    DebugWriteLine("NewTarget : "..tostring(NewTarget))
    targets[Count] = NewTarget
    TargetChangeHandler (NewTarget)
    DebugWriteLine("Exiting AddNewTargetFrame...")
end

function RemoveTarget(ID)
    DebugWriteLine("Entering RemoveTargetFrame...")
    for key,box in pairs(targets) do 
        DebugWriteLine("targets[key].ID == ID //"..tostring (TargetBox.GetID(box).." == "..tostring(ID)))
        if TargetBox.GetID(box) == ID then
            DebugWriteLine("Removing : "..tostring (ID))
            if not TargetBox.IsLocked(box) then
                DebugWriteLine("Processing Removal...")
                TargetBox.DestroyFrame(box)
                table.remove(targets, key)
            end
            break
        end
    end
    DebugWriteLine("Exiting RemoveTargetFrame...")
end

--[[
function RemoveOtherTargets(ID)
    DebugWriteLine("Entering RemoveOtherTargets...")
    for key,box in pairs(targets) do 
        DebugWriteLine("targets[key].ID == ID //"..tostring (TargetBox.GetID(box).." == "..tostring(ID)))
        if TargetBox.GetID(box) ~= ID then
            DebugWriteLine("Removing : "..tostring (ID))
            if not TargetBox.IsLocked(box) then
                DebugWriteLine("Processing Removal...")
                TargetBox.DestroyFrame(box)
                table.remove(targets, key)
            end
        end
    end
    DebugWriteLine("Exiting RemoveOtherTargets...")
end
]]

-- ------------------------------------------------------------------------
-- Doing Stuff!
-- ------------------------------------------------------------------------

targets = {}

Count = 0

LocalUser = Turbine.Gameplay.LocalPlayer.GetInstance()

AddCallback(LocalUser, "TargetChanged", TargetChangeHandler);

MenuItems = Turbine.UI.ContextMenu()
CreateMenu(MenuItems)

AddNewTarget()

--[[

DebugWriteLine("Turbine.Gameplay.Effect...")
for key, value in pairs (Turbine.Gameplay.Effect) do
    DebugWriteLine(tostring(key))
end
DebugWriteLine("Turbine.Gameplay.EffectList...")
for key, value in pairs (Turbine.Gameplay.EffectList) do
    DebugWriteLine(tostring(key))
end
]]--