-- chunkname: @scripts/extension_systems/first_person/player_unit_first_person_extension.lua

local DefaultGameParameters = require("scripts/foundation/utilities/parameters/default_game_parameters")
local FirstPersonAnimationVariables = require("scripts/utilities/first_person_animation_variables")
local FirstPersonLookDeltaAnimationControl = require("scripts/extension_systems/first_person/first_person_look_delta_animation_control")
local FirstPersonRunSpeedAnimationControl = require("scripts/extension_systems/first_person/first_person_run_speed_animation_control")
local ForceLookRotation = require("scripts/extension_systems/first_person/utilities/force_look_rotation")
local MaterialFx = require("scripts/utilities/material_fx")
local PlayerUnitPeeking = require("scripts/utilities/player_unit_peeking")
local Recoil = require("scripts/utilities/recoil")
local FOOTSTEP_SOUND_ALIAS = "footstep_right" or "footstep_left"
local UPPER_BODY_FOLEY = "sfx_foley_upper_body"
local WEAPON_FOLEY = "sfx_weapon_locomotion"
local EXTRA_FOLEY = "sfx_player_extra_slot"
local PlayerUnitFirstPersonExtension = class("PlayerUnitFirstPersonExtension")

PlayerUnitFirstPersonExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	local world = extension_init_context.world
	local wwise_world = extension_init_context.wwise_world
	local physics_world = extension_init_context.physics_world
	local breed = extension_init_data.breed

	self._wwise_world = wwise_world
	self._world = world
	self._unit = unit
	self._player = extension_init_data.player
	self._is_local_unit = extension_init_data.is_local_unit
	self._force_third_person_mode = extension_init_data.force_third_person_mode

	local is_server = extension_init_context.is_server

	self._is_server = is_server

	local heights = extension_init_data.heights

	self._heights = heights

	local character_height = heights.default

	if is_server then
		local game_object_data = ...

		game_object_data.character_height = character_height
	else
		local session, id = ...

		self._game_session = session
		self._game_object_id = id
	end

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._unit_data_extension = unit_data_extension

	local character_state_component = unit_data_extension:read_component("character_state")
	local sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
	local movement_state_component = unit_data_extension:read_component("movement_state")
	local weapon_action_component = unit_data_extension:read_component("weapon_action")
	local alternate_fire_component = unit_data_extension:read_component("alternate_fire")

	self._locomotion_component = unit_data_extension:read_component("locomotion")
	self._recoil_component = unit_data_extension:read_component("recoil")
	self._character_state_component = character_state_component
	self._movement_state_component = movement_state_component
	self._move_z = 0
	self._move_x = 0
	self._look_delta_y = 0
	self._look_delta_x = 0
	self._extrapolated_character_height = character_height
	self._last_fixed_t = Managers.time:time("gameplay")

	local input_extension = ScriptUnit.extension(unit, "input_system")

	self._input_extension = input_extension

	local yaw, pitch, roll = input_extension:get_orientation()
	local look_rotation = Quaternion.from_yaw_pitch_roll(yaw, pitch, roll)
	local pose_scale = breed.first_person_pose_scale or 1
	local position_root = Unit.local_position(unit, 1)
	local offset_height = Vector3(0, 0, character_height)
	local position = position_root + offset_height
	local unit_name = extension_init_data.unit_name
	local unit_spawner_manager = Managers.state.unit_spawner
	local pose = Matrix4x4.from_quaternion_position(look_rotation, position)

	Matrix4x4.set_scale(pose, Vector3(pose_scale, pose_scale, pose_scale))

	local first_person_unit = unit_spawner_manager:spawn_unit(unit_name, pose)

	self._first_person_unit = first_person_unit

	Unit.set_data(first_person_unit, "owner_unit", unit)

	local first_person_component = unit_data_extension:write_component("first_person")

	first_person_component.height_change_duration = 0
	first_person_component.height_change_start_time = 0
	first_person_component.height = character_height
	first_person_component.wanted_height = character_height
	first_person_component.old_height = character_height
	first_person_component.position = position
	first_person_component.rotation = look_rotation
	first_person_component.previous_rotation = look_rotation
	first_person_component.height_change_function = "ease_out_quad"
	self._first_person_component = first_person_component
	self._heights = extension_init_data.heights

	local first_person_mode_component = unit_data_extension:write_component("first_person_mode")

	first_person_mode_component.wants_1p_camera = true
	first_person_mode_component.show_1p_equipment_at_t = 0
	self._first_person_mode_component = unit_data_extension:read_component("first_person_mode")
	self._is_camera_follow_target = false
	self._is_first_person_spectated = false
	self._fixed_time_step = Managers.state.game_session.fixed_time_step

	local fixed_t = extension_init_context.fixed_frame * self._fixed_time_step

	self._show_1p_equipment, self._wants_1p_camera = self:_update_first_person_mode(fixed_t)

	local force_look_rotation_component = unit_data_extension:write_component("force_look_rotation")

	force_look_rotation_component.use_force_look_rotation = false
	force_look_rotation_component.start_yaw = 0
	force_look_rotation_component.start_pitch = 0
	force_look_rotation_component.wanted_pitch = 0
	force_look_rotation_component.wanted_yaw = 0
	force_look_rotation_component.start_time = 0
	force_look_rotation_component.end_time = 0
	self._force_look_rotation_component = force_look_rotation_component

	local peeking_component = unit_data_extension:write_component("peeking")

	peeking_component.has_significant_obstacle_in_front = false
	peeking_component.in_cover = false
	peeking_component.peeking_is_possible = false
	peeking_component.is_peeking = false
	peeking_component.peeking_height = 0.5
	self._peeking_component = peeking_component
	self._inair_state_component = unit_data_extension:read_component("inair_state")
	self._state_machine_lerp_values = {}
	self._footstep_time = 0
	self._right_foot_next = true

	local feet_source_id = WwiseWorld.make_manual_source(wwise_world, unit, 1)

	self._footstep_context = {
		foley_source_id = nil,
		fx_extension = nil,
		locomotion_extension = nil,
		unit = unit,
		breed = breed,
		alternate_fire_component = alternate_fire_component,
		character_state_component = character_state_component,
		movement_state_component = movement_state_component,
		sprint_character_state_component = sprint_character_state_component,
		weapon_action_component = weapon_action_component,
		feet_source_id = feet_source_id,
		world = world,
		physics_world = physics_world,
		wwise_world = wwise_world,
	}
	self._previous_frame_character_state_name = character_state_component.state_name
	self._1p_peeking_animation_data = {}
	self._3p_peeking_animation_data = {}
