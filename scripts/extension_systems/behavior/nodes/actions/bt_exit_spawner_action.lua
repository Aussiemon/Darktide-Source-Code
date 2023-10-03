require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BtExitSpawnerAction = class("BtExitSpawnerAction", "BtNode")
local WANTED_DISTANCE_TO_EXIT_SQ = 0.010000000000000002

BtExitSpawnerAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn
	local spawner_unit = spawn_component.spawner_unit
	local spawner_extension = ScriptUnit.extension(spawner_unit, "minion_spawner_system")
	scratchpad.exit_position = spawner_extension:exit_position_boxed()
	local spawn_type = spawner_extension:spawn_type()
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.locomotion_extension = locomotion_extension
	local spawn_type_anim_events = action_data.spawn_type_anim_events and action_data.spawn_type_anim_events[spawn_type]
	local anim_event = nil

	if spawn_type_anim_events then
		anim_event = Animation.random_event(spawn_type_anim_events)
	else
		anim_event = Animation.random_event(action_data.run_anim_event)
	end

	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(anim_event)

	if action_data.anim_driven_anim_event_durations and action_data.anim_driven_anim_event_durations[anim_event] then
		locomotion_extension:set_anim_driven(true)
		locomotion_extension:use_lerp_rotation(false)

		scratchpad.anim_driven = true
		scratchpad.anim_duration = t + action_data.anim_driven_anim_event_durations[anim_event]
	else
		locomotion_extension:set_movement_type("script_driven")
	end
end

BtExitSpawnerAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local spawn_component = Blackboard.write_component(blackboard, "spawn")
	spawn_component.is_exiting_spawner = false
	spawn_component.spawner_unit = nil

	scratchpad.locomotion_extension:set_movement_type("snap_to_navmesh")

	if scratchpad.anim_driven then
		scratchpad.locomotion_extension:set_anim_driven(false)
		scratchpad.locomotion_extension:use_lerp_rotation(true)
	end

	local exit_position = scratchpad.exit_position:unbox()
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	navigation_extension:set_nav_bot_position(exit_position)
	scratchpad.locomotion_extension:teleport_to(exit_position)

	local slot_system = Managers.state.extension:system("slot_system")
	local slot_extension = ScriptUnit.has_extension(unit, "slot_system")

	if slot_extension then
		slot_system:register_prioritized_user_unit_update(unit)
	end
end

BtExitSpawnerAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.anim_duration then
		if scratchpad.anim_duration <= t then
			return "done"
		end

		return "running"
	end

	local unit_position = POSITION_LOOKUP[unit]
	local exit_position = scratchpad.exit_position:unbox()
	local exit_vector = exit_position - unit_position
	local distance_to_exit_sq = Vector3.length_squared(exit_vector)

	if WANTED_DISTANCE_TO_EXIT_SQ < distance_to_exit_sq then
		local exit_direction = Vector3.normalize(exit_vector)
		local move_speed = breed.run_speed
		local exit_velocity = exit_direction * move_speed
		local locomotion_extension = scratchpad.locomotion_extension

		locomotion_extension:set_wanted_velocity(exit_velocity)

		return "running"
	else
		return "done"
	end
end

return BtExitSpawnerAction
