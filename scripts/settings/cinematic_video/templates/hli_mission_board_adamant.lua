-- chunkname: @scripts/settings/cinematic_video/templates/hli_mission_board_adamant.lua

local cinematic_video_template = {
	hli_mission_board_adamant = {
		loop_video = false,
		music = "cinematic_pot",
		video_name = "content/videos/hli_mission_board",
		stop_only_player_skip = true,
		start_sound_name = "wwise/events/cinematics/play_cs_hli_mission_board_bink_arbites_surround",
		stop_sound_name = "wwise/events/cinematics/stop_cs_hli_mission_board_bink_arbites_surround",
		packages = {
			"packages/content/videos/hli_mission_board"
		},
		subtitles = {
			{
				subtitle_duration = 6.75,
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_a_01",
				speaker_name = "adamant_officer_a",
				subtitle_start = 3
			},
			{
				subtitle_duration = 4.83,
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_b_01",
				speaker_name = "adamant_officer_a",
				subtitle_start = 10.04
			},
			{
				subtitle_duration = 5.69,
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_c_01",
				speaker_name = "adamant_officer_a",
				subtitle_start = 15.3
			},
			{
				subtitle_duration = 3.64,
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_d_01",
				speaker_name = "adamant_officer_a",
				subtitle_start = 23.15
			},
			{
				subtitle_duration = 6.46,
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_e_01",
				speaker_name = "adamant_officer_a",
				subtitle_start = 27.96
			},
			{
				subtitle_duration = 4.48,
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_f_01",
				speaker_name = "adamant_officer_a",
				subtitle_start = 34.81
			},
			{
				subtitle_duration = 2.11,
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_g_01",
				speaker_name = "adamant_officer_a",
				subtitle_start = 39.33
			},
			{
				subtitle_duration = 6.12,
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_h_01",
				speaker_name = "adamant_officer_a",
				subtitle_start = 41.61
			},
			{
				subtitle_duration = 2.79,
				currently_playing_subtitle = "loc_adamant_officer_a__hub_intro_mission_terminal_i_01",
				speaker_name = "adamant_officer_a",
				subtitle_start = 48.38
			}
		},
		post_video_action = {
			view_name = "mission_board_view",
			action_type = "open_hub_view"
		}
	}
}

return cinematic_video_template
