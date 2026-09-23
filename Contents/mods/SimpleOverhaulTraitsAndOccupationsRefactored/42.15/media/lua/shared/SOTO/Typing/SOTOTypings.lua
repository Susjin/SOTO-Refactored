----------------------------------------------------------------------------------------------
--- SOTO-Refactored
--- @author: peteR_pg
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- GitHub Repository: https://github.com/Susjin/SOTO-Refactored

--- This file exists only to declare classes and aliases
----------------------------------------------------------------------------------------------

---@alias integer number

---@alias SOTOGameMode {SP: "SP", MP_CLIENT: "MP_Client", MP_SERVER: "MP_Server"}

---@class ObjectPosition
---@field x number X position of the object
---@field y number Y position of the object
---@field z number Z position of the object

---@class TestingCommandArgs
---@field objectPos ObjectPosition
---@field args (string|number)[]
