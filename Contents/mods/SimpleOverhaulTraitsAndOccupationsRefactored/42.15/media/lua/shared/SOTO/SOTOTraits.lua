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


-- ----------------------- Physical skills functions ----------------------- --

---Executed when a player gets a level up on Strength
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Strength(player, perk, perkLevel)
    --Lose Slack if Strength and Fitness are level 7+
    if perkLevel >= 7 and player:getPerkLevel(Perks.Fitness) >= 7 and player:hasTrait(SOTO.CharacterTrait.SLACK) then
        player:getCharacterTraits():remove(SOTO.CharacterTrait.SLACK);
        HaloTextHelper.addTextWithArrow(player, getText("UI_trait_slack"), false, HaloTextHelper.getColorGreen());
        SOTOUtility.logDebug(string.format("Removed Slack for player: %s | Triggered by trait: %s", player:getDisplayName(), perk:getType()), "SOTOTraitsByLevel", SOTOUtility.getGameMode())
    end
end

---Executed when a player gets a level up on Fitness
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Fitness(player, perk, perkLevel)
    --Lose Slack if Strength and Fitness are level 7+
    if perkLevel >= 7 and player:getPerkLevel(Perks.Strength) >= 7 and player:hasTrait(SOTO.CharacterTrait.SLACK) then
        player:getCharacterTraits():remove(SOTO.CharacterTrait.SLACK);
        HaloTextHelper.addTextWithArrow(player, getText("UI_trait_slack"), false, HaloTextHelper.getColorGreen());
        SOTOUtility.logDebug(string.format("Removed Slack for player: %s | Triggered by trait: %s", player:getDisplayName(), perk:getType()), "SOTOTraitsByLevel", SOTOUtility.getGameMode())
    end
end

---Executed when a player gets a level up on Sneak
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Sneak(player, perk, perkLevel)
    local characterTraits, change = player:getCharacterTraits(), "Did nothing"
    --Give Sneaky if Sneak level is 4+ and don't have Conspicuous
    if SOTOSandbox.AgilityTraitsObtainable == true and perkLevel >= 4 and not player:hasTrait(CharacterTrait.CONSPICUOUS) and not player:hasTrait(SOTO.CharacterTrait.SNEAKY) then
        characterTraits:add(SOTO.CharacterTrait.SNEAKY);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, getText("UI_trait_sneaky"), true, HaloTextHelper.getColorGreen());
        change = "Gave Sneaky"
    end
    --Give Sneaky if Sneak level is 5+ and have Conspicuous
    if SOTOSandbox.AgilityTraitsObtainable == true and perkLevel >= 5 and player:hasTrait(CharacterTrait.CONSPICUOUS) and not player:hasTrait(SOTO.CharacterTrait.SNEAKY) then
        characterTraits:add(SOTO.CharacterTrait.SNEAKY);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, getText("UI_trait_sneaky"), true, HaloTextHelper.getColorGreen());
        change = "Gave Sneaky"
    end
    --Give Inconspicuous if Sneak level is 6+ and don't have Conspicuous
    if SOTOSandbox.InconspicuousEarnable == true and perkLevel == 6 and not player:hasTrait(CharacterTrait.CONSPICUOUS) and not player:hasTrait(CharacterTrait.INCONSPICUOUS) then
        characterTraits:add(CharacterTrait.INCONSPICUOUS);
        HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Inconspicuous"), true, HaloTextHelper.getColorGreen());
        change = "Gave Inconspicuous"
    end
    --Lose Conspicuous if Sneak level is 7+
    if SOTOSandbox.ConspicuousRemovable == true and perkLevel == 7 and player:hasTrait(CharacterTrait.CONSPICUOUS) then
        characterTraits:remove(CharacterTrait.CONSPICUOUS);
        HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Conspicuous"), false, HaloTextHelper.getColorGreen());
        change = "Removed Conspicuous"
    end
    SOTOUtility.logDebug(string.format("%s for player: %s | Triggered by trait: %s", change, player:getDisplayName(), perk:getType()), "SOTOTraitsByLevel", SOTOUtility.getGameMode())
end

