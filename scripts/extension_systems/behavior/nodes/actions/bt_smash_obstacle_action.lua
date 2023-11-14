require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Attack = require("scripts/utilities/attack/attack")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BtSmashObstacleAction = class("BtSmashObstacleAction", "BtNode")

BtSmashObstacleAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	if navigation_extension:use_smart_object(true) then
		local nav_smart_object_component = blackboard.nav_smart_object
		local target_unit = nav_smart_object_component.unit
		scratchpad.navigation_extension = navigation_extension
		scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
		scratchpad.target_unit = target_unit
		scratchpad.entrance_position = nav_smart_object_component.entrance_position
		scratchpad.exit_position = nav_smart_object_component.exit_position

		self:_start_rotate_towards_exit(unit, scratchpad, action_data, t)

		local target_unit_door_extension = ScriptUnit.has_extension(target_unit, "door_system")

		if target_unit_door_extension then
			target_unit_door_extension:increment_num_attackers()

			scratchpad.target_unit_door_extension = target_unit_door_extension
		end
	else
		scratchpad.failed_to_use_smart_object = true
	end
end

BtSmashObstacleAction._start_rotate_towards_exit = function (self, unit, scratchpad, action_data, t)
	local locomotion_extension = scratchpad.locomotion_extension
	local entrance_position = scratchpad.entrance_position:unbox()
	local exit_position = scratchpad.exit_position:unbox()
	local look_direction_wanted = Vector3.normalize(Vector3.flat(exit_position - entrance_position))
	local wanted_rotation = Quaternion.look(look_direction_wanted)
	scratchpad.wanted_rotation = QuaternionBox(wanted_rotation)
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

BtSmashObstacleAction._start_attack_anim = function (self, unit, blackboard, scratchpad, action_data, t)
	local attack_anim_events = action_data.attack_anim_events or "attack"
	local attack_event = Animation.random_event(attack_anim_events)
	local attack_anim_damage_timings = action_data.attack_anim_damage_timings
	local attack_damage_timing = attack_anim_damage_timings[attack_event]
	local attack_anim_durations = action_data.attack_anim_durations
	local attack_duration = attack_anim_durations[attack_event]
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(attack_event)

	scratchpad.attack_hit_time = t + attack_damage_timing
	scratchpad.attack_done_time = t + attack_duration
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.move_state = "attacking"
end

BtSmashObstacleAction._hit_target = function (self, unit, breed, target_unit, action_data)
	local damage_profile = action_data.damage_profile
	local damage_type = action_data.damage_type
	local power_level = action_data.power_level or Managers.state.difficulty:get_minion_attack_power_level(breed, "melee")

	Attack.execute(target_unit, damage_profile, "power_level", power_level, "attacking_unit", unit, "damage_type", damage_type, "attack_type", "door_smash")
end

BtSmashObstacleAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if not scratchpad.failed_to_use_smart_object then
		local locomotion_extension = scratchpad.locomotion_extension
		local original_rotation_speed = scratchpad.original_rotation_speed

		locomotion_extension:set_rotation_speed(original_rotation_speed)

		local navigation_extension = scratchpad.navigation_extension

		navigation_extension:use_smart_object(false)

		local target_unit_door_extension = scratchpad.target_unit_door_extension

		if target_unit_door_extension then
			target_unit_door_extension:decrement_num_attackers()
		end
	end
end

BtSmashObstacleAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.failed_to_use_smart_object then
		return "failed"
	end

	local rotation_done_time = scratchpad.rotation_done_time

	if rotation_done_time then
		if rotation_done_time <= t then
			scratchpad.rotation_done_time = nil

			self:_start_attack_anim(unit, blackboard, scratchpad, action_data, t)
		else
			local locomotion_extension = scratchpad.locomotion_extension
			local wanted_rotation = scratchpad.wanted_rotation:unbox()

			locomotion_extension:set_wanted_rotation(wanted_rotation)
		end
	end

	local attack_hit_time = scratchpad.attack_hit_time

	if attack_hit_time and attack_hit_time <= t then
		scratchpad.attack_hit_time = nil
		local target_unit = scratchpad.target_unit

		self:_hit_target(unit, breed, target_unit, action_data)
	end

	local attack_done_time = scratchpad.attack_done_time

	if attack_done_time and attack_done_time <= t then
		scratchpad.attack_done_time = nil

		return "done"
	end

	return "running"
end

return BtSmashObstacleAction
