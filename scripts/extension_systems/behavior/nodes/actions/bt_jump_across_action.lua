require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BtJumpAcrossAction = class("BtJumpAcrossAction", "BtNode")
local BASE_LAYER_EMPTY_EVENT = "base_layer_to_empty"

BtJumpAcrossAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	if navigation_extension:use_smart_object(true) then
		scratchpad.navigation_extension = navigation_extension
		local nav_smart_object_component = blackboard.nav_smart_object
		scratchpad.nav_smart_object_component = nav_smart_object_component
		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event(BASE_LAYER_EMPTY_EVENT)

		local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
		local spawn_component = blackboard.spawn
		local anim_translation_scale_factor = spawn_component.anim_translation_scale_factor
		local jump_anim_event = self:_start_jump(unit, breed, animation_extension, locomotion_extension, navigation_extension, nav_smart_object_component, anim_translation_scale_factor, scratchpad, action_data, t)
		scratchpad.locomotion_extension = locomotion_extension
		local behavior_component = Blackboard.write_component(blackboard, "behavior")
		behavior_component.move_state = "jumping"
		scratchpad.behavior_component = behavior_component
		local blend_timings = action_data.blend_timings
		local blend_duration = (blend_timings and blend_timings[jump_anim_event]) or 0
		scratchpad.blend_timing = t + blend_duration
	else
		scratchpad.failed_to_use_smart_object = true
	end
end

BtJumpAcrossAction._start_jump = function (self, unit, breed, animation_extension, locomotion_extension, navigation_extension, nav_smart_object_component, anim_translation_scale_factor, scratchpad, action_data, t)
	local entrance_position = nav_smart_object_component.entrance_position:unbox()
	local exit_position = nav_smart_object_component.exit_position:unbox()
	local entrance_to_exit_flat = Vector3.flat(exit_position - entrance_position)
	local wanted_rotation = Quaternion.look(entrance_to_exit_flat)
	scratchpad.wanted_rotation = QuaternionBox(wanted_rotation)
	local current_rotation_speed = locomotion_extension:rotation_speed()
	scratchpad.original_rotation_speed = current_rotation_speed
	local rotation = Unit.local_rotation(unit, 1)
	local look_direction = Quaternion.forward(rotation)
	local current_radians = math.atan2(look_direction.y, look_direction.x)
	local wanted_radians = math.atan2(entrance_to_exit_flat.y, entrance_to_exit_flat.x)
	local radians_to_rotate = math.abs(wanted_radians - current_radians)
	local rotation_duration = action_data.rotation_duration
	local wanted_rotation_speed = radians_to_rotate / rotation_duration

	locomotion_extension:set_rotation_speed(wanted_rotation_speed)
	locomotion_extension:set_movement_type("script_driven")
	locomotion_extension:teleport_to(entrance_position)

	local smart_object_data = navigation_extension:current_smart_object_data()
	local horizontal_length = smart_object_data.jump_flat_distance
	local smart_object_template = breed.smart_object_template
	local smart_object_type = nav_smart_object_component.type
	local anim_thresholds = smart_object_template.jump_across_anim_thresholds[smart_object_type] or smart_object_template.jump_across_anim_thresholds.jump
	local num_anim_thresholds = #anim_thresholds
	local jump_anim_event = nil

	for i = 1, num_anim_thresholds, 1 do
		local anim_threshold = anim_thresholds[i]

		if horizontal_length < anim_threshold.horizontal_threshold then
			jump_anim_event = Animation.random_event(anim_threshold.anim_events)

			animation_extension:anim_event(jump_anim_event)

			scratchpad.ending_anim_event = jump_anim_event
			local anim_timings = action_data.anim_timings
			local jump_duration = anim_timings[jump_anim_event]
			scratchpad.jump_done_t = t + jump_duration
			local animation_distance = anim_threshold.anim_horizontal_lengths or anim_threshold.anim_horizontal_length

			if type(animation_distance) == "table" then
				animation_distance = animation_distance[jump_anim_event]
			end

			local forward_factor = horizontal_length / animation_distance
			local jump_vector = exit_position - entrance_position
			local height_factor = jump_vector.z
			local anim_translation_scale = anim_translation_scale_factor * Vector3(forward_factor, forward_factor, height_factor)

			locomotion_extension:set_anim_translation_scale(anim_translation_scale)

			break
		end
	end

	return jump_anim_event
end

BtJumpAcrossAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if not scratchpad.failed_to_use_smart_object then
		local locomotion_extension = scratchpad.locomotion_extension

		locomotion_extension:set_anim_driven(false, false, false)
		locomotion_extension:set_movement_type("snap_to_navmesh")
		locomotion_extension:set_anim_translation_scale(Vector3(1, 1, 1))

		local original_rotation_speed = scratchpad.original_rotation_speed

		locomotion_extension:set_rotation_speed(original_rotation_speed)
		scratchpad.navigation_extension:use_smart_object(false)

		if reason == "done" then
			local anim_event = scratchpad.ending_anim_event
			local ending_move_states = action_data.ending_move_states
			local ending_move_state = ending_move_states[anim_event]

			fassert(ending_move_state, "[BtJumpAcrossAction] Missing ending move state for anim event %s.", anim_event)

			local behavior_component = scratchpad.behavior_component
			behavior_component.move_state = ending_move_state
		end
	end
end

local ABOVE_NAV_MESH_CHECK = 0.25
local BELOW_NAV_MESH_CHECK = 0.25

BtJumpAcrossAction._is_unit_on_navmesh = function (self, unit, navigation_extension)
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()
	local unit_position = POSITION_LOOKUP[unit]
	local altitude = GwNavQueries.triangle_from_position(nav_world, unit_position, ABOVE_NAV_MESH_CHECK, BELOW_NAV_MESH_CHECK, traverse_logic)

	return altitude ~= nil
end

BtJumpAcrossAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.failed_to_use_smart_object then
		return "failed"
	end

	if scratchpad.blend_timing and scratchpad.blend_timing <= t then
		local locomotion_extension = scratchpad.locomotion_extension
		local anim_driven = true
		local affected_by_gravity = false
		local script_driven_rotation = true

		locomotion_extension:set_anim_driven(anim_driven, affected_by_gravity, script_driven_rotation)

		scratchpad.blend_timing = nil
	end

	local wanted_rotation = scratchpad.wanted_rotation:unbox()
	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_wanted_rotation(wanted_rotation)

	if scratchpad.jump_done_t <= t then
		local navigation_extension = scratchpad.navigation_extension

		if self:_is_unit_on_navmesh(unit, navigation_extension) then
			local unit_position = POSITION_LOOKUP[unit]

			navigation_extension:set_nav_bot_position(unit_position)
		else
			local nav_smart_object_component = scratchpad.nav_smart_object_component
			local exit_position = nav_smart_object_component.exit_position:unbox()

			navigation_extension:set_nav_bot_position(exit_position)
			locomotion_extension:teleport_to(exit_position)
		end

		return "done"
	end

	return "running"
end

return BtJumpAcrossAction
