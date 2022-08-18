local ProjectileUnitWeaponExtension = class("ProjectileUnitWeaponExtension")

ProjectileUnitWeaponExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._damage_profile_lerp_values = extension_init_data.damage_profile_lerp_values
	self._explosion_template_lerp_values = extension_init_data.explosion_template_lerp_values
end

local NO_LERP_VALUES = {}

ProjectileUnitWeaponExtension.damage_profile_lerp_values = function (self, damage_profile_name_or_nil)
	return self._damage_profile_lerp_values or NO_LERP_VALUES
end

ProjectileUnitWeaponExtension.explosion_template_lerp_values = function (self)
	return self._explosion_template_lerp_values or NO_LERP_VALUES
end

return ProjectileUnitWeaponExtension
