-- ------------------------------------------------------------------------
-- Menu and Menu Utilities
-- ------------------------------------------------------------------------
TargetFrameMenu = class (Turbine.UI.ContextMenu)        

function TargetFrameMenu:Constructor() 
    Turbine.UI.ContextMenu.Constructor(self)

    self.invokerID = -1

    local menuItems=self:GetItems()

    menuItems:Add(Turbine.UI.MenuItem("New Target"))
    menuItems:Get(1).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("New Target") end
        AddNewTarget()
    end

    menuItems:Add(Turbine.UI.MenuItem("Remove Target"))
    menuItems:Get(2).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("Remove Target") end
        RemoveTarget(self.invokerID)
    end

    menuItems:Add(Turbine.UI.MenuItem("Effects"))

    menuItems:Add(Turbine.UI.MenuItem("Show", true))
    local showItems = menuItems:Get(4):GetItems()

    showItems:Add(Turbine.UI.MenuItem("Effects"))
    showItems:Get(1).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("Effects.Click") end
        TargetFrames[self.invokerID].ShowEffects = not TargetFrames[self.invokerID].ShowEffects
        TargetFrames[self.invokerID]:SetEnabledEffects()
        TargetFrames[self.invokerID]:Resize()
    end

    showItems:Add(Turbine.UI.MenuItem("Morale"))
    showItems:Get(2).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("Morale.Click") end
        TargetFrames[self.invokerID].ShowMorale = not TargetFrames[self.invokerID].ShowMorale
        TargetFrames[self.invokerID]:Resize()
    end

    showItems:Add(Turbine.UI.MenuItem("Power"))    
    showItems:Get(3).Click = function(sender, args)
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("Power.Click") end
        TargetFrames[self.invokerID].ShowPower = not TargetFrames[self.invokerID].ShowPower 
        TargetFrames[self.invokerID]:Resize()
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
    local currentGroup = ''
    for k, v in ipairs (effects) do
        if currentGroup ~= v[1] then
            currentGroup = v[1]
            if DEBUG_ENABLED then Turbine.Shell.WriteLine("New group : "..tostring(currentGroup)) end            
            effectsGroups:Add(Turbine.UI.MenuItem(currentGroup))
        end
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("New item : "..tostring(v[2])) end
        effect = Turbine.UI.MenuItem(v[2], true, true)
        effect.id = k
        effect.Click = function(sender, args)
            if DEBUG_ENABLED then Turbine.Shell.WriteLine(tostring(sender.id)) end
        end
        effectsGroups:Get(effectsGroups:GetCount()):GetItems():Add(effect)
        
    end
end