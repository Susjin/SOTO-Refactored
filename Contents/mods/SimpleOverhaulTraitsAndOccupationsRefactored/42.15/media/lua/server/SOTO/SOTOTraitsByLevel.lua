----------------------------------------------------------------------------------------------
--- SOTO-Refactored
--- @author: peteR_pg, hea
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- Steam profile: https://steamcommunity.com/id/heafoxyz/
--- GitHub Repository: https://github.com/Susjin/SOTO-Refactored

--- Main file with all functions related to traits that are gained by time
--- @class SOTOTraitsByLevel
local SOTOTraitsByLevel = {}
----------------------------------------------------------------------------------------------
--Requires
local SOTOUtility = require("SOTO/SOTOUtility")
local SOTOTraits = require("SOTO/SOTOTraits")

--Pulling global to local for performance
local SOTOSandbox = SandboxVars.SOTO


---Executed every time a player gets a level up on a skill
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel number
function SOTOTraitsByLevel.main(player, perk, perkLevel)
    local perkType = perk:getType()
    if SOTOTraits[perkType] then
        SOTOTraits[perkType](player, perk, perkLevel)
    else
        SOTOUtility.logDebug(string.format("Function for perk %s not found", perkType), SOTOTraits.ByLevel.location, SOTOUtility.getGameMode())
    end
end

Events.LevelPerk.Add(SOTOTraitsByLevel.main)

------------------ Returning file for 'require' ------------------
return SOTOTraitsByLevel