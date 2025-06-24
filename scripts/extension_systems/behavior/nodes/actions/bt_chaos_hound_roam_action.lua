-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_chaos_hound_roam_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local NavQueries = require("scripts/utilities/nav_queries")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtChaosHoundRoamAction = class("BtChaosHoundRoamAction", "BtNode")

BtChaosHoundRoamAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.combat_vector_extension = ScriptUnit.extension(unit, "combat_vector_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = navigation_extension

	local stagger_component = Blackboard.write_component(blackboard, "stagger")

	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	scratchpad.perception_component = blackboard.perception
	scratchpad.stagger_component = stagger_component

	local summon_component = Blackboard.write_component(blackboard, "summon_unit")

	scratchpad.summon_component = summon_component
	scratchpad.owner_unit = summon_component.owner

	local speed = action_data.speed

	navigation_extension:set_enabled(true, speed)

	scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()

	locomotion_extension:set_rotation_speed(action_data.rotation_speed)
	self:_get_random_position(scratchpad, navigation_extension, t)
	self:_move_to(scratchpad, navigation_extension)

	stagger_component.controlled_stagger = false
end

BtChaosHoundRoamAction.init_values = function (self, blackboard)
	local summon_component = Blackboard.write_component(blackboard, "summon_unit")

	summon_component.owner = nil

	summon_component.last_owner_position:store(0, 0, 0)
end

BtChaosHoundRoamAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local perception_component = scratchpad.perception_component

	if not destroy and perception_component.aggro_state ~= "passive" then
		local perception_extension = scratchpad.perception_extension

		perception_extension:aggro()

		local alert_spread_radius, target_unit = 5, perception_component.target_unit

		if alert_spread_radius and ALIVE[target_unit] then
			local optional_require_los = true

			perception_extension:alert_nearby_allies(target_unit, alert_spread_radius, optional_require_los, nil)
		end
	end

	if scratchpad.stagger_duration then
		MinionMovement.stop_running_stagger(scratchpad)
	end

	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	scratchpad.locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)
	scratchpad.navigation_extension:set_enabled(false)
end

BtChaosHoundRoamAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local navigation_extension = scratchpad.navigation_extension
	local unit_position = POSITION_LOOKUP[unit]
	local wanted_position = scratchpad.current_goal_position:unbox()
	local distance = Vector3.distance(unit_position, wanted_position)
	local stuck = scratchpad.stuck_t

	if distance < 6 then
		self:_get_random_position(scratchpad, navigation_extension, t)
		self:_move_to(scratchpad, navigation_extension)
	elseif stuck < t then
		self:_get_random_position(scratchpad, navigation_extension, t)
		self:_move_to(scratchpad, navigation_extension)
	end

	local behavior_component, is_in_stagger = scratchpad.behavior_component, scratchpad.stagger_duration and t <= scratchpad.stagger_duration
	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if (should_start_idle or should_be_idling) and not is_in_stagger then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)
		end

		return "running"
	end

	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		self:_start_move_anim(unit, scratchpad, action_data, t)
	end

	if scratchpad.is_anim_driven and scratchpad.start_rotation_timing and t >= scratchpad.start_rotation_timing then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	if scratchpad.start_move_event_anim_speed_duration then
		if t < scratchpad.start_move_event_anim_speed_duration then
			MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
		else
			navigation_extension:set_max_speed(action_data.speed)

			scratchpad.start_move_event_anim_speed_duration = nil
		end
	end

	self:_update_anim_lean_variable(unit, scratchpad, action_data)
	MinionMovement.update_running_stagger(unit, t, dt, scratchpad, action_data)

	return "running"
end

BtChaosHoundRoamAction._start_move_anim = function (self, unit, scratchpad, action_data, t)
	local stagger_component = scratchpad.stagger_component

	if stagger_component.controlled_stagger then
		stagger_component.controlled_stagger = false
	end

	local start_move_anim_events = action_data.start_move_anim_events
	local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)
	local start_move_event = start_move_anim_events[moving_direction_name]

	scratchpad.animation_extension:anim_event(start_move_event)

	if moving_direction_name ~= "fwd" then
		MinionMovement.set_anim_driven(scratchpad, true)

		local start_rotation_timing = action_data.start_move_rotation_timings[start_move_event]

		scratchpad.start_rotation_timing = t + start_rotation_timing
		scratchpad.move_start_anim_event_name = start_move_event
	else
		scratchpad.start_rotation_timing = nil
		scratchpad.move_start_anim_event_name = nil
	end

	local start_move_event_anim_speed_duration = action_data.start_move_event_anim_speed_durations and action_data.start_move_event_anim_speed_durations[start_move_event]

	if start_move_event_anim_speed_duration then
		scratchpad.start_move_event_anim_speed_duration = t + start_move_event_anim_speed_duration
	end

	scratchpad.behavior_component.move_state = "moving"
end

local DEFAULT_RADIUS = {
	-15,
	15,
}
local NAV_MESH_ABOVE, NAV_MESH_BELOW = 5, 5
local DEFAULT_TRIES = 6

BtChaosHoundRoamAction._get_random_position = function (self, scratchpad, navigation_extension, t)
	local owner_unit = scratchpad.owner_unit

	if HEALTH_ALIVE[owner_unit] then
		local owner_position = POSITION_LOOKUP[owner_unit]

		if owner_position then
			scratchpad.summon_component.last_owner_position:store(owner_position)
		end
	end

	local last_owner_position = scratchpad.summon_component.last_owner_position:unbox()

	if last_owner_position then
		local nav_world, _ = scratchpad.navigation_extension:nav_world(), scratchpad.navigation_extension:traverse_logic()
		local wanted_position

		for i = 1, DEFAULT_TRIES do
			local range_x, range_y = math.random_range(DEFAULT_RADIUS[1], DEFAULT_RADIUS[2]), math.random_range(DEFAULT_RADIUS[1], DEFAULT_RADIUS[2])
			local target_position = Vector3(last_owner_position[1] + range_x, last_owner_position[2] + range_y, last_owner_position[3])

			wanted_position = NavQueries.position_on_mesh(nav_world, target_position, NAV_MESH_ABOVE, NAV_MESH_BELOW)

			if wanted_position then
				scratchpad.current_goal_position = Vector3Box(wanted_position)

				break
			else
				scratchpad.current_goal_position = Vector3Box(last_owner_position)
			end
		end
	end

	scratchpad.stuck_t = t + 10
end

BtChaosHoundRoamAction._move_to = function (self, scratchpad, navigation_extension)
	local wanted_position = scratchpad.current_goal_position:unbox()

	navigation_extension:move_to(wanted_position)
end

BtChaosHoundRoamAction._update_anim_lean_variable = function (self, unit, scratchpad, action_data)
	local is_following_path = scratchpad.navigation_extension:is_following_path()

	if not is_following_path then
		return
	end

	local lean_value = MinionMovement.get_lean_animation_variable_value(unit, scratchpad, action_data)

	if lean_value then
		local lean_variable_name = action_data.lean_variable_name

		scratchpad.animation_extension:set_variable(lean_variable_name, lean_value)
	end
end

return BtChaosHoundRoamAction
