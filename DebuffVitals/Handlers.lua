-- ------------------------------------------------------------------------
-- Target Change Handler and Helpers
-- ------------------------------------------------------------------------
function TargetChangeHandler(sender, args)
    DebugWriteLine("Entering TargetChangeHandler...")
    DebugWriteLine("Changed target")
    for key,box in pairs(TargetFrames) do
        DebugWriteLine("ID : "..tostring(key).." value : "..tostring(box))
        TargetBox.UpdateTarget(box)
    end
    DebugWriteLine("Exiting TargetChangeHandler...")
end

-- ------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------
function MoraleChangedHandler(sender, args)
    local CurrentFrame = sender.self

    if not CurrentFrame.Target then
        DebugWriteLine("Skip MoraleChangedHandler.  No target.")
        return
    end
       
    local TargetMorale = CurrentFrame.Target:GetMorale()

    if TargetMorale <= 0 and CurrentFrame.Locked then
        CurrentFrame.Lock.MouseClick()
     end

    local TargetMaxMorale = CurrentFrame.Target:GetMaxMorale()
    local TargetTempMorale = CurrentFrame.Target:GetTemporaryMorale()
    local TargetMaxTempMorale = CurrentFrame.Target:GetMaxTemporaryMorale()

    CurrentFrame.Morale.Title:SetText(string.format("%s", FormatBigNumbers(TargetMorale))
                    .." / "..string.format("%s", FormatBigNumbers(TargetMaxMorale)).." ")

    if TargetMorale <= 1 then
        CurrentFrame.Morale.Percent:SetText(string.format("0.0%%"))
    else
        CurrentFrame.Morale.Percent:SetText(string.format("%.1f", 100 * TargetMorale / TargetMaxMorale).."%")
    end

    local BarSize = math.floor(TargetMorale/TargetMaxMorale * FrameWidth)
    CurrentFrame.Morale.Bar:SetSize(BarSize, ControlHeight)
    CurrentFrame.Morale.Bar:SetPosition(FrameWidth - BarSize, CurrentFrame.TitleBar:GetHeight())

end

-- ------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------
function PowerChangedHandler(sender, args)
    local CurrentFrame = sender.self

    if not CurrentFrame.Target then
        DebugWriteLine("Skip PowerChangedHandler.  No target.")
        return
    end
    
    local TargetPower = CurrentFrame.Target:GetPower()
    local TargetMaxPower = CurrentFrame.Target:GetMaxPower()
    local TargetTempPower = CurrentFrame.Target:GetTemporaryPower()
    local TargetMaxTempPower = CurrentFrame.Target:GetMaxTemporaryPower()
    CurrentFrame.Power.Title:SetText(string.format("%s", FormatBigNumbers(TargetPower))
                    .." / "..string.format("%s", FormatBigNumbers(TargetMaxPower)).." ")

    if TargetPower <= 1 then
        CurrentFrame.Power.Percent:SetText(string.format("0.0%%"))
    else
        CurrentFrame.Power.Percent:SetText(string.format("%.1f", 100 * TargetPower / TargetMaxPower).."%")
    end

    local BarSize = math.floor(TargetPower/TargetMaxPower * FrameWidth)
    CurrentFrame.Power.Bar:SetSize(BarSize, ControlHeight)
    CurrentFrame.Power.Bar:SetPosition(FrameWidth - BarSize, CurrentFrame.TitleBar:GetHeight() + CurrentFrame.Morale.Bar:GetHeight())

end

-- ------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------
function EffectsChangedHandler(sender, args)
    DebugWriteLine("Entering EffectsChangedHandler")

    local CurrentFrame = sender.self

    if not CurrentFrame.Target then
        DebugWriteLine("Skip... no target....")
        return
    end
   
    sender.self:SetWantsUpdates(true)
    
    DebugWriteLine("Exiting EffectsChangedHandler")
end

-- ------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------
function FormatBigNumbers(num)
    local numString = {}

    if num > 99999 and num < 1000000 then
        numString = string.format("%.1f", num / 1000).."K"
    elseif num > 999999 then
        numString = string.format("%.1f", num / 1000000).."M"
    else
        numString = tostring (math.floor(num))
    end

    return numString
end
