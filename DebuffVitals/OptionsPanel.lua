local DEBUG_ENABLED = DEBUG_ENABLED
local DEFAULT_EFFECTS = DEFAULT_EFFECTS
-- ------------------------------------------------------------------------
-- Plugin Manager Options Panel
-- ------------------------------------------------------------------------
function plugin.GetOptionsPanel (self)
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

    -- Width
    self.WidthScrollBar = Turbine.UI.Lotro.ScrollBar()
    self.WidthScrollBar:SetVisible(true)
    self.WidthScrollBar:SetParent(self)
    self.WidthScrollBar:SetSize(200, 10)
    self.WidthScrollBar:SetPosition(220, 45) 
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
    self.WidthTitle:SetPosition(40, 40) 
    self.WidthTitle:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.WidthTitle:SetFont( Turbine.UI.Lotro.Font.Verdana16 )
    self.WidthScrollBar.ValueChanged()

    -- Height
    self.HeightScrollBar = Turbine.UI.Lotro.ScrollBar()
    self.HeightScrollBar:SetVisible(true)
    self.HeightScrollBar:SetParent(self)
    self.HeightScrollBar:SetSize(200, 10)
    self.HeightScrollBar:SetPosition(220, 65) 
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
    self.HeightTitle:SetPosition(40, 60) 
    self.HeightTitle:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.HeightTitle:SetFont( Turbine.UI.Lotro.Font.Verdana16 )
    self.HeightScrollBar.ValueChanged()

    -- Modulus
    self.ModulusScrollBar = Turbine.UI.Lotro.ScrollBar()
    self.ModulusScrollBar:SetVisible(true)
    self.ModulusScrollBar:SetParent(self)
    self.ModulusScrollBar:SetSize(200, 10)
    self.ModulusScrollBar:SetPosition(220, 85) 
    self.ModulusScrollBar:SetMinimum(10)
    self.ModulusScrollBar:SetMaximum(120)
    self.ModulusScrollBar:SetValue(EffectsModulus)
    self.ModulusScrollBar:SetOrientation( Turbine.UI.Orientation.Horizontal )
    self.ModulusScrollBar:SetBackColor (Turbine.UI.Color.White)
    self.ModulusScrollBar.ValueChanged = function() 
        self.ModulusTitle:SetText("Refresh Throttling : "..tostring(self.ModulusScrollBar:GetValue()))    
    end

    self.ModulusTitle = Turbine.UI.Label()
    self.ModulusTitle:SetVisible(true)
    self.ModulusTitle:SetParent(self)
    self.ModulusTitle:SetSize(160, 20)
    self.ModulusTitle:SetPosition(40, 80) 
    self.ModulusTitle:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.ModulusTitle:SetFont( Turbine.UI.Lotro.Font.Verdana16 )
    self.ModulusScrollBar.ValueChanged()    

    -- DEBUFFS AND EFFECTS
    self.DebuffsTitle = Turbine.UI.Label()
    self.DebuffsTitle:SetVisible(true)
    self.DebuffsTitle:SetParent(self)
    self.DebuffsTitle:SetSize(200, 40)
    self.DebuffsTitle:SetPosition(20, DEBUFF_AND_EFFECTS_OFFSET + 0) 
    self.DebuffsTitle:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.DebuffsTitle:SetFont( Turbine.UI.Lotro.Font.Verdana20 )
    self.DebuffsTitle:SetText("Debuffs and Effects")

    local effects = TrackedEffects
    local currentGroup = ''

    for k = 1, #effects do
        local checkbox = Turbine.UI.Lotro.CheckBox()
        local groupName = Turbine.UI.Label()
        if currentGroup ~= effects[k][1] then
            currentGroup = effects[k][1]           
            groupName:SetVisible(true)
            groupName:SetParent(self)
            groupName:SetSize(140, 20)
            groupName:SetPosition(40, DEBUFF_AND_EFFECTS_OFFSET + 20 + k * 20) 
            groupName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
            groupName:SetFont( Turbine.UI.Lotro.Font.Verdana18 )
            groupName:SetText(currentGroup)         
        end
        checkbox:SetParent(self)
        checkbox:SetPosition(140, DEBUFF_AND_EFFECTS_OFFSET + 20 + k * 20)
        checkbox:SetSize(400, 20)
        checkbox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
        checkbox:SetFont( Turbine.UI.Lotro.Font.Verdana16 )
        checkbox:SetText(" "..tostring(effects[k][2]))
        self.checkboxes[k] = checkbox    
    end
    
    self:SetCheckboxes()

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
-- Reverts the effects to default values
-- ------------------------------------------------------------------------
function OptionsPanel:Defaults()
    self.WidthScrollBar:SetValue(DEFAULT_WIDTH)
    self.HeightScrollBar:SetValue(DEFAULT_HEIGHT)  
    self.ModulusScrollBar:SetValue(DEFAULT_EFFECTS_MODULUS)

    for k = 1, #DEFAULT_EFFECTS do
        if DEFAULT_EFFECTS[k][3] == 1 then
            self.checkboxes[k]:SetChecked(true)
        else
            self.checkboxes[k]:SetChecked(false)
        end                       
    end
    
    collectgarbage()
end

-- ------------------------------------------------------------------------
-- Sets all effects to current values
-- ------------------------------------------------------------------------
function OptionsPanel:Accept()
    for k = 1, #self.checkboxes do 
        if self.checkboxes[k]:IsChecked() then
            TrackedEffects[k][3] = 1
        else
            TrackedEffects[k][3] = 0
        end
    end

    GenerateEffectsSetFromTrackedEffects()

    FrameWidth = self.WidthScrollBar:GetValue()
    ControlHeight = self.HeightScrollBar:GetValue()
    EffectsModulus = self.ModulusScrollBar:GetValue()

    for k = 1, #TargetFrames do 
        TargetFrames[k]:ReconcileEffectsLists()
        TargetFrames[k]:SetEnabledEffects()
        TargetFrames[k]:Resize()
    end

    FrameMenu:CreateEffectsMenu()

    collectgarbage()
end

-- ------------------------------------------------------------------------
-- Undos any unapplied changes made to settings
-- ------------------------------------------------------------------------
function OptionsPanel:Revert()

    self.WidthScrollBar:SetValue(FrameWidth)
    self.HeightScrollBar:SetValue(ControlHeight)
    self.ModulusScrollBar:SetValue(EffectsModulus)

    local effects = TrackedEffects
    for k = 1, #effects do
        if effects[k][3] == 1 then
            self.checkboxes[k]:SetChecked(true)
        else
            self.checkboxes[k]:SetChecked(false)
        end                       
    end
end

-- ------------------------------------------------------------------------
-- Set checkboxes based on tracked effects
-- ------------------------------------------------------------------------
function OptionsPanel:SetCheckboxes()

    local effects = TrackedEffects
    for k = 1, #effects do
        if effects[k][3] == 1 then
            self.checkboxes[k]:SetChecked(true)
        else
            self.checkboxes[k]:SetChecked(false)
        end                       
    end
end