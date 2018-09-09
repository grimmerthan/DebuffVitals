-- ------------------------------------------------------------------------
-- Debug output
-- ------------------------------------------------------------------------
function DebugWriteLine (message)
    if DEBUG_ENABLED then
        Turbine.Shell.WriteLine(message)
    end
end
