local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local Blueprints = require("scripts/ui/view_elements/view_element_player_social_popup/view_element_player_social_popup_blueprints")
local PopupStyles = require("scripts/ui/view_elements/view_element_player_social_popup/view_element_player_social_popup_styles")
local column_margin = PopupStyles.column_margin
local column_width = PopupStyles.column_width
local player_info_area_size = PopupStyles.player_info_area_size
local popup_area_height = PopupStyles.player_info_area_size[2] + column_margin[2] * 2
local screen = UIWorkspaceSettings.screen
local popup_area_background = {
	vertical_alignment = "center",
	scale = "fit_width",
	size = {
		screen.size[1],
		popup_area_height
	},
	position = {
		0,
		0,
		1
	}
}
local popup_area = {
	vertical_alignment = "center",
	parent = "screen",
	horizontal_alignment = "center",
	size = {
		screen.size[1],
		popup_area_height
	},
	position = {
		0,
		0,
		2
	}
}
local left_column = {
	vertical_alignment = "top",
	parent = "popup_area",
	horizontal_alignment = "left",
	size = {
		screen.size[1] / 2,
		popup_area_height
	},
	position = {
		0,
		0,
		1
	}
}
local right_column = {
	vertical_alignment = "top",
	parent = "popup_area",
	horizontal_alignment = "right",
	size = {
		screen.size[1] / 2,
		popup_area_height
	},
	position = {
		0,
		0,
		1
	}
}
local menu_area = {
	vertical_alignment = "top",
	parent = "right_column",
	horizontal_alignment = "left",
	size = {
		column_width,
		popup_area_height - column_margin[2] * 2
	},
	position = {
		column_margin[1],
		column_margin[2],
		1
	}
}
local player_info_area = {
	vertical_alignment = "top",
	parent = "left_column",
	horizontal_alignment = "right",
	size = player_info_area_size,
	position = {
		-column_margin[1],
		column_margin[2],
		1
	}
}
local player_info_header = {
	vertical_alignment = "top",
	parent = "player_info_area",
	horizontal_alignment = "right",
	size = PopupStyles.player_info_header_size,
	position = {
		0,
		0,
		1
	}
}
local scenegraph_definition = {
	screen = screen,
	popup_area_background = popup_area_background,
	popup_area = popup_area,
	left_column = left_column,
	right_column = right_column,
	menu_area = menu_area,
	player_info_area = player_info_area,
	player_info_header = player_info_header
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			style_id = "terminal",
			pass_type = "texture_uv"
		},
		{
			value = "content/ui/materials/backgrounds/popups/screen_takeover_02",
			style_id = "icon",
			pass_type = "texture_uv"
		},
		{
			value = "content/ui/materials/dividers/horizontal_dynamic_upper",
			style_id = "top_border",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/dividers/skull_rendered_center_01",
			style_id = "top_border_decoration",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/dividers/horizontal_dynamic_lower",
			style_id = "bottom_border",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/dividers/skull_rendered_center_02",
			style_id = "bottom_border_decoration",
			pass_type = "texture"
		}
	}, "popup_area_background", nil, nil, PopupStyles.background),
	player_header = UIWidget.create_definition({
		{
			style_id = "user_fatshark_id",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			style_id = "player_display_name",
			value_id = "player_display_name",
			pass_type = "text"
		},
		{
			style_id = "user_display_name",
			value_id = "user_display_name",
			pass_type = "text"
		},
		{
			style_id = "user_fatshark_id",
			value_id = "user_fatshark_id",
			pass_type = "text"
		},
		{
			style_id = "user_activity",
			value_id = "user_activity",
			pass_type = "text"
		},
		{
			value = "content/ui/materials/dividers/skull_rendered_left_01",
			style_id = "divider",
			pass_type = "texture"
		},
		{
			value = "content/ui/materials/base/ui_portrait_frame_base",
			value_id = "portrait",
			pass_type = "texture",
			style_id = "portrait"
		}
	}, "player_info_header", nil, nil, PopupStyles.player_header)
}
local animations = {
	open = {
		{
			name = "fade_in_background",
			end_time = 0.15,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = 0
				end

				parent:_play_sound(UISoundEvents.social_menu_popup_enter)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local background_widget = widgets.background
				background_widget.alpha_multiplier = progress
			end
		},
		{
			name = "resize_popup",
			end_time = 0.4,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local content_target_height = math.max(params.popup_content_height, player_info_area_size[2])
				local popup_target_height = content_target_height + column_margin[2] * 2
				ui_scenegraph.popup_area.size[2] = popup_target_height
				ui_scenegraph.menu_area.size[2] = content_target_height
				params.popup_area_height = popup_target_height
				local background_widget = widgets.background
				local background_style = background_widget.style.icon
				local background_full_height = background_style.full_size[2]
				local v_end_target = popup_target_height / background_full_height
				params.v_start = math.clamp01(v_end_target / 2)
				params.v_end_target = v_end_target
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local math_lerp = math.lerp
				local math_min = math.min
				local math_ease_cubic = math.easeCubic
				local anim_progress = math_ease_cubic(progress)
				local popup_height = math_lerp(params.start_height, params.popup_area_height, anim_progress)
				ui_scenegraph.popup_area_background.size[2] = popup_height
				local background_widget = widgets.background
				local background_style = background_widget.style.icon
				local background_terminal_style = background_widget.style.terminal
				local background_full_height = background_style.full_size[2]
				local v_start = params.v_start
				local v_end = params.v_end_target
				local v_start_progress = math_lerp(v_start, 0, anim_progress)
				local v_end_progress = math_min(math_lerp(v_start, v_end, anim_progress), 1)
				local background_height = background_full_height * (v_end_progress - v_start_progress)
				background_style.size[2] = background_height
				background_style.uvs[1][2] = v_start_progress
				background_style.uvs[2][2] = v_end_progress

				return true
			end
		},
		{
			name = "fade_in_widgets",
			end_time = 0.75,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeCubic(progress)

				for name, widget in pairs(widgets) do
					if name ~= "background" then
						widget.alpha_multiplier = anim_progress
					end
				end
			end
		}
	},
	close = {
		{
			name = "fade_out_widgets",
			end_time = 0.5,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent:_play_sound(UISoundEvents.social_menu_popup_exit)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = 1 - math.easeCubic(progress)

				for name, widget in pairs(widgets) do
					if name ~= "background" then
						widget.alpha_multiplier = anim_progress
					end
				end
			end
		},
		{
			name = "resize_background",
			end_time = 0.65,
			start_time = 0.25,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				local start_height = params.popup_content_height + column_margin[2] * 2
				params.popup_area_height = start_height
				local background_widget = widgets.background
				local background_style = background_widget.style.icon
				local background_full_height = background_style.full_size[2]
				local v_start = start_height / background_full_height
				params.v_start = v_start
				params.v_end_target = math.clamp01(v_start / 2)
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local math_lerp = math.lerp
				local math_min = math.min
				local math_ease_cubic = math.easeCubic
				local anim_progress = math_ease_cubic(progress)
				local popup_height = math_lerp(params.popup_area_height, 0, anim_progress)
				ui_scenegraph.popup_area_background.size[2] = popup_height
				local background_widget = widgets.background
				local background_style = background_widget.style.icon
				local background_terminal_style = background_widget.style.terminal
				local background_full_height = background_style.full_size[2]
				local v_start = params.v_start
				local v_end = params.v_end_target
				local v_start_progress = math_lerp(0, v_end, anim_progress)
				local v_end_progress = math_min(math_lerp(v_start, v_end, anim_progress), 1)
				local background_height = background_full_height * (v_end_progress - v_start_progress)
				background_style.size[2] = background_height
				background_style.uvs[1][2] = v_start_progress
				background_style.uvs[2][2] = v_end_progress

				return true
			end
		},
		{
			name = "fade_out_background",
			end_time = 0.65,
			start_time = 0.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local background_widget = widgets.background
				background_widget.alpha_multiplier = 1 - progress
			end
		}
	},
	fade_in_widgets = {
		{
			name = "resize_background",
			end_time = 0.4,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeCubic(progress)
				ui_scenegraph.popup_area.size[2] = math.lerp(params.start_height, params.popup_area_height, anim_progress)

				return true
			end
		},
		{
			name = "fade_in_widgets",
			end_time = 0.75,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeCubic(progress)

				for name, widget in pairs(widgets) do
					if name ~= "background" then
						widget.alpha_multiplier = anim_progress
					end
				end
			end
		}
	},
	fade_out_widgets = {
		{
			name = "fade_out_widgets",
			end_time = 0.75,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = 1 - math.easeCubic(progress)

				for name, widget in pairs(widgets) do
					if name ~= "background" then
						widget.alpha_multiplier = anim_progress
					end
				end
			end
		}
	}
}
local view_element_player_social_popup_style_definition = {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	blueprints = Blueprints
}

return settings("ViewElementPlayerSocialPopupDefinition", view_element_player_social_popup_style_definition)
