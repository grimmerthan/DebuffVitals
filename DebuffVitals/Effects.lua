-- ------------------------------------------------------------------------
-- 
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
-- 
-- ------------------------------------------------------------------------
function SaveSettings(panel)
    settings = {}
    settings.TrackedEffects = TrackedEffects
    settings.FrameWidth = panel.widthScrollBar:GetValue()
    settings.ControlHeight = panel.heightScrollBar:GetValue()
    
    Turbine.PluginData.Save(Turbine.DataScope.Character, "DebuffVitals", settings, nil);
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