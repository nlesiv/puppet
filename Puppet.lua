_addon.author = 'Nobody'
_addon.name = 'puppet'
_addon.commands = {'puppet'}
_addon.version = '2022.12.12'

texts = require('texts')
strings = require("strings");
tables = require("tables");

admin = {
    "Hipolymer",
    "Dryend",
    "Spankey",
    "Sluhore",
    "Smollz",
    "Aprel"
}

STATE = {
    IDLE = 0,
    ENGAGED = 1,
    RESTING = 2,
    DEAD = 3,
    ZONING = 4
}


local COMMANDS = {}
COMMANDS["invite"] = function(command, sender) invite(sender) end
COMMANDS["release"] = function(command, sender) onReleaseComand(command) end
COMMANDS["summon"] = function(command, sender) onSummonCommand(command) end
COMMANDS["disband"] = function(command, sender) onDisbadParty(command) end

function onChatMessage(message, sender, mode, gm)
    print(sender, message, mode)



    if mode ~= 3 then return end

    if (not isAdmin(sender)) then return false end

    executeRemoteCommand(message, sender);

end

function isAdmin(name)

    for i, v in pairs(admin) do
        if name == v then return true end
    end
    return false;
end

function executeRemoteCommand(params, sender)


    local commands = params:split(' ');

    local command = table.remove(commands, 1);

    local fn = COMMANDS[command];

    print("Remote Command", command, commands);

    if (not fn) then return end

    fn(commands, sender);
end

function invite(player)
    local command = '/pcmd add ' .. player;
    windower.send_command("input " .. command);

end
function onDisbadParty()

    local command = "/pcmd breakup";
    windower.send_command("input " .. command);
end

function onReleaseComand(params)
    print("onReleaseComand()", params)
    local trust = table.remove(params, 1);

    if (not trust) then
        -- Relase All
        releaseAllTrusts()
    end

    -- Release a specific trust.
    releaseTrust(trust)
end

function releaseAllTrusts()
    windower.send_command("input /retr all")
    return true;
end

windower.register_event('chat message', onChatMessage)
