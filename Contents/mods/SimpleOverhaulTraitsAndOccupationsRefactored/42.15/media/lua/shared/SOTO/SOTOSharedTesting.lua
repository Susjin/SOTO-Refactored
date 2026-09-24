----------------------------------------------------------------------------------------------
--- SOTO-Refactored
--- @author: peteR_pg, hea
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- Steam profile: https://steamcommunity.com/id/heafoxyz/
--- GitHub Repository: https://github.com/Susjin/SOTO-Refactored

--- Main file with all functions related to testing the mod on both client and server
--- @class SOTOSharedTesting
local SOTOSharedTesting = {}
----------------------------------------------------------------------------------------------
--Requires
local SOTOUtility = require("SOTO/SOTOUtility")

--Pulling global to local for performance
local SOTO = SOTO


---Fully heals a door
---@param args TestingCommandArgs Data required to get the door
function SOTOSharedTesting.healDoor(args)
    ---@type IsoDoor
    local door = SOTOUtility.getObjectFromPosition(args.objectPos, "IsoDoor")
    if door then
        door:setHealth(door:getMaxHealth())
        door:sync()
    end
end

---Sets the condition of a given generator
---@param args TestingCommandArgs Data required to get the generator and the condition to be set
function SOTOSharedTesting.setGeneratorCondition(args)
    ---@type IsoGenerator
    local generator = SOTOUtility.getObjectFromPosition(args.objectPos, "IsoGenerator")
    local condition = tonumber(args.args[1])
    if generator then
        generator:setCondition(condition or 45)
        generator:sync()
    end
end






------------------ Returning file for 'require' ------------------
return SOTOSharedTesting