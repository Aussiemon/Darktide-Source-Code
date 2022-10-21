local Attack = require("scripts/utilities/attack/attack")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local MoverController = require("scripts/extension_systems/locomotion/utilities/mover_controller")
local LOCOMOTION_GRAVITY = 20
local MinionLocomotionExtension = class("MinionLocomotionExtension")

MinionLocomotionExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	self._unit = unit
	local breed = extension_init_data.breed
	local game_object_type = breed.game_object_type
	local sync_full_rotation = Network.object_has_field(game_object_type, "rotation")
	self._engine_extension_id = MinionLocomotion.register_extension(unit, LOCOMOTION_GRAVITY, sync_full_rotation)
	local mover_state = MoverController.create_mover_state()

	MoverController.set_active_mover(unit, mover_state, "mover")

	self._mover_state = mover_state
	self.movement_type = "snap_to_navmesh"

	self:set_mover_disable_reason("not_constrained_by_mover", true)
end

MinionLocomotionExtension.game_object_initialized = function (self, game_session, game_object_id)
	MinionLocomotion.game_object_initialized(self._engine_extension_id, game_object_id)

	self._game_object_id = game_object_id
end

MinionLocomotionExtension.destroy = function (self)
	MinionLocomotion.destroy_extension(self._engine_extension_id)
end

MinionLocomotionExtension.set_mover_displacement = function (self, displacement, duration)
	MinionLocomotion.set_mover_displacement(self._engine_extension_id, displacement, duration)
end

MinionLocomotionExtension.teleport_to = function (self, position, rotation)
	MinionLocomotion.teleport_to(self._engine_extension_id, position, rotation)
end

MinionLocomotionExtension.set_anim_driven = function (self, animation_driven, optional_affected_by_gravity, optional_script_driven_rotation, optional_override_velocity_z)
	MinionLocomotion.set_animation_driven(self._engine_extension_id, animation_driven, optional_affected_by_gravity, optional_script_driven_rotation, optional_override_velocity_z)
end

MinionLocomotionExtension.set_anim_translation_scale = function (self, scale)
	MinionLocomotion.set_animation_translation_scale(self._engine_extension_id, scale)
end

MinionLocomotionExtension.set_anim_rotation_scale = function (self, scale)
	MinionLocomotion.set_animation_rotation_scale(self._engine_extension_id, scale)
end

MinionLocomotionExtension.set_wanted_velocity_flat = function (self, velocity)
	MinionLocomotion.set_wanted_velocity_flat(self._engine_extension_id, velocity)
end

MinionLocomotionExtension.set_wanted_velocity = function (self, velocity)
	MinionLocomotion.set_wanted_velocity(self._engine_extension_id, velocity)
end

MinionLocomotionExtension.set_external_velocity = function (self, velocity)
	MinionLocomotion.set_external_velocity(self._engine_extension_id, velocity)
end

MinionLocomotionExtension.set_wanted_rotation = function (self, rotation)
	MinionLocomotion.set_wanted_rotation(self._engine_extension_id, rotation)
end

MinionLocomotionExtension.use_lerp_rotation = function (self, active)
	MinionLocomotion.use_lerp_rotation(self._engine_extension_id, active)
end

MinionLocomotionExtension.set_rotation_speed = function (self, rotation_speed)
	MinionLocomotion.set_rotation_speed(self._engine_extension_id, rotation_speed)
end

MinionLocomotionExtension.set_rotation_speed_modifier = function (self, rotation_speed_modifier, rotation_speed_modifier_lerp_time, start_time)
	MinionLocomotion.set_rotation_speed_modifier(self._engine_extension_id, rotation_speed_modifier, rotation_speed_modifier_lerp_time, start_time)
end

MinionLocomotionExtension.set_affected_by_gravity = function (self, affected_by_gravity, optional_override_velocity_z)
	MinionLocomotion.set_affected_by_gravity(self._engine_extension_id, affected_by_gravity, optional_override_velocity_z)
end

MinionLocomotionExtension.set_gravity = function (self, gravity)
	MinionLocomotion.set_gravity(self._engine_extension_id, gravity)
end

MinionLocomotionExtension.set_check_falling = function (self, state)
	MinionLocomotion.set_check_falling(self._engine_extension_id, state)
end

local movement_types = {
	script_driven = 0,
	snap_to_navmesh = 1,
	constrained_by_mover = 2
}

MinionLocomotionExtension.set_movement_type = function (self, movement_type, override_mover_separate_distance, ignore_forced_mover_kill)
	if movement_type == self.movement_type then
		return true
	end

	self.movement_type = movement_type

	if movement_type == "script_driven" then
		MoverController.set_disable_reason(self._unit, self._mover_state, "not_constrained_by_mover", true)
	elseif movement_type == "snap_to_navmesh" then
		MoverController.set_disable_reason(self._unit, self._mover_state, "not_constrained_by_mover", true)
	elseif movement_type == "constrained_by_mover" then
		MoverController.set_disable_reason(self._unit, self._mover_state, "not_constrained_by_mover", false)
	end

	local kill = MinionLocomotion.set_movement_type(self._engine_extension_id, movement_types[movement_type], override_mover_separate_distance)

	if kill and not ignore_forced_mover_kill then
		local damage_profile = DamageProfileTemplates.default

		Attack.execute(self._unit, damage_profile, "instakill", true)
	end

	return not kill
end

MinionLocomotionExtension.current_velocity = function (self)
	return MinionLocomotion.velocity(self._engine_extension_id)
end

MinionLocomotionExtension.is_falling = function (self)
	return MinionLocomotion.is_falling(self._engine_extension_id)
end

MinionLocomotionExtension.rotation_speed = function (self)
	return MinionLocomotion.rotation_speed(self._engine_extension_id)
end

MinionLocomotionExtension.rotation_speed_modifier = function (self)
	return MinionLocomotion.rotation_speed_modifier(self._engine_extension_id)
end

MinionLocomotionExtension.anim_rotation_scale = function (self)
	return MinionLocomotion.animation_rotation_scale(self._engine_extension_id)
end

MinionLocomotionExtension.anim_translation_scale = function (self)
	return MinionLocomotion.animation_translation_scale(self._engine_extension_id)
end

MinionLocomotionExtension.set_mover_disable_reason = function (self, reason, state)
	MoverController.set_disable_reason(self._unit, self._mover_state, reason, state)
end

MinionLocomotionExtension.set_traverse_logic = function (self, traverse_logic)
	MinionLocomotion.set_traverse_logic(self._engine_extension_id, traverse_logic)
end

MinionLocomotionExtension.engine_debug_info = function (self)
	return MinionLocomotion.extension_debug_info(self._engine_extension_id)
end

return MinionLocomotionExtension
