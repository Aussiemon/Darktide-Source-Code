-- chunkname: @scripts/extension_systems/trigger/trigger_conditions/trigger_condition_all_players_inside_no_enemies.lua

require("scripts/extension_systems/trigger/trigger_conditions/trigger_condition_base")

local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local TriggerConditionAllPlayersInsideNoEnemies = class("TriggerConditionAllPlayersInsideNoEnemies", "TriggerConditionBase")

TriggerConditionAllPlayersInsideNoEnemies.init = function (self, engine_volume_event_system, is_server, volume_unit, only_once, condition_name, evaluates_bots)
	TriggerConditionAllPlayersInsideNoEnemies.super.init(self, engine_volume_event_system, is_server, volume_unit, only_once, condition_name, evaluates_bots)

	local extension_manager = Managers.state.extension
	local side_system = extension_manager:system("side_system")
	local side_name = side_system:get_default_player_side_name()
	local side = side_system:get_side_from_name(side_name)

	self._side = side
	self._enemy_side_names = side:relation_side_names("enemy")

	local broadphase_system = extension_manager:system("broadphase_system")

	self._broadphase = broadphase_system.broadphase

	local volume_points = Unit.volume_points(self._volume_unit, "enemy_check_volume")
	local first_position, num_volume_points = volume_points[1], #volume_points
	local max_position, min_position = first_position, first_position
	local Vector3_max, Vector3_min = Vector3.max, Vector3.min

	for i = 2, num_volume_points do
		local volume_point = volume_points[i]

		max_position = Vector3_max(max_position, volume_point)
		min_position = Vector3_min(min_position, volume_point)
	end

	local Vector3_distance_squared = Vector3.distance_squared
	local max_distance_sq = -math.huge
	local center_position = (max_position + min_position) / 2

	for i = 1, num_volume_points do
		local position = volume_points[i]
		local distance_sq = Vector3_distance_squared(center_position, position)

		if max_distance_sq < distance_sq then
			max_distance_sq = distance_sq
		end
	end

	self._broadphase_center = Vector3Box(center_position)
	self._broadphase_radius = math.sqrt(max_distance_sq)
end

TriggerConditionAllPlayersInsideNoEnemies.on_volume_enter = function (self, entering_unit, dt, t)
	local side = self._side

	if side.units_lookup[entering_unit] then
		return self:_register_unit(entering_unit)
	else
		return false
	end
end

TriggerConditionAllPlayersInsideNoEnemies.on_volume_exit = function (self, exiting_unit)
	return self:_unregister_unit(exiting_unit)
end

local units_to_test, broadphase_results = {}, {}

TriggerConditionAllPlayersInsideNoEnemies.filter_passed = function (self, filter_unit, volume_id)
	local broadphase_radius, broadphase_center = self._broadphase_radius, self._broadphase_center:unbox()
	local volume_unit, enemy_found, Unit_is_point_inside_volume = self._volume_unit, false, Unit.is_point_inside_volume
	local position_offset = Vector3.up() * 0.25
	local num_results = Broadphase.query(self._broadphase, broadphase_center, broadphase_radius, broadphase_results, self._enemy_side_names)

	for i = 1, num_results do
		local enemy_unit = broadphase_results[i]
		local enemy_position = POSITION_LOOKUP[enemy_unit] + position_offset

		if Unit_is_point_inside_volume(volume_unit, "enemy_check_volume", enemy_position) then
			enemy_found = true

			break
		end
	end

	table.clear_array(broadphase_results, num_results)

	if enemy_found then
		return false
	end

	table.clear(units_to_test)

	local evaluates_bots = self._evaluates_bots
	local alive_players = Managers.state.player_unit_spawn:alive_players()
	local num_alive_players = #alive_players
	local num_units_to_test = 0
	local filter_passed = false

	for i = 1, num_alive_players do
		local player = alive_players[i]
		local player_unit = player.player_unit
		local is_bot = not player:is_human_controlled()
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		local is_hogtied = PlayerUnitStatus.is_hogtied(character_state_component)
		local valid_player = (evaluates_bots and is_bot or not is_bot) and not is_hogtied

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

return TriggerConditionAllPlayersInsideNoEnemies
