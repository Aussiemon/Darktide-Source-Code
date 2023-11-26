-- chunkname: @scripts/managers/ui/ui_font_manager.lua

local FontDefinitions = require("scripts/managers/ui/ui_fonts_definitions")
local UIFontManager = class("UIFontManager")

UIFontManager.DEBUG_TAG = "UI View Manager"

local function _add_base_path(paths, base_path)
	for i = 1, #paths do
		paths[i] = base_path .. paths[i]
	end
end

local function _add_definition(definitions, font_name, paths, render_flags)
	local definition = definitions[font_name]

	if not definition then
		definition = {}
		definitions[font_name] = definition
	end

	definition.path = paths
	definition.render_flags = render_flags
end

UIFontManager.init = function (self)
	self._locale_specific_font_package = nil
	self._font_definitions = {}
	self._packages_to_unload = {}

	local current_locale = Managers.localization and Managers.localization:language()
	local locale_specific_font = current_locale and FontDefinitions.locale_specific_fonts[current_locale]

	if locale_specific_font and locale_specific_font.package then
		self:_setup_font_definitions()
	end

	self:set_locale(current_locale)
end

UIFontManager.data_by_type = function (self, font_type)
	return self._font_definitions[font_type]
end

UIFontManager.set_locale = function (self, locale)
	if self._locale_specific_font_package then
		self:_setup_font_definitions()

		local package_manager = Managers.package

		self._packages_to_unload[#self._packages_to_unload + 1] = self._locale_specific_font_package
		self._locale_specific_font_package = nil
	end

	local locale_fonts = locale and FontDefinitions.locale_specific_fonts[locale]

	if locale_fonts and locale_fonts.package then
		local package_manager = Managers.package

		self._locale_specific_font_package = package_manager:load(locale_fonts.package, "UIFontManager", callback(self, "_setup_font_definitions", locale_fonts))
	else
		self:_setup_font_definitions(locale_fonts)
	end
end

UIFontManager.unload_old_font_packages = function (self)
	for i = 1, #self._packages_to_unload() do
		local package_manager = Managers.package

		package_manager:release(self._locale_specific_font_package)
	end
end

UIFontManager._setup_font_definitions = function (self, locale_fonts)
	local definitions = self._font_definitions

	for font_name, font_kind in pairs(FontDefinitions.fonts) do
		local paths = definitions[font_name] and definitions[font_name].path or {}

		table.clear(paths)

		paths[#paths + 1] = font_name

		if locale_fonts and locale_fonts[font_name] then
			paths[#paths + 1] = locale_fonts[font_name]
		elseif locale_fonts then
			local font_fallback = locale_fonts[font_kind]

			if type(font_fallback) == "table" then
				for i = 1, #font_fallback do
					paths[#paths + 1] = font_fallback[i]
				end
			else
				paths[#paths + 1] = font_fallback
			end
		end

		paths[#paths + 1] = FontDefinitions.custom_font

		_add_base_path(paths, FontDefinitions.base_path)
		_add_definition(definitions, font_name, paths, Gui.MultiLine + Gui.FormatDirectives)
		_add_definition(definitions, font_name .. "_no_render_flags", paths)
		_add_definition(definitions, font_name .. "_masked", paths, Gui.MultiLine + Gui.Masked + Gui.FormatDirectives)
		_add_definition(definitions, font_name .. "_write_mask", paths, Gui.MultiLine + Gui.WriteMask + Gui.FormatDirectives)
	end

	self._font_definitions = definitions
end

return UIFontManager
