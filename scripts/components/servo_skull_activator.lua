local ServoSkullActivator = component("ServoSkullActivator")

ServoSkullActivator.init = function (self, unit)
	local servo_skull_activator_extension = ScriptUnit.fetch_component_extension(unit, "servo_skull_system")

	if servo_skull_activator_extension then
		local hide_timer = self:get_data(unit, "hide_timer")

		servo_skull_activator_extension:setup_from_component(hide_timer)
	end
end

ServoSkullActivator.editor_init = function (self, unit)
	return
end

ServoSkullActivator.enable = function (self, unit)
	return
end

ServoSkullActivator.disable = function (self, unit)
	return
end

ServoSkullActivator.destroy = function (self, unit)
	return
end

ServoSkullActivator.component_data = {
	hide_timer = {
		ui_type = "number",
		value = 10,
		ui_name = "Hide Delay (in sec.)"
	},
	extensions = {
		"ServoSkullActivatorExtension"
	}
}

return ServoSkullActivator
