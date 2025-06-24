-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_13.lua

local cinematic_video_template = {
	debriefing_13 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_13",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_13",
		video_name = "content/videos/debriefings/debrief_13",
		packages = {
			"packages/content/videos/debrief_13",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_resurgence_debrief_a_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 5.52,
				subtitle_start = 6.333,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_resurgence_debrief_b_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 6.831,
				subtitle_start = 12,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_resurgence_debrief_c_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 3.33,
				subtitle_start = 19,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_resurgence_debrief_d_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 3.315,
				subtitle_start = 22.633,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_resurgence_debrief_e_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 3.996,
				subtitle_start = 26.233,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_resurgence_debrief_f_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 4.131,
				subtitle_start = 30.533,
			},
		},
	},
}

return cinematic_video_template
