-- chunkname: @scripts/components/decoder_device.lua

local DecoderDevice = component("DecoderDevice")

DecoderDevice.init = function (self, unit, is_server)
	local decoder_device_extension = ScriptUnit.fetch_component_extension(unit, "decoder_device_system")

	if decoder_device_extension then
		local material_slot = self:get_data(unit, "material_slot")
		local main_material = self:get_data(unit, "main_material")
		local ghost_material = self:get_data(unit, "ghost_material")
		local install_anim_event = self:get_data(unit, "install_anim_event")

		if main_material == "" or ghost_material == "" or install_anim_event == "" then
			Log.error("DecoderDevice", "Missing materials or anim event. material_slot(%q), main_material(%q), ghost_material(%q), install_anim_event(%q)", material_slot, main_material, ghost_material, install_anim_event)

			return
		end

		decoder_device_extension:setup_from_component(material_slot, main_material, ghost_material, install_anim_event)
	end
end

DecoderDevice.editor_init = function (self, unit)
	return
end

DecoderDevice.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if self:get_data(unit, "material_slot") == "" then
		success = false
		error_message = error_message .. "\nMissing unit data 'material_slot' it can't be empty"
	end

	if self:get_data(unit, "main_material") == "" then
		success = false
		error_message = error_message .. "\nMissing unit data 'main_material' it can't be empty"
	end

	if self:get_data(unit, "ghost_material") == "" then
		success = false
		error_message = error_message .. "\nMissing unit data 'ghost_material' it can't be empty"
	end

	if self:get_data(unit, "install_anim_event") == "" then
		success = false
		error_message = error_message .. "\nMissing unit data 'install_anim_event' it can't be empty"
	end

	return success, error_message
end

DecoderDevice.enable = function (self, unit)
	return
end

DecoderDevice.disable = function (self, unit)
	return
end

DecoderDevice.destroy = function (self, unit)
	return
end

DecoderDevice.component_data = {
	material_slot = {
		category = "Material",
		ui_name = "Material Slot",
		ui_type = "text_box",
		value = "",
	},
	main_material = {
		category = "Material",
		filter = "material",
		ui_name = "Main Material",
		ui_type = "resource",
		value = "",
	},
	ghost_material = {
		category = "Material",
		filter = "material",
		ui_name = "Ghost Material",
		ui_type = "resource",
		value = "",
	},
	install_anim_event = {
		ui_name = "Install Anim Event",
		ui_type = "text_box",
		value = "",
	},
	extensions = {
		"DecoderDeviceExtension",
	},
}

return DecoderDevice
