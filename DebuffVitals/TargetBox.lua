-- ------------------------------------------------------------------------
-- Target Box
-- ------------------------------------------------------------------------

TargetBox = class (Turbine.UI.Window)

-- ------------------------------------------------------------------------
-- TargetBox
-- ------------------------------------------------------------------------
function TargetBox:Constructor(num) 
    Turbine.UI.Window.Constructor(self)

    DebugWriteLine("Creating TargetBox")

    self.ID = num
    self.Target = nil
    self.Morale = {}
    self.Power = {}

    self:SetSize(200,146)
    self:SetVisible(true) 
    self:SetMouseVisible (false)
    self:SetPosition(Turbine.UI.Display:GetWidth()/5 + (Count % 20) * 40, Turbine.UI.Display:GetHeight()/5 + (Count % 20) * 40)
    self:SetZOrder (0)

    -- ------------------------------------------------------------------------
    -- Target Title Bar
    -- ------------------------------------------------------------------------ 
    self.TitleBar = Turbine.UI.Label()
    self.TitleBar:SetVisible(true)
    self.TitleBar:SetParent (self)
    self.TitleBar:SetSize(180,20)
    self.TitleBar:SetPosition (0,0)
    self.TitleBar:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
    self.TitleBar:SetFont( Turbine.UI.Lotro.Font.Verdana14 )
    self.TitleBar:SetBackColor( Turbine.UI.Color.Black )
    self.TitleBar:SetMultiline( false )  
  
    -- ------------------------------------------------------------------------
    -- Target Selection
    -- ------------------------------------------------------------------------
    self.TargetSelection = Turbine.UI.Lotro.EntityControl()
    self.TargetSelection:SetVisible(true)
    self.TargetSelection:SetParent (self)
    self.TargetSelection:SetSize(200,146)
    self.TargetSelection:SetPosition (0, 20)
    self.TargetSelection:SetZOrder (100)
    
    -- ------------------------------------------------------------------------
    -- Lock Control
    -- ------------------------------------------------------------------------
    self.LockBackground = Turbine.UI.Control()
    self.LockBackground:SetParent (self)
    self.LockBackground:SetBackColor ( Turbine.UI.Color.Black )
    self.LockBackground:SetSize(20, 20)
    self.LockBackground:SetPosition (180,0)
    
    self.Locked = false
    self.Lock = Turbine.UI.Control()
    self.Lock:SetParent (self)
    self.Lock:SetBackground( 0x410001D3 )

    self.Lock:SetSize(20, 20)
    self.Lock:SetPosition (180,0)
    self.Lock:SetBlendMode(Turbine.UI.BlendMode.Overlay)

    self.Lock.MouseClick = function ()
        DebugWriteLine("Lock for ID "..tostring(self.ID).." was "..tostring(self.Locked))
        self.Locked = not self.Locked
        if self.Locked then
            self.Lock:SetBackground( 0x410001D1 )
        else
            self.Lock:SetBackground( 0x410001D3 )
            TargetChangeHandler()
        end
        DebugWriteLine("Lock for ID "..tostring(self.ID).." is "..tostring(self.Locked)) 
    end

    -- ------------------------------------------------------------------------
    -- Morale 
    -- ------------------------------------------------------------------------
    self.Morale.Bar = Turbine.UI.Control()
    self.Morale.Bar:SetParent (self)
    self.Morale.Bar:SetBackColor ( Turbine.UI.Color.ForestGreen )
    self.Morale.Bar:SetSize (200, 20)
    self.Morale.Bar:SetPosition (0,21)
    self.Morale.Bar:SetMouseVisible (false)

    self.Morale.Title = Turbine.UI.Label()
    self.Morale.Title:SetParent (self)
    self.Morale.Title:SetPosition (45,21)
    self.Morale.Title:SetSize(155, 20)
    self.Morale.Title:SetMouseVisible (false)
    self.Morale.Title:SetText ("")
    self.Morale.Title:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight)
    self.Morale.Title:SetFont( Turbine.UI.Lotro.Font.Verdana12 )

    self.Morale.Percent = Turbine.UI.Label()
    self.Morale.Percent:SetParent (self)
    self.Morale.Percent:SetPosition (0,21)
    self.Morale.Percent:SetSize(45, 20)
    self.Morale.Percent:SetMouseVisible (false)
    self.Morale.Percent:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft)
    self.Morale.Percent:SetFont( Turbine.UI.Lotro.Font.Verdana12 )    

    -- ------------------------------------------------------------------------
    -- Power
    -- ------------------------------------------------------------------------
    self.Power.Bar = Turbine.UI.Control()
    self.Power.Bar:SetParent (self)
    self.Power.Bar:SetBackColor ( Turbine.UI.Color.RoyalBlue )
    self.Power.Bar:SetSize(200, 20)
    self.Power.Bar:SetPosition (0,42)
    self.Power.Bar:SetMouseVisible (false)

    self.Power.Title = Turbine.UI.Label()
    self.Power.Title:SetParent (self)
    self.Power.Title:SetPosition (45,42)
    self.Power.Title:SetSize(155, 20)
    self.Power.Title:SetMouseVisible (false)
    self.Power.Title:SetText ("")
    self.Power.Title:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight)
    self.Power.Title:SetFont( Turbine.UI.Lotro.Font.Verdana12 )

    self.Power.Percent = Turbine.UI.Label()
    self.Power.Percent:SetParent (self)
    self.Power.Percent:SetPosition (0,42)
    self.Power.Percent:SetSize(45, 20)
    self.Power.Percent:SetMouseVisible (false)
    self.Power.Percent:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft)
    self.Power.Percent:SetFont( Turbine.UI.Lotro.Font.Verdana12 )    
  
    -- ------------------------------------------------------------------------
    -- Effect Display
    -- ------------------------------------------------------------------------
    self.EffectList = nil
    self.SingleEffects = {}
    self.SingleEffects.FireLore = EffectFrame(self, "Fire-lore")
    self.SingleEffects.FireLore:SetPosition (0,63)

    self.SingleEffects.FrostLore = EffectFrame(self, "Frost-lore")
    self.SingleEffects.FrostLore:SetPosition (0,84)
    
    self.SingleEffects.RevealingMark = EffectFrame(self, "Revealing Mark")
    self.SingleEffects.RevealingMark:SetPosition (0,105)

    self.SingleEffects.TellingMark = EffectFrame(self, "Telling Mark")
    self.SingleEffects.TellingMark:SetPosition (0,126)
    
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
        if args.Button == Turbine.UI.MouseButton.Left then
            startX = args.X
            startY = args.Y
            self.IsDragging = true
        end
    end

    self.TargetSelection.MouseUp = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Left then
            if ( self.IsDragging ) then
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
                    self:SetTop(Turbine.UI.Display:GetHeight()-self:GetHeight())
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
            DebugWriteLine("Showing menu")
        
            if CountTargets() == 1 then
                MenuItems:GetItems():Get(3):SetEnabled(false)
