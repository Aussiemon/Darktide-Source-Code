-- chunkname: @scripts/components/light_array.lua

local LightControllerUtilities = require("core/scripts/common/light_controller_utilities")
local LightArray = component("LightArray")

LightArray.init = function (self, unit)
	local world = Unit.world(unit)

	self._world = world
	self._unit = unit
	self._spawned_units = {}

	local resource = self:get_data(unit, "resource")
	local spacing = self:get_data(unit, "spacing")
	local size = self:get_data(unit, "size")

	self._size = size

	local effect = self:get_data(unit, "effect")
	local start_enabled = self:get_data(unit, "start_enabled")
	local fake_light = self:get_data(unit, "fake_light")

	self._fake_light = fake_light

	local light_data = {}

	light_data.type = self:get_data(unit, "light_type")
	light_data.ies = self:get_data(unit, "light_ies")
	light_data.color_filter = self:get_data(unit, "light_color_filter")
	light_data.intensity = self:get_data(unit, "light_intensity")
	light_data.temperature = self:get_data(unit, "light_temperature")
	light_data.volumetric_intensity = self:get_data(unit, "light_volumetric_intensity")
	light_data.cast_shadows = self:get_data(unit, "light_cast_shadows")
	light_data.dynamic = self:get_data(unit, "light_dynamic")
	light_data.force_static = self:get_data(unit, "light_force_static")
	light_data.max_shadow_resolution = self:get_data(unit, "light_max_shadow_resolution")
	light_data.lens_flare = self:get_data(unit, "light_lens_flare")
	light_data.reflector = self:get_data(unit, "light_reflector")
	light_data.falloff_start = self:get_data(unit, "light_falloff_start")
	light_data.falloff_end = self:get_data(unit, "light_falloff_end")
	light_data.angle_start = self:get_data(unit, "light_angle_start")
	light_data.angle_end = self:get_data(unit, "light_angle_end")

	for i = 1, size do
		local index = string.format("%02d", i)
		local node_index = Unit.node(unit, "ap_node_" .. index)
		local spawned_unit = World.spawn_unit_ex(world, resource, nil, Unit.world_pose(unit, node_index))

		self._spawned_units[#self._spawned_units + 1] = spawned_unit

		World.link_unit(world, spawned_unit, 1, unit, node_index)

		local parent_node_index = Unit.node(unit, "ap_" .. index)

		Unit.set_local_position(unit, parent_node_index, Vector3(0, spacing * (i - 1), -0.02))

		local rotation_offset = self:get_data(unit, "rotation_offset")
		local rotation = Quaternion.from_euler_angles_xyz(-90 + rotation_offset.x, rotation_offset.z, rotation_offset.y)

		Unit.set_local_rotation(unit, parent_node_index, rotation)
		self:_set_light_data(spawned_unit, light_data)

		if effect == "none" then
			LightControllerUtilities.set_enabled(spawned_unit, start_enabled, fake_light)
		else
			LightControllerUtilities.set_enabled(spawned_unit, false, fake_light)
		end
	end

	self._effect_state = false
	self._effect_time_off = self:get_data(unit, "effect_time_off")
	self._effect_time_on = self:get_data(unit, "effect_time_on")
	self._effect_time = 0
	self._effect_index = 1

	local effects = {
		none = nil,
		cycle = self._effect_cycle,
		cycle_inverse = self._effect_cycle_inverse,
		ping_pong = self._effect_ping_pong,
	}

	self._effect = effects[effect]

	if effect == "cycle_inverse" then
		self._effect_index = self._size
	end

	self._effect_active = start_enabled and self._effect ~= nil

	return effect ~= "none"
end

LightArray.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:init(unit)

	local light_groups = self:get_data(unit, "light_groups")

	LevelEditor.light_groups:register_component(self, light_groups)

	local groups_enabled = LevelEditor.light_groups:settings()
	local light_group_enabled = true

	for _, group_name in pairs(light_groups) do
		if groups_enabled[group_name] == "OFF" then
			light_group_enabled = false
		end
	end
end

LightArray.editor_apply_enabled = function (self, light_group_enabled)
	local unit = self._unit
	local start_enabled = self:get_data(unit, "start_enabled")
	local fake_light = self:get_data(unit, "fake_light")

	if light_group_enabled == false then
		start_enabled = false
	end

	LightControllerUtilities.set_enabled(unit, start_enabled, fake_light)
end

LightArray.enable = function (self, unit)
	return
end

LightArray.disable = function (self, unit)
	return
end

LightArray.destroy = function (self, unit)
	local world = self._world

	for i = 1, #self._spawned_units do
		local spawned_unit = self._spawned_units[i]

		World.unlink_unit(world, spawned_unit)
		World.destroy_unit(world, spawned_unit)
	end
end

LightArray.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self:destroy()
	LevelEditor.light_groups:unregister_component(self)
end

LightArray.editor_validate = function (self, unit)
	return true, ""
end

LightArray.update = function (self, unit, dt, t)
	if self._effect_active and dt ~= nil then
		if self._effect_time_between == 0 then
			if self._effect_time > self._effect_time_on then
				self:_effect()

				self._effect_time = 0
			end
		elseif self._effect_time > self._effect_time_off then
			if not self._effect_state then
				self:_effect()

				self._effect_state = true
			elseif self._effect_time > self._effect_time_off + self._effect_time_on then
				self:_effect(true)

				self._effect_state = false
				self._effect_time = 0
			end
		end

		self._effect_time = self._effect_time + dt
	end

	return true
end

LightArray._effect_cycle = function (self, skip_on)
	if self._effect_index > self._size then
		self._effect_index = 1
	end

	local last_unit = self._spawned_units[self._effect_index - 1]

	if last_unit == nil then
		last_unit = self._spawned_units[self._size]
	end

	LightControllerUtilities.set_enabled(last_unit, false, self._fake_light)

	if skip_on == nil then
		local unit = self._spawned_units[self._effect_index]

		LightControllerUtilities.set_enabled(unit, true, self._fake_light)

		self._effect_index = self._effect_index + 1
	end
end

LightArray._effect_cycle_inverse = function (self, skip_on)
	if self._effect_index < 1 then
		self._effect_index = self._size
	end

	local last_unit = self._spawned_units[self._effect_index + 1]

	if last_unit == nil then
		last_unit = self._spawned_units[1]
	end

	LightControllerUtilities.set_enabled(last_unit, false, self._fake_light)

	if skip_on == nil then
		local unit = self._spawned_units[self._effect_index]

		LightControllerUtilities.set_enabled(unit, true, self._fake_light)

		self._effect_index = self._effect_index - 1
	end
end

LightArray._effect_ping_pong = function (self, skip_on)
	if self.ping == nil then
		self:_effect_cycle(skip_on)
	else
		self:_effect_cycle_inverse(skip_on)
	end

	if self._effect_index > self._size then
		self._effect_index = self._size - 1
		self.ping = true
	elseif self._effect_index < 1 then
		self._effect_index = 2
		self.ping = nil
	end
end

LightArray._set_light_data = function (self, spawned_unit, data)
	local num_lights = Unit.num_lights(spawned_unit)

	for i = 1, num_lights do
		local light = Unit.light(spawned_unit, i)

		Light.set_type(light, data.type)
		Light.set_ies_profile(light, data.ies)

		local _, r, g, b = Quaternion.to_elements(data.color_filter:unbox())

		Light.set_color_filter(light, Vector3(r / 255, g / 255, b / 255))
		Light.set_intensity(light, data.intensity)
		Light.set_correlated_color_temperature(light, data.temperature)
		Light.set_volumetric_intensity(light, data.volumetric_intensity)
		Light.set_casts_shadows(light, data.cast_shadows)
		Light.set_dynamic(light, data.dynamic)
		Light.set_force_static(light, data.force_static)
		Light.set_max_shadow_resolution(light, data.max_shadow_resolution)
		Light.set_lens_flare_enabled(light, data.lens_flare)
		Light.set_spot_reflector(light, data.reflector)
		Light.set_falloff_start(light, data.falloff_start)
		Light.set_falloff_end(light, data.falloff_end)
		Light.set_spot_angle_start(light, data.angle_start / 180 * math.pi)
		Light.set_spot_angle_end(light, data.angle_end / 180 * math.pi)

		local color_intensity = Light.color_with_intensity(light)
		local color = Vector3.normalize(color_intensity)
		local intensity = Vector3.length(color_intensity)

		Unit.set_vector3_for_materials(spawned_unit, "emissive_color", color)
		Unit.set_scalar_for_materials(spawned_unit, "emissive_intensity_lumen", intensity)
	end
end

LightArray.start = function (self, unit)
	if self._effect ~= nil then
		self._effect_active = true
	else
		for i = 1, #self._spawned_units do
			local unit = self._spawned_units[i]

			LightControllerUtilities.set_enabled(unit, true, self._fake_light)
		end
	end
end

LightArray.stop = function (self, unit)
	self._effect_active = false

	for i = 1, #self._spawned_units do
		local unit = self._spawned_units[i]

		LightControllerUtilities.set_enabled(unit, false, self._fake_light)
	end
end

LightArray.component_data = {
	resource = {
		filter = "unit",
		preview = false,
		ui_name = "Resource",
		ui_type = "resource",
		value = "",
	},
	size = {
		decimals = 0,
		max = 20,
		min = 2,
		step = 1,
		ui_name = "Size",
		ui_type = "slider",
		value = 3,
	},
	spacing = {
		decimals = 2,
		max = 20,
		min = 0,
		step = 0.1,
		ui_name = "Spacing (Meters)",
		ui_type = "slider",
		value = 1,
	},
	rotation_offset = {
		ui_name = "Rotation offset",
		ui_type = "vector",
		value = Vector3Box(0, 0, 0),
	},
	start_enabled = {
		ui_name = "Start Enabled",
		ui_type = "check_box",
		value = true,
	},
	fake_light = {
		ui_name = "Fake Light",
		ui_type = "check_box",
		value = false,
	},
	light_groups = {
		category = "Light Groups",
		size = 0,
		ui_name = "Light Groups",
		ui_type = "text_box_array",
		values = {},
	},
	effect = {
		category = "Effect",
		ui_name = "Effect",
		ui_type = "combo_box",
		value = "none",
		options_keys = {
			"None",
			"Cycle",
			"Cycle Inverse",
			"Ping Pong",
		},
		options_values = {
			"none",
			"cycle",
			"cycle_inverse",
			"ping_pong",
		},
	},
	effect_time_on = {
		category = "Effect",
		decimals = 2,
		step = 0.01,
		ui_name = "Time on (Seconds)",
		ui_type = "number",
		value = 1,
	},
	effect_time_off = {
		category = "Effect",
		decimals = 2,
		step = 0.01,
		ui_name = "Time off (Seconds)",
		ui_type = "number",
		value = 0,
	},
	light_type = {
		category = "Lights",
		ui_name = "Type",
		ui_type = "combo_box",
		value = "omni",
		options_keys = {
			"Omni",
			"Spot",
		},
		options_values = {
			"omni",
			"spot",
		},
	},
	light_ies = {
		category = "Lights",
		filter = "ies",
		preview = false,
		ui_name = "IES Profile",
		ui_type = "resource",
		value = "",
	},
	light_color_filter = {
		category = "Lights",
		ui_name = "Color Filter",
		ui_type = "color",
		value = QuaternionBox(Color(1, 1, 1, 1)),
	},
	light_intensity = {
		category = "Lights",
		decimals = 0,
		max = 10000,
		min = 0,
		step = 1,
		ui_name = "Intensity",
		ui_type = "slider",
		value = 600,
	},
	light_temperature = {
		category = "Lights",
		decimals = 0,
		max = 20000,
		min = 0,
		step = 1,
		ui_name = "Temperature",
		ui_type = "slider",
		value = 6570,
	},
	light_volumetric_intensity = {
		category = "Lights",
		decimals = 2,
		max = 2,
		min = 0,
		step = 0.1,
		ui_name = "Volumetric Intensity",
		ui_type = "slider",
		value = 1,
	},
	light_particle_intensity = {
		category = "Lights",
		decimals = 2,
		max = 2,
		min = 0,
		step = 0.1,
		ui_name = "Particle Intensity",
		ui_type = "slider",
		value = 1,
	},
	light_cast_shadows = {
		category = "Lights",
		ui_name = "Cast Shadows",
		ui_type = "check_box",
		value = false,
	},
	light_dynamic = {
		category = "Lights",
		ui_name = "Dynamic Light",
		ui_type = "check_box",
		value = false,
	},
	light_force_static = {
		category = "Lights",
		ui_name = "Force Static Light",
		ui_type = "check_box",
		value = false,
	},
	light_max_shadow_resolution = {
		category = "Lights",
		decimals = 0,
		max = 1024,
		min = 0,
		step = 1,
		ui_name = "Max Shadow Resolution",
		ui_type = "number",
		value = 128,
	},
	light_lens_flare = {
		category = "Lights",
		ui_name = "Lens Flare Enabled",
		ui_type = "check_box",
		value = false,
	},
	light_reflector = {
		category = "Lights",
		ui_name = "Reflector",
		ui_type = "check_box",
		value = false,
	},
	light_falloff_start = {
		category = "Lights",
		decimals = 1,
		max = 1000,
		min = 0,
		step = 1,
		ui_name = "Falloff Start",
		ui_type = "number",
		value = 0,
	},
	light_falloff_end = {
		category = "Lights",
		decimals = 1,
		max = 1000,
		min = 0,
		step = 1,
		ui_name = "Falloff End",
		ui_type = "number",
		value = 5,
	},
	light_angle_start = {
		category = "Lights",
		decimals = 2,
		max = 1000,
		min = 0,
		step = 1,
		ui_name = "Angle Start",
		ui_type = "number",
		value = 0,
	},
	light_angle_end = {
		category = "Lights",
		decimals = 2,
		max = 1000,
		min = 0,
		step = 1,
		ui_name = "Angle End",
		ui_type = "number",
		value = 45,
	},
	inputs = {
		start = {
			accessibility = "public",
			type = "event",
		},
		stop = {
			accessibility = "public",
			type = "event",
		},
	},
}

return LightArray
