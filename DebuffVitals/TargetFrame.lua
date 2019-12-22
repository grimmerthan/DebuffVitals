local DEBUG_ENABLED = DEBUG_ENABLED
local DEFAULT_EFFECTS_MODULUS = DEFAULT_EFFECTS_MODULUS

-- ------------------------------------------------------------------------
-- TargetFrame - the base panel that tracks morale/power and effects 
-- ------------------------------------------------------------------------
TargetFrame = class (Turbine.UI.Window)

function TargetFrame:Constructor(FrameID, LoadedFrame) 
    Turbine.UI.Window.Constructor(self)

    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering TargetFrame:Constructor") end

    self.ID = FrameID
    self.Target = nil
    self.Morale = {}
    self.Morale.visible = true
    self.Power = {}
    self.Power.visible = true 
    self.Locked = false
    self.lastCorruptionSeen = 0
    self.effectsCounter = 0

    self:SetVisible(true) 
    self:SetMouseVisible (false)      

    -- ------------------------------------------------------------------------
    -- Target Title Bar
    -- ------------------------------------------------------------------------ 
    self.TitleBar = Turbine.UI.Label()
    self.TitleBar:SetVisible(true)
    self.TitleBar:SetParent (self)
    -- to accomodate the square lock icon
    self.TitleBar:SetSize(FrameWidth - ControlHeight, ControlHeight)
    self.TitleBar:SetPosition (0,0)
    self.TitleBar:SetTextAlignment (Turbine.UI.ContentAlignment.MiddleLeft)
    self.TitleBar:SetFont (Turbine.UI.Lotro.Font.Verdana12)
    self.TitleBar:SetBackColor (Turbine.UI.Color.Black)
    self.TitleBar:SetMultiline (false)  
  
    -- ------------------------------------------------------------------------
    -- Target Selection
    -- ------------------------------------------------------------------------
    self.TargetSelection = Turbine.UI.Lotro.EntityControl()
    self.TargetSelection:SetVisible (true)
    self.TargetSelection:SetParent (self)
    -- size will be set later, when all effects are loaded
    self.TargetSelection:SetPosition (0, 20)
    self.TargetSelection:SetZOrder (100)
    
    -- ------------------------------------------------------------------------
    -- Lock Control
    -- ------------------------------------------------------------------------
    self.LockBackground = Turbine.UI.Control()
    self.LockBackground:SetParent (self)
    self.LockBackground:SetBackColor (Turbine.UI.Color.Black)
    self.LockBackground:SetSize (ControlHeight, ControlHeight)
    self.LockBackground:SetPosition (FrameWidth - ControlHeight, 0)
    
    self.Lock = Turbine.UI.Control()
    self.Lock:SetParent (self)
    self.Lock:SetBackground (0x410001D3)

    self.Lock:SetSize (ControlHeight, ControlHeight)
    self.Lock:SetPosition (FrameWidth - ControlHeight,0)
    self.Lock:SetBlendMode (Turbine.UI.BlendMode.Overlay)

    self.Lock.MouseClick = function ()
        self.Locked = not self.Locked
        if self.Locked then
            self.Lock:SetBackground( 0x410001D1 )
        else
            self.Lock:SetBackground( 0x410001D3 )
            self:UpdateTarget()
        end
    end

    -- ------------------------------------------------------------------------
    -- Morale 
    -- ------------------------------------------------------------------------
    local moralePosition = self.TitleBar:GetHeight()

    self.ShowMorale = DEFAULT_SHOW_MORALE
    if LoadedFrame ~= nil and LoadedFrame.ShowMorale ~= nil then self.ShowMorale = LoadedFrame.ShowMorale end
    
    self.Morale.Bar = Turbine.UI.Control()
    self.Morale.Bar:SetParent (self)
    self.Morale.Bar:SetBackColor (Turbine.UI.Color.ForestGreen )
    self.Morale.Bar:SetSize (FrameWidth, ControlHeight)
    self.Morale.Bar:SetPosition (0, moralePosition)
    self.Morale.Bar:SetMouseVisible (false)
    self.Morale.Bar:SetVisible (self.ShowMorale)

    self.Morale.Percent = Turbine.UI.Label()
    self.Morale.Percent:SetParent (self)
    self.Morale.Percent:SetPosition (0, moralePosition)
    self.Morale.Percent:SetSize (45, ControlHeight)
    self.Morale.Percent:SetMouseVisible (false)
    self.Morale.Percent:SetTextAlignment (Turbine.UI.ContentAlignment.MiddleLeft)
    self.Morale.Percent:SetFont (Turbine.UI.Lotro.Font.Verdana12 )
    self.Morale.Percent:SetVisible (self.ShowMorale)    

    self.Morale.Title = Turbine.UI.Label()
    self.Morale.Title:SetParent (self)
    self.Morale.Title:SetPosition (45, moralePosition)
    self.Morale.Title:SetSize(FrameWidth - 45, ControlHeight)
    self.Morale.Title:SetMouseVisible (false)
    self.Morale.Title:SetText ("")
    self.Morale.Title:SetTextAlignment (Turbine.UI.ContentAlignment.MiddleRight)
    self.Morale.Title:SetFont (Turbine.UI.Lotro.Font.Verdana12)
    self.Morale.Title:SetVisible (self.ShowMorale)

    -- ------------------------------------------------------------------------
    -- Power
    -- ------------------------------------------------------------------------
    local powerPosition = self.TitleBar:GetHeight() + self.Morale.Bar:GetHeight()

    self.ShowPower = DEFAULT_SHOW_POWER
    if LoadedFrame ~= nil and LoadedFrame.ShowPower ~= nil then self.ShowPower = LoadedFrame.ShowPower end 

    self.Power.Bar = Turbine.UI.Control()
    self.Power.Bar:SetParent (self)
    self.Power.Bar:SetBackColor (Turbine.UI.Color.RoyalBlue)
    self.Power.Bar:SetSize (FrameWidth, ControlHeight)
    self.Power.Bar:SetPosition (0, powerPosition)
    self.Power.Bar:SetMouseVisible (false)
    self.Power.Bar:SetVisible (self.ShowPower)

    self.Power.Percent = Turbine.UI.Label()
    self.Power.Percent:SetParent (self)
    self.Power.Percent:SetPosition (0, powerPosition)
    self.Power.Percent:SetSize (45, ControlHeight)
    self.Power.Percent:SetMouseVisible (false)
    self.Power.Percent:SetTextAlignment (Turbine.UI.ContentAlignment.MiddleLeft)
    self.Power.Percent:SetFont (Turbine.UI.Lotro.Font.Verdana12)
    self.Power.Percent:SetVisible (self.ShowPower)

    self.Power.Title = Turbine.UI.Label()
    self.Power.Title:SetParent (self)
    self.Power.Title:SetPosition (45, powerPosition)
    self.Power.Title:SetSize(FrameWidth - 45, ControlHeight)
    self.Power.Title:SetMouseVisible (false)
    self.Power.Title:SetText ("")
    self.Power.Title:SetTextAlignment (Turbine.UI.ContentAlignment.MiddleRight)
    self.Power.Title:SetFont (Turbine.UI.Lotro.Font.Verdana12)
    self.Power.Title:SetVisible (self.ShowPower)

    -- ------------------------------------------------------------------------
    -- Effect Display
    -- ------------------------------------------------------------------------
    -- Effects are filtered twice before being shown
    --  1) globally, the entire list of effects in Constants.lua is filtered by selections in OptionsPanel.lua
    --  2) local to each TargetFrame, this subset of effects are shown as an effects menu, and individually selectable
    
    self.ShowEffects = DEFAULT_SHOW_EFFECTS
    if LoadedFrame ~= nil and LoadedFrame.ShowEffects ~= nil then self.ShowEffects = LoadedFrame.ShowEffects end    
    
    -- Turbine.Gameplay.EffectsList for a specific target
    self.EffectsList = nil
    -- A filter that defines which EnabledEffects are interesting out of the global EffectsList
    self.EnabledEffectsToggles = {}
    -- The set of actual effects a target is looking for 
    self.EnabledEffects = {}
  
    if LoadedFrame ~= nil then
        if LoadedFrame.EnabledEffectsToggles ~= nil then
            for k = 1, #LoadedFrame.EnabledEffectsToggles do
                if DEBUG_ENABLED then Turbine.Shell.WriteLine("EffectToggle: "..tostring(LoadedFrame.EnabledEffectsToggles[k][1]).." "..tostring(LoadedFrame.EnabledEffectsToggles[k][2])) end        
            end
            self.EnabledEffectsToggles = LoadedFrame.EnabledEffectsToggles                  
        else
            for k = 1, #EffectsSet do
                self.EnabledEffectsToggles[k] = {EffectsSet[k][2], false}
            end           
        end       
    else
        for k = 1, #EffectsSet do
            self.EnabledEffectsToggles[k] = {EffectsSet[k][2], true}
        end
    end

    self:SetEnabledEffects()
    self:Resize()

    if LoadedFrame ~= nil and LoadedFrame.Position ~= nil 
        and LoadedFrame.Position[1] + FrameWidth <= Turbine.UI.Display:GetWidth() 
        and LoadedFrame.Position[2] + self:GetHeight() <= Turbine.UI.Display:GetHeight() then
            self:SetPosition(LoadedFrame.Position[1], LoadedFrame.Position[2]) 
    else    
        self:SetPosition(Turbine.UI.Display:GetWidth()/5 + (self.ID % 20) * 40, 
                         Turbine.UI.Display:GetHeight()/5 + (self.ID % 20) * 40)
    end

    -- ------------------------------------------------------------------------
    -- Mouse and key interactions
    -- ------------------------------------------------------------------------
    -- Hide with interface
    self:SetWantsKeyEvents( true )
    function self:KeyDown( args )
        a = args.Action
        if ( a == 268435635 ) then
            self:SetVisible( not self:IsVisible() )
        end
    end

    -- Mouse and Dragging
    self.IsDragging = false

    self.TargetSelection.MouseDown = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Left and not LockedPosition then
            startX = args.X
            startY = args.Y
            self.IsDragging = true
        end
    end

    self.TargetSelection.MouseUp = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Left then
            if self.IsDragging then
                self.IsDragging = false
                
                self:SetLeft(self:GetLeft() + (args.X - startX))
                self:SetTop(self:GetTop() + (args.Y - startY))

                if self:GetLeft() < 0 then
                    self:SetLeft(0)
                elseif self:GetLeft() + self:GetWidth() > Turbine.UI.Display:GetWidth() then
                    self:SetLeft(Turbine.UI.Display:GetWidth()-self:GetWidth())
                end
                if self:GetTop() < 0 then
                    self:SetTop(0)
                elseif self:GetTop() + self:GetHeight() > Turbine.UI.Display:GetHeight() then
                    if (Turbine.UI.Display:GetHeight()-self:GetHeight()) < 0 then
                        self:SetTop(0)
                    else
                        self:SetTop(Turbine.UI.Display:GetHeight()-self:GetHeight())
                    end
                end
            end
        end
    end

    self.TargetSelection.MouseMove = function(sender, args)
        if self.IsDragging then
            self:SetLeft(self:GetLeft() + (args.X - startX))
            self:SetTop(self:GetTop() + (args.Y - startY))
        end
    end
    
    self.TitleBar.MouseClick = function (sender, args)
        if args.Button == Turbine.UI.MouseButton.Right then
            self.IsDragging = false

            -- Set checked states
            FrameMenu:GetItems():Get(4):GetItems():Get(1):SetChecked(self.ShowEffects)
            FrameMenu:GetItems():Get(4):GetItems():Get(2):SetChecked(self.ShowMorale)
            FrameMenu:GetItems():Get(4):GetItems():Get(3):SetChecked(self.ShowPower)
            FrameMenu:GetItems():Get(5):GetItems():Get(1):SetChecked(LockedPosition)
            FrameMenu:GetItems():Get(5):GetItems():Get(2):SetChecked(SaveFramePositions)

            local items = FrameMenu:GetItems():Get(3):GetItems()
            for k = 1, #self.EnabledEffectsToggles do
                items:Get(k):SetChecked(self.EnabledEffectsToggles[k][2])
            end 

            if #TargetFrames == 1 or self.Locked then
                FrameMenu:GetItems():Get(2):SetEnabled(false)
            else
                FrameMenu:GetItems():Get(2):SetEnabled(true)
            end

            FrameMenu.invoker = self
            FrameMenu:ShowMenu()
        end
    end

    self.TitleBar.MouseDown = self.TargetSelection.MouseDown
    self.TitleBar.MouseUp = self.TargetSelection.MouseUp
    self.TitleBar.MouseMove = self.TargetSelection.MouseMove

    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting TargetFrame:Constructor") end
