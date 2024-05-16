﻿-- chunkname: @scripts/settings/cinematic_video/templates/voxshot_rise.lua

local cinematic_video_template = {
	voxshot_rise = {
		loop_video = false,
		music = "cinematic_pot",
		start_sound_name = "wwise/events/cinematics/play_vox_shot_rise",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_vox_shot_rise",
		video_name = "content/videos/voxshot_rise",
		packages = {
			"packages/content/videos/voxshot_rise",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_comms_operator_a__vox_shots_rise_b_01",
				speaker_name = "enemy_nemesis_wolfer_a",
				subtitle_duration = 5,
				subtitle_start = 5,
			},
			{
				currently_playing_subtitle = "loc_contract_vendor_a__vox_shots_rise_c_01",
				speaker_name = "enemy_nemesis_wolfer_a",
				subtitle_duration = 5,
				subtitle_start = 10,
			},
		},
		post_video_action = {
			action_type = "set_narrative_stat",
			event_name = "voxshot_rise_viewed",
		},
	},
}

return cinematic_video_template
