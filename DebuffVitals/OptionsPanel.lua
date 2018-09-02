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
    
    -- Plugin manager seems to autostretch x 

    self.title = Turbine.UI.Label()
    self.title:SetVisible(true)
    self.title:SetParent(self)
    self.title:SetSize(200, 40)
    self.title:SetPosition(20, 0) 
    self.title:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.title:SetFont( Turbine.UI.Lotro.Font.Verdana20 )
    self.title:SetText("Debuffs and Effects")

    for k, v in ipairs (TrackedEffects) do 
        DebugWriteLine("OptionsPanel: Adding in "..tostring(v[2]))               
        local checkbox = Turbine.UI.Lotro.CheckBox()    
        checkbox:SetParent(self)
        checkbox:SetPosition(20, 20 + k * 20)
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
    self:SetSize(0, 100 + #self.checkboxes * 20)    

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