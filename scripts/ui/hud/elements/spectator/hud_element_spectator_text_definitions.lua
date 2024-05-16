-- chunkname: @scripts/ui/hud/elements/spectator/hud_element_spectator_text_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local background_size = {
	700,
	40,
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	bounding_box = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "bottom",
		size = background_size,
		position = {
			0,
			-100,
			0,
		},
	},
	rescued_text = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "top",
		size = background_size,
		position = {
			0,
			15,
			1,
		},
	},
	spectating_text = {
		horizontal_alignment = "center",
		parent = "bounding_box",
		vertical_alignment = "top",
		size = background_size,
		position = {
			0,
			0,
			1,
		},
	},
	cycle_text = {
		horizontal_alignment = "center",
		parent = "spectating_text",
		vertical_alignment = "top",
		size = background_size,
		position = {
			0,
			30,
			0,
		},
	},
}
local rescued_style = table.clone(UIFontSettings.body)

rescued_style.text_horizontal_alignment = "center"
rescued_style.text_vertical_alignment = "top"
rescued_style.text_color = Color.terminal_text_body(255, true)
rescued_style.offset = {
	0,
	0,
	3,
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
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			value = Utf8.upper(Localize("loc_spectator_mode_waiting_to_be_rescued")),
			style = rescued_style,
		},
		{
			pass_type = "rect",
			style_id = "background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					0,
				},
				color = Color.terminal_background(nil, true),
				size_addition = {
					-4,
					0,
				},
				offset = {
					0,
					0,
					-2,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "background_overlay",
			value = "content/ui/materials/backgrounds/headline_terminal",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					0,
				},
				size_addition = {
					-8,
					0,
				},
				color = Color.terminal_grid_background_gradient(nil, true),
				offset = {
					0,
					0,
					-1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "background_frame",
			value = "content/ui/materials/frames/frame_glow_01",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size = {
					0,
				},
				size_addition = {
					15,
					19,
				},
				color = Color.terminal_frame(nil, true),
				offset = {
					0,
					0,
					0,
				},
			},
		},
	}, "rescued_text"),
	spectating_text = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "n/a",
			value_id = "text",
			style = spectating_style,
		},
	}, "spectating_text"),
	cycle_text = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "n/a",
			value_id = "text",
			style = cycle_style,
		},
	}, "cycle_text"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
