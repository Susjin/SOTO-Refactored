----------------------------------------------------------------------------------------------
--- SOTO-Refactored
--- @author: peteR_pg, hea
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- Steam profile: https://steamcommunity.com/id/heafoxyz/
--- GitHub Repository: https://github.com/Susjin/SOTO-Refactored


--- Main file with all functions related to the Generator Expert Trait
----------------------------------------------------------------------------------------------
--Requiring ISFixGenerator to make sure it loads first
require("TimedActions/ISFixGenerator")

--Requires
local SOTOUtility = require("SOTO/SOTOUtility")

--Pulling global to local for performance
local SOTO = SOTO


local oldISFixGenerator_complete = ISFixGenerator.complete
function ISFixGenerator:complete()
	local scrapItem = self.character:getInventory():getFirstTypeRecurse("ElectronicsScrap");

	if not scrapItem then return false; end;
	self.character:removeFromHands(scrapItem);
	self.character:getInventory():Remove(scrapItem);
	sendRemoveItemFromContainer(self.character:getInventory(), scrapItem);

	self.generator:setCondition(self.generator:getCondition() + 4 + (1*(self.character:getPerkLevel(Perks.Electricity))/2))
	addXp(self.character, Perks.Electricity, 5)

	if self.character:hasTrait(SOTO.CharacterTrait.GENERATOR_EXPERT) or self.character:hasTrait(SOTO.CharacterTrait.GENERATOR_EXPERT2) then
		self.generator:setCondition(self.generator:getCondition() + 2.5 + (1*(self.character:getPerkLevel(Perks.Electricity))/2))
		addXp(self.character, Perks.Electricity, 5)
	end

	if SOTOUtility.getGameMode() == "SP" then
		self:continueFixing()
	end

	return true
end