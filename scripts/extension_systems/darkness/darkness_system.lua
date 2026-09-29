-- chunkname: @scripts/extension_systems/darkness/darkness_system.lua

local DarknessSystem = class("DarknessSystem", "ExtensionSystemBase")
local extensions = {
	"LightSourceExtension",
	"PlayerUnitDarknessExtension"
}

DarknessSystem.DARKNESS_THRESHOLD = 0.025
DarknessSystem.TOTAL_DARKNESS_TRESHOLD = 0.0125

DarknessSystem.init = function (self, entity_system_creation_context, system_init_data, system_name)
	DarknessSystem.super.init(self, entity_system_creation_context, system_init_data, system_name, extensions)

	self._light_source_data = {}
	self._player_unit_darkness_data = {}

	local darkness_settings = system_init_data.mission.darkness_settings

	if darkness_settings then
		local volumes = darkness_settings.volumes

		self._darkness_volumes = volumes
		self._num_volumes = #volumes
	else
		self._num_volumes = 0
	end

	self._in_darkness = false
	self._global_darkness = false
end

DarknessSystem.set_global_darkness = function (self, set)
	self._global_darkness = set
end

DarknessSystem.set_level = function (self, level)
	self._level = level
end

DarknessSystem.destroy = function (self)
	self._environment_handler = nil
end

DarknessSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data)
	local extension

	if extension_name == "LightSourceExtension" then
		extension = {
			intensity = extension_init_data and extension_init_data.intensity or 1
		}
	elseif extension_name == "PlayerUnitDarknessExtension" then
		extension = {
			darkness_intensity = 0,
			intensity = extension_init_data and extension_init_data.intensity or 1
		}
	end

	ScriptUnit.set_extension(unit, self._name, extension)

	return extension
end

DarknessSystem.register_extension_update = function (self, unit, extension_name, extension)
	if extension_name == "LightSourceExtension" then
		self._light_source_data[unit] = extensions
	elseif extension_name == "PlayerUnitDarknessExtension" then
		self._player_unit_darkness_data[unit] = extension
		self._light_source_data[unit] = extension
	end
end

DarknessSystem.on_remove_extension = function (self, unit, extension_name)
	DarknessSystem.super.on_remove_extension(self, unit, extension_name)

	if extension_name == "LightSourceExtension" then
		self._light_source_data[unit] = nil
		POSITION_LOOKUP[unit] = nil
	elseif extension_name == "PlayerUnitDarknessExtension" then
		self._player_unit_darkness_data[unit] = nil
	end
end

DarknessSystem.update = function (self, context, dt, t, ...)
	if self._darkness_volumes or self._global_darkness then
		self:_update_light_sources(dt, t)
		self:_update_player_unit_darkness(dt, t)
	end
end

DarknessSystem._update_light_sources = function (self, dt, t)
	return
end

local IN_LIGHT_LIGHT_VALUE = 0.05
local IN_TWILIGHT_LIGHT_VALUE = 0.015
local TWILIGHT_MAX_INTENSITY = 0.15

local function LIGHT_TO_DARKNESS_INTENSITY_CONVERSION_FUNCTION(light_value)
	local darkness = (1 - light_value / IN_TWILIGHT_LIGHT_VALUE)^2

	return darkness / 15
end

DarknessSystem._update_player_unit_darkness = function (self, dt, t)
	for unit, data in pairs(self._player_unit_darkness_data) do
		local unit_position = POSITION_LOOKUP[unit]
		local pos = unit_position + Vector3(0, 0, 1)
		local in_darkness = self:is_in_darkness_volume(pos)
		local light_value

		if in_darkness then
			light_value = self:calculate_light_value(pos)

			if light_value > IN_LIGHT_LIGHT_VALUE then
				data.darkness_intensity = 0
				data.in_darkness = false
			elseif light_value > IN_TWILIGHT_LIGHT_VALUE then
				data.darkness_intensity = math.auto_lerp(IN_LIGHT_LIGHT_VALUE, IN_TWILIGHT_LIGHT_VALUE, 0, TWILIGHT_MAX_INTENSITY, light_value)
				data.in_darkness = true
			else
				data.darkness_intensity = math.min(math.max(data.darkness_intensity, TWILIGHT_MAX_INTENSITY) + dt * LIGHT_TO_DARKNESS_INTENSITY_CONVERSION_FUNCTION(light_value), 1)
				data.in_darkness = true
			end
		else
			data.in_darkness = false
			data.darkness_intensity = 0
		end
	end
end

DarknessSystem.is_in_darkness_volume = function (self, position)
	if self._global_darkness then
		return true
	end

	local volumes = self._darkness_volumes

	if volumes then
		local is_inside_func = Level.is_point_inside_volume
		local level = self._level

		for i = 1, self._num_volumes do
			local vol_name = volumes[i]

			if is_inside_func(level, vol_name, position) then
				return true
			end
		end
	end

	return false
end

DarknessSystem.calculate_light_value = function (self, position)
	local light_value = 0

	for unit, data in pairs(self._light_source_data) do
		local pos = POSITION_LOOKUP[unit]
		local dist_sq = math.max(Vector3.distance_squared(position, pos), 1)
		local intensity = data.intensity

		light_value = light_value + intensity * (1 / dist_sq)
	end

	return light_value
end

DarknessSystem.is_in_darkness = function (self, position, darkness_treshold)
	if not self:is_in_darkness_volume(position) then
		return false
	end

	local light_value = self:calculate_light_value(position)

	return light_value < (darkness_treshold or DarknessSystem.DARKNESS_THRESHOLD)
end

return DarknessSystem
