local FirstPersonLookDeltaAnimationControl = require("scripts/extension_systems/first_person/first_person_look_delta_animation_control")
local FirstPersonRunSpeedAnimationControl = require("scripts/extension_systems/first_person/first_person_run_speed_animation_control")
local PlayerHuskFirstPersonExtension = class("PlayerHuskFirstPersonExtension")

PlayerHuskFirstPersonExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._world = extension_init_context.world
	local heights = extension_init_data.heights
	self._heights = heights
	self._extrapolated_character_height = heights.default
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local first_person_component = unit_data_extension:read_component("first_person")
	self._first_person_component = first_person_component
	self._first_person_mode_component = unit_data_extension:read_component("first_person_mode")
	local character_height = heights.default
	local position_root = Unit.local_position(unit, 1)
	local offset_height = Vector3(0, 0, character_height)
	local position = position_root + offset_height
	local unit_name = extension_init_data.unit_name
	local unit_spawner_manager = Managers.state.unit_spawner
	local first_person_unit = unit_spawner_manager:spawn_unit(unit_name, position)
	self._first_person_unit = first_person_unit

	Unit.set_data(first_person_unit, "owner_unit", unit)

	self._is_camera_follow_target = false
	self._is_first_person_spectated = false
end

PlayerHuskFirstPersonExtension.extensions_ready = function (self, world, unit)
	self._run_animation_speed_control = FirstPersonRunSpeedAnimationControl:new(self._first_person_unit, unit)
	local is_husk = true
	self._look_delta_animation_control = FirstPersonLookDeltaAnimationControl:new(self._first_person_unit, unit, is_husk)
end

PlayerHuskFirstPersonExtension.destroy = function (self)
	local unit_spawner_manager = Managers.state.unit_spawner

	unit_spawner_manager:mark_for_deletion(self._first_person_unit)
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
