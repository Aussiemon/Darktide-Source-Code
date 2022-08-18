local localization_macros = {
	EXAMPLE_MACRO = function (param)
		return string.format("I'm an example macro and my param is %s", param)
	end
}

return settings("LocalizationMacros", localization_macros)
