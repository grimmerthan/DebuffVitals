local DEBUG_ENABLED = DEBUG_ENABLED

-- ------------------------------------------------------------------------
-- Add a new frame, from right-click context menu
-- ------------------------------------------------------------------------
function AddNewTarget(LoadedFrame)
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering AddNewTargetFrame...") end
    FrameID = FrameID + 1

    local NewFrame = TargetFrame(FrameID, LoadedFrame)

    TargetFrame.UpdateTarget(NewFrame)

    TargetFrames[#TargetFrames + 1] = NewFrame

    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting AddNewTargetFrame...") end
end

-- ------------------------------------------------------------------------
-- Delete a specific frame, from right-click context menu
-- ------------------------------------------------------------------------
function RemoveTarget(ID)
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering RemoveTargetFrame...") end

    for k = 1, #TargetFrames do
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("TargetFrames[k].ID: "..tostring(TargetFrames[k].ID).. " | ID: "..tostring(ID)) end
        if TargetFrames[k].ID == ID then
            if not TargetFrames[k].Locked then
                TargetFrames[k]:SetVisible(false)
                table.remove(TargetFrames, k)
            end
            break
        end
    end
    collectgarbage()
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting RemoveTargetFrame...") end
end

-- ------------------------------------------------------------------------
-- Clear the current set of frames and apply a new set
-- ------------------------------------------------------------------------
function CreateFrames()
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering CreateFrames...") end

    FrameID = 0
 
    for k = 1, #TargetFrames do
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("deleting k: "..tostring(k)) end        
        TargetFrames[k]:SetVisible(false)
        TargetFrames[k] = nil
    end
    collectgarbage()

    if #loadedFrames > 0 then
        GenerateEffectsSetFromLoad()
        for k = 1, #loadedFrames do
            AddNewTarget(loadedFrames[k]) 
        end
    else
        GenerateEffectsSetFromTrackedEffects()
        AddNewTarget()
    end

    FrameMenu:CreateEffectsMenu()

    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting CreateFrames...") end
end

-- ------------------------------------------------------------------------
-- Creates the subset of effects that will be monitored.  EnabledEffectsToggles
--     is used to build this subset, as this holds the list of interesting effects.
-- ------------------------------------------------------------------------
function GenerateEffectsSetFromLoad()
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering GenerateEffectsSetFromLoad...") end  

    EffectsSet = {}

    -- Set all TrackedEffects to disabled and re-enable for EnabledEffectsToggles
    for k = 1, #TrackedEffects do
        TrackedEffects[k][3] = 0
    end

    -- Look at the single frame and set that TrackedEffect (and panel checkbox) to enabled
    for k = 1, #loadedFrames[1].EnabledEffectsToggles do
        local currentToggle = loadedFrames[1].EnabledEffectsToggles[k]
        for k = 1, #TrackedEffects do
            if TrackedEffects[k][2] == currentToggle[1] then 
                EffectsSet[#EffectsSet + 1] = {TrackedEffects[k][1], TrackedEffects[k][2], 1, 
                                               TrackedEffects[k][4], TrackedEffects[k][5]}  
                TrackedEffects[k][3] = 1
            end
        end
    end

    OP:SetCheckboxes()

    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting GenerateEffectsSetFromLoad...") end
end


-- ------------------------------------------------------------------------
-- Creates the subset of effects that will be monitored
-- ------------------------------------------------------------------------
function GenerateEffectsSetFromTrackedEffects()
    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Entering OptionsPanel:GenerateEffectsSetFromTrackedEffects...") end  

    EffectsSet = {}

    for k = 1, #TrackedEffects do   
        if TrackedEffects[k][3] == 1 then 
            EffectsSet[#EffectsSet + 1] = {TrackedEffects[k][1], TrackedEffects[k][2], TrackedEffects[k][3], 
                                           TrackedEffects[k][4], TrackedEffects[k][5]}
        end
    end

    if DEBUG_ENABLED then Turbine.Shell.WriteLine("Exiting OptionsPanel:GenerateEffectsSetFromTrackedEffects...") end
end