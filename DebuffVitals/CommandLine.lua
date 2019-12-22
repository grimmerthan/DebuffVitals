local DEBUG_ENABLED = DEBUG_ENABLED

dvCommand = Turbine.ShellCommand();

-- ------------------------------------------------------------------------
-- Command line structure and handling
-- ------------------------------------------------------------------------
function dvCommand:Execute(cmd, args)
    local arguments = {}

    if DEBUG_ENABLED then Turbine.Shell.WriteLine("#: "..tostring(#args).." args : "..tostring(args)); end
      
    for argument in args:gmatch("%S+") do   
        table.insert(arguments, argument) 
    end

    if DEBUG_ENABLED then Turbine.Shell.WriteLine("#: "..tostring(#arguments)); end

    if #arguments == 1 then
        if arguments[1] == "list" then
            self:List()
        elseif arguments[1] == "save" then
            SaveSettings()            
        else
            self:GetHelp()
        end
    elseif #arguments == 2 then
        if arguments[1] == "load" then
            self:Load(arguments[2])
        elseif arguments[1] == "delete" then
            self:Delete(arguments[2])
        elseif arguments[1] == "save" and arguments[2] == "settings" then
            SaveSettings()
        elseif arguments[1] == "save" then
            self:SaveConfig(arguments[2])
        else
            self:GetHelp()
        end
    else
        self:GetHelp()
    end
end

-- ------------------------------------------------------------------------
-- List any stored sets of frames
-- ------------------------------------------------------------------------
function dvCommand:List()
    local SettingsNames = {}
    for k, v in pairs (TargetFrameSets) do              
        SettingsNames[#SettingsNames+1] = k      
    end
    table.sort(SettingsNames) 
    Turbine.Shell.WriteLine("dbv - stored configurations: "..tostring(#SettingsNames));
    for k, v in pairs (SettingsNames) do
        Turbine.Shell.WriteLine("  "..tostring(v));
    end
end

-- ------------------------------------------------------------------------
-- Show help 
-- ------------------------------------------------------------------------
function dvCommand:GetHelp()
    Turbine.Shell.WriteLine("usage: /debuffvitals|dbv [save <name> | list | load <name> | delete <name>] | help | save settings");
end

-- ------------------------------------------------------------------------
-- Load a specific stored set of frames
-- ------------------------------------------------------------------------
function dvCommand:Load(SetName)
    if TargetFrameSets[SetName] ~= nil then
        ActivateSettings (TargetFrameSets[SetName])
        CreateFrames()
    else
        Turbine.Shell.WriteLine("dbv - no configuration matches '"..tostring(SetName).."'");
    end
end

-- ------------------------------------------------------------------------
-- Save a specific set of frames
-- ------------------------------------------------------------------------
function dvCommand:SaveConfig(SetName)
    TargetFrameSets[SetName] = CaptureSettings()
    Turbine.Shell.WriteLine("dbv - saved configuration as '"..tostring(SetName).."'");
    SaveSettings()    
end

-- ------------------------------------------------------------------------
-- Delete a specific set of frames
-- ------------------------------------------------------------------------
function dvCommand:Delete(SetName)
    if TargetFrameSets[SetName] ~= nil then
        TargetFrameSets[SetName] = nil
        Turbine.Shell.WriteLine("dbv - removed configuration named '"..tostring(SetName).."'");
        SaveSettings()
    end
end

Turbine.Shell.AddCommand( "debuffvitals;dbv", dvCommand );