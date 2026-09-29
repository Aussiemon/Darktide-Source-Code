-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_spillway_02.lua

local cinematic_video_template = {
	debriefing_spillway_02 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_spillway_debrief_02",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_spillway_debrief_02",
		video_name = "content/videos/debriefings/debrief_spillway_02",
		packages = {
			"packages/content/videos/debrief_spillway_02",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_interrogator_a__enemy_within_resurgence_debrief_a_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 6.209,
				subtitle_start = 6.422,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__enemy_within_resurgence_debrief_b_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 4.649,
				subtitle_start = 12.834,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__enemy_within_resurgence_debrief_c_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 9.263,
				subtitle_start = 17.802,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__enemy_within_resurgence_debrief_d_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 9.74,
				subtitle_start = 27.578,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__enemy_within_resurgence_debrief_e_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 9.44,
				subtitle_start = 37.584,
			},
		},
	},
}

return cinematic_video_template
