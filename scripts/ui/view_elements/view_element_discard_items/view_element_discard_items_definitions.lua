-- chunkname: @scripts/ui/view_elements/view_element_discard_items/view_element_discard_items_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local StepperPassTemplates = require("scripts/ui/pass_templates/stepper_pass_templates")
local CheckboxPassTemplates = require("scripts/ui/pass_templates/checkbox_pass_templates")
local DiscardItemsSettings = require("scripts/ui/view_elements/view_element_discard_items/view_element_discard_items_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local Text = require("scripts/utilities/ui/text")
local window_size = DiscardItemsSettings.window_size
local content_size = DiscardItemsSettings.content_size
local checkbox_size = DiscardItemsSettings.checkbox_size
local confirm_button_size = DiscardItemsSettings.confirm_button_size
local scenegraph_definitions = {
	screen = UIWorkspaceSettings.screen,
	pivot = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
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
	window = {
		horizontal_alignment = "top",
		parent = "pivot",
		vertical_alignment = "left",
		size = window_size,
		position = {
			0,
			0,
			20,
		},
	},
	window_content = {
		horizontal_alignment = "center",
		parent = "window",
		vertical_alignment = "bottom",
		size = window_size,
		position = {
			0,
			0,
			2,
		},
	},
	rarity_title = {
		horizontal_alignment = "center",
		parent = "window_content",
		vertical_alignment = "top",
		size = {
			content_size[1],
			50,
		},
		position = {
			0,
			0,
			1,
		},
	},
	rarity_checkbox_button_1 = {
		horizontal_alignment = "center",
		parent = "rarity_title",
		vertical_alignment = "bottom",
		size = checkbox_size,
		position = {
			0,
			checkbox_size[2] + 10,
			0,
		},
	},
	rarity_checkbox_button_2 = {
		horizontal_alignment = "center",
		parent = "rarity_checkbox_button_1",
		vertical_alignment = "bottom",
		size = checkbox_size,
		position = {
			0,
			checkbox_size[2] + 10,
			0,
		},
	},
	rarity_checkbox_button_3 = {
		horizontal_alignment = "center",
		parent = "rarity_checkbox_button_2",
		vertical_alignment = "bottom",
		size = checkbox_size,
		position = {
			0,
			checkbox_size[2] + 10,
			0,
		},
	},
	rarity_checkbox_button_4 = {
		horizontal_alignment = "center",
		parent = "rarity_checkbox_button_3",
		vertical_alignment = "bottom",
		size = checkbox_size,
		position = {
			0,
			checkbox_size[2] + 10,
			0,
		},
	},
	rarity_checkbox_button_5 = {
		horizontal_alignment = "center",
		parent = "rarity_checkbox_button_4",
		vertical_alignment = "bottom",
		size = checkbox_size,
		position = {
			0,
			checkbox_size[2] + 10,
			0,
		},
	},
	rating_title = {
		horizontal_alignment = "center",
		parent = "rarity_checkbox_button_5",
		vertical_alignment = "bottom",
		size = {
			content_size[1],
			50,
		},
		position = {
			0,
			50,
			1,
		},
	},
	rating_stepper = {
		horizontal_alignment = "center",
		parent = "rating_title",
		vertical_alignment = "bottom",
		size = checkbox_size,
		position = {
			0,
			checkbox_size[2] + 10,
			0,
		},
	},
	select_button = {
		horizontal_alignment = "center",
		parent = "selection_value",
		vertical_alignment = "bottom",
		size = confirm_button_size,
		position = {
			0,
			confirm_button_size[2] + 10,
			0,
		},
	},
	unselect_button = {
		horizontal_alignment = "center",
		parent = "select_button",
		vertical_alignment = "bottom",
		size = confirm_button_size,
		position = {
			0,
			confirm_button_size[2] + 10,
			0,
		},
	},
	selection_value = {
		horizontal_alignment = "center",
		parent = "rating_stepper",
		vertical_alignment = "bottom",
		size = {
			content_size[1],
			30,
		},
		position = {
			0,
			60,
			23,
		},
	},
	description = {
		horizontal_alignment = "center",
		parent = "selection_value",
		vertical_alignment = "bottom",
		size = {
			content_size[1],
			30,
		},
		position = {
			0,
			-30,
			2,
		},
	},
}
local widget_definitions = {
	rarity_title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = {
				font_size = 20,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "bottom",
				vertical_alignment = "bottom",
				text_color = Color.terminal_text_body_sub_header(255, true),
				offset = {
					0,
					0,
					1,
				},
			},
			value = Localize("loc_discard_items_view_rarity_title"),
		},
	}, "rarity_title"),
	rating_title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = {
				font_size = 20,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "bottom",
				vertical_alignment = "bottom",
				text_color = Color.terminal_text_body_sub_header(255, true),
				offset = {
					0,
					0,
					1,
				},
			},
			value = Localize("loc_discard_items_view_rating_lower"),
		},
	}, "rating_title"),
	description = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = {
				font_size = 20,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "bottom",
				vertical_alignment = "bottom",
				text_color = Color.terminal_text_body_sub_header(255, true),
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "description"),
	window = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					24,
					24,
				},
				color = Color.terminal_grid_background(nil, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "background_gradient",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.black(200, true),
				offset = {
					0,
					0,
					3,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_frame(nil, true),
				offset = {
					0,
					0,
					4,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_corner(nil, true),
				offset = {
					0,
					0,
					5,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "edge_top",
			value = "content/ui/materials/dividers/horizontal_dynamic_upper",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					nil,
					10,
				},
				size_addition = {
					10,
					0,
				},
				color = Color.terminal_text_header(255, true),
				offset = {
					0,
					-4,
					14,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "edge_bottom",
			value = "content/ui/materials/dividers/horizontal_dynamic_lower",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					nil,
					10,
				},
				size_addition = {
					10,
					0,
				},
				color = Color.terminal_text_header(255, true),
				offset = {
					0,
					4,
					14,
				},
			},
		},
	}, "window"),
	selection_value = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "value",
			value_id = "value",
			style = {
				font_size = 18,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "selection_value"),
	rarity_checkbox_button_1 = UIWidget.create_definition(CheckboxPassTemplates.terminal_checkbox_button, "rarity_checkbox_button_1", {
		visible = true,
		original_text = Localize("loc_item_weapon_rarity_1"),
	}),
	rarity_checkbox_button_2 = UIWidget.create_definition(CheckboxPassTemplates.terminal_checkbox_button, "rarity_checkbox_button_2", {
		visible = true,
		original_text = Localize("loc_item_weapon_rarity_2"),
	}),
	rarity_checkbox_button_3 = UIWidget.create_definition(CheckboxPassTemplates.terminal_checkbox_button, "rarity_checkbox_button_3", {
		visible = true,
		original_text = Localize("loc_item_weapon_rarity_3"),
	}),
	rarity_checkbox_button_4 = UIWidget.create_definition(CheckboxPassTemplates.terminal_checkbox_button, "rarity_checkbox_button_4", {
		visible = true,
		original_text = Localize("loc_item_weapon_rarity_4"),
	}),
	rarity_checkbox_button_5 = UIWidget.create_definition(CheckboxPassTemplates.terminal_checkbox_button, "rarity_checkbox_button_5", {
		visible = true,
		original_text = Localize("loc_item_weapon_rarity_5"),
	}),
	rating_stepper = UIWidget.create_definition(StepperPassTemplates.terminal_stepper, "rating_stepper", {
		original_text = "999",
		visible = true,
	}),
	select_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "select_button", {
		visible = true,
		original_text = Localize("loc_select"),
		hotspot = {
			on_released_sound = nil,
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.mastery_select_weapon,
		},
	}),
	unselect_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "unselect_button", {
		visible = true,
		original_text = Localize("loc_unselect"),
		hotspot = {
			on_released_sound = nil,
			on_hover_sound = UISoundEvents.default_mouse_hover,
			on_pressed_sound = UISoundEvents.weapons_select_weapon,
		},
	}),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definitions,
}
