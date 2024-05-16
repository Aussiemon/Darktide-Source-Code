-- chunkname: @scripts/ui/view_elements/view_element_server_migration/view_element_server_migration_definitions.lua

local ConstantElementWarningPopupsSettings = require("scripts/ui/constant_elements/elements/popup_handler/constant_element_popup_handler_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ColorUtilities = require("scripts/utilities/ui/colors")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
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
	change_info_grid = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			800,
			600,
		},
		position = {
			0,
			0,
			200,
		},
	},
	change_info_grid_content_pivot = {
		horizontal_alignment = "left",
		parent = "change_info_grid",
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
	change_info_grid_scrollbar = {
		horizontal_alignment = "right",
		parent = "change_info_grid",
		vertical_alignment = "top",
		size = {
			8,
			600,
		},
		position = {
			13,
			0,
			2,
		},
	},
	change_info_grid_interaction = {
		horizontal_alignment = "left",
		parent = "change_info_grid",
		vertical_alignment = "top",
		size = {
			800,
			600,
		},
		position = {
			0,
			0,
			2,
		},
	},
	change_info_grid_mask = {
		horizontal_alignment = "center",
		parent = "change_info_grid",
		vertical_alignment = "center",
		size = {
			820,
			610,
		},
		position = {
			0,
			0,
			1,
		},
	},
	wallet_grid_1 = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			400,
			600,
		},
		position = {
			-220,
			0,
			200,
		},
	},
	wallet_grid_1_content_pivot = {
		horizontal_alignment = "left",
		parent = "wallet_grid_1",
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
	wallet_grid_1_scrollbar = {
		horizontal_alignment = "right",
		parent = "wallet_grid_1",
		vertical_alignment = "top",
		size = {
			8,
			600,
		},
		position = {
			13,
			0,
			2,
		},
	},
	wallet_grid_1_interaction = {
		horizontal_alignment = "left",
		parent = "wallet_grid_1",
		vertical_alignment = "top",
		size = {
			400,
			600,
		},
		position = {
			0,
			0,
			2,
		},
	},
	wallet_grid_1_mask = {
		horizontal_alignment = "center",
		parent = "wallet_grid_1",
		vertical_alignment = "center",
		size = {
			420,
			610,
		},
		position = {
			0,
			0,
			1,
		},
	},
	wallet_grid_2 = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			400,
			600,
		},
		position = {
			220,
			0,
			200,
		},
	},
	wallet_grid_2_content_pivot = {
		horizontal_alignment = "left",
		parent = "wallet_grid_2",
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
	wallet_grid_2_scrollbar = {
		horizontal_alignment = "right",
		parent = "wallet_grid_2",
		vertical_alignment = "top",
		size = {
			8,
			600,
		},
		position = {
			13,
			0,
			2,
		},
	},
	wallet_grid_2_interaction = {
		horizontal_alignment = "left",
		parent = "wallet_grid_2",
		vertical_alignment = "top",
		size = {
			400,
			600,
		},
		position = {
			0,
			0,
			2,
		},
	},
	wallet_grid_2_mask = {
		horizontal_alignment = "center",
		parent = "wallet_grid_2",
		vertical_alignment = "center",
		size = {
			420,
			610,
		},
		position = {
			0,
			0,
			1,
		},
	},
	wallet_grid_3 = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			800,
			100,
		},
		position = {
			0,
			0,
			200,
		},
	},
	wallet_grid_3_content_pivot = {
		horizontal_alignment = "left",
		parent = "wallet_grid_3",
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
	wallet_grid_3_scrollbar = {
		horizontal_alignment = "right",
		parent = "wallet_grid_3",
		vertical_alignment = "top",
		size = {
			8,
			100,
		},
		position = {
			13,
			0,
			2,
		},
	},
	wallet_grid_3_interaction = {
		horizontal_alignment = "left",
		parent = "wallet_grid_3",
		vertical_alignment = "top",
		size = {
			800,
			100,
		},
		position = {
			0,
			0,
			2,
		},
	},
	wallet_grid_3_mask = {
		horizontal_alignment = "center",
		parent = "wallet_grid_3",
		vertical_alignment = "center",
		size = {
			820,
			110,
		},
		position = {
			0,
			0,
			1,
		},
	},
	title_pivot = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			1920,
			50,
		},
		position = {
			0,
			0,
			5,
		},
	},
	slider_pivot = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			5,
		},
	},
	button_pivot = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = ButtonPassTemplates.terminal_button.size,
		position = {
			0,
			0,
			5,
		},
	},
}
local popup_type_style = {
	warning = {
		icon = "content/ui/materials/symbols/warning",
		icon_size = {
			92,
			72,
		},
		icon_color = {
			255,
			162,
			6,
			6,
		},
		background_color = {
			50,
			100,
			0,
			0,
		},
		terminal_background_color = {
			255,
			100,
			6,
			6,
		},
		title_text_color = {
			255,
			162,
			6,
			6,
		},
		description_text_color = {
			255,
			212,
			194,
			194,
		},
	},
	default = {
		icon = "content/ui/materials/symbols/warning",
		icon_size = {
			0,
			0,
		},
		icon_color = Color.blue(127.5, true),
		background_color = Color.terminal_grid_background(50, true),
		terminal_background_color = Color.terminal_grid_background(255, true),
		title_text_color = Color.terminal_text_header(255, true),
		description_text_color = Color.terminal_text_body(255, true),
	},
}
local title_style = table.clone(UIFontSettings.header_1)

