-- ------------------------------------------------------------------------
-- Effect boxes and timers
-- ------------------------------------------------------------------------

EffectFrame = class (Turbine.UI.Control)

function EffectFrame:Constructor (CurrentFrame, TargetEffect)
    Turbine.UI.Control.Constructor(self)
    
    DebugWriteLine("Creating EffectFrame : "..tostring(TargetEffect))
    
    self.flashPeriod = 2
    self.lastFlash = 0
    self.flash = false
    self.thisEffect = nil
    self.startTime = 1
    self.duration = 1
    self.endTime = 1

    self:SetParent(CurrentFrame)
    self:SetVisible(true)
    self:SetSize (200,20)
--    self:SetBackColor(Turbine.UI.Color.Gray)
    self:SetEnabled(false)

    --self:SetMouseVisible(false)
    self.effect = Turbine.UI.Lotro.EffectDisplay()
    self.effect:SetVisible(true)
    self.effect:SetParent(self)
    self.effect:SetSize(20, 20)
    self.effect:SetPosition(0, 0)

    self.name = Turbine.UI.Label()
    self.name:SetVisible(true)
    self.name:SetParent(self)
    self.name:SetSize(100, 20)
    self.name:SetPosition(20, 0) 
    self.name:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.name:SetFont( Turbine.UI.Lotro.Font.Verdana12 )
    self.name:SetText(TargetEffect)
    
    self.timer = Turbine.UI.Label()
    self.timer:SetVisible(true)
    self.timer:SetParent(self)
    self.timer:SetSize(80, 20)
    self.timer:SetPosition(120, 0)
    self.timer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
    self.timer:SetFont( Turbine.UI.Lotro.Font.Verdana12 )
    self.timer:SetText("inactive") 

end


function EffectFrame:SetEffect(value, target)
    self.effect:SetEffect(value)
    
    self.startTime = value:GetStartTime()
    DebugWriteLine("self.startTime - "..tostring(self.startTime))
    self.duration = value:GetDuration()
    DebugWriteLine("self.duration - "..tostring(self.duration))    
    self.endTime = (self.startTime + self.duration)
    DebugWriteLine("self.endTime - "..tostring(self.endTime))
    if (Turbine.Engine.GetGameTime() < self.endTime) then
        DebugWriteLine("self:SetWantsUpdates(true)")
        self:SetWantsUpdates(true)
    end
end

function EffectFrame:Update(args)
    local gameTime = Turbine.Engine.GetGameTime()
    local elapsedTime = gameTime - self.startTime
    local percentComplete = elapsedTime / self.duration
    
    -- update the time
    if (self.duration > 86400) then
        local time = TimeFormat(math.floor(elapsedTime))
        self.timer:SetText(time)
    else
        local remaining = self.duration - math.ceil(elapsedTime)
        local time = TimeFormat(remaining < 0 and 0 or remaining)
        self.timer:SetText(time)
        
        if (gameTime > self.endTime) then
            self.timer:SetText("inactive")
            self.effect:SetEffect()
            self:SetWantsUpdates(false)
        end        
    end
end


function TimeFormat (value)
    if (value >= 3600) then
        local sec = math.fmod(value, 3600) / 60;
        value = ("%d:%02d:%02d"):format(value / 3600, value % 3600 / 60, value % 60);
    elseif (value >= 60) then
        value = ("%d:%02d"):format(value / 60, value % 60);
    else
        value = ("0:%02d"):format(value);
    end
    return value;
end