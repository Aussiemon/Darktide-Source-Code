local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local splash_definitions = {
	{
		{
			video_name = "content/videos/fatshark_splash",
			sound_name = "wwise/events/cinematics/play_fatshark_splash",
			exit_sound_name = "wwise/events/cinematics/stop_fatshark_splash",
			type = "video"
		},
		duration = 18
	},
	{
		{
			vertical_alignment = "center",
			type = "texture",
			value = "content/ui/materials/symbols/logos/games_workshop_warhammer_logo_white",
			horizontal_alignment = "center",
			position = {
				0,
				-100,
				11
			},
			size = {
				510.5,
				497
			}
		},
		{
			vertical_alignment = "center",
			type = "text",
			value = "loc_splash_view_games_workshop_warhammer_description",
			horizontal_alignment = "center",
			position = {
				0,
				400,
				801
			},
			size = {
				1500,
				50
			},
			style = {
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				font_type = UIFontSettings.body.font_type,
				font_size = UIFontSettings.body.font_size,
				text_color = UIFontSettings.body.text_color
			}
		},
		duration = 5
	},
	{
		{
			vertical_alignment = "center",
			type = "rect",
			horizontal_alignment = "center",
			position = {
				0,
				-165,
				11
			},
			size = {
				1500,
				3
			},
			color = UIFontSettings.body.text_color
		},
		{
			vertical_alignment = "center",
			type = "text",
			value = "loc_splash_view_photosensitivity_epileptic_seizures_title",
			horizontal_alignment = "center",
			position = {
				0,
				20,
				11
			},
			size = {
				1500,
				500
			},
			style = {
				text_vertical_alignment = "top",
				text_horizontal_alignment = "left",
				font_type = UIFontSettings.header_1.font_type,
				font_size = UIFontSettings.header_1.font_size,
				text_color = UIFontSettings.body.text_color
			}
		},
		{
			vertical_alignment = "center",
			type = "text",
			value = "loc_splash_view_photosensitivity_epileptic_seizures_description",
			horizontal_alignment = "center",
			position = {
				0,
				110,
				801
			},
			size = {
				1500,
				500
			},
			style = {
				line_spacing = 1.6,
				text_vertical_alignment = "top",
				text_horizontal_alignment = "left",
				font_type = UIFontSettings.body.font_type,
				font_size = UIFontSettings.header_3.font_size,
				text_color = UIFontSettings.body.text_color
			}
		},
		duration = 5
	},
	{
		{
			video_name = "content/videos/darktide_world_intro",
			sound_name = "wwise/events/cinematics/play_intro_cinematic_surround",
			type = "video",
			exit_sound_name = "wwise/events/cinematics/stop_intro_cinematic_surround",
			size = {
				1920,
				816
			},
			position = {
				0,
				132,
				0
			}
		},
		two_step_skip = true,
		duration = 165
	},
	{
		duration = 1
	}
}
local legend_inputs = {
	{
		input_action = "skip_cinematic",
		display_name = "loc_continue",
		alignment = "left_alignment",
		on_pressed_callback = "on_skip_pressed",
		visibility_function = function (parent)
			return parent._show_skip
		end
	}
}
local total_duration = 0

for i = 1, #splash_definitions do
	total_duration = total_duration + splash_definitions[i].duration or 0
end

return {
	time_between_pages = 1,
	pages = splash_definitions,
	duration = total_duration,
	legend_inputs = legend_inputs
}
