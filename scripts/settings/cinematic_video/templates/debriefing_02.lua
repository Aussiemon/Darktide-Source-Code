-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_02.lua

local cinematic_video_template = {
	debriefing_02 = {
		video_name = "content/videos/debriefings/debrief_02",
		stop_only_player_skip = true,
		loop_video = false,
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_02",
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_02",
		music = "cinematic",
		packages = {
			"packages/content/videos/debrief_02"
		},
		subtitles = {
			{
				subtitle_duration = 4.91,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_stockpile_debrief_a_01",
				speaker_name = "sergeant_a",
				subtitle_start = 6
			},
			{
				subtitle_duration = 5.48,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_stockpile_debrief_b_01",
				speaker_name = "sergeant_a",
				subtitle_start = 12.2
			},
			{
				subtitle_duration = 5.04,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_stockpile_debrief_c_01",
				speaker_name = "sergeant_a",
				subtitle_start = 18.4
			},
			{
				subtitle_duration = 3.67,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_stockpile_debrief_d_01",
				speaker_name = "sergeant_a",
				subtitle_start = 24
			},
			{
				subtitle_duration = 4.2,
				currently_playing_subtitle = "loc_sergeant_a__player_journey_stockpile_debrief_e_01",
				speaker_name = "sergeant_a",
				subtitle_start = 29
			}
		}
	}
}

return cinematic_video_template
