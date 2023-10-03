require("scripts/extension_systems/weapon/actions/action_weapon_base")

local BallisticRaycast = require("scripts/extension_systems/weapon/actions/utilities/ballistic_raycast")
local ActionAimForceField = class("ActionAimForceField", "ActionWeaponBase")

ActionAimForceField.init = function (self, action_context, ...)
	ActionAimForceField.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension
	self._action_component = unit_data_extension:write_component("action_place")
end

ActionAimForceField.start = function (self, dt, t)
	self._action_component.rotation_step = 0
end

ActionAimForceField.fixed_update = function (self, dt, t)
	local first_person_component = self._first_person_component
	local action_component = self._action_component
	local action_settings = self._action_settings
	local place_configuration = action_settings.place_configuration
	local physics_world = self._physics_world
	local look_rotation = first_person_component.rotation
	local look_direction = Quaternion.forward(look_rotation)
	local look_direction_flat = Vector3.flat(look_direction)
	local rotation = Quaternion.look(look_direction_flat)
	local collision_filter = "filter_player_character_ballistic_raycast"
	local max_steps = 10
	local max_time = 2
	local speed = 12.5
	local angle = math.pi / 16
	local gravity = -19.64
	local hit, position, _, normal, actor = BallisticRaycast.cast(physics_world, collision_filter, first_person_component, max_steps, max_time, speed, angle, gravity)

	if hit and Vector3.dot(normal, Vector3.up()) < 0.75 then
		local player_position = self._locomotion_component.position
		local half_step_back = 1 * Vector3.normalize(position - player_position)
		local step_back_position = position - half_step_back
		local _, new_position, _, _, _ = PhysicsWorld.raycast(physics_world, step_back_position, Vector3(0, 0, -1), 5, "closest", "types", "both", "collision_filter", collision_filter)

		if new_position then
			position = new_position
		else
			hit = false
			position = Vector3.zero()
			actor = nil
		end
	end

	if place_configuration.allow_rotation then
		rotation = self:_rotate(position, rotation, place_configuration)
	end

	local hit_unit = nil

	if actor then
		hit_unit = Actor.unit(actor)
	end

	if hit_unit then
		local unit_spawner_manager = Managers.state.unit_spawner
		local game_object_id = unit_spawner_manager:game_object_id(hit_unit)
		local level_index = unit_spawner_manager:level_index(hit_unit)

		if not game_object_id and not level_index then
			hit_unit = nil
		end
	end

	action_component.can_place = hit
	action_component.position = position
	action_component.rotation = rotation
	action_component.placed_on_unit = hit_unit
	action_component.aiming_place = true
end

ActionAimForceField.finish = function (self, reason, data, t, time_in_action)
	self._action_component.aiming_place = false
end

ActionAimForceField._rotate = function (self, position, rotation, place_configuration)
	local current_rotation_step = self._action_component.rotation_step
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

	local rotation_angle = math.pi * 2 / rotation_steps * current_rotation_step
	local additional_rotation = Quaternion(Vector3.up(), rotation_angle)
	local new_rotation = Quaternion.multiply(rotation, additional_rotation)

	return new_rotation
end

return ActionAimForceField
