-- ------------------------------------------------------------------------
-- Loads any saved settings
-- ------------------------------------------------------------------------
function LoadSettings()
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering LoadEffects...") end
    local count = 1
    
    local settings = PatchDataLoad(Turbine.DataScope.Character, "DebuffVitals", nil);

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

        if settings.TrackedEffects ~=nil then
            for k, v in ipairs (settings.TrackedEffects) do
                local found = false
                if DEBUG_ENABLED then Turbine.Shell.WriteLine("Loading  in "..tostring(v[1]).." / "..tostring(v[2])..
                                " / "..tostring(v[3]).." / "..tostring(v[4]).." / "..tostring(v[5])) end
                for key, value in ipairs (TrackedEffects) do
                    if value[2] == v[2] then
                        value[3] = v[3]
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
    end

    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting LoadEffects...") end   
end    

-- ------------------------------------------------------------------------
-- Save settings / character
-- ------------------------------------------------------------------------
function SaveSettings()
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering SaveSettings...") end
    settings = {}
    settings.FramePositions = {}
    settings.TrackedEffects = TrackedEffects
    settings.FrameWidth = FrameWidth
    settings.ControlHeight = ControlHeight
    settings.LockedPosition = LockedPosition
    settings.SaveFramePositions = SaveFramePositions
    if settings.SaveFramePositions then
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("{v:GetPosition()}") end
        for k, v in pairs (TargetFrames) do
            settings.FramePositions[k] = {v:GetPosition()}
        end
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("{v:GetPosition()}") end
    end
    settings.ShowMorale = ShowMorale
    settings.ShowPower = ShowPower
    
    PatchDataSave(Turbine.DataScope.Character, "DebuffVitals", settings, nil);
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting SaveSettings...") end
end

-- ------------------------------------------------------------------------
-- Creates the subset of effects that will be monitored
-- ------------------------------------------------------------------------
function GenerateEnabledSet()
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering GenerateEnabledSet...") end
    local count = 1    
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("TrackedEffects count "..tostring(#TrackedEffects)) end
    
    EffectsSet = {}
    
    local effects = TrackedEffects
    for k, v in ipairs (effects) do   
        if v[3] == 1 then 
            if DEBUG_ENABLED then Turbine.Shell.WriteLine("Adding in "..tostring(v[1]).." / "..tostring(v[2])..
                        " / "..tostring(v[3]).." / "..tostring(v[4]).." / "..tostring(v[5])) end
            EffectsSet[count] = {v[1], v[2], v[3], v[4], v[5]}
            count = count + 1
        end
    end

    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting GenerateEnabledSet...") end
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
