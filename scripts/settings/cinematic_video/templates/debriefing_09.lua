-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_09.lua

local cinematic_video_template = {
	debriefing_09 = {
		video_name = "content/videos/debriefings/debrief_09",
		stop_only_player_skip = true,
		loop_video = false,
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_09",
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_09",
		music = "cinematic",
		packages = {
			"packages/content/videos/debrief_09"
		},
		subtitles = {
			{
				subtitle_duration = 4.52,
				currently_playing_subtitle = "loc_tech_priest_a__player_journey_core_debrief_a_01",
				speaker_name = "tech_priest_a",
				subtitle_start = 7
			},
			{
				subtitle_duration = 7.25,
				currently_playing_subtitle = "loc_tech_priest_a__player_journey_core_debrief_b_01",
				speaker_name = "tech_priest_a",
				subtitle_start = 11.9
			},
			{
				subtitle_duration = 3.23,
				currently_playing_subtitle = "loc_tech_priest_a__player_journey_core_debrief_c_01",
				speaker_name = "tech_priest_a",
				subtitle_start = 19.66
			},
			{
				subtitle_duration = 5.99,
				currently_playing_subtitle = "loc_tech_priest_a__player_journey_core_debrief_d_01",
				speaker_name = "tech_priest_a",
				subtitle_start = 23.13
			},
			{
				subtitle_duration = 5.48,
				currently_playing_subtitle = "loc_tech_priest_a__player_journey_core_debrief_e_01",
				speaker_name = "tech_priest_a",
				subtitle_start = 29.4
			}
		}
	}
}

return cinematic_video_template
