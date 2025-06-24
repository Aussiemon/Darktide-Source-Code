-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_06.lua

local cinematic_video_template = {
	debriefing_06 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_06",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_06",
		video_name = "content/videos/debriefings/debrief_06",
		packages = {
			"packages/content/videos/debrief_06",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_propaganda_debrief_a_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 5.18,
				subtitle_start = 16.33,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_propaganda_debrief_b_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 3.5,
				subtitle_start = 21.66,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_propaganda_debrief_c_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 3.76,
				subtitle_start = 25.33,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_propaganda_debrief_d_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 6.87,
				subtitle_start = 29.33,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_propaganda_debrief_e_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 2.55,
				subtitle_start = 36.33,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__player_journey_propaganda_debrief_f_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 7.21,
				subtitle_start = 39,
			},
		},
	},
}

return cinematic_video_template
