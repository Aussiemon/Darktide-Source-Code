require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BtOpenDoorAction = class("BtOpenDoorAction", "BtNode")
local DEFAULT_OPEN_DOOR_ANIM_EVENT = "idle"

BtOpenDoorAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	if navigation_extension:use_smart_object(true) then
		local nav_smart_object_component = blackboard.nav_smart_object
		local door_unit = nav_smart_object_component.unit
		local entrance_position = nav_smart_object_component.entrance_position:unbox()
		local exit_position = nav_smart_object_component.exit_position:unbox()
		scratchpad.navigation_extension = navigation_extension
		scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
		scratchpad.door_unit_extension = ScriptUnit.extension(door_unit, "door_system")

		self:_start_rotate_towards_exit(unit, scratchpad, action_data, t, entrance_position, exit_position)
	else
		scratchpad.failed_to_use_smart_object = true
	end
end

BtOpenDoorAction._start_rotate_towards_exit = function (self, unit, scratchpad, action_data, t, entrance_position, exit_position)
	local look_direction_wanted = Vector3.normalize(Vector3.flat(exit_position - entrance_position))
	local wanted_rotation = Quaternion.look(look_direction_wanted)
	scratchpad.wanted_rotation = QuaternionBox(wanted_rotation)
	local locomotion_extension = scratchpad.locomotion_extension
	local current_rotation_speed = locomotion_extension:rotation_speed()
	scratchpad.original_rotation_speed = current_rotation_speed
	local rotation = Unit.local_rotation(unit, 1)
	local look_direction = Quaternion.forward(rotation)
	local radians = Vector3.angle(look_direction, look_direction_wanted)
	local rotation_duration = action_data.rotation_duration
	local wanted_rotation_speed = radians / rotation_duration

	locomotion_extension:set_rotation_speed(wanted_rotation_speed)

	scratchpad.rotation_done_time = t + rotation_duration
end

BtOpenDoorAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if not scratchpad.failed_to_use_smart_object then
		local locomotion_extension = scratchpad.locomotion_extension
		local original_rotation_speed = scratchpad.original_rotation_speed

		locomotion_extension:set_rotation_speed(original_rotation_speed)

		local navigation_extension = scratchpad.navigation_extension

		navigation_extension:use_smart_object(false)
	end
end

local DEFAULT_DOOR_OPEN_TIME_OFFSET = 0.2

BtOpenDoorAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.failed_to_use_smart_object then
		return "failed"
	end

	local door_unit_extension = scratchpad.door_unit_extension
	local rotation_done_time = scratchpad.rotation_done_time

	if rotation_done_time then
		if rotation_done_time <= t then
			if door_unit_extension:can_open() then
				local open_door_time = action_data.open_door_time
				local offset = action_data.open_door_time_offset

				door_unit_extension:open(nil, unit, open_door_time and open_door_time + (offset or DEFAULT_DOOR_OPEN_TIME_OFFSET) or offset)

				scratchpad.rotation_done_time = nil
				scratchpad.open_door_time = t + (open_door_time or 0)
				local behavior_component = Blackboard.write_component(blackboard, "behavior")
				local animation_extension = ScriptUnit.extension(unit, "animation_system")

				animation_extension:anim_event(action_data.open_door_anim_event or DEFAULT_OPEN_DOOR_ANIM_EVENT)

				behavior_component.move_state = "idle"
			end
		else
			local locomotion_extension = scratchpad.locomotion_extension
			local wanted_rotation = scratchpad.wanted_rotation:unbox()

			locomotion_extension:set_wanted_rotation(wanted_rotation)
		end
	elseif door_unit_extension:can_open() then
		local open_door_time = action_data.open_door_time
		local offset = action_data.open_door_time_offset

		door_unit_extension:open(nil, unit, open_door_time and open_door_time + (offset or DEFAULT_DOOR_OPEN_TIME_OFFSET) or offset)

		scratchpad.open_door_time = t + (open_door_time or 0)
	end

	if not door_unit_extension:nav_blocked() and (not scratchpad.open_door_time or scratchpad.open_door_time <= t) then
		return "done"
	end

	return "running"
end

return BtOpenDoorAction
