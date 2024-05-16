-- chunkname: @scripts/settings/cinematic_video/templates/hli_contracts.lua

local cinematic_video_template = {
	hli_contracts = {
		loop_video = false,
		music = "cinematic_pot",
		start_sound_name = "wwise/events/cinematics/play_cs_hli_contracts_bink_surround",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_hli_contracts_bink_surround",
		video_name = "content/videos/hli_contracts",
		packages = {
			"packages/content/videos/hli_contracts",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_c_01",
				speaker_name = "explicator_a",
				subtitle_duration = 5.30805,
				subtitle_start = 8.344,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_d_01",
				speaker_name = "explicator_a",
				subtitle_duration = 1.075,
				subtitle_start = 14.807,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_e_01",
				speaker_name = "explicator_a",
				subtitle_duration = 2.595,
				subtitle_start = 16.234,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_f_01",
				speaker_name = "explicator_a",
				subtitle_duration = 10.698,
				subtitle_start = 22.853,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_g_01",
				speaker_name = "explicator_a",
				subtitle_duration = 4.814,
				subtitle_start = 42.701,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_h_01",
				speaker_name = "explicator_a",
				subtitle_duration = 4.081,
				subtitle_start = 47.866,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_i_01",
				speaker_name = "explicator_a",
				subtitle_duration = 1.466,
				subtitle_start = 52.419,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_j_01",
				speaker_name = "explicator_a",
				subtitle_duration = 1.604,
				subtitle_start = 54.517,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_k_01",
				speaker_name = "explicator_a",
				subtitle_duration = 1.525,
				subtitle_start = 56.718,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__hub_intro_contracts_l_01",
				speaker_name = "explicator_a",
				subtitle_duration = 4.16,
				subtitle_start = 61.807,
			},
		},
		post_video_action = {
			action_type = "open_hub_view",
			view_name = "contracts_background_view",
		},
	},
}

return cinematic_video_template
