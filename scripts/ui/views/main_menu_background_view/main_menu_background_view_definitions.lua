-- chunkname: @scripts/ui/views/main_menu_background_view/main_menu_background_view_definitions.lua

local DefaultPassTemplates = require("scripts/ui/pass_templates/default_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	}
}
local widget_definitions = {}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
