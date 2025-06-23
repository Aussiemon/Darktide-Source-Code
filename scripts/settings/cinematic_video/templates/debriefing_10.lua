-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_10.lua

local cinematic_video_template = {
	debriefing_10 = {
		video_name = "content/videos/debriefings/debrief_10",
		stop_only_player_skip = true,
		loop_video = false,
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_10",
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_10",
		music = "cinematic",
		packages = {
			"packages/content/videos/debrief_10"
		},
		subtitles = {
			{
				subtitle_duration = 3.69,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_armoury_debrief_a_01",
				speaker_name = "sergeant_a",
				subtitle_start = 7
			},
			{
				subtitle_duration = 2.63,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_armoury_debrief_b_01",
				speaker_name = "sergeant_a",
				subtitle_start = 10.9
			},
			{
				subtitle_duration = 5.25,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_armoury_debrief_c_01",
				speaker_name = "sergeant_a",
				subtitle_start = 13.86
			},
			{
				subtitle_duration = 2.52,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_armoury_debrief_d_01",
				speaker_name = "sergeant_a",
				subtitle_start = 19.4
			},
			{
				subtitle_duration = 6.48,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_armoury_debrief_e_01",
				speaker_name = "sergeant_a",
				subtitle_start = 22.26
			},
			{
				subtitle_duration = 5.23,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_armoury_debrief_f_01",
				speaker_name = "sergeant_a",
				subtitle_start = 29.13
			}
		}
	}
}

return cinematic_video_template
