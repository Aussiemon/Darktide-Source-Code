-- chunkname: @scripts/components/weather_volume.lua

local WeatherVolume = component("WeatherVolume")

WeatherVolume.init = function (self, unit)
	if not DEDICATED_SERVER then
		self:enable(unit)
	end
end

WeatherVolume.enable = function (self, unit)
	local weather_extension = ScriptUnit.fetch_component_extension(unit, "weather_system")

	if weather_extension then
		local world_particles = self:get_data(unit, "world_particles")
		local screen_particles = self:get_data(unit, "screen_particles")
		local priority = self:get_data(unit, "priority")

		weather_extension:setup_from_component(world_particles, screen_particles, priority)
	end
end

WeatherVolume.disable = function (self, unit)
	return
end

WeatherVolume.destroy = function (self, unit)
	return
end

WeatherVolume.editor_init = function (self, unit)
	return
end

WeatherVolume.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if rawget(_G, "LevelEditor") and not Unit.has_volume(unit, "weather_volume") then
		success = false
		error_message = error_message .. "\nMissing volume 'weather_volume'"
	end

	return success, error_message
end

WeatherVolume.editor_destroy = function (self, unit)
	return
end

WeatherVolume.component_data = {
	world_particles = {
		filter = "particles",
		preview = false,
		ui_name = "World Particles",
		ui_type = "resource",
		value = "",
	},
	screen_particles = {
		filter = "particles",
		preview = false,
		ui_name = "Screen Particles",
		ui_type = "resource",
		value = "",
	},
	priority = {
		decimals = 0,
		max = 10,
		min = 1,
		step = 1,
		ui_name = "Priority",
		ui_type = "number",
		value = 1,
	},
	extensions = {
		"WeatherExtension",
	},
}

return WeatherVolume
