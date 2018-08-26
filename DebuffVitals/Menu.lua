-- ------------------------------------------------------------------------
-- Menu and Menu Utilities
-- ------------------------------------------------------------------------
function CreateMenu()

    menuItems = Turbine.UI.ContextMenu()        
    menu=menuItems:GetItems()
    menu:Add(Turbine.UI.MenuItem("Effects Menu", false))
    menu:Add(Turbine.UI.MenuItem("New Target"))
    menu:Add(Turbine.UI.MenuItem("Remove Target"))
    
    menu:Get(2).Click = function(sender, args)
        DebugWriteLine("New Target")
        AddNewTarget()
    end
    menu:Get(3).Click = function(sender, args)
        DebugWriteLine("Remove Target")
        RemoveTarget(menuItems.invokerID)
    end
    return menuItems
end