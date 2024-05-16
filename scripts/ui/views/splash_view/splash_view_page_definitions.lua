-- chunkname: @scripts/ui/views/splash_view/splash_view_page_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local splash_definitions = {
	{
		{
			exit_sound_name = "wwise/events/cinematics/stop_fatshark_splash",
			sound_name = "wwise/events/cinematics/play_fatshark_splash",
			type = "video",
			video_name = "content/videos/fatshark_splash",
		},
		duration = 18,
	},
	{
		{
			horizontal_alignment = "center",
			type = "texture",
			value = "content/ui/materials/symbols/logos/games_workshop_warhammer_logo_white",
			vertical_alignment = "center",
			position = {
				0,
				-100,
				11,
			},
			size = {
				510.5,
				497,
			},
		},
		{
			horizontal_alignment = "center",
			type = "text",
			value = "loc_splash_view_games_workshop_warhammer_description",
			vertical_alignment = "center",
			position = {
				0,
				400,
				801,
			},
			size = {
				1500,
				50,
			},
			style = {
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				font_type = UIFontSettings.body.font_type,
				font_size = UIFontSettings.body.font_size,
				text_color = UIFontSettings.body.text_color,
			},
		},
		duration = 5,
	},
	{
		{
			horizontal_alignment = "center",
			type = "texture",
			value = "content/ui/materials/backgrounds/splash_screen_partner_logos",
			vertical_alignment = "center",
			position = {
				0,
				0,
				11,
			},
			size = {
				1920,
				1080,
			},
		},
		duration = 5,
	},
	{
		{
			horizontal_alignment = "center",
			type = "rect",
			vertical_alignment = "center",
			position = {
				0,
				-165,
				11,
			},
			size = {
				1500,
				3,
			},
			color = UIFontSettings.body.text_color,
		},
		{
			horizontal_alignment = "center",
			type = "text",
			value = "loc_splash_view_photosensitivity_epileptic_seizures_title",
			vertical_alignment = "center",
			position = {
				0,
				20,
				11,
			},
			size = {
				1500,
				500,
			},
			style = {
				text_horizontal_alignment = "left",
				text_vertical_alignment = "top",
				font_type = UIFontSettings.header_1.font_type,
				font_size = UIFontSettings.header_1.font_size,
				text_color = UIFontSettings.body.text_color,
			},
		},
		{
			horizontal_alignment = "center",
			type = "text",
			value = "loc_splash_view_photosensitivity_epileptic_seizures_description",
			vertical_alignment = "center",
			position = {
				0,
				110,
				801,
			},
			size = {
				1500,
				500,
			},
			style = {
				line_spacing = 1.6,
				text_horizontal_alignment = "left",
				text_vertical_alignment = "top",
				font_type = UIFontSettings.body.font_type,
				font_size = UIFontSettings.header_3.font_size,
				text_color = UIFontSettings.body.text_color,
			},
		},
		duration = 5,
	},
	{
		{
			exit_sound_name = "wwise/events/cinematics/stop_intro_cinematic_surround",
			sound_name = "wwise/events/cinematics/play_intro_cinematic_surround",
			type = "video",
			video_name = "content/videos/darktide_world_intro",
			size = {
				1920,
				816,
			},
			position = {
				0,
				132,
				0,
			},
		},
		duration = 165,
		hold_to_skip = true,
		two_step_skip = true,
		visibility_function = function (parent)
			local value = Application.user_setting("interface_settings", "intro_cinematic_enabled")

			if value ~= nil then
				return value
			end

			return true
		end,
	},
	{
		duration = 1,
	},
}
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_cutscene_skip_no_input",
		input_action = "skip_cinematic_hold",
		key = "hold_skip",
		on_pressed_callback = "on_hold_skip_pressed",
		use_mouse_hold = true,
		visibility_function = function (parent)
			return parent._hold_to_skip
		end,
	},
}
local total_duration = 0

for i = 1, #splash_definitions do
	total_duration = total_duration + splash_definitions[i].duration or 0
end

return {
	time_between_pages = 1,
	pages = splash_definitions,
	duration = total_duration,
	legend_inputs = legend_inputs,
}
