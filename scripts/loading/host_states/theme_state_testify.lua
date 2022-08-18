local ThemeStateTestify = {
	check_theme_loaded = function (_, theme_packages, level_name, circumstance_name)
		if table.is_empty(theme_packages) then
			ferror("No theme created for level: %q circumstance: %q", level_name, circumstance_name)
		end
	end
}

return ThemeStateTestify
