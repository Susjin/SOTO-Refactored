if not getDebug() then return end

---@alias integer number


local function debugSOTO(message)
    print("DebugSOTO:" .. message)
end

---@param player IsoPlayer
local function changeWeaponDoorDamage(player, value)
    local weapon = player:getUseHandWeapon()
    --local weaponItem = weapon and weapon:getScriptItem() or nil

    
    if weapon then
        debugSOTO("current damage: " .. tostring(weapon:getDoorDamage()))
        weapon:setDoorDamage(value)
        weapon:setCriticalChance(100)
    end
    
    weapon:syncItemFields()
end

---@param door IsoDoor
local function healDoorDamage(door)
    if door then
        door:setHealth(door:getMaxHealth())
    end
end


---@param playerIndex integer
---@param contextMenu ISContextMenu
---@param worldObjects table
local function onSOTOContextMenu(playerIndex, contextMenu, worldObjects)
    local player = getSpecificPlayer(playerIndex)
    local door
    for i = 1, #worldObjects do
        if instanceof(worldObjects[i], "IsoDoor") then
            door = worldObjects[i]
            break
        end
    end

    contextMenu:addOption("SOTO: Heal Door", door, healDoorDamage)

    local weaponSubMenuOption = contextMenu:addOption("SOTO: Weapon door damage", worldObjects, nil)
    local weaponSubMenu = contextMenu:getNew(contextMenu)

    contextMenu:addSubMenu(weaponSubMenuOption, weaponSubMenu)

    weaponSubMenu:addOption("35", player, changeWeaponDoorDamage, 35)
    weaponSubMenu:addOption("50", player, changeWeaponDoorDamage, 50)
    weaponSubMenu:addOption("75", player, changeWeaponDoorDamage, 75)
    weaponSubMenu:addOption("100", player, changeWeaponDoorDamage, 100)

    

end


Events.OnFillWorldObjectContextMenu.Add(onSOTOContextMenu)