-- ------------------------------------------------------------------------
-- Target Box
-- ------------------------------------------------------------------------

TargetBox = {}

TargetBox.new = function(num) 
    local self = setmetatable({}, TargetBox)

    Turbine.Shell.WriteLine("Creating TargetBox")

    self.ID = num
    self.Target = nil
    self.Morale = {}
    self.Power = {}
    self.EffectsBar = {}
    self.Effects = nil

    -- ------------------------------------------------------------------------
    -- TargetFrame
    -- ------------------------------------------------------------------------
    self.TargetFrame = Turbine.UI.Window()
    self.TargetFrame:SetSize(200,100)
    self.TargetFrame:SetVisible(true) 
    self.TargetFrame:SetMouseVisible ("false")
--    self.TargetFrame:SetBackColor(Turbine.UI.Color.White)
    self.TargetFrame:SetPosition(Turbine.UI.Display:GetWidth()/5 + (Count % 20) * 40, Turbine.UI.Display:GetHeight()/5 + (Count % 20) * 40)

    -- ------------------------------------------------------------------------
    -- Target Title Bar
    -- ------------------------------------------------------------------------ 
    self.TitleBar = Turbine.UI.Label()
    self.TitleBar:SetVisible(true)
    self.TitleBar:SetParent (self.TargetFrame)
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
    self.TargetSelection:SetParent (self.TargetFrame)
    self.TargetSelection:SetSize(200,60)
    self.TargetSelection:SetPosition (0, 20)
    self.TargetSelection:SetZOrder (100)
    
    -- ------------------------------------------------------------------------
    -- Lock Control
    -- ------------------------------------------------------------------------
    self.LockBackground = Turbine.UI.Control()
    self.LockBackground:SetParent (self.TargetFrame)
    self.LockBackground:SetBackColor ( Turbine.UI.Color.Black )
    self.LockBackground:SetSize(20, 20)
    self.LockBackground:SetPosition (180,0)
    
    self.Locked = false
    self.Lock = Turbine.UI.Control()
    self.Lock:SetParent (self.TargetFrame)
    self.Lock:SetBackground( 0x410001D3 )

    self.Lock:SetSize(20, 20)
    self.Lock:SetPosition (180,0)
    self.Lock:SetBlendMode(Turbine.UI.BlendMode.Overlay)

    self.Lock.MouseClick = function ()
        Turbine.Shell.WriteLine("Lock for ID "..tostring(self.ID).." was "..tostring(self.Locked))
        self.Locked = not self.Locked
        if self.Locked then
            self.Lock:SetBackground( 0x410001D1 )
        else
            self.Lock:SetBackground( 0x410001D3 )
            TargetChangeHandler()
        end
        Turbine.Shell.WriteLine("Lock for ID "..tostring(self.ID).." is "..tostring(self.Locked)) 
    end
    

    -- ------------------------------------------------------------------------
    -- Morale 
    -- ------------------------------------------------------------------------
    self.Morale.Bar = Turbine.UI.Control()
    self.Morale.Bar:SetParent (self.TargetFrame)
    self.Morale.Bar:SetBackColor ( Turbine.UI.Color.ForestGreen )
    self.Morale.Bar:SetSize (200, 20)
    self.Morale.Bar:SetPosition (0,21)
    self.Morale.Bar:SetMouseVisible (false)

    self.Morale.Title = Turbine.UI.Label()
    self.Morale.Title:SetParent (self.TargetFrame)
    self.Morale.Title:SetPosition (45,21)
    self.Morale.Title:SetSize(155, 20)
    self.Morale.Title:SetMouseVisible (false)
    self.Morale.Title:SetText ("")
    self.Morale.Title:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight)
    self.Morale.Title:SetFont( Turbine.UI.Lotro.Font.Verdana12 )

    self.Morale.Percent = Turbine.UI.Label()
    self.Morale.Percent:SetParent (self.TargetFrame)
    self.Morale.Percent:SetPosition (0,21)
    self.Morale.Percent:SetSize(45, 20)
    self.Morale.Percent:SetMouseVisible (false)
    self.Morale.Percent:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft)
    self.Morale.Percent:SetFont( Turbine.UI.Lotro.Font.Verdana12 )    

    -- ------------------------------------------------------------------------
    -- Power
    -- ------------------------------------------------------------------------
    self.Power.Bar = Turbine.UI.Control()
    self.Power.Bar:SetParent (self.TargetFrame)
    self.Power.Bar:SetBackColor ( Turbine.UI.Color.RoyalBlue )
    self.Power.Bar:SetSize(200, 20)
    self.Power.Bar:SetPosition (0,42)
    self.Power.Bar:SetMouseVisible (false)

    self.Power.Title = Turbine.UI.Label()
    self.Power.Title:SetParent (self.TargetFrame)
    self.Power.Title:SetPosition (45,42)
    self.Power.Title:SetSize(155, 20)
    self.Power.Title:SetMouseVisible (false)
    self.Power.Title:SetText ("")
    self.Power.Title:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight)
    self.Power.Title:SetFont( Turbine.UI.Lotro.Font.Verdana12 )

    self.Power.Percent = Turbine.UI.Label()
    self.Power.Percent:SetParent (self.TargetFrame)
    self.Power.Percent:SetPosition (0,42)
    self.Power.Percent:SetSize(45, 20)
    self.Power.Percent:SetMouseVisible (false)
    self.Power.Percent:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft)
    self.Power.Percent:SetFont( Turbine.UI.Lotro.Font.Verdana12 )    
  
    -- ------------------------------------------------------------------------
    -- Effect Display
    -- ------------------------------------------------------------------------

    self.EffectsBar.FireLore = Turbine.UI.Lotro.EffectDisplay()
    self.EffectsBar.FireLore:SetParent (self.TargetFrame)
