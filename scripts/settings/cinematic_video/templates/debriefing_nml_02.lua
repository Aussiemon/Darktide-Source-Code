-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_nml_02.lua

local cinematic_video_template = {
	debriefing_nml_02 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_nml_debrief_02",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_nml_debrief_02",
		video_name = "content/videos/debriefings/debrief_nml_02",
		packages = {
			"packages/content/videos/debrief_nml_02",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_scavenge_debrief_v1_a_01",
				speaker_name = "commissar_a",
				subtitle_duration = 4.412,
				subtitle_start = 6.49,
			},
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_scavenge_debrief_v1_b_01",
				speaker_name = "commissar_a",
				subtitle_duration = 7.084,
				subtitle_start = 11.388,
			},
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_scavenge_debrief_v1_c_01",
				speaker_name = "commissar_a",
				subtitle_duration = 5.112,
				subtitle_start = 19.006,
			},
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_scavenge_debrief_v1_d_01",
				speaker_name = "commissar_a",
				subtitle_duration = 9.334,
				subtitle_start = 24.224,
			},
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_scavenge_debrief_v1_e_01",
				speaker_name = "commissar_a",
				subtitle_duration = 9.73,
				subtitle_start = 34.529,
			},
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_scavenge_debrief_v1_f_01",
				speaker_name = "commissar_a",
				subtitle_duration = 2.98,
				subtitle_start = 44.599,
			},
		},
	},
}

return cinematic_video_template
