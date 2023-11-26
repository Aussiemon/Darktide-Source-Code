-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_beast_of_nurgle_movement_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionMovement = require("scripts/utilities/minion_movement")
local NavQueries = require("scripts/utilities/nav_queries")
local BtBeastOfNurgleMovementAction = class("BtBeastOfNurgleMovementAction", "BtNode")

BtBeastOfNurgleMovementAction.TIME_TO_FIRST_EVALUATE = 0.1
BtBeastOfNurgleMovementAction.CONSECUTIVE_EVALUATE_INTERVAL = 0.15

local DEFAULT_MIN_MOVE_DURATION = 0.5

BtBeastOfNurgleMovementAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = navigation_extension
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")

	local nav_world = navigation_extension:nav_world()

	scratchpad.nav_world = nav_world

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	scratchpad.behavior_component = behavior_component

	local perception_component = blackboard.perception

	scratchpad.perception_component = perception_component

	local spawn_component = blackboard.spawn

	scratchpad.physics_world = spawn_component.physics_world

	local slot_system = Managers.state.extension:system("slot_system")

	slot_system:do_slot_search(unit, false)

	if action_data.randomized_direction_degree_range then
		local randomized_move_to_directions = {}

		self:_calculate_randomized_move_to_directions(unit, action_data, scratchpad, randomized_move_to_directions)

		scratchpad.randomized_move_to_directions = randomized_move_to_directions
	end

	scratchpad.move_to_cooldown = 0
	scratchpad.move_direction_index = 1
	scratchpad.find_move_position_attempts = 0
	scratchpad.max_distance_to_target_sq = action_data.max_distance_to_target^2

	navigation_extension:set_enabled(true, action_data.move_speed or breed.run_speed)

	local rotation_speed = action_data.rotation_speed

	if rotation_speed then
		scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()

		locomotion_extension:set_rotation_speed(rotation_speed)
	end

	scratchpad.time_to_next_evaluate = t + BtBeastOfNurgleMovementAction.TIME_TO_FIRST_EVALUATE

	local target_unit = perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]

	self:_move_to_target(unit, t, scratchpad, action_data, navigation_extension, target_position)

	scratchpad.min_move_duration = t + DEFAULT_MIN_MOVE_DURATION
	scratchpad.broadphase_system = Managers.state.extension:system("broadphase_system")
	scratchpad.pushed_enemies = {}
	scratchpad.push_nearby_players_frequency = action_data.push_nearby_players_frequency
end

BtBeastOfNurgleMovementAction.init_values = function (self, blackboard)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.movement_liquid_paint_id = 0
	behavior_component.vomit_liquid_paint_id = 0
end

BtBeastOfNurgleMovementAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		self:_set_anim_driven(unit, scratchpad, false)
	end

	local original_rotation_speed = scratchpad.original_rotation_speed

	if original_rotation_speed then
		scratchpad.locomotion_extension:set_rotation_speed(original_rotation_speed)
	end

	scratchpad.navigation_extension:set_enabled(false)

	local slot_system = Managers.state.extension:system("slot_system")

	slot_system:do_slot_search(unit, true)
end

local DISTANCE_SQ_CHANGE_TO_MOVE = 1

BtBeastOfNurgleMovementAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]
	local navigation_extension = scratchpad.navigation_extension
	local destination = navigation_extension:destination()
	local is_anim_driven = scratchpad.is_anim_driven

	if not is_anim_driven then
		local distance_to_destination_sq = Vector3.distance_squared(destination, target_position)

		if t >= scratchpad.move_to_cooldown and (distance_to_destination_sq > DISTANCE_SQ_CHANGE_TO_MOVE or not perception_component.has_line_of_sight) then
			self:_move_to_target(unit, t, scratchpad, action_data, navigation_extension, target_position)
		end
	end

	local behavior_component = scratchpad.behavior_component
	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if should_start_idle or should_be_idling then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)
		end

		MinionMovement.rotate_towards_target_unit(unit, scratchpad)

		scratchpad.time_to_next_evaluate = t + BtBeastOfNurgleMovementAction.CONSECUTIVE_EVALUATE_INTERVAL

		return "running", true
	end

	if not is_anim_driven then
		local target_distance = perception_component.target_distance

		if target_distance <= action_data.wanted_distance and perception_component.has_line_of_sight and t > scratchpad.min_move_duration then
			return action_data.done_on_arrival and "done" or "running"
		end
	end

	if action_data.liquid_area_template then
		self:_paint_liquid(unit, scratchpad, action_data)
	end

	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		self:_start_move_anim(unit, breed, t, scratchpad, action_data)
	else
		scratchpad.push_nearby_players_frequency = scratchpad.push_nearby_players_frequency - dt

		if scratchpad.push_nearby_players_frequency <= 0 then
			table.clear(scratchpad.pushed_enemies)

			scratchpad.push_nearby_players_frequency = action_data.push_nearby_players_frequency
		end

		local optional_only_ahead_targets = true

		MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit, optional_only_ahead_targets)
	end

	if is_anim_driven and scratchpad.start_rotation_timing and t >= scratchpad.start_rotation_timing then
		self:_update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	local direction_to_target = Vector3.normalize(POSITION_LOOKUP[target_unit] - POSITION_LOOKUP[unit])

	MinionMovement.update_ground_normal_rotation(unit, scratchpad, direction_to_target)

	return "running"