--                MenuItems:GetItems():Get(4):SetEnabled(false)
            else
                MenuItems:GetItems():Get(3):SetEnabled(true)
--                MenuItems:GetItems():Get(4):SetEnabled(true)
            end
            MenuItems.invokerID = self.ID
            MenuItems:ShowMenu()
        end
    end

    self.TitleBar.MouseDown = self.TargetSelection.MouseDown

    self.TitleBar.MouseUp = function(sender, args)
        self.IsDragging = false
        if args.Button == Turbine.UI.MouseButton.Right then
            DebugWriteLine("Closing menu")
        end
    end
    
    self.TitleBar.MouseMove = self.TargetSelection.MouseMove

end

function TargetBox:DestroyFrame()
    self:SetVisible(false)
    self= nil
end

function TargetBox:UpdateTarget()
    DebugWriteLine("Entering UpdateTarget")
    if self.Locked then
        if self.TargetSelection:GetEntity() then
            DebugWriteLine("  No change - locked on target : "..tostring(self.TargetSelection:GetEntity():GetName()))
            self:SetWantsUpdates(true)
        else
            DebugWriteLine("  No change - locked on NO TARGET")
        end
    else
        DebugWriteLine("  Changing target")

        self.TitleBar:SetText("No target")
        self.Morale.Title:SetText("")
        self.Morale.Percent:SetText("")
        self.Power.Title:SetText("")
        self.Power.Percent:SetText("")
        self.Morale.Bar:SetSize (200, 20)
        self.Morale.Bar:SetPosition (0,21)
        self.Power.Bar:SetSize(200, 20)
        self.Power.Bar:SetPosition (0,42)
        
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
                  
        self.SingleEffects.FireLore:ClearCurrentEffect()
        self.SingleEffects.FrostLore:ClearCurrentEffect()
        self.SingleEffects.RevealingMark:ClearCurrentEffect()
        self.SingleEffects.TellingMark:ClearCurrentEffect()

        if self.EffectList then
            RemoveCallback(self.EffectList, "EffectAdded", EffectsChangedHandler)
            RemoveCallback(self.EffectList, "EffectRemoved", EffectsChangedHandler)
            RemoveCallback(self.EffectList, "EffectsCleared", EffectsChangedHandler)
            self.EffectList = nil   
        end

        self.Target = LocalUser:GetTarget()
        self.TargetSelection:SetEntity( self.Target )

        -- ------------------------------------------------------------------------
        -- This one command is currently critical for EntityControl to work as expected.
        -- Deleting or re-ordering this command impacts target locks. 
        -- ------------------------------------------------------------------------
        local ThrowAwayGetTargetCall = LocalUser:GetTarget()
    
        if self.Target then
            DebugWriteLine("  New target's name : "..tostring(self.Target:GetName()))
            self.TitleBar:SetText(self.TargetSelection:GetEntity():GetName())
    
            if self.Target.GetLevel ~= nil then            
                DebugWriteLine("  New target - got level")
                self.TitleBar:SetText("["..self.Target:GetLevel().."] " ..self.Target:GetName())
                self.Target.self = self
               
                AddCallback(self.Target, "MoraleChanged", MoraleChangedHandler)
                AddCallback(self.Target, "BaseMaxMoraleChanged", MoraleChangedHandler)
                AddCallback(self.Target, "MaxMoraleChanged", MoraleChangedHandler)
                AddCallback(self.Target, "MaxTemporaryMoraleChanged", MoraleChangedHandler)
                AddCallback(self.Target, "TemporaryMoraleChanged", MoraleChangedHandler)
                
                MoraleChangedHandler(self.Target)

                AddCallback(self.Target, "PowerChanged", PowerChangedHandler)
                AddCallback(self.Target, "BaseMaxPowerChanged", PowerChangedHandler)
                AddCallback(self.Target, "MaxPowerChanged", PowerChangedHandler)
                AddCallback(self.Target, "MaxTemporaryPowerChanged", PowerChangedHandler)
                AddCallback(self.Target, "TemporaryPowerChanged", PowerChangedHandler)

                PowerChangedHandler(self.Target)

                self.EffectList = self.Target:GetEffects()
                self.EffectList.self = self
              
                AddCallback(self.EffectList, "EffectAdded", EffectsChangedHandler)
                AddCallback(self.EffectList, "EffectRemoved", EffectsChangedHandler)
                AddCallback(self.EffectList, "EffectsCleared", EffectsChangedHandler)

                EffectsChangedHandler(self.Target)

                -- Effects updated during :Update()
                self:SetWantsUpdates(true)
            else
                DebugWriteLine("  Changing on target - no level found")
                self.TitleBar:SetText(self.Target:GetName())
                self:SetWantsUpdates(false)                    
            end
        else
            DebugWriteLine("NO TARGET")        
            self:SetWantsUpdates(false)        
        end

    end

    DebugWriteLine("Exiting UpdateTarget")
