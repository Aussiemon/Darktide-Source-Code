local LightControllerUtilities = require("core/scripts/common/light_controller_utilities")
local LightControllerFlickerSettings = require("scripts/settings/components/light_controller_flicker")

LightControllerUtilities.register_flicker_configurations(LightControllerFlickerSettings)

local LightController = component("LightController")

LightController.init = function (self, unit)
	self._unit = unit

	LightControllerUtilities.set_intensity(unit)

	local light_controller_extension = ScriptUnit.fetch_component_extension(unit, "light_controller_system")

	if light_controller_extension then
		local start_enabled = self:get_data(unit, "start_enabled")
		local fake_light = self:get_data(unit, "fake_light")
		local light_groups = self:get_data(unit, "light_groups")
		local flicker_start_enabled = self:get_data(unit, "flicker_start_enabled")
		local flicker_config = self:get_data(unit, "flicker_config")

		light_controller_extension:setup_from_component(start_enabled, fake_light, light_groups, flicker_start_enabled, flicker_config)

		self._light_controller_extension = light_controller_extension

		if start_enabled then
			Unit.flow_event(unit, "lua_light_controller_spawned_enabled")
		else
			Unit.flow_event(unit, "lua_light_controller_spawned_disabled")
		end
	end
end

LightController.editor_init = function (self, unit)
	if LevelEditor then
		local light_groups = self:get_data(unit, "light_groups")

		LevelEditor.light_groups:register_component(self, light_groups)

		self._unit = unit

		LightControllerUtilities.set_intensity(unit)

		local groups_enabled = LevelEditor.light_groups:settings()
		local light_group_enabled = true

		for _, group_name in pairs(light_groups) do
			if groups_enabled[group_name] == "OFF" then
				light_group_enabled = false
			end
		end

		self:editor_apply_enabled(light_group_enabled)

		local flicker_enabled = self:get_data(unit, "flicker_start_enabled")

		if flicker_enabled then
			local flicker_config = self:get_data(unit, "flicker_config")

			LightControllerUtilities.set_flicker(unit, flicker_enabled, flicker_config)
		end

		if self:get_data(unit, "start_enabled") then
			Unit.flow_event(unit, "lua_light_controller_spawned_editor_enabled")
		else
			Unit.flow_event(unit, "lua_light_controller_spawned_editor_disabled")
		end
	end
end

LightController.editor_apply_enabled = function (self, light_group_enabled)
	local unit = self._unit
	local start_enabled = self:get_data(unit, "start_enabled")
	local fake_light = self:get_data(unit, "fake_light")

	if light_group_enabled == false then
		start_enabled = false
	end

	LightControllerUtilities.set_enabled(unit, start_enabled, fake_light)
end

LightController.enable = function (self, unit)
	return
end

LightController.disable = function (self, unit)
	return
end

LightController.destroy = function (self, unit)
	return
end

LightController.enable_lights = function (self)
	local light_controller_extension = self._light_controller_extension

	if light_controller_extension then
		local is_enabled = true
		local is_deterministic = false

		light_controller_extension:set_enabled(is_enabled, is_deterministic)
	end
end

LightController.disable_lights = function (self)
	local light_controller_extension = self._light_controller_extension

	if light_controller_extension then
		local is_enabled = false
		local is_deterministic = false

		light_controller_extension:set_enabled(is_enabled, is_deterministic)
	end
end

LightController.enable_flicker = function (self)
	local light_controller_extension = self._light_controller_extension

	if light_controller_extension then
		local is_enabled = true
		local configuration = nil
		local is_deterministic = false

		light_controller_extension:set_flicker_state(is_enabled, configuration, is_deterministic)
	end
end

LightController.disable_flicker = function (self)
	local light_controller_extension = self._light_controller_extension

	if light_controller_extension then
		local is_enabled = false
		local configuration = nil
		local is_deterministic = false

		light_controller_extension:set_flicker_state(is_enabled, configuration, is_deterministic)
	end
end

LightController.editor_destroy = function (self, unit)
	if LevelEditor then
		LevelEditor.light_groups:unregister_component(self)
	end
end

LightController.component_data = {
	start_enabled = {
		ui_type = "check_box",
		value = true,
		ui_name = "Start Enabled"
	},
	light_groups = {
		category = "Light Groups",
		ui_type = "text_box_array",
		size = 0,
		ui_name = "Light Groups",
		values = {}
	},
	fake_light = {
		ui_type = "check_box",
		value = false,
		ui_name = "Fake Light"
	},
	flicker_start_enabled = {
		ui_type = "check_box",
		value = false,
		ui_name = "Flicker Enabled",
		category = "Flicker"
	},
	flicker_config = {
		ui_type = "combo_box",
		category = "Flicker",
		value = "default",
		ui_name = "Config",
		options_keys = {
			"Default",
			"Default 2",
			"Movement - Expensive"
		},
		options_values = {
			"default",
			"default2",
			"movement_expensive"
		}
	},
	extensions = {
		"LightControllerExtension"
	},
	inputs = {
		enable_lights = {
			accessibility = "public",
			type = "event"
		},
		disable_lights = {
			accessibility = "public",
			type = "event"
		},
		enable_flicker = {
			accessibility = "public",
			type = "event"
		},
		disable_flicker = {
			accessibility = "public",
			type = "event"
		}
	}
}

return LightController
