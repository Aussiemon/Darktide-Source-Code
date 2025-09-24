-- chunkname: @scripts/components/timed_synchronizer.lua

local TimedSynchronizer = component("TimedSynchronizer")

TimedSynchronizer.init = function (self, unit, is_server)
	local timed_synchronizer_extension = ScriptUnit.fetch_component_extension(unit, "event_synchronizer_system")

	self._unit = unit
	self._is_server = is_server

	if timed_synchronizer_extension then
		local objective_name = self:get_data(unit, "objective_name")
		local auto_start = self:get_data(unit, "automatic_start")
		local global_group = self:get_data(unit, "global_group")
		local curve_power = self:get_data(unit, "curve_power")

		timed_synchronizer_extension:setup_from_component(objective_name, global_group, auto_start, curve_power)

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

TimedSynchronizer.pause = function (self)
	if self._timed_synchronizer_extension and self._is_server then
		self._timed_synchronizer_extension:pause_event()
	end
end

TimedSynchronizer.resume = function (self)
	if self._timed_synchronizer_extension and self._is_server then
		self._timed_synchronizer_extension:resume_event()
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
	global_group = {
		ui_name = "Global Objective",
		ui_type = "check_box",
		value = false,
	},
	automatic_start = {
		ui_name = "Automatic Start On Mission Start",
		ui_type = "check_box",
		value = false,
	},
	time_to_add = {
		ui_name = "Time To Add",
		ui_type = "number",
		value = 0,
	},
	curve_power = {
		ui_name = "Curve Power",
		ui_type = "number",
		value = 1,
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
		pause = {
			accessibility = "public",
			type = "event",
		},
		resume = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"TimedSynchronizerExtension",
	},
}

return TimedSynchronizer
