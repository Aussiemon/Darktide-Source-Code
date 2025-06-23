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
		cycle = self._effect_cycle,
		cycle_inverse = self._effect_cycle_inverse,
		ping_pong = self._effect_ping_pong
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
	if self._effect_active then
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
		ui_type = "resource",
		preview = false,
		value = "",
		ui_name = "Resource",
		filter = "unit"
	},
	size = {
		ui_type = "slider",
		min = 2,
		step = 1,
		decimals = 0,
		value = 3,
		ui_name = "Size",
		max = 20
	},
	spacing = {
		ui_type = "slider",
		min = 0,
		step = 0.1,
		decimals = 2,
		value = 1,
		ui_name = "Spacing (Meters)",
		max = 20
	},
	rotation_offset = {
		ui_type = "vector",
		ui_name = "Rotation offset",
		value = Vector3Box(0, 0, 0)
	},
	start_enabled = {
		ui_type = "check_box",
		value = true,
		ui_name = "Start Enabled"
	},
	fake_light = {
		ui_type = "check_box",
		value = false,
		ui_name = "Fake Light"
	},
	light_groups = {
		category = "Light Groups",
		ui_type = "text_box_array",
		size = 0,
		ui_name = "Light Groups",
		values = {}
	},
	effect = {
		ui_type = "combo_box",
		category = "Effect",
		value = "none",
		ui_name = "Effect",
		options_keys = {
			"None",
			"Cycle",
			"Cycle Inverse",
			"Ping Pong"
		},
		options_values = {
			"none",
			"cycle",
			"cycle_inverse",
			"ping_pong"
		}
	},
	effect_time_on = {
		ui_type = "number",
		decimals = 2,
		category = "Effect",
		value = 1,
		ui_name = "Time on (Seconds)",
		step = 0.01
	},
	effect_time_off = {
		ui_type = "number",
		decimals = 2,
		category = "Effect",
		value = 0,
		ui_name = "Time off (Seconds)",
		step = 0.01
	},
	light_type = {
		ui_type = "combo_box",
		category = "Lights",
		value = "omni",
		ui_name = "Type",
		options_keys = {
			"Omni",
			"Spot"
		},
		options_values = {
			"omni",
			"spot"
		}
	},
	light_ies = {
		ui_type = "resource",
		preview = false,
		category = "Lights",
		value = "",
		ui_name = "IES Profile",
		filter = "ies"
	},
	light_color_filter = {
		ui_type = "color",
		ui_name = "Color Filter",
		category = "Lights",
		value = QuaternionBox(Color(1, 1, 1, 1))
	},
	light_intensity = {
		ui_type = "slider",
		min = 0,
		step = 1,
		category = "Lights",
		value = 600,
		decimals = 0,
		ui_name = "Intensity",
		max = 10000
	},
	light_temperature = {
		ui_type = "slider",
		min = 0,
		step = 1,
		category = "Lights",
		value = 6570,
		decimals = 0,
		ui_name = "Temperature",
		max = 20000
	},
	light_volumetric_intensity = {
		ui_type = "slider",
		min = 0,
		step = 0.1,
		category = "Lights",
		value = 1,
		decimals = 2,
		ui_name = "Volumetric Intensity",
		max = 2
	},
	light_particle_intensity = {
		ui_type = "slider",
		min = 0,
		step = 0.1,
		category = "Lights",
		value = 1,
		decimals = 2,
		ui_name = "Particle Intensity",
		max = 2
	},
	light_cast_shadows = {
		ui_type = "check_box",
		value = false,
		ui_name = "Cast Shadows",
		category = "Lights"
	},
	light_dynamic = {
		ui_type = "check_box",
		value = false,
		ui_name = "Dynamic Light",
		category = "Lights"
	},
	light_force_static = {
		ui_type = "check_box",
		value = false,
		ui_name = "Force Static Light",
		category = "Lights"
	},
	light_max_shadow_resolution = {
		ui_type = "number",
		min = 0,
		step = 1,
		category = "Lights",
		value = 128,
		decimals = 0,
		ui_name = "Max Shadow Resolution",
		max = 1024
	},
	light_lens_flare = {
		ui_type = "check_box",
		value = false,
		ui_name = "Lens Flare Enabled",
		category = "Lights"
	},
	light_reflector = {
		ui_type = "check_box",
		value = false,
		ui_name = "Reflector",
		category = "Lights"
	},
	light_falloff_start = {
		ui_type = "number",
		min = 0,
		step = 1,
		category = "Lights",
		value = 0,
		decimals = 1,
		ui_name = "Falloff Start",
		max = 1000
	},
	light_falloff_end = {
		ui_type = "number",
		min = 0,
		step = 1,
		category = "Lights",
		value = 5,
		decimals = 1,
		ui_name = "Falloff End",
		max = 1000
	},
	light_angle_start = {
		ui_type = "number",
		min = 0,
		step = 1,
		category = "Lights",
		value = 0,
		decimals = 2,
		ui_name = "Angle Start",
		max = 1000
	},
	light_angle_end = {
		ui_type = "number",
		min = 0,
		step = 1,
		category = "Lights",
		value = 45,
		decimals = 2,
		ui_name = "Angle End",
		max = 1000
	},
	inputs = {
		start = {
			accessibility = "public",
			type = "event"
		},
		stop = {
			accessibility = "public",
			type = "event"
		}
	}
}

return LightArray
