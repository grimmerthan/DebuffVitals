-- ------------------------------------------------------------------------
-- Menu and Menu Utilities
-- ------------------------------------------------------------------------
function CreateMenu()

    local menuItems = Turbine.UI.ContextMenu()        
    local menu=menuItems:GetItems()

    menu:Add(Turbine.UI.MenuItem("New Target"))
    menu:Get(1).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("New Target") end
        AddNewTarget()
    end

    menu:Add(Turbine.UI.MenuItem("Remove Target"))
    menu:Get(2).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("Remove Target") end
        RemoveTarget(menuItems.invokerID)
    end

    local show = Turbine.UI.MenuItem("Show", true)
    local showItems = show:GetItems()
    showItems:Add(Turbine.UI.MenuItem("Morale"))
    showItems:Get(1).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("Morale") end
        ShowMorale = not ShowMorale
        for k, v in pairs (TargetFrames) do
            v:Resize()
        end
    end

    showItems:Add(Turbine.UI.MenuItem("Power"))    
    showItems:Get(2).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("Power") end
        ShowPower = not ShowPower
        for k, v in pairs (TargetFrames) do
            v:Resize()
        end
    end
    
    showItems:Add(Turbine.UI.MenuItem("Effects"))
    menu:Add(show, true)

    local options = Turbine.UI.MenuItem("Options", true)
    local optionsItems = options:GetItems()
    optionsItems:Add(Turbine.UI.MenuItem("Lock Position"))
    optionsItems:Get(1).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("Lock Position") end
        LockedPosition = not LockedPosition
    end
    optionsItems:Add(Turbine.UI.MenuItem("Save frame position"))
    optionsItems:Get(2).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("Save Frame Positions") end
        SaveFramePositions = not SaveFramePositions
    end    
    
    optionsItems:Add(Turbine.UI.MenuItem("Save settings "))
    optionsItems:Get(2).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("Save settings") end

    end    
    
    menu:Add(options, true)
    
    return menuItems
end
