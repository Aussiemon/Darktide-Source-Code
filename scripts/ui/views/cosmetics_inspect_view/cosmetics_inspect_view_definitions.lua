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
	left_side = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			grid_width,
			grid_height
		},
		position = {
			100,
			130,
			1
		}
	},
	title = {
		vertical_alignment = "top",
		parent = "left_side",
		horizontal_alignment = "left",
		size = {
			grid_width - 40,
			70
		},
		position = {
			20,
			50,
			1
		}
	},
	description_grid = {
		vertical_alignment = "top",
		parent = "left_side",
		horizontal_alignment = "center",
		size = {
			grid_width - grid_margin * 2,
			grid_height - 80
		},
		position = {
			0,
			40,
			1
		}
	},
	description_content_pivot = {
		vertical_alignment = "top",
		parent = "description_grid",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			2
		}
	},
	description_mask = {
		vertical_alignment = "center",
		parent = "description_grid",
		horizontal_alignment = "center",
		size = {
			grid_width,
			grid_height - 40
		},
		position = {
			0,
			0,
			2
		}
	},
	description_scrollbar = {
		vertical_alignment = "top",
		parent = "description_grid",
		horizontal_alignment = "right",
		size = {
			10,
			grid_height - 80
		},
		position = {
			30,
			-20,
			2
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
item_restrictions_title_style.text_color = Color.terminal_text_body_sub_header(255, true)
local item_restrictions_text_style = table.clone(item_restrictions_title_style)
item_restrictions_text_style.text_color = Color.terminal_text_body(255, true)
local title_style = table.clone(UIFontSettings.header_1)
title_style.font_size = 40
title_style.offset = {
	0,
	0,
	1
}
title_style.text_horizontal_alignment = "center"
title_style.text_vertical_alignment = "top"
local sub_title_style = table.clone(UIFontSettings.header_5)
sub_title_style.text_horizontal_alignment = "center"
sub_title_style.text_vertical_alignment = "top"
sub_title_style.offset = {
	0,
	0,
	0
}
sub_title_style.text_color = Color.terminal_text_body(255, true)
local description_text_font_style = table.clone(UIFontSettings.terminal_header_3)
description_text_font_style.text_horizontal_alignment = "left"
description_text_font_style.text_vertical_alignment = "top"
description_text_font_style.font_size = 20
description_text_font_style.text_color = Color.terminal_text_body(255, true)
local widget_definitions = {
	bundle_background = UIWidget.create_definition({
		{
			value_id = "bundle",
			style_id = "bundle",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/bundle_store_preview",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					0
				},
				size = {
					1200,
					1080
				},
				size_addition = {
					0,
					0
				},
				material_values = {
					gradient_map = "content/ui/textures/masks/blur_straight"
				}
			},
			visibility_function = function (content, style)
				return style.material_values.texture_map
			end
		}
	}, "canvas"),
	title = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style_id = "text",
			value = "",
			style = title_style
		},
		{
			value_id = "sub_text",
			pass_type = "text",
			style_id = "sub_text",
			value = "",
			style = sub_title_style
		},
		{
			value_id = "divider",
			style_id = "divider",
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_center_02",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					400,
					18
				},
				offset = {
					0,
					9,
					1
				},
				color = Color.terminal_frame(255, true)
			}
		}
	}, "title"),
	description_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "description_scrollbar"),
	description_mask = UIWidget.create_definition({
		{
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur_viewport_2",
			pass_type = "texture",
			style = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					3
				}
			}
		}
	}, "description_mask")
}
local text_description_pass_template = {
	{
		value_id = "text",
		style_id = "text",
		pass_type = "text",
		value = "",
		style = description_text_font_style
	}
}
local item_restrictions_pass = {
	{
		value_id = "title",
		style_id = "title",
		pass_type = "text",
		value = Utf8.upper(Localize("loc_item_equippable_on_header")),
		style = item_restrictions_title_style
	},
	{
		value_id = "text",
		style_id = "text",
		pass_type = "text",
		value = "",
		style = item_restrictions_text_style
	}
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
		input_action = "hotkey_menu_special_1",
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
		input_action = "hotkey_menu_special_1",
		on_pressed_callback = "cb_on_weapon_swap_pressed",
		visibility_function = function (parent)
			return parent:_can_swap_weapon()
		end
	},
	{
		display_name = "loc_inventory_menu_zoom_in",
		input_action = "hotkey_menu_special_2",
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
	scenegraph_definition = scenegraph_definition,
	text_description_pass_template = text_description_pass_template,
	item_restrictions_pass = item_restrictions_pass
}
