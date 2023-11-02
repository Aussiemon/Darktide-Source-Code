local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local InputUtils = require("scripts/managers/input/input_utils")
local InventoryCosmeticsViewSettings = require("scripts/ui/views/inventory_cosmetics_view/inventory_cosmetics_view_settings")
local ItemUtils = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
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
	unlock_box = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			500,
			60
		},
		position = {
			600,
			-260,
			3
		}
	},
	unlock_title = {
		vertical_alignment = "top",
		parent = "unlock_box",
		horizontal_alignment = "left",
		size = {
			500,
			50
		},
		position = {
			0,
			0,
			3
		}
	},
	unlock_details = {
		vertical_alignment = "top",
		parent = "unlock_title",
		horizontal_alignment = "center",
		size = {
			500,
			50
		},
		position = {
			0,
			0,
			3
		}
	},
	toggle_locked_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	toggle_locked = {
		vertical_alignment = "top",
		parent = "toggle_locked_pivot",
		horizontal_alignment = "left",
		size = {
			400,
			20
		},
		position = {
			0,
			0,
			3
		}
	}
}
local unlock_title_style = table.clone(UIFontSettings.body)
unlock_title_style.text_horizontal_alignment = "left"
unlock_title_style.text_vertical_alignment = "top"
unlock_title_style.text_color = Color.terminal_icon(255, true)
local unlock_icon_style = table.clone(unlock_title_style)
unlock_icon_style.offset = {
	-20,
	0,
	0
}
local unlock_details_style = table.clone(UIFontSettings.body)
unlock_details_style.text_horizontal_alignment = "left"
unlock_details_style.text_vertical_alignment = "top"
unlock_details_style.text_color = Color.terminal_text_body(255, true)
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
	unlock_title = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			value = "",
			style = unlock_title_style
		},
		{
			value_id = "icon",
			pass_type = "text",
			style_id = "icon",
			value = "",
			style = unlock_icon_style,
			visibility_function = function (content, style)
				return content.locked
			end
		}
	}, "unlock_title"),
	unlock_details = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			value = "",
			style = unlock_details_style
		}
	}, "unlock_details"),
	equip_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "equip_button", {
		gamepad_action = "confirm_pressed",
		visible = false,
		text = Utf8.upper(Localize("loc_weapon_inventory_equip_button")),
		hotspot = {}
	}),
	toggle_locked = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_select
			}
		},
		{
			style_id = "text",
			pass_type = "text",
			value_id = "text",
			style = input_legend_button_style,
			change_function = function (content, style)
				local hotspot = content.hotspot
				local is_disabled = hotspot.disabled
				local button_text = content.original_text or ""
				local trigger_action = content.trigger_action
				local service_type = "View"
				local alias_key = Managers.ui:get_input_alias_key(trigger_action, service_type)
				local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)
				content.text = string.format(Localize("loc_input_legend_text_template"), input_text, button_text)
				local default_text_color = is_disabled and style.disabled_color or style.default_text_color
				local hover_color = style.hover_color
				local text_color = style.text_color
				local progress = math.max(hotspot.anim_hover_progress or 0, hotspot.anim_input_progress or 0)

				for i = 2, 4 do
					text_color[i] = (hover_color[i] - default_text_color[i]) * progress + default_text_color[i]
				end
			end
		}
	}, "toggle_locked", {
		visible = false,
		trigger_action = "toggle_filter",
		original_text = Localize("loc_inventory_cosmetics_item_acquisition_filter"),
		hotspot = {}
	})
}
local menu_zoom_out = "loc_inventory_menu_zoom_out"
local menu_zoom_in = "loc_inventory_menu_zoom_in"
local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	},
	{
		display_name = "loc_inventory_menu_zoom_in",
		input_action = "hotkey_menu_special_2",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_camera_zoom_toggled",
		visibility_function = function (parent, id)
			local display_name = parent._camera_zoomed_in and menu_zoom_out or menu_zoom_in

			parent._input_legend_element:set_display_name(id, display_name)

			return parent._initialize_zoom
		end
	},
	{
		input_action = "hotkey_item_inspect",
		display_name = "loc_weapon_inventory_inspect_button",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_inspect_pressed",
		visibility_function = function (parent)
			local previewed_item = parent._previewed_item

			if previewed_item then
				local item_type = previewed_item.item_type
				local ITEM_TYPES = UISettings.ITEM_TYPES

				if item_type == ITEM_TYPES.WEAPON_MELEE or item_type == ITEM_TYPES.WEAPON_RANGED or item_type == ITEM_TYPES.WEAPON_SKIN or item_type == ITEM_TYPES.END_OF_ROUND or item_type == ITEM_TYPES.GEAR_EXTRA_COSMETIC or item_type == ITEM_TYPES.GEAR_HEAD or item_type == ITEM_TYPES.GEAR_LOWERBODY or item_type == ITEM_TYPES.GEAR_UPPERBODY or item_type == ITEM_TYPES.EMOTE or item_type == ITEM_TYPES.SET then
					return true
				end
			end

			return false
		end
	}
}

return {
	grid_settings = grid_settings,
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
