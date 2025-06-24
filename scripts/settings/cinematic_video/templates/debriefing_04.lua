-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_04.lua

local cinematic_video_template = {
	debriefing_04 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_04",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_04",
		video_name = "content/videos/debriefings/debrief_04",
		packages = {
			"packages/content/videos/debrief_04",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_enforcer_debrief_a_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 3.72,
				subtitle_start = 6.2,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_enforcer_debrief_b_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 5.42,
				subtitle_start = 9.6,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_enforcer_debrief_c_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 6.59,
				subtitle_start = 15.27,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_enforcer_debrief_d_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 2.94,
				subtitle_start = 22,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_enforcer_debrief_e_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 5.97,
				subtitle_start = 24.96,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_enforcer_debrief_f_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 6.58,
				subtitle_start = 31.48,
			},
		},
	},
}

return cinematic_video_template
