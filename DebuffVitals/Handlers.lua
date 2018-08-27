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


function MoraleChangedHandler(sender, args)
--    DebugWriteLine("Entering MoraleChangedHandler")
    local CurrentFrame = sender.self

    if not CurrentFrame.Target then
        DebugWriteLine("Skip MoraleChangedHandler.  No target.")
        return
    end
       
--    DebugWriteLine("Morale changing....")
    local TargetMorale = CurrentFrame.Target:GetMorale()
--    DebugWriteLine("Name "..tostring(CurrentFrame.Target:GetName()).." Morale "..tostring(CurrentFrame.Target:GetMorale()))

    if TargetMorale <= 0 and CurrentFrame.Locked then
        CurrentFrame.Lock.MouseClick()
     end

    local TargetMaxMorale = CurrentFrame.Target:GetMaxMorale()
    local TargetTempMorale = CurrentFrame.Target:GetTemporaryMorale()
    local TargetMaxTempMorale = CurrentFrame.Target:GetMaxTemporaryMorale()
    CurrentFrame.Morale.Title:SetText(string.format("%d", TargetMorale).." / "..string.format("%d", TargetMaxMorale).." ")

    if TargetMorale <= 1 then
        CurrentFrame.Morale.Percent:SetText(string.format("0.0%%"))
    else
        CurrentFrame.Morale.Percent:SetText(string.format("%.1f", 100 * TargetMorale / TargetMaxMorale).."%")
    end

    local BarSize = math.floor(TargetMorale/TargetMaxMorale * 200)
    CurrentFrame.Morale.Bar:SetSize(BarSize, 20)
    CurrentFrame.Morale.Bar:SetPosition(200 - BarSize, 21)

--    DebugWriteLine("Exiting MoraleChangedHandler")
end


function PowerChangedHandler(sender, args)
--    DebugWriteLine("Entering PowerChangedHandler")
    local CurrentFrame = sender.self

    if not CurrentFrame.Target then
        DebugWriteLine("Skip PowerChangedHandler.  No target.")
        return
    end
    
--    DebugWriteLine("Power changing....")
    local TargetPower = CurrentFrame.Target:GetPower()
--    DebugWriteLine("Name "..tostring(CurrentFrame.Target:GetName()).." Power "..tostring(CurrentFrame.Target:GetPower()))
        
    local TargetMaxPower = CurrentFrame.Target:GetMaxPower()
    local TargetTempPower = CurrentFrame.Target:GetTemporaryPower()
    local TargetMaxTempPower = CurrentFrame.Target:GetMaxTemporaryPower()
    CurrentFrame.Power.Title:SetText(string.format("%d", TargetPower).." / "..string.format("%d", TargetMaxPower).." ")

    if TargetPower <= 1 then
        CurrentFrame.Power.Percent:SetText(string.format("0.0%%"))
    else
        CurrentFrame.Power.Percent:SetText(string.format("%.1f", 100 * TargetPower / TargetMaxPower).."%")
    end

    local BarSize = math.floor(TargetPower/TargetMaxPower * 200)
    CurrentFrame.Power.Bar:SetSize(BarSize, 20)
    CurrentFrame.Power.Bar:SetPosition(200 - BarSize, 42)

--    DebugWriteLine("Exiting PowerChangedHandler")
end

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
