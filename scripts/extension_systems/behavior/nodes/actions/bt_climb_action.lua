require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Catapulted = require("scripts/extension_systems/character_state_machine/character_states/utilities/catapulted")
local BtClimbAction = class("BtClimbAction", "BtNode")
local BASE_LAYER_EMPTY_EVENT = "base_layer_to_empty"

BtClimbAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	if navigation_extension:use_smart_object(true) then
		scratchpad.navigation_extension = navigation_extension

		if action_data.catapult_units then
			local side_system = Managers.state.extension:system("side_system")
			local side = side_system.side_by_unit[unit]
			local enemy_side_names = side:relation_side_names("enemy")
			scratchpad.enemy_side_names = enemy_side_names
			scratchpad.units_catapulted = {}
			scratchpad.side = side
			local broadphase_system = Managers.state.extension:system("broadphase_system")
			scratchpad.broadphase = broadphase_system.broadphase
		end

		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event(BASE_LAYER_EMPTY_EVENT)

		local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
		local nav_smart_object_component = blackboard.nav_smart_object
		scratchpad.animation_extension = animation_extension
		scratchpad.locomotion_extension = locomotion_extension
		scratchpad.nav_smart_object_component = nav_smart_object_component
		local spawn_component = blackboard.spawn
		local anim_translation_scale_factor = spawn_component.anim_translation_scale_factor
		scratchpad.anim_translation_scale_factor = anim_translation_scale_factor
		local entrance_position, exit_position, ledge_position = self:_calculate_jump(navigation_extension, nav_smart_object_component, scratchpad)

		self:_start_jump(unit, breed, action_data, t, scratchpad, locomotion_extension, entrance_position, exit_position, ledge_position)

		local behavior_component = Blackboard.write_component(blackboard, "behavior")
		behavior_component.move_state = "jumping"
		scratchpad.behavior_component = behavior_component
	else
		scratchpad.failed_to_use_smart_object = true
	end
end

BtClimbAction._calculate_jump = function (self, navigation_extension, nav_smart_object_component, scratchpad)
	local entrance_position = nav_smart_object_component.entrance_position:unbox()
	local exit_position = nav_smart_object_component.exit_position:unbox()
	local smart_object_data = navigation_extension:current_smart_object_data()
	local ledge_type = smart_object_data.ledge_type
	local ledge_position = nil

	if ledge_type == "thick_fence" then
		local ledge_position1 = smart_object_data.ledge_position1:unbox()
		local ledge_position2 = smart_object_data.ledge_position2:unbox()
		local distance_to_ledge_position_1_sq = Vector3.distance_squared(ledge_position1, entrance_position)
		local distance_to_ledge_position_2_sq = Vector3.distance_squared(ledge_position2, entrance_position)
		ledge_position = distance_to_ledge_position_1_sq < distance_to_ledge_position_2_sq and ledge_position1 or ledge_position2
		scratchpad.climb_height = ledge_position.z - entrance_position.z
		scratchpad.fall_height = ledge_position.z - exit_position.z
	elseif ledge_type == "narrow_fence" then
		ledge_position = smart_object_data.ledge_position:unbox()
		scratchpad.climb_height = ledge_position.z - entrance_position.z
		scratchpad.fall_height = ledge_position.z - exit_position.z
	elseif ledge_type == "edge" then
		if entrance_position.z <= exit_position.z then
			scratchpad.climb_height = exit_position.z - entrance_position.z
		else
			scratchpad.fall_height = entrance_position.z - exit_position.z
		end

		ledge_position = smart_object_data.ledge_position:unbox()
	end

	scratchpad.ledge_position = Vector3Box(ledge_position)
	scratchpad.jump_type = ledge_type == "edge" and "edge" or "fence"

	return entrance_position, exit_position, ledge_position
end

BtClimbAction._start_jump = function (self, unit, breed, action_data, t, scratchpad, locomotion_extension, entrance_position, exit_position, ledge_position)
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

	local jump_type = scratchpad.jump_type
	local climb_height = scratchpad.climb_height
	local smart_object_template = breed.smart_object_template

	if climb_height then
		local anim_thresholds = smart_object_template.jump_up_anim_thresholds
		local jump_event = self:_jump_anim_event(unit, climb_height, anim_thresholds, jump_type, scratchpad)
		scratchpad.ending_anim_event = jump_event
		scratchpad.jump_up_anim_event = jump_event
		local anim_timings = action_data.anim_timings
		local jump_duration = anim_timings[jump_event]
		scratchpad.climb_done_t = t + jump_duration
		scratchpad.climb_state = "climbing"
		local blend_timings = action_data.blend_timings
		local blend_duration = blend_timings and blend_timings[jump_event] or 0
		scratchpad.blend_timing = t + blend_duration
	else
		local fall_height = scratchpad.fall_height
		local anim_thresholds = smart_object_template.jump_down_anim_thresholds
		local jump_event = self:_jump_anim_event(unit, fall_height, anim_thresholds, jump_type, scratchpad)
		scratchpad.climb_state = "falling"
		scratchpad.jump_down_anim_event = jump_event
		local blend_timings = action_data.blend_timings
		local blend_duration = blend_timings and blend_timings[jump_event] or 0
		scratchpad.blend_timing = t + blend_duration
	end
