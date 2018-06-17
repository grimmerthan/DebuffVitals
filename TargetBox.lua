-- ------------------------------------------------------------------------
-- Target Box
-- ------------------------------------------------------------------------

TargetBox = {}

TargetBox.new = function(num) 
    local self = setmetatable({}, TargetBox)

    Turbine.Shell.WriteLine("Creating TargetBox")

    self.ID = num
    self.CurrentTarget = {}
    self.CurrentTarget.Effects = {}
    self.Morale = {}
    self.Power = {}
    self.Effects = {}

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
    self.Morale.Bar:SetPosition (0,20)
    self.Morale.Bar:SetMouseVisible (false)

    self.Morale.Title = Turbine.UI.Label()
    self.Morale.Title:SetParent (self.TargetFrame)
    self.Morale.Title:SetPosition (45,20)
    self.Morale.Title:SetSize(155, 20)
    self.Morale.Title:SetMouseVisible (false)
    self.Morale.Title:SetText ("")
    self.Morale.Title:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight)
    self.Morale.Title:SetFont( Turbine.UI.Lotro.Font.Verdana12 )

    self.Morale.Percent = Turbine.UI.Label()
    self.Morale.Percent:SetParent (self.TargetFrame)
    self.Morale.Percent:SetPosition (0,20)
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
    self.Power.Bar:SetPosition (0,40)
    self.Power.Bar:SetMouseVisible (false)

    self.Power.Title = Turbine.UI.Label()
    self.Power.Title:SetParent (self.TargetFrame)
    self.Power.Title:SetPosition (45,40)
    self.Power.Title:SetSize(155, 20)
    self.Power.Title:SetMouseVisible (false)
    self.Power.Title:SetText ("")
    self.Power.Title:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight)
    self.Power.Title:SetFont( Turbine.UI.Lotro.Font.Verdana12 )

    self.Power.Percent = Turbine.UI.Label()
    self.Power.Percent:SetParent (self.TargetFrame)
    self.Power.Percent:SetPosition (0,40)
    self.Power.Percent:SetSize(45, 20)
    self.Power.Percent:SetMouseVisible (false)
    self.Power.Percent:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft)
    self.Power.Percent:SetFont( Turbine.UI.Lotro.Font.Verdana12 )    
  
    -- ------------------------------------------------------------------------
    -- Effect Display
    -- ------------------------------------------------------------------------
    self.Effects.FireLore = Turbine.UI.Lotro.EffectDisplay()
    self.Effects.FireLore:SetParent (self.TargetFrame)
    self.Effects.FireLore:SetSize(200, 20)
    self.Effects.FireLore:SetPosition (0,60)
    self.Effects.FireLore:SetMouseVisible (false)

    self.Effects.FrostLore = Turbine.UI.Lotro.EffectDisplay()
    self.Effects.FrostLore:SetParent (self.TargetFrame)
    self.Effects.FrostLore:SetSize(200, 20)
    self.Effects.FrostLore:SetPosition (0,80)
    self.Effects.FrostLore:SetMouseVisible (false)
    
   
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
        self.Morale.Bar:SetPosition (0,20)
        self.Power.Bar:SetSize(200, 20)
        self.Power.Bar:SetPosition (0,40)

        self.CurrentTarget = LocalUser:GetTarget()
        self.TargetSelection:SetEntity( self.CurrentTarget )

        local ThrowAwayGetTargetCall = LocalUser:GetTarget()
    
        if self.CurrentTarget then
            Turbine.Shell.WriteLine("  New target : "..tostring(self.TargetSelection:GetEntity()))
            Turbine.Shell.WriteLine("  New target's name : "..tostring(self.TargetSelection:GetEntity():GetName()))
            self.TitleBar:SetText(self.TargetSelection:GetEntity():GetName())
            self.Effects = self.CurrentTarget:GetEffects()
    
            if self.CurrentTarget.GetLevel ~= nil then
                Turbine.Shell.WriteLine("  Changing on target - got level")
                self.TitleBar:SetText("["..self.CurrentTarget:GetLevel().."] " ..self.CurrentTarget:GetName())
               
                self.CurrentTarget.MoraleChanged = function ()
                    if not self.CurrentTarget then
                        Turbine.Shell.WriteLine("Morale changing on target death....")
                        return
                    end
                    Turbine.Shell.WriteLine("Morale changing....")
                    local TargetMorale = self.CurrentTarget:GetMorale()
                    local TargetMaxMorale = self.CurrentTarget:GetMaxMorale()
                    local TargetTempMorale = self.CurrentTarget:GetTemporaryMorale()
                    local TargetMaxTempMorale = self.CurrentTarget:GetMaxTemporaryMorale()
                    self.Morale.Title:SetText(string.format("%d", TargetMorale).." / "..string.format("%d", TargetMaxMorale).." ")

                    if TargetMorale <= 1 then
                        self.Morale.Percent:SetText(string.format("0.0%%"))
                    else
                        self.Morale.Percent:SetText(string.format("%.1f", 100 * TargetMorale / TargetMaxMorale).."%")
                    end

                    local BarSize = math.floor(TargetMorale/TargetMaxMorale * 200)
                    self.Morale.Bar:SetSize(BarSize, 20)
                    self.Morale.Bar:SetPosition(200 - BarSize, 20)

                end
                    
                self.CurrentTarget.MaxMoraleChanged = self.CurrentTarget.MoraleChanged
                self.CurrentTarget.MoraleChanged()


                self.CurrentTarget.PowerChanged = function ()
                    Turbine.Shell.WriteLine("Power changing....")
                    local TargetPower = self.CurrentTarget:GetPower()
                    local TargetMaxPower = self.CurrentTarget:GetMaxPower()
                    local TargetTempPower = self.CurrentTarget:GetTemporaryPower()
                    local TargetMaxTempPower = self.CurrentTarget:GetMaxTemporaryPower()
                    self.Power.Title:SetText(string.format("%d", TargetPower).." / "..string.format("%d", TargetMaxPower).." ")
                    if TargetPower <= 1 then
                        self.Power.Percent:SetText(string.format("0.0%%"))            
                    else
                        self.Power.Percent:SetText(string.format("%.1f", 100 * TargetPower / TargetMaxPower).."%")
                    end

                    local BarSize = math.floor(TargetPower/TargetMaxPower * 200)
                    self.Power.Bar:SetSize(BarSize, 20)
                    self.Power.Bar:SetPosition(200 - BarSize, 40)
                                       
                end
        
                self.CurrentTarget.MaxPowerChanged = self.CurrentTarget.PowerChanged
                self.CurrentTarget.PowerChanged()
                               
            else
                Turbine.Shell.WriteLine("  Changing on target - not got level")
                self.TitleBar:SetText(self.CurrentTarget:GetName())
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