end

BtBeastOfNurgleMovementAction._start_move_anim = function (self, unit, breed, t, scratchpad, action_data, optional_moving_direction_name)
	local moving_direction_name = optional_moving_direction_name or MinionMovement.get_moving_direction_name(unit, scratchpad)
	local start_move_event
	local using_anim_driven = false

	if action_data.start_move_anim_events then
		local start_move_anim_events = action_data.start_move_anim_events

		start_move_event = Animation.random_event(start_move_anim_events[moving_direction_name])
		using_anim_driven = true
	end

	scratchpad.animation_extension:anim_event(start_move_event or action_data.run_anim_event)

	if using_anim_driven and moving_direction_name ~= "fwd" then
		self:_set_anim_driven(unit, scratchpad, true)

		local start_move_rotation_timings = action_data.start_move_rotation_timings
		local start_rotation_timing = start_move_rotation_timings[start_move_event]

		scratchpad.start_rotation_timing = t + start_rotation_timing
		scratchpad.move_start_anim_event_name = start_move_event
	else
		scratchpad.start_rotation_timing = nil
		scratchpad.move_start_anim_event_name = nil
	end

	local behavior_component = scratchpad.behavior_component

	behavior_component.move_state = "moving"
end

BtBeastOfNurgleMovementAction._update_anim_driven_start_rotation = function (self, unit, scratchpad, action_data, t)
	if not scratchpad.rotation_duration then
		local navigation_extension = scratchpad.navigation_extension
		local current_node, next_node_in_path = navigation_extension:current_and_next_node_positions_in_path()
		local destination = next_node_in_path or current_node
		local start_move_event_name = scratchpad.move_start_anim_event_name
		local start_move_anim_data = action_data.start_move_anim_data[start_move_event_name]
		local rotation_sign, rotation_radians = start_move_anim_data.sign, start_move_anim_data.rad
		local rotation_scale = Animation.calculate_anim_rotation_scale(unit, destination, rotation_sign, rotation_radians)

		scratchpad.locomotion_extension:set_anim_rotation_scale(rotation_scale)

		local rotation_duration = action_data.start_rotation_durations[start_move_event_name]

		scratchpad.rotation_duration = t + rotation_duration
	elseif t >= scratchpad.rotation_duration then
		scratchpad.start_rotation_timing = nil
		scratchpad.rotation_duration = nil

		self:_set_anim_driven(unit, scratchpad, false)
	end
end

BtBeastOfNurgleMovementAction._set_anim_driven = function (self, unit, scratchpad, set_anim_driven)
	MinionMovement.set_anim_driven(scratchpad, set_anim_driven)
end

local NAV_MESH_ABOVE = 0.7
local NAV_MESH_ABOVE_INCREMENT = 0.2
local NAV_MESH_BELOW = 2
local NAV_MESH_BELOW_INCREMENT = 0.2
local NAV_MESH_LATERAL_INCREMENT = 0.5
local DISTANCE_FROM_NAV_MESH = 0

