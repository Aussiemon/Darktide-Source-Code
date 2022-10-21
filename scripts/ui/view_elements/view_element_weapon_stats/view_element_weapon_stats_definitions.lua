local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	pivot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	}
}
local widget_definitions = {
	grid_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				size_addition = {
					18,
					16
				}
			}
		}
	}, "grid_background"),
	grid_divider_top = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/frames/item_info_upper",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top"
			}
		}
	}, "grid_divider_top"),
	grid_divider_bottom = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/frames/item_info_lower",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center"
			}
		}
	}, "grid_divider_bottom")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
