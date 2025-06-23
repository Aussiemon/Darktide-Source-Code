-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_15.lua

local cinematic_video_template = {
	debriefing_15 = {
		video_name = "content/videos/debriefings/debrief_15",
		stop_only_player_skip = true,
		loop_video = false,
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_15",
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_15",
		music = "cinematic",
		packages = {
			"packages/content/videos/debrief_15"
		},
		subtitles = {
			{
				subtitle_duration = 2.094,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_complex_debrief_a_01",
				speaker_name = "sergeant_a",
				subtitle_start = 6.3
			},
			{
				subtitle_duration = 4.439,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_complex_debrief_b_01",
				speaker_name = "sergeant_a",
				subtitle_start = 8.533
			},
			{
				subtitle_duration = 4.137,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_complex_debrief_c_01",
				speaker_name = "sergeant_a",
				subtitle_start = 13.1
			},
			{
				subtitle_duration = 6.757,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_complex_debrief_d_01",
				speaker_name = "sergeant_a",
				subtitle_start = 17.399
			},
			{
				subtitle_duration = 4.645,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_complex_debrief_e_01",
				speaker_name = "sergeant_a",
				subtitle_start = 24.399
			},
			{
				subtitle_duration = 7.811,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_complex_debrief_f_01",
				speaker_name = "sergeant_a",
				subtitle_start = 29.366
			}
		}
	}
}

return cinematic_video_template
