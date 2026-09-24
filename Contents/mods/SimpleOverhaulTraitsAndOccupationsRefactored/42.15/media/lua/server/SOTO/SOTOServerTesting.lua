----------------------------------------------------------------------------------------------
--- SOTO-Refactored
--- @author: peteR_pg, hea
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- Steam profile: https://steamcommunity.com/id/heafoxyz/
--- GitHub Repository: https://github.com/Susjin/SOTO-Refactored

--- Main file with all functions related to testing the mod on server
--- @class SOTOServerTesting
local SOTOServerTesting = {}
----------------------------------------------------------------------------------------------
--Requires
local SOTOUtility = require("SOTO/SOTOUtility")
local SOTOSharedTesting = require("SOTO/SOTOSharedTesting")

--Pulling global to local for performance
local pairs = pairs

-- ----------------------- All Server Commands ----------------------- --

---Fully heals a door
---@param player IsoPlayer Player that sent the command
---@param args TestingCommandArgs Data required to get the door
function SOTOServerTesting.healDoor(player, args)
    SOTOSharedTesting.healDoor(args)
end

---Sets the condition of a given generator
---@param player IsoPlayer Player that sent the command
---@param args TestingCommandArgs Data required to get the generator and the condition to be set
function SOTOServerTesting.setGeneratorCondition(player, args)
    SOTOSharedTesting.setGeneratorCondition(args)
end




-- ----------------------- Main command function ----------------------- --

---Run once a client command is received
---@param module string To check if the command is from SOTO
---@param command string What function to execute
---@param player IsoPlayer The player that sent the command
---@param args table All arguments for the command
local function onClientCommand(module, command, player, args)
    if module == "SOTOTesting" and SOTOServerTesting[command] and player then
        local printArgs = string.format("Received client command [%s] from player: %s, with args: ", command, player:getDisplayName())
        if args and not table.isempty(args) then
            for i, arg in pairs(args) do
                printArgs = string.format("%s[%s]%s, ", printArgs, tostring(i), tostring(arg))
            end
        else
            printArgs = string.format("%sNo arguments provided.", printArgs)
        end
        SOTOUtility.logDebug(printArgs, "SOTOServerTesting", SOTOUtility.getGameMode())
        SOTOServerTesting[command](player, args)
    end
end

Events.OnClientCommand.Add(onClientCommand)

------------------ Returning file for 'require' ------------------
return SOTOServerTesting