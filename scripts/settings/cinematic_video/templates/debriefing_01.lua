-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_01.lua

local cinematic_video_template = {
	debriefing_01 = {
		video_name = "content/videos/debriefings/debrief_01",
		stop_only_player_skip = true,
		loop_video = false,
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_01",
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_01",
		music = "cinematic",
		packages = {
			"packages/content/videos/debrief_01"
		},
		subtitles = {
			{
				subtitle_duration = 3.38,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_station_debrief_a_01",
				speaker_name = "sergeant_a",
				subtitle_start = 5.79
			},
			{
				subtitle_duration = 4.97,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_station_debrief_b_01",
				speaker_name = "sergeant_a",
				subtitle_start = 9.6
			},
			{
				subtitle_duration = 1.4,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_station_debrief_c_01",
				speaker_name = "sergeant_a",
				subtitle_start = 17.16
			},
			{
				subtitle_duration = 4.71,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_station_debrief_d_01",
				speaker_name = "sergeant_a",
				subtitle_start = 19.33
			},
			{
				subtitle_duration = 5.48,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_station_debrief_e_01",
				speaker_name = "sergeant_a",
				subtitle_start = 25.08
			}
		}
	}
}

return cinematic_video_template
