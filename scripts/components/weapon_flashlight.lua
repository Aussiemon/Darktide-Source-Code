-- chunkname: @scripts/components/weapon_flashlight.lua

local WeaponFlashlight = component("WeaponFlashlight")

WeaponFlashlight.init = function (self, unit)
	local start_enabled = self:get_data(unit, "start_enabled")

	if Unit.num_lights(unit) > 0 then
		self._light = Unit.light(unit, 1)
	end

	if start_enabled then
		self:enable(unit)
	else
		self:disable(unit)
	end
end

WeaponFlashlight.editor_validate = function (self, unit)
	return true, ""
end

WeaponFlashlight.enable = function (self, unit)
	local light = self._light

	if not light then
		return
	end

	local color = Light.color_with_intensity(light)

	Light.set_enabled(light, true)
	Unit.set_vector3_for_materials(unit, "light_color", color)
end

WeaponFlashlight.disable = function (self, unit)
	local light = self._light

	if not light then
		return
	end

	Light.set_enabled(light, false)
	Unit.set_vector3_for_materials(unit, "light_color", Vector3(0, 0, 0))
end

WeaponFlashlight.set_intensity = function (self, unit, settings, scale)
	local light = self._light

	if not light then
		return
	end

	local intensity = settings.intensity * scale

	Light.set_intensity(light, intensity)

	local color = Light.color_with_intensity(light)

	Unit.set_vector3_for_materials(unit, "light_color", color * (scale * scale * scale))
end

WeaponFlashlight.set_template = function (self, unit, settings)
	local light = self._light

	if not light then
		return
	end

	Light.set_ies_profile(light, settings.ies_profile)
	Light.set_correlated_color_temperature(light, settings.color_temperature)
	Light.set_intensity(light, settings.intensity)
	Light.set_volumetric_intensity(light, settings.volumetric_intensity)
	Light.set_casts_shadows(light, settings.cast_shadows)
	Light.set_spot_angle_start(light, settings.spot_angle.min)
	Light.set_spot_angle_end(light, settings.spot_angle.max)
	Light.set_spot_reflector(light, settings.spot_reflector)
	Light.set_falloff_start(light, settings.falloff.near)
	Light.set_falloff_end(light, settings.falloff.far)
end

WeaponFlashlight.destroy = function (self, unit)
	return
end

WeaponFlashlight.component_data = {
	start_enabled = {
		ui_name = "Start Enabled",
		ui_type = "check_box",
		value = false,
	},
}

return WeaponFlashlight
