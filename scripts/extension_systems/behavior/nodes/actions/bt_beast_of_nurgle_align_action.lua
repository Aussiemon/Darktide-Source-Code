-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_beast_of_nurgle_align_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Component = require("scripts/utilities/component")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtBeastOfNurgleAlignAction = class("BtBeastOfNurgleAlignAction", "BtNode")

BtBeastOfNurgleAlignAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = navigation_extension

	local nav_world = navigation_extension:nav_world()

	scratchpad.nav_world = nav_world

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	scratchpad.behavior_component = behavior_component

	local perception_component = blackboard.perception

	scratchpad.perception_component = perception_component

	local rotation_speed = action_data.rotation_speed

	if rotation_speed then
		scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()

		locomotion_extension:set_rotation_speed(rotation_speed)
	end

	scratchpad.behavior_component.move_state = "idle"

	local self_flat_fwd = Vector3.flat(Quaternion.forward(Unit.local_rotation(unit, 1)))

	Unit.set_local_rotation(unit, 1, Quaternion.look(self_flat_fwd))
end

BtBeastOfNurgleAlignAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		self:_set_anim_driven(unit, scratchpad, false)
	end

	local original_rotation_speed = scratchpad.original_rotation_speed

	if original_rotation_speed then
		scratchpad.locomotion_extension:set_rotation_speed(original_rotation_speed)
	end
end

BtBeastOfNurgleAlignAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local started_aligning = scratchpad.started_aligning

	if not started_aligning then
		local dont_need_to_align = self:_start_align_anim(unit, breed, t, scratchpad, action_data)

		if dont_need_to_align then
			return "done"
		end
	end

	local is_anim_driven = scratchpad.is_anim_driven

	if is_anim_driven and scratchpad.start_rotation_timing and t >= scratchpad.start_rotation_timing then
		local done = self:_update_anim_driven_start_rotation(unit, scratchpad, action_data, t)

		if done then
			return "done"
		end
	end

	if scratchpad.align_duration and t >= scratchpad.align_duration then
		return "done"
	elseif scratchpad.align_duration and t > scratchpad.align_rotation_duration then
		self:_rotate_towards_target_unit(unit, scratchpad)
	end

	return "running"
end

BtBeastOfNurgleAlignAction._start_align_anim = function (self, unit, breed, t, scratchpad, action_data)
	local spline_component = Component.get_components_by_name(unit, "BeastOfNurgle")
	local _, rotation = spline_component[1]:get_spline_position_rotation(1)
	local forward = Quaternion.forward(rotation)
	local right = Quaternion.right(rotation)
	local position = POSITION_LOOKUP[unit]
	local target_position = POSITION_LOOKUP[scratchpad.perception_component.target_unit]
	local direction = Vector3.flat(Vector3.normalize(target_position - position))
	local moving_direction_name = MinionMovement.get_relative_direction_name(right, forward, direction)
	local align_anim_events = action_data.align_anim_events
	local align_anim_event = Animation.random_event(align_anim_events[moving_direction_name])

	scratchpad.animation_extension:anim_event(align_anim_event)

	local dont_need_to_align = false

	if moving_direction_name ~= "fwd" then
		self:_set_anim_driven(unit, scratchpad, true)

		local start_move_rotation_timings = action_data.start_move_rotation_timings
		local start_rotation_timing = start_move_rotation_timings[align_anim_event]

		scratchpad.start_rotation_timing = t + start_rotation_timing
		scratchpad.move_start_anim_event_name = align_anim_event
	else
		local align_duration = action_data.align_durations and action_data.align_durations[align_anim_event]

		if align_duration then
			scratchpad.align_duration = t + align_duration
			scratchpad.align_rotation_duration = t + action_data.align_rotation_durations[align_anim_event]
		else
			dont_need_to_align = true
		end
	end

	scratchpad.started_aligning = true

	return dont_need_to_align
end

BtBeastOfNurgleAlignAction._update_anim_driven_start_rotation = function (self, unit, scratchpad, action_data, t)
	if not scratchpad.rotation_duration then
		local destination = POSITION_LOOKUP[scratchpad.perception_component.target_unit]
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

		return true
	end

	return false
end

BtBeastOfNurgleAlignAction._set_anim_driven = function (self, unit, scratchpad, set_anim_driven)
	MinionMovement.set_anim_driven(scratchpad, set_anim_driven)
end

BtBeastOfNurgleAlignAction._rotate_towards_target_unit = function (self, unit, scratchpad)
	if not ALIVE[scratchpad.perception_component.target_unit] then
		return
	end

	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, scratchpad.perception_component.target_unit)
	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_wanted_rotation(flat_rotation)
end

return BtBeastOfNurgleAlignAction
