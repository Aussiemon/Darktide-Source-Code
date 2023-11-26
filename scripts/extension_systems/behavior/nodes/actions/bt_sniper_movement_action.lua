-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_sniper_movement_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local MinionMovement = require("scripts/utilities/minion_movement")
local NavQueries = require("scripts/utilities/nav_queries")
local BtSniperMovementAction = class("BtSniperMovementAction", "BtNode")

BtSniperMovementAction.TIME_TO_FIRST_EVALUATE = {
	2,
	2.5
}
BtSniperMovementAction.CONSECUTIVE_EVALUATE_INTERVAL = {
	1,
	2
}

BtSniperMovementAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.navigation_extension = navigation_extension
	scratchpad.nav_world = navigation_extension:nav_world()

	local astar = GwNavAStar.create(scratchpad.nav_world)

	scratchpad.astar = astar

	local cover_component = Blackboard.write_component(blackboard, "cover")

	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.cover_component = cover_component
	scratchpad.perception_component = blackboard.perception
	scratchpad.stagger_component = Blackboard.write_component(blackboard, "stagger")

	local combat_vector_component = blackboard.combat_vector

	scratchpad.combat_vector_component = combat_vector_component

	local run_speed = breed.run_speed

	navigation_extension:set_enabled(true, run_speed)

	scratchpad.time_to_next_evaluate = t + math.random_range(BtSniperMovementAction.TIME_TO_FIRST_EVALUATE[1], BtSniperMovementAction.TIME_TO_FIRST_EVALUATE[2])
	scratchpad.move_type_switch_stickiness = 0
	scratchpad.valid_destinations = {
		0,
		0,
		0,
		0,
		0
	}

	self:_set_destinations(scratchpad, action_data)
	self:_start_astar(unit, scratchpad, action_data)
end

BtSniperMovementAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	if scratchpad.stagger_duration then
		MinionMovement.stop_running_stagger(scratchpad)
	end

	scratchpad.navigation_extension:set_enabled(false)

	local astar = scratchpad.astar

	if astar then
		GwNavAStar.destroy(astar)
	end
end

local DESTINATION_TYPES = {
	combat_vector = 3,
	main_path_ahead = 1,
	cover = 4,
	done = 0,
	main_path_behind = 2
}

BtSniperMovementAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if action_data.running_stagger_duration then
		MinionMovement.update_running_stagger(unit, t, dt, scratchpad, action_data)
	end

	local behavior_component = scratchpad.behavior_component
	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		self:_evaluate_destinations(unit, scratchpad, action_data)
	end

	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)
	local should_evaluate = not scratchpad.running_stagger_block_evaluate and t >= scratchpad.time_to_next_evaluate

	if should_start_idle or should_be_idling then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)
		end

		local evaluate = not scratchpad.running_stagger_block_evaluate and t > scratchpad.time_to_next_evaluate

		return "running", evaluate
	end

	local move_type = self:_get_move_type(scratchpad, action_data)

	if move_state ~= "moving" or move_type ~= scratchpad.current_move_type and t >= scratchpad.move_type_switch_stickiness then
		self:_start_move_anim(unit, t, behavior_component, scratchpad, action_data, move_type)

		scratchpad.current_move_type = move_type
		scratchpad.move_type_switch_stickiness = t + action_data.move_type_switch_stickiness
	end

	if scratchpad.is_anim_driven and scratchpad.start_rotation_timing and t >= scratchpad.start_rotation_timing then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	if should_evaluate then
		scratchpad.time_to_next_evaluate = t + math.random_range(BtSniperMovementAction.CONSECUTIVE_EVALUATE_INTERVAL[1], BtSniperMovementAction.CONSECUTIVE_EVALUATE_INTERVAL[2])

		return "running", true
	end

	return "running"
end

BtSniperMovementAction._start_move_anim = function (self, unit, t, behavior_component, scratchpad, action_data, move_type)
	local animation_extension = scratchpad.animation_extension
	local path_distance = scratchpad.navigation_extension:remaining_distance_from_progress_to_end_of_path()
	local should_use_anim_driven_event = path_distance >= action_data.anim_driven_min_distance
	local start_move_anim_events = action_data.start_move_anim_events
	local anim_events = start_move_anim_events

	if move_type == "jogging" and anim_events and should_use_anim_driven_event then
		local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)
		local start_move_event = anim_events[moving_direction_name]

		animation_extension:anim_event(start_move_event)

		if moving_direction_name ~= "fwd" then
			MinionMovement.set_anim_driven(scratchpad, true)

			local start_rotation_timing = action_data.start_move_rotation_timings[start_move_event]

			scratchpad.start_rotation_timing = t + start_rotation_timing
			scratchpad.move_start_anim_event_name = start_move_event
		else
			scratchpad.start_rotation_timing = nil
			scratchpad.move_start_anim_event_name = nil
		end
	else
		animation_extension:anim_event(action_data.sprint_anim_event)
	end

	local speed = action_data.speeds[move_type]

	scratchpad.navigation_extension:set_max_speed(speed)

	behavior_component.move_state = "moving"
end

BtSniperMovementAction._get_move_type = function (self, scratchpad, action_data)
	local perception_component = scratchpad.perception_component
	local has_line_of_sight = perception_component.has_line_of_sight
	local target_distance = perception_component.target_distance
	local sprint_target_distance = action_data.sprint_target_distance

	if has_line_of_sight and target_distance <= sprint_target_distance then
		return "sprinting"
	else
		return "jogging"
	end
