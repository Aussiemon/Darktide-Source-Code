-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_summon_minions_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local Vo = require("scripts/utilities/vo")
local BtSummonMinionsAction = class("BtSummonMinionsAction", "BtNode")
local _play_wwise, _has_active_minions_and_refill, _check_player_los

BtSummonMinionsAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local active_timer = _has_active_minions_and_refill(blackboard, action_data)

	if not active_timer then
		local events = action_data.anim_events
		local event = Animation.random_event(events)
		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event(event)

		local vo_event = action_data.vo_event

		if vo_event then
			local breed_name = breed.name

			Vo.enemy_generic_vo_event(unit, vo_event, breed_name)
		end

		local shout_wwise_event_timing = action_data.shout_wwise_event_timing

		if shout_wwise_event_timing then
			scratchpad.shout_wwise_event_timing = t + shout_wwise_event_timing
		end
	end

	scratchpad.summon_component = Blackboard.write_component(blackboard, "summon")

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.nav_world = navigation_extension:nav_world()

	local summon_component = scratchpad.summon_component

	if summon_component.next_summon_t == 0 then
		summon_component.next_summon_t = t + action_data.initial_delay
	end

	scratchpad.summoned_minions_extension = ScriptUnit.extension(unit, "summon_minions_system")
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
end

BtSummonMinionsAction.init_values = function (self, blackboard)
	local summon_component = Blackboard.write_component(blackboard, "summon")

	summon_component.next_summon_t = 0
	summon_component.amount = 0
end

BtSummonMinionsAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	return
end

BtSummonMinionsAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local stinger_delay = action_data.stinger_delay
	local summon_component = scratchpad.summon_component
	local interval_til_next_summon = action_data.interval_til_next_summon

	if not scratchpad.delay then
		scratchpad.delay = t + stinger_delay

		return "running"
	end

	local active_timer = _has_active_minions_and_refill(blackboard, action_data)

	if not active_timer then
		if scratchpad.shout_wwise_event_timing and t >= scratchpad.shout_wwise_event_timing then
			local fx_system = Managers.state.extension:system("fx_system")
			local position = POSITION_LOOKUP[unit]
			local shout_wwise_event = action_data.shout_wwise_event

			fx_system:trigger_wwise_event(shout_wwise_event, position)

			scratchpad.shout_wwise_event_timing = nil
		end

		if not scratchpad.pre_stinger then
			scratchpad.pre_stinger = action_data.pre_stinger

			_play_wwise(unit, scratchpad.pre_stinger)
		end
	end

	if t > scratchpad.delay and not scratchpad.summoned_success then
		scratchpad.summoned_success = true

		self:_summon_minions(unit, breed, blackboard, scratchpad, action_data, dt, t)

		summon_component.next_summon_t = t + math.random(interval_til_next_summon[1], interval_til_next_summon[2])

		return "done"
	end

	return "running"
end

local TEMP_FLOOD_FILL_POSITONS = {}
local BREEDS_TO_SPAWN = {}
local MIN_DISTANCE_FROM_PLAYERS = 5
local DEFAULT_MAIN_PATH_OFFSET = 20
local DEFAULT_OCCLUSION_SPAWN_RANGE = {
	3,
	6,
	12,
	24,
	36,
	72,
}
local DEFAULT_TRIES = 6

