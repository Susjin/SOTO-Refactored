----------------------------------------------------------------------------------------------
--- SOTO-Refactored
--- @author: peteR_pg
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- GitHub Repository: https://github.com/Susjin/SOTO-Refactored

--- Main file with all functions related to PLACEHOLDER
--- @class SOTOWeaponModifier
local SOTOWeaponModifier = {}
----------------------------------------------------------------------------------------------
--Requires
local SOTOUtility = require("SOTOUtility")

--Pulling global to local for performance
local SOTO = SOTO


---Sets specific weapon stats for Strong Grip and Break-in Technique traits
---@param weapon HandWeapon Weapon to be changed
---@param weaponItemScript Item The script related to that weapon
---@param doorDamage number? Door damage to be set
---@param enduranceModifier number? Endurance modifier to be set
---@param attackWithLowestEndurance boolean? If the weapon can be used with the lowest amount of endurance
function SOTOWeaponModifier.setWeaponStats(weapon, weaponItemScript, doorDamage, enduranceModifier, attackWithLowestEndurance)
    if not weapon or not weapon:isEquipped() then return end

    if weaponItemScript then
        local originalDoorDamage = weaponItemScript:getDoorDamage()
        local originalEnduranceModifier = weaponItemScript:getEnduranceMod()
        local originalAttackWithLowestEndurance = weaponItemScript:isCantAttackWithLowestEndurance()

        weapon:setDoorDamage(doorDamage and (originalDoorDamage * doorDamage) or originalDoorDamage)
        weapon:setEnduranceMod(enduranceModifier or originalEnduranceModifier)
        weapon:setCantAttackWithLowestEndurance(attackWithLowestEndurance or originalAttackWithLowestEndurance)
    end
    --Sync every change
    weapon:syncItemFields()
end

---main
---@param player IsoPlayer
---@param weapon HandWeapon?
function SOTOWeaponModifier.main(player, weapon)
    if not player and instanceof(player, "IsoPlayer") then return end

    weapon = weapon or player:getUseHandWeapon()
    if not weapon or weapon:hasTag(ItemTag.BARE_HANDS) then return end
    local itemScript = weapon:getScriptItem()
    if not itemScript then return end
    local swingAnimation = itemScript:getSwingAnim()

    if swingAnimation and swingAnimation == "Heavy" then
        if player:hasTrait(SOTO.CharacterTrait.STRONG_GRIP) then
            --Do not change door damage, reduce endurance cost and allow to always use the weapon
            SOTOWeaponModifier.setWeaponStats(weapon, itemScript, nil, 1, false)
            SOTOUtility.logDebug(string.format("Strong Grip: Updated weapon stats for %s", itemScript:getFullName()), "SOTOWeaponModifier.main", SOTOUtility.getGameMode())
        else
            SOTOWeaponModifier.setWeaponStats(weapon, itemScript)
            SOTOUtility.logDebug(string.format("Strong Grip: Reset weapon stats for %s", itemScript:getFullName()), "SOTOWeaponModifier.main", SOTOUtility.getGameMode())
        end
    end

    if itemScript:containsWeaponCategory(WeaponCategory.AXE) then
        if player:hasTrait(SOTO.CharacterTrait.BREAK_IN_TECHNIQUE) then
            --Give 50% plus door damage, and don't change the rest
            SOTOWeaponModifier.setWeaponStats(weapon, itemScript, 1.5)
            SOTOUtility.logDebug(string.format("Break-in Technique: Updated weapon stats for %s", itemScript:getFullName()), "SOTOWeaponModifier.main", SOTOUtility.getGameMode())
        else
            SOTOWeaponModifier.setWeaponStats(weapon, itemScript)
            SOTOUtility.logDebug(string.format("Break-in Technique: Reset weapon stats for %s", itemScript:getFullName()), "SOTOWeaponModifier.main", SOTOUtility.getGameMode())
        end
    end
end




------------------ Returning file for 'require' ------------------
return SOTOWeaponModifier