BtBeastOfNurgleMovementAction._move_to_target = function (self, unit, t, scratchpad, action_data, navigation_extension, target_position)
	local nav_world, traverse_logic = navigation_extension:nav_world(), navigation_extension:traverse_logic()
	local attempts = scratchpad.find_move_position_attempts
	local above = NAV_MESH_ABOVE + attempts * NAV_MESH_ABOVE_INCREMENT
	local below = NAV_MESH_BELOW + attempts * NAV_MESH_BELOW_INCREMENT
	local lateral = attempts * NAV_MESH_LATERAL_INCREMENT
	local target_position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, target_position, above, below, lateral, DISTANCE_FROM_NAV_MESH)

	if scratchpad.move_to_target_absolute_position or action_data.move_to_target_absolute_position then
		if target_position_on_navmesh then
			navigation_extension:move_to(target_position_on_navmesh)

			scratchpad.find_move_position_attempts = 0
		else
			scratchpad.find_move_position_attempts = attempts + 1
		end

		return
	end

	local goal_position

	if target_position_on_navmesh then
		local unit_position = POSITION_LOOKUP[unit]
		local to_unit = unit_position - target_position
		local to_unit_direction = Vector3.normalize(to_unit)
		local to_unit_rotation = Quaternion.look(to_unit_direction)
		local move_direction_index = scratchpad.move_direction_index
		local randomized_move_to_directions = scratchpad.randomized_move_to_directions
		local randomized_direction = randomized_move_to_directions[move_direction_index]:unbox()
		local randomized_rotation = Quaternion.look(randomized_direction)
		local wanted_rotation = Quaternion.multiply(to_unit_rotation, randomized_rotation)
		local wanted_direction = Quaternion.forward(wanted_rotation)

		if move_direction_index == 1 then
			wanted_direction = Vector3.flat(Vector3.normalize(POSITION_LOOKUP[unit] - target_position))
		end

		local min_distance_to_target = action_data.min_distance_to_target
		local max_distance_to_target = action_data.max_distance_to_target
		local wanted_position = target_position_on_navmesh + wanted_direction * math.random_range(min_distance_to_target, max_distance_to_target)
		local _, hit_position = GwNavQueries.raycast(nav_world, target_position_on_navmesh, wanted_position, traverse_logic)
		local target_to_goal_distance = Vector3.distance(target_position_on_navmesh, hit_position)

		if min_distance_to_target < target_to_goal_distance then
			goal_position = hit_position
		end

		if not goal_position then
			if move_direction_index < #randomized_move_to_directions then
				scratchpad.move_direction_index = move_direction_index + 1
			else
				scratchpad.move_to_cooldown = t + action_data.move_to_fail_cooldown
				scratchpad.move_direction_index = 1

				table.shuffle(randomized_move_to_directions)

				scratchpad.move_to_target_absolute_position = true
			end
		end
	end

	if goal_position then
		navigation_extension:move_to(goal_position)

		scratchpad.find_move_position_attempts = 0
		scratchpad.move_to_cooldown = t + action_data.move_to_cooldown
	else
		scratchpad.find_move_position_attempts = attempts + 1
	end
end

BtBeastOfNurgleMovementAction._calculate_randomized_move_to_directions = function (self, unit, action_data, scratchpad, randomized_directions)
	local degree_range = action_data.randomized_direction_degree_range
	local degree_per_direction = action_data.degree_per_direction
	local num_directions = degree_range / degree_per_direction
	local current_degree = -(degree_range / 2)

	for i = 1, num_directions do
		current_degree = current_degree + degree_per_direction

		local radians = math.degrees_to_radians(current_degree)
		local direction = Vector3(math.sin(radians), math.cos(radians), 0)

		randomized_directions[i] = Vector3Box(direction)
	end

	table.shuffle(randomized_directions)

	return randomized_directions
end

BtBeastOfNurgleMovementAction._paint_liquid = function (self, unit, scratchpad, action_data)
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local position = POSITION_LOOKUP[unit]
	local liquid_paint_id = scratchpad.behavior_component[action_data.liquid_paint_id_from_component]
	local max_liquid_paint_distance = action_data.max_liquid_paint_distance
	local liquid_position = position + Vector3.up() * 0.5
	local nav_world = scratchpad.nav_world
	local liquid_area_template = action_data.liquid_area_template
	local allow_liquid_unit_creation = true
	local liquid_paint_brush_size = action_data.liquid_paint_brush_size
	local not_on_other_liquids = true
	local source_unit = unit
	local source_side = side and side:name()

	LiquidArea.paint(liquid_paint_id, max_liquid_paint_distance, liquid_position, nav_world, liquid_area_template, allow_liquid_unit_creation, liquid_paint_brush_size, not_on_other_liquids, source_unit, nil, source_side)
end

return BtBeastOfNurgleMovementAction
