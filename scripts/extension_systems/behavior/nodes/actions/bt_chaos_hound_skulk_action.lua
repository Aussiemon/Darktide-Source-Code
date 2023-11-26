-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_chaos_hound_skulk_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtChaosHoundSkulkAction = class("BtChaosHoundSkulkAction", "BtNode")

BtChaosHoundSkulkAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.combat_vector_extension = ScriptUnit.extension(unit, "combat_vector_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = navigation_extension

	local stagger_component = Blackboard.write_component(blackboard, "stagger")

	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = blackboard.perception
	scratchpad.stagger_component = stagger_component

	local combat_vector_component = blackboard.combat_vector

	scratchpad.combat_vector_component = combat_vector_component

	local speed = action_data.speed

	navigation_extension:set_enabled(true, speed)

	scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()

	locomotion_extension:set_rotation_speed(action_data.rotation_speed)

	scratchpad.current_combat_vector_position = Vector3Box()

	self:_move_to_combat_vector(scratchpad, combat_vector_component, navigation_extension)

	stagger_component.controlled_stagger = false
end

BtChaosHoundSkulkAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local locomotion_extension = scratchpad.locomotion_extension

	if scratchpad.stagger_duration then
		scratchpad.animation_extension:anim_event("stagger_finished")
		locomotion_extension:set_affected_by_gravity(false)
		locomotion_extension:set_movement_type("snap_to_navmesh")
	end

	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)
	scratchpad.navigation_extension:set_enabled(false)
end

local NEW_LOCATION_MIN_DIST = 10
local MIN_COMBAT_VECTOR_DISTANCE_CHANGE_SQ = 9

BtChaosHoundSkulkAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local combat_vector_component = scratchpad.combat_vector_component
	local wanted_position = combat_vector_component.position:unbox()
	local navigation_extension = scratchpad.navigation_extension
	local current_combat_vector_position = scratchpad.current_combat_vector_position:unbox()
	local distance_sq = Vector3.distance_squared(current_combat_vector_position, wanted_position)

	if distance_sq > MIN_COMBAT_VECTOR_DISTANCE_CHANGE_SQ then
		self:_move_to_combat_vector(scratchpad, combat_vector_component, navigation_extension)
	end

	local behavior_component = scratchpad.behavior_component
	local behavior_component, is_in_stagger = behavior_component, scratchpad.stagger_duration and t <= scratchpad.stagger_duration
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

	if navigation_extension:has_reached_destination() then
		scratchpad.combat_vector_extension:look_for_new_location(NEW_LOCATION_MIN_DIST)
	end

	return "running"
end

BtChaosHoundSkulkAction._start_move_anim = function (self, unit, scratchpad, action_data, t)
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

BtChaosHoundSkulkAction._move_to_combat_vector = function (self, scratchpad, combat_vector_component, navigation_extension)
	local wanted_position = combat_vector_component.position:unbox()

	navigation_extension:move_to(wanted_position)
	scratchpad.current_combat_vector_position:store(wanted_position)
end

BtChaosHoundSkulkAction._update_anim_lean_variable = function (self, unit, scratchpad, action_data)
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

return BtChaosHoundSkulkAction
