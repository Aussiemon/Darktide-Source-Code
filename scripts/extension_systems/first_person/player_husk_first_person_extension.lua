local FirstPersonLookDeltaAnimationControl = require("scripts/extension_systems/first_person/first_person_look_delta_animation_control")
local FirstPersonRunSpeedAnimationControl = require("scripts/extension_systems/first_person/first_person_run_speed_animation_control")
local Footstep = require("scripts/utilities/footstep")
local PlayerHuskFirstPersonExtension = class("PlayerHuskFirstPersonExtension")
local FOOTSTEP_SOUND_ALIAS = "footstep"
local UPPER_BODY_FOLEY = "sfx_foley_upper_body"
local WEAPON_FOLEY = "sfx_weapon_locomotion"
local EXTRA_FOLEY = "sfx_player_extra_slot"

PlayerHuskFirstPersonExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	local wwise_world = extension_init_context.wwise_world
	local physics_world = extension_init_context.physics_world
	local breed = extension_init_data.breed
	self._wwise_world = wwise_world
	self._world = extension_init_context.world
	local heights = extension_init_data.heights
	self._heights = heights
	self._extrapolated_character_height = heights.default
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local first_person_component = unit_data_extension:read_component("first_person")
	local character_state_component = unit_data_extension:read_component("character_state")
	local sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
	local movement_state_component = unit_data_extension:read_component("movement_state")
	local weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._first_person_mode_component = unit_data_extension:read_component("first_person_mode")
	self._unit_data_extension = unit_data_extension
	self._first_person_component = first_person_component
	self._character_state_component = character_state_component
	local pose_scale = breed.first_person_pose_scale or 1
	local character_height = heights.default
	local position_root = Unit.local_position(unit, 1)
	local rotation_root = Unit.local_rotation(unit, 1)
	local offset_height = Vector3(0, 0, character_height)
	local position = position_root + offset_height
	local unit_name = extension_init_data.unit_name
	local unit_spawner_manager = Managers.state.unit_spawner
	local pose = Matrix4x4.from_quaternion_position(rotation_root, position)

	Matrix4x4.set_scale(pose, Vector3(pose_scale, pose_scale, pose_scale))

	local first_person_unit = unit_spawner_manager:spawn_unit(unit_name, pose)
	self._first_person_unit = first_person_unit
	self._unit = unit

	Unit.set_data(first_person_unit, "owner_unit", unit)

	self._is_camera_follow_target = false
	self._is_first_person_spectated = false
	self._footstep_time = 0
	local feet_source_id = WwiseWorld.make_manual_source(wwise_world, unit, 1)
	self._footstep_context = {
		character_state_component = character_state_component,
		sprint_character_state_component = sprint_character_state_component,
		weapon_action_component = weapon_action_component,
		breed = breed,
		movement_state_component = movement_state_component,
		wwise_world = wwise_world,
		unit = unit,
		physics_world = physics_world,
		feet_source_id = feet_source_id
	}
	self._previous_frame_character_state_name = character_state_component.state_name
end

PlayerHuskFirstPersonExtension.extensions_ready = function (self, world, unit)
	local first_person_unit = self._first_person_unit
	local is_husk = true
	self._run_animation_speed_control = FirstPersonRunSpeedAnimationControl:new(first_person_unit, unit)
	self._look_delta_animation_control = FirstPersonLookDeltaAnimationControl:new(first_person_unit, unit, is_husk)
	self._footstep_context.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	self._footstep_context.fx_extension = ScriptUnit.extension(unit, "fx_system")
	self._footstep_context.foley_source_id = WwiseWorld.make_manual_source(self._wwise_world, first_person_unit, 1)
end

PlayerHuskFirstPersonExtension.destroy = function (self)
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

PlayerHuskFirstPersonExtension.update = function (self, unit, dt, t)
	self._show_1p_equipment, self._wants_1p_camera = self:_update_first_person_mode(t)

	if self:is_in_first_person_mode() then
		self._run_animation_speed_control:update(dt, t)
		self._look_delta_animation_control:update(dt, t)
	else
		local position_root = Unit.local_position(unit, 1)

		self:update_unit_position_and_rotation(position_root, false)
	end

	if not self._unit_data_extension.is_resimulating then
		self._footstep_time = Footstep.update_1p_footsteps(t, self._footstep_time, self._previous_frame_character_state_name, self._is_camera_follow_target, self._footstep_context, FOOTSTEP_SOUND_ALIAS, UPPER_BODY_FOLEY, WEAPON_FOLEY, EXTRA_FOLEY)
	end

	self._previous_frame_character_state_name = self._character_state_component.state_name
	self._extrapolated_character_height = self._first_person_component.height
end

PlayerHuskFirstPersonExtension.update_unit_position_and_rotation = function (self, position_3p_unit, force_update_unit_and_children)
	local first_person_unit = self._first_person_unit
	local fp_component = self._first_person_component
	local height = fp_component.height
	local position = position_3p_unit + Vector3(0, 0, height)

	Unit.set_local_rotation(first_person_unit, 1, fp_component.rotation)
	Unit.set_local_position(first_person_unit, 1, position)

	if force_update_unit_and_children then
		World.update_unit_and_children(self._world, first_person_unit)
	end
end

PlayerHuskFirstPersonExtension._update_first_person_mode = function (self, t)
	local wants_1p_camera = self._first_person_mode_component.wants_1p_camera
	local show_1p_equipment = wants_1p_camera and self._first_person_mode_component.show_1p_equipment_at_t < t

	return show_1p_equipment, wants_1p_camera
end

PlayerHuskFirstPersonExtension.is_in_first_person_mode = function (self)
	return self._is_first_person_spectated and self._show_1p_equipment
end

PlayerHuskFirstPersonExtension.set_camera_follow_target = function (self, is_followed, first_person_spectating)
	self._is_camera_follow_target = is_followed
	self._is_first_person_spectated = is_followed and first_person_spectating
end

PlayerHuskFirstPersonExtension.is_camera_follow_target = function (self)
	return self._is_camera_follow_target
end

PlayerHuskFirstPersonExtension.first_person_unit = function (self)
	return self._first_person_unit
end

PlayerHuskFirstPersonExtension.extrapolated_character_height = function (self)
	return self._extrapolated_character_height
end

return PlayerHuskFirstPersonExtension
