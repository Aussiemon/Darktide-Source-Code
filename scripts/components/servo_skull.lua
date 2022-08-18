local ServoSkull = component("ServoSkull")

ServoSkull.init = function (self, unit)
	local servo_skull_extension = ScriptUnit.fetch_component_extension(unit, "servo_skull_system")

	if servo_skull_extension then
		local pulse_interval = self:get_data(unit, "pulse_interval")

		servo_skull_extension:setup_from_component(pulse_interval)
	end
end

ServoSkull.editor_init = function (self, unit)
	return
end

ServoSkull.enable = function (self, unit)
	return
end

ServoSkull.disable = function (self, unit)
	return
end

ServoSkull.destroy = function (self, unit)
	return
end

ServoSkull.component_data = {
	pulse_interval = {
		ui_type = "number",
		value = 10,
		ui_name = "Pulse interval (in sec)"
	},
	extensions = {
		"ServoSkullExtension"
	}
}

return ServoSkull
