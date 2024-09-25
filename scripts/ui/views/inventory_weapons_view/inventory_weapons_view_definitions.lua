-- chunkname: @scripts/ui/views/inventory_weapons_view/inventory_weapons_view_definitions.lua

local InventoryWeaponsViewSettings = require("scripts/ui/views/inventory_weapons_view/inventory_weapons_view_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISettings = require("scripts/settings/ui/ui_settings")
local ItemUtils = require("scripts/utilities/items")
local title_height = 108
local edge_padding = 44
local grid_width = 640
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
local button_margin = 20
local button_size = ButtonPassTemplates.terminal_button.size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	corner_top_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			130,
			272,
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
			130,
			272,
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
			70,
			202,
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
			70,
			202,
		},
		position = {
			0,
			0,
			62,
		},
	},
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
			0,
			0,
		},
		position = {
			100,
			40,
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
			-1140,
			60,
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
			60,
			3,
		},
	},
	display_name = {
		horizontal_alignment = "left",
		parent = "weapon_stats_pivot",
		vertical_alignment = "top",
		size = {
			1700,
			50,
		},
		position = {
			0,
			-567,
			3,
		},
	},
	weapon_actions_pivot = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-560,
			40,
			3,
		},
	},
	equip_button = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			374,
			76,
		},
		position = {
			857,
			-90,
			1,
		},
	},
	button_options = {
		horizontal_alignment = "top",
		parent = "canvas",
		vertical_alignment = "left",
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
	weapon_discard_pivot = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			1320,
			60,
			1,
		},
	},
}
local widget_definitions = {
	corner_bottom_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value_id = "texture",
		},
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value_id = "texture",
		},
	}, "corner_bottom_right"),
	equip_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.default_button), "equip_button", {
		gamepad_action = "confirm_pressed",
		original_text = Utf8.upper(Localize("loc_weapon_inventory_equip_button")),
		hotspot = {},
	}),
	background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/panel_horizontal_half",
			style = {
				offset = {
					0,
					0,
					0,
				},
				color = {
					100,
					0,
					0,
					0,
				},
			},
		},
	}, "screen"),
	discard_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.default_button), "equip_button", {
		gamepad_action = "gamepad_secondary_action_pressed",
		visible = false,
		original_text = Utf8.upper(Localize("loc_discard_items_button")),
		hotspot = {},
	}),
}
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_settings_menu_close_menu",
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
	},
	{
		alignment = "right_alignment",
		display_name = "loc_item_toggle_equipped_compare",
		input_action = "hotkey_item_compare",
		on_pressed_callback = "cb_on_toggle_item_compare",
		visibility_function = function (parent)
			local is_previewing_item = parent:is_previewing_item()

			return is_previewing_item and not parent:is_selected_item_equipped() and not parent._discard_items_element and not parent._selected_options
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_discard_items_button",
		input_action = "hotkey_item_discard_pressed",
		on_pressed_callback = "cb_on_discard_pressed",
		visibility_function = function (parent)
			return not parent._discard_items_element
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_inventory_add_favorite",
		input_action = "hotkey_item_favorite",
		on_pressed_callback = "cb_on_favorite_pressed",
		visibility_function = function (parent, id)
			local widget

			if parent._discard_items_element and not parent._discard_items_element:visible() then
				return false
			end

			if parent._discard_items_element and parent._using_cursor_navigation then
				widget = parent._item_grid and parent._item_grid:hovered_widget()
			else
				widget = parent._item_grid and parent._item_grid:selected_grid_widget()
			end

			local gear_id = widget and widget.content.element and widget.content.element.item and widget.content.element.item.gear_id

			if gear_id then
				local is_favorite = ItemUtils.is_item_id_favorited(gear_id)
				local display_name = is_favorite and "loc_inventory_remove_favorite" or "loc_inventory_add_favorite"

				parent._input_legend_element:set_display_name(id, display_name)

				return true
			end

			return false
		end,
	},
}
local blueprints = {
	button = {
		size = ButtonPassTemplates.terminal_button.size,
		pass_template = table.clone(ButtonPassTemplates.terminal_list_button_with_background_and_text_icon),
		init = function (parent, widget, entry, callback_name)
			local content = widget.content

			content.text = entry.display_name or ""
			content.icon = entry.display_icon or ""
			content.hotspot.pressed_callback = entry.callback
		end,
	},
}

return {
	grid_settings = grid_settings,
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	blueprints = blueprints,
}
