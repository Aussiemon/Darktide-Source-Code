-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/aim_projectile_ads_effects.lua

require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/aim_projectile_effects")

local Action = require("scripts/utilities/weapon/action")
local ProjectileIntegrationData = require("scripts/extension_systems/locomotion/utilities/projectile_integration_data")
local AimProjectileAdsEffects = class("AimProjectileAdsEffects", "AimProjectileEffects")

AimProjectileAdsEffects.init = function (self, context, slot, weapon_template, fx_sources)
	AimProjectileAdsEffects.super.init(self, context, slot, weapon_template, fx_sources)

	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._alternate_fire_component = unit_data_extension:read_component("alternate_fire")
	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
end

local _trajectory_settings = {}

AimProjectileAdsEffects._trajectory_settings = function (self, t)
	table.clear(_trajectory_settings)

	local weapon_template = self._weapon_template
	local alternate_fire_settings = weapon_template.alternate_fire_settings
	local projectile_aim_effect_settings = alternate_fire_settings.projectile_aim_effect_settings
	local alternate_fire_component = self._alternate_fire_component
	local is_aiming_down_sights = alternate_fire_component and alternate_fire_component.is_active
	local aiming_down_sights_start_time = alternate_fire_component and alternate_fire_component.start_t
	local aiming_down_sights_time = t - aiming_down_sights_start_time
	local delay = projectile_aim_effect_settings and projectile_aim_effect_settings.arc_show_delay or 0
	local is_timing_right = delay < aiming_down_sights_time

	if not is_aiming_down_sights or not is_timing_right then
		return false, nil
	end

	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local hide_arc = action_settings and action_settings.hide_arc

	if hide_arc then
		return false, nil
	end

	local inventory_slot_component = self._inventory_slot_component
	local no_ammo_in_clip = inventory_slot_component.current_ammunition_clip == 0
	local no_ammo_in_reserve = inventory_slot_component.current_ammunition_reserve == 0

	if no_ammo_in_clip and no_ammo_in_reserve then
		return false, nil
	end

	local throw_type = projectile_aim_effect_settings.throw_type
	local stop_on_impact = projectile_aim_effect_settings.stop_on_impact
	local projectile_locomotion_template = projectile_aim_effect_settings.projectile_template.locomotion_template
	local trajectory_parameters = projectile_locomotion_template.trajectory_parameters[throw_type]

	_trajectory_settings.projectile_locomotion_template = projectile_locomotion_template
	_trajectory_settings.rotation = Quaternion.identity()
	_trajectory_settings.speed = trajectory_parameters.speed_initial
	_trajectory_settings.momentum = Vector3.zero()
	_trajectory_settings.throw_type = throw_type
	_trajectory_settings.stop_on_impact = stop_on_impact
	_trajectory_settings.time_in_action = 0

	local mass, radius = ProjectileIntegrationData.mass_radius(projectile_locomotion_template, nil)

	_trajectory_settings.mass = mass
	_trajectory_settings.radius = radius
	_trajectory_settings.use_sway_and_recoil = projectile_aim_effect_settings.use_sway_and_recoil
	_trajectory_settings.arc_vfx_spawner_name = projectile_aim_effect_settings.arc_vfx_spawner_name

	if projectile_aim_effect_settings.arc_start_offset then
		_trajectory_settings.start_offset = projectile_aim_effect_settings.arc_start_offset:unbox()
	end

	return true, _trajectory_settings
end

return AimProjectileAdsEffects