end

PlayerUnitFirstPersonExtension.extensions_ready = function (self, world, unit)
	local first_person_unit = self._first_person_unit
	local is_husk = false

	self._run_animation_speed_control = FirstPersonRunSpeedAnimationControl:new(first_person_unit, unit)
	self._look_delta_animation_control = FirstPersonLookDeltaAnimationControl:new(first_person_unit, unit, is_husk)
	self._weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	self._footstep_context.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	self._footstep_context.fx_extension = ScriptUnit.extension(unit, "fx_system")
	self._footstep_context.foley_source_id = WwiseWorld.make_manual_source(self._wwise_world, first_person_unit, 1)
	self._ledge_finder_extension = ScriptUnit.has_extension(unit, "ledge_finder_system")
end

PlayerUnitFirstPersonExtension.game_object_initialized = function (self, session, id)
	self._game_session = session
	self._game_object_id = id
end

PlayerUnitFirstPersonExtension.destroy = function (self)
	local unit_spawner_manager = Managers.state.unit_spawner

	unit_spawner_manager:mark_for_deletion(self._first_person_unit)

	local wwise_world = self._wwise_world
	local feet_source_id = self._feet_source_id
	local foley_source_id = self._footstep_context.foley_source_id

	if feet_source_id then
		WwiseWorld.destroy_manual_source(wwise_world, feet_source_id)
	end

	if foley_source_id then
		WwiseWorld.destroy_manual_source(wwise_world, foley_source_id)
	end
end

local function _ease_out_quad(t, b, c, d)
	t = t / d

	local res = -c * t * (t - 2) + b

	return res
end

PlayerUnitFirstPersonExtension.default_height = function (self, state_name)
	return self._heights[state_name]
end

local function _ease_in_cubic(t, b, c, d)
	local p = t / d

	t = p * p * p

	local res = math.lerp(b, b + c, t)

	return res
end

local function _calculate_base_player_height(fp_component, t)
	local time_changing_height = t - fp_component.height_change_start_time
	local duration = fp_component.height_change_duration

	if time_changing_height < duration then
		local old_height = fp_component.old_height
		local new_height
		local height_change_function = fp_component.height_change_function

		if height_change_function == "ease_in_cubic" then
			new_height = _ease_in_cubic(time_changing_height, old_height, fp_component.wanted_height - old_height, duration)
		else
			new_height = _ease_out_quad(time_changing_height, old_height, fp_component.wanted_height - old_height, duration)
		end

		return new_height
	else
		return fp_component.wanted_height
	end
