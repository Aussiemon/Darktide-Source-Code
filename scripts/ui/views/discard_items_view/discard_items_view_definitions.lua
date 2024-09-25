-- chunkname: @scripts/ui/views/discard_items_view/discard_items_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local StepperPassTemplates = require("scripts/ui/pass_templates/stepper_pass_templates")
local CheckboxPassTemplates = require("scripts/ui/pass_templates/checkbox_pass_templates")
local DiscardItemsViewSettings = require("scripts/ui/views/discard_items_view/discard_items_view_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local Text = require("scripts/utilities/ui/text")
local window_size = DiscardItemsViewSettings.window_size
local content_size = DiscardItemsViewSettings.content_size
local checkbox_size = DiscardItemsViewSettings.checkbox_size
local discard_button_size = DiscardItemsViewSettings.discard_button_size
local scenegraph_definitions = {
	screen = UIWorkspaceSettings.screen,
	background_icon = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1250,
			1250,
		},
		position = {
			0,
			0,
			0,
		},
	},
	button_pivot = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			0,
			470,
			1,
		},
	},
	window = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
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
	window_title = {
		horizontal_alignment = "center",
		parent = "window_content",
		vertical_alignment = "top",
		size = {
			content_size[1],
			50,
		},
		position = {
			0,
			20,
			2,
		},
	},
	title_divider = {
		horizontal_alignment = "center",
		parent = "window_title",
		vertical_alignment = "bottom",
		size = {
			468,
			22,
		},
		position = {
			0,
			30,
			1,
		},
	},
	rarity_title = {
		horizontal_alignment = "center",
		parent = "title_divider",
		vertical_alignment = "bottom",
		size = {
			content_size[1],
			50,
		},
		position = {
			0,
			45,
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
	description = {
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
			1,
		},
	},
	discard_button = {
		horizontal_alignment = "center",
		parent = "description",
		vertical_alignment = "bottom",
		size = discard_button_size,
		position = {
			0,
			discard_button_size[2] + 10,
			0,
		},
	},
	close_button = {
		horizontal_alignment = "center",
		parent = "discard_button",
		vertical_alignment = "bottom",
		size = discard_button_size,
		position = {
			0,
			discard_button_size[2] + 10,
			2,
		},
	},
}
local widget_definitions = {
	title_divider = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_center_02",
			style = {
				color = Color.terminal_frame(255, true),
			},
		},
	}, "title_divider"),
	window_title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			style = {
				font_size = 28,
				font_type = "proxima_nova_bold",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				text_color = Color.terminal_text_header(255, true),
				offset = {
					0,
					0,
					1,
				},
			},
			value = Localize("loc_grim_input_description_discard"),
		},
	}, "window_title"),
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
			value = Localize("loc_discard_items_view_rating_title"),
		},
	}, "rating_title"),
	description = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "n/a",
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
			content_id = "hotspot",
			pass_type = "hotspot",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size_addition = {
					0,
					0,
				},
				offset = {
					0,
					0,
					10,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "screen_background",
			style = {
				horizontal_alignment = "center",
				scenegraph_id = "screen",
				vertical_alignment = "center",
				color = {
					100,
					0,
					0,
					0,
				},
				offset = {
					0,
					0,
					0,
				},
				size_addition = {
					0,
					0,
				},
			},
		},
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
			style_id = "outer_shadow",
			value = "content/ui/materials/frames/dropshadow_large",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				color = Color.black(200, true),
				size_addition = {
					96,
					96,
				},
				offset = {
					0,
					0,
					5,
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
		{
			pass_type = "texture",
			style_id = "screen_background_vignette",
			value = "content/ui/materials/masks/gradient_vignette",
			style = {
				scenegraph_id = "screen",
				color = {
					100,
					0,
					0,
					0,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
		{
			pass_type = "rect",
			style_id = "window_background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = {
					100,
					0,
					0,
					0,
				},
				offset = {
					0,
					0,
					-1,
				},
				size_addition = {
					0,
					0,
				},
			},
		},
	}, "window"),
	discard_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button_hold_small, "discard_button", {
		visible = true,
		original_text = Localize("loc_alias_view_hotkey_item_discard"),
	}),
	close_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "close_button", {
		visible = true,
		original_text = Localize("loc_action_interaction_close"),
	}),
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
}
local animation_definitions = {
	on_enter = {
		{
			end_time = 0,
			name = "init",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local window = widgets.window

				for _, pass_style in pairs(window.style) do
					local color = pass_style.text_color or pass_style.color

					if color then
						color[1] = 0
					end
				end

				widgets.discard_button.alpha_multiplier = 0
				widgets.close_button.alpha_multiplier = 0
				widgets.rating_stepper.alpha_multiplier = 0
				widgets.title_divider.alpha_multiplier = 0
				widgets.description.alpha_multiplier = 0
				widgets.rarity_checkbox_button_1.alpha_multiplier = 0
				widgets.rarity_checkbox_button_2.alpha_multiplier = 0
				widgets.rarity_checkbox_button_3.alpha_multiplier = 0
				widgets.rarity_checkbox_button_4.alpha_multiplier = 0
				widgets.rarity_checkbox_button_5.alpha_multiplier = 0
				widgets.window_title.alpha_multiplier = 0
				widgets.rarity_title.alpha_multiplier = 0
				widgets.rating_title.alpha_multiplier = 0
				parent._content_alpha_multiplier = 0
			end,
		},
		{
			end_time = 1.2,
			name = "fade_in_background",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeCubic(progress)
				local window = widgets.window
				local alpha = 100 * anim_progress

				window.style.screen_background.color[1] = alpha
				window.style.screen_background_vignette.color[1] = alpha
			end,
		},
		{
			end_time = 0.2,
			name = "fade_in_window",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)
				local window = widgets.window
				local alpha = 255 * anim_progress
				local window_style = window.style

				window_style.background.color[1] = alpha
				window_style.background_gradient.color[1] = 200 * anim_progress
				window_style.outer_shadow.color[1] = 200 * anim_progress
				window_style.frame.color[1] = alpha
				window_style.corner.color[1] = alpha
				window_style.edge_top.color[1] = alpha
				window_style.edge_bottom.color[1] = alpha
				window_style.window_background.color[1] = 200 * anim_progress
			end,
		},
		{
			end_time = 0.7,
			name = "fade_in_content",
			start_time = 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				parent._content_alpha_multiplier = anim_progress
				widgets.discard_button.alpha_multiplier = anim_progress
				widgets.close_button.alpha_multiplier = anim_progress
				widgets.rating_stepper.alpha_multiplier = anim_progress
				widgets.title_divider.alpha_multiplier = anim_progress
				widgets.description.alpha_multiplier = anim_progress
				widgets.rarity_checkbox_button_1.alpha_multiplier = anim_progress
				widgets.rarity_checkbox_button_2.alpha_multiplier = anim_progress
				widgets.rarity_checkbox_button_3.alpha_multiplier = anim_progress
				widgets.rarity_checkbox_button_4.alpha_multiplier = anim_progress
				widgets.rarity_checkbox_button_5.alpha_multiplier = anim_progress
				widgets.window_title.alpha_multiplier = anim_progress
				widgets.rarity_title.alpha_multiplier = anim_progress
				widgets.rating_title.alpha_multiplier = anim_progress
			end,
		},
		{
			end_time = 0.4,
			name = "move",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent:_set_scenegraph_size("window", nil, 100)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeCubic(progress)

				parent:_set_scenegraph_size("window", nil, 100 + (scenegraph_definition.window.size[2] - 100) * anim_progress)
			end,
		},
	},
	on_exit = {
		{
			end_time = 0.3,
			name = "fade_out_content",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(1 - progress)

				parent._content_alpha_multiplier = anim_progress
				widgets.discard_button.alpha_multiplier = anim_progress
				widgets.close_button.alpha_multiplier = anim_progress
				widgets.rating_stepper.alpha_multiplier = anim_progress
				widgets.title_divider.alpha_multiplier = anim_progress
				widgets.description.alpha_multiplier = anim_progress
				widgets.rarity_checkbox_button_1.alpha_multiplier = anim_progress
				widgets.rarity_checkbox_button_2.alpha_multiplier = anim_progress
				widgets.rarity_checkbox_button_3.alpha_multiplier = anim_progress
				widgets.rarity_checkbox_button_4.alpha_multiplier = anim_progress
				widgets.rarity_checkbox_button_5.alpha_multiplier = anim_progress
				widgets.window_title.alpha_multiplier = anim_progress
				widgets.rarity_title.alpha_multiplier = anim_progress
				widgets.rating_title.alpha_multiplier = anim_progress
			end,
		},
		{
			end_time = 0.7,
			name = "move",
			start_time = 0.3,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent:_set_scenegraph_size("window", nil, 100)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeCubic(1 - progress)

				parent:_set_scenegraph_size("window", nil, 100 + (scenegraph_definition.window.size[2] - 100) * anim_progress)
			end,
		},
		{
			end_time = 0.5,
			name = "fade_out_window",
			start_time = 0.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(1 - progress)
				local window = widgets.window
				local alpha = 255 * anim_progress
				local window_style = window.style

				window_style.background.color[1] = alpha
				window_style.background_gradient.color[1] = 200 * anim_progress
				window_style.outer_shadow.color[1] = 200 * anim_progress
				window_style.frame.color[1] = alpha
				window_style.corner.color[1] = alpha
				window_style.edge_top.color[1] = alpha
				window_style.edge_bottom.color[1] = alpha
				window_style.window_background.color[1] = 200 * anim_progress
			end,
		},
		{
			end_time = 0.6,
			name = "delay",
			start_time = 0.5,
		},
	},
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definitions,
	animations = animation_definitions,
}
