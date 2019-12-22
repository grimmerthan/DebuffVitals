local DEBUG_ENABLED = DEBUG_ENABLED

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

-- ------------------------------------------------------------------------
-- Simple recursive table print.  This does not handle circular tables.   
-- ------------------------------------------------------------------------
function tablePrint (tbl, indent)
    if not indent then 
        indent = 0
    end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            if DEBUG_ENABLED then Turbine.Shell.WriteLine (tostring(formatting)) end
            tablePrint(v, indent + 2)
        else
            if DEBUG_ENABLED then Turbine.Shell.WriteLine (tostring(formatting) .. tostring(v)) end
        end
    end
end