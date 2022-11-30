local InventoryWeaponsViewSettings = require("scripts/ui/views/inventory_weapons_view/inventory_weapons_view_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISettings = require("scripts/settings/ui/ui_settings")
local title_height = 108
local edge_padding = 44
local grid_width = 640
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
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	corner_top_left = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			130,
			272
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
			130,
			272
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
			70,
			202
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
			70,
			202
		},
		position = {
			0,
			0,
			62
		}
	},
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
			40,
			1
		}
	},
	weapon_stats_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-1140,
			60,
			3
		}
	},
	weapon_compare_stats_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-1140 + grid_size[1] - 50,
			60,
			3
		}
	},
	display_name = {
		vertical_alignment = "top",
		parent = "weapon_stats_pivot",
		horizontal_alignment = "left",
		size = {
			1700,
			50
		},
		position = {
			0,
			-567,
			3
		}
	},
	weapon_actions_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-560,
			40,
			3
		}
	},
	equip_button = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			374,
			76
		},
		position = {
			857,
			-90,
			1
		}
	}
}
local widget_definitions = {
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value_id = "texture"
		}
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value_id = "texture"
		}
	}, "corner_bottom_right"),
	equip_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.default_button), "equip_button", {
		text = Utf8.upper(Localize("loc_weapon_inventory_equip_button")),
		hotspot = {}
	}),
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/panel_horizontal_half",
			pass_type = "texture",
			style = {
				offset = {
					0,
					0,
					0
				},
				color = {
					100,
					0,
					0,
					0
				}
			}
		}
	}, "screen")
}
local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	},
	{
		input_action = "hotkey_item_customize",
		display_name = "loc_weapon_inventory_customize_button",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_customize_pressed",
		visibility_function = function (parent)
			local is_previewing_item = parent:is_previewing_item()

			if is_previewing_item then
				local is_previewing_item = parent:is_previewing_item()
				local previewed_item = parent:previewed_item()
				local item_type = previewed_item.item_type
				local ITEM_TYPES = UISettings.ITEM_TYPES

				if item_type == ITEM_TYPES.WEAPON_MELEE or item_type == ITEM_TYPES.WEAPON_RANGED then
					return true
				end
			end

			return false
		end
	},
	{
		input_action = "hotkey_item_inspect",
		display_name = "loc_weapon_inventory_inspect_button",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_inspect_pressed",
		visibility_function = function (parent)
			local is_previewing_item = parent:is_previewing_item()

			if is_previewing_item then
				local is_previewing_item = parent:is_previewing_item()
				local previewed_item = parent:previewed_item()
				local item_type = previewed_item.item_type
				local ITEM_TYPES = UISettings.ITEM_TYPES

				if item_type == ITEM_TYPES.WEAPON_MELEE or item_type == ITEM_TYPES.WEAPON_RANGED then
					return true
				end
			end

			return false
		end
	},
	{
		input_action = "hotkey_item_compare",
		display_name = "loc_item_toggle_equipped_compare",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_toggle_item_compare",
		visibility_function = function (parent)
			local is_previewing_item = parent:is_previewing_item()

			return is_previewing_item
		end
	},
	{
		input_action = "hotkey_item_discard",
		display_name = "loc_inventory_item_discard",
		alignment = "right_alignment",
		use_mouse_hold = true,
		on_pressed_callback = "cb_on_discard_held",
		visibility_function = function (parent)
			local is_item_equipped = parent:is_selected_item_equipped()

			return not is_item_equipped
		end
	}
}

return {
	grid_settings = grid_settings,
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
