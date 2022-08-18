require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPatrols = require("scripts/utilities/minion_patrols")
local NavQueries = require("scripts/utilities/nav_queries")
local NavigationCostSettings = require("scripts/settings/navigation/navigation_cost_settings")
local BtPatrolAction = class("BtPatrolAction", "BtNode")
local NAV_TAG_LAYER_COSTS = {
	jumps = 30,
	ledges_with_fence = 30,
	doors = 10,
	teleporters = 20,
	ledges = 30
}
local DEFAULT_ROTATION_SPEED = 3.5

BtPatrolAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.animation_extension = animation_extension
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.behavior_component = behavior_component
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.navigation_extension = navigation_extension
	local nav_world = navigation_extension:nav_world()
	scratchpad.nav_world = nav_world
	local traverse_logic = navigation_extension:traverse_logic()
	scratchpad.traverse_logic = traverse_logic
	local walk_speed = breed.walk_speed

	navigation_extension:set_enabled(true, walk_speed)

	for nav_tag_name, cost in pairs(NAV_TAG_LAYER_COSTS) do
		navigation_extension:set_nav_tag_layer_cost(nav_tag_name, cost)
	end

	local patrol_component = Blackboard.write_component(blackboard, "patrol")
	scratchpad.patrol_component = patrol_component
	local patrol_index = patrol_component.patrol_index
	local is_patrol_leader = patrol_index == 1
	scratchpad.is_patrol_leader = is_patrol_leader

	if is_patrol_leader then
		GwNavBot.set_use_channel(navigation_extension._nav_bot, true)

		local patrol = Blackboard.write_component(blackboard, "patrol")
		local walk_position = patrol.walk_position:unbox()

		navigation_extension:move_to(walk_position)
	end

	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local current_rotation_speed = locomotion_extension:rotation_speed()
	scratchpad.original_rotation_speed = current_rotation_speed

	locomotion_extension:set_rotation_speed(DEFAULT_ROTATION_SPEED or action_data.rotation_speed)

	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.previous_speed = walk_speed
end

BtPatrolAction.init_values = function (self, blackboard)
	local patrol_component = Blackboard.write_component(blackboard, "patrol")

	patrol_component.walk_position:store(0, 0, 0)

	patrol_component.should_patrol = false
	patrol_component.patrol_leader_unit = nil
	patrol_component.patrol_index = 0
	patrol_component.patrol_id = 0
	patrol_component.auto_patrol = false
end

BtPatrolAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local navigation_extension = scratchpad.navigation_extension

	navigation_extension:set_enabled(false)

	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)

	scratchpad.behavior_component.move_state = "idle"
	local default_nav_tag_layers_minions = NavigationCostSettings.default_nav_tag_layers_minions

	for nav_tag_name, _ in pairs(NAV_TAG_LAYER_COSTS) do
		local default_cost = default_nav_tag_layers_minions[nav_tag_name]

		navigation_extension:set_nav_tag_layer_cost(nav_tag_name, default_cost)
	end

	local breed_nav_tag_allowed_layers = breed.nav_tag_allowed_layers

	if breed_nav_tag_allowed_layers then
		for nav_tag_name, cost in pairs(breed_nav_tag_allowed_layers) do
			navigation_extension:set_nav_tag_layer_cost(nav_tag_name, cost)
		end
	end

	if scratchpad.is_patrol_leader and not breed.use_navigation_path_splines then
		GwNavBot.set_use_channel(navigation_extension._nav_bot, false)
	end
end

local WAIT_AT_DESTINATION_TIME_RANGE = {
	4,
	14
}

BtPatrolAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	self:_update_patrolling(unit, breed, blackboard, scratchpad, action_data, dt, t)

	local patrol_component = scratchpad.patrol_component
	local behavior_component = scratchpad.behavior_component
	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)
	local is_patrol_leader = scratchpad.is_patrol_leader

	if is_patrol_leader then
		local navigation_extension = scratchpad.navigation_extension
		scratchpad.has_followed_path = scratchpad.has_followed_path or navigation_extension:is_following_path()

		if not scratchpad.wait_at_destination_t and is_patrol_leader and scratchpad.has_followed_path and navigation_extension:has_reached_destination() then
			scratchpad.wait_at_destination_t = t + math.random_range(WAIT_AT_DESTINATION_TIME_RANGE[1], WAIT_AT_DESTINATION_TIME_RANGE[2])
		end
	end

	if should_start_idle or should_be_idling then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)

			scratchpad.patrol_anim_end_at_t = nil
		end

		if scratchpad.wait_at_destination_t and scratchpad.wait_at_destination_t <= t then
			if patrol_component.auto_patrol then
				self:_set_new_patrol_position(unit, patrol_component)
			else
				patrol_component.walk_position:store(0, 0, 0)

				patrol_component.should_patrol = false
			end

			return "done"
		end

		return "running"
	end

	local move_state = behavior_component.move_state

	if move_state ~= "moving" or (scratchpad.patrol_anim_end_at_t and scratchpad.patrol_anim_end_at_t <= t) then
		self:_start_move_anim(unit, scratchpad, behavior_component, action_data, t)
	end

	return "running"
