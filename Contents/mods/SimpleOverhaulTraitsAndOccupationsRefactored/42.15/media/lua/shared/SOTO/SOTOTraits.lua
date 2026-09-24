----------------------------------------------------------------------------------------------
--- SOTO-Refactored
--- @author: peteR_pg, hea
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- Steam profile: https://steamcommunity.com/id/heafoxyz/
--- GitHub Repository: https://github.com/Susjin/SOTO-Refactored

--- Main file with all functions to add traits to players
--- @class SOTOTraits
local SOTOTraits = {}
----------------------------------------------------------------------------------------------
--Requires
local SOTOUtility = require("SOTO/SOTOUtility")

--Pulling global to local for performance
local SOTO = SOTO
local SOTOSandbox = SandboxVars.SOTO

--Setting up locals
local gamemode = SOTOUtility.getGameMode()
local locationByLevel = "SOTOTraitsByLevel"

---A loggin function specific to this file
---@param actionAndPerk string What action was done and what trait was
---@param playerName string The player name
---@param trigger string What triggered the action. eg. a trait level up, zombie kills,  etc.
function SOTOTraits.logDebug(actionAndPerk, playerName, trigger)
    SOTOUtility.logDebug(string.format("%s on player: %s | Triggered by: %s", actionAndPerk, playerName, trigger), locationByLevel, gamemode)
end


-- ----------------------- Physical skills functions ----------------------- --

