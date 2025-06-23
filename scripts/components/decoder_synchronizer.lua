-- chunkname: @scripts/components/decoder_synchronizer.lua

local DecoderSynchronizer = component("DecoderSynchronizer")

DecoderSynchronizer.init = function (self, unit, is_server)
	self:enable(unit)

	local decoder_synchronizer_extension = ScriptUnit.fetch_component_extension(unit, "event_synchronizer_system")

	if decoder_synchronizer_extension then
		local objective_name = self:get_data(unit, "objective_name")
		local auto_start = self:get_data(unit, "automatic_start")
		local min_time_until_stalling = self:get_data(unit, "min_time_until_stalling")
		local max_time_until_stalling = self:get_data(unit, "max_time_until_stalling")
		local num_active_units = self:get_data(unit, "num_active_units")
		local stall_once_per_device = self:get_data(unit, "stall_once_per_device")
		local setup_only = self:get_data(unit, "setup_only")
		local progress_in_minigame = self:get_data(unit, "progress_in_minigame")

		decoder_synchronizer_extension:setup_from_component(objective_name, auto_start, min_time_until_stalling, max_time_until_stalling, num_active_units, stall_once_per_device, setup_only, progress_in_minigame)

		self._decoder_synchronizer_extension = decoder_synchronizer_extension
	end
end

DecoderSynchronizer.editor_init = function (self, unit)
	return
end

DecoderSynchronizer.editor_validate = function (self, unit)
	return true, ""
end

DecoderSynchronizer.editor_update = function (self, unit, dt, t)
	return
end

DecoderSynchronizer.enable = function (self, unit)
	return
end

DecoderSynchronizer.disable = function (self, unit)
	return
end

DecoderSynchronizer.destroy = function (self, unit)
	return
end

DecoderSynchronizer.start_decoding_event = function (self)
	if self._decoder_synchronizer_extension then
		self._decoder_synchronizer_extension:start_event()
	end
end

DecoderSynchronizer.component_data = {
	objective_name = {
		ui_type = "text_box",
		value = "default",
		ui_name = "Objective Name"
	},
	automatic_start = {
		ui_type = "check_box",
		value = false,
		ui_name = "Auto Start On Mission Start"
	},
	min_time_until_stalling = {
		ui_type = "number",
		value = 20,
		ui_name = "Min time until stalling (in sec.)"
	},
	max_time_until_stalling = {
		ui_type = "number",
		value = 30,
		ui_name = "Max time until stalling (in sec.)"
	},
	num_active_units = {
		ui_type = "number",
		value = 1,
		ui_name = "Num. of Active Units"
	},
	stall_once_per_device = {
		ui_type = "check_box",
		value = false,
		ui_name = "Stall only once per device"
	},
	setup_only = {
		ui_type = "check_box",
		value = false,
		ui_name = "Setup Only"
	},
	progress_in_minigame = {
		value = false,
		ui_type = "combo_box",
		ui_name = "Progress In Minigame",
		options_keys = {
			"true",
			"On Stall",
			"false"
		},
		options_values = {
			true,
			"On Stall",
			false
		}
	},
	inputs = {
		start_decoding_event = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"DecoderSynchronizerExtension",
		"NetworkedTimerExtension"
	}
}

return DecoderSynchronizer
