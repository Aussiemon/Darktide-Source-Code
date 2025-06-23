-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_04.lua

local cinematic_video_template = {
	debriefing_04 = {
		video_name = "content/videos/debriefings/debrief_04",
		stop_only_player_skip = true,
		loop_video = false,
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_04",
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_04",
		music = "cinematic",
		packages = {
			"packages/content/videos/debrief_04"
		},
		subtitles = {
			{
				subtitle_duration = 3.72,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_enforcer_debrief_a_01",
				speaker_name = "interrogator_a",
				subtitle_start = 6.2
			},
			{
				subtitle_duration = 5.42,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_enforcer_debrief_b_01",
				speaker_name = "interrogator_a",
				subtitle_start = 9.6
			},
			{
				subtitle_duration = 6.59,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_enforcer_debrief_c_01",
				speaker_name = "interrogator_a",
				subtitle_start = 15.27
			},
			{
				subtitle_duration = 2.94,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_enforcer_debrief_d_01",
				speaker_name = "interrogator_a",
				subtitle_start = 22
			},
			{
				subtitle_duration = 5.97,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_enforcer_debrief_e_01",
				speaker_name = "interrogator_a",
				subtitle_start = 24.96
			},
			{
				subtitle_duration = 6.58,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_enforcer_debrief_f_01",
				speaker_name = "interrogator_a",
				subtitle_start = 31.48
			}
		}
	}
}

return cinematic_video_template