end

local MAIN_PATH_AHEAD_DISTANCE = 30
local MAIN_PATH_BEHIND_DISTANCE = 30

BtSniperMovementAction._set_destinations = function (self, scratchpad, action_data)
	local cover_component = scratchpad.cover_component

	if cover_component.has_cover then
		scratchpad.valid_destinations[DESTINATION_TYPES.cover] = cover_component.navmesh_position
	else
		scratchpad.valid_destinations[DESTINATION_TYPES.cover] = 0
	end

	local combat_vector_component = scratchpad.combat_vector_component

	if combat_vector_component.has_position then
		scratchpad.valid_destinations[DESTINATION_TYPES.combat_vector] = combat_vector_component.position
	else
		scratchpad.valid_destinations[DESTINATION_TYPES.combat_vector] = 0
	end

	local main_path_manager = Managers.state.main_path
	local target_side_id = 1
	local _, ahead_travel_distance = main_path_manager:ahead_unit(target_side_id)
	local ahead_main_path_position = MainPathQueries.position_from_distance(ahead_travel_distance + MAIN_PATH_AHEAD_DISTANCE)

	if ahead_main_path_position then
		scratchpad.valid_destinations[DESTINATION_TYPES.main_path_ahead] = Vector3Box(ahead_main_path_position)
	else
		scratchpad.valid_destinations[DESTINATION_TYPES.main_path_ahead] = 0
	end

	local behind_main_path_position = MainPathQueries.position_from_distance(ahead_travel_distance - MAIN_PATH_BEHIND_DISTANCE)

	if behind_main_path_position then
		scratchpad.valid_destinations[DESTINATION_TYPES.main_path_behind] = Vector3Box(behind_main_path_position)
	else
		scratchpad.valid_destinations[DESTINATION_TYPES.main_path_behind] = 0
	end

	scratchpad.astar_index = #scratchpad.valid_destinations
end

BtSniperMovementAction._start_astar = function (self, unit, scratchpad, action_data)
	local astar_index = scratchpad.astar_index
	local astar_position
	local valid_destinations = scratchpad.valid_destinations

	if valid_destinations[astar_index] ~= 0 then
		astar_position = valid_destinations[astar_index]:unbox()

		if astar_index == DESTINATION_TYPES.cover then
			scratchpad.moving_to_cover = true
		else
			scratchpad.moving_to_cover = false
		end
	end

	scratchpad.astar_index = scratchpad.astar_index - 1

	local traverse_logic = scratchpad.navigation_extension:traverse_logic()
	local navmesh_position = astar_position and NavQueries.position_on_mesh_with_outside_position(scratchpad.nav_world, traverse_logic, astar_position, 1, 1, 1)

	if navmesh_position then
		local astar = scratchpad.astar
		local nav_world = scratchpad.nav_world
		local from_position = POSITION_LOOKUP[unit]

		GwNavAStar.start(astar, nav_world, from_position, navmesh_position, traverse_logic)

		scratchpad.invalid_position = false
		scratchpad.current_move_destination = Vector3Box(navmesh_position)
	else
		scratchpad.invalid_position = true
	end

	return false
end

local BROADPHASE_RELATION = "enemy"
local BROADPHASE_RADIUS = 5
local BROADPHASE_RESULTS = {}
local MAX_DISTANCE_FROM_TARGETS_IN_BROADPHASE = 6

BtSniperMovementAction._evaluate_destinations = function (self, unit, scratchpad, action_data)
	if scratchpad.invalid_position then
		self:_restart_atar(unit, scratchpad, action_data)

		return
	end

	local astar = scratchpad.astar
	local done = GwNavAStar.processing_finished(astar)

	if not done then
		return
	end

	local path_found = GwNavAStar.path_found(astar)

	if path_found then
		local node_count = GwNavAStar.node_count(astar)
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local target_side_names = side:relation_side_names(BROADPHASE_RELATION)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		local path_is_valid = true
		local self_position = POSITION_LOOKUP[unit]

		for i = 2, node_count do
			local node = GwNavAStar.node_at_index(astar, i)
			local num_results = broadphase.query(broadphase, node, BROADPHASE_RADIUS, BROADPHASE_RESULTS, target_side_names)

			for j = 1, num_results do
				local result = BROADPHASE_RESULTS[j]
				local pos = POSITION_LOOKUP[result]
				local distance = Vector3.distance(pos, self_position)

				if distance > MAX_DISTANCE_FROM_TARGETS_IN_BROADPHASE then
					path_is_valid = false

					break
				end
			end

			if not path_is_valid then
				break
			end
		end

		if path_is_valid then
			local navigation_extension = scratchpad.navigation_extension
			local position = scratchpad.current_move_destination:unbox()

			if Vector3.distance(self_position, position) > 0.25 then
				navigation_extension:move_to(position)
			end
		else
			scratchpad.astar_index = scratchpad.astar_index - 1

			self:_restart_atar(unit, scratchpad, action_data)
		end
	else
		scratchpad.astar_index = scratchpad.astar_index - 1

		self:_restart_atar(unit, scratchpad, action_data)
	end
end

BtSniperMovementAction._restart_atar = function (self, unit, scratchpad, action_data)
	if scratchpad.astar_index > 0 then
		self:_start_astar(unit, scratchpad, action_data)
	else
		self:_set_destinations(scratchpad, action_data)
		self:_start_astar(unit, scratchpad, action_data)
	end
end

return BtSniperMovementAction
