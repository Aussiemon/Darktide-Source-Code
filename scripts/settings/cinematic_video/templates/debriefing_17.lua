-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_17.lua

local cinematic_video_template = {
	debriefing_17 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_17",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_17",
		video_name = "content/videos/debriefings/debrief_17",
		packages = {
			"packages/content/videos/debrief_17",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_heresy_debrief_a_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 4.554,
				subtitle_start = 6.333,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_heresy_debrief_b_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 5.712,
				subtitle_start = 11,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_heresy_debrief_c_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 5.804,
				subtitle_start = 16.8,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_heresy_debrief_d_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 6.97,
				subtitle_start = 22.8,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_heresy_debrief_e_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 3.281,
				subtitle_start = 29.933,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_heresy_debrief_f_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 3.673,
				subtitle_start = 33.433,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_heresy_debrief_g_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 2.653,
				subtitle_start = 37.3,
			},
		},
	},
}

return cinematic_video_template
