-- ------------------------------------------------------------------------
-- Menu and Menu Utilities
-- ------------------------------------------------------------------------
function CreateMenu(MenuItems)
        
    menu=MenuItems:GetItems()
    menu:Add(Turbine.UI.MenuItem("Effects Menu", false))
    menu:Add(Turbine.UI.MenuItem("New Target"))
    menu:Add(Turbine.UI.MenuItem("Remove Target"))
    
    menu:Get(2).Click = function(sender, args)
        Turbine.Shell.WriteLine("Add one")
        AddNewTargetFrame()
    end
    menu:Get(3).Click = function(sender, args)
        Turbine.Shell.WriteLine("Remove one")
        RemoveTargetFrame(MenuItems.invokerID)
    end
    
end

