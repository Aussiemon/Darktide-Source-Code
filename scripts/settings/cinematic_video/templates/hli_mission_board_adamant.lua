-- chunkname: @scripts/settings/cinematic_video/templates/hli_mission_board_adamant.lua

local cinematic_video_template = {
	hli_mission_board_adamant = {
		loop_video = false,
		music = "cinematic_pot",
		start_sound_name = "wwise/events/cinematics/play_cs_hli_mission_board_bink_arbites_surround",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_hli_mission_board_bink_arbites_surround",
		video_name = "content/videos/hli_mission_board",
		packages = {
			"packages/content/videos/hli_mission_board",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_a_01",
				speaker_name = "adamant_officer_a",
				subtitle_duration = 6.75,
				subtitle_start = 3,
			},
			{
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_b_01",
				speaker_name = "adamant_officer_a",
				subtitle_duration = 4.83,
				subtitle_start = 10.04,
			},
			{
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_c_01",
				speaker_name = "adamant_officer_a",
				subtitle_duration = 5.69,
				subtitle_start = 15.3,
			},
			{
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_d_01",
				speaker_name = "adamant_officer_a",
				subtitle_duration = 3.64,
				subtitle_start = 23.15,
			},
			{
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_e_01",
				speaker_name = "adamant_officer_a",
				subtitle_duration = 6.46,
				subtitle_start = 27.96,
			},
			{
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_f_01",
				speaker_name = "adamant_officer_a",
				subtitle_duration = 4.48,
				subtitle_start = 34.81,
			},
			{
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_g_01",
				speaker_name = "adamant_officer_a",
				subtitle_duration = 2.11,
				subtitle_start = 39.33,
			},
			{
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_h_01",
				speaker_name = "adamant_officer_a",
				subtitle_duration = 6.12,
				subtitle_start = 41.61,
			},
			{
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_i_01",
				speaker_name = "adamant_officer_a",
				subtitle_duration = 2.79,
				subtitle_start = 48.38,
			},
		},
		post_video_action = {
			action_type = "open_hub_view",
			view_name = "mission_board_view",
		},
	},
}

return cinematic_video_template
