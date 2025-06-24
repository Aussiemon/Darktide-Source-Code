-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_07.lua

local cinematic_video_template = {
	debriefing_07 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_07",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_07",
		video_name = "content/videos/debriefings/debrief_07",
		packages = {
			"packages/content/videos/debrief_07",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_strain_debrief_a_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 3.56,
				subtitle_start = 7,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_strain_debrief_b_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 5.56,
				subtitle_start = 10.6,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_strain_debrief_c_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 3,
				subtitle_start = 16.2,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_strain_debrief_d_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 3.95,
				subtitle_start = 19.3,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_strain_debrief_e_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 9.42,
				subtitle_start = 23.5,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_strain_debrief_f_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 3.92,
				subtitle_start = 33.1,
			},
		},
	},
}

return cinematic_video_template
