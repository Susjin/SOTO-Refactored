----------------------------------------------------------------------------------------------
--- SOTO-Refactored
--- @author: peteR_pg
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- GitHub Repository: https://github.com/Susjin/SOTO-Refactored

--- Main file with all functions related to PLACEHOLDER
--- @class SOTOWeaponModifierClient
local SOTOWeaponModifierClient = {}
----------------------------------------------------------------------------------------------
--Requires
local SOTOUtility = require("SOTOUtility")
local SOTOWeaponModifier = require("SOTO/SOTOWeaponModifier")


---changePlayerWeaponStats
---@param playerNumOrCharacter IsoGameCharacter|number The player that triggered the event
---@param item InventoryItem The equipped item
function SOTOWeaponModifierClient.changePlayerWeaponStats(playerNumOrCharacter, item)
    if not playerNumOrCharacter then return end

    --Getting player from args
    local player
    if type(playerNumOrCharacter) == "number" then player = getSpecificPlayer(playerNumOrCharacter) end
    if instanceof(playerNumOrCharacter, "IsoPlayer") then player = playerNumOrCharacter end

    --Getting the item weapon
    local weapon
    if item and instanceof(item, "HandWeapon") then weapon = item end

    local gamemode = SOTOUtility.getGameMode()
    if gamemode == SOTOUtility.GameMode.SP then
        SOTOWeaponModifier.main(player, weapon)
    elseif gamemode == SOTOUtility.GameMode.MP_CLIENT then
        sendClientCommand(player, "SOTO", "WeaponModifier", {})
    end
end

Events.OnEquipPrimary.Add(SOTOWeaponModifierClient.changePlayerWeaponStats)
Events.OnEquipSecondary.Add(SOTOWeaponModifierClient.changePlayerWeaponStats)
Events.OnCreatePlayer.Add(SOTOWeaponModifierClient.changePlayerWeaponStats)

------------------ Returning file for 'require' ------------------
return SOTOWeaponModifierClient