end

-- ------------------------------------------------------------------------
-- Merge any changes to effects to the current list 
-- ------------------------------------------------------------------------
function TargetFrame:ReconcileEffectsLists()

    local newEnabledEffectsToggles = {}
    -- create the list of new toggles with default checked state
    for k = 1, #EffectsSet do
        newEnabledEffectsToggles[k] = {EffectsSet[k][2], true}
    end

    -- go through the existing toggles on a TargetFrame for a match, and update toggle state if found
    for k = 1, #self.EnabledEffectsToggles do
        for kk = 1, #newEnabledEffectsToggles do
            if newEnabledEffectsToggles[kk][1] == self.EnabledEffectsToggles[k][1] then
                newEnabledEffectsToggles[kk][2] = self.EnabledEffectsToggles[k][2]
                break
            end
        end
    end

    self.EnabledEffectsToggles = newEnabledEffectsToggles
end

-- ------------------------------------------------------------------------
-- Clears and sets up all enabled/tracked effects
-- ------------------------------------------------------------------------
function TargetFrame:SetEnabledEffects()
    -- clear current effects
    for k = 1, #self.EnabledEffects do
        self.EnabledEffects[k]:SetVisible(false)
        self.EnabledEffects[k] = nil
    end

    self.EnabledEffects = {}

    if self.ShowEffects then
        -- generate new effects when effects are toggled on
        for k = 1, #EffectsSet do
            if self.EnabledEffectsToggles[k][2] then
                self.EnabledEffects[#self.EnabledEffects + 1] = EffectFrame(self, EffectsSet[k])
            end
        end
    end     
end

-- ------------------------------------------------------------------------
-- Set handlers, morale, power, and effects, when player target changes
-- ------------------------------------------------------------------------
function TargetFrame:UpdateTarget()
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering UpdateTarget") end
    if self.Locked then
        if self.TargetSelection:GetEntity() then
            -- There was a previous locked target, and info/handlers are already setup.  As an active target, fresh updates are 
            --   now available      
            if DEBUG_ENABLED then Turbine.Shell.WriteLine("  No change - locked on target : "..tostring(self.TargetSelection:GetEntity():GetName())) end
        else
            if DEBUG_ENABLED then Turbine.Shell.WriteLine("  No change - locked on NO TARGET") end
        end
    else
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("  Changing target") end

        self:SetWantsUpdates(false)
        self.TitleBar:SetText("No target")
        CurrentTarget = nil

        self.Morale.Title:SetText("")
        self.Morale.Percent:SetText("")
        self.Morale.Bar:SetSize (FrameWidth, ControlHeight)
        self.Morale.Bar:SetPosition(0, self.Morale.Bar:GetTop())

        self.Power.Title:SetText("")
        self.Power.Percent:SetText("")
        self.Power.Bar:SetSize(FrameWidth, ControlHeight)
        self.Power.Bar:SetPosition(0, self.Power.Bar:GetTop())

        if self.Target then
            RemoveCallback(self.Target, "MoraleChanged", MoraleChangedHandler)
            RemoveCallback(self.Target, "BaseMaxMoraleChanged", MoraleChangedHandler)
            RemoveCallback(self.Target, "MaxMoraleChanged", MoraleChangedHandler)
            RemoveCallback(self.Target, "MaxTemporaryMoraleChanged", MoraleChangedHandler)
            RemoveCallback(self.Target, "TemporaryMoraleChanged", MoraleChangedHandler)
            RemoveCallback(self.Target, "PowerChanged", PowerChangedHandler)
            RemoveCallback(self.Target, "BaseMaxPowerChanged", PowerChangedHandler)
            RemoveCallback(self.Target, "MaxPowerChanged", PowerChangedHandler)
            RemoveCallback(self.Target, "MaxTemporaryPowerChanged", PowerChangedHandler)
            RemoveCallback(self.Target, "TemporaryPowerChanged", PowerChangedHandler)
            self.Target = nil
        end

        if DEBUG_ENABLED then Turbine.Shell.WriteLine("CLEARING CURRENT EFFECTS") end
        for k = 1, #self.EnabledEffects do
            self.EnabledEffects[k]:ClearCurrentEffect()
        end

        if self.EffectsList then
            self.EffectsList = nil   
        end

        self.Target = LocalUser:GetTarget()
        self.TargetSelection:SetEntity( self.Target )

        -- ------------------------------------------------------------------------
        -- This one command is currently critical for EntityControl to work as expected.
        -- Deleting or re-ordering this command impacts target locks. 
        -- ------------------------------------------------------------------------
        CurrentTarget = LocalUser:GetTarget()
    
        if self.Target then
            self.TitleBar:SetText(self.TargetSelection:GetEntity():GetName())
    
            if self.Target.GetLevel ~= nil then            
                self.TitleBar:SetText("["..self.Target:GetLevel().."] " ..self.Target:GetName())
                self.Target.self = self
                
                if self.ShowMorale then
                    AddCallback(self.Target, "MoraleChanged", MoraleChangedHandler)
                    AddCallback(self.Target, "BaseMaxMoraleChanged", MoraleChangedHandler)
                    AddCallback(self.Target, "MaxMoraleChanged", MoraleChangedHandler)
                    AddCallback(self.Target, "MaxTemporaryMoraleChanged", MoraleChangedHandler)
                    AddCallback(self.Target, "TemporaryMoraleChanged", MoraleChangedHandler)
                    
                    MoraleChangedHandler(self.Target)
                end

                if self.ShowPower then
                    AddCallback(self.Target, "PowerChanged", PowerChangedHandler)
                    AddCallback(self.Target, "BaseMaxPowerChanged", PowerChangedHandler)
                    AddCallback(self.Target, "MaxPowerChanged", PowerChangedHandler)
                    AddCallback(self.Target, "MaxTemporaryPowerChanged", PowerChangedHandler)
                    AddCallback(self.Target, "TemporaryPowerChanged", PowerChangedHandler)
    
                    PowerChangedHandler(self.Target)
                end

                if self.ShowEffects and #self.EnabledEffectsToggles then
                    self.EffectsList = self.Target:GetEffects()
                    self.EffectsList.self = self
    
                    -- Set last callback well in the past, so that the first handler update fires
                    self.LastCallback = Turbine.Engine.GetGameTime() - 10 
                end
                self:SetWantsUpdates(true)

            else
                if DEBUG_ENABLED then Turbine.Shell.WriteLine("  Changing on target - no level found") end
                self.TitleBar:SetText(self.Target:GetName())                    
            end
        else
            if DEBUG_ENABLED then Turbine.Shell.WriteLine("NO TARGET") end              
        end
    end

    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting UpdateTarget") end
end

-- ------------------------------------------------------------------------
-- Update enabled effects, after an Effect handler triggers, cross-checking lists of effects
-- ------------------------------------------------------------------------
function TargetFrame:Update()
    self.effectsCounter = self.effectsCounter + 1 
    
    -- This gets the effect list from the target and checks list against tracked effects.
    if self.effectsCounter % EffectsModulus == 0 then
        self.effectsCounter = 0
        self:UpdateFrame()
    end

    -- This updates timers and possible effect removals.
    local trackedEffects = self.EnabledEffects
    for x = 1, #trackedEffects do
        trackedEffects[x]:Update()
    end
    
end

function TargetFrame:UpdateFrame()

    -- update a frame only when there is at least one enabled effect and a target 
    if self.Target and self.EffectsList and #self.EffectsList then
        local trackedEffects = self.EnabledEffects
        local targetEffects = self.EffectsList

        for k = 1, #trackedEffects do
            for kk = 1, targetEffects:GetCount() do
                local matchPattern = {}
                if trackedEffects[k].patternMatch == nil then
                    matchPattern = trackedEffects[k].effectName
                else
                    matchPattern = trackedEffects[k].patternMatch
                end                

                if type (matchPattern) == "string" then                  
                    if string.find (targetEffects:Get(kk):GetName(), matchPattern) then
                        trackedEffects[k]:SetCurrentEffect(targetEffects:Get(kk))
                        trackedEffects[k].lastSeen = Turbine.Engine.GetGameTime()
                        break
                    end
                else
                    local found = false
                    for x = 1, #matchPattern do
                        if string.find (self.EffectsList:Get(kk):GetName(), matchPattern[x]) then
                            trackedEffects[k]:SetCurrentEffect(targetEffects:Get(kk))
                            trackedEffects[k].lastSeen = Turbine.Engine.GetGameTime()
                            found = true
                            break
                        end                   
                    end
                    if found then
                        break
                    end
                end
            end
            -- While going through the list, clear any toggle or expire-on-damage effects that have likely expired.
            -- This should happen only on the focused target, and not affect targets without focus.
            if self.Target == CurrentTarget then
                if trackedEffects[k].timedType > 0 and trackedEffects[k].lastSeen then
                    if (Turbine.Engine.GetGameTime() - trackedEffects[k].lastSeen) > 5 then       
                        trackedEffects[k]:ClearCurrentEffect()
                    end
                end
            end    
        end
        
        local number = nil
        local count = 0
        for i = 1, targetEffects:GetCount() do
            if targetEffects:Get(i):GetCategory() == Turbine.Gameplay.EffectCategory.Corruption then
                number = string.match(targetEffects:Get(i):GetName(), "%d+")
                count = count + 1
                self.lastCorruptionSeen = Turbine.Engine.GetGameTime() 
            end
        end

        if number then           
            self.TitleBar:SetText(tostring(number).." ["..self.Target:GetLevel().."] " ..self.Target:GetName())
        elseif count > 0 then
            self.TitleBar:SetText(tostring(count).." ["..self.Target:GetLevel().."] " ..self.Target:GetName())
        else
            if (Turbine.Engine.GetGameTime() - self.lastCorruptionSeen) > 1 then
                self.TitleBar:SetText("["..self.Target:GetLevel().."] " ..self.Target:GetName())
                self.lastCorruptionSeen = 0
            end
        end       
    end
end

-- ------------------------------------------------------------------------
--  Set size/visibility of all controls
-- ------------------------------------------------------------------------
function TargetFrame:Resize()

    -- namebar
    self.TitleBar:SetSize(FrameWidth - ControlHeight, ControlHeight)

    self.LockBackground:SetSize(ControlHeight, ControlHeight)
    self.LockBackground:SetPosition (FrameWidth - ControlHeight,0)

    self.Lock:SetSize(ControlHeight, ControlHeight)
    self.Lock:SetPosition (FrameWidth - ControlHeight,0)

    -- morale/power
    local MoralePowerHeight = 0
    if self.ShowMorale then
        local moralePosition = self.TitleBar:GetHeight()
        self.Morale.Bar:SetSize (FrameWidth, ControlHeight)
        self.Morale.Bar:SetPosition (0, moralePosition)
        self.Morale.Percent:SetSize(45, ControlHeight)
        self.Morale.Percent:SetPosition (0, moralePosition)
        self.Morale.Title:SetSize(FrameWidth - 45, ControlHeight)
        self.Morale.Title:SetPosition (45, moralePosition)

        MoralePowerHeight = MoralePowerHeight + ControlHeight
    end
    self.Morale.Bar:SetVisible(self.ShowMorale)
    self.Morale.Percent:SetVisible(self.ShowMorale)
    self.Morale.Title:SetVisible(self.ShowMorale)

    if self.ShowPower then
        local powerPosition = self.TitleBar:GetHeight() + MoralePowerHeight
        self.Power.Bar:SetSize(FrameWidth, ControlHeight)
        self.Power.Bar:SetPosition (0, powerPosition)
        self.Power.Percent:SetSize(45, ControlHeight)    
        self.Power.Percent:SetPosition (0, powerPosition)
        self.Power.Title:SetPosition (45, powerPosition)
        self.Power.Title:SetSize(FrameWidth - 45, ControlHeight)
        
        MoralePowerHeight = MoralePowerHeight + ControlHeight
    end
    self.Power.Bar:SetVisible(self.ShowPower)
    self.Power.Percent:SetVisible(self.ShowPower)
    self.Power.Title:SetVisible(self.ShowPower)

    for k = 1, #self.EnabledEffects do
        self.EnabledEffects[k]:SetPosition (0, self.TitleBar:GetHeight() + MoralePowerHeight + (k - 1) * ControlHeight)
    end

    -- title bar, morale bar, power bar + all effects
    local frameSize = self.TitleBar:GetHeight() + MoralePowerHeight + #self.EnabledEffects * ControlHeight
    
    self:SetSize(FrameWidth, frameSize)
    self.TargetSelection:SetPosition(0,ControlHeight)
    self.TargetSelection:SetSize(FrameWidth, frameSize)
    
    self:UpdateTarget()
end