title_style.text_horizontal_alignment = "center"

local widget_definitions = {
	change_info_grid_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "change_info_grid_scrollbar"),
	change_info_grid_interaction = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
		},
	}, "change_info_grid_interaction"),
	change_info_grid_mask = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur_viewport_3",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
	}, "change_info_grid_mask"),
	wallet_grid_1_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "wallet_grid_1_scrollbar"),
	wallet_grid_1_interaction = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
		},
	}, "wallet_grid_1_interaction"),
	wallet_grid_1_mask = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur_viewport_3",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
	}, "wallet_grid_1_mask"),
	wallet_grid_2_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "wallet_grid_2_scrollbar"),
	wallet_grid_2_interaction = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
		},
	}, "wallet_grid_2_interaction"),
	wallet_grid_2_mask = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur_viewport_3",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
	}, "wallet_grid_2_mask"),
	wallet_grid_3_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "wallet_grid_3_scrollbar"),
	wallet_grid_3_interaction = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
		},
	}, "wallet_grid_3_interaction"),
	wallet_grid_3_mask = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur_viewport_3",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
	}, "wallet_grid_3_mask"),
	popup_background = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "terminal",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				offset = {
					0,
					0,
					0,
				},
				size = {
					nil,
					0,
				},
				size_addition = {
					40,
					150,
				},
				uvs = {
					{
						0,
						0,
					},
					{
						1,
						1,
					},
				},
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "texture",
			value = "content/ui/materials/backgrounds/popups/screen_takeover_01",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_background(255, true),
				size_addition = {
					0,
					0,
				},
				offset = {
					0,
					0,
					1,
				},
				size = {
					1822,
					430,
				},
				uvs = {
					{
						0,
						0,
					},
					{
						1,
						1,
					},
				},
			},
		},
	}, "screen"),
	edge_top = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "texture",
			value = "content/ui/materials/dividers/horizontal_dynamic_upper",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					50,
					0,
				},
				offset = {
					0,
					0,
					2,
				},
				size = {
					252,
					10,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "texture_center",
			value = "content/ui/materials/dividers/skull_rendered_center_01",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					0,
					0,
				},
				offset = {
					0,
					0,
					3,
				},
				size = {
					140,
					18,
				},
			},
		},
	}, "screen"),
	edge_bottom = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "texture",
			value = "content/ui/materials/dividers/horizontal_dynamic_lower",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					50,
					0,
				},
				offset = {
					0,
					0,
					2,
				},
				size = {
					252,
					10,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "texture_center",
			value = "content/ui/materials/dividers/skull_rendered_center_02",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					0,
					0,
				},
				offset = {
					0,
					10,
					3,
				},
				size = {
					306,
					48,
				},
			},
		},
	}, "screen"),
	next_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "button_pivot", {
		alpha_multiplier = 0,
		gamepad_action = "confirm_pressed",
		original_text = Localize("loc_confirm"),
		hotspot = {
			use_is_focused = true,
		},
	}),
	close_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button_hold_small, "button_pivot", {
		alpha_multiplier = 0,
	}, ButtonPassTemplates.terminal_button.size),
	title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "title",
			value = "",
			value_id = "title",
			style = title_style,
		},
	}, "title_pivot"),
}
local slide_selector = {
	margin = 5,
	pass_template_function = function (index, template)
		return {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				style_id = "hotspot",
				content = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.default_click,
					on_select_sound = UISoundEvents.default_click,
				},
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "top",
					size = template.size,
					offset = {
						0,
						0,
						0,
					},
				},
			},
			{
				pass_type = "rect",
				style_id = "selection",
				style = {
					horizontal_alignment = "left",
					vertical_alignment = "top",
					default_color = Color.terminal_text_body_dark(255, true),
					selected_color = Color.terminal_text_header_selected(255, true),
					hover_color = Color.terminal_text_body(255, true),
					size = template.size,
				},
				change_function = function (content, style)
					local hotspot = content.hotspot
					local is_selected = hotspot.is_selected
					local is_focused = hotspot.is_focused
					local is_hover = hotspot.is_hover
					local default_color = style.default_color
					local hover_color = style.hover_color
					local selected_color = style.selected_color
					local color

					if (is_selected or is_focused) and selected_color then
						color = selected_color
					elseif is_hover and hover_color then
						color = hover_color
					elseif default_color then
						color = default_color
					end

					if color then
						ColorUtilities.color_copy(color, style.color)
					end
				end,
			},
		}
	end,
	size = {
		30,
		10,
	},
	init = function (parent, widget, index)
		return
	end,
}
local anim_start_delay = 0
local animations = {
	on_enter = {
		{
			end_time = 0,
			name = "init",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local alpha_multiplier = 0

				parent._animated_alpha_multiplier = alpha_multiplier

				if params.additional_widgets then
					for i = 1, #params.additional_widgets do
						local widget = params.additional_widgets[i]

						widget.alpha_multiplier = alpha_multiplier
					end
				end

				widgets.edge_top.style.texture.size[1] = widgets.popup_background.style.terminal.size[1]
				widgets.edge_bottom.style.texture.size[1] = widgets.popup_background.style.terminal.size[1]

				local popup_type = "default"

				if parent._popup_type then
					for name, _ in pairs(popup_type_style) do
						if parent._popup_type == name then
							popup_type = name

							break
						end
					end
				end

				widgets.popup_background.style.texture.color = popup_type_style[popup_type].background_color
				widgets.popup_background.style.terminal.color = popup_type_style[popup_type].terminal_background_color
				widgets.next_button.alpha_multiplier = 0
				widgets.close_button.alpha_multiplier = 0
			end,
		},
		{
			name = "open",
			start_time = anim_start_delay + 0,
			end_time = anim_start_delay + 0.3,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				parent._animated_alpha_multiplier = anim_progress

				local popup_height = params.popup_height
				local window_height = popup_height * anim_progress
				local background_height = widgets.popup_background.style.texture.size[2]
				local background_limit = math.min(popup_height, background_height)
				local normalized_end_height = background_limit / background_height
				local uv_v_mid_value = normalized_end_height * 0.5

				widgets.popup_background.style.texture.size_addition[2] = -background_height + background_limit * anim_progress
				widgets.popup_background.style.texture.uvs[1][2] = uv_v_mid_value - uv_v_mid_value * anim_progress
				widgets.popup_background.style.texture.uvs[2][2] = uv_v_mid_value + uv_v_mid_value * anim_progress
				widgets.popup_background.style.terminal.size_addition[2] = window_height + anim_progress * 26
				widgets.edge_bottom.offset[2] = window_height * 0.5
				widgets.edge_top.offset[2] = -window_height * 0.5
			end,
		},
		{
			name = "fade_in",
			start_time = anim_start_delay + 0.2,
			end_time = anim_start_delay + 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				if params.additional_widgets then
					for i = 1, #params.additional_widgets do
						local widget = params.additional_widgets[i]

						widget.alpha_multiplier = anim_progress
					end
				end

				widgets.close_button.alpha_multiplier = anim_progress
				widgets.next_button.alpha_multiplier = anim_progress
			end,
		},
	},
	on_exit = {
		{
			name = "fade_out",
			start_time = anim_start_delay + 0,
			end_time = anim_start_delay + 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeInCubic(1 - progress)

				if params.additional_widgets then
					for i = 1, #params.additional_widgets do
						local widget = params.additional_widgets[i]

						widget.alpha_multiplier = anim_progress
					end
				end

				widgets.close_button.alpha_multiplier = anim_progress
				widgets.next_button.alpha_multiplier = anim_progress
			end,
		},
		{
			name = "close",
			start_time = anim_start_delay + 0.2,
			end_time = anim_start_delay + 0.4,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeInCubic(1 - progress)

				parent._animated_alpha_multiplier = anim_progress

				local popup_height = params.popup_height
				local window_height = popup_height * anim_progress
				local background_height = widgets.popup_background.style.texture.size[2]
				local background_limit = math.min(popup_height, background_height)
				local normalized_end_height = background_limit / background_height
				local uv_v_mid_value = normalized_end_height * 0.5

				widgets.popup_background.style.texture.size_addition[2] = -background_height + background_limit * anim_progress
				widgets.popup_background.style.texture.uvs[1][2] = uv_v_mid_value - uv_v_mid_value * anim_progress
				widgets.popup_background.style.texture.uvs[2][2] = uv_v_mid_value + uv_v_mid_value * anim_progress
				widgets.popup_background.style.terminal.size_addition[2] = window_height + anim_progress * 26
				widgets.edge_bottom.offset[2] = window_height * 0.5
				widgets.edge_top.offset[2] = -window_height * 0.5
			end,
		},
	},
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	slide_selector = slide_selector,
}
