require("scripts/extension_systems/weapon/actions/action_weapon_base")

local AimPlaceUtil = require("scripts/extension_systems/weapon/actions/utilities/aim_place_util")
local ActionAimPlace = class("ActionAimPlace", "ActionWeaponBase")

ActionAimPlace.init = function (self, action_context, ...)
	ActionAimPlace.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension
	self._action_component = unit_data_extension:write_component("action_place")
end

ActionAimPlace.start = function (self, dt, t)
	self._action_component.rotation_step = 0
end

ActionAimPlace.fixed_update = function (self, dt, t)
	local first_person_component = self._first_person_component
	local action_component = self._action_component
	local action_settings = self._action_settings
	local place_configuration = action_settings.place_configuration
	local physics_world = self._physics_world
	local can_place, position, rotation, placed_on_unit = AimPlaceUtil.aim_placement(physics_world, place_configuration, first_person_component)
	local current_rotation_step = action_component.rotation_step

	if place_configuration.allow_rotation then
		local rotate_input = place_configuration.rotation_input
		local rotation_steps = place_configuration.rotation_steps
		local has_input = self._input_extension:get(rotate_input)

		if has_input then
			current_rotation_step = (current_rotation_step + 1) % rotation_steps
			self._action_component.rotation_step = current_rotation_step
			local rotation_animation_1p = place_configuration.anim_rotate_event
			local rotation_animation_3p = place_configuration.anim_rotate_event_3p or rotation_animation_1p

			if rotation_animation_1p then
				self:trigger_anim_event(rotation_animation_1p, rotation_animation_3p)
			end

			local sound_event = place_configuration.rotate_sound_event

			if sound_event then
				local position_offset = place_configuration.sound_position_offset and place_configuration.sound_position_offset:unbox() or Vector3.zero()

				self._fx_extension:trigger_exclusive_wwise_event(sound_event, position + position_offset)
			end
		end

		local angle = math.pi * 2 / rotation_steps * current_rotation_step
		local additional_rotation = Quaternion(Vector3.up(), angle)
		rotation = Quaternion.multiply(rotation, additional_rotation)
	end

	action_component.can_place = can_place
	action_component.position = position
	action_component.rotation = rotation
	action_component.placed_on_unit = placed_on_unit
	action_component.aiming_place = true
end

ActionAimPlace.finish = function (self, reason, data, t, time_in_action)
	self._action_component.aiming_place = false
end

return ActionAimPlace
