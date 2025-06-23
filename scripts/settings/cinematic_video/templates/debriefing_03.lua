-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_03.lua

local cinematic_video_template = {
	debriefing_03 = {
		video_name = "content/videos/debriefings/debrief_03",
		stop_only_player_skip = true,
		loop_video = false,
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_03",
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_03",
		music = "cinematic",
		packages = {
			"packages/content/videos/debrief_03"
		},
		subtitles = {
			{
				subtitle_duration = 3.53,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_cartel_debrief_a_01",
				speaker_name = "sergeant_a",
				subtitle_start = 6.1
			},
			{
				subtitle_duration = 2.67,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_cartel_debrief_b_01",
				speaker_name = "sergeant_a",
				subtitle_start = 9.7
			},
			{
				subtitle_duration = 4.05,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_cartel_debrief_c_01",
				speaker_name = "sergeant_a",
				subtitle_start = 12.9
			},
			{
				subtitle_duration = 4.88,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_cartel_debrief_e_01",
				speaker_name = "sergeant_a",
				subtitle_start = 18.06
			},
			{
				subtitle_duration = 4.66,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_cartel_debrief_f_01",
				speaker_name = "sergeant_a",
				subtitle_start = 23.22
			},
			{
				subtitle_duration = 4.1,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_cartel_debrief_g_01",
				speaker_name = "sergeant_a",
				subtitle_start = 28.75
			}
		}
	}
}

return cinematic_video_template