end

BtClimbAction._jump_anim_event = function (self, unit, jump_height, anim_thresholds, jump_type, scratchpad)
	local animation_extension = scratchpad.animation_extension
	local locomotion_extension = scratchpad.locomotion_extension
	local num_anim_thresholds = #anim_thresholds

	for i = 1, num_anim_thresholds do
		local anim_threshold = anim_thresholds[i]

		if jump_height < anim_threshold.height_threshold then
			local jump_data = anim_threshold[jump_type]
			local jump_anim_data = jump_data.jump
			local jump_anim_events = jump_anim_data.anim_events
			local jump_event = Animation.random_event(jump_anim_events)

			animation_extension:anim_event(jump_event)

			local vertical_scale = 1
			local anim_vertical_length = jump_anim_data.anim_vertical_length

			if anim_vertical_length then
				vertical_scale = jump_height / anim_vertical_length
			end

			local horizontal_scale = 1
			local land_anim_data = jump_data.land
			local anim_horizontal_length = jump_anim_data.anim_horizontal_length

			if anim_horizontal_length then
				local nav_smart_object_component = scratchpad.nav_smart_object_component
				local unit_position = POSITION_LOOKUP[unit]
				local exit_position = nav_smart_object_component.exit_position:unbox()
				local jump_horizontal_length = Vector3.length(Vector3.flat(exit_position - unit_position))

				if land_anim_data then
					local land_horizontal_length = land_anim_data.anim_horizontal_length
					jump_horizontal_length = jump_horizontal_length - land_horizontal_length
				end

				horizontal_scale = jump_horizontal_length / anim_horizontal_length
			end

			local anim_translation_scale_factor = scratchpad.anim_translation_scale_factor
			local anim_translation_scale = anim_translation_scale_factor * Vector3(horizontal_scale, horizontal_scale, vertical_scale)

			locomotion_extension:set_anim_translation_scale(anim_translation_scale)

			if land_anim_data then
				local land_anim_events = land_anim_data.anim_events
				local land_event = Animation.random_event(land_anim_events)
				scratchpad.land_anim_event = land_event
			end

			return jump_event
		end
	end
end

BtClimbAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if not scratchpad.failed_to_use_smart_object then
		local locomotion_extension = scratchpad.locomotion_extension
		local anim_driven = false
		local affected_by_gravity = false
		local script_driven_rotation = false

		locomotion_extension:set_anim_driven(anim_driven, affected_by_gravity, script_driven_rotation)
		locomotion_extension:set_movement_type("snap_to_navmesh")
		locomotion_extension:set_anim_translation_scale(Vector3(1, 1, 1))

		local original_rotation_speed = scratchpad.original_rotation_speed

		locomotion_extension:set_rotation_speed(original_rotation_speed)
		scratchpad.navigation_extension:use_smart_object(false)

		if reason == "done" then
			local anim_event = scratchpad.ending_anim_event
			local ending_move_states = action_data.ending_move_states
			local ending_move_state = ending_move_states[anim_event]
			local behavior_component = scratchpad.behavior_component
			behavior_component.move_state = ending_move_state

			scratchpad.animation_extension:anim_event("climb_finished")
		end
	end
end

BtClimbAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
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

	if scratchpad.climb_state == "climbing" then
		self:_update_climbing(unit, breed, scratchpad, action_data, t)
	elseif scratchpad.climb_state == "falling" then
		self:_update_falling(unit, scratchpad, action_data, dt, t)
	elseif scratchpad.climb_state == "landing" then
		self:_update_landing(scratchpad, t)
	end

	if scratchpad.climb_state == "done" then
		return "done"
	else
		return "running"
	end
end

local ABOVE_NAV_MESH_CHECK = 0.25
local BELOW_NAV_MESH_CHECK = 0.25

BtClimbAction._is_unit_on_navmesh = function (self, unit, navigation_extension)
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()
	local unit_position = POSITION_LOOKUP[unit]
	local altitude = GwNavQueries.triangle_from_position(nav_world, unit_position, ABOVE_NAV_MESH_CHECK, BELOW_NAV_MESH_CHECK, traverse_logic)

	return altitude ~= nil
end

