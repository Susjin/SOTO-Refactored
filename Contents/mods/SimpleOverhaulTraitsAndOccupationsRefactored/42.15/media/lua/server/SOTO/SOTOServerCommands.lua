----------------------------------------------------------------------------------------------
--- SOTO-Refactored
--- @author: peteR_pg
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- GitHub Repository: https://github.com/Susjin/SOTO-Refactored

--- Main file with all functions related to Server Commands
--- @class SOTOServerCommands
local SOTOServerCommands = {}
----------------------------------------------------------------------------------------------
--Requires
local SOTOUtility = require("SOTOUtility")
local SOTOWeaponModifier = require("SOTO/SOTOWeaponModifier")

--Pulling global to local for performance
local pairs = pairs

---WeaponModifier
---@param player IsoPlayer
---@param args table
function SOTOServerCommands.WeaponModifier(player, args)
    SOTOWeaponModifier.main(player)
end











--[[Main command function]]--

---Run on a client command is received
---@param module string To check if the command is from SOTO
---@param command string What function to execute
---@param player IsoPlayer The player that sent the command
---@param args table All arguments for the command
local function onClientCommand(module, command, player, args)
    if module == "SOTO" and SOTOServerCommands[command] and player then
        local printArgs = string.format("Received client command [%s] from player: %s, with args: ", command, player:getDisplayName())
        if args and not table.isempty(args) then
            for i, arg in pairs(args) do
                printArgs = string.format("%s[%s]%s, ", printArgs, tostring(i), tostring(arg))
            end
        else
            printArgs = string.format("%sNo arguments provided.", printArgs)
        end
        SOTOUtility.logDebug(printArgs, "[onClientCommand]", SOTOUtility.getGameMode())
        SOTOServerCommands[command](player, args)
    end
end

Events.OnClientCommand.Add(onClientCommand)

------------------ Returning file for 'require' ------------------
return SOTOServerCommands