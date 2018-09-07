-- ------------------------------------------------------------------------
-- Plugin Manager Options Panel
-- ------------------------------------------------------------------------
function plugin.GetOptionsPanel (self)
    DebugWriteLine("GetOptionsPanel")
    OP = OptionsPanel()   
    return OP
end

-- ------------------------------------------------------------------------
-- 
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

    self.widthScrollBar = Turbine.UI.Lotro.ScrollBar()
    self.widthScrollBar:SetVisible(true)
    self.widthScrollBar:SetParent(self)
    self.widthScrollBar:SetSize(200, 10)
    self.widthScrollBar:SetPosition(200, 46) 
    self.widthScrollBar:SetMinimum(150)
    self.widthScrollBar:SetMaximum(250)
    self.widthScrollBar:SetValue(200)    
    self.widthScrollBar:SetOrientation( Turbine.UI.Orientation.Horizontal )
    self.widthScrollBar:SetBackColor (Turbine.UI.Color.White)
    self.widthScrollBar.ValueChanged = function() 
        self.widthTitle:SetText("Frame width : "..tostring(self.widthScrollBar:GetValue()))    
    end


    self.widthTitle = Turbine.UI.Label()
    self.widthTitle:SetVisible(true)
    self.widthTitle:SetParent(self)
    self.widthTitle:SetSize(200, 20)
    self.widthTitle:SetPosition(40, 40) 
    self.widthTitle:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.widthTitle:SetFont( Turbine.UI.Lotro.Font.Verdana16 )
    self.widthTitle:SetText("Frame width : "..tostring(self.widthScrollBar:GetValue()))


    self.heightScrollBar = Turbine.UI.Lotro.ScrollBar()
    self.heightScrollBar:SetVisible(true)
    self.heightScrollBar:SetParent(self)
    self.heightScrollBar:SetSize(200, 10)
    self.heightScrollBar:SetPosition(200, 66) 
    self.heightScrollBar:SetMinimum(10)
    self.heightScrollBar:SetMaximum(30)
    self.heightScrollBar:SetValue(20)    
    self.heightScrollBar:SetOrientation( Turbine.UI.Orientation.Horizontal )
    self.heightScrollBar:SetBackColor (Turbine.UI.Color.White)
    self.heightScrollBar.ValueChanged = function() 
        self.heightTitle:SetText("Effect height : "..tostring(self.heightScrollBar:GetValue()))    
    end  

    self.heightTitle = Turbine.UI.Label()
    self.heightTitle:SetVisible(true)
    self.heightTitle:SetParent(self)
    self.heightTitle:SetSize(200, 20)
    self.heightTitle:SetPosition(40, 60) 
    self.heightTitle:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.heightTitle:SetFont( Turbine.UI.Lotro.Font.Verdana16 )
    self.heightTitle:SetText("Effect height : "..tostring(self.heightScrollBar:GetValue()))

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
        checkbox:SetPosition(20, DEBUFF_AND_EFFECTS_OFFSET + 20 + k * 20)
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
    self.revertButton = Turbine.UI.Lotro.Button();
    self.revertButton:SetParent(self);
    self.revertButton:SetSize(80, 20);
    self.revertButton:SetPosition(10, self:GetHeight() - 40)
    self.revertButton:SetText("Revert");
    self.revertButton.Click = function(sender, args)
        self:Revert();
    end

    self.defaultButton = Turbine.UI.Lotro.Button();
    self.defaultButton:SetParent(self);
    self.defaultButton:SetSize(80, 20);
    self.defaultButton:SetPosition(110, self:GetHeight() - 40)
    self.defaultButton:SetText("Defaults");
    self.defaultButton.Click = function(sender, args)
        self:Defaults();        
    end

    self.acceptButton  = Turbine.UI.Lotro.Button();
    self.acceptButton:SetParent(self);
    self.acceptButton:SetSize(80, 20);
    self.acceptButton:SetPosition(210, self:GetHeight() - 40)
    self.acceptButton:SetText("Accept");
    self.acceptButton.Click = function(sender, args)
        self:Accept();
        FrameWidth = self.widthScrollBar:GetValue()
        ControlHeight = self.heightScrollBar:GetValue()
        for k, frame in pairs (TargetFrames) do
            frame:Resize()
        end
    end    
end

-- ------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------
function OptionsPanel:Defaults()
    for k, v in ipairs (DEFAULT_EFFECTS) do
        if v[3] == 1 then
            self.checkboxes[k]:SetChecked(true)
        else
            self.checkboxes[k]:SetChecked(false)
        end                       
    end   
end

-- ------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------
function OptionsPanel:Accept()
    for k, v in ipairs (self.checkboxes) do
        if v:IsChecked() then
            TrackedEffects[k][3] = 1
        else
            TrackedEffects[k][3] = 0
        end
    end

    Turbine.PluginData.Save(Turbine.DataScope.Character, "DebuffVitals", TrackedEffects, nil);

    GenerateEnabledSet()

    for k, v in pairs(TargetFrames) do
        v:SetEnabledEffects()
    end
    
end

-- ------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------
function OptionsPanel:Revert()
    for k, v in ipairs (TrackedEffects) do
        if v[3] == 1 then
            self.checkboxes[k]:SetChecked(true)
        else
            self.checkboxes[k]:SetChecked(false)
        end                       
    end
end