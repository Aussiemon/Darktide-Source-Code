-- chunkname: @scripts/ui/views/options_view/options_view_definitions.lua

local OptionsViewSettings = require("scripts/ui/views/options_view/options_view_settings")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scrollbar_width = OptionsViewSettings.scrollbar_width
local grid_size = OptionsViewSettings.grid_size
local grid_width = grid_size[1]
local grid_height = grid_size[2]
local grid_blur_edge_size = OptionsViewSettings.grid_blur_edge_size
local mask_size = {
	grid_width + grid_blur_edge_size[1] * 2,
	grid_height + grid_blur_edge_size[2] * 2,
}
local mask_offset_y = 16
local settings_mask_size = {
	1080 + grid_blur_edge_size[1] * 2,
	grid_height + grid_blur_edge_size[2],
}
local settings_grid_height = grid_height + mask_offset_y
local tooltip_text_style = table.clone(UIFontSettings.body)

tooltip_text_style.text_horizontal_alignment = "left"
tooltip_text_style.text_vertical_alignment = "center"
tooltip_text_style.horizontal_alignment = "left"
tooltip_text_style.vertical_alignment = "center"
tooltip_text_style.color = Color.white(255, true)
tooltip_text_style.offset = {
	0,
	0,
	2,
}

local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	tooltip = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			200,
		},
	},
	background = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			grid_width,
			grid_height,
		},
		position = {
			180,
			240,
			1,
		},
	},
	background_icon = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1250,
			1250,
		},
		position = {
			0,
			0,
			0,
		},
	},
	grid_start = {
		horizontal_alignment = "left",
		parent = "background",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
	grid_content_pivot = {
		horizontal_alignment = "left",
		parent = "grid_start",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
	grid_mask = {
		horizontal_alignment = "center",
		parent = "background",
		vertical_alignment = "center",
		size = mask_size,
		position = {
			0,
			0,
			0,
		},
	},
	grid_interaction = {
		horizontal_alignment = "left",
		parent = "background",
		vertical_alignment = "top",
		size = {
			grid_width + scrollbar_width * 2,
			mask_size[2],
		},
		position = {
			0,
			0,
			0,
		},
	},
	scrollbar = {
		horizontal_alignment = "right",
		parent = "background",
		vertical_alignment = "center",
		size = {
			scrollbar_width,
			grid_height,
		},
		position = {
			50,
			0,
			1,
		},
	},
	button = {
		horizontal_alignment = "top",
		parent = "grid_content_pivot",
		vertical_alignment = "left",
		size = {
			500,
			64,
		},
		position = {
			0,
			0,
			0,
		},
	},
	title_divider = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			335,
			18,
		},
		position = {
			180,
			145,
			1,
		},
	},
	title_text = {
		horizontal_alignment = "left",
		parent = "title_divider",
		vertical_alignment = "bottom",
		size = {
			500,
			50,
		},
		position = {
			0,
			-35,
			1,
		},
	},
	settings_grid_background = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			1000,
			settings_grid_height,
		},
		position = {
			-180,
			130,
			1,
		},
	},
	settings_grid_start = {
		horizontal_alignment = "left",
		parent = "settings_grid_background",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
	settings_grid_content_pivot = {
		horizontal_alignment = "left",
		parent = "settings_grid_start",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
	settings_scrollbar = {
		horizontal_alignment = "right",
		parent = "settings_grid_background",
		vertical_alignment = "top",
		size = {
			scrollbar_width,
			grid_height - 26,
		},
		position = {
			50,
			45,
			1,
		},
	},
	settings_grid_mask = {
		horizontal_alignment = "center",
		parent = "settings_grid_background",
		vertical_alignment = "top",
		size = settings_mask_size,
		position = {
			0,
			mask_offset_y,
			0,
		},
	},
	settings_grid_interaction = {
		horizontal_alignment = "left",
		parent = "settings_grid_background",
		vertical_alignment = "top",
		size = {
			1000 + scrollbar_width * 2,
			mask_size[2],
		},
		position = {
			0,
			0,
			0,
		},
	},
}
local widget_definitions = {
	settings_overlay = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					20,
				},
				color = {
					160,
					0,
					0,
					0,
				},
			},
		},
	}, "screen"),
	background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.black(255, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignemt = "center",
				scale_to_material = true,
				vertical_alignemnt = "center",
				size_addition = {
					40,
					40,
				},
				offset = {
					-20,
					-20,
					0,
				},
				color = Color.terminal_grid_background_gradient(204, true),
			},
		},
	}, "screen"),
	title_divider = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_rendered_left_01",
		},
	}, "title_divider"),
	title_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			value = Managers.localization:localize("loc_settings_menu_header"),
			style = table.clone(UIFontSettings.header_1),
		},
	}, "title_text"),
	background_icon = UIWidget.create_definition({
		{
			pass_type = "slug_icon",
			value = "content/ui/vector_textures/symbols/cog_skull_01",
			style = {
				offset = {
					0,
					0,
					0,
				},
				color = {
					80,
					0,
					0,
					0,
				},
			},
		},
	}, "background_icon"),
	tooltip = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					0,
				},
				color = Color.terminal_corner(255, true),
				size_addition = {
					23,
					23,
				},
			},
		},
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					1,
				},
				color = Color.black(255, true),
				size_addition = {
					20,
					20,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = tooltip_text_style,
		},
	}, "tooltip", {
		visible = false,
	}),
	scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "scrollbar", {
		scroll_speed = 10,
	}),
	grid_mask = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_vertical_blur",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
	}, "grid_mask"),
	grid_interaction = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
		},
	}, "grid_interaction"),
	settings_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "settings_scrollbar", {
		scroll_speed = 10,
	}),
	settings_grid_mask = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_vertical_blur",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
	}, "settings_grid_mask"),
	settings_grid_interaction = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
		},
	}, "settings_grid_interaction"),
}
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_settings_menu_close_menu",
		input_action = "back",
		on_pressed_callback = "cb_on_back_pressed",
		visibility_function = nil,
	},
	{
		alignment = nil,
		display_name = "loc_settings_menu_reset_to_default",
		input_action = "hotkey_menu_special_2",
		on_pressed_callback = "cb_reset_category_to_default",
		visibility_function = function (parent)
			return not not parent._selected_category and parent._categories_by_display_name[parent._selected_category].can_be_reset
		end,
	},
}
local OptionsViewDefinitions = {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}

return settings("OptionsViewDefinitions", OptionsViewDefinitions)
