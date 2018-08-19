-- ------------------------------------------------------------------------
-- Target Change Handler and Helpers
-- ------------------------------------------------------------------------
function TargetChangeHandler(sender, args)
    Turbine.Shell.WriteLine("Entering TargetChangeHandler...")
    Turbine.Shell.WriteLine("Changed target")
    for key,box in pairs(targets) do
        Turbine.Shell.WriteLine("ID : "..tostring(key).." value : "..tostring(box))
        TargetBox.UpdateTarget(box)
    end
    Turbine.Shell.WriteLine("Exiting TargetChangeHandler...")
end


function MoraleChangedHandler(sender, args)
    Turbine.Shell.WriteLine("Entering MoraleChanged")
    local CurrentFrame = sender.self

    if not CurrentFrame.Target then
        Turbine.Shell.WriteLine("Skip... no target....")
        return
    end
       
    Turbine.Shell.WriteLine("Morale changing....")
    local TargetMorale = CurrentFrame.Target:GetMorale()
    Turbine.Shell.WriteLine("Name "..tostring(CurrentFrame.Target:GetName()).." Morale "..tostring(CurrentFrame.Target:GetMorale()))

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

    Turbine.Shell.WriteLine("Exiting MoraleChanged")
end


function PowerChangedHandler(sender, args)
    Turbine.Shell.WriteLine("Entering PowerChanged")
    local CurrentFrame = sender.self

    if not CurrentFrame.Target then
        Turbine.Shell.WriteLine("Skip... no target....")
        return
    end
    
    Turbine.Shell.WriteLine("Power changing....")
    local TargetPower = CurrentFrame.Target:GetPower()
    Turbine.Shell.WriteLine("Name "..tostring(CurrentFrame.Target:GetName()).." Power "..tostring(CurrentFrame.Target:GetPower()))
        
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

    Turbine.Shell.WriteLine("Exiting PowerChanged")
end

function EffectsChangedHandler(sender, args)
    Turbine.Shell.WriteLine("Entering EffectsChangedHandler")

    local CurrentFrame = sender.self

    if not CurrentFrame.Target then
        Turbine.Shell.WriteLine("Skip... no target....")
        return
    end
   
    sender.self:SetWantsUpdates(true)
    
    Turbine.Shell.WriteLine("Exiting EffectsChangedHandler")
end
