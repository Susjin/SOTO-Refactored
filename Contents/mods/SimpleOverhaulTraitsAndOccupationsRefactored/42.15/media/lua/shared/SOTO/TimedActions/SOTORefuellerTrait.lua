require "TimedActions/ISBaseTimedAction"

--ISAddGasolineToVehicle | Triggered when adding gas to a car
local old_ISAddGasolineToVehicle_getDuration = ISAddGasolineToVehicle.getDuration
function ISAddGasolineToVehicle:getDuration()
    local baseDuration = old_ISAddGasolineToVehicle_getDuration(self)
    if self.character:hasTrait(SOTO.CharacterTrait.REFUELLER) then
        baseDuration = baseDuration * 0.75 -- 75
    end
    return baseDuration
end

--ISTakeGasolineFromVehicle | Triggered when taking gas from a car
local old_ISTakeGasolineFromVehicle_getDuration = ISTakeGasolineFromVehicle.getDuration
function ISTakeGasolineFromVehicle:getDuration()
    local baseDuration = old_ISTakeGasolineFromVehicle_getDuration(self)
    if self.character:hasTrait(SOTO.CharacterTrait.REFUELLER) then
        baseDuration = baseDuration * 0.75
    end
    return baseDuration
end

--ISRefuelFromGasPump | Triggered when refueling a car from a gas pump
local old_ISRefuelFromGasPump_getDuration = ISRefuelFromGasPump.getDuration
function ISRefuelFromGasPump:getDuration()
    local baseDuration = old_ISRefuelFromGasPump_getDuration(self)
    if self.character:hasTrait(SOTO.CharacterTrait.REFUELLER) then
        baseDuration = baseDuration * 0.75	
    end
    return baseDuration
end

--ISTakeFuel | Triggered when using the context menu on a gas pump to take fuel to a can
local old_ISTakeFuel_getDuration = ISTakeFuel.getDuration
function ISTakeFuel:getDuration()
    local baseDuration = old_ISTakeFuel_getDuration(self)
    if self.character:hasTrait(SOTO.CharacterTrait.REFUELLER) then
        baseDuration = baseDuration * 0.75
    end
    return baseDuration
end

--ISAddFuel | Triggered when adding fuel to a generator
local old_ISAddFuel_getDuration = ISAddFuel.getDuration
function ISAddFuel:getDuration()
    local baseDuration = old_ISAddFuel_getDuration(self)
    if self.character:hasTrait(SOTO.CharacterTrait.REFUELLER) then
        baseDuration = baseDuration * 0.75
    end
    return baseDuration
end