end

local DEFAULT_MOVE_ANIM_EVENT = "move_fwd"
local ANIM_VARIABLE_NAME = "anim_move_speed"
local DEFAULT_SPEED = 0.9
local MIN_VARIABLE_VALUE = 0.2
local MAX_VARIABLE_VALUE = 2

BtPatrolAction._start_move_anim = function (self, unit, scratchpad, behavior_component, action_data, t)
	behavior_component.move_state = "moving"

	self:_start_patrol_anim(unit, scratchpad, behavior_component, action_data, t)
end

BtPatrolAction._start_patrol_anim = function (self, unit, scratchpad, behavior_component, action_data, t)
	local move_event = Animation.random_event(action_data.anim_events or DEFAULT_MOVE_ANIM_EVENT)
	local speed = action_data.speeds[move_event] or DEFAULT_SPEED

	scratchpad.animation_extension:anim_event(move_event)
	scratchpad.navigation_extension:set_max_speed(speed)

	local variable_value = math.clamp(speed, 0, MAX_VARIABLE_VALUE)

	scratchpad.animation_extension:set_variable(ANIM_VARIABLE_NAME, variable_value)

	local duration = action_data.durations and action_data.durations[move_event]

	if duration then
		scratchpad.patrol_anim_end_at_t = t + duration
	end
end

local AHEAD_TRAVEL_DISTANCE_RANDOM_RANGE = {
	-30,
	30
}
local FALLBACK_DISTANCE_RANDOM_RANGE = {
	1,
	30
}
local NEW_PATROL_POSITION_TARGET_SIDE_ID = 1
local MIN_DISTANCE_TO_NEW_PATROL_POS = 2

BtPatrolAction._set_new_patrol_position = function (self, unit, patrol_component)
	local main_path_manager = Managers.state.main_path
	local _, ahead_travel_distance = main_path_manager:ahead_unit(NEW_PATROL_POSITION_TARGET_SIDE_ID)
	local random_offset = math.random_range(AHEAD_TRAVEL_DISTANCE_RANDOM_RANGE[1], AHEAD_TRAVEL_DISTANCE_RANDOM_RANGE[2])
	local total_path_distance = MainPathQueries.total_path_distance()
	local wanted_distance = math.clamp(ahead_travel_distance + random_offset, 0, total_path_distance)
	local wanted_position = MainPathQueries.position_from_distance(wanted_distance)
	local unit_position = POSITION_LOOKUP[unit]
	local distance = Vector3.distance(wanted_position, unit_position)

	if distance < MIN_DISTANCE_TO_NEW_PATROL_POS then
		local extra_offset = math.clamp(wanted_distance + math.random_range(FALLBACK_DISTANCE_RANDOM_RANGE[1], FALLBACK_DISTANCE_RANDOM_RANGE[2]), 0, total_path_distance)
		wanted_position = MainPathQueries.position_from_distance(extra_offset)
	end

	patrol_component.walk_position:store(wanted_position)
end

local ABOVE = 2
local BELOW = 2.5
local HOTIZONTAL = 2
local PATROL_OFFSET_SIDEWAYS = 1
local PATORL_OFFSET_BACK = 1.25
local SPEED_UP_DISTANCE = 0.5
local SLOW_DOWN_DISTANCE = 0.25
local MAX_SPEED_UP_SPEED = 0.1
local SLOW_DOWN_SPEED = 0.65
local LERP_FOLLOW_DIRECTION_SPEED = 0.5
local SPEED_LERP_SPEED = 2

