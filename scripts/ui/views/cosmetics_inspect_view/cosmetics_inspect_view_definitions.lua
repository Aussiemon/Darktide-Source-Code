-- chunkname: @scripts/ui/views/cosmetics_inspect_view/cosmetics_inspect_view_definitions.lua

local CosmeticsInspectViewSettings = require("scripts/ui/views/cosmetics_inspect_view/cosmetics_inspect_view_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ItemUtils = require("scripts/utilities/items")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local grid_height = CosmeticsInspectViewSettings.grid_height
local grid_margin = 30
local item_grid_width = 542
local grid_width = item_grid_width + grid_margin * 2
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
	corner_top_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			180,
			310,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_top_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			180,
			310,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_bottom_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			180,
			120,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_bottom_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			180,
			120,
		},
		position = {
			0,
			0,
			62,
		},
	},
	item_grid_pivot = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			100,
			100,
			1,
		},
	},
	player_panel_pivot = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			100,
			-50,
			1,
		},
	},
	weapon_stats_pivot = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-1340,
			110,
			3,
		},
	},
	left_side = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			grid_width,
			grid_height,
		},
		position = {
			100,
			130,
			1,
		},
	},
	title = {
		horizontal_alignment = "left",
		parent = "left_side",
		vertical_alignment = "top",
		size = {
			grid_width - 40,
			70,
		},
		position = {
			20,
			50,
			1,
		},
	},
	description_grid = {
		horizontal_alignment = "center",
		parent = "left_side",
		vertical_alignment = "top",
		size = {
			grid_width - grid_margin * 2,
			grid_height - 80,
		},
		position = {
			0,
			40,
			1,
		},
	},
	description_content_pivot = {
		horizontal_alignment = "left",
		parent = "description_grid",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			2,
		},
	},
	description_mask = {
		horizontal_alignment = "center",
		parent = "description_grid",
		vertical_alignment = "center",
		size = {
			grid_width,
			grid_height - 40,
		},
		position = {
			0,
			0,
			2,
		},
	},
	description_scrollbar = {
		horizontal_alignment = "right",
		parent = "description_grid",
		vertical_alignment = "top",
		size = {
			10,
			grid_height - 80,
		},
		position = {
			30,
			-20,
			2,
		},
	},
}
local sub_title_style = table.clone(UIFontSettings.terminal_header_3)

sub_title_style.text_horizontal_alignment = "left"
sub_title_style.horizontal_alignment = "left"
sub_title_style.text_vertical_alignment = "top"
sub_title_style.vertical_alignment = "top"
sub_title_style.offset = {
	0,
	0,
	1,
}
sub_title_style.font_size = 20
sub_title_style.text_color = Color.terminal_text_body_sub_header(255, true)

local item_text_style = table.clone(sub_title_style)

item_text_style.text_color = Color.terminal_text_body(255, true)

local title_style = table.clone(UIFontSettings.header_1)

title_style.font_size = 40
title_style.offset = {
	0,
	0,
	1,
}
title_style.text_horizontal_alignment = "center"
title_style.text_vertical_alignment = "top"

local header_sub_title_text_style = table.clone(UIFontSettings.header_5)

header_sub_title_text_style.text_horizontal_alignment = "center"
header_sub_title_text_style.text_vertical_alignment = "top"
header_sub_title_text_style.offset = {
	0,
	0,
	0,
}
header_sub_title_text_style.text_color = Color.terminal_text_body(255, true)

local description_text_font_style = table.clone(UIFontSettings.terminal_header_3)

description_text_font_style.text_horizontal_alignment = "left"
description_text_font_style.text_vertical_alignment = "top"
description_text_font_style.font_size = 20
description_text_font_style.text_color = Color.terminal_text_body(255, true)

local widget_definitions = {
	bundle_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "bundle",
			value = "content/ui/materials/backgrounds/bundle_store_preview",
			value_id = "bundle",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					0,
				},
				size = {
					1200,
					1080,
				},
				size_addition = {
					0,
					0,
				},
				material_values = {
					gradient_map = "content/ui/textures/masks/blur_straight",
					texture_map = nil,
				},
			},
			visibility_function = function (content, style)
				return style.material_values.texture_map
			end,
		},
	}, "canvas"),
	title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = title_style,
		},
		{
			pass_type = "text",
			style_id = "sub_text",
			value = "",
			value_id = "sub_text",
			style = header_sub_title_text_style,
		},
		{
			pass_type = "texture",
			style_id = "divider",
			value = "content/ui/materials/dividers/skull_center_02",
			value_id = "divider",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					400,
					18,
				},
				offset = {
					0,
					9,
					1,
				},
				color = Color.terminal_frame(255, true),
			},
		},
	}, "title"),
	description_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "description_scrollbar", {
		enable_gamepad_scrolling = true,
		focused = true,
		gamepad_axis_name = "navigate_controller",
		hotspot = {
			is_focused = true,
		},
	}),
	description_mask = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur_viewport_2",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
				offset = {
					0,
					0,
					3,
				},
			},
		},
	}, "description_mask"),
}
local text_description_pass_template = {
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = description_text_font_style,
	},
}
local item_sub_title_pass = {
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = sub_title_style,
	},
}
local item_text_pass = {
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = item_text_style,
	},
}
local menu_preview_with_gear_off = "loc_inventory_menu_preview_with_gear_off"
local menu_preview_with_gear_on = "loc_inventory_menu_preview_with_gear_on"
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_settings_menu_close_menu",
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
		visibility_function = nil,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_inventory_menu_zoom_in",
		input_action = "hotkey_menu_special_2",
		on_pressed_callback = "cb_on_camera_zoom_toggled",
		visibility_function = function (parent, id)
			local display_name = parent._zoom_level >= 0.5 and "loc_inventory_menu_zoom_out" or "loc_inventory_menu_zoom_in"

			parent._input_legend_element:set_display_name(id, display_name)

			return not parent._disable_zoom
		end,
	},
	{
		alignment = "right_alignment",
		input_action = "hotkey_menu_special_1",
		on_pressed_callback = "cb_on_preview_with_gear_toggled",
		display_name = menu_preview_with_gear_off,
		visibility_function = function (parent, id)
			local display_name = parent._previewed_with_gear and menu_preview_with_gear_off or menu_preview_with_gear_on

			parent._input_legend_element:set_display_name(id, display_name)

			return parent:_can_preview()
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_inventory_menu_swap_weapon",
		input_action = "hotkey_menu_special_1",
		on_pressed_callback = "cb_on_weapon_swap_pressed",
		store_appearance_option = true,
		visibility_function = function (parent)
			return parent:_can_swap_weapon()
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_preview_voice",
		input_action = "hotkey_item_inspect",
		on_pressed_callback = "cb_preview_voice",
		visibility_function = function (parent, id)
			return parent:_can_preview_voice()
		end,
	},
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	text_description_pass_template = text_description_pass_template,
	item_sub_title_pass = item_sub_title_pass,
	item_text_pass = item_text_pass,
}