--    self.EffectsBar.FireLore:SetSize(200, 20)
    self.EffectsBar.FireLore:SetSize(20, 20)
    self.EffectsBar.FireLore:SetPosition (0,60)
    self.EffectsBar.FireLore:SetMouseVisible (false)

    self.EffectsBar.FrostLore = Turbine.UI.Lotro.EffectDisplay()
    self.EffectsBar.FrostLore:SetParent (self.TargetFrame)
--    self.EffectsBar.FrostLore:SetSize(200, 20)
    self.EffectsBar.FrostLore:SetSize(20, 20)
    self.EffectsBar.FrostLore:SetPosition (0,80)
    self.EffectsBar.FrostLore:SetMouseVisible (false)

    -- Hide with interface
    self.TargetFrame:SetWantsKeyEvents( true )
    function self.TargetFrame:KeyDown( args )
        a = args.Action
        if ( a == 268435635 ) then
            self.TargetFrame:SetVisible( not self.TargetFrame:IsVisible() )
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
                
                self.TargetFrame:SetLeft(self.TargetFrame:GetLeft() + (args.X - startX))
                self.TargetFrame:SetTop(self.TargetFrame:GetTop() + (args.Y - startY))
    
                if self.TargetFrame:GetLeft() < 0 then
                    self.TargetFrame:SetLeft(0)
                elseif self.TargetFrame:GetLeft() + self.TargetFrame:GetWidth() > Turbine.UI.Display:GetWidth() then
                    self.TargetFrame:SetLeft(Turbine.UI.Display:GetWidth()-self.TargetFrame:GetWidth())
                end
                if self.TargetFrame:GetTop() < 0 then
                    self.TargetFrame:SetTop(0)
                elseif self.TargetFrame:GetTop() + self.TargetFrame:GetHeight() > Turbine.UI.Display:GetHeight() then
                    self.TargetFrame:SetTop(Turbine.UI.Display:GetHeight()-self.TargetFrame:GetHeight())
                end
            end
        end
    end

    self.TargetSelection.MouseMove = function(sender, args)
        if self.IsDragging then
            self.TargetFrame:SetLeft(self.TargetFrame:GetLeft() + (args.X - startX))
            self.TargetFrame:SetTop(self.TargetFrame:GetTop() + (args.Y - startY))
        end
    end
    
    self.TitleBar.MouseClick = function (sender, args)
        if args.Button == Turbine.UI.MouseButton.Right then
            self.IsDragging = false
            Turbine.Shell.WriteLine("Showing menu")
        
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
            Turbine.Shell.WriteLine("Closing menu")
        end
    end
    
    self.TitleBar.MouseMove = self.TargetSelection.MouseMove

    return self

end

function TargetBox:DestroyFrame()
    self.TargetFrame:SetVisible(false)
    self.TargetFrame = nil
end

