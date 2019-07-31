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
        else
            self:GetHelp()
        end
    else
        self:GetHelp()
    end
end

function dvCommand:List()
    Turbine.Shell.WriteLine("ListListListListList");
    local SettingsNames = {}
    for k, v in pairs (TargetFrameSets) do              
        SettingsNames[#SettingsNames+1] = k
    end
    table.sort(SettingsNames) 
    for k, v in pairs (SettingsNames) do
        if DEBUG_ENABLED then Turbine.Shell.WriteLine("name: "..tostring(v)); end
    end
end

function dvCommand:GetHelp()
    Turbine.Shell.WriteLine("GetHelpGetHelpGetHelp");
end

function dvCommand:Activate(SetName)
    Turbine.Shell.WriteLine("ActivateActivateActivate");
    if TargetFrameSets[SetName] ~= nil then
        ActivateSettings (TargetFrameSets[SetName])
        CreateFramesFromLoad()        
    end
end

function dvCommand:Record(SetName)
    Turbine.Shell.WriteLine("RecordRecordRecord");
    TargetFrameSets[SetName] = CaptureSettings()
end

function dvCommand:Remove(SetName)
    Turbine.Shell.WriteLine("RemoveRemoveRemove");
    if TargetFrameSets[SetName] ~= nil then
        TargetFrameSets[SetName] = nil
    end
end

Turbine.Shell.AddCommand( "debuffvitals;dbv", dvCommand );