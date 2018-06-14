-- ------------------------------------------------------------------------
-- Target Box
-- ------------------------------------------------------------------------

TargetBox = {}

TargetBox.new = function(num) 
    local self = setmetatable({}, TargetBox)

    Turbine.Shell.WriteLine("Creating TargetBox")

    self.ID = num

    -- ------------------------------------------------------------------------
    -- TargetFrame
    -- ------------------------------------------------------------------------
    self.TargetFrame = Turbine.UI.Window()
    self.TargetFrame:SetSize(200,100)
    self.TargetFrame:SetVisible(true) 
    self.TargetFrame:SetMouseVisible ("false")
    self.TargetFrame:SetBackColor(Turbine.UI.Color.White)
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
    
--[[  
    -- ------------------------------------------------------------------------
    -- Morale 
    -- ------------------------------------------------------------------------
    self.MoraleBar = Turbine.UI.Control()
    MoraleBar:SetParent (TargetFrame)
    MoraleBar:SetBackColor ( Turbine.UI.Color.ForestGreen )
    MoraleBar:SetSize (200, 20)
    MoraleBar:SetPosition (0,20)
    MoraleBar:SetMouseVisible (false)

    self.MoraleTitle = Turbine.UI.Label()
    MoraleTitle:SetParent (TargetFrame)
    MoraleTitle:SetPosition (45,20)
    MoraleTitle:SetSize(155, 20)
    MoraleTitle:SetMouseVisible (false)
    MoraleTitle:SetText ("")
    MoraleTitle:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight)
    MoraleTitle:SetFont( Turbine.UI.Lotro.Font.Verdana12 )

    self.MoralePercent = Turbine.UI.Label()
    MoralePercent:SetParent (TargetFrame)
    MoralePercent:SetPosition (0,20)
    MoralePercent:SetSize(45, 20)
    MoralePercent:SetMouseVisible (false)
    MoralePercent:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft)
    MoralePercent:SetFont( Turbine.UI.Lotro.Font.Verdana12 )    

    -- ------------------------------------------------------------------------
    -- Power
    -- ------------------------------------------------------------------------
    self.PowerBar = Turbine.UI.Control()
    PowerBar:SetParent (TargetFrame)
    PowerBar:SetBackColor ( Turbine.UI.Color.RoyalBlue )
    PowerBar:SetSize(200, 20)
    PowerBar:SetPosition (0,40)
    PowerBar:SetMouseVisible (false)

    self.PowerTitle = Turbine.UI.Label()
    PowerTitle:SetParent (TargetFrame)
    PowerTitle:SetPosition (45,40)
    PowerTitle:SetSize(155, 20)
    PowerTitle:SetMouseVisible (false)
    PowerTitle:SetText ("")
    PowerTitle:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight)
    PowerTitle:SetFont( Turbine.UI.Lotro.Font.Verdana12 )

    self.PowerPercent = Turbine.UI.Label()
    PowerPercent:SetParent (TargetFrame)
    PowerPercent:SetPosition (0,40)
    PowerPercent:SetSize(45, 20)
    PowerPercent:SetMouseVisible (false)
    PowerPercent:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft)
    PowerPercent:SetFont( Turbine.UI.Lotro.Font.Verdana12 )    

    -- Hide with interface
    TargetFrame:SetWantsKeyEvents( true )
    function TargetFrame:KeyDown( args )
        a = args.Action
        if ( a == 268435635 ) then
            TargetFrame:SetVisible( not TargetFrame:IsVisible() )
        end
    end

    -- Mouse and Dragging
    IsDragging = false

    TargetSelection.MouseDown = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Left then
            startX = args.X
            startY = args.Y
            IsDragging = true
        end
    end

    TargetSelection.MouseUp = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Left then
            if ( IsDragging ) then
                IsDragging = false
                
                TargetFrame:SetLeft(TargetFrame:GetLeft() + (args.X - startX))
                TargetFrame:SetTop(TargetFrame:GetTop() + (args.Y - startY))
    
                if TargetFrame:GetLeft() < 0 then
                    TargetFrame:SetLeft(0)
                elseif TargetFrame:GetLeft() + TargetFrame:GetWidth() > Turbine.UI.Display:GetWidth() then
                    TargetFrame:SetLeft(Turbine.UI.Display:GetWidth()-TargetFrame:GetWidth())
                end
                if TargetFrame:GetTop() < 0 then
                    TargetFrame:SetTop(0)
                elseif TargetFrame:GetTop() + TargetFrame:GetHeight() > Turbine.UI.Display:GetHeight() then
                    TargetFrame:SetTop(Turbine.UI.Display:GetHeight()-TargetFrame:GetHeight())
                end
            end
        end
    end

    TargetSelection.MouseMove = function(sender, args)
        if IsDragging then
            TargetFrame:SetLeft(TargetFrame:GetLeft() + (args.X - startX))
            TargetFrame:SetTop(TargetFrame:GetTop() + (args.Y - startY))
        end
    end
    
    TitleBar.MouseClick = function (sender, args)
        if args.Button == Turbine.UI.MouseButton.Right then
            IsDragging = false
            Turbine.Shell.WriteLine("Showing menu")
        
            if CountTargets() == 1 then
                MenuItems:GetItems():Get(3):SetEnabled(false)
            else
                MenuItems:GetItems():Get(3):SetEnabled(true)
            end
            MenuItems.invokerID = ID
            MenuItems:ShowMenu()
        end
    end

    TitleBar.MouseDown = TargetSelection.MouseDown

    TitleBar.MouseUp = function(sender, args)
        IsDragging = false
        if args.Button == Turbine.UI.MouseButton.Right then
            Turbine.Shell.WriteLine("Closing menu")
        end
    end
    
    TitleBar.MouseMove = TargetSelection.MouseMove

    function self.IsLocked()
        return Locked
    end
    
    function self.GetID()
        return ID
    end    

    function self.DestroyFrame()
    --    TargetFrame:SetVisible(false)
    --    TargetFrame = nil
    end
]]

    return self

