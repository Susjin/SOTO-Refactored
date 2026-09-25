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
--Variations
SOTOTraits.ByLevel = {}
SOTOTraits.ByLevel.location = "SOTOTraitsByLevel"

SOTOTraits.ByTime = {}
SOTOTraits.ByTime.location = "SOTOTraitsByTime"

SOTOTraits.ByTimeAndKills = {}
SOTOTraits.ByTimeAndKills.location = "SOTOTraitsByTimeAndKills"

--Requires
local SOTOUtility = require("SOTO/SOTOUtility")

--Pulling global to local for performance
local SOTO = SOTO
local SOTOSandbox = SandboxVars.SOTO
local HaloTextHelper = HaloTextHelper

--Setting up locals
local gamemode = SOTOUtility.getGameMode()

---A loggin function specific to this file
---@param actionAndPerk string What action was done and what trait was
---@param playerName string The player name
---@param trigger string What triggered the action. eg. a trait level up, zombie kills,  etc.
---@param location string Location of the function
function SOTOTraits.logDebug(actionAndPerk, playerName, trigger, location)
    SOTOUtility.logDebug(string.format("%s on player: %s | Triggered by: %s", actionAndPerk, playerName, trigger), SOTOTraits[location].location, gamemode)
end


-- ----------------------- Physical skills functions ----------------------- --

---Executed when a player gets a level up on Strength
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Strength(player, perk, perkLevel)
    --Lose Slack if Strength and Fitness are level 7+
    if perkLevel >= 7 and player:getPerkLevel(Perks.Fitness) >= 5 and player:hasTrait(SOTO.CharacterTrait.SLACK) then
        local traitName = getText("UI_trait_slack")
        player:getCharacterTraits():remove(SOTO.CharacterTrait.SLACK);
        HaloTextHelper.addTextWithArrow(player, traitName, false, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Removed " .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Fitness
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Fitness(player, perk, perkLevel)
    --Lose Slack if Strength and Fitness are level 7+
    if perkLevel >= 7 and player:getPerkLevel(Perks.Strength) >= 5 and player:hasTrait(SOTO.CharacterTrait.SLACK) then
        local traitName = getText("UI_trait_slack")
        player:getCharacterTraits():remove(SOTO.CharacterTrait.SLACK);
        HaloTextHelper.addTextWithArrow(player, traitName, false, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Removed " .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Sneak
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Sneak(player, perk, perkLevel)
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
    if SOTOSandbox.InconspicuousEarnable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.CONSPICUOUS) and not player:hasTrait(CharacterTrait.INCONSPICUOUS) then
        traitName = getText("UI_trait_Inconspicuous")
        characterTraits:add(CharacterTrait.INCONSPICUOUS);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        change = "Gave " .. traitName
    end
    --Lose Conspicuous if Sneak level is 7+
    if SOTOSandbox.ConspicuousRemovable == true and perkLevel >= 7 and player:hasTrait(CharacterTrait.CONSPICUOUS) then
        traitName = getText("UI_trait_Conspicuous")
        characterTraits:remove(CharacterTrait.CONSPICUOUS);
        HaloTextHelper.addTextWithArrow(player, traitName, false, HaloTextHelper.getColorGreen());
        change = "Removed " .. traitName
    end
    SOTOTraits.logDebug(change, player:getDisplayName(), perk:getType(), "ByLevel")
end

---Executed when a player gets a level up on Lightfoot
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Lightfoot(player, perk, perkLevel)
    local characterTraits, change, traitName = player:getCharacterTraits(), "Did nothing", ""
    --Give Lightfooted if Lightfooted level is 4+ and don't have Clumsy
    if SOTOSandbox.AgilityTraitsObtainable == true and perkLevel >= 4 and not player:hasTrait(SOTO.CharacterTrait.LIGHTFOOTED) and not player:hasTrait(CharacterTrait.CLUMSY) then
        traitName = getText("UI_trait_lightfooted")
        characterTraits:add(SOTO.CharacterTrait.LIGHTFOOTED);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        change = "Gave " .. traitName
    end
    --Give Lightfooted if Lightfooted level is 5+ and have Clumsy
    if SOTOSandbox.AgilityTraitsObtainable == true and perkLevel >= 5 and not player:hasTrait(SOTO.CharacterTrait.LIGHTFOOTED) and player:hasTrait(CharacterTrait.CLUMSY) then
        traitName = getText("UI_trait_lightfooted")
        characterTraits:add(SOTO.CharacterTrait.LIGHTFOOTED);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        change = "Gave " .. traitName
    end
    --Give Graceful if Lightfooted level is 6+ and don't have Clumsy
    if SOTOSandbox.GracefulEarnable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.CLUMSY) and not player:hasTrait(CharacterTrait.GRACEFUL) then
        traitName = getText("UI_trait_graceful")
        characterTraits:add(CharacterTrait.GRACEFUL);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        change = "Gave " .. traitName
    end
    --Lose Clumsy if Lightfooted level is 7+
    if SOTOSandbox.ClumsyRemovable == true and perkLevel >= 7 and player:hasTrait(CharacterTrait.CLUMSY) then
        traitName = getText("UI_trait_clumsy")
        characterTraits:remove(CharacterTrait.CLUMSY);
        HaloTextHelper.addTextWithArrow(player, traitName, false, HaloTextHelper.getColorGreen());
        change = "Removed " .. traitName
    end
    SOTOTraits.logDebug(change, player:getDisplayName(), perk:getType(), "ByLevel")
