-- chunkname: @scripts/settings/cinematic_video/templates/hli_expeditions.lua

local cinematic_video_template = {
	hli_expeditions = {
		loop_video = false,
		music = "cinematic_pot",
		start_sound_name = "wwise/events/cinematics/play_cs_hli_expeditions_mix_surround",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cs_hli_expeditions_mix_surround",
		video_name = "content/videos/hli_expeditions",
		packages = {
			"packages/content/videos/hli_expeditions",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_expeditions_a_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 10.15,
				subtitle_start = 6.17,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_expeditions_b_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 6.349,
				subtitle_start = 20.63,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_expeditions_c_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 5.259,
				subtitle_start = 27.82,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_expeditions_d_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 6.78,
				subtitle_start = 34.83,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_expeditions_e_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 10.649,
				subtitle_start = 42.49,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_expeditions_f_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 4,
				subtitle_start = 56.62,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_expeditions_g_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 6.269,
				subtitle_start = 60.81,
			},
		},
		post_video_action = {
			action_type = "open_hub_view",
			view_name = "expedition_view",
		},
	},
}

return cinematic_video_template
