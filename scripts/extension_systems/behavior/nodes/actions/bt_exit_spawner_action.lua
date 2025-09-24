-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_exit_spawner_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BtExitSpawnerAction = class("BtExitSpawnerAction", "BtNode")
local BASE_LAYER_EMPTY_EVENT = "base_layer_to_empty"
local WANTED_DISTANCE_TO_EXIT = 0.01

BtExitSpawnerAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn
	local spawner_unit = spawn_component.spawner_unit
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	locomotion_extension:set_movement_type("script_driven")

	scratchpad.locomotion_extension = locomotion_extension

	local spawn_type, spawner_extension
	local has_spawner_extension = ScriptUnit.has_extension(spawner_unit, "minion_spawner_system")

	if has_spawner_extension then
		spawner_extension = ScriptUnit.extension(spawner_unit, "minion_spawner_system")
		spawn_type = spawner_extension:spawn_type()
	else
		spawn_type = "from_ground"
	end

	local spawn_type_anim_events = action_data.spawn_type_anim_events and action_data.spawn_type_anim_events[spawn_type]
	local anim_event

	if spawn_type_anim_events then
		anim_event = Animation.random_event(spawn_type_anim_events)
	else
		anim_event = Animation.random_event(action_data.run_anim_event)
	end

	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(anim_event)

	local anim_driven_anim_event_duration = action_data.anim_driven_anim_event_durations and action_data.anim_driven_anim_event_durations[anim_event]

	if anim_driven_anim_event_duration then
		animation_extension:anim_event(BASE_LAYER_EMPTY_EVENT)

		local spawn_type_anim_lengths = action_data.spawn_type_anim_lengths[spawn_type]
		local anim_lengths = spawn_type_anim_lengths[anim_event] or spawn_type_anim_lengths.default
		local spawn_index = spawn_component.spawner_spawn_index
		local spawn_height, spawn_horizontal_length

		if has_spawner_extension then
			spawn_height = spawner_extension:spawn_height(spawn_index)
			spawn_horizontal_length = spawner_extension:spawn_horizontal_length(spawn_index)
		else
			spawn_height = 1
			spawn_horizontal_length = 1
		end

		local anim_vertical_length = anim_lengths.vertical_length
		local vertical_scale = spawn_height / anim_vertical_length
		local anim_horizontal_length = anim_lengths.horizontal_length
		local horizontal_scale = spawn_horizontal_length / anim_horizontal_length
		local anim_translation_scale_factor = spawn_component.anim_translation_scale_factor
		local anim_translation_scale = anim_translation_scale_factor * Vector3(horizontal_scale, horizontal_scale, vertical_scale)

		locomotion_extension:set_anim_driven(true)
		locomotion_extension:use_lerp_rotation(false)
		locomotion_extension:set_anim_translation_scale(anim_translation_scale)

		scratchpad.anim_driven = true
		scratchpad.anim_duration = t + anim_driven_anim_event_duration
	elseif has_spawner_extension then
		scratchpad.exit_position = spawner_extension:exit_position_boxed()
	else
		scratchpad.exit_position = Vector3Box(POSITION_LOOKUP[unit])
	end

	scratchpad.spawn_position = Vector3Box(POSITION_LOOKUP[unit])
end

BtExitSpawnerAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local spawn_component = Blackboard.write_component(blackboard, "spawn")

	spawn_component.is_exiting_spawner = false
	spawn_component.spawner_unit = nil
	spawn_component.spawner_spawn_index = -1

	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_movement_type("snap_to_navmesh")

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local destination, spawn_position = navigation_extension:destination(), scratchpad.spawn_position:unbox()

	if not destroy and Vector3.equal(destination, spawn_position) then
		navigation_extension:stop()
	end

	if scratchpad.anim_driven then
		locomotion_extension:set_anim_driven(false)
		locomotion_extension:use_lerp_rotation(true)
		locomotion_extension:set_anim_translation_scale(Vector3(1, 1, 1))
	end

	local slot_extension = ScriptUnit.has_extension(unit, "slot_system")

	if slot_extension then
		local slot_system = Managers.state.extension:system("slot_system")

		slot_system:register_prioritized_user_unit_update(unit)
	end
end

BtExitSpawnerAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.anim_duration then
		if t >= scratchpad.anim_duration then
			return "done"
		end

		return "running"
	end

	local unit_position, exit_position = POSITION_LOOKUP[unit], scratchpad.exit_position:unbox()
	local exit_vector = exit_position - unit_position
	local exit_direction, distance_to_exit = Vector3.direction_length(exit_vector)

	if distance_to_exit > WANTED_DISTANCE_TO_EXIT then
		local move_speed = breed.run_speed

		if distance_to_exit < move_speed * dt then
			move_speed = distance_to_exit / dt
		end

		local wanted_velocity = exit_direction * move_speed

		scratchpad.locomotion_extension:set_wanted_velocity(wanted_velocity)

		return "running"
	else
		return "done"
	end
end

return BtExitSpawnerAction
