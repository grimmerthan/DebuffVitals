local DEBUG_ENABLED = DEBUG_ENABLED
local DEFAULT_EFFECTS = DEFAULT_EFFECTS
-- ------------------------------------------------------------------------
-- Loads saved settings
-- ------------------------------------------------------------------------
function LoadSettings(name)
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering LoadEffects...") end

    local settings = PatchDataLoad(Turbine.DataScope.Character, "DebuffVitals", name);

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
        frame.EnabledEffectsToggles = {}
        for kk = 1, #TargetFrames[k].EnabledEffectsToggles do
            toggle = {TargetFrames[k].EnabledEffectsToggles[kk][1], TargetFrames[k].EnabledEffectsToggles[kk][2]}
            frame.EnabledEffectsToggles[#frame.EnabledEffectsToggles + 1] = toggle
        end
        currentsettings.Frames[#currentsettings.Frames + 1] = frame
    end    
    return currentsettings
end