end

---Executed when a player gets a level up on Sprinting
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Sprinting(player, perk, perkLevel)
    --Give Jogger if Sprinting level is 5+
    if SOTOSandbox.AgilityTraitsObtainable == true and perkLevel >= 5 and not player:hasTrait(CharacterTrait.JOGGER) then
        local traitName = getText("UI_trait_Jogger")
        player:getCharacterTraits():add(CharacterTrait.JOGGER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Nimble
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Nimble(player, perk, perkLevel)
    --Give Agile if Nimble level is 5+
    if SOTOSandbox.AgilityTraitsObtainable == true and perkLevel >= 5 and not player:hasTrait(SOTO.CharacterTrait.AGILE) then
        local traitName = getText("UI_trait_agile")
        player:getCharacterTraits():add(SOTO.CharacterTrait.AGILE);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

-- ----------------------- Crafting|Survival skills functions ----------------------- --

---Executed when a player gets a level up on PlantScavenging
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.PlantScavenging(player, perk, perkLevel)
    --Give Forager if Foraging level is 6+
    if SOTOSandbox.SurvTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.FORAGER) then
        local traitName = getText("UI_trait_forager")
        player:getCharacterTraits():add(SOTO.CharacterTrait.FORAGER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Fishing
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Fishing(player, perk, perkLevel)
    --Give Angler if Fishing level is 6+
    if SOTOSandbox.SurvTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.FISHING) then
        local traitName = getText("UI_trait_Fishing")
        player:getCharacterTraits():add(CharacterTrait.FISHING);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Trapping
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Trapping(player, perk, perkLevel)
    --Give Trapper if Trapping level is 6+
    if SOTOSandbox.SurvTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.TRAPPER) then
        local traitName = getText("UI_trait_trapper")
        player:getCharacterTraits():add(SOTO.CharacterTrait.TRAPPER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Tracking
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Tracking(player, perk, perkLevel)
    --Give Tracker if Tracking level is 6+
    if SOTOSandbox.SurvTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.TRACKER) then
        local traitName = getText("UI_trait_tracker")
        player:getCharacterTraits():add(SOTO.CharacterTrait.TRACKER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Doctor
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Doctor(player, perk, perkLevel)
    --Give First Aider if First Aid level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.FIRST_AID) then
        local traitName = getText("UI_trait_FirstAid")
        player:getCharacterTraits():add(CharacterTrait.FIRST_AID);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Cooking
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Cooking(player, perk, perkLevel)
    --Give Culinary if Cooking level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.CULINARY) then
        local traitName = getText("UI_trait_culinary")
        player:getCharacterTraits():add(SOTO.CharacterTrait.CULINARY);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Farming
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Farming(player, perk, perkLevel)
    --Give Gardener if Agriculture level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.GARDENER) then
        local traitName = getText("UI_trait_Gardener")
        player:getCharacterTraits():add(CharacterTrait.GARDENER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Woodwork
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Woodwork(player, perk, perkLevel)
    --Give Woodworker if Carpentry level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.WOODWORKER) then
        local traitName = getText("UI_trait_woodworker")
        player:getCharacterTraits():add(SOTO.CharacterTrait.WOODWORKER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Electricity
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Electricity(player, perk, perkLevel)
    --Give Electrical Mechanic if Electrical level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.ELECTRICALMECHANIC) then
        local traitName = getText("UI_trait_electricalmechanic")
        player:getCharacterTraits():add(SOTO.CharacterTrait.ELECTRICALMECHANIC);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Mechanics
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Mechanics(player, perk, perkLevel)
    --Give Auto Mechanic if Mechanics level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.AUTOMECHANIC) then
        local traitName = getText("UI_trait_automechanic")
        player:getCharacterTraits():add(SOTO.CharacterTrait.AUTOMECHANIC);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on MetalWelding
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.MetalWelding(player, perk, perkLevel)
    --Give Metal Welder if Welding level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.METAL_WELDER) then
        local traitName = getText("UI_trait_metalwelder")
        player:getCharacterTraits():add(SOTO.CharacterTrait.METAL_WELDER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Tailoring
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Tailoring(player, perk, perkLevel)
    --Give Sewer if Tailoring level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.TAILOR) then
        local traitName = getText("UI_trait_Tailor")
        player:getCharacterTraits():add(CharacterTrait.TAILOR);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Carving
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Carving(player, perk, perkLevel)
    --Give Whittler if Carving level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.WHITTLER) then
        local traitName = getText("UI_trait_Whittler")
        player:getCharacterTraits():add(CharacterTrait.WHITTLER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Masonry
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Masonry(player, perk, perkLevel)
    --Give Mason if Masonry level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.MASON) then
        local traitName = getText("UI_trait_Mason")
        player:getCharacterTraits():add(CharacterTrait.MASON);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Pottery
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Pottery(player, perk, perkLevel)
    --Give Potter if Pottery level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.POTTER) then
        local traitName = getText("UI_trait_potter")
        player:getCharacterTraits():add(SOTO.CharacterTrait.POTTER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Glassmaking
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Glassmaking(player, perk, perkLevel)
    --Give Glassblower if Glassmaking level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.GLASSBLOWER) then
        local traitName = getText("UI_trait_glassblower")
        player:getCharacterTraits():add(SOTO.CharacterTrait.GLASSBLOWER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Blacksmith
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Blacksmith(player, perk, perkLevel)
    --Give Blacksmith Knowledge if Blacksmithing level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.BLACKSMITH) then
        local traitName = getText("UI_trait_Blacksmith")
        player:getCharacterTraits():add(CharacterTrait.BLACKSMITH);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on FlintKnapping
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.FlintKnapping(player, perk, perkLevel)
    --Give Knapping Basics if Knapping level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.KNAPPING_BASICS) then
        local traitName = getText("UI_trait_knappingbasics")
        player:getCharacterTraits():add(SOTO.CharacterTrait.KNAPPING_BASICS);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Husbandry
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Husbandry(player, perk, perkLevel)
    --Give Animal Friend if Animal Care level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.ANIMAL_FRIEND) then
        local traitName = getText("UI_trait_animalfriend")
        player:getCharacterTraits():add(SOTO.CharacterTrait.ANIMAL_FRIEND);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Butchering
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Butchering(player, perk, perkLevel)
    --Give Slaughterer if Butchering level is 6+
    if SOTOSandbox.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.SLAUGHTERER) then
        local traitName = getText("UI_trait_slaughterer")
        player:getCharacterTraits():add(SOTO.CharacterTrait.SLAUGHTERER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

-- ----------------------- Meele Combat Skill Functions ----------------------- --

---Executed when a player gets a level up on Maintenance
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Maintenance(player, perk, perkLevel)
    --Give Tinkerer if Maintenance level is 6+
    if SOTOSandbox.CombatTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.TINKERER) then
        local traitName = getText("UI_trait_tinkerer")
        player:getCharacterTraits():add(CharacterTrait.TINKERER);
        SOTOTraits.addXPBoost(player, Perks.Maintenance, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on SmallBlade
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.SmallBlade(player, perk, perkLevel)
    --Give Knifer if Short Blade level is 6+
    if SOTOSandbox.CombatTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.KNIFER) then
        local traitName = getText("UI_trait_knifer")
        player:getCharacterTraits():add(SOTO.CharacterTrait.KNIFER);
        SOTOTraits.addXPBoost(player, Perks.SmallBlade, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on SmallBlunt
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.SmallBlunt(player, perk, perkLevel)
    --Give Bludgeoner if Short Blunt level is 6+
    if SOTOSandbox.CombatTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.BLUDGEONER) then
        local traitName = getText("UI_trait_bludgeoner")
        player:getCharacterTraits():add(SOTO.CharacterTrait.BLUDGEONER);
        SOTOTraits.addXPBoost(player, Perks.SmallBlunt, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Axe
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Axe(player, perk, perkLevel)
    --Give Cutter if Axe level is 6+
    if SOTOSandbox.CombatTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.CUTTER) then
        local traitName = getText("UI_trait_cutter")
        player:getCharacterTraits():add(SOTO.CharacterTrait.CUTTER);
        SOTOTraits.addXPBoost(player, Perks.Axe, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Spear
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Spear(player, perk, perkLevel)
    --Give Spearman if Spears level is 6+
    if SOTOSandbox.CombatTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.SPEARMAN) then
        local traitName = getText("UI_trait_spearman")
        player:getCharacterTraits():add(SOTO.CharacterTrait.SPEARMAN);
        SOTOTraits.addXPBoost(player, Perks.Spear, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on LongBlade
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.LongBlade(player, perk, perkLevel)
    --Give Swordsman if Long Blade level is 6+
    if SOTOSandbox.CombatTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.SWORDSMAN) then
        local traitName = getText("UI_trait_swordsman")
        player:getCharacterTraits():add(SOTO.CharacterTrait.SWORDSMAN);
        SOTOTraits.addXPBoost(player, Perks.LongBlade, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

---Executed when a player gets a level up on Blunt
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Blunt(player, perk, perkLevel)
    --Give Baseball Player if Long Blunt level is 6+
    if SOTOSandbox.CombatTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.BASEBALL_PLAYER) then
        local traitName = getText("UI_trait_PlaysBaseball")
        player:getCharacterTraits():add(CharacterTrait.BASEBALL_PLAYER);
        SOTOTraits.addXPBoost(player, Perks.Blunt, 1);
        HaloTextHelper.addTextWithArrow(player, traitName, true, HaloTextHelper.getColorGreen());
        SOTOTraits.logDebug("Added" .. traitName, player:getDisplayName(), perk:getType(), "ByLevel")
    end
