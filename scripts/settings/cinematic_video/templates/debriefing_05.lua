-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_05.lua

local cinematic_video_template = {
	debriefing_05 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_05",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_05",
		video_name = "content/videos/debriefings/debrief_05",
		packages = {
			"packages/content/videos/debrief_05",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_habs_debrief_a_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 2.31,
				subtitle_start = 6,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_habs_debrief_b_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 7.43,
				subtitle_start = 8.5,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_habs_debrief_c_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 4.77,
				subtitle_start = 16.1,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_habs_debrief_d_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 4.71,
				subtitle_start = 21,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_habs_debrief_e_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 5.88,
				subtitle_start = 26.16,
			},
		},
	},
}

return cinematic_video_template
