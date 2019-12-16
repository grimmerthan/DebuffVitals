local DEBUG_ENABLED = DEBUG_ENABLED

-- ------------------------------------------------------------------------
-- EffectFrame - base UI control
-- ------------------------------------------------------------------------
EffectFrame = class (Turbine.UI.Control)

function EffectFrame:Constructor (CurrentFrame, EffectDefinition)
    Turbine.UI.Control.Constructor(self)
    
    if DEBUG_ENABLED then Turbine.Shell.WriteLine (
            table.concat({"Creating EffectFrame : ", tostring(EffectDefinition[2]), " (", tostring(EffectDefinition[5]), ")"})) end

    self.startTime = 0
    self.duration = 0
    self.endTime = 0
    self.lastSeen = nil
    self.timedType = EffectDefinition[4]

    self:SetParent(CurrentFrame)
    self:SetVisible(true)
    self:SetSize (FrameWidth, ControlHeight)     
    self:SetEnabled(false)

    self.effectDisplay = Turbine.UI.Lotro.EffectDisplay()
    self.effectDisplay:SetVisible(true)
    self.effectDisplay:SetMouseVisible(true)
    self.effectDisplay:SetParent(self)
    self.effectDisplay:SetSize(ControlHeight, ControlHeight)
    self.effectDisplay:SetPosition(0, 0)
    self.effectDisplay:SetZOrder(200)

    self.name = Turbine.UI.Label()
    self.name:SetVisible(true)
    self.name:SetParent(self)
    self.name:SetSize(FrameWidth - ControlHeight - 30, ControlHeight)
    self.name:SetPosition(ControlHeight, 0) 
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
    self.timer:SetSize(30, ControlHeight)
    self.timer:SetPosition(FrameWidth - 30, 0)
    self.timer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
    self.timer:SetFont( Turbine.UI.Lotro.Font.Verdana12 )
    self.timer:SetForeColor (Turbine.UI.Color.Gray)
    self.timer:SetText("-")
end

-- ------------------------------------------------------------------------
-- Sets the specific effect and timers
-- ------------------------------------------------------------------------
function EffectFrame:SetCurrentEffect(effect)
    self.effectDisplay:SetEffect(effect)

    self.startTime = effect:GetStartTime()
    self.duration = effect:GetDuration()
    self.endTime = (self.startTime + self.duration)
    self.name:SetForeColor (Turbine.UI.Color.White)
    self.timer:SetForeColor (Turbine.UI.Color.White)
    if self.patternMatch then
        self.name:SetText(effect:GetName())
    end
end

-- ------------------------------------------------------------------------
-- Remove an existing effect on target change or timeout
-- ------------------------------------------------------------------------
function EffectFrame:ClearCurrentEffect()
    self.startTime = 0
    self.duration = 0
    self.endTime = 0
    self.lastSeen = nil

    self.effect = nil

    -- Workaround for an issue with EffectDisplay, where the EffectDisplay persists
    --   the previous background colour, after an effect is cleared via SetEffect
    self.effectDisplay:SetVisible(false)
    self.effectDisplay = nil

    self.effectDisplay = Turbine.UI.Lotro.EffectDisplay()
    self.effectDisplay:SetVisible(true)
    self.effectDisplay:SetParent(self)
    self.effectDisplay:SetSize(ControlHeight, ControlHeight)
    self.effectDisplay:SetPosition(0, 0)  
    self.effectDisplay:SetEffect(nil)

    self.name:SetForeColor (Turbine.UI.Color.Gray)
    if self.patternMatch then
        self.name:SetText(tostring(self.effectName))
    end
    self.timer:SetText("-")
    self.timer:SetForeColor (Turbine.UI.Color.Gray)  
    
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Current effect cleared") end    
end

-- ------------------------------------------------------------------------
-- Updates timers
-- ------------------------------------------------------------------------
function EffectFrame:Update(args)
    if self.startTime > 0 then
        if self.timedType == 1 then
            self.timer:SetText("T")
        else
            local gameTime = Turbine.Engine.GetGameTime()
            local elapsedTime = gameTime - self.startTime
        
            -- update the time
            local remaining = self.duration - math.ceil(elapsedTime)
            local time = FormatTime(remaining)
            self.timer:SetText(time)
    
            if (gameTime >= self.endTime) then      
                self:ClearCurrentEffect()
            end
        end
    end
end