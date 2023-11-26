-- chunkname: @scripts/settings/cinematic_video/templates/hli_mission_board.lua

local cinematic_video_template = {
	hli_mission_board = {
		loop_video = false,
		music = "cinematic_pot",
		video_name = "content/videos/hli_mission_board",
		stop_only_player_skip = true,
		start_sound_name = "wwise/events/cinematics/play_cs_hli_mission_board_bink_surround",
		stop_sound_name = "wwise/events/cinematics/stop_cs_hli_mission_board_bink_surround",
		packages = {
			"packages/content/videos/hli_mission_board"
		},
		subtitles = {
			{
				subtitle_duration = 2.639365,
				currently_playing_subtitle = "loc_sergeant_a__hub_intro_mission_terminal_a_01",
				speaker_name = "sergeant_a",
				subtitle_start = 2.892
			},
			{
				subtitle_duration = 3.959048,
				currently_playing_subtitle = "loc_sergeant_a__hub_intro_mission_terminal_b_01",
				speaker_name = "sergeant_a",
				subtitle_start = 6.03
			},
			{
				subtitle_duration = 1,
				currently_playing_subtitle = "loc_sergeant_a__hub_intro_mission_terminal_c_01",
				speaker_name = "sergeant_a",
				subtitle_start = 10.368
			},
			{
				subtitle_duration = 5.620771,
				currently_playing_subtitle = "loc_sergeant_a__hub_intro_mission_terminal_d_01",
				speaker_name = "sergeant_a",
				subtitle_start = 13.718
			},
			{
				subtitle_duration = 2.765011,
				currently_playing_subtitle = "loc_sergeant_a__hub_intro_mission_terminal_e_01",
				speaker_name = "sergeant_a",
				subtitle_start = 23.422
			},
			{
				subtitle_duration = 4.476213,
				currently_playing_subtitle = "loc_sergeant_a__hub_intro_mission_terminal_f_01",
				speaker_name = "sergeant_a",
				subtitle_start = 27.007
			},
			{
				subtitle_duration = 5.014989,
				currently_playing_subtitle = "loc_sergeant_a__hub_intro_mission_terminal_g_01",
				speaker_name = "sergeant_a",
				subtitle_start = 32.185
			},
			{
				subtitle_duration = 2.482426,
				currently_playing_subtitle = "loc_sergeant_a__hub_intro_mission_terminal_h_01",
				speaker_name = "sergeant_a",
				subtitle_start = 38.297
			},
			{
				subtitle_duration = 2.413311,
				currently_playing_subtitle = "loc_sergeant_a__hub_intro_mission_terminal_i_01",
				speaker_name = "sergeant_a",
				subtitle_start = 43.598
			},
			{
				subtitle_duration = 3.881156,
				currently_playing_subtitle = "loc_sergeant_a__hub_intro_mission_terminal_j_01",
				speaker_name = "sergeant_a",
				subtitle_start = 46.994
			}
		},
		post_video_action = {
			view_name = "mission_board_view",
			action_type = "open_hub_view"
		}
	}
}

return cinematic_video_template
