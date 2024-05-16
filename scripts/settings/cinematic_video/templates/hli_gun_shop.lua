-- chunkname: @scripts/settings/cinematic_video/templates/hli_gun_shop.lua

local cinematic_video_template = {
	hli_gun_shop = {
		loop_video = false,
		music = "cinematic_pot",
		start_sound_name = "wwise/events/cinematics/play_cs_hli_gun_shop_bink_surround",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_hli_gun_shop_bink_surround",
		video_name = "content/videos/hli_gun_shop",
		packages = {
			"packages/content/videos/hli_gun_shop",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_explicator_a__hub_intro_gun_shop_a_01",
				speaker_name = "explicator_a",
				subtitle_duration = 8.522834,
				subtitle_start = 15.325,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__hub_intro_gun_shop_b_01",
				speaker_name = "explicator_a",
				subtitle_duration = 8.436712,
				subtitle_start = 24.572,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__hub_intro_gun_shop_c_01",
				speaker_name = "explicator_a",
				subtitle_duration = 3.034444,
				subtitle_start = 34,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__hub_intro_gun_shop_d_01",
				speaker_name = "explicator_a",
				subtitle_duration = 6.22254,
				subtitle_start = 44.643,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__hub_intro_gun_shop_e_01",
				speaker_name = "explicator_a",
				subtitle_duration = 4.862245,
				subtitle_start = 51.851,
			},
		},
		post_video_action = {
			action_type = "open_hub_view",
			view_name = "credits_vendor_background_view",
		},
	},
}

return cinematic_video_template
