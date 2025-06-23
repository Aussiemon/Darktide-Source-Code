-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_13.lua

local cinematic_video_template = {
	debriefing_13 = {
		video_name = "content/videos/debriefings/debrief_13",
		stop_only_player_skip = true,
		loop_video = false,
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_13",
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_13",
		music = "cinematic",
		packages = {
			"packages/content/videos/debrief_13"
		},
		subtitles = {
			{
				subtitle_duration = 5.52,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_resurgence_debrief_a_01",
				speaker_name = "interrogator_a",
				subtitle_start = 6.333
			},
			{
				subtitle_duration = 6.831,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_resurgence_debrief_b_01",
				speaker_name = "interrogator_a",
				subtitle_start = 12
			},
			{
				subtitle_duration = 3.33,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_resurgence_debrief_c_01",
				speaker_name = "interrogator_a",
				subtitle_start = 19
			},
			{
				subtitle_duration = 3.315,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_resurgence_debrief_d_01",
				speaker_name = "interrogator_a",
				subtitle_start = 22.633
			},
			{
				subtitle_duration = 3.996,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_resurgence_debrief_e_01",
				speaker_name = "interrogator_a",
				subtitle_start = 26.233
			},
			{
				subtitle_duration = 4.131,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_resurgence_debrief_f_01",
				speaker_name = "interrogator_a",
				subtitle_start = 30.533
			}
		}
	}
}

return cinematic_video_template
