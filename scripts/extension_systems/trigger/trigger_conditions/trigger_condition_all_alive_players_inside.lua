require("scripts/extension_systems/trigger/trigger_conditions/trigger_condition_base")

local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local TriggerConditionAllAlivePlayersInside = class("TriggerConditionAllAlivePlayersInside", "TriggerConditionBase")

TriggerConditionAllAlivePlayersInside.init = function (self, engine_volume_event_system, is_server, volume_unit, only_once, condition_name, evaluates_bots)
	TriggerConditionAllAlivePlayersInside.super.init(self, engine_volume_event_system, is_server, volume_unit, only_once, condition_name, evaluates_bots)

	self._side_system = Managers.state.extension:system("side_system")
	self._player_side = self._side_system:get_default_player_side_name()
end

TriggerConditionAllAlivePlayersInside.on_volume_enter = function (self, entering_unit, dt, t)
	local side_name = self._player_side

	if self:_unit_is_on_side(entering_unit, side_name) then
		return self:_register_unit(entering_unit)
	end

	return false
end

TriggerConditionAllAlivePlayersInside.on_volume_exit = function (self, exiting_unit)
	return self:_unregister_unit(exiting_unit)
end

local units_to_test = {}

TriggerConditionAllAlivePlayersInside.filter_passed = function (self, filter_unit, volume_id)
	table.clear(units_to_test)

	local evaluates_bots = self._evaluates_bots
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local alive_players = player_unit_spawn_manager:alive_players()
	local num_alive_players = #alive_players
	local num_units_to_test = 0
	local filter_passed = false

	for i = 1, num_alive_players do
		local player = alive_players[i]
		local player_unit = player.player_unit
		local is_bot = not player:is_human_controlled()
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")
		local character_state_component = unit_data_extension and unit_data_extension:read_component("character_state")
		local requires_allied_interaction_help = character_state_component and PlayerUnitStatus.requires_allied_interaction_help(character_state_component)
		local valid_player = (evaluates_bots and is_bot or not is_bot) and not requires_allied_interaction_help

		if valid_player then
			num_units_to_test = num_units_to_test + 1
			units_to_test[num_units_to_test] = player_unit
		end
	end

	if num_units_to_test > 0 then
		filter_passed = VolumeEvent.has_all_units_inside(self._engine_volume_event_system, volume_id, unpack(units_to_test))
	end

	return filter_passed
end

TriggerConditionAllAlivePlayersInside._unit_is_on_side = function (self, unit, side_name)
	local side = self._side_system.side_by_unit[unit]

	return side and side:name() == side_name
end

return TriggerConditionAllAlivePlayersInside
