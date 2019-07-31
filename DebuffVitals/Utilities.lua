local DEBUG_ENABLED = DEBUG_ENABLED

-- ------------------------------------------------------------------------
-- Creates the subset of effects that will be monitored
-- ------------------------------------------------------------------------
function GenerateEnabledSet()
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering GenerateEnabledSet...") end  

    EffectsSet = {}

    for k = 1, #TrackedEffects do   
        if TrackedEffects[k][3] == 1 then 
            EffectsSet[#EffectsSet + 1] = {TrackedEffects[k][1], TrackedEffects[k][2], TrackedEffects[k][3], 
                                           TrackedEffects[k][4], TrackedEffects[k][5]}
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