local DEBUG_ENABLED = DEBUG_ENABLED
local DEFAULT_EFFECTS = DEFAULT_EFFECTS
-- ------------------------------------------------------------------------
-- Loads saved settings
-- ------------------------------------------------------------------------
function LoadSettings(name)
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering LoadEffects...") end
    local loadedFrames = {}    
    local settings = PatchDataLoad(Turbine.DataScope.Character, "DebuffVitals", name);

    for k = 1, #DEFAULT_EFFECTS do
        table.insert(TrackedEffects, {DEFAULT_EFFECTS[k][1], DEFAULT_EFFECTS[k][2], DEFAULT_EFFECTS[k][3], 
                                      DEFAULT_EFFECTS[k][4], DEFAULT_EFFECTS[k][5]} )
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

        if settings.TrackedEffects ~=nil then
            for k = 1, #settings.TrackedEffects do
                for kk = 1, #TrackedEffects do
                    if TrackedEffects[kk][2] == settings.TrackedEffects[k][2] then
                        TrackedEffects[kk][3] = settings.TrackedEffects[k][3]
                        break
                    end
                end
            end
        end

        if settings.Frames ~= nil then
            loadedFrames = settings.Frames
        end
    end

    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting LoadEffects...") end

    return loadedFrames    
end    

-- ------------------------------------------------------------------------
-- Save settings / character
-- ------------------------------------------------------------------------
function SaveSettings(name)
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering SaveSettings...") end
    settings = {}
    settings.FramePositions = {}
    settings.TrackedEffects = TrackedEffects
    settings.FrameWidth = FrameWidth
    settings.ControlHeight = ControlHeight
    settings.LockedPosition = LockedPosition
    settings.SaveFramePositions = SaveFramePositions
    settings.Frames = {}
    for k = 1, #TargetFrames do
        local frame = {}
        frame.ShowMorale = TargetFrames[k].ShowMorale
        frame.ShowPower = TargetFrames[k].ShowPower
        frame.ShowEffects = TargetFrames[k].ShowEffects
        frame.Position = {TargetFrames[k]:GetPosition()}
        frame.EnabledEffectsToggles = TargetFrames[k].EnabledEffectsToggles
        table.insert (settings.Frames, frame)
    end
    PatchDataSave(Turbine.DataScope.Character, "DebuffVitals", settings, name);
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting SaveSettings...") end
end
