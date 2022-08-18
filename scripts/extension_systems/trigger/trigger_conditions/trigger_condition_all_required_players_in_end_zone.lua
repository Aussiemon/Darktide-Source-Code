require("scripts/extension_systems/trigger/trigger_conditions/trigger_condition_base")

local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local TriggerConditionAllRequiredPlayersInEndZone = class("TriggerConditionAllRequiredPlayersInEndZone", "TriggerConditionBase")

TriggerConditionAllRequiredPlayersInEndZone.init = function (self, unit, condition_name, evaluates_bots)
	TriggerConditionAllRequiredPlayersInEndZone.super.init(self, condition_name, evaluates_bots)

	self._side_system = Managers.state.extension:system("side_system")
	self._player_side = self._side_system:get_default_player_side_name()
end

TriggerConditionAllRequiredPlayersInEndZone.on_volume_enter = function (self, entering_unit, dt, t)
	local side_name = self._player_side

	if self:_unit_is_on_side(entering_unit, side_name) then
		local has_registered = self:register_unit(entering_unit)

		return has_registered
	end

	return false
end

TriggerConditionAllRequiredPlayersInEndZone.on_volume_exit = function (self, exiting_unit)
	local has_unregistered = self:unregister_unit(exiting_unit)

	return has_unregistered
end

TriggerConditionAllRequiredPlayersInEndZone.is_condition_fulfilled = function (self, volume_id)
	local side_system = self._side_system
	local side_name = self._player_side
	local side = side_system:get_side_from_name(side_name)
	local player_units = side.player_units
	local registered_units = self._registered_units
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local ScriptUnit_has_extension = ScriptUnit.has_extension

	for i = 1, #player_units do
		repeat
			local player_unit = player_units[i]
			local player = player_unit_spawn_manager:owner(player_unit)

			if not player or not registered_units[player_unit] then
				break
			end

			local unit_data_extension = ScriptUnit_has_extension(player_unit, "unit_data_system")
			local character_state_component = unit_data_extension and unit_data_extension:read_component("character_state")
			local end_zone_conditions_fulfilled = character_state_component and PlayerUnitStatus.end_zone_conditions_fulfilled(character_state_component)

			if not end_zone_conditions_fulfilled then
				return false
			end
		until true
	end

	return true
end

TriggerConditionAllRequiredPlayersInEndZone._unit_is_on_side = function (self, unit, side_name)
	local side = self._side_system.side_by_unit[unit]

	return side and side:name() == side_name
end

return TriggerConditionAllRequiredPlayersInEndZone
