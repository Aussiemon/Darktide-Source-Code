-- chunkname: @scripts/settings/cinematic_video/templates/hli_contracts.lua

local cinematic_video_template = {
	hli_contracts = {
		loop_video = false,
		music = "cinematic_pot",
		video_name = "content/videos/hli_contracts",
		stop_only_player_skip = true,
		start_sound_name = "wwise/events/cinematics/play_cs_hli_contracts_bink_surround",
		stop_sound_name = "wwise/events/cinematics/stop_cs_hli_contracts_bink_surround",
		packages = {
			"packages/content/videos/hli_contracts"
		},
		subtitles = {
			{
				subtitle_duration = 5.30805,
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_c_01",
				speaker_name = "explicator_a",
				subtitle_start = 8.344
			},
			{
				subtitle_duration = 1.075,
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_d_01",
				speaker_name = "explicator_a",
				subtitle_start = 14.807
			},
			{
				subtitle_duration = 2.595,
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_e_01",
				speaker_name = "explicator_a",
				subtitle_start = 16.234
			},
			{
				subtitle_duration = 10.698,
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_f_01",
				speaker_name = "explicator_a",
				subtitle_start = 22.853
			},
			{
				subtitle_duration = 4.814,
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_g_01",
				speaker_name = "explicator_a",
				subtitle_start = 42.701
			},
			{
				subtitle_duration = 4.081,
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_h_01",
				speaker_name = "explicator_a",
				subtitle_start = 47.866
			},
			{
				subtitle_duration = 1.466,
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_i_01",
				speaker_name = "explicator_a",
				subtitle_start = 52.419
			},
			{
				subtitle_duration = 1.604,
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_j_01",
				speaker_name = "explicator_a",
				subtitle_start = 54.517
			},
			{
				subtitle_duration = 1.525,
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_k_01",
				speaker_name = "explicator_a",
				subtitle_start = 56.718
			},
			{
				subtitle_duration = 4.16,
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_l_01",
				speaker_name = "explicator_a",
				subtitle_start = 61.807
			}
		},
		post_video_action = {
			view_name = "contracts_background_view",
			action_type = "open_hub_view"
		}
	}
}

return cinematic_video_template
