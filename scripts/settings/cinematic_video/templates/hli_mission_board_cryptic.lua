-- chunkname: @scripts/settings/cinematic_video/templates/hli_mission_board_cryptic.lua

local cinematic_video_template = {
	hli_mission_board_cryptic = {
		loop_video = false,
		music = "cinematic_pot",
		start_sound_name = "wwise/events/cinematics/play_cs_hli_mission_board_bink_cryptic_surround",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_hli_mission_board_bink_cryptic_surround",
		video_name = "content/videos/hli_mission_board",
		packages = {
			"packages/content/videos/hli_mission_board",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_mission_terminal_a_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 3.682,
				subtitle_start = 2.985,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_mission_terminal_b_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 3.484,
				subtitle_start = 7.489,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_mission_terminal_c_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 4.28,
				subtitle_start = 12.018,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_mission_terminal_d_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 4.653,
				subtitle_start = 17.891,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_mission_terminal_e_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 4.181,
				subtitle_start = 23.066,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_mission_terminal_f_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 3.881,
				subtitle_start = 28.516,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_mission_terminal_g_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 4.579,
				subtitle_start = 34.761,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_mission_terminal_h_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 7.116,
				subtitle_start = 40.186,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_mission_terminal_i_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 3.385,
				subtitle_start = 48.372,
			},
		},
		post_video_action = {
			action_type = "open_hub_view",
			view_name = "mission_board_view",
		},
	},
}

return cinematic_video_template
