-- chunkname: @scripts/components/timed_synchronizer.lua

local TimedSynchronizer = component("TimedSynchronizer")

TimedSynchronizer.init = function (self, unit)
	local timed_synchronizer_extension = ScriptUnit.fetch_component_extension(unit, "event_synchronizer_system")

	self._unit = unit

	if timed_synchronizer_extension then
		local objective_name = self:get_data(unit, "objective_name")
		local automatic_start = self:get_data(unit, "automatic_start")

		timed_synchronizer_extension:setup_from_component(objective_name, automatic_start)

		self._timed_synchronizer_extension = timed_synchronizer_extension
	end
end

TimedSynchronizer.editor_init = function (self, unit)
	return
end

TimedSynchronizer.editor_validate = function (self, unit)
	return true, ""
end

TimedSynchronizer.start_timed_event = function (self)
	if self._timed_synchronizer_extension then
		self._timed_synchronizer_extension:start_event()
	end
end

TimedSynchronizer.add_time = function (self)
	if self._timed_synchronizer_extension then
		local time = self:get_data(self._unit, "time_to_add")

		self._timed_synchronizer_extension:add_time(time)
	end
end

TimedSynchronizer.enable = function (self, unit)
	return
end

TimedSynchronizer.disable = function (self, unit)
	return
end

TimedSynchronizer.destroy = function (self, unit)
	return
end

TimedSynchronizer.component_data = {
	objective_name = {
		ui_name = "Objective name",
		ui_type = "text_box",
		value = "default",
	},
	automatic_start = {
		ui_name = "Auto start on mission start",
		ui_type = "check_box",
		value = false,
	},
	time_to_add = {
		ui_name = "Time To Add",
		ui_type = "number",
		value = 0,
	},
	inputs = {
		start_timed_event = {
			accessibility = "public",
			type = "event",
		},
		add_time = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"TimedSynchronizerExtension",
	},
}

return TimedSynchronizer
