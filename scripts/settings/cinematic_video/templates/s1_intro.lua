-- chunkname: @scripts/settings/cinematic_video/templates/s1_intro.lua

local cinematic_video_template = {
	s1_intro = {
		loop_video = false,
		music = "cinematic_pot",
		video_name = "content/videos/s1_intro",
		stop_only_player_skip = true,
		start_sound_name = "wwise/events/cinematics/play_traitors_in_tertium_cinematic_surround",
		stop_sound_name = "wwise/events/cinematics/stop_traitors_in_tertium_cinematic_surround",
		packages = {
			"packages/content/videos/s1_intro"
		},
		subtitles = {
			{
				subtitle_duration = 7.571,
				currently_playing_subtitle = "loc_enemy_nemesis_wolfer_a__wolfer_speech_a_01",
				speaker_name = "enemy_nemesis_wolfer_a",
				subtitle_start = 23.765
			},
			{
				subtitle_duration = 5.39,
				currently_playing_subtitle = "loc_enemy_nemesis_wolfer_a__wolfer_speech_b_01",
				speaker_name = "enemy_nemesis_wolfer_a",
				subtitle_start = 32.546
			},
			{
				subtitle_duration = 4.83,
				currently_playing_subtitle = "loc_enemy_nemesis_wolfer_a__wolfer_speech_c_01",
				speaker_name = "enemy_nemesis_wolfer_a",
				subtitle_start = 40.127
			},
			{
				subtitle_duration = 4.713,
				currently_playing_subtitle = "loc_enemy_nemesis_wolfer_a__wolfer_speech_d_01",
				speaker_name = "enemy_nemesis_wolfer_a",
				subtitle_start = 45.917
			},
			{
				subtitle_duration = 5.54,
				currently_playing_subtitle = "loc_enemy_nemesis_wolfer_a__wolfer_speech_e_01",
				speaker_name = "enemy_nemesis_wolfer_a",
				subtitle_start = 51.587
			},
			{
				subtitle_duration = 6.7,
				currently_playing_subtitle = "loc_enemy_nemesis_wolfer_a__wolfer_speech_f_01",
				speaker_name = "enemy_nemesis_wolfer_a",
				subtitle_start = 58.269
			},
			{
				subtitle_duration = 3.39,
				currently_playing_subtitle = "loc_enemy_nemesis_wolfer_a__wolfer_speech_g_01",
				speaker_name = "enemy_nemesis_wolfer_a",
				subtitle_start = 65.759
			},
			{
				subtitle_duration = 1.895,
				currently_playing_subtitle = "loc_sergeant_a__wolfer_speech_h_01",
				speaker_name = "sergeant_a",
				subtitle_start = 69.7
			},
			{
				subtitle_duration = 7.375,
				currently_playing_subtitle = "loc_sergeant_a__wolfer_speech_i_01",
				speaker_name = "sergeant_a",
				subtitle_start = 72.994
			},
			{
				subtitle_duration = 7.595,
				currently_playing_subtitle = "loc_sergeant_a__wolfer_speech_j_01",
				speaker_name = "sergeant_a",
				subtitle_start = 81.222
			},
			{
				subtitle_duration = 7.37,
				currently_playing_subtitle = "loc_sergeant_a__wolfer_speech_k_01",
				speaker_name = "sergeant_a",
				subtitle_start = 89.77
			},
			{
				subtitle_duration = 5.389,
				currently_playing_subtitle = "loc_sergeant_a__wolfer_speech_l_01",
				speaker_name = "sergeant_a",
				subtitle_start = 98.344
			},
			{
				subtitle_duration = 6.843,
				currently_playing_subtitle = "loc_sergeant_a__wolfer_speech_m_01",
				speaker_name = "sergeant_a",
				subtitle_start = 104.31
			},
			{
				subtitle_duration = 3.359,
				currently_playing_subtitle = "loc_sergeant_a__wolfer_speech_n_01",
				speaker_name = "sergeant_a",
				subtitle_start = 112.532
			},
			{
				subtitle_duration = 5.985,
				currently_playing_subtitle = "loc_sergeant_a__wolfer_speech_o_01",
				speaker_name = "sergeant_a",
				subtitle_start = 117.258
			}
		},
		post_video_action = {
			event_name = "s1_intro_viewed",
			action_type = "set_narrative_stat"
		}
	}
}

return cinematic_video_template
