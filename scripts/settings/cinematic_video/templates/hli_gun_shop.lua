-- chunkname: @scripts/settings/cinematic_video/templates/hli_gun_shop.lua

local cinematic_video_template = {
	hli_gun_shop = {
		loop_video = false,
		music = "cinematic_pot",
		video_name = "content/videos/hli_gun_shop",
		stop_only_player_skip = true,
		start_sound_name = "wwise/events/cinematics/play_cs_hli_gun_shop_bink_surround",
		stop_sound_name = "wwise/events/cinematics/stop_cs_hli_gun_shop_bink_surround",
		packages = {
			"packages/content/videos/hli_gun_shop"
		},
		subtitles = {
			{
				subtitle_duration = 8.522834,
				currently_playing_subtitle = "loc_explicator_a__hub_intro_gun_shop_a_01",
				speaker_name = "explicator_a",
				subtitle_start = 15.325
			},
			{
				subtitle_duration = 8.436712,
				currently_playing_subtitle = "loc_explicator_a__hub_intro_gun_shop_b_01",
				speaker_name = "explicator_a",
				subtitle_start = 24.572
			},
			{
				subtitle_duration = 3.034444,
				currently_playing_subtitle = "loc_explicator_a__hub_intro_gun_shop_c_01",
				speaker_name = "explicator_a",
				subtitle_start = 34
			},
			{
				subtitle_duration = 6.22254,
				currently_playing_subtitle = "loc_explicator_a__hub_intro_gun_shop_d_01",
				speaker_name = "explicator_a",
				subtitle_start = 44.643
			},
			{
				subtitle_duration = 4.862245,
				currently_playing_subtitle = "loc_explicator_a__hub_intro_gun_shop_e_01",
				speaker_name = "explicator_a",
				subtitle_start = 51.851
			}
		},
		post_video_action = {
			view_name = "credits_vendor_background_view",
			action_type = "open_hub_view"
		}
	}
}

return cinematic_video_template