BtSummonMinionsAction._summon_minions = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side_from_name("villains")
	local enemy_side = side_system:get_side_from_name("heroes")
	local nav_world = scratchpad.nav_world
	local success, random_occluded_position, target_direction, spawn_rotation
	local players_in_los = _check_player_los(scratchpad, side)
	local should_close_spawn_outside_los = action_data.should_close_spawn_outside_los and not players_in_los

	if should_close_spawn_outside_los then
		random_occluded_position = POSITION_LOOKUP[unit]
		spawn_rotation = Quaternion.look(Vector3(0, 0, 0))
	else
		for i = 1, DEFAULT_TRIES do
			local occluded_spawn_range = DEFAULT_OCCLUSION_SPAWN_RANGE[i]

			success, random_occluded_position, target_direction = self:_try_find_occluded_position(nav_world, side, enemy_side, occluded_spawn_range, true, nil, nil)

			if success then
				spawn_rotation = Quaternion.look(Vector3(target_direction.x, target_direction.y, 0))

				break
			end
		end

		if not success then
			return
		end
	end

	local aggro_state = action_data.spawn_aggro_state
	local optional_target_unit

	if aggro_state == "aggroed" then
		local main_path_manager = Managers.state.main_path

		if main_path_manager:is_main_path_ready() then
			optional_target_unit = main_path_manager:ahead_unit(1)
		end
	end

	local breeds = action_data.breed_data
	local min_amount = 0

	for i = 1, #breeds do
		local breed_data = breeds[i]
		local breed_name, amount = breed_data.name, breed_data.amount
		local _num = math.random(amount[1], amount[2])

		min_amount = min_amount + amount[1]

		for j = 1, _num do
			BREEDS_TO_SPAWN[#BREEDS_TO_SPAWN + 1] = breed_name
		end
	end

	if #BREEDS_TO_SPAWN == 0 then
		return
	end

	table.shuffle(BREEDS_TO_SPAWN)

	if action_data.should_refill then
		local minion_amount_spawned = blackboard.summon.amount or 0
		local num_to_spawn = math.max(0, min_amount - minion_amount_spawned)
		local breeds_to_keep = math.min(num_to_spawn, #BREEDS_TO_SPAWN)

		if breeds_to_keep < #BREEDS_TO_SPAWN then
			for i = #BREEDS_TO_SPAWN, breeds_to_keep + 1, -1 do
				table.remove(BREEDS_TO_SPAWN, i)
			end
		end
	end

	local below, above = 2, 2
	local num_to_spawn = #BREEDS_TO_SPAWN

	if num_to_spawn == 0 then
		table.clear(BREEDS_TO_SPAWN)

		return
	end

	local num_positions = GwNavQueries.flood_fill_from_position(nav_world, random_occluded_position, above, below, num_to_spawn, TEMP_FLOOD_FILL_POSITONS)
	local side_extension = ScriptUnit.extension(unit, "side_system")
	local side_id = side_extension.side_id

	for i = 1, num_positions do
		local spawn_position = TEMP_FLOOD_FILL_POSITONS[i]
		local breed_name = BREEDS_TO_SPAWN[i]
		local minion_spawn_manager = Managers.state.minion_spawn
		local param_table = minion_spawn_manager:request_param_table()

		param_table.optional_aggro_state = aggro_state
		param_table.optional_target_unit = optional_target_unit

		local spawned_unit = minion_spawn_manager:spawn_minion(breed_name, spawn_position, spawn_rotation, side_id, param_table)

		scratchpad.summoned_minions_extension:add_new_summoned_unit(spawned_unit)
	end

	table.clear_array(TEMP_FLOOD_FILL_POSITONS, num_positions)
	table.clear(BREEDS_TO_SPAWN)

	local stinger = action_data.stinger

	_play_wwise(unit, stinger)
end

BtSummonMinionsAction._try_find_occluded_position = function (self, nav_world, side, target_side, occluded_spawn_range, try_find_on_main_path, optional_main_path_offset, optional_disallowed_positions)
	local target_side_id = target_side.side_id
	local main_path_manager = Managers.state.main_path
	local nav_spawn_points = main_path_manager:nav_spawn_points()
	local target_unit, travel_distance, path_position = main_path_manager:ahead_unit(target_side_id)

	if not target_unit then
		return false, nil, nil, nil
	end

	local wanted_position

	if try_find_on_main_path then
		local main_path_offset = optional_main_path_offset or DEFAULT_MAIN_PATH_OFFSET

		if type(main_path_offset) == "table" then
			main_path_offset = math.random_range(optional_main_path_offset[1], optional_main_path_offset[2])
		end

		local main_path_distance = math.max(travel_distance + main_path_offset, 0)

		wanted_position = MainPathQueries.position_from_distance(main_path_distance)
	else
		wanted_position = path_position
	end

	local only_search_forward = false
	local random_occluded_position = SpawnPointQueries.get_random_occluded_position(nav_world, nav_spawn_points, wanted_position, side, occluded_spawn_range, 1, MIN_DISTANCE_FROM_PLAYERS, nil, nil, only_search_forward, optional_disallowed_positions)

	if not random_occluded_position then
		return false, nil, nil, nil
	end

	local to_target = wanted_position - random_occluded_position
	local target_direction = Vector3.normalize(to_target)

	return true, random_occluded_position, target_direction, target_unit
end

function _play_wwise(unit, event)
	local fx_system = Managers.state.extension:system("fx_system")
	local position = Unit.world_position(unit, 1)

	fx_system:trigger_wwise_event(event, position)
end

function _has_active_minions_and_refill(blackboard, action_data)
	local should_refill = action_data.should_refill
	local summon_component = blackboard.summon
	local minion_amount = summon_component.amount

	if should_refill and minion_amount ~= 0 then
		return true
	else
		return false
	end
end

function _check_player_los(scratchpad, side)
	local valid_enemy_player_units = side.valid_enemy_player_units
	local perception_extension = scratchpad.perception_extension
	local num_enemies = #valid_enemy_player_units

	for i = 1, num_enemies do
		local target_unit = valid_enemy_player_units[i]
		local has_line_of_sight = perception_extension:has_line_of_sight(target_unit)

		if has_line_of_sight then
			return true
		end
	end

	return false
end

return BtSummonMinionsAction
