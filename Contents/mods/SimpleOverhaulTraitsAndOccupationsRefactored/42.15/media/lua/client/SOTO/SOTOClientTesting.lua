----------------------------------------------------------------------------------------------
--- SOTO-Refactored
--- @author: peteR_pg
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- GitHub Repository: https://github.com/Susjin/SOTO-Refactored

--- Main file with all functions related to testing the mod on client
--- @class SOTOClientTesting
local SOTOClientTesting = {}
----------------------------------------------------------------------------------------------
--If client is not on debug mode, ignore this whole file
if not getDebug() then return SOTOClientTesting end

--Requires
local SOTOUtility = require("SOTO/SOTOUtility")
local SOTOSharedTesting = require("SOTO/SOTOSharedTesting")

--Pulling global to local for performance
local SOTO = SOTO

--Setting up locals
local subMenuTexture = getTexture("trait_weightgainnew")

---Creates a text box to run a test
---@param func string
---@param player IsoPlayer
---@param object IsoObject
---@param text string
function SOTOClientTesting.createTextBox(func, player, object, text)
    local modal = ISTextBox:new(0, 0, 280, 70, text, "", func, SOTOClientTesting.onClickTextBox, nil, player, object);
    modal:initialise();
    modal:addToUIManager();
end

---Runs when the text box is confirmed
---@param func string
---@param button ISButton
---@param player IsoPlayer
---@param object IsoObject
function SOTOClientTesting.onClickTextBox(func, button, player, object)
    if button.internal == "OK" then
        local args = {button.parent.entry:getText()}
        SOTOClientTesting.onContextMenuObjectSelection(func, player, object, args)
    end
end

---Runs when a option from the context menu is clicked
---@param func string
---@param player IsoPlayer
---@param object IsoObject
---@param args (string|number)[]
function SOTOClientTesting.onContextMenuObjectSelection(func, player, object, args)
    if object and player and func and SOTOSharedTesting[func] then
        ---@type ObjectPosition
        local objectPos = {x = object:getX(), y = object:getY(), z = object:getZ()}
        ---@type TestingCommandArgs
        local finalArgs = {objectPos = objectPos, args = args}
        if SOTOUtility.getGameMode() == SOTOUtility.GameMode["SP"] then
            SOTOSharedTesting[func](finalArgs)
        elseif SOTOUtility.getGameMode() == SOTOUtility.GameMode["MP_CLIENT"] then
            sendClientCommand(player, "SOTOTesting", func, finalArgs)
        end
    end
end

---Function to run when a player creates a world context menu
---@param playerIndex integer Local player number that created that menu
---@param contextMenu ISContextMenu The menu that got created
---@param worldObjects IsoObject[] All objects on the menu position
function SOTOClientTesting.onSOTOContextMenu(playerIndex, contextMenu, worldObjects)
    local player = getSpecificPlayer(playerIndex)
    ---@type IsoDoor|IsoGenerator
    local door, generator
    for i = 1, #worldObjects do
        if instanceof(worldObjects[i], "IsoDoor") then
            door = worldObjects[i]
            break
        end
        if instanceof(worldObjects[i], "IsoGenerator") then
            generator = worldObjects[i]
            break
        end
    end

    local SOTODebugMenuOption = contextMenu:addOption("SOTO|Debug", worldObjects, nil)
    SOTODebugMenuOption.iconTexture = subMenuTexture
    local SOTODebugMenu = contextMenu:getNew(contextMenu)
    contextMenu:addSubMenu(SOTODebugMenuOption, SOTODebugMenu)
    if not door and not generator then contextMenu:removeOptionByName("SOTO|Debug") end

    if door then
        local doorOption = SOTODebugMenu:addOption("Door: Heal", "healDoor", SOTOClientTesting.onContextMenuObjectSelection, player, door)
        doorOption.iconTexture = getTexture(door:getSpriteName()):splitIcon()
    end
    if generator then
        local genOption = SOTODebugMenu:addOption("Generator: Set Condition", "setGeneratorCondition", SOTOClientTesting.createTextBox, player, generator, "Set generator condition to: ")
        genOption.iconTexture = getTexture("Item_Generator")
    end
end

Events.OnFillWorldObjectContextMenu.Add(SOTOClientTesting.onSOTOContextMenu)


------------------ Returning file for 'require' ------------------
return SOTOClientTesting