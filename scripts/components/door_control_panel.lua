local DoorControlPanel = component("DoorControlPanel")

DoorControlPanel.init = function (self, unit)
	self:enable(unit)

	local door_control_panel_extension = ScriptUnit.fetch_component_extension(unit, "door_control_panel_system")

	if door_control_panel_extension then
		local start_active = self:get_data(unit, "start_active")

		door_control_panel_extension:setup_from_component(start_active)

		self._door_control_panel_extension = door_control_panel_extension
	end
end

DoorControlPanel.editor_init = function (self, unit)
	return
end

DoorControlPanel.enable = function (self, unit)
	return
end

DoorControlPanel.disable = function (self, unit)
	return
end

DoorControlPanel.destroy = function (self, unit)
	return
end

DoorControlPanel.activate = function (self)
	if self._door_control_panel_extension then
		self._door_control_panel_extension:set_active(true)
	end
end

DoorControlPanel.deactivate = function (self)
	if self._door_control_panel_extension then
		self._door_control_panel_extension:set_active(false)
	end
end

DoorControlPanel.component_data = {
	start_active = {
		ui_type = "check_box",
		value = true,
		ui_name = "Start Active"
	},
	inputs = {
		activate = {
			accessibility = "public",
			type = "event"
		},
		deactivate = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"DoorControlPanelExtension"
	}
}

return DoorControlPanel
