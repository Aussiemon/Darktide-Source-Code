-- chunkname: @scripts/settings/cinematic_video/templates/core_research_intro.lua

local cinematic_video_template = {
	core_research_intro = {
		loop_video = false,
		music = "cinematic",
		video_name = "content/videos/core_research_intro",
		stop_only_player_skip = true,
		start_sound_name = "wwise/events/cinematics/play_dt_cin_core_research_surround",
		stop_sound_name = "wwise/events/cinematics/stop_dt_cin_core_research_surround",
		packages = {
			"packages/content/videos/core_research_intro"
		},
		subtitles = {
			{
				subtitle_duration = 6.02,
				currently_playing_subtitle = "loc_flight_control_a__mission_core_cinematic_a_01",
				speaker_name = "vocator_a",
				subtitle_start = 1.7
			},
			{
				subtitle_duration = 14.387,
				currently_playing_subtitle = "loc_travelling_salesman_a__mission_core_cinematic_b_01",
				speaker_name = "travelling_salesman_a",
				subtitle_start = 15.162
			},
			{
				subtitle_duration = 9.43,
				currently_playing_subtitle = "loc_travelling_salesman_a__mission_core_cinematic_c_01",
				speaker_name = "travelling_salesman_a",
				subtitle_start = 27.7
			},
			{
				subtitle_duration = 12.495,
				currently_playing_subtitle = "loc_travelling_salesman_a__mission_core_cinematic_d_01",
				speaker_name = "travelling_salesman_a",
				subtitle_start = 41.733
			}
		},
		post_video_action = {
			event_name = "core_research_intro_viewed",
			action_type = "set_narrative_stat"
		}
	}
}

return cinematic_video_template