BtPatrolAction._update_patrolling = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.is_patrol_leader or scratchpad.delayed_alert then
		return
	end

	local patrol_component = scratchpad.patrol_component
	local nav_world = scratchpad.nav_world
	local traverse_logic = scratchpad.traverse_logic
	local patrol_leader_unit = patrol_component.patrol_leader_unit

	if not HEALTH_ALIVE[patrol_leader_unit] then
		return
	end

	local patrol_index = patrol_component.patrol_index
	local patrol_leader_blackboard = BLACKBOARDS[patrol_leader_unit]
	local patrol_leader_perception_component = patrol_leader_blackboard.perception
	local patrol_leader_target_unit = patrol_leader_perception_component.target_unit

	if HEALTH_ALIVE[patrol_leader_target_unit] then
		local perception_extension = ScriptUnit.extension(unit, "perception_system")
		local optional_ignore_alerted_los = true

		perception_extension:delayed_alert(patrol_leader_target_unit, patrol_index * 0.5, optional_ignore_alerted_los)

		scratchpad.delayed_alert = true

		return
	end

	local patrol_leader_locomotion_extension = ScriptUnit.extension(patrol_leader_unit, "locomotion_system")
	local current_velocity = patrol_leader_locomotion_extension:current_velocity()
	local magnitude = Vector3.length(current_velocity)
	local velocity_normalized = Vector3.normalize(current_velocity)
	local current_follow_direction = nil

	if not scratchpad.current_follow_direction then
		current_follow_direction = velocity_normalized
		scratchpad.current_follow_direction = Vector3Box(velocity_normalized)
	else
		current_follow_direction = scratchpad.current_follow_direction:unbox()
		current_follow_direction = Vector3.lerp(current_follow_direction, velocity_normalized, dt * LERP_FOLLOW_DIRECTION_SPEED)

		scratchpad.current_follow_direction:store(current_follow_direction)
	end

	local patrol_leader_nav_extension = ScriptUnit.extension(patrol_leader_unit, "navigation_system")
	local _, is_right_side, is_left_side, is_third = MinionPatrols.get_follow_index(patrol_index)
	local follow_unit_rotation = Unit.local_rotation(patrol_leader_unit, 1)
	local follow_unit_position = POSITION_LOOKUP[patrol_leader_unit]
	local follow_unit_right, follow_unit_bwd = nil

	if magnitude > 0.05 then
		follow_unit_right = Vector3.cross(current_follow_direction, Vector3.up())
		follow_unit_bwd = -current_follow_direction
	else
		follow_unit_right = Quaternion.right(follow_unit_rotation)
		follow_unit_bwd = -Quaternion.forward(follow_unit_rotation)
	end

	local patrol_position = nil

	if is_third then
		patrol_position = follow_unit_position
	elseif is_right_side then
		patrol_position = follow_unit_position + follow_unit_right * PATROL_OFFSET_SIDEWAYS
	elseif is_left_side then
		patrol_position = follow_unit_position + -follow_unit_right * PATROL_OFFSET_SIDEWAYS
	end

	local back_offset = (is_third and 2) or 1
	patrol_position = patrol_position + follow_unit_bwd * PATORL_OFFSET_BACK * back_offset
	local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, patrol_position, ABOVE, BELOW, HOTIZONTAL)

	if not position_on_navmesh then
		return
	end

	local navigation_extension = scratchpad.navigation_extension

	navigation_extension:move_to(position_on_navmesh)

	local distance_to_patrol_position = Vector3.distance(POSITION_LOOKUP[unit], position_on_navmesh)
	local follow_unit_leader_speed = patrol_leader_nav_extension:max_speed()
	local new_speed = nil

	if SPEED_UP_DISTANCE < distance_to_patrol_position then
		new_speed = follow_unit_leader_speed + math.min(distance_to_patrol_position, MAX_SPEED_UP_SPEED)
	elseif distance_to_patrol_position < SLOW_DOWN_DISTANCE then
		new_speed = SLOW_DOWN_SPEED
	else
		local locomotion_extension = scratchpad.locomotion_extension
		local current_speed = Vector3.length(locomotion_extension:current_velocity())
		local speed_diff = distance_to_patrol_position - current_speed * dt
		new_speed = follow_unit_leader_speed - speed_diff
	end

	local previous_speed = scratchpad.previous_speed
	local wanted_speed = math.lerp(previous_speed, new_speed, dt * SPEED_LERP_SPEED)

	navigation_extension:set_max_speed(wanted_speed)

	scratchpad.previous_speed = wanted_speed
	local variable_value = math.clamp(wanted_speed, MIN_VARIABLE_VALUE, MAX_VARIABLE_VALUE)
	local old_variable_value = scratchpad.old_move_speed_variable

	if variable_value ~= old_variable_value then
		scratchpad.animation_extension:set_variable(ANIM_VARIABLE_NAME, variable_value)

		scratchpad.old_move_speed_variable = variable_value
	end
end

return BtPatrolAction
