-- chunkname: @scripts/extension_systems/weapon/projectile_unit_weapon_extension.lua

local ProjectileUnitWeaponExtension = class("ProjectileUnitWeaponExtension")

ProjectileUnitWeaponExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._damage_profile_lerp_values = extension_init_data.damage_profile_lerp_values
	self._explosion_template_lerp_values = extension_init_data.explosion_template_lerp_values
end

local NO_LERP_VALUES = {}

ProjectileUnitWeaponExtension.damage_profile_lerp_values = function (self, damage_profile_name_or_nil)
	local projectile_damage_profile_lerp_values = self._damage_profile_lerp_values
	local damage_profile_lerp_values = damage_profile_name_or_nil and projectile_damage_profile_lerp_values and projectile_damage_profile_lerp_values[damage_profile_name_or_nil]

	return damage_profile_lerp_values or projectile_damage_profile_lerp_values or NO_LERP_VALUES
end

ProjectileUnitWeaponExtension.explosion_template_lerp_values = function (self, explosion_template_name_or_nil)
	local projectile_explosion_template = self._explosion_template_lerp_values
	local explosion_template_lerp_values = explosion_template_name_or_nil and projectile_explosion_template and projectile_explosion_template[explosion_template_name_or_nil]

	return explosion_template_lerp_values or projectile_explosion_template or NO_LERP_VALUES
end

return ProjectileUnitWeaponExtension
