-- chunkname: @scripts/components/demolition_synchronizer.lua

local DemolitionSynchronizer = component("DemolitionSynchronizer")

DemolitionSynchronizer.init = function (self, unit, is_server)
	self._unit = unit
	self._is_server = is_server
	self._attached_units = {}
	self._destructed_units = 0

	local demolition_synchronizer_extension = ScriptUnit.fetch_component_extension(unit, "event_synchronizer_system")

	if demolition_synchronizer_extension then
		local objective_name = self:get_data(unit, "objective_name")
		local total_segments = self:get_data(unit, "total_segments")
		local shuffle_segments = self:get_data(unit, "shuffle_segments")
		local lock_last_segment = self:get_data(unit, "lock_last_segment")
		local stage_end_delay = self:get_data(unit, "stage_end_delay")
		local segment_end_delay = self:get_data(unit, "segment_end_delay")
		local auto_start = self:get_data(unit, "automatic_start")

		demolition_synchronizer_extension:setup_from_component(objective_name, total_segments, shuffle_segments, lock_last_segment, stage_end_delay, segment_end_delay, auto_start)

		self._demolition_synchronizer_extension = demolition_synchronizer_extension
	end
end

DemolitionSynchronizer.start_demolition_event = function (self)
	if self._demolition_synchronizer_extension then
		self._demolition_synchronizer_extension:start_event()
	end
end

DemolitionSynchronizer.editor_init = function (self, unit)
	return
end

DemolitionSynchronizer.editor_validate = function (self, unit)
	return true, ""
end

DemolitionSynchronizer.enable = function (self, unit)
	return
end

DemolitionSynchronizer.disable = function (self, unit)
	return
end

DemolitionSynchronizer.destroy = function (self, unit)
	return
end

DemolitionSynchronizer.component_data = {
	objective_name = {
		ui_name = "Objective Name",
		ui_type = "text_box",
		value = "default",
	},
	total_segments = {
		decimals = 0,
		ui_name = "Objective Segments",
		ui_type = "number",
		value = 1,
	},
	shuffle_segments = {
		ui_name = "Shuffle Segments",
		ui_type = "check_box",
		value = true,
	},
	lock_last_segment = {
		ui_name = "Lock Last Segment",
		ui_type = "check_box",
		value = false,
	},
	stage_end_delay = {
		decimals = 100,
		step = 0.1,
		ui_name = "Stage End Delay (sec.)",
		ui_type = "number",
		value = 0,
	},
	segment_end_delay = {
		decimals = 100,
		step = 0.1,
		ui_name = "Segment End Delay (sec.)",
		ui_type = "number",
		value = 8,
	},
	automatic_start = {
		ui_name = "Auto Start On Mission Start",
		ui_type = "check_box",
		value = false,
	},
	inputs = {
		start_demolition_event = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"DemolitionSynchronizerExtension",
	},
}

return DemolitionSynchronizer
