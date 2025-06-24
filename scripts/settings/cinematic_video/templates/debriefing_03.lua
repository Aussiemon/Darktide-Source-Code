-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_03.lua

local cinematic_video_template = {
	debriefing_03 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_03",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_03",
		video_name = "content/videos/debriefings/debrief_03",
		packages = {
			"packages/content/videos/debrief_03",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_cartel_debrief_a_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 3.53,
				subtitle_start = 6.1,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_cartel_debrief_b_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 2.67,
				subtitle_start = 9.7,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_cartel_debrief_c_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 4.05,
				subtitle_start = 12.9,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_cartel_debrief_e_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 4.88,
				subtitle_start = 18.06,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_cartel_debrief_f_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 4.66,
				subtitle_start = 23.22,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_cartel_debrief_g_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 4.1,
				subtitle_start = 28.75,
			},
		},
	},
}

return cinematic_video_template
