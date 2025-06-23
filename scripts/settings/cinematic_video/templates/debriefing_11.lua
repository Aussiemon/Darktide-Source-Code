-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_11.lua

local cinematic_video_template = {
	debriefing_11 = {
		video_name = "content/videos/debriefings/debrief_11",
		stop_only_player_skip = true,
		loop_video = false,
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_11",
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_11",
		music = "cinematic",
		packages = {
			"packages/content/videos/debrief_11"
		},
		subtitles = {
			{
				subtitle_duration = 5.333,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_raid_debrief_a_01",
				speaker_name = "interrogator_a",
				subtitle_start = 7
			},
			{
				subtitle_duration = 2.465,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_raid_debrief_b_01",
				speaker_name = "interrogator_a",
				subtitle_start = 12.5
			},
			{
				subtitle_duration = 7.263,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_raid_debrief_c_01",
				speaker_name = "interrogator_a",
				subtitle_start = 15.199
			},
			{
				subtitle_duration = 2.641,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_raid_debrief_d_01",
				speaker_name = "interrogator_a",
				subtitle_start = 22.733
			},
			{
				subtitle_duration = 6.436,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_raid_debrief_e_01",
				speaker_name = "interrogator_a",
				subtitle_start = 25.6
			},
			{
				subtitle_duration = 5.036,
				currently_playing_subtitle = "loc_interrogator_a__player_journey_raid_debrief_f_01",
				speaker_name = "interrogator_a",
				subtitle_start = 32.399
			}
		}
	}
}

return cinematic_video_template
