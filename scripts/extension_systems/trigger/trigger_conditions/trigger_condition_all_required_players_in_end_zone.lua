require("scripts/extension_systems/trigger/trigger_conditions/trigger_condition_base")

local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local TriggerConditionAllRequiredPlayersInEndZone = class("TriggerConditionAllRequiredPlayersInEndZone", "TriggerConditionBase")

TriggerConditionAllRequiredPlayersInEndZone.init = function (self, engine_volume_event_system, is_server, volume_unit, only_once, condition_name, evaluates_bots)
	TriggerConditionAllRequiredPlayersInEndZone.super.init(self, engine_volume_event_system, is_server, volume_unit, only_once, condition_name, evaluates_bots)

	self._side_system = Managers.state.extension:system("side_system")
	self._player_side = self._side_system:get_default_player_side_name()
end

TriggerConditionAllRequiredPlayersInEndZone.on_volume_enter = function (self, entering_unit, dt, t)
	local side_name = self._player_side

	if self:_unit_is_on_side(entering_unit, side_name) then
		return self:_register_unit(entering_unit)
	end

	return false
end

TriggerConditionAllRequiredPlayersInEndZone.on_volume_exit = function (self, exiting_unit)
	return self:_unregister_unit(exiting_unit)
end

TriggerConditionAllRequiredPlayersInEndZone._log_player_states = function (self, alive_players)
	local text = "Ending mission with alive players in following character states: "
	local first = true

	for ii = 1, #alive_players do
		local player = alive_players[ii]
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

		if unit_data_extension then
			local character_state_component = unit_data_extension:read_component("character_state")

			if player:is_human_controlled() then
				if not first then
					text = text .. ", "
				end

				text = text .. tostring(character_state_component.state_name)
				first = false
			end
		end
	end

	Log.info("TriggerConditionAllRequiredPlayersInEndZone", text)
end

local units_to_test = {}

TriggerConditionAllRequiredPlayersInEndZone.filter_passed = function (self, filter_unit, volume_id)
	table.clear(units_to_test)

	local num_units_to_test = 0
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local alive_players = player_unit_spawn_manager:alive_players()
	local num_alive_players = #alive_players
	local filter_passed = false

	for i = 1, num_alive_players do
		local player = alive_players[i]
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

		if unit_data_extension then
			local character_state_component = unit_data_extension:read_component("character_state")
			local can_complete_mission = PlayerUnitStatus.end_zone_conditions_fulfilled(character_state_component)
			local is_human = player:is_human_controlled()

			if is_human and can_complete_mission then
				num_units_to_test = num_units_to_test + 1
				units_to_test[num_units_to_test] = player_unit
			end
		end
	end

	if num_units_to_test > 0 then
		filter_passed = VolumeEvent.has_all_units_inside(self._engine_volume_event_system, volume_id, unpack(units_to_test))
	end

	if filter_passed and not self._states_logged then
		self:_log_player_states(alive_players)

		self._states_logged = true
	end

	return filter_passed
end

TriggerConditionAllRequiredPlayersInEndZone._unit_is_on_side = function (self, unit, side_name)
	local side = self._side_system.side_by_unit[unit]

	return side and side:name() == side_name
end

return TriggerConditionAllRequiredPlayersInEndZone
