local EmissiveLight = component("EmissiveLight")

EmissiveLight.init = function (self, unit)
	self:enable(unit)
end

EmissiveLight.enable = function (self, unit)
	if Unit.num_lights(unit) >= 1 then
		local light = Unit.light(unit, 1)
		local color_intensity = Light.color_with_intensity(light)
		local color = Vector3.normalize(color_intensity)
		local intensity = Vector3.length(color_intensity)

		Unit.set_vector3_for_materials(unit, "emissive_color", color)
		Unit.set_scalar_for_materials(unit, "emissive_intensity_lumen", intensity)
	end
end

EmissiveLight.disable = function (self, unit)
	return
end

EmissiveLight.destroy = function (self, unit)
	return
end

EmissiveLight.editor_validate = function (self, unit)
	return true, ""
end

EmissiveLight.component_data = {}

return EmissiveLight
