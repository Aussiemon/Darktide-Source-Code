-- chunkname: @scripts/ui/views/splash_video_view/splash_video_view_settings.lua

local SplashVideoViewSettings = {
	viewport_layer = 1,
	level_name = "content/levels/ui/video_view/video_view",
	timer_name = "ui",
	world_layer = 1,
	viewport_type = "default",
	viewport_name = "ui_video_view_world_viewport",
	world_name = "ui_video_view_world",
	darktide_world_intro_subtitles = {
		{
			subtitle_duration = 2.45,
			currently_playing_subtitle = "loc_shipmistress_a__world_intro_01",
			speaker_name = "shipmistress_a",
			subtitle_start = 7.15
		},
		{
			subtitle_duration = 5.6,
			currently_playing_subtitle = "loc_shipmistress_a__world_intro_02",
			speaker_name = "shipmistress_a",
			subtitle_start = 11.3
		},
		{
			subtitle_duration = 1.8,
			currently_playing_subtitle = "loc_shipmistress_a__world_intro_03",
			speaker_name = "shipmistress_a",
			subtitle_start = 21.5
		},
		{
			subtitle_duration = 12.2,
			currently_playing_subtitle = "loc_shipmistress_a__world_intro_04",
			speaker_name = "shipmistress_a",
			subtitle_start = 29.52
		},
		{
			subtitle_duration = 6.3,
			currently_playing_subtitle = "loc_shipmistress_a__world_intro_05",
			speaker_name = "shipmistress_a",
			subtitle_start = 44.9
		},
		{
			subtitle_duration = 11.6,
			currently_playing_subtitle = "loc_shipmistress_a__world_intro_06",
			speaker_name = "shipmistress_a",
			subtitle_start = 51.98
		},
		{
			subtitle_duration = 1.9,
			currently_playing_subtitle = "loc_shipmistress_a__world_intro_07",
			speaker_name = "shipmistress_a",
			subtitle_start = 70.65
		},
		{
			subtitle_duration = 2.4,
			currently_playing_subtitle = "loc_shipmistress_a__world_intro_08",
			speaker_name = "shipmistress_a",
			subtitle_start = 73.15
		},
		{
			subtitle_duration = 3,
			currently_playing_subtitle = "loc_vocator_a__world_intro_09",
			speaker_name = "vocator_a",
			subtitle_start = 76.85
		},
		{
			subtitle_duration = 3.4,
			currently_playing_subtitle = "loc_shipmistress_a__world_intro_10",
			speaker_name = "shipmistress_a",
			subtitle_start = 103.39
		},
		{
			subtitle_duration = 4.4,
			currently_playing_subtitle = "loc_shipmistress_a__world_intro_11",
			speaker_name = "shipmistress_a",
			subtitle_start = 108.6
		},
		{
			subtitle_duration = 4,
			currently_playing_subtitle = "loc_shipmistress_a__world_intro_12_a",
			speaker_name = "shipmistress_a",
			subtitle_start = 114.4
		},
		{
			subtitle_duration = 4.1,
			currently_playing_subtitle = "loc_shipmistress_a__world_intro_12_b",
			speaker_name = "shipmistress_a",
			subtitle_start = 122.3
		},
		{
			subtitle_duration = 2.35,
			currently_playing_subtitle = "loc_shipmistress_a__world_intro_13",
			speaker_name = "shipmistress_a",
			subtitle_start = 127.65
		},
		{
			subtitle_duration = 1.5,
			currently_playing_subtitle = "loc_veteran_male_c__surrounded_07",
			speaker_name = "veteran_male_c",
			subtitle_start = 130.3
		},
		{
			subtitle_duration = 1.55,
			currently_playing_subtitle = "loc_veteran_male_a__surrounded_response_09",
			speaker_name = "veteran_male_a",
			subtitle_start = 131.9
		},
		{
			subtitle_duration = 0.9,
			currently_playing_subtitle = "loc_veteran_male_a__guidance_correct_doorway_01",
			speaker_name = "veteran_male_a",
			subtitle_start = 138.9
		},
		{
			subtitle_duration = 2.4,
			currently_playing_subtitle = "loc_shipmistress_a__world_intro_14",
			speaker_name = "shipmistress_a",
			subtitle_start = 145.92
		},
		{
			subtitle_duration = 0.69,
			currently_playing_subtitle = "loc_veteran_male_c__seen_enemy_specials_generic_05",
			speaker_name = "veteran_male_c",
			subtitle_start = 152.25
		},
		{
			subtitle_duration = 1.4,
			currently_playing_subtitle = "loc_shipmistress_a__world_intro_15",
			speaker_name = "shipmistress_a",
			subtitle_start = 152.95
		},
		{
			subtitle_duration = 2.8,
			currently_playing_subtitle = "loc_shipmistress_a__world_intro_16",
			speaker_name = "shipmistress_a",
			subtitle_start = 157.7
		}
	}
}

return settings("SplashVideoViewSettings", SplashVideoViewSettings)