end

local half_pi = math.half_pi
local height_per_half_pi = 2.5 / half_pi

local function _peeking_player_height(unmodified_look_rotation, peeking_component, crouch_height, default_height, fp_component, last_fixed_t, t, fixed_time_step)
	local up = Vector3.up()
	local forward = Quaternion.forward(unmodified_look_rotation)
	local angle = math.acos(Vector3.dot(forward, up))
	local p = angle - half_pi
	local peeking_height = peeking_component.peeking_height

	peeking_height = peeking_height + height_per_half_pi * (p / half_pi)
	peeking_height = math.clamp(peeking_height, crouch_height, default_height)

	local current_height = fp_component.height
	local delta = peeking_height - current_height
	local abs_delta = math.abs(delta)

	if abs_delta > 0.001 then
		local height_speed_min = 0.03 / fixed_time_step
		local height_speed_max = 0.07 / fixed_time_step
		local height_speed_per_fixed_frame = math.remap(0.2, 0.4, height_speed_min, height_speed_max, abs_delta)
		local time = t - last_fixed_t
		local sign = math.sign(delta)

		if sign == 1 then
			current_height = math.min(current_height + height_speed_per_fixed_frame * time, peeking_height)
		elseif sign == -1 then
			current_height = math.max(current_height - height_speed_per_fixed_frame * time, peeking_height)
		else
			current_height = peeking_height
		end
	else
		current_height = peeking_height
	end

	return current_height
end

PlayerUnitFirstPersonExtension.fixed_update = function (self, unit, dt, t, frame)
	self:_update_first_person_forced_rotation(dt, t)

	local fp_component = self._first_person_component
	local height = _calculate_base_player_height(fp_component, t)
	local locomotion_component = self._locomotion_component
	local inair_state_component = self._inair_state_component
	local locomotion_position = locomotion_component.position
	local position = locomotion_position + Vector3(0, 0, height)
	local input_ext = self._input_extension
	local yaw, pitch, roll = input_ext:get_orientation()
	local recoil_template = self._weapon_extension:recoil_template()
	local pitch_offset, yaw_offset = Recoil.first_person_offset(recoil_template, self._recoil_component, self._movement_state_component, locomotion_component, inair_state_component)
	local look_rotation = Quaternion.from_yaw_pitch_roll(yaw + yaw_offset, pitch + pitch_offset, roll)
	local unmodified_look_rotation = Quaternion.from_yaw_pitch_roll(yaw, pitch, roll)
	local base_position_offset

	if inair_state_component.on_ground then
		base_position_offset = Vector3.up() * 0.2
	else
		base_position_offset = -Vector3.up() * 0.2
	end

	local ledge_finder_extension = self._ledge_finder_extension

	if ledge_finder_extension then
		ledge_finder_extension:calculate_ledges(frame, locomotion_position, base_position_offset, position, unmodified_look_rotation)
	end

	local peeking_component = self._peeking_component

	if peeking_component.is_peeking then
		local heights = self._heights

		height = _peeking_player_height(unmodified_look_rotation, peeking_component, heights.crouch, heights.default, fp_component, self._last_fixed_t, t, self._fixed_time_step)
		position = locomotion_position + Vector3(0, 0, height)
	end

	fp_component.position = position
	fp_component.height = height
	fp_component.previous_rotation = fp_component.rotation
	fp_component.rotation = look_rotation

	if self._is_server then
		GameSession.set_game_object_field(self._game_session, self._game_object_id, "character_height", fp_component.height)
	end

	self._last_fixed_t = t
end

PlayerUnitFirstPersonExtension.server_correction_occurred = function (self, unit, from_frame)
	self._last_fixed_t = from_frame * self._fixed_time_step
end

PlayerUnitFirstPersonExtension.update = function (self, unit, dt, t)
	self._show_1p_equipment, self._wants_1p_camera = self:_update_first_person_mode(t)

	local is_in_first_person_mode = self:is_in_first_person_mode()

	if is_in_first_person_mode then
		self._run_animation_speed_control:update(dt, t)
		self._look_delta_animation_control:update(dt, t)
		PlayerUnitPeeking.update_first_person_animations(self._first_person_unit, self._1p_peeking_animation_data, dt, t)
	end

	PlayerUnitPeeking.update_third_person_animations(unit, self._3p_peeking_animation_data, dt)
	self:_update_rotation(unit, dt, t)

	if not self._unit_data_extension.is_resimulating then
		local previous_frame_character_state_name = self._previous_frame_character_state_name
		local footstep_context = self._footstep_context

		self._footstep_time, self._right_foot_next = MaterialFx.update_1p_footsteps(t, self._footstep_time, self._right_foot_next, previous_frame_character_state_name, is_in_first_person_mode, footstep_context, FOOTSTEP_SOUND_ALIAS, UPPER_BODY_FOLEY, WEAPON_FOLEY, EXTRA_FOLEY)

		MaterialFx.update_3p_footsteps(previous_frame_character_state_name, is_in_first_person_mode, footstep_context, FOOTSTEP_SOUND_ALIAS, UPPER_BODY_FOLEY, WEAPON_FOLEY, EXTRA_FOLEY)
	end

	self._previous_frame_character_state_name = self._character_state_component.state_name
