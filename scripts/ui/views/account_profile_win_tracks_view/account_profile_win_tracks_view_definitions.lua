local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementMenuPanel = require("scripts/ui/view_elements/view_element_menu_panel/view_element_menu_panel")
local screen_size = UIWorkspaceSettings.screen.size
local top_panel_size = UIWorkspaceSettings.top_panel.size
local bottom_panel_size = UIWorkspaceSettings.bottom_panel.size
local visible_area_size = {
	screen_size[1],
	screen_size[2] - (top_panel_size[2] + bottom_panel_size[2])
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	visible_area = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = visible_area_size,
		position = {
			0,
			top_panel_size[2],
			1
		}
	}
}
local widget_definitions = {
	placeholder = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/placeholders/account_profile/wintracks_full_view_placeholder"
		}
	}, "visible_area")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
