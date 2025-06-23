-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_06.lua

local cinematic_video_template = {
	debriefing_06 = {
		video_name = "content/videos/debriefings/debrief_06",
		stop_only_player_skip = true,
		loop_video = false,
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_06",
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_06",
		music = "cinematic",
		packages = {
			"packages/content/videos/debrief_06"
		},
		subtitles = {
			{
				subtitle_duration = 5.18,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_propaganda_debrief_a_01",
				speaker_name = "interrogator_a",
				subtitle_start = 16.33
			},
			{
				subtitle_duration = 3.5,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_propaganda_debrief_b_01",
				speaker_name = "interrogator_a",
				subtitle_start = 21.66
			},
			{
				subtitle_duration = 3.76,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_propaganda_debrief_c_01",
				speaker_name = "interrogator_a",
				subtitle_start = 25.33
			},
			{
				subtitle_duration = 6.87,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_propaganda_debrief_d_01",
				speaker_name = "interrogator_a",
				subtitle_start = 29.33
			},
			{
				subtitle_duration = 2.55,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_propaganda_debrief_e_01",
				speaker_name = "interrogator_a",
				subtitle_start = 36.33
			},
			{
				subtitle_duration = 7.21,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_propaganda_debrief_f_01",
				speaker_name = "interrogator_a",
				subtitle_start = 39
			}
		}
	}
}

return cinematic_video_template
