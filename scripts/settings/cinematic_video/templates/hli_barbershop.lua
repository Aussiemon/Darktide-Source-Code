-- chunkname: @scripts/settings/cinematic_video/templates/hli_barbershop.lua

local cinematic_video_template = {
	hli_barbershop = {
		loop_video = false,
		music = "cinematic_pot",
		video_name = "content/videos/hli_barbershop",
		stop_only_player_skip = true,
		start_sound_name = "wwise/events/cinematics/play_cs_hli_barber_shop_bink_surround",
		stop_sound_name = "wwise/events/cinematics/stop_cs_hli_barber_shop_bink_surround",
		packages = {
			"packages/content/videos/hli_barbershop"
		},
		subtitles = {
			{
				subtitle_duration = 4.015714,
				currently_playing_subtitle = "loc_barber_a__hub_intro_barber_a_01",
				speaker_name = "barber_a",
				subtitle_start = 1.586
			},
			{
				subtitle_duration = 8.729932,
				currently_playing_subtitle = "loc_barber_a__hub_intro_barber_b_01",
				speaker_name = "barber_a",
				subtitle_start = 6.736
			},
			{
				subtitle_duration = 5.759002,
				currently_playing_subtitle = "loc_barber_a__hub_intro_barber_c_01",
				speaker_name = "barber_a",
				subtitle_start = 26.037
			},
			{
				subtitle_duration = 6.59381,
				currently_playing_subtitle = "loc_barber_a__hub_intro_barber_d_01",
				speaker_name = "barber_a",
				subtitle_start = 33.046
			},
			{
				subtitle_duration = 7.625034,
				currently_playing_subtitle = "loc_barber_a__hub_intro_barber_e_01",
				speaker_name = "barber_a",
				subtitle_start = 43.338
			},
			{
				subtitle_duration = 3.416213,
				currently_playing_subtitle = "loc_barber_a__hub_intro_barber_f_01",
				speaker_name = "barber_a",
				subtitle_start = 58.386
			},
			{
				subtitle_duration = 4.447778,
				currently_playing_subtitle = "loc_barber_a__hub_intro_barber_g_01",
				speaker_name = "barber_a",
				subtitle_start = 63.828
			}
		},
		post_video_action = {
			view_name = "barber_vendor_background_view",
			action_type = "open_hub_view"
		}
	}
}

return cinematic_video_template