BtClimbAction._update_climbing = function (self, unit, breed, scratchpad, action_data, t)
	if scratchpad.units_catapulted ~= nil then
		self:_catapult_units(unit, scratchpad, action_data)
	end

	if scratchpad.climb_done_t <= t then
		local jump_type = scratchpad.jump_type

		if jump_type == "edge" then
			local navigation_extension = scratchpad.navigation_extension

			if self:_is_unit_on_navmesh(unit, navigation_extension) then
				local unit_position = POSITION_LOOKUP[unit]

				navigation_extension:set_nav_bot_position(unit_position)
			else
				local nav_smart_object_component = scratchpad.nav_smart_object_component
				local exit_position = nav_smart_object_component.exit_position:unbox()

				navigation_extension:set_nav_bot_position(exit_position)
				scratchpad.locomotion_extension:teleport_to(exit_position)

				local unit_position = POSITION_LOOKUP[unit]
			end

			scratchpad.climb_state = "done"
		else
			local fall_height = scratchpad.fall_height
			local smart_object_template = breed.smart_object_template
			local anim_thresholds = smart_object_template.jump_down_anim_thresholds
			local anim_event = self:_jump_anim_event(unit, fall_height, anim_thresholds, "fence", scratchpad)
			scratchpad.climb_state = "falling"
			scratchpad.jump_down_anim_event = anim_event
		end
	end
end

BtClimbAction._update_falling = function (self, unit, scratchpad, action_data, dt, t)
	if scratchpad.units_catapulted ~= nil then
		self:_catapult_units(unit, scratchpad, action_data)
	end

	local unit_position = POSITION_LOOKUP[unit]
	local nav_smart_object_component = scratchpad.nav_smart_object_component
	local exit_position = nav_smart_object_component.exit_position:unbox()
	local locomotion_extension = scratchpad.locomotion_extension
	local velocity = locomotion_extension:current_velocity()
	local land_check_height = velocity.z * dt * 2

	if unit_position.z + land_check_height <= exit_position.z then
		locomotion_extension:set_anim_translation_scale(Vector3(1, 1, 1))

		local teleport_position = Vector3(exit_position.x, exit_position.y, exit_position.z)

		Unit.set_local_position(unit, 1, teleport_position)
		locomotion_extension:set_movement_type("snap_to_navmesh")

		local animation_extension = scratchpad.animation_extension
		local land_anim_event = scratchpad.land_anim_event

		animation_extension:anim_event(land_anim_event)

		scratchpad.ending_anim_event = land_anim_event
		local land_timings = action_data.land_timings
		local jump_down_anim_event = scratchpad.jump_down_anim_event
		local jump_up_anim_event = scratchpad.jump_up_anim_event
		local jump_landing_duration = land_timings and (land_timings[jump_up_anim_event] or land_timings[jump_down_anim_event])

		if jump_landing_duration then
			scratchpad.land_done_t = t + jump_landing_duration
		else
			local anim_timings = action_data.anim_timings
			local land_duration = anim_timings[land_anim_event]
			scratchpad.land_done_t = t + land_duration
		end

		scratchpad.climb_state = "landing"
	end
end

BtClimbAction._update_landing = function (self, scratchpad, t)
	if scratchpad.land_done_t <= t then
		local nav_smart_object_component = scratchpad.nav_smart_object_component
		local exit_position = nav_smart_object_component.exit_position:unbox()
		local navigation_extension = scratchpad.navigation_extension

		navigation_extension:set_nav_bot_position(exit_position)

		scratchpad.climb_state = "done"
	end
end

local broadphase_results = {}

BtClimbAction._catapult_units = function (self, unit, scratchpad, action_data)
	local data = action_data.catapult_units
	local units_catapulted = scratchpad.units_catapulted
	local speed = data.speed
	local angle = data.angle
	local radius = data.radius
	local radius_sq = radius * radius
	local side = scratchpad.side
	local valid_enemy_player_units = side.valid_enemy_player_units
	local broadphase = scratchpad.broadphase
	local unit_position = POSITION_LOOKUP[unit]
	local enemy_side_names = scratchpad.enemy_side_names
	local num_results = broadphase:query(unit_position, radius, broadphase_results, enemy_side_names)

	for i = 1, num_results do
		local hit_unit = broadphase_results[i]
		local hit_position = POSITION_LOOKUP[hit_unit]
		local offset = hit_position - unit_position
		local distance_squared = Vector3.length_squared(offset)

		if not units_catapulted[hit_unit] and valid_enemy_player_units[hit_unit] and distance_squared < radius_sq then
			local length = speed * math.cos(angle)
			local height = speed * math.sin(angle)
			local flat_offset_direction = Vector3.normalize(Vector3.flat(offset))
			local push_velocity = flat_offset_direction * length
			push_velocity.z = height
			local target_unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
			local catapulted_state_input = target_unit_data_extension:write_component("catapulted_state_input")

			Catapulted.apply(catapulted_state_input, push_velocity)

			units_catapulted[hit_unit] = hit_unit
		end
	end
end

return BtClimbAction
