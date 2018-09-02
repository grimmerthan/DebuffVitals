-- ------------------------------------------------------------------------
-- Debug output
-- ------------------------------------------------------------------------
DebugEnabled = true

function DebugWriteLine (message)
    if DebugEnabled then
        Turbine.Shell.WriteLine(message)
    end
end
