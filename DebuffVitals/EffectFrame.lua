-- ------------------------------------------------------------------------
-- Effect boxes and timers
-- ------------------------------------------------------------------------

EffectFrame = class (Turbine.UI.Control)

-- ------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------
function EffectFrame:Constructor (CurrentFrame, EffectDefinition)
    Turbine.UI.Control.Constructor(self)
    
    DebugWriteLine("Creating EffectFrame : "..tostring(EffectDefinition[2]))

    self.startTime = 0
    self.duration = 0
    self.endTime = 0
    self.lastSeen = nil
    self.toggle = EffectDefinition[4]

    self:SetParent(CurrentFrame)
    self:SetVisible(true)
    self:SetSize (DEFAULT_WIDTH, DEFAULT_HEIGHT)     
    self:SetEnabled(false)

    self.effectDisplay = Turbine.UI.Lotro.EffectDisplay()
    self.effectDisplay:SetVisible(true)
    self.effectDisplay:SetMouseVisible(true)
    self.effectDisplay:SetParent(self)
    self.effectDisplay:SetSize(DEFAULT_HEIGHT, DEFAULT_HEIGHT)
    self.effectDisplay:SetPosition(0, 0)
    self.effectDisplay:SetZOrder(200)

    self.name = Turbine.UI.Label()
    self.name:SetVisible(true)
    self.name:SetParent(self)
    self.name:SetSize(DEFAULT_WIDTH - DEFAULT_HEIGHT - 30, DEFAULT_HEIGHT)
    self.name:SetPosition(DEFAULT_HEIGHT, 0) 
    self.name:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.name:SetFont( Turbine.UI.Lotro.Font.Verdana12 )
    self.name:SetText(tostring(EffectDefinition[2]))
    self.name:SetForeColor (Turbine.UI.Color.Gray)
    self.name:SetMultiline(false)
    
    self.effectName = EffectDefinition[2]
    self.patternMatch = EffectDefinition[5]    
   
    self.timer = Turbine.UI.Label()
    self.timer:SetVisible(true)
    self.timer:SetParent(self)
    self.timer:SetSize(30, DEFAULT_HEIGHT)
    self.timer:SetPosition(DEFAULT_WIDTH - 30, 0)
    self.timer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
    self.timer:SetFont( Turbine.UI.Lotro.Font.Verdana12 )
    self.timer:SetForeColor (Turbine.UI.Color.Gray)
    self.timer:SetText("-")
end

-- ------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------
function EffectFrame:SetCurrentEffect(effect)
    self.effectDisplay:SetEffect(effect)

    self.startTime = effect:GetStartTime()
    self.duration = effect:GetDuration()
    self.endTime = (self.startTime + self.duration)
    if (Turbine.Engine.GetGameTime() < self.endTime) then
        self:SetWantsUpdates(true)
    end
    
    self.name:SetForeColor (Turbine.UI.Color.White)
    self.timer:SetForeColor (Turbine.UI.Color.White)
    if self.patternMatch then
        self.name:SetText(effect:GetName())
    end
end

-- ------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------
function EffectFrame:ClearCurrentEffect()
    self.startTime = 0
    self.duration = 0
    self.endTime = 0
    self.lastSeen = 0

    self.effect = nil

    self.effectDisplay:SetVisible(false)
    self.effectDisplay = nil

    self.effectDisplay = Turbine.UI.Lotro.EffectDisplay()
    self.effectDisplay:SetVisible(true)
    self.effectDisplay:SetParent(self)
    self.effectDisplay:SetSize(DEFAULT_HEIGHT, DEFAULT_HEIGHT)
    self.effectDisplay:SetPosition(0, 0)  
    self.effectDisplay:SetEffect(nil)

    self.name:SetForeColor (Turbine.UI.Color.Gray)
    if self.patternMatch then
        self.name:SetText(tostring(self.effectName))
    end
    self.timer:SetText("-")
    self.timer:SetForeColor (Turbine.UI.Color.Gray)  

    self:SetWantsUpdates(false)
end

-- ------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------
function EffectFrame:Update(args)
    local gameTime = Turbine.Engine.GetGameTime()
    local elapsedTime = gameTime - self.startTime
   
    -- update the time
    if (self.duration > 86400) then
        local time = TimeFormat(math.floor(elapsedTime))
        self.timer:SetText(time)
    else
        local remaining = self.duration - math.ceil(elapsedTime)
        local time = TimeFormat(remaining < 0 and 0 or remaining)
        self.timer:SetText(time)
        
        if (gameTime > self.endTime) then
            self:ClearCurrentEffect()
        end        
    end
end

-- ------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------
function TimeFormat (value)
    if (value >= 3600) then
        local sec = math.fmod(value, 3600) / 60;
        value = ("%d:%02d:%02d"):format(value / 3600, value % 3600 / 60, value % 60);
    elseif (value >= 60) then
        value = ("%d:%02d"):format(value / 60, value % 60);
    else
        value = ("%d"):format(value);
    end
    return value;
end