-- chunkname: @scripts/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local InventoryWeaponCosmeticsViewSettings = require("scripts/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view_settings")
local ItemUtils = require("scripts/utilities/items")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local info_box_size = {
	1150,
	200,
}
local equip_button_size = {
	374,
	76,
}
local title_height = 70
local edge_padding = 44
local grid_width = 440
local grid_height = 860
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
	scrollbar_horizontal_offset = -7,
	scrollbar_vertical_margin = 91,
	scrollbar_vertical_offset = 48,
	scrollbar_width = 7,
	use_is_focused_for_navigation = false,
	use_select_on_focused = true,
	use_terminal_background = true,
	widget_icon_load_margin = 400,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding,
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
			200,
			100,
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
			240,
		},
		position = {
			-20,
			-20,
			3,
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
			-48,
			1,
		},
	},
	weapon_preview = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			800,
			800,
		},
		position = {
			0,
			0,
			1,
		},
	},
	description_text = {
		horizontal_alignment = "center",
		parent = "display_name_divider",
		vertical_alignment = "bottom",
		size = {
			1000,
			150,
		},
		position = {
			0,
			120,
			3,
		},
	},
	info_box = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = info_box_size,
		position = {
			-100,
			-125,
			3,
		},
	},
	display_name_divider = {
		horizontal_alignment = "left",
		parent = "info_box",
		vertical_alignment = "bottom",
		size = {
			info_box_size[1] - (equip_button_size[1] + 30),
			20,
		},
		position = {
			0,
			0,
			1,
		},
	},
	display_name_divider_glow = {
		horizontal_alignment = "left",
		parent = "info_box",
		vertical_alignment = "bottom",
		size = {
			info_box_size[1] - (equip_button_size[1] + 30),
			80,
		},
		position = {
			0,
			-6,
			1,
		},
	},
	display_name = {
		horizontal_alignment = "left",
		parent = "info_box",
		vertical_alignment = "bottom",
		size = {
			info_box_size[1] - (equip_button_size[1] + 30 + 20),
			50,
		},
		position = {
			10,
			-40,
			3,
		},
	},
	sub_display_name = {
		horizontal_alignment = "center",
		parent = "display_name",
		vertical_alignment = "top",
		size = {
			info_box_size[1] - (equip_button_size[1] + 30 + 20),
			50,
		},
		position = {
			0,
			45,
			3,
		},
	},
	equip_button = {
		horizontal_alignment = "right",
		parent = "info_box",
		vertical_alignment = "bottom",
		size = equip_button_size,
		position = {
			0,
			-8,
			1,
		},
	},
}
local display_name_style = table.clone(UIFontSettings.header_2)

display_name_style.text_horizontal_alignment = "left"
display_name_style.text_vertical_alignment = "bottom"

local title_text_style = table.clone(UIFontSettings.header_2)

title_text_style.text_horizontal_alignment = "center"
title_text_style.text_vertical_alignment = "bottom"

local sub_display_name_style = table.clone(UIFontSettings.header_3)

sub_display_name_style.text_horizontal_alignment = "left"
sub_display_name_style.text_vertical_alignment = "top"
sub_display_name_style.text_color = Color.ui_grey_light(255, true)

local description_text_style = table.clone(UIFontSettings.body_small)

description_text_style.text_horizontal_alignment = "left"
description_text_style.text_vertical_alignment = "top"

local widget_definitions = {
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/metal_01_lower",
		},
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/screen/metal_01_lower",
			style = {
				uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				},
			},
		},
	}, "corner_bottom_right"),
	description_text = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "",
			value_id = "text",
			style = description_text_style,
		},
	}, "description_text"),
	display_name_divider = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_dynamic_lower",
		},
	}, "display_name_divider"),
	display_name_divider_glow = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/effects/wide_upward_glow",
		},
	}, "display_name_divider_glow"),
	sub_display_name = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "",
			value_id = "text",
			style = sub_display_name_style,
		},
	}, "sub_display_name"),
	display_name = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "",
			value_id = "text",
			style = display_name_style,
		},
	}, "display_name"),
	equip_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.default_button), "equip_button", {
		gamepad_action = "confirm_pressed",
		original_text = Utf8.upper(Localize("loc_weapon_inventory_equip_button")),
		hotspot = {
			on_pressed_sound = UISoundEvents.weapons_skin_confirm,
		},
	}),
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
}
local background_widget = UIWidget.create_definition({
	{
		pass_type = "rect",
		style = {
			color = {
				255,
				13,
				26,
				30,
			},
		},
	},
}, "screen")
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_settings_menu_close_menu",
		input_action = "back",
		on_pressed_callback = "_cb_on_close_pressed",
	},
}
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
local always_visible_widget_names = {
	corner_bottom_left = true,
	corner_bottom_right = true,
	corner_top_left = true,
	corner_top_right = true,
}

return {
	grid_settings = grid_settings,
	legend_inputs = legend_inputs,
	background_widget = background_widget,
	always_visible_widget_names = always_visible_widget_names,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	animations = animations,
}
