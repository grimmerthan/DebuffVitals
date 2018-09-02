-- ------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------
function LoadEffects()
    DebugWriteLine("Entering LoadEffects...")
    local count = 1
    
    local SavedEffects = Turbine.PluginData.Load(Turbine.DataScope.Character, "DebuffVitals", nil);
    
    DebugWriteLine("SavedEffects : "..tostring(SavedEffects))
    
    for k, v in ipairs (SavedEffects or DEFAULT_EFFECTS) do
        DebugWriteLine("Loading  in "..tostring(v[1]).." / "..tostring(v[2])..
                        " / "..tostring(v[3]).." / "..tostring(v[4]).." / "..tostring(v[5]))
        TrackedEffects[count] = {v[1], v[2], v[3], v[4], v[5]}
        count = count + 1
    end
    DebugWriteLine("Exiting LoadEffects...")    
end    

-- ------------------------------------------------------------------------
-- 
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