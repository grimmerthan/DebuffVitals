-- ------------------------------------------------------------------------
-- Menu and Menu Utilities
-- ------------------------------------------------------------------------
TargetFrameMenu = class (Turbine.UI.ContextMenu)        

function TargetFrameMenu:Constructor() 
    Turbine.UI.ContextMenu.Constructor(self)

    local menuItems=self:GetItems()

    menuItems:Add(Turbine.UI.MenuItem("New Target"))
    menuItems:Get(1).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("New Target") end
        AddNewTarget()
    end

    menuItems:Add(Turbine.UI.MenuItem("Remove Target"))
    menuItems:Get(2).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("Remove Target") end
        RemoveTarget(self.invoker.ID)
    end

    menuItems:Add(Turbine.UI.MenuItem("Effects"))

    menuItems:Add(Turbine.UI.MenuItem("Show", true))
    local showItems = menuItems:Get(4):GetItems()

    showItems:Add(Turbine.UI.MenuItem("Effects"))
    showItems:Get(1).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("Effects.Click") end
        self.invoker.ShowEffects = not self.invoker.ShowEffects
        self.invoker:SetEnabledEffects()
        self.invoker:Resize()
    end

    showItems:Add(Turbine.UI.MenuItem("Morale"))
    showItems:Get(2).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("Morale.Click") end
        self.invoker.ShowMorale = not self.invoker.ShowMorale
        self.invoker:Resize()
    end

    showItems:Add(Turbine.UI.MenuItem("Power"))    
    showItems:Get(3).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("Power.Click") end
        self.invoker.ShowPower = not self.invoker.ShowPower 
        self.invoker:Resize()
    end

    menuItems:Add(Turbine.UI.MenuItem("Options", true))
    local optionsItems = menuItems:Get(5):GetItems()
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
    optionsItems:Get(3).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("Save settings") end
        SaveSettings()
    end    

end

function TargetFrameMenu:CreateEffectsMenu()
    local effectsGroups = FrameMenu:GetItems():Get(3):GetItems()

    effectsGroups:Clear()

    local effects = EffectsSet
    for k, v in ipairs (effects) do
        effect = Turbine.UI.MenuItem(v[2], true, true)
        effect.id = k
        effect.Click = function(sender, args)
            if DEBUG_ENABLED then Turbine.Shell.WriteLine(tostring(self.invoker.EnabledEffectsToggles[k][1])) end        
            self.invoker.EnabledEffectsToggles[k][2] = not self.invoker.EnabledEffectsToggles[k][2]
            self.invoker:SetEnabledEffects()
            self.invoker:Resize()
        end
        effectsGroups:Add(effect)
    end
end