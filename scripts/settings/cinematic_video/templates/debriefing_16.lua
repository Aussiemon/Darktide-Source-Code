-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_16.lua

local cinematic_video_template = {
	debriefing_16 = {
		video_name = "content/videos/debriefings/debrief_16",
		stop_only_player_skip = true,
		loop_video = false,
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_16",
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_16",
		music = "cinematic",
		packages = {
			"packages/content/videos/debrief_16"
		},
		subtitles = {
			{
				subtitle_duration = 2.683,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_rise_debrief_a_01",
				speaker_name = "interrogator_a",
				subtitle_start = 6.199
			},
			{
				subtitle_duration = 7.642,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_rise_debrief_b_01",
				speaker_name = "interrogator_a",
				subtitle_start = 9.166
			},
			{
				subtitle_duration = 5.913,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_rise_debrief_c_01",
				speaker_name = "interrogator_a",
				subtitle_start = 17.1
			},
			{
				subtitle_duration = 4.534,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_rise_debrief_d_01",
				speaker_name = "interrogator_a",
				subtitle_start = 23.399
			},
			{
				subtitle_duration = 8.644,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_rise_debrief_e_01",
				speaker_name = "interrogator_a",
				subtitle_start = 28.1
			},
			{
				subtitle_duration = 7.802,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_rise_debrief_f_01",
				speaker_name = "interrogator_a",
				subtitle_start = 37
			},
			{
				subtitle_duration = 1.139,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_rise_debrief_g_01",
				speaker_name = "interrogator_a",
				subtitle_start = 45
			}
		}
	}
}

return cinematic_video_template
