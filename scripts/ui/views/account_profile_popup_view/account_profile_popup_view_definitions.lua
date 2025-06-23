-- chunkname: @scripts/ui/views/account_profile_popup_view/account_profile_popup_view_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local PopupStyles = require("scripts/ui/views/account_profile_popup_view/account_profile_popup_view_styles")
local popup_margin = PopupStyles.popup_margin
local info_margin = PopupStyles.info_margin
local scenegraph = {}

scenegraph.screen = UIWorkspaceSettings.screen
scenegraph.popup_area = {
	vertical_alignment = "center",
	parent = "screen",
	horizontal_alignment = "center",
	size = {
		scenegraph.screen.size[1],
		0
	},
	position = {
		0,
		0,
		1
	}
}
scenegraph.popup_content_area = {
	vertical_alignment = "top",
	parent = "popup_area",
	horizontal_alignment = "center",
	size = PopupStyles.popup_content_size,
	position = {
		0,
		0,
		1
	}
}
scenegraph.icon = {
	vertical_alignment = "top",
	parent = "popup_content_area",
	horizontal_alignment = "left",
	size = PopupStyles.icon_size,
	position = {
		0,
		popup_margin,
		1
	}
}
scenegraph.headline = {
	vertical_alignment = "top",
	parent = "popup_content_area",
	horizontal_alignment = "right",
	size = PopupStyles.headline.size,
	position = {
		0,
		info_margin,
		1
	}
}
scenegraph.information_area = {
	vertical_alignment = "top",
	parent = "popup_content_area",
	horizontal_alignment = "right",
	size = PopupStyles.info_area_size,
	position = {
		0,
		info_margin + scenegraph.headline.size[2],
		1
	}
}

local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			scenegraph_id = "screen",
			style_id = "screen_overlay",
			pass_type = "rect"
		},
		{
			pass_type = "rect",
			style_id = "background"
		},
		{
			pass_type = "rect",
			style_id = "top_border"
		},
		{
			pass_type = "rect",
			style_id = "bottom_border"
		}
	}, "popup_area", nil, nil, PopupStyles.background),
	headline = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style = PopupStyles.headline
		}
	}, "headline"),
	icon = UIWidget.create_definition({
		{
			pass_type = "texture",
			value_id = "icon"
		}
	}, "icon")
}
local widget_blueprints = {}
local animations = {
	open_view = {
		{
			name = "fade_in_background",
			end_time = 0.15,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				for _, widget in pairs(widgets) do
					widget.alpha_multiplier = 0
				end

				parent:_play_sound("wwise/events/ui/play_ui_popup_open")
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local background_widget = widgets.background

				background_widget.alpha_multiplier = progress
			end
		},
		{
			name = "resize_background",
			end_time = 0.4,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				params.start_height = ui_scenegraph.popup_area.size[2]
				params.popup_area_height = ui_scenegraph.popup_content_area.size[2]
			end,
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
	close_view = {
		{
			name = "fade_out_widgets",
			end_time = 0.5,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				params.popup_area_height = ui_scenegraph.popup_content_area.size[2]
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
				parent:_play_sound("wwise/events/ui/play_ui_popup_close")
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = 1 - math.easeCubic(progress)

				ui_scenegraph.popup_area.size[2] = params.popup_area_height * anim_progress

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

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph,
	widget_blueprints = widget_blueprints
}
