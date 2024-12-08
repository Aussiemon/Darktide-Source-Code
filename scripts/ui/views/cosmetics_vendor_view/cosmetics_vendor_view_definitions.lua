-- chunkname: @scripts/ui/views/cosmetics_vendor_view/cosmetics_vendor_view_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local title_height = 70
local edge_padding = 44
local grid_width = 448
local grid_height = 780
local grid_size = {
	grid_width - edge_padding,
	grid_height,
}
local grid_spacing = {
	10,
	10,
}
local mask_size = {
	grid_width + 40,
	grid_height,
}
local grid_settings = {
	cache_loaded_icons = true,
	scrollbar_horizontal_offset = -7,
	scrollbar_vertical_margin = 91,
	scrollbar_vertical_offset = 48,
	scrollbar_width = 7,
	top_padding = 85,
	use_is_focused_for_navigation = false,
	use_select_on_focused = true,
	use_terminal_background = true,
	widget_icon_load_margin = 4000,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding,
}
local category_button_size = {
	100,
	100,
}
local wallet_text_font_style = table.clone(UIFontSettings.currency_title)

wallet_text_font_style.text_horizontal_alignment = "right"
wallet_text_font_style.text_vertical_alignment = "center"
wallet_text_font_style.original_offset = {
	0,
	0,
	1,
}

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
	item_grid_pivot = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			grid_width,
			grid_height,
		},
		position = {
			category_button_size[1] + 50 + 50,
			170,
			1,
		},
	},
	grid_tab_panel = {
		horizontal_alignment = "center",
		parent = "item_grid_pivot",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			-50,
			1,
		},
	},
	button_pivot = {
		horizontal_alignment = "left",
		parent = "item_grid_pivot",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-120,
			40,
			3,
		},
	},
	button_pivot_background = {
		horizontal_alignment = "left",
		parent = "button_pivot",
		vertical_alignment = "top",
		size = {
			120,
			520,
		},
		position = {
			-20,
			-20,
			3,
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
			-1140,
			40,
			3,
		},
	},
	weapon_compare_stats_pivot = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-1140 + (grid_size[1] - 50),
			40,
			3,
		},
	},
	item_name_pivot = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			0,
			0,
		},
		position = {
			-80,
			-220,
			3,
		},
	},
	purchase_button = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			374,
			76,
		},
		position = {
			-80,
			-90,
			1,
		},
	},
	item_restrictions_background = {
		horizontal_alignment = "right",
		parent = "item_grid_pivot",
		vertical_alignment = "bottom",
		size = {
			350,
			0,
		},
		position = {
			400,
			-90,
			1,
		},
	},
	item_restrictions = {
		horizontal_alignment = "left",
		parent = "item_restrictions_background",
		vertical_alignment = "center",
		size = {
			500,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
	side_panel_area = {
		horizontal_alignment = "right",
		parent = "item_grid_pivot",
		vertical_alignment = "bottom",
		size = {
			350,
			0,
		},
		position = {
			400,
			-90,
			1,
		},
	},
	set_item_parts_representation = {
		horizontal_alignment = "left",
		parent = "item_restrictions",
		vertical_alignment = "bottom",
		size = {
			50,
			50,
		},
		position = {
			0,
			80,
			1,
		},
	},
	title_text = {
		horizontal_alignment = "left",
		parent = "item_grid_pivot",
		vertical_alignment = "top",
		size = {
			grid_size[1] + edge_padding,
			90,
		},
		position = {
			0,
			8,
			15,
		},
	},
	divider = {
		horizontal_alignment = "left",
		parent = "title_text",
		vertical_alignment = "bottom",
		size = {
			grid_size[1] + edge_padding,
			50,
		},
		position = {
			0,
			17,
			1,
		},
	},
	info_text = {
		horizontal_alignment = "right",
		parent = "purchase_button",
		vertical_alignment = "center",
		size = {
			grid_width,
			50,
		},
		position = {
			-70,
			0,
			0,
		},
	},
	wallet_pivot = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-20,
			50,
			60,
		},
	},
	corner_top_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			540,
			224,
		},
		position = {
			0,
			-65,
			55,
		},
	},
}
local item_restrictions_title_style = {
	drop_shadow = true,
	font_size = 18,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "top",
	vertical_alignment = "top",
	text_color = Color.terminal_text_body_sub_header(255, true),
	offset = {
		0,
		0,
		1,
	},
}
local owned_item_text_style = table.clone(UIFontSettings.body)

