-- chunkname: @scripts/components/shading_environment_volume.lua

local ShadingEnvironmentVolume = component("ShadingEnvironmentVolume")

ShadingEnvironmentVolume.init = function (self, unit)
	self:enable(unit)
end

ShadingEnvironmentVolume.enable = function (self, unit)
	local environment_extension = ScriptUnit.fetch_component_extension(unit, "shading_environment_system")

	if environment_extension then
		self._extension = environment_extension

		local fade_in_distance = self:get_data(unit, "fade_in_distance")
		local blend_layer = self:get_data(unit, "blend_layer")
		local blend_mask = self:get_data(unit, "blend_mask")
		local shading_environment = self:get_data(unit, "shading_environment")
		local shading_environment_slot_string = self:get_data(unit, "shading_environment_slot")
		local shading_environment_slot = tonumber(shading_environment_slot_string)
		local start_enabled = self:get_data(unit, "start_enabled")

		if shading_environment and shading_environment ~= "" then
			environment_extension:setup_from_component(fade_in_distance, blend_layer, blend_mask, shading_environment, shading_environment_slot, start_enabled)
		else
			Log.warning("ShadingEnvironmentVolume", "[Unit: %s, %s] A ShadingEnvironmentVolume is missing a ShadingEnvironment", unit, Unit.id_string(unit))
		end
	end
end

ShadingEnvironmentVolume.disable = function (self, unit)
	return
end

ShadingEnvironmentVolume.destroy = function (self, unit)
	return
end

ShadingEnvironmentVolume.editor_init = function (self, unit)
	if LevelEditor then
		self._enabled = self:get_data(unit, "start_enabled")

		if LevelEditor.register_shading_environment_volume then
			if self._enabled then
				local volume_data = {
					fade_in_distance = self:get_data(unit, "fade_in_distance"),
					blend_layer = self:get_data(unit, "blend_layer") or 1,
					override = self:get_data(unit, "override"),
					shading_environment = self:get_data(unit, "shading_environment"),
					shading_environment_slot = self:get_data(unit, "shading_environment_slot")
				}

				LevelEditor:register_shading_environment_volume(unit, volume_data)
			end
		else
			Application.console_send({
				system = "Shading Environment Volume",
				message = "You need to update your binaries, could not register shading environment volume with level editor!",
				level = "error",
				type = "message"
			})
		end
	end
end

ShadingEnvironmentVolume.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if self:get_data(unit, "shading_environment") == "" then
		success = false
		error_message = error_message .. "\nMissing unit data 'shading_environment' it can't be empty"
	end

	if rawget(_G, "LevelEditor") and not Unit.has_volume(unit, "env_volume") then
		success = false
		error_message = error_message .. "\nMissing volume 'env_volume'"
	end

	return success, error_message
end

ShadingEnvironmentVolume.enable_environment = function (self)
	local extension = self._extension

	if extension then
		extension:enable()
	end
end

ShadingEnvironmentVolume.disable_environment = function (self)
	local extension = self._extension

	if extension then
		extension:disable()
	end
end

ShadingEnvironmentVolume.editor_destroy = function (self, unit)
	if LevelEditor and LevelEditor.unregister_shading_environment_volume and self._enabled then
		LevelEditor:unregister_shading_environment_volume(unit)
	end
end

ShadingEnvironmentVolume.component_data = {
	fade_in_distance = {
		ui_type = "number",
		decimals = 0,
		value = 1,
		ui_name = "Fade in distance (m):",
		step = 1
	},
	blend_layer = {
		ui_type = "number",
		decimals = 0,
		value = 1,
		ui_name = "Layer:",
		step = 1
	},
	override = {
		ui_type = "check_box",
		value = false,
		ui_name = "Override: (Deprecated)"
	},
	blend_mask = {
		value = "ALL",
		ui_type = "combo_box",
		ui_name = "Blend Mask:",
		options_keys = {
			"ALL",
			"OVERRIDES"
		},
		options_values = {
			"ALL",
			"OVERRIDES"
		}
	},
	shading_environment = {
		ui_type = "resource",
		preview = false,
		value = "",
		ui_name = "Shading environment:",
		filter = "shading_environment"
	},
	shading_environment_slot = {
		value = "-1",
		ui_type = "combo_box",
		ui_name = "Shading environment Slot",
		options_keys = {
			"-1 - None"
		},
		options_values = {
			"-1"
		}
	},
	start_enabled = {
		ui_type = "check_box",
		value = true,
		ui_name = "Start Enabled"
	},
	extensions = {
		"ShadingEnvironmentExtension"
	},
	inputs = {
		enable_environment = {
			accessibility = "public",
			type = "event"
		},
		disable_environment = {
			accessibility = "public",
			type = "event"
		}
	}
}

return ShadingEnvironmentVolume
