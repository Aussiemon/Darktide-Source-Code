-- chunkname: @scripts/ui/views/inventory_background_view/inventory_background_view_definitions.lua

local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local InputDevice = require("scripts/managers/input/input_device")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local Items = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local character_experience_bar_size = {
	188,
	16,
}
local portait_size = table.clone(ItemSlotSettings.slot_portrait_frame.item_icon_size)
local insignia_size = table.clone(ItemSlotSettings.slot_insignia.item_icon_size)
local scenegraph_definition = {
	screen = {
		scale = "fit",
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
			462,
			272,
		},
		position = {
			0,
			0,
			110,
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
			110,
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
			110,
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
			110,
		},
	},
	transition_background = {
		scale = "fit",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			93,
		},
	},
	profile_presets_pivot = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			-60,
			94,
			92,
		},
	},
	character_insigna = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			insignia_size[1] * 0.8,
			insignia_size[2] * 0.8,
		},
		position = {
			52,
			15,
			110,
		},
	},
	character_portrait = {
		horizontal_alignment = "left",
		parent = "character_insigna",
		vertical_alignment = "center",
		size = {
			portait_size[1] * 0.8,
			portait_size[2] * 0.8,
		},
		position = {
			insignia_size[1] * 0.8,
			0,
			1,
		},
	},
	character_name = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			400,
			30,
		},
		position = {
			200,
			8,
			111,
		},
	},
	character_title = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			400,
			54,
		},
		position = {
			200,
			42,
			111,
		},
	},
	character_archetype_title = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			400,
			54,
		},
		position = {
			200,
			68,
			111,
		},
	},
	character_name_no_title = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			400,
			30,
		},
		position = {
			200,
			20,
			111,
		},
	},
	character_archetype_title_no_title = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			280,
			54,
		},
		position = {
			200,
			55,
			111,
		},
	},
	character_level = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			40,
			54,
		},
		position = {
			113,
			97,
			111,
		},
	},
	character_level_next = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			40,
			54,
		},
		position = {
			381,
			97,
			111,
		},
	},
	character_experience = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = character_experience_bar_size,
		position = {
			175,
			116,
			109,
		},
	},
	loading = {
		horizontal_alignment = "center",
		scale = "fit",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			200,
		},
	},
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
				color = Color.black(127.5, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/loading/loading_icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					256,
					256,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "loading", {
		visible = false,
	}),
	character_portrait = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture_portrait",
			value = "content/ui/materials/base/ui_portrait_frame_base",
			value_id = "texture",
			style = {
				material_values = {
					texture_frame = "content/ui/textures/icons/items/frames/default",
					use_placeholder_texture = 1,
				},
			},
		},
	}, "character_portrait"),
	character_insigna = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture_insignia",
			value = "content/ui/materials/base/ui_default_base",
			value_id = "texture_insignia",
			style = {
				material_values = {
					use_placeholder_texture = 1,
				},
			},
		},
	}, "character_insigna"),
	character_name = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "",
			value_id = "text",
			style = character_name_style,
		},
	}, "character_name"),
	character_archetype_title = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "",
			value_id = "text",
			style = character_archetype_title_style,
		},
	}, "character_archetype_title"),
	character_title = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "",
			value_id = "text",
			style = character_title_style,
		},
	}, "character_title"),
	character_level = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "",
			value_id = "text",
			style = character_level_style,
		},
	}, "character_level"),
	character_level_next = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "",
			value_id = "text",
			style = character_level_next_style,
		},
	}, "character_level_next"),
	character_experience = UIWidget.create_definition(BarPassTemplates.character_menu_experience_bar, "character_experience", {
		bar_length = character_experience_bar_size[1],
	}, character_experience_bar_size),
	corner_top_left = UIWidget.create_definition({
		{
			pass_type = "texture",
			value_id = "texture",
		},
	}, "corner_top_left"),
	corner_top_right = UIWidget.create_definition({
		{
			pass_type = "texture",
			value_id = "texture",
		},
	}, "corner_top_right"),
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
	transition_background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.black(255, true),
			},
		},
	}, "transition_background", {
		visible = false,
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
		display_name = "loc_inventory_menu_swap_weapon",
		input_action = "hotkey_menu_special_1",
		on_pressed_callback = "cb_on_weapon_swap_pressed",
		visibility_function = function (parent)
			return not parent._is_readonly and parent:_can_swap_weapon() and parent:is_inventory_synced()
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_menu_toggle_ui_visibility_on",
		input_action = "hotkey_toggle_item_tooltip",
		on_pressed_callback = "cb_on_item_stats_toggled",
		visibility_function = function (parent, id)
			if not InputDevice.gamepad_active then
				return
			end

			local display_name = parent:is_item_stats_toggled() and "loc_menu_toggle_ui_visibility_off" or "loc_menu_toggle_ui_visibility_on"

			parent._input_legend_element:set_display_name(id, display_name)

			local active_view = parent._active_view

			return active_view and active_view == "inventory_view"
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_talent_menu_action_clear_all_points",
		input_action = "hotkey_menu_special_1",
		on_pressed_callback = "cb_on_clear_all_talents_pressed",
		visibility_function = function (parent, id)
			return parent._active_view == "talent_builder_view" and not parent._is_readonly
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_inventory_menu_profile_preset_cycle",
		input_action = "hotkey_item_profile_preset_input_2",
		on_pressed_callback = "cb_on_profile_preset_cycle",
		visibility_function = function (parent)
			return InputDevice.gamepad_active and parent:can_cycle_profile_preset() and not parent._is_readonly
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_inventory_menu_profile_preset_add",
		input_action = "hotkey_item_profile_preset_input_1",
		on_pressed_callback = "cb_on_profile_preset_add",
		visibility_function = function (parent)
			return InputDevice.gamepad_active and parent:can_add_profile_preset() and not parent._is_readonly
		end,
	},
	{
		alignment = "right_alignment",
		display_name = "loc_inventory_menu_profile_preset_customize",
		input_action = "hotkey_item_profile_preset_input_1_hold",
		on_pressed_callback = "cb_on_profile_preset_customize",
		visibility_function = function (parent)
			return InputDevice.gamepad_active and parent:can_customize_profile_preset() and not parent._is_readonly
		end,
	},
}
local animations = {
	transition_fade = {
		{
			end_time = 0.4,
			name = "fade_out",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				widgets.transition_background.alpha_multiplier = 1
				widgets.transition_background.content.visible = true
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				widgets.transition_background.alpha_multiplier = 1 - progress
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				widgets.transition_background.content.visible = false
			end,
		},
	},
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	animations = animations,
}
