----------------------------------------------------------------------------------------------
--- SOTO-Refactored
--- @author: peteR_pg
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- GitHub Repository: https://github.com/Susjin/SOTO-Refactored

--- Overrides the isTraitEnabled function to allow for the new sleep related traits to be enabled/disabled based on server settings.
----------------------------------------------------------------------------------------------
--Pulling global to local for performance
local SOTO = SOTO

local _ = CharacterCreationProfession.isTraitEnabled
function CharacterCreationProfession:isTraitEnabled(trait)
    if trait:getType() == CharacterTrait.INSOMNIAC 
      or trait:getType() == CharacterTrait.NEEDS_LESS_SLEEP 
      or trait:getType() == CharacterTrait.NEEDS_MORE_SLEEP 
      or trait:getType() == SOTO.CharacterTrait.OWLPERSON
      or trait:getType() == SOTO.CharacterTrait.LARKPERSON
      then
        return not isMultiplayer() or (getServerOptions():getBoolean("SleepAllowed") and getServerOptions():getBoolean("SleepNeeded"))
    end
    return true
end