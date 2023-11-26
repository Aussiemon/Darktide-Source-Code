-- chunkname: @scripts/components/servo_skull_activator.lua

local ServoSkullActivator = component("ServoSkullActivator")

ServoSkullActivator.init = function (self, unit)
	return
end

ServoSkullActivator.editor_init = function (self, unit)
	return
end

ServoSkullActivator.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if rawget(_G, "LevelEditor") and not Unit.has_visibility_group(unit, "main") then
		success = false
		error_message = error_message .. "\nCouldn't find visibility group 'main'"
	end

	return success, error_message
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
	extensions = {
		"ServoSkullActivatorExtension"
	}
}

return ServoSkullActivator
