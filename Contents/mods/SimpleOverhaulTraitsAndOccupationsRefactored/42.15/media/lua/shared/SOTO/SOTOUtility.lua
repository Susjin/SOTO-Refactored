----------------------------------------------------------------------------------------------
--- SOTO-Refactored
--- @author: peteR_pg, hea
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- Steam profile: https://steamcommunity.com/id/heafoxyz/
--- GitHub Repository: https://github.com/Susjin/SOTO-Refactored


--- Main file with all utility functions
--- @class SOTOUtility
local SOTOUtility = {}
----------------------------------------------------------------------------------------------
--Pulling global to local for performance
local getDebug = getDebug()
local pairs = pairs

--- @type {SP: "SP", MP_CLIENT: "MP_Client", MP_SERVER: "MP_Server"}
SOTOUtility.GameMode = {
    SP = "SP",
    MP_CLIENT = "MP_Client",
    MP_SERVER = "MP_Server",
}

---Logs a message on the console if debug mode is on
---@param message string Message to be print
---@param location string From what file|function it is
---@param gameMode string What gamemode is running on the client executed
function SOTOUtility.logDebug(message, location, gameMode)
    if getDebug or SOTOUtility.getGameMode() == SOTOUtility.GameMode["MP_SERVER"] then
        print(string.format("SOTODebug[%s|%s]: %s", gameMode or "", location or "", message or ""))
    end
end

---Function responsible for determining the current game mode, returns "SP" for single player, "MP_Client" for multiplayer client and "MP_Server" for multiplayer server
---@return "SP"|"MP_Client"|"MP_Server"
function SOTOUtility.getGameMode()
    if not isClient() and not isServer() then
        return SOTOUtility.GameMode.SP
    elseif isClient() then
        return SOTOUtility.GameMode.MP_CLIENT
    end
    return SOTOUtility.GameMode.MP_SERVER
end

---Function that returns ArrayList of all players in case its called on Server, all ever loaded players in case it's called on MP Client, or local player list in case it's called on SP. If player is passed as argument, returns list with only that player.
---@param player IsoPlayer|nil optional player to get list for
---@return ArrayList ArrayList of all players in case its called on Server, all ever loaded players in case it's called on MP Client, or local player list in case it's called on SP.
function SOTOUtility.getPlayersList(player)
    if player then
        local playerList = ArrayList.new()
        playerList:add(player)
        ---@cast playerList ArrayList
        return playerList
    end

    ---@type ArrayList
    local playerList = getOnlinePlayers()
    if playerList:isEmpty() then
        local playerNum = getNumActivePlayers()
        for i = 1, #playerNum do
            local splitPlayer = getSpecificPlayer(i)
            if splitPlayer then
                playerList:add(splitPlayer)
            end
        end
    end

    return playerList
end

---Prints a whole table, used for debug
---@param table table to be printed
function SOTOUtility.printTable(table)
    -- to make output beautiful
    local function tab(amt)
        local str = ""
        for i=1,amt do
            str = str .. "\t"
        end
        return str
    end

    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(table) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(table) do
            if (cache[table] == nil) or (cur_index >= cache[table]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. tab(depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. tab(depth) .. key .. " = {\n"
                    table.insert(stack, table)
                    table.insert(stack,v)
                    cache[table] = cur_index+1
                    break
                else
                    output_str = output_str .. tab(depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (#stack > 0) then
            table = stack[#stack]
            stack[#stack] = nil
            depth = cache[table] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    print(output_str)
end

------------------ Returning file for 'require' ------------------
return SOTOUtility