-- chunkname: @scripts/settings/cinematic_video/templates/broker_intro.lua

local cinematic_video_template = {
	broker_intro = {
		loop_video = false,
		music = "cinematic_pot",
		start_sound_name = "wwise/events/cinematics/play_cin_broker_prologue_mix",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cin_broker_prologue_mix",
		video_name = "content/videos/broker_intro",
		packages = {
			"packages/content/videos/broker_intro",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_interrogator_a__broker_prologue_a_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 3.929,
				subtitle_start = 7.66,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__broker_prologue_b_01",
				speaker_name = "explicator_a",
				subtitle_duration = 3.74,
				subtitle_start = 13.58,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__broker_prologue_c_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 2.779,
				subtitle_start = 19.78,
			},
			{
				currently_playing_subtitle = "loc_broker_male_a__guidance_correct_path_02",
				speaker_name = "broker_male_a",
				subtitle_duration = 0.972,
				subtitle_start = 24.539,
			},
			{
				currently_playing_subtitle = "loc_enemy_plasma_gunner_a__shooting_08",
				speaker_name = "cine_plasma_gunner_a",
				subtitle_duration = 1.404,
				subtitle_start = 32.783,
			},
			{
				currently_playing_subtitle = "loc_broker_female_c__combat_pause_limited_adamant_b_02_b_01",
				speaker_name = "broker_male_a",
				subtitle_duration = 2.628,
				subtitle_start = 35.135,
			},
			{
				currently_playing_subtitle = "loc_enemy_traitor_gunner_a__ranged_idle_01",
				speaker_name = "cine_plasma_gunner_a",
				subtitle_duration = 1.2,
				subtitle_start = 38.183,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__broker_prologue_d_01",
				speaker_name = "explicator_a",
				subtitle_duration = 1.559,
				subtitle_start = 43.85,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__broker_prologue_e_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 4.079,
				subtitle_start = 47.27,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__broker_prologue_f_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 1.88,
				subtitle_start = 51.73,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__broker_prologue_g_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 4.85,
				subtitle_start = 53.76,
			},
			{
				currently_playing_subtitle = "loc_broker_female_c__come_back_to_squad_05",
				speaker_name = "broker_male_a",
				subtitle_duration = 3.576,
				subtitle_start = 63.299,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__broker_prologue_i_01",
				speaker_name = "explicator_a",
				subtitle_duration = 2.469,
				subtitle_start = 81.34,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__broker_prologue_j_01",
				speaker_name = "explicator_a",
				subtitle_duration = 3.46,
				subtitle_start = 84.35,
			},
			{
				currently_playing_subtitle = "loc_explicator_a__broker_prologue_k_01",
				speaker_name = "explicator_a",
				subtitle_duration = 1.96,
				subtitle_start = 92.44,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__broker_prologue_l_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 2.049,
				subtitle_start = 98.54,
			},
		},
		pre_video_action = {
			action_type = "set_narrative_stat",
			event_name = "onboarding_step_chapel_video_viewed",
		},
	},
}

return cinematic_video_template