end

PlayerUnitFirstPersonExtension._update_rotation = function (self, unit, dt, t)
	local first_person_unit = self._first_person_unit
	local fp_component = self._first_person_component

	if self._is_local_unit then
		local orientation = self._player:get_orientation()
		local recoil_template = self._weapon_extension:recoil_template()
		local pitch_offset, yaw_offset = Recoil.first_person_offset(recoil_template, self._recoil_component, self._movement_state_component, self._locomotion_component, self._inair_state_component)
		local yaw = orientation.yaw + yaw_offset
		local pitch = orientation.pitch + pitch_offset
		local roll = orientation.roll
		local rot = Quaternion.from_yaw_pitch_roll(yaw, pitch, roll)

		Unit.set_local_rotation(first_person_unit, 1, rot)
	elseif self._is_first_person_spectated then
		Unit.set_local_rotation(first_person_unit, 1, fp_component.rotation)
	else
		Unit.set_local_rotation(first_person_unit, 1, fp_component.rotation)
	end
end

PlayerUnitFirstPersonExtension.update_unit_position = function (self, unit, dt, t)
	local first_person_unit = self._first_person_unit
	local position_root = Unit.local_position(unit, 1)
	local fp_component = self._first_person_component
	local unit_data_extension = self._unit_data_extension
	local state_machine_lerp_values = self._state_machine_lerp_values
	local player = self._player
	local peeking_component = self._peeking_component

	if self._is_local_unit and player:is_human_controlled() then
		local height

		if peeking_component.is_peeking then
			local orientation = self._player:get_orientation()
			local yaw = orientation.yaw
			local pitch = orientation.pitch
			local roll = orientation.roll
			local rot = Quaternion.from_yaw_pitch_roll(yaw, pitch, roll)
			local heights = self._heights

			height = _peeking_player_height(rot, peeking_component, heights.crouch, heights.default, fp_component, self._last_fixed_t, t, self._fixed_time_step)
		else
			height = _calculate_base_player_height(fp_component, t)
		end

		local position = position_root + Vector3(0, 0, height)

		self._extrapolated_character_height = height

		Unit.set_local_position(first_person_unit, 1, position)
		FirstPersonAnimationVariables.update(dt, t, first_person_unit, unit_data_extension, self._weapon_extension, state_machine_lerp_values)
	elseif self._is_first_person_spectated then
		local height = _calculate_base_player_height(fp_component, t)
		local offset_height = Vector3(0, 0, height)

		self._extrapolated_character_height = height

		local position = position_root + offset_height

		Unit.set_local_position(first_person_unit, 1, position)
		FirstPersonAnimationVariables.update(dt, t, first_person_unit, unit_data_extension, self._weapon_extension, state_machine_lerp_values)
	else
		Unit.set_local_position(first_person_unit, 1, fp_component.position)

		self._extrapolated_character_height = fp_component.height
	end

	World.update_unit_and_children(self._world, first_person_unit)
end

PlayerUnitFirstPersonExtension._update_first_person_mode = function (self, t)
	if self._force_third_person_mode then
		return false, false
	end

	local is_first_person_spectated = self._is_first_person_spectated
	local wants_1p_camera = self._first_person_mode_component.wants_1p_camera
	local player = self._player
	local is_human_controlled = player:is_human_controlled()

	if not is_human_controlled then
		return self:_server_evaluate_other_players_first_person_mode(is_first_person_spectated, wants_1p_camera)
	end

	if not self._is_local_unit then
		return self:_server_evaluate_other_players_first_person_mode(is_first_person_spectated, wants_1p_camera)
	end

	local show_1p_equipment = wants_1p_camera and t >= self._first_person_mode_component.show_1p_equipment_at_t

	return show_1p_equipment, wants_1p_camera
end

