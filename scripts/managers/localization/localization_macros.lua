-- chunkname: @scripts/managers/localization/localization_macros.lua

local InputUtils = require("scripts/managers/input/input_utils")
local localization_macros = {}

localization_macros.EXAMPLE_MACRO = function (param)
	return string.format("I'm an example macro and my param is %s", param)
end

localization_macros.INGAME_INPUT = function (param)
	local input_action = param

	if input_action and Managers.ui then
		local service_type = "Ingame"
		local alias_key = Managers.ui:get_input_alias_key(input_action, service_type)
		local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)

		return input_text
	end

	return "n/a"
end

localization_macros.VIEW_INPUT = function (param)
	local input_action = param

	if input_action and Managers.ui then
		local service_type = "View"
		local alias_key = Managers.ui:get_input_alias_key(input_action, service_type)
		local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)

		return input_text
	end

	return "n/a"
end

return settings("LocalizationMacros", localization_macros)