---Executed when a player gets a level up on Strength
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Strength(player, perk, perkLevel)
    --Lose Slack if Strength and Fitness are level 7+
    if perkLevel >= 7 and player:getPerkLevel(Perks.Fitness) >= 7 and player:hasTrait(SOTO.CharacterTrait.SLACK) then
        local traitName = getText("UI_trait_slack")
        player:getCharacterTraits():remove(SOTO.CharacterTrait.SLACK);
        HaloTextHelper.addTextWithArrow(player, traitName, false, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Removed " .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Fitness
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Fitness(player, perk, perkLevel)
    --Lose Slack if Strength and Fitness are level 7+
    if perkLevel >= 7 and player:getPerkLevel(Perks.Strength) >= 7 and player:hasTrait(SOTO.CharacterTrait.SLACK) then
        local traitName = getText("UI_trait_slack")
        player:getCharacterTraits():remove(SOTO.CharacterTrait.SLACK);
        HaloTextHelper.addTextWithArrow(player, traitName, false, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Removed " .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Sneak
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Sneak(player, perk, perkLevel)
    local characterTraits, change, traitName = player:getCharacterTraits(), "Did nothing", ""
    --Give Sneaky if Sneak level is 4+ and don't have Conspicuous
    if SOTOSandbox.AgilityTraitsObtainable == true and perkLevel >= 4 and not player:hasTrait(CharacterTrait.CONSPICUOUS) and not player:hasTrait(SOTO.CharacterTrait.SNEAKY) then
        traitName = getText("UI_trait_sneaky")
        characterTraits:add(SOTO.CharacterTrait.SNEAKY);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        change = "Gave " .. traitName
    end
    --Give Sneaky if Sneak level is 5+ and have Conspicuous
    if SOTOSandbox.AgilityTraitsObtainable == true and perkLevel >= 5 and player:hasTrait(CharacterTrait.CONSPICUOUS) and not player:hasTrait(SOTO.CharacterTrait.SNEAKY) then
        traitName = getText("UI_trait_sneaky")
        characterTraits:add(SOTO.CharacterTrait.SNEAKY);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        change = "Gave " .. traitName
    end
    --Give Inconspicuous if Sneak level is 6+ and don't have Conspicuous
    if SOTOSandbox.InconspicuousEarnable == true and perkLevel == 6 and not player:hasTrait(CharacterTrait.CONSPICUOUS) and not player:hasTrait(CharacterTrait.INCONSPICUOUS) then
        traitName = getText("UI_trait_Inconspicuous")
        characterTraits:add(CharacterTrait.INCONSPICUOUS);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        change = "Gave " .. traitName
    end
    --Lose Conspicuous if Sneak level is 7+
    if SOTOSandbox.ConspicuousRemovable == true and perkLevel == 7 and player:hasTrait(CharacterTrait.CONSPICUOUS) then
        traitName = getText("UI_trait_Conspicuous")
        characterTraits:remove(CharacterTrait.CONSPICUOUS);
        HaloTextHelper.addTextWithArrow(player, traitName, false, HaloTextHelper.getColorGreen());
        change = "Removed " .. traitName
    end
    SOTOTraits.logDebug(change, player:getDisplayName(), perk:getType())
end

---Executed when a player gets a level up on Lightfoot
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Lightfoot(player, perk, perkLevel)
    local characterTraits, change, traitName = player:getCharacterTraits(), "Did nothing", ""
    --Give Lightfooted if Lightfoot level is 4+ and don't have Clumsy
    if SOTOSandbox.AgilityTraitsObtainable == true and perkLevel >= 4 and not player:hasTrait(SOTO.CharacterTrait.LIGHTFOOTED) and not player:hasTrait(CharacterTrait.CLUMSY) then
        traitName = getText("UI_trait_lightfooted")
        characterTraits:add(SOTO.CharacterTrait.LIGHTFOOTED);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        change = "Gave " .. traitName
    end
    --Give Lightfooted if Lightfoot level is 5+ and have Clumsy
    if SOTOSandbox.AgilityTraitsObtainable == true and perkLevel >= 5 and not player:hasTrait(SOTO.CharacterTrait.LIGHTFOOTED) and player:hasTrait(CharacterTrait.CLUMSY) then
        traitName = getText("UI_trait_lightfooted")
        characterTraits:add(SOTO.CharacterTrait.LIGHTFOOTED);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        change = "Gave " .. traitName
    end
    --Give Graceful if Lightfoot level is 6+ and don't have Clumsy
    if SOTOSandbox.GracefulEarnable == true and perkLevel == 6 and not player:hasTrait(CharacterTrait.CLUMSY) and not player:hasTrait(CharacterTrait.GRACEFUL) then
        traitName = getText("UI_trait_graceful")
        characterTraits:add(CharacterTrait.GRACEFUL);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        change = "Gave " .. traitName
    end
    --Lose Clumsy if Lightfoot level is 7
    if SOTOSandbox.ClumsyRemovable == true and perkLevel == 7 and player:hasTrait(CharacterTrait.CLUMSY) then
        traitName = getText("UI_trait_clumsy")
        characterTraits:remove(CharacterTrait.CLUMSY);
        HaloTextHelper.addTextWithArrow(player, traitName, false, HaloTextHelper.getColorGreen());
        change = "Removed " .. traitName
    end
    SOTOTraits.logDebug(change, player:getDisplayName(), perk:getType())
end

---Executed when a player gets a level up on Sprinting
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Sprinting(player, perk, perkLevel)
    --Give Jogger if Sprinting level is 5+
    if SOTOSandbox.AgilityTraitsObtainable == true and perkLevel >= 5 and not player:hasTrait(CharacterTrait.JOGGER) then
        local traitName = getText("UI_trait_Jogger")
        player:getCharacterTraits():add(CharacterTrait.JOGGER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Nimble
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Nimble(player, perk, perkLevel)
    --Give Agile if Nimble level is 5+
    if SOTOSandbox.AgilityTraitsObtainable == true and perkLevel >= 5 and not player:hasTrait(SOTO.CharacterTrait.AGILE) then
        local traitName = getText("UI_trait_agile")
        player:getCharacterTraits():add(SOTO.CharacterTrait.AGILE);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

-- ----------------------- Crafting|Survival skills functions ----------------------- --

---Executed when a player gets a level up on PlantScavenging
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.PlantScavenging(player, perk, perkLevel)
    --Give Forager if Foraging level is 6+
    if SOTOSandbox.SurvTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.FORAGER) then
        local traitName = getText("UI_trait_forager")
        player:getCharacterTraits():add(SOTO.CharacterTrait.FORAGER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Fishing
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Fishing(player, perk, perkLevel)
    --Give Angler if Fishing level is 6+
    if SOTOSandbox.SurvTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.FISHING) then
        local traitName = getText("UI_trait_Fishing")
        player:getCharacterTraits():add(CharacterTrait.FISHING);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Trapping
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Trapping(player, perk, perkLevel)
    --Give Trapper if Trapping level is 6+
    if SOTOSandbox.SurvTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.TRAPPER) then
        local traitName = getText("UI_trait_trapper")
        player:getCharacterTraits():add(SOTO.CharacterTrait.TRAPPER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Tracking
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Tracking(player, perk, perkLevel)
    --Give Tracker if Tracking level is 6+
    if SOTOSandbox.SurvTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.TRACKER) then
        local traitName = getText("UI_trait_tracker")
        player:getCharacterTraits():add(SOTO.CharacterTrait.TRACKER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Doctor
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Doctor(player, perk, perkLevel)
    --Give First Aider if First Aid level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.FIRST_AID) then
        local traitName = getText("UI_trait_FirstAid")
        player:getCharacterTraits():add(CharacterTrait.FIRST_AID);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Cooking
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Cooking(player, perk, perkLevel)
    --Give Culinary if Cooking level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.CULINARY) then
        local traitName = getText("UI_trait_culinary")
        player:getCharacterTraits():add(SOTO.CharacterTrait.CULINARY);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Farming
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Farming(player, perk, perkLevel)
    --Give Gardener if Agriculture level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.GARDENER) then
        local traitName = getText("UI_trait_Gardener")
        player:getCharacterTraits():add(CharacterTrait.GARDENER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Woodwork
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Woodwork(player, perk, perkLevel)
    --Give Woodworker if Carpentry level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.WOODWORKER) then
        local traitName = getText("UI_trait_woodworker")
        player:getCharacterTraits():add(SOTO.CharacterTrait.WOODWORKER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Electricity
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Electricity(player, perk, perkLevel)
    --Give Electrical Mechanic if Electrical level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.ELECTRICALMECHANIC) then
        local traitName = getText("UI_trait_electricalmechanic")
        player:getCharacterTraits():add(SOTO.CharacterTrait.ELECTRICALMECHANIC);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Mechanics
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Mechanics(player, perk, perkLevel)
    --Give Auto Mechanic if Mechanics level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.AUTOMECHANIC) then
        local traitName = getText("UI_trait_automechanic")
        player:getCharacterTraits():add(SOTO.CharacterTrait.AUTOMECHANIC);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on MetalWelding
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.MetalWelding(player, perk, perkLevel)
    --Give Metal Welder if Welding level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.METAL_WELDER) then
        local traitName = getText("UI_trait_metalwelder")
        player:getCharacterTraits():add(SOTO.CharacterTrait.METAL_WELDER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Tailoring
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Tailoring(player, perk, perkLevel)
    --Give Sewer if Tailoring level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.TAILOR) then
        local traitName = getText("UI_trait_Tailor")
        player:getCharacterTraits():add(CharacterTrait.TAILOR);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Carving
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Carving(player, perk, perkLevel)
    --Give Whittler if Carving level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.WHITTLER) then
        local traitName = getText("UI_trait_Whittler")
        player:getCharacterTraits():add(CharacterTrait.WHITTLER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Masonry
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Masonry(player, perk, perkLevel)
    --Give Mason if Masonry level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.MASON) then
        local traitName = getText("UI_trait_Mason")
        player:getCharacterTraits():add(CharacterTrait.MASON);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Pottery
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Pottery(player, perk, perkLevel)
    --Give Potter if Pottery level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.POTTER) then
        local traitName = getText("UI_trait_potter")
        player:getCharacterTraits():add(SOTO.CharacterTrait.POTTER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Glassmaking
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Glassmaking(player, perk, perkLevel)
    --Give Glassblower if Glassmaking level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.GLASSBLOWER) then
        local traitName = getText("UI_trait_glassblower")
        player:getCharacterTraits():add(SOTO.CharacterTrait.GLASSBLOWER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Blacksmith
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Blacksmith(player, perk, perkLevel)
    --Give Blacksmith Knowledge if Blacksmithing level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.BLACKSMITH) then
        local traitName = getText("UI_trait_Blacksmith")
        player:getCharacterTraits():add(CharacterTrait.BLACKSMITH);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on FlintKnapping
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.FlintKnapping(player, perk, perkLevel)
    --Give Knapping Basics if Knapping level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.KNAPPING_BASICS) then
        local traitName = getText("UI_trait_knappingbasics")
        player:getCharacterTraits():add(SOTO.CharacterTrait.KNAPPING_BASICS);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Husbandry
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Husbandry(player, perk, perkLevel)
    --Give Animal Friend if Animal Care level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.ANIMAL_FRIEND) then
        local traitName = getText("UI_trait_animalfriend")
        player:getCharacterTraits():add(SOTO.CharacterTrait.ANIMAL_FRIEND);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

