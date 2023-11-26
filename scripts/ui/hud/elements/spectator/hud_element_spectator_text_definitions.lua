-- chunkname: @scripts/ui/hud/elements/spectator/hud_element_spectator_text_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local background_size = {
	700,
	40
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	bounding_box = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = background_size,
		position = {
			0,
			-100,
			0
		}
	},
	rescued_text = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = background_size,
		position = {
			0,
			50,
			1
		}
	},
	spectating_text = {
		vertical_alignment = "top",
		parent = "bounding_box",
		horizontal_alignment = "center",
		size = background_size,
		position = {
			0,
			0,
			1
		}
	},
	cycle_text = {
		vertical_alignment = "top",
		parent = "spectating_text",
		horizontal_alignment = "center",
		size = background_size,
		position = {
			0,
			30,
			0
		}
	}
}
local rescued_style = table.clone(UIFontSettings.body)

rescued_style.text_horizontal_alignment = "center"
rescued_style.text_vertical_alignment = "top"
rescued_style.text_color = Color.terminal_text_body(255, true)
rescued_style.offset = {
	0,
	0,
	3
}
rescued_style.text_horizontal_alignment = "center"
rescued_style.text_vertical_alignment = "center"

local spectating_style = table.clone(UIFontSettings.body)

spectating_style.text_horizontal_alignment = "center"
spectating_style.text_vertical_alignment = "top"
spectating_style.text_color = Color.terminal_text_body(255, true)

local cycle_style = table.clone(UIFontSettings.body)

cycle_style.text_horizontal_alignment = "center"
cycle_style.text_vertical_alignment = "top"
cycle_style.text_color = Color.terminal_text_body_sub_header(255, true)

local widget_definitions = {
	rescued_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = Utf8.upper(Localize("loc_spectator_mode_waiting_to_be_rescued")),
			style = rescued_style
		},
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					0
				},
				color = Color.terminal_background(nil, true),
				size_addition = {
					-4,
					0
				},
				offset = {
					0,
					0,
					-2
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/headline_terminal",
			style_id = "background_overlay",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					0
				},
				size_addition = {
					-8,
					0
				},
				color = Color.terminal_grid_background_gradient(nil, true),
				offset = {
					0,
					0,
					-1
				}
			}
		},
		{
			value = "content/ui/materials/frames/frame_glow_01",
			style_id = "background_frame",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size = {
					0
				},
				size_addition = {
					15,
					19
				},
				color = Color.terminal_frame(nil, true),
				offset = {
					0,
					0,
					0
				}
			}
		}
	}, "rescued_text"),
	spectating_text = UIWidget.create_definition({
		{
			value = "n/a",
			value_id = "text",
			pass_type = "text",
			style = spectating_style
		}
	}, "spectating_text"),
	cycle_text = UIWidget.create_definition({
		{
			value = "n/a",
			value_id = "text",
			pass_type = "text",
			style = cycle_style
		}
	}, "cycle_text")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
