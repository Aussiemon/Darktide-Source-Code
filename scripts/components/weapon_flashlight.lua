local WeaponFlashlight = component("WeaponFlashlight")

WeaponFlashlight.init = function (self, unit)
	if Unit.get_data(unit, "flashlight_enabled") then
		self:enable(unit)
	else
		self:disable(unit)
	end
end

WeaponFlashlight.enable = function (self, unit)
	if Unit.num_lights(unit) >= 1 then
		local light = Unit.light(unit, 1)
		local color = Light.color_with_intensity(light)

		Light.set_enabled(light, true)
		Unit.set_vector3_for_materials(unit, "light_color", color)
	end
end

WeaponFlashlight.disable = function (self, unit)
	if Unit.num_lights(unit) >= 1 then
		local light = Unit.light(unit, 1)

		Light.set_enabled(light, false)
		Unit.set_vector3_for_materials(unit, "light_color", Vector3(0, 0, 0))
	end
end

WeaponFlashlight.toggle = function (self, unit, was_enabled)
	if was_enabled then
		self:disable(unit)
	else
		self:enable(unit)
	end
end

WeaponFlashlight.set_intensity = function (self, unit, template, scale)
	local light = Unit.light(unit, 1)
	local base_intensity = template.intensity
	local scaled_intensity = base_intensity * scale

	Light.set_intensity(light, scaled_intensity)

	local color = Light.color_with_intensity(light)

	Unit.set_vector3_for_materials(unit, "light_color", color * scale * scale * scale)
end

WeaponFlashlight.set_template = function (self, unit, template)
	local light = Unit.light(unit, 1)

	Light.set_intensity(light, template.intensity)
	Light.set_volumetric_intensity(light, template.volumetric_intensity)
	Light.set_casts_shadows(light, template.cast_shadows)
	Light.set_spot_angle_start(light, math.degrees_to_radians(template.spot_angle.min))
	Light.set_spot_angle_end(light, math.degrees_to_radians(template.spot_angle.max))
	Light.set_spot_reflector(light, template.spot_reflector)
	Light.set_falloff_start(light, template.falloff.near)
	Light.set_falloff_end(light, template.falloff.far)
end

WeaponFlashlight.destroy = function (self, unit)
	return
end

WeaponFlashlight.component_data = {}

return WeaponFlashlight
