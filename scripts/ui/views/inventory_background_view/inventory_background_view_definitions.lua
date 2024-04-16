local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local InputDevice = require("scripts/managers/input/input_device")
local InventoryBackgroundViewSettings = require("scripts/ui/views/inventory_background_view/inventory_background_view_settings")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemUtils = require("scripts/utilities/items")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local character_experience_bar_size = {
	188,
	16
}
local portait_size = table.clone(ItemSlotSettings.slot_portrait_frame.item_icon_size)
local insignia_size = table.clone(ItemSlotSettings.slot_insignia.item_icon_size)
local scenegraph_definition = {
	screen = {
		scale = "fit",
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
			462,
			272
		},
		position = {
			0,
			0,
			92
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
			92
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
			92
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
			92
		}
	},
	profile_presets_pivot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-60,
			94,
			92
		}
	},
	character_insigna = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			insignia_size[1] * 0.8,
			insignia_size[2] * 0.8
		},
		position = {
			52,
			15,
			94
		}
	},
	character_portrait = {
		vertical_alignment = "center",
		parent = "character_insigna",
		horizontal_alignment = "left",
		size = {
			portait_size[1] * 0.8,
			portait_size[2] * 0.8
		},
		position = {
			insignia_size[1] * 0.8,
			0,
			1
		}
	},
	character_name = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			400,
			30
		},
		position = {
			200,
			8,
			93
		}
	},
	character_title = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			400,
			54
		},
		position = {
			200,
			42,
			93
		}
	},
	character_archetype_title = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			400,
			54
		},
		position = {
			200,
			68,
			93
		}
	},
	character_name_no_title = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			400,
			30
		},
		position = {
			200,
			20,
			93
		}
	},
	character_archetype_title_no_title = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			280,
			54
		},
		position = {
			200,
			55,
			93
		}
	},
	character_level = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			40,
			54
		},
		position = {
			113,
			97,
			93
		}
	},
	character_level_next = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			40,
			54
		},
		position = {
			381,
			97,
			93
		}
	},
	character_experience = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = character_experience_bar_size,
		position = {
			175,
			116,
			93
		}
	},
	loading = {
		vertical_alignment = "center",
		scale = "fit",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			200
		}
	}
}
local character_title_style = table.clone(UIFontSettings.body_small)
character_title_style.text_horizontal_alignment = "left"
character_title_style.text_vertical_alignment = "top"
character_title_style.text_color = Color.terminal_text_body(255, true)
local character_name_style = table.clone(UIFontSettings.header_3)
character_name_style.text_horizontal_alignment = "left"
character_name_style.text_vertical_alignment = "top"
local character_archetype_title_style = table.clone(UIFontSettings.body_small)
character_archetype_title_style.text_horizontal_alignment = "left"
character_archetype_title_style.text_vertical_alignment = "top"
character_archetype_title_style.text_color = Color.terminal_text_body_sub_header(255, true)
local character_level_style = table.clone(UIFontSettings.body_small)
character_level_style.text_horizontal_alignment = "center"
character_level_style.text_vertical_alignment = "center"
character_level_style.text_color = Color.terminal_text_header(255, true)
local character_level_next_style = table.clone(UIFontSettings.body_small)
character_level_next_style.text_horizontal_alignment = "center"
character_level_next_style.text_vertical_alignment = "center"
character_level_next_style.text_color = Color.terminal_text_header(255, true)
local widget_definitions = {
	loading = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.black(127.5, true)
			}
		},
		{
			value = "content/ui/materials/loading/loading_icon",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					256,
					256
				},
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "loading", {
		visible = false
	}),
	character_portrait = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture_portrait",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_portrait_frame_base",
			style = {
				material_values = {
					texture_frame = "content/ui/textures/icons/items/frames/default",
					use_placeholder_texture = 1
				}
			}
		}
	}, "character_portrait"),
	character_insigna = UIWidget.create_definition({
		{
			value_id = "texture_insignia",
			style_id = "texture_insignia",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_default_base",
			style = {
				material_values = {
					use_placeholder_texture = 1
				}
			}
		}
	}, "character_insigna"),
	character_name = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = character_name_style
		}
	}, "character_name"),
	character_archetype_title = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = character_archetype_title_style
		}
	}, "character_archetype_title"),
	character_title = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = character_title_style
		}
	}, "character_title"),
	character_level = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = character_level_style
		}
	}, "character_level"),
	character_level_next = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = character_level_next_style
		}
	}, "character_level_next"),
	character_experience = UIWidget.create_definition(BarPassTemplates.character_menu_experience_bar, "character_experience", {
		bar_length = character_experience_bar_size[1]
	}, character_experience_bar_size),
	corner_top_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value_id = "texture"
		}
	}, "corner_top_left"),
	corner_top_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value_id = "texture"
		}
	}, "corner_top_right"),
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
	}, "corner_bottom_right")
}
local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	},
	{
		input_action = "hotkey_menu_special_1",
		display_name = "loc_inventory_menu_swap_weapon",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_weapon_swap_pressed",
		visibility_function = function (parent)
			return parent:_can_swap_weapon() and not parent._is_readonly and parent:is_inventory_synced()
		end
	},
	{
		input_action = "hotkey_toggle_item_tooltip",
		display_name = "loc_menu_toggle_ui_visibility_on",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_item_stats_toggled",
		visibility_function = function (parent, id)
			if not InputDevice.gamepad_active then
				return
			end

			local display_name = parent:is_item_stats_toggled() and "loc_menu_toggle_ui_visibility_off" or "loc_menu_toggle_ui_visibility_on"

			parent._input_legend_element:set_display_name(id, display_name)

			local active_view = parent._active_view

			return active_view and active_view == "inventory_view"
		end
	},
	{
		display_name = "loc_talent_menu_action_clear_all_points",
		input_action = "hotkey_menu_special_1",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_clear_all_talents_pressed",
		visibility_function = function (parent, id)
			return parent._active_view == "talent_builder_view" and not parent._is_readonly
		end
	},
	{
		input_action = "hotkey_item_profile_preset_input_2",
		display_name = "loc_inventory_menu_profile_preset_cycle",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_profile_preset_cycle",
		visibility_function = function (parent)
			return InputDevice.gamepad_active and parent:can_cycle_profile_preset() and not parent._is_readonly
		end
	},
	{
		input_action = "hotkey_item_profile_preset_input_1",
		display_name = "loc_inventory_menu_profile_preset_add",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_profile_preset_add",
		visibility_function = function (parent)
			return InputDevice.gamepad_active and parent:can_add_profile_preset() and not parent._is_readonly
		end
	},
	{
		input_action = "hotkey_item_profile_preset_input_1_hold",
		display_name = "loc_inventory_menu_profile_preset_customize",
		alignment = "right_alignment",
		on_pressed_callback = "cb_on_profile_preset_customize",
		visibility_function = function (parent)
			return InputDevice.gamepad_active and parent:can_customize_profile_preset() and not parent._is_readonly
		end
	}
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
