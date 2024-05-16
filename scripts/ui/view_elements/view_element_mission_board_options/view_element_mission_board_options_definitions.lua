-- chunkname: @scripts/ui/view_elements/view_element_mission_board_options/view_element_mission_board_options_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
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
	options_area = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			1400,
			600,
		},
		position = {
			0,
			0,
			1,
		},
	},
	options_title = {
		horizontal_alignment = "center",
		parent = "options_area",
		vertical_alignment = "top",
		size = {
			1400,
			50,
		},
		position = {
			0,
			-70,
			5,
		},
	},
	options_grid = {
		horizontal_alignment = "left",
		parent = "options_area",
		vertical_alignment = "center",
		size = {
			850,
			550,
		},
		position = {
			0,
			0,
			5,
		},
	},
	options_grid_content_pivot = {
		horizontal_alignment = "left",
		parent = "options_grid",
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
	options_grid_scrollbar = {
		horizontal_alignment = "right",
		parent = "options_grid",
		vertical_alignment = "top",
		size = {
			8,
			550,
		},
		position = {
			30,
			0,
			2,
		},
	},
	options_grid_interaction = {
		horizontal_alignment = "left",
		parent = "options_grid",
		vertical_alignment = "top",
		size = {
			850,
			550,
		},
		position = {
			0,
			0,
			2,
		},
	},
	options_grid_mask = {
		horizontal_alignment = "center",
		parent = "options_grid",
		vertical_alignment = "center",
		size = {
			870,
			570,
		},
		position = {
			0,
			0,
			1,
		},
	},
	tooltip = {
		horizontal_alignment = "right",
		parent = "options_area",
		vertical_alignment = "top",
		size = {
			400,
			520,
		},
		position = {
			0,
			40,
			200,
		},
	},
	button_pivot = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = ButtonPassTemplates.terminal_button.size,
		position = {
			0,
			330,
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

local tooltip_text_style = table.clone(UIFontSettings.body)

tooltip_text_style.text_horizontal_alignment = "left"
tooltip_text_style.text_vertical_alignment = "top"
tooltip_text_style.horizontal_alignment = "left"
tooltip_text_style.vertical_alignment = "center"
tooltip_text_style.color = Color.white(255, true)
tooltip_text_style.offset = {
	0,
	0,
	2,
}

local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.black(76.5, true),
			},
		},
	}, "screen"),
	options_grid_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, "options_grid_scrollbar"),
	options_grid_interaction = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
		},
	}, "options_grid_interaction"),
	options_grid_mask = UIWidget.create_definition({
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
	}, "options_grid_mask"),
	popup_background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					nil,
					0,
				},
				size_addition = {
					0,
					-26,
				},
				color = Color.black(178.5, true),
			},
		},
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
	title_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value_id = "text",
			value = Managers.localization:localize("loc_settings_menu_header"),
			style = title_style,
		},
	}, "options_title"),
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
	button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "button_pivot", {
		alpha_multiplier = 0,
		gamepad_action = "back",
		original_text = Localize("loc_popup_button_close"),
		hotspot = {
			use_is_focused = true,
		},
	}),
	tooltip = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					1,
				},
				color = Color.black(120, true),
				size_addition = {
					50,
					50,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = tooltip_text_style,
		},
	}, "tooltip", {
		visible = false,
	}),
	settings_overlay = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					20,
				},
				color = {
					160,
					0,
					0,
					0,
				},
			},
		},
	}, "screen"),
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
				widgets.button.alpha_multiplier = 0
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
				widgets.popup_background.style.background.size[2] = window_height + anim_progress * 26
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

				widgets.button.alpha_multiplier = anim_progress
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

				widgets.button.alpha_multiplier = anim_progress
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
				widgets.popup_background.style.background.size[2] = window_height + anim_progress * 26
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
}