end

function TargetBox:Update()
    DebugWriteLine(">>>>>>>>>>Entering TargetBox:Update")

    if self.Target then
        DebugWriteLine("Target name "..tostring(self.Target:GetName()))
        DebugWriteLine("Effect count "..tostring(self.EffectList:GetCount()))

        for i = 1, self.EffectList:GetCount() do
            DebugWriteLine("Effect name "..tostring(self.EffectList:Get(i):GetName()))        
            if self.EffectList:Get(i):GetName() == "Fire-lore" then
                DebugWriteLine(">>>>>Fire-lore<<<<<")
                self.SingleEffects.FireLore:SetCurrentEffect(self.EffectList:Get(i))    
                self.SingleEffects.FireLore.lastSeen = Turbine.Engine.GetGameTime()             
            elseif self.EffectList:Get(i):GetName() == "Frost-lore" then
                DebugWriteLine(">>>>>Frost-lore<<<<<")
                self.SingleEffects.FrostLore:SetCurrentEffect(self.EffectList:Get(i))
                self.SingleEffects.FrostLore.lastSeen = Turbine.Engine.GetGameTime()      
            elseif self.EffectList:Get(i):GetName() == "Revealing Mark" then
                DebugWriteLine(">>>>>Revealing Mark<<<<<")
                self.SingleEffects.RevealingMark:SetCurrentEffect(self.EffectList:Get(i))
                self.SingleEffects.RevealingMark.lastSeen = Turbine.Engine.GetGameTime()      
            elseif self.EffectList:Get(i):GetName() == "Telling Mark" then
                DebugWriteLine(">>>>>Telling Mark<<<<<")
                self.SingleEffects.TellingMark:SetCurrentEffect(self.EffectList:Get(i))
                self.SingleEffects.TellingMark.lastSeen = Turbine.Engine.GetGameTime() 
            end
        end       
    end

    if (self.SingleEffects.RevealingMark.lastSeen > 0) and (Turbine.Engine.GetGameTime() - self.SingleEffects.RevealingMark.lastSeen) > 5 then
        DebugWriteLine(">>>>>Revealing Mark was not seen for last  "..tostring(Turbine.Engine.GetGameTime() - self.SingleEffects.RevealingMark.lastSeen).." seconds ago.")
        self.SingleEffects.RevealingMark:ClearCurrentEffect()
    end
    
    if (self.SingleEffects.TellingMark.lastSeen > 0) and (Turbine.Engine.GetGameTime() - self.SingleEffects.TellingMark.lastSeen) > 5 then
        DebugWriteLine(">>>>>Telling Mark was not seen for last  "..tostring(Turbine.Engine.GetGameTime() - self.SingleEffects.TellingMark.lastSeen).." seconds ago.")
        self.SingleEffects.TellingMark:ClearCurrentEffect()  
    end            
    
    self:SetWantsUpdates(false)
    DebugWriteLine(">>>>>>>>>>Exiting TargetBox:Update")    
