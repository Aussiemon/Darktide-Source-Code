local function syntax_check(mechanism_settings)
	for name, settings in pairs(mechanism_settings) do
		fassert(settings.class_file_name, "Mechanism %q is missing class_file_name.", name)
		fassert(settings.class_name, "Mechanism %q is missing class_name.", name)
		fassert(settings.states, "Mechanism %q is missing states.", name)
	end
end

return syntax_check
