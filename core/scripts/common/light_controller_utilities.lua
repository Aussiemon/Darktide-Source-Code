local LightControllerUtilities = {
	set_enabled = function (unit, is_enabled, fake_light)
		local num_lights = Unit.num_lights(unit)

		if num_lights >= 1 then
			local light_source_enabled = is_enabled

			if fake_light then
				light_source_enabled = false
			end

			for ii = 1, num_lights do
				local light = Unit.light(unit, ii)

				Light.set_enabled(light, light_source_enabled)
			end

			local shadow_caster_group = "shadow_caster"

			if Unit.has_visibility_group(unit, shadow_caster_group) then
				Unit.set_visibility(unit, "shadow_caster", not light_source_enabled)
			end

			if is_enabled then
				Unit.set_scalar_for_materials(unit, "emissive_multiplier", 1, true)
				Unit.flow_event(unit, "lights_enabled")
			else
				Unit.set_scalar_for_materials(unit, "emissive_multiplier", 0, true)
				Unit.flow_event(unit, "lights_disabled")
			end
		end
	end,
	set_intensity = function (unit)
		local num_lights = Unit.num_lights(unit)

		if num_lights >= 1 then
			for ii = 1, num_lights do
				local light = Unit.light(unit, ii)
				local color_intensity = Light.color_with_intensity(light)
				local color = Vector3.normalize(color_intensity)
				local intensity = Vector3.length(color_intensity)

				Unit.set_vector3_for_materials(unit, "emissive_color", color)
				Unit.set_scalar_for_materials(unit, "emissive_intensity_lumen", intensity)
			end
		end
	end,
	set_flicker = function (unit, is_enabled, flicker_name)
		for ii = 1, Unit.num_lights(unit) do
			local light = Unit.light(unit, ii)

			if is_enabled then
				Light.set_flicker_type(light, flicker_name)
			else
				Light.set_flicker_type(light, nil)
			end
		end
	end,
	register_flicker_configurations = function (configurations)
		for flicker_name, values in pairs(configurations) do
			Light.add_flicker_configuration(flicker_name, values.persistance, values.octaves, values.min_value, values.frequency_multiplier, values.translation.persistance, values.translation.octaves, values.translation.jitter_multiplier_xy, values.translation.jitter_multiplier_z, values.translation.frequency_multiplier)
		end
	end
}

return LightControllerUtilities
