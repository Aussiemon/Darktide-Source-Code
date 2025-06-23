-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_14.lua

local cinematic_video_template = {
	debriefing_14 = {
		video_name = "content/videos/debriefings/debrief_14",
		stop_only_player_skip = true,
		loop_video = false,
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_14",
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_14",
		music = "cinematic",
		packages = {
			"packages/content/videos/debrief_14"
		},
		subtitles = {
			{
				subtitle_duration = 3.241,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_archives_debrief_a_01",
				speaker_name = "sergeant_a",
				subtitle_start = 6.3
			},
			{
				subtitle_duration = 4.578,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_archives_debrief_b_01",
				speaker_name = "sergeant_a",
				subtitle_start = 9.733
			},
			{
				subtitle_duration = 2.917,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_archives_debrief_c_01",
				speaker_name = "sergeant_a",
				subtitle_start = 14.466
			},
			{
				subtitle_duration = 2.842,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_archives_debrief_d_01",
				speaker_name = "sergeant_a",
				subtitle_start = 17.6
			},
			{
				subtitle_duration = 5.81,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_archives_debrief_e_01",
				speaker_name = "sergeant_a",
				subtitle_start = 20.6
			},
			{
				subtitle_duration = 5.633,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_archives_debrief_f_01",
				speaker_name = "sergeant_a",
				subtitle_start = 26.6
			}
		}
	}
}

return cinematic_video_template
