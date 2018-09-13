-- ------------------------------------------------------------------------
-- Plugin Manager Options Panel
-- ------------------------------------------------------------------------
function plugin.GetOptionsPanel (self)
    DebugWriteLine("GetOptionsPanel")
    OP = OptionsPanel()   
    return OP
end

-- ------------------------------------------------------------------------
-- Panel in Plugin Manager
-- ------------------------------------------------------------------------
OptionsPanel = class (Turbine.UI.Control)

function OptionsPanel:Constructor ()
    Turbine.UI.Control.Constructor(self)

    self:SetBackColor(Turbine.UI.Color.MidnightBlue)
    self.checkboxes = {}

    -- OPTIONS
    self.OptionsTitle = Turbine.UI.Label()
    self.OptionsTitle:SetVisible(true)
    self.OptionsTitle:SetParent(self)
    self.OptionsTitle:SetSize(200, 40)
    self.OptionsTitle:SetPosition(20, 0) 
    self.OptionsTitle:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.OptionsTitle:SetFont( Turbine.UI.Lotro.Font.Verdana20 )
    self.OptionsTitle:SetText("Options")

    self.ShowMorale = Turbine.UI.Lotro.CheckBox()    
    self.ShowMorale:SetParent(self)
    self.ShowMorale:SetPosition(40, 40)
    self.ShowMorale:SetSize(400, 20)
    self.ShowMorale:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.ShowMorale:SetFont( Turbine.UI.Lotro.Font.Verdana16 )
    self.ShowMorale:SetText(" Show morale")
    self.ShowMorale:SetChecked(ShowMorale)

    self.ShowPower = Turbine.UI.Lotro.CheckBox()    
    self.ShowPower:SetParent(self)
    self.ShowPower:SetPosition(40, 60)
    self.ShowPower:SetSize(400, 20)
    self.ShowPower:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.ShowPower:SetFont( Turbine.UI.Lotro.Font.Verdana16 )
    self.ShowPower:SetText(" Show power")
    self.ShowPower:SetChecked(ShowPower)

    self.WidthScrollBar = Turbine.UI.Lotro.ScrollBar()
    self.WidthScrollBar:SetVisible(true)
    self.WidthScrollBar:SetParent(self)
    self.WidthScrollBar:SetSize(200, 10)
    self.WidthScrollBar:SetPosition(200, 85) 
    self.WidthScrollBar:SetMinimum(150)
    self.WidthScrollBar:SetMaximum(250)
    self.WidthScrollBar:SetValue(FrameWidth)    
    self.WidthScrollBar:SetOrientation( Turbine.UI.Orientation.Horizontal )
    self.WidthScrollBar:SetBackColor (Turbine.UI.Color.White)
    self.WidthScrollBar.ValueChanged = function() 
        self.WidthTitle:SetText("Frame width : "..tostring(self.WidthScrollBar:GetValue()))    
    end

    self.WidthTitle = Turbine.UI.Label()
    self.WidthTitle:SetVisible(true)
    self.WidthTitle:SetParent(self)
    self.WidthTitle:SetSize(130, 20)
    self.WidthTitle:SetPosition(40, 80) 
    self.WidthTitle:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.WidthTitle:SetFont( Turbine.UI.Lotro.Font.Verdana16 )
    self.WidthScrollBar.ValueChanged()

    self.HeightScrollBar = Turbine.UI.Lotro.ScrollBar()
    self.HeightScrollBar:SetVisible(true)
    self.HeightScrollBar:SetParent(self)
    self.HeightScrollBar:SetSize(200, 10)
    self.HeightScrollBar:SetPosition(200, 105) 
    self.HeightScrollBar:SetMinimum(10)
    self.HeightScrollBar:SetMaximum(30)
    self.HeightScrollBar:SetValue(ControlHeight)    
    self.HeightScrollBar:SetOrientation( Turbine.UI.Orientation.Horizontal )
    self.HeightScrollBar:SetBackColor (Turbine.UI.Color.White)
    self.HeightScrollBar.ValueChanged = function() 
        self.HeightTitle:SetText("Effect height : "..tostring(self.HeightScrollBar:GetValue()))    
    end  

    self.HeightTitle = Turbine.UI.Label()
    self.HeightTitle:SetVisible(true)
    self.HeightTitle:SetParent(self)
    self.HeightTitle:SetSize(130, 20)
    self.HeightTitle:SetPosition(40, 100) 
    self.HeightTitle:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.HeightTitle:SetFont( Turbine.UI.Lotro.Font.Verdana16 )
    self.HeightScrollBar.ValueChanged()

    self.PreloadScrollBar = Turbine.UI.Lotro.ScrollBar()
    self.PreloadScrollBar:SetVisible(true)
    self.PreloadScrollBar:SetParent(self)
    self.PreloadScrollBar:SetSize(200, 10)
    self.PreloadScrollBar:SetPosition(200, 125) 
    self.PreloadScrollBar:SetMinimum(2)
    self.PreloadScrollBar:SetMaximum(20)
    self.PreloadScrollBar:SetValue(PreLoadedCount * 2)
    self.PreloadScrollBar:SetOrientation( Turbine.UI.Orientation.Horizontal )
    self.PreloadScrollBar:SetBackColor (Turbine.UI.Color.White)
    self.PreloadScrollBar.ValueChanged = function() 
        -- workaround bad scrollbar behaviour 
        self.PreloadTitle:SetText("Load frames : "..tostring(math.floor(self.PreloadScrollBar:GetValue()/2)))    
    end  

    self.PreloadTitle = Turbine.UI.Label()
    self.PreloadTitle:SetVisible(true)
    self.PreloadTitle:SetParent(self)
    self.PreloadTitle:SetSize(130, 20)
    self.PreloadTitle:SetPosition(40, 120) 
    self.PreloadTitle:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.PreloadTitle:SetFont( Turbine.UI.Lotro.Font.Verdana16 )
    self.PreloadScrollBar.ValueChanged()

    self.LockedPosition = Turbine.UI.Lotro.CheckBox()    
    self.LockedPosition:SetParent(self)
    self.LockedPosition:SetPosition(40, 140)
    self.LockedPosition:SetSize(400, 20)
    self.LockedPosition:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.LockedPosition:SetFont( Turbine.UI.Lotro.Font.Verdana16 )
    self.LockedPosition:SetText(" Locked position")
    self.LockedPosition:SetChecked(LockedPosition)

    self.SaveFramePositions = Turbine.UI.Lotro.CheckBox()    
    self.SaveFramePositions:SetParent(self)
    self.SaveFramePositions:SetPosition(40, 160)
    self.SaveFramePositions:SetSize(400, 20)
    self.SaveFramePositions:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.SaveFramePositions:SetFont( Turbine.UI.Lotro.Font.Verdana16 )
    self.SaveFramePositions:SetText(" Save frame position")
    self.SaveFramePositions:SetChecked(SaveFramePositions)

    -- DEBUFFS AND EFFECTS
    self.DebuffsTitle = Turbine.UI.Label()
    self.DebuffsTitle:SetVisible(true)
    self.DebuffsTitle:SetParent(self)
    self.DebuffsTitle:SetSize(200, 40)
    self.DebuffsTitle:SetPosition(20, DEBUFF_AND_EFFECTS_OFFSET + 0) 
    self.DebuffsTitle:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.DebuffsTitle:SetFont( Turbine.UI.Lotro.Font.Verdana20 )
    self.DebuffsTitle:SetText("Debuffs and Effects")

    for k, v in ipairs (TrackedEffects) do 
        DebugWriteLine("OptionsPanel: Adding in "..tostring(v[2]))               
        local checkbox = Turbine.UI.Lotro.CheckBox()    
        checkbox:SetParent(self)
        checkbox:SetPosition(40, DEBUFF_AND_EFFECTS_OFFSET + 20 + k * 20)
        checkbox:SetSize(400, 20)
        checkbox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
        checkbox:SetFont( Turbine.UI.Lotro.Font.Verdana16 )
        checkbox:SetText(" "..tostring(v[1]).." - "..tostring(v[2]))        
        if v[3] == 1 then
            checkbox:SetChecked(true)
        else
            checkbox:SetChecked(false)
        end
        self.checkboxes[k] = checkbox                       
    end

    self:SetSize(0, DEBUFF_AND_EFFECTS_OFFSET + 100 + #self.checkboxes * 20)
    
    -- buttons
    self.RevertButton = Turbine.UI.Lotro.Button();
    self.RevertButton:SetParent(self);
    self.RevertButton:SetSize(80, 20);
    self.RevertButton:SetPosition(10, self:GetHeight() - 40)
    self.RevertButton:SetText("Revert");
    self.RevertButton.Click = function(sender, args)
        self:Revert();
    end

    self.DefaultButton = Turbine.UI.Lotro.Button();
    self.DefaultButton:SetParent(self);
    self.DefaultButton:SetSize(80, 20);
    self.DefaultButton:SetPosition(110, self:GetHeight() - 40)
    self.DefaultButton:SetText("Defaults");
    self.DefaultButton.Click = function(sender, args)
        self:Defaults();        
    end

    self.AcceptButton  = Turbine.UI.Lotro.Button();
    self.AcceptButton:SetParent(self);
    self.AcceptButton:SetSize(80, 20);
    self.AcceptButton:SetPosition(210, self:GetHeight() - 40)
    self.AcceptButton:SetText("Accept");
    self.AcceptButton.Click = function(sender, args)
        self:Accept();
    end    
end

-- ------------------------------------------------------------------------
-- Pressing the Defaults Button
-- ------------------------------------------------------------------------
function OptionsPanel:Defaults()

    self.WidthScrollBar:SetValue(DEFAULT_WIDTH)
    self.HeightScrollBar:SetValue(DEFAULT_HEIGHT)  
    self.SaveFramePositions:SetChecked(DEFAULT_SAVE_FRAME_POSITIONS)
    self.LockedPosition:SetChecked(DEFAULT_LOCKED_POSITION)
    self.PreloadScrollBar:SetValue(DEFAULT_PRELOAD_COUNT)
    self.ShowMorale:SetChecked(DEFAULT_SHOW_MORALE)
    self.ShowPower:SetChecked(DEFAULT_SHOW_POWER)

    for k, v in ipairs (DEFAULT_EFFECTS) do
        if v[3] == 1 then
            self.checkboxes[k]:SetChecked(true)
        else
            self.checkboxes[k]:SetChecked(false)
        end                       
    end   
end

-- ------------------------------------------------------------------------
-- Pressing the Accept Button
-- ------------------------------------------------------------------------
function OptionsPanel:Accept()
    for k, v in ipairs (self.checkboxes) do
        if v:IsChecked() then
            TrackedEffects[k][3] = 1
        else
            TrackedEffects[k][3] = 0
        end
    end

    SaveSettings(self)

    GenerateEnabledSet()
    
    FrameWidth = self.WidthScrollBar:GetValue()
    ControlHeight = self.HeightScrollBar:GetValue()
    SaveFramePositions = self.SaveFramePositions:IsChecked()
    LockedPosition = self.LockedPosition:IsChecked()
    PreLoadedCount = self.PreloadScrollBar:GetValue()
    ShowMorale = self.ShowMorale:IsChecked()
    ShowPower = self.ShowPower:IsChecked()

    for k, v in pairs (TargetFrames) do
        v:SetEnabledEffects()
        v:Resize()
    end
end

-- ------------------------------------------------------------------------
-- Pressing the Revert Button
-- ------------------------------------------------------------------------
function OptionsPanel:Revert()

    self.WidthScrollBar:SetValue(FrameWidth)
    self.HeightScrollBar:SetValue(ControlHeight)  
    self.SaveFramePositions:SetChecked(SaveFramePositions)
    self.LockedPosition:SetChecked(LockedPosition)
    self.PreloadScrollBar:SetValue(PreLoadedCount) 
    self.ShowMorale:SetChecked(ShowMorale)
    self.ShowPower:SetChecked(ShowPower)

    for k, v in ipairs (TrackedEffects) do
        if v[3] == 1 then
            self.checkboxes[k]:SetChecked(true)
        else
            self.checkboxes[k]:SetChecked(false)
        end                       
    end
end