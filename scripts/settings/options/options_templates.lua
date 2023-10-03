local category_settings = {
	{
		path = "scripts/settings/options/interface_settings"
	},
	{
		dofile = true,
		path = "scripts/settings/options/sound_settings"
	},
	{
		path = "scripts/settings/options/render_settings",
		validation_function = function ()
			return IS_GDK or IS_XBS or IS_WINDOWS
		end
	},
	{
		path = "scripts/settings/options/keybind_settings",
		validation_function = function ()
			return (IS_GDK or IS_XBS or IS_WINDOWS) and Managers.ui:using_cursor_navigation()
		end
	},
	{
		path = "scripts/settings/options/controller_settings",
		validation_function = function ()
			return IS_GDK or IS_XBS or IS_WINDOWS
		end
	},
	{
		path = "scripts/settings/options/input_settings"
	}
}

local function generate_settings(entries)
	local categories = {}
	local all_settings = {}

	for _, entry in ipairs(entries) do
		local path = entry.path
		local config = nil

		if entry.dofile then
			config = dofile(path)
		else
			config = require(path)
		end

		local settings = config.settings
		local reset_function = config.reset_function
		local category_display_name = config.display_name or "n/a"
		local category_icon = config.icon
		local can_be_reset = config.can_be_reset

		if can_be_reset == nil then
			can_be_reset = true
		end

		categories[#categories + 1] = {
			display_name = category_display_name,
			icon = category_icon,
			reset_function = reset_function,
			validation_function = entry.validation_function,
			can_be_reset = can_be_reset
		}
		local latest_group_name = nil

		for _, setting in ipairs(settings) do
			latest_group_name = settings.group_name or latest_group_name
			all_settings[#all_settings + 1] = setting
			setting.category = category_display_name
			setting.group = latest_group_name
		end
	end

	return {
		settings = all_settings,
		categories = categories
	}
end

return generate_settings(category_settings)