---Executed when a player gets a level up on Butchering
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Butchering(player, perk, perkLevel)
    --Give Slaughterer if Butchering level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.SLAUGHTERER) then
        local traitName = getText("UI_trait_slaughterer")
        player:getCharacterTraits():add(SOTO.CharacterTrait.SLAUGHTERER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType())
    end
end

-- ----------------------- Meele Combat Skill Functions ----------------------- --

---Executed when a player gets a level up on Maintenance
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Maintenance(player, perk, perkLevel)

end

---Executed when a player gets a level up on SmallBlade
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.SmallBlade(player, perk, perkLevel)

end

---Executed when a player gets a level up on SmallBlunt
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.SmallBlunt(player, perk, perkLevel)

end

---Executed when a player gets a level up on Axe
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Axe(player, perk, perkLevel)

end

---Executed when a player gets a level up on Spear
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Spear(player, perk, perkLevel)

end

---Executed when a player gets a level up on LongBlade
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.LongBlade(player, perk, perkLevel)

end

---Executed when a player gets a level up on Blunt
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Blunt(player, perk, perkLevel)

end

-- ----------------------- Ranged Combat Skill Functions ----------------------- --

---Executed when a player gets a level up on Aiming
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Aiming(player, perk, perkLevel)

end


-- ----------------------- Extra Functions ----------------------- --

---Adds a skill XP boost to a given player. If it pass 3 points of boost, default to maximum (3)
---@param player IsoPlayer The player to add the boost
---@param perk PerkFactory.Perk What skill will get the boost
---@param boostAmount integer What extra boost amount will be given
function SOTOTraits.addXPBoost(player, perk, boostAmount)
    local playerXP = player:getXp()
    local currentXPBoost = playerXP:getPerkBoost(perk);
    local newBoost = currentXPBoost + boostAmount;
    if newBoost > 3 then
        playerXP:setPerkBoost(perk, 3);
    else
        playerXP:setPerkBoost(perk, newBoost);
    end
end

------------------ Returning file for 'require' ------------------
return SOTOTraits