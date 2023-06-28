require("scripts/extension_systems/trigger/trigger_conditions/trigger_condition_base")

local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local TriggerConditionAtLeastOnePlayerInside = class("TriggerConditionAtLeastOnePlayerInside", "TriggerConditionBase")

TriggerConditionAtLeastOnePlayerInside.on_volume_enter = function (self, entering_unit, dt, t)
	if self:_is_player(entering_unit) then
		return self:_register_unit(entering_unit)
	end

	return false
end

TriggerConditionAtLeastOnePlayerInside.on_volume_exit = function (self, exiting_unit)
	return self:_unregister_unit(exiting_unit)
end

local units_to_test = {}

TriggerConditionAtLeastOnePlayerInside.filter_passed = function (self, filter_unit, volume_id)
	local evaluates_bots = self._evaluates_bots
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local alive_players = player_unit_spawn_manager:alive_players()
	local num_alive_players = #alive_players
	local filter_passed = false

	for i = 1, num_alive_players do
		local player = alive_players[i]
		local player_unit = player.player_unit
		local is_bot = not player:is_human_controlled()
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")
		local character_state_component = unit_data_extension and unit_data_extension:read_component("character_state")
		local is_hogtied = character_state_component and PlayerUnitStatus.is_hogtied(character_state_component)
		local valid_player = (evaluates_bots and is_bot or not is_bot) and not is_hogtied

		if valid_player then
			units_to_test[1] = player_unit
			filter_passed = VolumeEvent.has_all_units_inside(self._engine_volume_event_system, volume_id, unpack(units_to_test))

			if filter_passed then
				break
			end
		end
	end

	return filter_passed
end

TriggerConditionAtLeastOnePlayerInside._is_player = function (self, unit)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(unit)

	if player then
		local is_bot = not player:is_human_controlled()
		local evaluates_bots = self._evaluates_bots
		local valid_player = evaluates_bots and is_bot or not is_bot

		return valid_player
	end

	return false
end

return TriggerConditionAtLeastOnePlayerInside
