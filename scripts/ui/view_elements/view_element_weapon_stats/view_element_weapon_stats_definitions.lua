local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local rating_text_style = table.clone(UIFontSettings.body_small)
rating_text_style.text_horizontal_alignment = "right"
rating_text_style.text_vertical_alignment = "center"
rating_text_style.text_color = Color.white(255, true)
rating_text_style.font_size = 30
rating_text_style.offset = {
	-10,
	0,
	300
}
rating_text_style.material = "content/ui/materials/font_gradients/slug_font_gradient_item_level"
local rating_header_text_style = table.clone(UIFontSettings.body_small)
rating_header_text_style.text_horizontal_alignment = "right"
rating_header_text_style.text_vertical_alignment = "center"
rating_header_text_style.text_color = Color.terminal_text_body(255, true)
rating_header_text_style.font_size = 17
rating_header_text_style.size = {
	nil,
	18
}
rating_header_text_style.offset = {
	-112,
	3,
	300
}
local basic_text_style = table.clone(UIFontSettings.body_small)
basic_text_style.text_horizontal_alignment = "left"
basic_text_style.text_vertical_alignment = "center"
basic_text_style.text_color = Color.terminal_text_body(255, true)
basic_text_style.font_size = 17
basic_text_style.size = {
	nil,
	18
}
basic_text_style.offset = {
	55,
	3,
	300
}
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
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					-1
				},
				size_addition = {
					-8,
					0
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					18,
					16
				},
				color = Color.terminal_grid_background(255, true)
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
