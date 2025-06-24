-- chunkname: @scripts/settings/cinematic_video/templates/debriefing_08.lua

local cinematic_video_template = {
	debriefing_08 = {
		loop_video = false,
		music = "cinematic",
		start_sound_name = "wwise/events/cinematics/play_cs_pj_debrief_08",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_pj_debrief_08",
		video_name = "content/videos/debriefings/debrief_08",
		packages = {
			"packages/content/videos/debrief_08",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_tech_priest_a__player_journey_cargo_debrief_a_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 4.51,
				subtitle_start = 7.06,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__player_journey_cargo_debrief_b_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 5.53,
				subtitle_start = 11.8,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__player_journey_cargo_debrief_c_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 3.84,
				subtitle_start = 17.34,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__player_journey_cargo_debrief_d_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 5.79,
				subtitle_start = 21.5,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__player_journey_cargo_debrief_e_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 8.12,
				subtitle_start = 27.9,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__player_journey_cargo_debrief_f_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 8.06,
				subtitle_start = 36.26,
			},
		},
	},
}

return cinematic_video_template