function TargetBox:UpdateTarget()
    Turbine.Shell.WriteLine("Entering UpdateTarget")
    if self.Locked then
        if self.TargetSelection:GetEntity() then
            Turbine.Shell.WriteLine("  No change - lock on target : "..tostring(self.TargetSelection:GetEntity()))
            Turbine.Shell.WriteLine("  No change - lock on target : "..tostring(self.TargetSelection:GetEntity():GetName()))           
        else
            Turbine.Shell.WriteLine("  No change - locked on NO TARGET")
        end
    else
        Turbine.Shell.WriteLine("  Changing target")

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
            RemoveCallback(self.Target, "MoraleChanged", MoraleChangedHandler);
            RemoveCallback(self.Target, "BaseMaxMoraleChanged", MoraleChangedHandler);
            RemoveCallback(self.Target, "MaxMoraleChanged", MoraleChangedHandler);
            RemoveCallback(self.Target, "MaxTemporaryMoraleChanged", MoraleChangedHandler);
            RemoveCallback(self.Target, "TemporaryMoraleChanged", MoraleChangedHandler);
            RemoveCallback(self.Target, "PowerChanged", PowerChangedHandler);
            RemoveCallback(self.Target, "BaseMaxPowerChanged", PowerChangedHandler);
            RemoveCallback(self.Target, "MaxPowerChanged", PowerChangedHandler);
            RemoveCallback(self.Target, "MaxTemporaryPowerChanged", PowerChangedHandler);
            RemoveCallback(self.Target, "TemporaryPowerChanged", PowerChangedHandler);   
        end

        if self.Effects then
            RemoveCallback(self.Effects, "EffectAdded", EffectsChangedHandler);
            RemoveCallback(self.Effects, "EffectRemoved", EffectsChangedHandler);
            RemoveCallback(self.Effects, "EffectsCleared", EffectsChangedHandler);   
        end
        
        self.Target = nil
        self.Effects = nil
        self.Target = LocalUser:GetTarget()
        self.TargetSelection:SetEntity( self.Target )

        local ThrowAwayGetTargetCall = LocalUser:GetTarget()
    
        if self.Target then
            Turbine.Shell.WriteLine("  New target : "..tostring(self.TargetSelection:GetEntity()))
            Turbine.Shell.WriteLine("  New target's name : "..tostring(self.TargetSelection:GetEntity():GetName()))
            self.TitleBar:SetText(self.TargetSelection:GetEntity():GetName())
    
            if self.Target.GetLevel ~= nil then
                self.Effects = self.Target:GetEffects()            
                
                Turbine.Shell.WriteLine("  Changing on target - got level")
                self.TitleBar:SetText("["..self.Target:GetLevel().."] " ..self.Target:GetName())
                self.Target.self = self
                self.Effects.self = self
                
                AddCallback(self.Target, "MoraleChanged", MoraleChangedHandler);
                AddCallback(self.Target, "BaseMaxMoraleChanged", MoraleChangedHandler);
                AddCallback(self.Target, "MaxMoraleChanged", MoraleChangedHandler);
                AddCallback(self.Target, "MaxTemporaryMoraleChanged", MoraleChangedHandler);
                AddCallback(self.Target, "TemporaryMoraleChanged", MoraleChangedHandler);
                
                MoraleChangedHandler(self.Target)

                AddCallback(self.Target, "PowerChanged", PowerChangedHandler);
                AddCallback(self.Target, "BaseMaxPowerChanged", PowerChangedHandler);
                AddCallback(self.Target, "MaxPowerChanged", PowerChangedHandler);
                AddCallback(self.Target, "MaxTemporaryPowerChanged", PowerChangedHandler);
                AddCallback(self.Target, "TemporaryPowerChanged", PowerChangedHandler);

                PowerChangedHandler(self.Target)

                AddCallback(self.Effects, "EffectAdded", EffectsChangedHandler);
                AddCallback(self.Effects, "EffectRemoved", EffectsChangedHandler);
                AddCallback(self.Effects, "EffectsCleared", EffectsChangedHandler);               

                EffectsChangedHandler(self.Effects)
            else
                Turbine.Shell.WriteLine("  Changing on target - not got level")
                self.TitleBar:SetText(self.Target:GetName())
            end
        end
    end

    Turbine.Shell.WriteLine("Exiting UpdateTarget")
end

function TargetBox:DumpData()
    Turbine.Shell.WriteLine(">>>>>Data dump  ID : "..tostring(self.ID))
    Turbine.Shell.WriteLine(">>>>>    EntityControl : "..tostring(self.TargetSelection))
     if self.TargetSelection:GetEntity() ~=nil then
        Turbine.Shell.WriteLine(">>>>>    Entity      : "..tostring(self.TargetSelection:GetEntity()))
        Turbine.Shell.WriteLine(">>>>>    Entity Name : "..tostring(self.TargetSelection:GetEntity():GetName()))
    else
        Turbine.Shell.WriteLine(">>>>>    NO TARGET")
    end        
end

function TargetBox:GetID()
    return self.ID
end

function TargetBox:IsLocked()
    return self.Locked
end