end

function TargetBox:DumpData()
    DebugWriteLine(">>>>>Data dump  ID : "..tostring(self.ID))
    DebugWriteLine(">>>>>    EntityControl : "..tostring(self.TargetSelection))
     if self.TargetSelection:GetEntity() ~=nil then
        DebugWriteLine(">>>>>    Entity      : "..tostring(self.TargetSelection:GetEntity()))
        DebugWriteLine(">>>>>    Entity Name : "..tostring(self.TargetSelection:GetEntity():GetName()))
    else
        DebugWriteLine(">>>>>    No target")
    end        
end

function TargetBox:GetID()
    return self.ID
end

function TargetBox:IsLocked()
    return self.Locked
end

function TargetBox:DumpEffect(effect)
    DebugWriteLine(">>>>"..tostring(effect:GetName()).."  "..tostring(effect.."<<<<"))       
    DebugWriteLine(">>>>>>"..tostring(effect:GetID()))
    DebugWriteLine(">>>>>>"..tostring(effect:IsDebuff()))
    DebugWriteLine(">>>>>>"..tostring(effect:GetName()))
    DebugWriteLine(">>>>>>"..tostring(effect:IsCurable()))
    DebugWriteLine(">>>>>>"..tostring(effect:GetStartTime()))
    DebugWriteLine(">>>>>>"..tostring(effect:GetDuration()))
    DebugWriteLine(">>>>>>"..tostring(effect:GetDescription()))
    DebugWriteLine(">>>>>>"..tostring(string.format("%x",effect:GetIcon())))
    DebugWriteLine(">>>>>>"..tostring(effect:GetCategory()))
end