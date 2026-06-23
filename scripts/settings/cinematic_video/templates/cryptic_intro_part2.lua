-- chunkname: @scripts/settings/cinematic_video/templates/cryptic_intro_part2.lua

local cinematic_video_template = {
	cryptic_intro_part2 = {
		loop_video = false,
		music = "cinematic_pot",
		start_sound_name = "wwise/events/cinematics/play_cin_cryptic_prologue_pt2",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cin_cryptic_prologue_pt2",
		video_name = "content/videos/cryptic_intro_part2",
		packages = {
			"packages/content/videos/cryptic_intro_part2",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_interrogator_a__cryptic_prologue_q_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 5.2,
				subtitle_start = 5.78,
			},
		},
		pre_video_action = {
			action_type = "set_narrative_stat",
			event_name = "onboarding_step_chapel_video_viewed",
		},
	},
}

return cinematic_video_template
