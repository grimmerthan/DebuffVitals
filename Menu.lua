-- ------------------------------------------------------------------------
-- Menu and Menu Utilities
-- ------------------------------------------------------------------------
function CreateMenu(MenuItems)
        
    menu=MenuItems:GetItems()
    menu:Add(Turbine.UI.MenuItem("Effects Menu", false))
    menu:Add(Turbine.UI.MenuItem("New Target"))
    menu:Add(Turbine.UI.MenuItem("Remove Target"))
--    menu:Add(Turbine.UI.MenuItem("Remove Other Targets"))
    
    menu:Get(2).Click = function(sender, args)
        DebugWriteLine("New Target")
        AddNewTarget()
    end
    menu:Get(3).Click = function(sender, args)
        DebugWriteLine("Remove Target")
        RemoveTarget(MenuItems.invokerID)
    end
--    menu:Get(4).Click = function(sender, args)
--        DebugWriteLine("Remove Other Targets")
--        RemoveOtherTargets(MenuItems.invokerID)
--    end
    
end