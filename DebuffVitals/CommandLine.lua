local DEBUG_ENABLED = DEBUG_ENABLED

dvCommand = Turbine.ShellCommand();

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
        else
            self:GetHelp()
        end
    elseif #arguments == 2 then
        if arguments[1] == "activate" then
            self:Activate(arguments[2])
        elseif arguments[1] == "record" then
            self:Record(arguments[2])
        elseif arguments[1] == "remove" then
            self:Remove(arguments[2])
        elseif arguments[1] == "save" and arguments[2] == "settings" then
            SaveSettings()
        else
            self:GetHelp()
        end
    else
        self:GetHelp()
    end
end

function dvCommand:List()
    local SettingsNames = {}
    for k, v in pairs (TargetFrameSets) do              
        SettingsNames[#SettingsNames+1] = k      
    end
    table.sort(SettingsNames) 
    Turbine.Shell.WriteLine("dbv - saved configurations: "..tostring(#SettingsNames));
    for k, v in pairs (SettingsNames) do
        Turbine.Shell.WriteLine("  "..tostring(v));
    end
end

function dvCommand:GetHelp()
    Turbine.Shell.WriteLine("usage: /debuffvitals|dbv [help | save settings | list | activate <name> | record <name> | remove <name>]");
end

function dvCommand:Activate(SetName)
    if TargetFrameSets[SetName] ~= nil then
        ActivateSettings (TargetFrameSets[SetName])
        CreateFrames()
    else
        Turbine.Shell.WriteLine("dbv - no configuration matches '"..tostring(SetName).."'");
    end
end

function dvCommand:Record(SetName)
    TargetFrameSets[SetName] = CaptureSettings()
    Turbine.Shell.WriteLine("dbv - recorded configuration as '"..tostring(SetName).."'");
    Turbine.Shell.WriteLine("dbv - to persist changes, use 'dbv save settings'");    
end

function dvCommand:Remove(SetName)
    if TargetFrameSets[SetName] ~= nil then
        TargetFrameSets[SetName] = nil
        Turbine.Shell.WriteLine("dbv - removed configuration named '"..tostring(SetName).."'");
    Turbine.Shell.WriteLine("dbv - to persist changes, use 'dbv save settings'");
    end
end

Turbine.Shell.AddCommand( "debuffvitals;dbv", dvCommand );