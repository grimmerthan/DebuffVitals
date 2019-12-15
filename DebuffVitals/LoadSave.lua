local DEBUG_ENABLED = DEBUG_ENABLED
local DEFAULT_EFFECTS = DEFAULT_EFFECTS
-- ------------------------------------------------------------------------
-- Loads saved settings
-- ------------------------------------------------------------------------
function LoadSettings(name)
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering LoadEffects...") end

    local settings = PatchDataLoad(Turbine.DataScope.Character, "DebuffVitals", name);

    for k = 1, #DEFAULT_EFFECTS do
        TrackedEffects[#TrackedEffects +1 ] = {DEFAULT_EFFECTS[k][1], DEFAULT_EFFECTS[k][2], DEFAULT_EFFECTS[k][3], 
                                               DEFAULT_EFFECTS[k][4], DEFAULT_EFFECTS[k][5]}
    end

    if settings then 
        ActivateSettings(settings)
        if settings.TargetFrameSets ~= nil then  
            TargetFrameSets = settings.TargetFrameSets
        end   
    end

    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting LoadEffects...") end
end    

-- ------------------------------------------------------------------------
-- Activates loaded settings
-- ------------------------------------------------------------------------
function ActivateSettings(settings)
    if settings.FrameWidth then
        FrameWidth = settings.FrameWidth
    end

    if settings.ControlHeight then
        ControlHeight = settings.ControlHeight
    end
    
    if settings.EffectsModulus then
        EffectsModulus = settings.EffectsModulus
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

-- ------------------------------------------------------------------------
-- Save settings / character
-- ------------------------------------------------------------------------
function SaveSettings(name)
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering SaveSettings...") end

    local currentSettings = CaptureSettings()
    currentSettings.TargetFrameSets = TargetFrameSets
    
    PatchDataSave(Turbine.DataScope.Character, "DebuffVitals", currentSettings, name);
    
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting SaveSettings...") end
end

-- ------------------------------------------------------------------------
-- Record the current settings
-- ------------------------------------------------------------------------
function CaptureSettings()
    local currentsettings = {}
    currentsettings.TrackedEffects = TrackedEffects
    currentsettings.FrameWidth = FrameWidth
    currentsettings.ControlHeight = ControlHeight
    currentsettings.LockedPosition = LockedPosition
    currentsettings.EffectsModulus = EffectsModulus
    currentsettings.SaveFramePositions = SaveFramePositions
    currentsettings.Frames = {}
    for k = 1, #TargetFrames do
        local frame = {}
        frame.ShowMorale = TargetFrames[k].ShowMorale
        frame.ShowPower = TargetFrames[k].ShowPower
        frame.ShowEffects = TargetFrames[k].ShowEffects
        frame.Position = {TargetFrames[k]:GetPosition()}
        frame.EnabledEffectsToggles = TargetFrames[k].EnabledEffectsToggles
        currentsettings.Frames[#currentsettings.Frames + 1] = frame
    end
    return currentsettings
end