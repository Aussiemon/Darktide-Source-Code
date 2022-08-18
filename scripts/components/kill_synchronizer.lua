local KillSynchronizer = component("KillSynchronizer")

KillSynchronizer.init = function (self, unit)
	local kill_synchronizer_extension = ScriptUnit.fetch_component_extension(unit, "event_synchronizer_system")

	if kill_synchronizer_extension then
		local objective_name = self:get_data(unit, "objective_name")
		local automatic_start = self:get_data(unit, "automatic_start")

		kill_synchronizer_extension:setup_from_component(objective_name, automatic_start)

		self._kill_synchronizer_extension = kill_synchronizer_extension
	end
end

KillSynchronizer.editor_init = function (self, unit)
	return
end

KillSynchronizer.start_kill_event = function (self)
	if self._kill_synchronizer_extension then
		self._kill_synchronizer_extension:start_event()
	end
end

KillSynchronizer.enable = function (self, unit)
	return
end

KillSynchronizer.disable = function (self, unit)
	return
end

KillSynchronizer.destroy = function (self, unit)
	return
end

KillSynchronizer.component_data = {
	objective_name = {
		ui_type = "text_box",
		value = "default",
		ui_name = "Objective name"
	},
	automatic_start = {
		ui_type = "check_box",
		value = false,
		ui_name = "Auto start on mission start"
	},
	inputs = {
		start_kill_event = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"KillSynchronizerExtension"
	}
}

return KillSynchronizer