---Executed when a player gets a level up on Lightfoot
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Lightfoot(player, perk, perkLevel)
    local characterTraits, change = player:getCharacterTraits(), "Did nothing"
    --Give Lightfooted if Lightfoot level is 4+ and don't have Clumsy
    if SOTOSandbox.AgilityTraitsObtainable == true and perkLevel >= 4 and not player:hasTrait(SOTO.CharacterTrait.LIGHTFOOTED) and not player:hasTrait(CharacterTrait.CLUMSY) then
        characterTraits:add(SOTO.CharacterTrait.LIGHTFOOTED);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, getText("UI_trait_lightfooted"), true, HaloTextHelper.getColorGreen());
        change = "Gave Lightfooted"
    end
    --Give Lightfooted if Lightfoot level is 5+ and have Clumsy
    if SOTOSandbox.AgilityTraitsObtainable == true and perkLevel >= 5 and not player:hasTrait(SOTO.CharacterTrait.LIGHTFOOTED) and player:hasTrait(CharacterTrait.CLUMSY) then
        characterTraits:add(SOTO.CharacterTrait.LIGHTFOOTED);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, getText("UI_trait_lightfooted"), true, HaloTextHelper.getColorGreen());
        change = "Gave Lightfooted"
    end
    --Give Graceful if Lightfoot level is 6+ and don't have Clumsy
    if SOTOSandbox.GracefulEarnable == true and perkLevel == 6 and not player:hasTrait(CharacterTrait.CLUMSY) and not player:hasTrait(CharacterTrait.GRACEFUL) then
        characterTraits:add(CharacterTrait.GRACEFUL);
        HaloTextHelper.addTextWithArrow(player, getText("UI_trait_graceful"), true, HaloTextHelper.getColorGreen());
        change = "Gave Graceful"
    end
    --Lose Clumsy if Lightfoot level is 7
    if SOTOSandbox.ClumsyRemovable == true and perkLevel == 7 and player:hasTrait(CharacterTrait.CLUMSY) then
        characterTraits:remove(CharacterTrait.CLUMSY);
        HaloTextHelper.addTextWithArrow(player, getText("UI_trait_clumsy"), false, HaloTextHelper.getColorGreen());
        change = "Removed Clumsy"
    end
    SOTOUtility.logDebug(string.format("%s for player: %s | Triggered by trait: %s", change, player:getDisplayName(), perk:getType()), "SOTOTraitsByLevel", SOTOUtility.getGameMode())
end

---Executed when a player gets a level up on Sprinting
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Sprinting(player, perk, perkLevel)
    --Give Jogger if Sprinting level is 5+
    if SOTOSandbox.AgilityTraitsObtainable == true and perkLevel >= 5 and not player:hasTrait(CharacterTrait.JOGGER) then
        player:getCharacterTraits():add(CharacterTrait.JOGGER);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Jogger"), true, HaloTextHelper.getColorGreen());
        SOTOUtility.logDebug(string.format("Added Jogger for player: %s | Triggered by trait: %s", player:getDisplayName(), perk:getType()), "SOTOTraitsByLevel", SOTOUtility.getGameMode())
    end
end

---Executed when a player gets a level up on Nimble
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Nimble(player, perk, perkLevel)
    --Give Agile if Nimble level is 5+
    if SOTOSandbox.AgilityTraitsObtainable == true and perkLevel >= 5 and not player:hasTrait(SOTO.CharacterTrait.AGILE) then
        player:getCharacterTraits():add(SOTO.CharacterTrait.AGILE);
        SOTOTraits.addXPBoost(player, perk, 1);
        HaloTextHelper.addTextWithArrow(player, getText("UI_trait_agile"), true, HaloTextHelper.getColorGreen());
        SOTOUtility.logDebug(string.format("Added Agile for player: %s | Triggered by trait: %s", player:getDisplayName(), perk:getType()), "SOTOTraitsByLevel", SOTOUtility.getGameMode())
    end
end

-- ----------------------- Crafting|Survival skills functions ----------------------- --

---Executed when a player gets a level up on PlantScavenging
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.PlantScavenging(player, perk, perkLevel)

end

---Executed when a player gets a level up on Fishing
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Fishing(player, perk, perkLevel)

end

---Executed when a player gets a level up on Trapping
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Trapping(player, perk, perkLevel)

end

---Executed when a player gets a level up on Tracking
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Tracking(player, perk, perkLevel)

end

---Executed when a player gets a level up on Doctor
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Doctor(player, perk, perkLevel)

end

---Executed when a player gets a level up on Cooking
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Cooking(player, perk, perkLevel)

end

---Executed when a player gets a level up on Farming
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Farming(player, perk, perkLevel)

end

---Executed when a player gets a level up on Woodwork
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Woodwork(player, perk, perkLevel)

end

---Executed when a player gets a level up on Electricity
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Electricity(player, perk, perkLevel)

end

---Executed when a player gets a level up on Mechanics
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Mechanics(player, perk, perkLevel)

end

---Executed when a player gets a level up on MetalWelding
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.MetalWelding(player, perk, perkLevel)

end

---Executed when a player gets a level up on Tailoring
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Tailoring(player, perk, perkLevel)

end

---Executed when a player gets a level up on Carving
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Carving(player, perk, perkLevel)

end

---Executed when a player gets a level up on Masonry
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Masonry(player, perk, perkLevel)

end

---Executed when a player gets a level up on Pottery
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Pottery(player, perk, perkLevel)

end

---Executed when a player gets a level up on Glassmaking
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Glassmaking(player, perk, perkLevel)

end

---Executed when a player gets a level up on Blacksmith
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Blacksmith(player, perk, perkLevel)

end

---Executed when a player gets a level up on FlintKnapping
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.FlintKnapping(player, perk, perkLevel)

end

---Executed when a player gets a level up on Husbandry
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Husbandry(player, perk, perkLevel)

end

---Executed when a player gets a level up on Butchering
---@param player IsoPlayer
---@param perk PerkFactory.Perk
---@param perkLevel integer
function SOTOTraits.Butchering(player, perk, perkLevel)

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