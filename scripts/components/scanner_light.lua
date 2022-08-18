local ScannerLight = component("ScannerLight")

ScannerLight.init = function (self, unit)
	self:enable(unit)

	local lights = {}
	local lights_array = self:get_data(unit, "lights")

	if lights_array then
		for i = 1, #lights_array, 1 do
			local light_name = lights_array[i]
			local has_light = Unit.has_light(unit, light_name)

			if has_light then
				local light = Unit.light(unit, light_name)
				lights[#lights + 1] = light
			end
		end
	end

	self._lights = lights
end

ScannerLight.editor_init = function (self, unit)
	self:enable(unit)

	self._should_debug_draw = false
end

ScannerLight.enable = function (self, unit)
	return
end

ScannerLight.disable = function (self, unit)
	return
end

ScannerLight.destroy = function (self, unit)
	return
end

ScannerLight.update = function (self, unit, dt, t)
	return
end

ScannerLight.editor_update = function (self, unit, dt, t)
	return
end

ScannerLight.changed = function (self, unit)
	return
end

ScannerLight.editor_changed = function (self, unit)
	return
end

ScannerLight.editor_world_transform_modified = function (self, unit)
	return
end

ScannerLight.editor_selection_changed = function (self, unit, selected)
	return
end

ScannerLight.editor_reset_physics = function (self, unit)
	return
end

ScannerLight.editor_property_changed = function (self, unit)
	return
end

ScannerLight.editor_on_level_spawned = function (self, unit, level)
	return
end

ScannerLight.editor_toggle_debug_draw = function (self, enable)
	self._should_debug_draw = enable
end

ScannerLight.enable_lights = function (self, enabled)
	local lights = self._lights

	for i = 1, #lights, 1 do
		local light = lights[i]

		Light.set_enabled(light, enabled)
	end
end

ScannerLight.set_light_color = function (self, color)
	local a, r, g, b = Quaternion.to_elements(color)
	local color_filter = Vector3(r / 255, g / 255, b / 255)
	local lights = self._lights

	for i = 1, #lights, 1 do
		local light = lights[i]

		Light.set_color_filter(light, color_filter)
	end
end

ScannerLight.component_data = {
	lights = {
		ui_type = "text_box_array",
		size = 1,
		ui_name = "Lights"
	},
	inputs = {
		function_example = {
			accessibility = "public",
			type = "event"
		}
	}
}

return ScannerLight