end

-- ----------------------- Ranged Combat Skill Functions ----------------------- --

---Executed when a player gets a level up on Aiming
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.ByLevel.Aiming(player, perk, perkLevel)
    local characterTraits, traitNameShooter, traitNameSharp, shooter, sharp = player:getCharacterTraits(), getText("UI_trait_shooter"), getText("UI_trait_expshooter"), false, false
    --Give Shooter if Aiming level is 5+, don't have Sharpshooter and have Eagle Eyed
    if SOTOSandbox.FirearmTraitsObtainable == true and perkLevel == 5 and player:hasTrait(CharacterTrait.EAGLE_EYED) and not player:hasTrait(SOTO.CharacterTrait.EXP_SHOOTER) and not player:hasTrait(SOTO.CharacterTrait.SHOOTER) then
        characterTraits:add(SOTO.CharacterTrait.SHOOTER);
        SOTOTraits.addXPBoost(player, perk, 1);
        SOTOTraits.addXPBoost(player, Perks.Reloading, 1);
        HaloTextHelper.addTextWithArrow(player, traitNameShooter, true, HaloTextHelper.getColorGreen());
        shooter = true
    end
    --Give Shooter if Aiming level is 6+ and don't have Short Sighted, Eagle Eyed and Sharpshooter
    if SOTOSandbox.FirearmTraitsObtainable == true and perkLevel == 6 and not player:hasTrait(CharacterTrait.SHORT_SIGHTED) and not player:hasTrait(CharacterTrait.EAGLE_EYED) and not player:hasTrait(SOTO.CharacterTrait.EXP_SHOOTER) and not player:hasTrait(SOTO.CharacterTrait.SHOOTER) then
        characterTraits:add(SOTO.CharacterTrait.SHOOTER);
        SOTOTraits.addXPBoost(player, perk, 1);
        SOTOTraits.addXPBoost(player, Perks.Reloading, 1);
        HaloTextHelper.addTextWithArrow(player, traitNameShooter, true, HaloTextHelper.getColorGreen());
        shooter = true
    end
    --Give Shooter if Aiming level is 7+, don't have Sharpshooter and have Short Sighted
    if SOTOSandbox.FirearmTraitsObtainable == true and perkLevel == 7 and player:hasTrait(CharacterTrait.SHORT_SIGHTED) and not player:hasTrait(SOTO.CharacterTrait.EXP_SHOOTER) and not player:hasTrait(SOTO.CharacterTrait.SHOOTER) then
        characterTraits:add(SOTO.CharacterTrait.SHOOTER);
        SOTOTraits.addXPBoost(player, perk, 1);
        SOTOTraits.addXPBoost(player, Perks.Reloading, 1)
        HaloTextHelper.addTextWithArrow(player, traitNameShooter, true, HaloTextHelper.getColorGreen())
        shooter = true
    end

    --Give Sharpshooter if Aiming level is 7+, have Eagle Eyed and Shooter
    if SOTOSandbox.FirearmTraitsObtainable == true and perkLevel == 7 and player:hasTrait(CharacterTrait.EAGLE_EYED) and player:hasTrait(SOTO.CharacterTrait.SHOOTER) and not player:hasTrait(SOTO.CharacterTrait.EXP_SHOOTER)then
        characterTraits:add(SOTO.CharacterTrait.EXP_SHOOTER);
        characterTraits:remove(SOTO.CharacterTrait.SHOOTER);
        SOTOTraits.addXPBoost(player, perk, 1);
        SOTOTraits.addXPBoost(player, Perks.Reloading, 1);
        HaloTextHelper.addTextWithArrow(player, traitNameSharp, true, HaloTextHelper.getColorGreen());
        sharp = true
    end
    --Give Sharpshooter if Aiming level is 8+, have Shooter and don't have Short Sighted and Eagle Eyed
    if SOTOSandbox.FirearmTraitsObtainable == true and perkLevel == 8 and not player:hasTrait(CharacterTrait.SHORT_SIGHTED) and not player:hasTrait(CharacterTrait.EAGLE_EYED) and player:hasTrait(SOTO.CharacterTrait.SHOOTER) and not player:hasTrait(SOTO.CharacterTrait.EXP_SHOOTER)then
        characterTraits:add(SOTO.CharacterTrait.EXP_SHOOTER);
        characterTraits:remove(SOTO.CharacterTrait.SHOOTER);
        SOTOTraits.addXPBoost(player, perk, 1);
        SOTOTraits.addXPBoost(player, Perks.Reloading, 1);
        HaloTextHelper.addTextWithArrow(player, traitNameSharp, true, HaloTextHelper.getColorGreen());
        sharp = true
    end
    --Give Sharpshooter if Aiming level is 9+, have Short Sighted and Shooter
    if SOTOSandbox.FirearmTraitsObtainable == true and perkLevel == 9 and player:hasTrait(CharacterTrait.SHORT_SIGHTED) and player:hasTrait(SOTO.CharacterTrait.SHOOTER) and not player:hasTrait(SOTO.CharacterTrait.EXP_SHOOTER)then
        characterTraits:add(SOTO.CharacterTrait.EXP_SHOOTER);
        characterTraits:remove(SOTO.CharacterTrait.SHOOTER);
        SOTOTraits.addXPBoost(player, perk, 1);
        SOTOTraits.addXPBoost(player, Perks.Reloading, 1);
        HaloTextHelper.addTextWithArrow(player, traitNameSharp, true, HaloTextHelper.getColorGreen());
        sharp = true
    end
    if sharp or shooter then
        SOTOTraits.logDebug("Added" .. shooter and traitNameShooter or traitNameSharp, player:getDisplayName(), perk:getType(), "ByLevel")
    end
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