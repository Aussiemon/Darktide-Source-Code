-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_nml_01.lua

local cinematic_video_template = {
	debriefing_nml_01 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_nml_debrief_01",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_nml_debrief_01",
		video_name = "content/videos/debriefings/debrief_nml_01",
		packages = {
			"packages/content/videos/debrief_nml_01",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_train_debrief_v1_a_01",
				speaker_name = "commissar_a",
				subtitle_duration = 10.057,
				subtitle_start = 6.669,
			},
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_train_debrief_v1_b_01",
				speaker_name = "commissar_a",
				subtitle_duration = 4.004,
				subtitle_start = 17.213,
			},
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_train_debrief_v1_c_01",
				speaker_name = "commissar_a",
				subtitle_duration = 9.143,
				subtitle_start = 21.665,
			},
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_train_debrief_v1_d_01",
				speaker_name = "commissar_a",
				subtitle_duration = 2.16,
				subtitle_start = 31.305,
			},
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_train_debrief_v1_e_01",
				speaker_name = "commissar_a",
				subtitle_duration = 7.674,
				subtitle_start = 33.855,
			},
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_train_debrief_v1_f_01",
				speaker_name = "commissar_a",
				subtitle_duration = 3.132,
				subtitle_start = 42.035,
			},
		},
	},
}

return cinematic_video_template
