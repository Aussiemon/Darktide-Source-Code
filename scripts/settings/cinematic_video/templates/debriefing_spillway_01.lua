-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_spillway_01.lua

local cinematic_video_template = {
	debriefing_spillway_01 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_spillway_debrief_01",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_spillway_debrief_01",
		video_name = "content/videos/debriefings/debrief_spillway_01",
		packages = {
			"packages/content/videos/debrief_spillway_01",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_interrogator_a__enemy_within_cargo_debrief_a_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 7.925,
				subtitle_start = 6.422,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__enemy_within_cargo_debrief_b_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 7.353,
				subtitle_start = 14.695,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__enemy_within_cargo_debrief_c_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 10.619,
				subtitle_start = 22.515,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__enemy_within_cargo_debrief_d_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 7.403,
				subtitle_start = 33.49,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__enemy_within_cargo_debrief_e_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 9.527,
				subtitle_start = 41.617,
			},
		},
	},
}

return cinematic_video_template
