-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_nml_03.lua

local cinematic_video_template = {
	debriefing_nml_03 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_nml_debrief_03",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_nml_debrief_03",
		video_name = "content/videos/debriefings/debrief_nml_03",
		packages = {
			"packages/content/videos/debrief_nml_03",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_trenches_debrief_v1_a_01",
				speaker_name = "commissar_a",
				subtitle_duration = 3.583,
				subtitle_start = 6.444,
			},
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_trenches_debrief_v1_b_01",
				speaker_name = "commissar_a",
				subtitle_duration = 8.45,
				subtitle_start = 10.35,
			},
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_trenches_debrief_v1_c_01",
				speaker_name = "commissar_a",
				subtitle_duration = 7.43,
				subtitle_start = 19.336,
			},
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_trenches_debrief_v1_d_01",
				speaker_name = "commissar_a",
				subtitle_duration = 9.78,
				subtitle_start = 27.164,
			},
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_trenches_debrief_v1_e_01",
				speaker_name = "commissar_a",
				subtitle_duration = 5.443,
				subtitle_start = 37.428,
			},
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_trenches_debrief_v1_f_01",
				speaker_name = "commissar_a",
				subtitle_duration = 7.517,
				subtitle_start = 43.303,
			},
			{
				currently_playing_subtitle = "loc_commissar_a__live_story_trenches_debrief_v1_g_01",
				speaker_name = "commissar_a",
				subtitle_duration = 3.111,
				subtitle_start = 51.148,
			},
		},
	},
}

return cinematic_video_template
