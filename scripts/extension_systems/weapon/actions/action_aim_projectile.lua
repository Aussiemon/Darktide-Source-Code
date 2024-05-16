-- chunkname: @scripts/extension_systems/weapon/actions/action_aim_projectile.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local AimProjectile = require("scripts/utilities/aim_projectile")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local ProjectileLocomotionTemplates = require("scripts/settings/projectile_locomotion/projectile_locomotion_templates")
local ProjectileIntegrationData = require("scripts/extension_systems/locomotion/utilities/projectile_integration_data")
local ActionAimProjectile = class("ActionAimProjectile", "ActionWeaponBase")

ActionAimProjectile.init = function (self, action_context, ...)
	ActionAimProjectile.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension

	self._action_aim_projectile_component = unit_data_extension:write_component("action_aim_projectile")
	self._locomotion_component = unit_data_extension:read_component("locomotion")
end

ActionAimProjectile.start = function (self, action_settings, t, time_scale, action_start_params)
	local locomotion_template = self:_locomotion_template()
	local throw_type = action_settings.throw_type or "throw"
	local throw_config = locomotion_template.trajectory_parameters[throw_type]
	local momentum

	if throw_config.randomized_angular_velocity then
		local max = throw_config.randomized_angular_velocity

		momentum = Vector3(math.random() * max.x, math.random() * max.y, math.random() * max.z)
	elseif throw_config.momentum then
		momentum = throw_config.momentum:unbox()
	else
		momentum = Vector3.zero()
	end

	self._action_aim_projectile_component.momentum = momentum
end

ActionAimProjectile.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings
	local projectile_locomotion_template = self:_locomotion_template()
	local first_person_component = self._first_person_component
	local look_rotation = first_person_component.rotation
	local look_position = first_person_component.position
	local initial_position = look_position
	local initial_rotation = look_rotation
	local throw_type = action_settings.throw_type
	local aim_parameters = AimProjectile.aim_parameters(initial_position, initial_rotation, look_rotation, projectile_locomotion_template, throw_type, time_in_action)
	local _, locomotion_extension = self:_existing_unit()
	local _, radius = ProjectileIntegrationData.mass_radius(projectile_locomotion_template, locomotion_extension)
	local throw_position = AimProjectile.check_throw_position(aim_parameters.position, look_position, projectile_locomotion_template, radius, self._physics_world)
	local action_aim_projectile_component = self._action_aim_projectile_component

	action_aim_projectile_component.position = throw_position
	action_aim_projectile_component.rotation = aim_parameters.rotation
	action_aim_projectile_component.direction = aim_parameters.direction
	action_aim_projectile_component.speed = aim_parameters.speed
end

ActionAimProjectile._existing_unit = function (self)
	local wielded_slot_name = self._inventory_component.wielded_slot
	local slot_config_or_nil = PlayerUnitVisualLoadout.slot_config_from_slot_name(wielded_slot_name)
	local existing_unit = slot_config_or_nil and slot_config_or_nil.use_existing_unit_3p and self._inventory_slot_component.existing_unit_3p
	local locomotion_extension = existing_unit and ScriptUnit.extension(existing_unit, "locomotion_system")

	return existing_unit, locomotion_extension
end

ActionAimProjectile._locomotion_template = function (self)
	local existing_unit, locomotion_extension = self:_existing_unit()
	local action_settings = self._action_settings
	local weapon_template = self._weapon_template
	local locomotion_template

	if locomotion_extension then
		locomotion_template = locomotion_extension:locomotion_template()
	elseif action_settings.projectile_locomotion_template then
		local template_name_from_action = action_settings.projectile_locomotion_template

		locomotion_template = ProjectileLocomotionTemplates[template_name_from_action]
	elseif weapon_template.projectile_template then
		local projectile_templates = weapon_template.projectile_template

		locomotion_template = projectile_templates.locomotion_template
	end

	return locomotion_template
end

ActionAimProjectile.finish = function (self, reason, data, t, time_in_action)
	return
end

return ActionAimProjectile
