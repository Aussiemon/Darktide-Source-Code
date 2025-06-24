-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_01.lua

local cinematic_video_template = {
	debriefing_01 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_01",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_01",
		video_name = "content/videos/debriefings/debrief_01",
		packages = {
			"packages/content/videos/debrief_01",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_station_debrief_a_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 3.38,
				subtitle_start = 5.79,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_station_debrief_b_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 4.97,
				subtitle_start = 9.6,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_station_debrief_c_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 1.4,
				subtitle_start = 17.16,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_station_debrief_d_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 4.71,
				subtitle_start = 19.33,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_station_debrief_e_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 5.48,
				subtitle_start = 25.08,
			},
		},
	},
}

return cinematic_video_template
