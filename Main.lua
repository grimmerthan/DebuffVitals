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

-- ------------------------------------------------------------------------
-- Unloading Plugin
-- ------------------------------------------------------------------------
function plugin.Unload()
    Turbine.Shell.WriteLine("Unloading TargetChanged handler")
    RemoveCallback(Turbine.Gameplay.LocalPlayer.GetInstance(), "TargetChanged", TargetHandler)
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
    Turbine.Shell.WriteLine("Entering AddNewTargetFrame...")
    Count = Count + 1
    NewTarget = TargetBox.new(Count)
    Turbine.Shell.WriteLine("NewTarget : "..tostring(NewTarget))
    targets[Count] = NewTarget
    TargetChangeHandler (NewTarget)
    Turbine.Shell.WriteLine("Exiting AddNewTargetFrame...")
end

function RemoveTarget(ID)
    Turbine.Shell.WriteLine("Entering RemoveTargetFrame...")
    for key,box in pairs(targets) do 
        Turbine.Shell.WriteLine("targets[key].ID == ID //"..tostring (TargetBox.GetID(box).." == "..tostring(ID)))
        if TargetBox.GetID(box) == ID then
            Turbine.Shell.WriteLine("Removing : "..tostring (ID))
            if not TargetBox.IsLocked(box) then
                Turbine.Shell.WriteLine("Processing Removal...")
                TargetBox.DestroyFrame(box)
                table.remove(targets, key)
            end
            break
        end
    end
    Turbine.Shell.WriteLine("Exiting RemoveTargetFrame...")
end

--[[
function RemoveOtherTargets(ID)
    Turbine.Shell.WriteLine("Entering RemoveOtherTargets...")
    for key,box in pairs(targets) do 
        Turbine.Shell.WriteLine("targets[key].ID == ID //"..tostring (TargetBox.GetID(box).." == "..tostring(ID)))
        if TargetBox.GetID(box) ~= ID then
            Turbine.Shell.WriteLine("Removing : "..tostring (ID))
            if not TargetBox.IsLocked(box) then
                Turbine.Shell.WriteLine("Processing Removal...")
                TargetBox.DestroyFrame(box)
                table.remove(targets, key)
            end
        end
    end
    Turbine.Shell.WriteLine("Exiting RemoveOtherTargets...")
end
]]
-- ------------------------------------------------------------------------
-- Target Change Handler and Helpers
-- ------------------------------------------------------------------------
function TargetChangeHandler(sender, args)
    Turbine.Shell.WriteLine("Entering TargetChangeHandler...")
    Turbine.Shell.WriteLine("Changed target")
    for key,box in pairs(targets) do
        Turbine.Shell.WriteLine("ID : "..tostring(key).." value : "..tostring(box))
        TargetBox.UpdateTarget(box)
    end
    Turbine.Shell.WriteLine("Exiting TargetChangeHandler...")
end


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
for k, v in pairs(Turbine.Gameplay.Effect) do
    Turbine.Shell.WriteLine(k)
end
]]
