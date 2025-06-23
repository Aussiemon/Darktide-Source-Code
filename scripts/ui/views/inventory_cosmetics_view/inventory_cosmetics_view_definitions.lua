-- chunkname: @scripts/ui/views/inventory_cosmetics_view/inventory_cosmetics_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local Items = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local info_box_size = {
	1250,
	200
}
local equip_button_size = {
	374,
	76
}
local title_height = 70
local edge_padding = 50
local grid_width = 454
local grid_height = 860
local grid_size = {
	grid_width - edge_padding,
	grid_height
}
local grid_spacing = {
	10,
	10
}
local mask_size = {
	grid_width + 40,
	grid_height
}
local grid_settings = {
	scrollbar_width = 7,
	widget_icon_load_margin = 400,
	use_select_on_focused = true,
	use_is_focused_for_navigation = false,
	use_terminal_background = true,
	using_custom_gamepad_navigation = true,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	corner_top_left = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			180,
			310
		},
		position = {
			0,
			0,
			62
		}
	},
	corner_top_right = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			180,
			310
		},
		position = {
			0,
			0,
			62
		}
	},
	corner_bottom_left = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			180,
			120
		},
		position = {
			0,
			0,
			62
		}
	},
	corner_bottom_right = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			180,
			120
		},
		position = {
			0,
			0,
			62
		}
	},
	item_grid_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			100,
			100,
			1
		}
	},
	player_panel_pivot = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			100,
			-50,
			1
		}
	},
	item_name_pivot = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-70,
			-260,
			3
		}
	},
	info_box = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = info_box_size,
		position = {
			-70,
			-125,
			3
		}
	},
	equip_button = {
		vertical_alignment = "bottom",
		parent = "info_box",
		horizontal_alignment = "right",
		size = equip_button_size,
		position = {
			0,
			-8,
			1
		}
	},
	side_panel_area = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			550,
			0
		},
		position = {
			600,
			-260,
			3
		}
	}
}
local big_header_text_style = table.clone(UIFontSettings.header_3)

big_header_text_style.text_horizontal_alignment = "left"
big_header_text_style.text_vertical_alignment = "top"
big_header_text_style.text_color = Color.terminal_text_body_sub_header(255, true)

local big_body_text_style = table.clone(UIFontSettings.body_medium)

big_body_text_style.text_horizontal_alignment = "left"
big_body_text_style.text_vertical_alignment = "top"
big_body_text_style.text_color = Color.terminal_icon(255, true)

local small_header_text_style = table.clone(UIFontSettings.terminal_header_3)

small_header_text_style.text_horizontal_alignment = "left"
small_header_text_style.horizontal_alignment = "left"
small_header_text_style.text_vertical_alignment = "top"
small_header_text_style.vertical_alignment = "top"
small_header_text_style.offset = {
	0,
	0,
	1
}
small_header_text_style.font_size = 20
small_header_text_style.text_color = Color.terminal_text_body_sub_header(255, true)

local small_body_text_style = table.clone(small_header_text_style)

small_body_text_style.text_color = Color.terminal_text_body(255, true)

local unlock_icon_style = table.clone(big_body_text_style)

unlock_icon_style.offset = {
	-20,
	0,
	0
}

local big_details_text_style = table.clone(UIFontSettings.body_medium)

big_details_text_style.text_horizontal_alignment = "left"
big_details_text_style.text_vertical_alignment = "top"
big_details_text_style.text_color = {
	255,
	116,
	140,
	115
}

local input_legend_button_style = table.clone(UIFontSettings.body_small)

input_legend_button_style.text_horizontal_alignment = "left"
input_legend_button_style.text_vertical_alignment = "top"
input_legend_button_style.text_color = Color.ui_grey_light(255, true)
input_legend_button_style.default_text_color = Color.ui_grey_light(255, true)
input_legend_button_style.hover_color = Color.white(255, true)

local widget_definitions = {
	corner_top_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/metal_01_upper"
		}
	}, "corner_top_left"),
	corner_top_right = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/metal_01_upper",
			pass_type = "texture_uv",
			style = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				}
			}
		}
	}, "corner_top_right"),
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/screen/metal_01_lower"
		}
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/screen/metal_01_lower",
			pass_type = "texture_uv",
			style = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				}
			}
		}
	}, "corner_bottom_right"),
	equip_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "equip_button", {
		gamepad_action = "confirm_pressed",
		visible = false,
		original_text = Utf8.upper(Localize("loc_weapon_inventory_equip_button")),
		hotspot = {}
	})
}
local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	},
	{
		input_action = "hotkey_item_inspect",
		display_name = "loc_weapon_inventory_inspect_button",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_inspect_pressed",
		visibility_function = function (parent)
			local previewed_element = parent._previewed_element

			if previewed_element and previewed_element.premium_offer then
				return false
			end

			local previewed_item = parent._previewed_item

			if previewed_item then
				local item_type = previewed_item.item_type
				local ITEM_TYPES = UISettings.ITEM_TYPES

				if item_type == ITEM_TYPES.WEAPON_MELEE or item_type == ITEM_TYPES.WEAPON_RANGED or item_type == ITEM_TYPES.WEAPON_SKIN or item_type == ITEM_TYPES.END_OF_ROUND or item_type == ITEM_TYPES.GEAR_EXTRA_COSMETIC or item_type == ITEM_TYPES.GEAR_HEAD or item_type == ITEM_TYPES.GEAR_LOWERBODY or item_type == ITEM_TYPES.GEAR_UPPERBODY or item_type == ITEM_TYPES.COMPANION_GEAR_FULL or item_type == ITEM_TYPES.EMOTE or item_type == ITEM_TYPES.SET then
					return true
				end
			end

			return false
		end
	},
	{
		display_name = "loc_inventory_menu_zoom_in",
		input_action = "hotkey_menu_special_2",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_camera_zoom_toggled",
		visibility_function = function (parent, id)
			local display_name = parent._zoom_level >= 0.5 and "loc_inventory_menu_zoom_out" or "loc_inventory_menu_zoom_in"

			parent._input_legend_element:set_display_name(id, display_name)

			return parent._initialize_zoom
		end
	}
}
local small_header_text_pass = {
	{
		value_id = "text",
		style_id = "text",
		pass_type = "text",
		value = "",
		style = small_header_text_style
	}
}
local small_body_text_pass = {
	{
		value_id = "text",
		style_id = "text",
		pass_type = "text",
		value = "",
		style = small_body_text_style
	}
}
local big_header_text_pass = {
	{
		value_id = "text",
		style_id = "text",
		pass_type = "text",
		value = "",
		style = big_header_text_style
	}
}
local big_body_text_pass = {
	{
		value_id = "text",
		style_id = "text",
		pass_type = "text",
		value = "",
		style = big_body_text_style
	}
}
local big_details_text_pass = {
	{
		value_id = "text",
		style_id = "text",
		pass_type = "text",
		value = "",
		style = big_details_text_style
	}
}

return {
	grid_settings = grid_settings,
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	small_header_text_pass = small_header_text_pass,
	small_body_text_pass = small_body_text_pass,
	big_header_text_pass = big_header_text_pass,
	big_body_text_pass = big_body_text_pass,
	big_details_text_pass = big_details_text_pass
}
