-- chunkname: @scripts/settings/cinematic_video/templates/hli_penances.lua

local cinematic_video_template = {
	hli_penances = {
		loop_video = false,
		music = "cinematic_pot",
		video_name = "content/videos/hli_penances",
		stop_only_player_skip = true,
		start_sound_name = "wwise/events/cinematics/play_cs_hli_penances_bink_surround",
		stop_sound_name = "wwise/events/cinematics/stop_cs_hli_penances_bink_surround",
		packages = {
			"packages/content/videos/hli_penances"
		},
		subtitles = {
			{
				subtitle_duration = 9.1,
				currently_playing_subtitle = "loc_boon_vendor_a__hub_intro_penance_a_01",
				speaker_name = "boon_vendor_a",
				subtitle_start = 2.3
			},
			{
				subtitle_duration = 6.85,
				currently_playing_subtitle = "loc_boon_vendor_a__hub_intro_penance_b_01",
				speaker_name = "boon_vendor_a",
				subtitle_start = 12.5
			},
			{
				subtitle_duration = 4.164,
				currently_playing_subtitle = "loc_boon_vendor_a__hub_intro_penance_c_01",
				speaker_name = "boon_vendor_a",
				subtitle_start = 29.332
			},
			{
				subtitle_duration = 4.6,
				currently_playing_subtitle = "loc_boon_vendor_a__hub_intro_penance_d_01",
				speaker_name = "boon_vendor_a",
				subtitle_start = 35.74
			},
			{
				subtitle_duration = 5.5,
				currently_playing_subtitle = "loc_boon_vendor_a__hub_intro_penance_e_01",
				speaker_name = "boon_vendor_a",
				subtitle_start = 42.605
			}
		},
		post_video_action = {
			view_name = "penance_overview_view",
			action_type = "open_hub_view"
		}
	}
}

return cinematic_video_template
