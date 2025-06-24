-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_12.lua

local cinematic_video_template = {
	debriefing_12 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_12",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_12",
		video_name = "content/videos/debriefings/debrief_12",
		packages = {
			"packages/content/videos/debrief_12",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_twins_debrief_a_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 4.286,
				subtitle_start = 7,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_twins_debrief_b_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 3.75,
				subtitle_start = 11.533,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_twins_debrief_c_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 1.302,
				subtitle_start = 15.399,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_twins_debrief_d_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 3.68,
				subtitle_start = 16.933,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_twins_debrief_e_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 5.668,
				subtitle_start = 20.766,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_twins_debrief_f_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 4.686,
				subtitle_start = 26.666,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_twins_debrief_g_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 3.3,
				subtitle_start = 31.533,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_twins_debrief_h_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 1.111,
				subtitle_start = 34.866,
			},
		},
	},
}

return cinematic_video_template
