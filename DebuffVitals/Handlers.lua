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
    
    CurrentFrame.Morale.Title:SetText(string.format("%d", FormatMoraleAndPower(TargetMorale))
                    .." / "..string.format("%d", FormatMoraleAndPower(TargetMaxMorale)).." ")

    if TargetMorale <= 1 then
        CurrentFrame.Morale.Percent:SetText(string.format("0.0%%"))
    else
        CurrentFrame.Morale.Percent:SetText(string.format("%.1f", 100 * TargetMorale / TargetMaxMorale).."%")
    end

    local BarSize = math.floor(TargetMorale/TargetMaxMorale * DEFAULT_WIDTH)
    CurrentFrame.Morale.Bar:SetSize(BarSize, DEFAULT_HEIGHT)
    CurrentFrame.Morale.Bar:SetPosition(DEFAULT_WIDTH - BarSize, CurrentFrame.TitleBar:GetHeight())

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
    CurrentFrame.Power.Title:SetText(string.format("%d", FormatMoraleAndPower(TargetPower))
                    .." / "..string.format("%d", FormatMoraleAndPower(TargetMaxPower)).." ")

    if TargetPower <= 1 then
        CurrentFrame.Power.Percent:SetText(string.format("0.0%%"))
    else
        CurrentFrame.Power.Percent:SetText(string.format("%.1f", 100 * TargetPower / TargetMaxPower).."%")
    end

    local BarSize = math.floor(TargetPower/TargetMaxPower * DEFAULT_WIDTH)
    CurrentFrame.Power.Bar:SetSize(BarSize, DEFAULT_HEIGHT)
    CurrentFrame.Power.Bar:SetPosition(DEFAULT_WIDTH - BarSize, CurrentFrame.TitleBar:GetHeight() + CurrentFrame.Morale.Bar:GetHeight())

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
function FormatMoraleAndPower(num)

    return num
end