-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_spillway_03.lua

local cinematic_video_template = {
	debriefing_spillway_03 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_spillway_debrief_03",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_spillway_debrief_03",
		video_name = "content/videos/debriefings/debrief_spillway_03",
		packages = {
			"packages/content/videos/debrief_spillway_03",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_interrogator_a__enemy_within_spillway_debrief_a_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 8.685,
				subtitle_start = 6.422,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__enemy_within_spillway_debrief_b_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 9.758,
				subtitle_start = 15.128,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__enemy_within_spillway_debrief_c_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 4.985,
				subtitle_start = 25.435,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__enemy_within_spillway_debrief_d_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 7.445,
				subtitle_start = 30.665,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__enemy_within_spillway_debrief_e_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 8.156,
				subtitle_start = 38.252,
			},
		},
	},
}

return cinematic_video_template
