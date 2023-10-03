local cinematic_video_template = {
	hli_crafting_station_underground = {
		loop_video = false,
		music = "cinematic_pot",
		video_name = "content/videos/hli_crafting_station_underground",
		stop_only_player_skip = true,
		start_sound_name = "wwise/events/cinematics/play_cs_hli_crafting_bink_surround",
		stop_sound_name = "wwise/events/cinematics/stop_cs_hli_crafting_bink_surround",
		packages = {
			"packages/content/videos/hli_crafting_station_underground"
		},
		subtitles = {
			{
				subtitle_duration = 3.457896,
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_shrine_ver_02_c_01",
				speaker_name = "tech_priest_a",
				subtitle_start = 8.32
			},
			{
				subtitle_duration = 4.730729,
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_shrine_ver_02_d_01",
				speaker_name = "tech_priest_a",
				subtitle_start = 12.646
			},
			{
				subtitle_duration = 3.812271,
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_shrine_ver_02_e_01",
				speaker_name = "tech_priest_a",
				subtitle_start = 19.316
			},
			{
				subtitle_duration = 7.706938,
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_shrine_ver_02_f_01",
				speaker_name = "tech_priest_a",
				subtitle_start = 24.88
			},
			{
				subtitle_duration = 4.583271,
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_shrine_ver_02_f2_01",
				speaker_name = "tech_priest_a",
				subtitle_start = 33.201
			},
			{
				subtitle_duration = 4.170188,
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_shrine_ver_02_g_01",
				speaker_name = "tech_priest_a",
				subtitle_start = 39.211
			},
			{
				subtitle_duration = 4.750854,
				currently_playing_subtitle = "loc_tech_priest_a__hub_intro_shrine_ver_02_h_01",
				speaker_name = "tech_priest_a",
				subtitle_start = 44.279
			}
		},
		post_video_action = {
			view_name = "crafting_view",
			action_type = "open_hub_view"
		}
	}
}

return cinematic_video_template
