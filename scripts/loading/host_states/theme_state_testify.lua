-- chunkname: @scripts/loading/host_states/theme_state_testify.lua

local ThemePackage = require("scripts/foundation/managers/package/utilities/theme_package")
local ThemeStateTestify = {
	check_theme_loaded = function (theme_packages, level_name, circumstance_name)
		if not ThemePackage.disabled_levels[level_name] and table.is_empty(theme_packages) then
			ferror("No theme created for level: %q circumstance: %q", level_name, circumstance_name)
		end
	end,
}

return ThemeStateTestify
