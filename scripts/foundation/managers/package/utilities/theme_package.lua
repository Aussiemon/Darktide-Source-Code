-- chunkname: @scripts/foundation/managers/package/utilities/theme_package.lua

local ThemePackage = {}

local function _get_theme_packages(level_name, theme_tag)
	local file_path = level_name .. "_mission_themes"

	if theme_tag and Application.can_get_resource("lua", file_path) then
		local file_data = require(file_path)
		local theme_packages = file_data[theme_tag]

		if not theme_packages then
			Log.error("ThemePackage", "No theme package configuration in file: %q, level: %q, theme_tag: %q", file_path, level_name, theme_tag)
		end

		return theme_packages
	else
		Log.error("ThemePackage", "Cannot load theme package configuration file: %q, level: %q, theme_tag: %q", file_path, level_name, theme_tag)
	end
end

ThemePackage.level_resource_dependency_packages = function (level_name, theme_tag)
	local theme_packages = _get_theme_packages(level_name, theme_tag)

	if not theme_packages and theme_tag ~= "default" then
		Log.error("ThemePackage", "Falling back to theme_tag default")

		theme_packages = _get_theme_packages(level_name, "default")
	end

	return theme_packages or {}
end

return ThemePackage
