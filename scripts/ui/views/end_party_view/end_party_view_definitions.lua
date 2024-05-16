-- chunkname: @scripts/ui/views/end_party_view/end_party_view_definitions.lua

local DefaultPassTemplates = require("scripts/ui/pass_templates/default_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local panel_size = {
	340,
	60,
}
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
	timer_text = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			300,
			40,
		},
		position = {
			-20,
			20,
			1,
		},
	},
	panel_pivot = {
		horizontal_alignment = "top",
		parent = "screen",
		vertical_alignment = "left",
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
	panel = {
		horizontal_alignment = "center",
		parent = "panel_pivot",
		vertical_alignment = "center",
		size = panel_size,
		position = {
			0,
			0,
			1,
		},
	},
	sub_title_text = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			1200,
			40,
		},
		position = {
			0,
			68,
			0,
		},
	},
	sub_title_divider = {
		horizontal_alignment = "center",
		parent = "sub_title_text",
		vertical_alignment = "top",
		size = {
			240,
			15,
		},
		position = {
			0,
			40,
			1,
		},
	},
}
local title_text_font_setting_name = "nameplates"
local title_text_font_settings = UIFontSettings[title_text_font_setting_name]
local title_text_font_color = title_text_font_settings.text_color
local title_text_font_size = title_text_font_settings.font_size
local sub_title_text_font_style = table.clone(UIFontSettings.header_3)

sub_title_text_font_style.text_color = Color.ui_brown_light(255, true)
sub_title_text_font_style.text_vertical_alignment = "center"
sub_title_text_font_style.text_horizontal_alignment = "center"

local widget_definitions = {
	timer_text = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "00:00",
			value_id = "text",
			style = {
				text_horizontal_alignment = "right",
				text_vertical_alignment = "top",
				text_color = title_text_font_color,
				font_type = title_text_font_settings.font_type,
				font_size = title_text_font_size,
			},
		},
	}, "timer_text"),
}
local player_name_font_setting_name = "body"
local player_name_font_settings = UIFontSettings[player_name_font_setting_name]
local player_name_font_color = player_name_font_settings.text_color
local guild_name_font_setting_name = "end_of_round_nameplates_guild"
local guild_name_font_settings = UIFontSettings[guild_name_font_setting_name]
local guild_name_font_color = guild_name_font_settings.text_color
local icon_size = {
	panel_size[2],
	panel_size[2],
}
local panel_definition = UIWidget.create_definition({
	{
		content_id = "hotspot",
		pass_type = "hotspot",
	},
	{
		pass_type = "text",
		style_id = "player_name",
		value = "<player_name>",
		value_id = "player_name",
		style = {
			text_horizontal_alignment = "center",
			text_vertical_alignment = "top",
			offset = {
				0,
				5,
				2,
			},
			font_type = player_name_font_settings.font_type,
			font_size = player_name_font_settings.font_size,
			default_font_size = player_name_font_settings.font_size,
			text_color = player_name_font_color,
			default_text_color = player_name_font_color,
		},
	},
}, "panel")
local animations = {
	on_enter = {
		{
			end_time = 0.5,
			name = "fade_in",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				parent._render_settings.alpha_multiplier = 0
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeOutCubic(progress)

				parent._render_settings.alpha_multiplier = anim_progress
			end,
		},
	},
}

return {
	animations = animations,
	panel_definition = panel_definition,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