PlayerUnitFirstPersonExtension._server_evaluate_other_players_first_person_mode = function (self, is_first_person_spectated, wants_1p_camera)
	local is_in_first_person_mode = is_first_person_spectated and wants_1p_camera

	return is_in_first_person_mode, wants_1p_camera
end

PlayerUnitFirstPersonExtension._update_first_person_forced_rotation = function (self, dt, t)
	local force_look = self._force_look_rotation_component

	if force_look.use_force_look_rotation and t > force_look.end_time then
		ForceLookRotation.stop(force_look)
	end
end

local DEFAULT_VERTICAL_FOV = DefaultGameParameters.vertical_fov
local BASE_VERTICAL_FOV = DEFAULT_VERTICAL_FOV * math.pi / 180
local BASE_HORIZONTAL_FOV = BASE_VERTICAL_FOV * 1.7777777777777777

PlayerUnitFirstPersonExtension.is_within_default_view = function (self, position)
	local first_person = self._first_person_component
	local pos = first_person.position
	local rot = first_person.rotation
	local player_forward = Quaternion.forward(rot)
	local to_pos_dir = Vector3.normalize(position - pos)
	local dot = Vector3.dot(to_pos_dir, player_forward)
	local is_infront = dot > 0

	if is_infront then
		local player_right = Quaternion.right(rot)
		local player_up = Quaternion.up(rot)
		local c_x = Vector3.dot(to_pos_dir, player_right)
		local c_y = dot
		local c_z = Vector3.dot(to_pos_dir, player_up)
		local dot_xy = c_y
		local c_to_pos_dir_length_xy = math.sqrt(c_x * c_x + c_y * c_y)

		if c_to_pos_dir_length_xy == 0 then
			return false
		end

		local cos_xy = math.clamp(dot_xy / c_to_pos_dir_length_xy, -1, 1)
		local yaw = math.acos(cos_xy)

		if yaw <= BASE_HORIZONTAL_FOV * 0.5 then
			local dot_uz = c_to_pos_dir_length_xy
			local to_pos_dir_length_uz = math.sqrt(c_to_pos_dir_length_xy * c_to_pos_dir_length_xy + c_z * c_z)
			local cos_uz = math.clamp(dot_uz / to_pos_dir_length_uz, -1, 1)
			local pitch = math.acos(cos_uz)

			if pitch <= BASE_VERTICAL_FOV * 0.5 then
				return true
			end

			return false
		end
	end

	return false
end

PlayerUnitFirstPersonExtension.is_in_first_person_mode = function (self)
	return self._show_1p_equipment
end

PlayerUnitFirstPersonExtension.wants_first_person_camera = function (self)
	return self._wants_1p_camera
end

PlayerUnitFirstPersonExtension.set_camera_follow_target = function (self, is_followed, first_person_spectating)
	self._is_camera_follow_target = is_followed

	local is_local_human = self._is_local_unit and self._player:is_human_controlled()

	self._is_first_person_spectated = not is_local_human and is_followed and first_person_spectating
end

PlayerUnitFirstPersonExtension.is_camera_follow_target = function (self)
	return self._is_camera_follow_target
end

PlayerUnitFirstPersonExtension.first_person_unit = function (self)
	return self._first_person_unit
end

PlayerUnitFirstPersonExtension.extrapolated_character_height = function (self)
	return self._extrapolated_character_height
end

PlayerUnitFirstPersonExtension.extrapolated_rotation = function (self)
	return Unit.local_rotation(self._first_person_unit, 1)
end

local player_height_movement_speed = 3

PlayerUnitFirstPersonExtension.set_wanted_player_height = function (self, state, time_to_change, height_change_function)
	local player_height_wanted = self:_player_height_from_name(state)
	local fp_component = self._first_person_component

	fp_component.wanted_height = player_height_wanted

	self:reset_height_change(time_to_change, height_change_function)
end

PlayerUnitFirstPersonExtension.reset_height_change = function (self, time_to_change, height_change_function)
	local fp_component = self._first_person_component

	fp_component.old_height = fp_component.height

	if time_to_change == nil then
		time_to_change = math.abs(fp_component.wanted_height - fp_component.old_height) / player_height_movement_speed
	end

	if height_change_function == nil then
		height_change_function = "ease_out_quad"
	end

	fp_component.height_change_duration = Network.pack_unpack(NetworkConstants.short_time_index, time_to_change)
	fp_component.height_change_start_time = self._last_fixed_t
	fp_component.height_change_function = height_change_function
end

PlayerUnitFirstPersonExtension._player_height_from_name = function (self, name)
	return self._heights[name]
end

return PlayerUnitFirstPersonExtension
