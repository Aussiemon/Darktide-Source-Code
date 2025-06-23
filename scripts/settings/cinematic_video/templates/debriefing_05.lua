-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_05.lua

local cinematic_video_template = {
	debriefing_05 = {
		video_name = "content/videos/debriefings/debrief_05",
		stop_only_player_skip = true,
		loop_video = false,
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_05",
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_05",
		music = "cinematic",
		packages = {
			"packages/content/videos/debrief_05"
		},
		subtitles = {
			{
				subtitle_duration = 2.31,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_habs_debrief_a_01",
				speaker_name = "sergeant_a",
				subtitle_start = 6
			},
			{
				subtitle_duration = 7.43,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_habs_debrief_b_01",
				speaker_name = "sergeant_a",
				subtitle_start = 8.5
			},
			{
				subtitle_duration = 4.77,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_habs_debrief_c_01",
				speaker_name = "sergeant_a",
				subtitle_start = 16.1
			},
			{
				subtitle_duration = 4.71,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_habs_debrief_d_01",
				speaker_name = "sergeant_a",
				subtitle_start = 21
			},
			{
				subtitle_duration = 5.88,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_habs_debrief_e_01",
				speaker_name = "sergeant_a",
				subtitle_start = 26.16
			}
		}
	}
}

return cinematic_video_template
