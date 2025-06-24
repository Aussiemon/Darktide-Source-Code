-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_14.lua

local cinematic_video_template = {
	debriefing_14 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_14",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_14",
		video_name = "content/videos/debriefings/debrief_14",
		packages = {
			"packages/content/videos/debrief_14",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_archives_debrief_a_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 3.241,
				subtitle_start = 6.3,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_archives_debrief_b_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 4.578,
				subtitle_start = 9.733,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_archives_debrief_c_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 2.917,
				subtitle_start = 14.466,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_archives_debrief_d_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 2.842,
				subtitle_start = 17.6,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_archives_debrief_e_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 5.81,
				subtitle_start = 20.6,
			},
			{
				currently_playing_subtitle = "loc_sergeant_a__player_journey_archives_debrief_f_01",
				speaker_name = "sergeant_a",
				subtitle_duration = 5.633,
				subtitle_start = 26.6,
			},
		},
	},
}

return cinematic_video_template
