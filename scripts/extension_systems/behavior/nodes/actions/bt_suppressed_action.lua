-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_suppressed_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtSuppressedAction = class("BtSuppressedAction", "BtNode")

BtSuppressedAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local perception_component = blackboard.perception

	scratchpad.perception_component = perception_component

	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	scratchpad.locomotion_extension = locomotion_extension

	local anim_events
	local jump_anim_events = action_data.jump_anim_events
	local chance_of_jump_animation = action_data.chance_of_jump_animation
	local is_jumping = false

	if jump_anim_events and chance_of_jump_animation > math.random() then
		anim_events = self:_setup_jump_anim(unit, scratchpad, blackboard, jump_anim_events)
		is_jumping = true
	else
		anim_events = action_data.anim_events
	end

	local durations = is_jumping and action_data.jump_durations or action_data.durations

	self:_trigger_anim(unit, scratchpad, anim_events, durations, t)

	scratchpad.is_jumping = is_jumping
end

BtSuppressedAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event("stagger_finished")

	local out_of_suppression_anim_event = action_data.out_of_suppression_anim_event

	if out_of_suppression_anim_event then
		if type(out_of_suppression_anim_event) == "table" then
			local playing_suppressed_anim_event = scratchpad.suppressed_anim_event

			out_of_suppression_anim_event = out_of_suppression_anim_event[playing_suppressed_anim_event]
		end

		animation_extension:anim_event(out_of_suppression_anim_event)
	end

	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end
end

BtSuppressedAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local duration = scratchpad.duration

	if duration < t and scratchpad.is_jumping then
		self:_trigger_anim(unit, scratchpad, action_data.anim_events, action_data.durations, t)

		scratchpad.is_jumping = nil

		MinionMovement.set_anim_driven(scratchpad, false)
	end

	if not scratchpad.is_jumping then
		self:_rotate_towards_target_unit(unit, scratchpad)
	end

	return "running"
end

BtSuppressedAction._trigger_anim = function (self, unit, scratchpad, anim_events, durations, t)
	local anim_event = Animation.random_event(anim_events)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(anim_event)

	local duration = durations[anim_event]

	if type(duration) == "table" then
		duration = math.random_range(duration[1], duration[2])
	end

	scratchpad.suppressed_anim_event = anim_event
	scratchpad.duration = t + duration
end

BtSuppressedAction._setup_jump_anim = function (self, unit, scratchpad, blackboard, jump_anim_events)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.navigation_extension = navigation_extension

	MinionMovement.set_anim_driven(scratchpad, true)

	local chosen_anim_events
	local suppression_component = blackboard.suppression
	local direction = suppression_component.direction:unbox()
	local forward = Quaternion.forward(Unit.local_rotation(unit, 1))
	local dot = Vector3.dot(forward, direction)
	local use_bwd_and_fwd = math.random() > 0.5

	if use_bwd_and_fwd then
		local is_fwd = dot > 0

		if is_fwd then
			chosen_anim_events = jump_anim_events.bwd
		else
			chosen_anim_events = jump_anim_events.fwd
		end
	else
		local is_to_the_left = Vector3.cross(forward, direction).z > 0

		if is_to_the_left then
			chosen_anim_events = jump_anim_events.right
		else
			chosen_anim_events = jump_anim_events.left
		end
	end

	return chosen_anim_events
end

BtSuppressedAction._rotate_towards_target_unit = function (self, unit, scratchpad)
	local target_unit = scratchpad.perception_component.target_unit

	if HEALTH_ALIVE[target_unit] then
		local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

		scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)
	end
end

return BtSuppressedAction
