local InventoryCosmeticsViewSettings = require("scripts/ui/views/inventory_cosmetics_view/inventory_cosmetics_view_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ItemUtils = require("scripts/utilities/items")
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
	weapon_stats_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-1340,
			110,
			3
		}
	},
	item_title_background = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			800,
			0
		},
		position = {
			0,
			-90,
			1
		}
	},
	item_title = {
		vertical_alignment = "center",
		parent = "item_title_background",
		horizontal_alignment = "right",
		size = {
			500,
			0
		},
		position = {
			-120,
			0,
			1
		}
	},
	item_restrictions_background = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			800,
			0
		},
		position = {
			100,
			-90,
			1
		}
	},
	item_restrictions = {
		vertical_alignment = "center",
		parent = "item_restrictions_background",
		horizontal_alignment = "left",
		size = {
			500,
			0
		},
		position = {
			50,
			0,
			1
		}
	}
}
local item_restrictions_title_style = table.clone(UIFontSettings.terminal_header_3)
item_restrictions_title_style.text_horizontal_alignment = "left"
item_restrictions_title_style.horizontal_alignment = "left"
item_restrictions_title_style.text_vertical_alignment = "top"
item_restrictions_title_style.vertical_alignment = "top"
item_restrictions_title_style.offset = {
	0,
	0,
	1
}
item_restrictions_title_style.font_size = 20
local item_title_style = table.clone(UIFontSettings.header_1)
item_title_style.material = "content/ui/materials/font_gradients/slug_font_gradient_rust"
item_title_style.font_size = 40
item_title_style.offset = {
	0,
	0,
	1
}
item_title_style.text_horizontal_alignment = "right"
item_title_style.horizontal_alignment = "right"
item_title_style.text_vertical_alignment = "top"
item_title_style.vertical_alignment = "bottom"
local item_sub_title_style = table.clone(UIFontSettings.terminal_header_3)
item_sub_title_style.text_horizontal_alignment = "right"
item_sub_title_style.horizontal_alignment = "right"
item_sub_title_style.text_vertical_alignment = "top"
item_sub_title_style.vertical_alignment = "bottom"
item_sub_title_style.offset = {
	0,
	10,
	1
}
item_sub_title_style.font_size = 20
local widget_definitions = {
	item_title_background = UIWidget.create_definition({
		{
			value_id = "title_background",
			style_id = "title_background",
			pass_type = "texture_uv",
			value = "content/ui/materials/masks/gradient_horizontal",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "top",
				color = Color.black(153, true),
				size_addition = {
					0,
					20
				},
				offset = {
					0,
					0,
					0
				},
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
	}, "item_title_background"),
	item_title = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			value = "",
			style = item_title_style
		},
		{
			value_id = "sub_text",
			pass_type = "text",
			style_id = "sub_text",
			value = "",
			style = item_sub_title_style
		}
	}, "item_title"),
	item_restrictions = UIWidget.create_definition({
		{
			value_id = "title",
			style_id = "title",
			pass_type = "text",
			value = Localize("loc_item_equippable_on_header"),
			style = item_restrictions_title_style
		},
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = item_restrictions_title_style
		}
	}, "item_restrictions", {
		visible = false
	})
}
local menu_zoom_out = "loc_inventory_menu_zoom_out"
local menu_zoom_in = "loc_inventory_menu_zoom_in"
local menu_preview_with_gear_off = "loc_inventory_menu_preview_with_gear_off"
local menu_preview_with_gear_on = "loc_inventory_menu_preview_with_gear_on"
local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	},
	{
		input_action = "hotkey_menu_special_2",
		alignment = "right_alignment",
		gear_toggle_option = true,
		on_pressed_callback = "cb_on_preview_with_gear_toggled",
		display_name = menu_preview_with_gear_off,
		visibility_function = function (parent, id)
			local display_name = parent._previewed_with_gear and menu_preview_with_gear_off or menu_preview_with_gear_on

			parent._input_legend_element:set_display_name(id, display_name)

			return true
		end
	},
	{
		display_name = "loc_inventory_menu_swap_weapon",
		store_appearance_option = true,
		alignment = "right_alignment",
		input_action = "hotkey_menu_special_2",
		on_pressed_callback = "cb_on_weapon_swap_pressed",
		visibility_function = function (parent)
			return parent:_can_swap_weapon()
		end
	},
	{
		display_name = "loc_inventory_menu_zoom_in",
		input_action = "hotkey_menu_special_1",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_camera_zoom_toggled",
		visibility_function = function (parent, id)
			if parent:_can_zoom() then
				local display_name = parent._camera_zoomed_in and menu_zoom_out or menu_zoom_in

				parent._input_legend_element:set_display_name(id, display_name)

				return true
			end

			return false
		end
	}
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
