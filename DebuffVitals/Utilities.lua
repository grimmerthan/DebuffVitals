-- ------------------------------------------------------------------------
-- Loads any saved settings
-- ------------------------------------------------------------------------
function LoadSettings()
    DebugWriteLine("Entering LoadEffects...")
    local count = 1
    
    local settings = Turbine.PluginData.Load(Turbine.DataScope.Character, "DebuffVitals", nil);

    for k, v in ipairs (DEFAULT_EFFECTS) do
        TrackedEffects[count] = {v[1], v[2], v[3], v[4], v[5]}
        count = count + 1
    end

    if settings then
        if settings.FrameWidth then
            FrameWidth = settings.FrameWidth
        end
        
        if settings.ControlHeight then
            ControlHeight = settings.ControlHeight
        end

        if settings.PreloadedCount then
            PreLoadedCount = settings.PreloadedCount
        end

        if settings.LockedPosition ~= nil then
            LockedPosition = settings.LockedPosition
        end 

        if settings.SaveFramePositions ~= nil then
            SaveFramePositions = settings.SaveFramePositions
        end
        
        if settings.FramePositions then
            FramePositions = settings.FramePositions
        end
        
        if settings.ShowMorale ~= nil then
            ShowMorale = settings.ShowMorale
        end

        if settings.ShowPower ~= nil then
            ShowPower = settings.ShowPower
        end

        for k, v in ipairs (settings.TrackedEffects) do
            local found = false
            DebugWriteLine("Loading  in "..tostring(v[1]).." / "..tostring(v[2])..
                            " / "..tostring(v[3]).." / "..tostring(v[4]).." / "..tostring(v[5]))
            for key, value in ipairs (TrackedEffects) do
                if value[2] == v[2] then
                    value[1] = v[1]
                    value[3] = v[3]
                    value[4] = v[4]
                    value[5] = v[5]
                    found = true
                    break
                end
            end
            if not found then
                TrackedEffects[count] = {v[1], v[2], v[3], v[4], v[5]}
                count = count + 1        
            end
        end 
    end

    DebugWriteLine("Exiting LoadEffects...")    
end    

-- ------------------------------------------------------------------------
-- Save settings / character
-- ------------------------------------------------------------------------
function SaveSettings(panel)
    DebugWriteLine("Entering SaveSettings...")
    settings = {}
    settings.FramePositions = {}
    settings.TrackedEffects = TrackedEffects
    settings.FrameWidth = panel.WidthScrollBar:GetValue()
    settings.ControlHeight = panel.HeightScrollBar:GetValue()
    settings.PreloadedCount = math.floor(panel.PreloadScrollBar:GetValue()/2)
    settings.LockedPosition = panel.LockedPosition:IsChecked()
    settings.SaveFramePositions = panel.SaveFramePositions:IsChecked()
    if settings.SaveFramePositions then
        DebugWriteLine("{v:GetPosition()}")
        for k, v in pairs (TargetFrames) do
            settings.FramePositions[k] = {v:GetPosition()}
        end
        DebugWriteLine("{v:GetPosition()}") 
    end
    settings.ShowMorale = panel.ShowMorale:IsChecked()
    settings.ShowPower = panel.ShowPower:IsChecked()
    
    Turbine.PluginData.Save(Turbine.DataScope.Character, "DebuffVitals", settings, nil);
    DebugWriteLine("Exiting SaveSettings...")    
end

-- ------------------------------------------------------------------------
-- Creates the subset of effects that will be monitored
-- ------------------------------------------------------------------------
function GenerateEnabledSet()
    DebugWriteLine("Entering GenerateEnabledSet...")
    local count = 1    
    DebugWriteLine("TrackedEffects count "..tostring(#TrackedEffects))
    
    EffectsSet = {}
    
    for k, v in ipairs (TrackedEffects) do   
        if v[3] == 1 then 
            DebugWriteLine("Adding in "..tostring(v[1]).." / "..tostring(v[2])..
                        " / "..tostring(v[3]).." / "..tostring(v[4]).." / "..tostring(v[5]))    
            EffectsSet[count] = {v[1], v[2], v[3], v[4], v[5]}
            count = count + 1
        end
    end
    DebugWriteLine("Exiting GenerateEnabledSet...")    
end

-- ------------------------------------------------------------------------
-- Returns formatted time values
-- ------------------------------------------------------------------------
function FormatTime (value)
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

-- ------------------------------------------------------------------------
-- Returns a shortened number, for less wide frames   
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