end

function TargetBox:UpdateTarget()
    Turbine.Shell.WriteLine("Entering UpdateTarget")
    Turbine.Shell.WriteLine("  LocalUserTarget ID : "..tostring(LocalUser:GetTarget()))

    if self.Locked then
        if self.TargetSelection:GetEntity() then
            Turbine.Shell.WriteLine("  No change - lock on target : "..tostring(self.TargetSelection:GetEntity()))
            Turbine.Shell.WriteLine("  No change - lock on target : "..tostring(self.TargetSelection:GetEntity():GetName()))           
        else
            Turbine.Shell.WriteLine("  No change - locked on NO TARGET")
        end
    else
        Turbine.Shell.WriteLine("  Changing target")

        local Target = LocalUser:GetTarget()
        self.TargetSelection:SetEntity( Target )
    
        if Target then
            Turbine.Shell.WriteLine("  New target : "..tostring(self.TargetSelection:GetEntity()))
            Turbine.Shell.WriteLine("  New target's name : "..tostring(self.TargetSelection:GetEntity():GetName()))
            self.TitleBar:SetText(self.TargetSelection:GetEntity():GetName())
        else
            Turbine.Shell.WriteLine("  Changing - no target")
            self.TitleBar:SetText("No Target")             
        end

--[[
            MoraleTitle:SetText("")
            MoralePercent:SetText("")
            PowerTitle:SetText("")
            PowerPercent:SetText("")

               
                if Target.GetLevel ~= nil then
                    Turbine.Shell.WriteLine("  Changing on target - got level")
                    TitleBar:SetText("["..Target:GetLevel().."] " ..Target:GetName())
        
                    Target.MoraleChanged = function ()
                        Turbine.Shell.WriteLine("Morale changing....")
                        TargetMorale = Target:GetMorale()
                        TargetMaxMorale = Target:GetMaxMorale()
                        MoraleTitle:SetText(string.format("%d", TargetMorale).." / "..string.format("%d", TargetMaxMorale))
                        if TargetMorale <= 1 then
                            MoralePercent:SetText(string.format("0.0%%"))
                        else
                            MoralePercent:SetText(string.format("%.1f", 100 * TargetMorale / TargetMaxMorale).."%")
                        end
                    end
                        
                    Target.MaxMoraleChanged = Target.MoraleChanged
                    Target.MoraleChanged()
        
                    Target.PowerChanged = function ()
                        Turbine.Shell.WriteLine("Power changing....")
                        TargetPower = Target:GetPower()
                        TargetMaxPower = Target:GetMaxPower()
                        PowerTitle:SetText(string.format("%d", TargetPower).." / "..string.format("%d", TargetMaxPower))
                        if TargetPower <= 1 then
                            PowerPercent:SetText(string.format("0.0%%"))            
                        else
                            PowerPercent:SetText(string.format("%.1f", 100 * TargetPower / TargetMaxPower).."%")
                        end
                    end
            
                    Target.MaxPowerChanged = Target.PowerChanged
                    Target.PowerChanged()
                else
                    Turbine.Shell.WriteLine("  Changing on target - not got level")
                    TitleBar:SetText(Target:GetName())
                end
        ]]
    end

    TargetBox.DumpData(self)

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



