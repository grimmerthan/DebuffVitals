local DEBUG_ENABLED = DEBUG_ENABLED

dvCommand = Turbine.ShellCommand();

function dvCommand:Execute(cmd, args)
    local arguments = {}
    for argument in args:gmatch("%S+") do table.insert(arguments, argument) end

    if DEBUG_ENABLED then Turbine.Shell.WriteLine("argument count : "..tostring(#arguments)); end

    if #arguments == 1 then
        if arguments[1] == "list" then
            Turbine.Shell.WriteLine("LIST");
        elseif arguments[1] == "help" then
            Turbine.Shell.WriteLine("HELP");
        else
            self:GetHelp()
        end
    elseif #arguments == 2 then
        if arguments[1] == "load" then
            self:Load()
        elseif arguments[1] == "save" then
            self:Save()
        elseif arguments[1] == "delete" then
            self:Delete()
        else
            self:GetHelp()
        end
    else
        self:GetHelp()
    end
end

function dvCommand:GetHelp()
    Turbine.Shell.WriteLine("GetHelpGetHelpGetHelp");
end

function dvCommand:Load()
    Turbine.Shell.WriteLine("LoadLoadLoadLoadLoad");
end

function dvCommand:Save()
    Turbine.Shell.WriteLine("SaveSaveSaveSaveSave");
end

function dvCommand:Delete()
    Turbine.Shell.WriteLine("DeleteDeleteDelete");
end

Turbine.Shell.AddCommand( "debuffvitals", dvCommand );