owned_item_text_style.text_horizontal_alignment = "right"
owned_item_text_style.text_vertical_alignment = "center"
owned_item_text_style.horizontal_alignment = "center"
owned_item_text_style.vertical_alignment = "center"
owned_item_text_style.offset = {
	0,
	0,
	2,
}
owned_item_text_style.text_color = Color.terminal_text_header(255, true)

local item_restrictions_body_style = {
	drop_shadow = true,
	font_size = 20,
	font_type = "proxima_nova_bold",
	horizontal_alignment = "left",
	text_horizontal_alignment = "left",
	text_vertical_alignment = "top",
	vertical_alignment = "top",
	text_color = Color.terminal_text_body(255, true),
	offset = {
		0,
		0,
		1,
	},
}
local widget_definitions = {
	corner_top_right = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "texture",
			value = "content/ui/materials/frames/screen/cosmetic_upper_right",
			style = {
				offset = {
					0,
					-1,
					1,
				},
			},
		},
	}, "corner_top_right"),
	button_pivot_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.terminal_grid_background(255, true),
				size_addition = {
					30,
					20,
				},
				offset = {
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/tab_frame_upper",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				color = Color.white(255, true),
				size = {
					136,
					14,
				},
				offset = {
					0,
					-5,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/tab_frame_lower",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				color = Color.white(255, true),
				size = {
					135,
					14,
				},
				offset = {
					0,
					5,
					1,
				},
			},
		},
	}, "button_pivot_background"),
	title_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = {
				font_size = 28,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					0,
					1,
				},
				size = {
					grid_size[1],
					10,
				},
			},
		},
	}, "title_text"),
	divider = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_center_02",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_text_body_dark(255, true),
				size = {
					468,
					22,
				},
			},
		},
	}, "divider"),
	owned_info_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = owned_item_text_style,
			value = string.format("%s ", Localize("loc_premium_store_owned_note")),
		},
	}, "info_text", {
		visible = false,
	}),
	no_class_info_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = owned_item_text_style,
			value = Localize("loc_cosmetic_vendor_no_operative_of_class"),
		},
	}, "info_text", {
		visible = false,
	}),
}
local wallet_definitions = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "texture",
		value = "content/ui/materials/icons/currencies/marks_small",
		value_id = "texture",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			size = {
				42,
				30,
			},
			offset = {
				0,
				0,
				1,
			},
			original_offset = {
				0,
				0,
				1,
			},
		},
	},
	{
		pass_type = "text",
		style_id = "text",
		value = "0",
		value_id = "text",
		style = wallet_text_font_style,
	},
}, "wallet_pivot")
local animations = {
	on_enter = {
		{
			end_time = 0.6,
			name = "fade_in",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				parent.animated_alpha_multiplier = 0
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				return
			end,
		},
		{
			end_time = 0.8,
			name = "move",
			start_time = 0.35,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeOutCubic(progress)

				parent.animated_alpha_multiplier = anim_progress

				local x_anim_distance_max = 50
				local x_anim_distance = x_anim_distance_max - x_anim_distance_max * anim_progress

				parent:_set_scenegraph_position("button_pivot", scenegraph_definition.button_pivot.position[1] - x_anim_distance)
				parent:_set_scenegraph_position("item_grid_pivot", scenegraph_definition.item_grid_pivot.position[1] - x_anim_distance)
				parent:_force_update_scenegraph()
			end,
		},
		{
			end_time = 0.8,
			name = "done",
			start_time = 0.8,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				parent.enter_animation_done = true
			end,
		},
	},
}
local item_sub_title_pass = {
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = item_restrictions_title_style,
	},
}
local item_text_pass = {
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = item_restrictions_body_style,
	},
}

return {
	grid_settings = grid_settings,
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	wallet_definitions = wallet_definitions,
	item_sub_title_pass = item_sub_title_pass,
	item_text_pass = item_text_pass,
}
