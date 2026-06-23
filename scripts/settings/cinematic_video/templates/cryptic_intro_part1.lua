-- chunkname: @scripts/settings/cinematic_video/templates/cryptic_intro_part1.lua

local cinematic_video_template = {
	cryptic_intro_part1 = {
		loop_video = false,
		music = "cinematic_pot",
		start_sound_name = "wwise/events/cinematics/play_cin_cryptic_prologue_pt1",
		stop_only_player_skip = true,
		stop_sound_name = "wwise/events/cinematics/stop_cin_cryptic_prologue_pt1",
		video_name = "content/videos/cryptic_intro_part1",
		packages = {
			"packages/content/videos/cryptic_intro_part1",
		},
		subtitles = {
			{
				currently_playing_subtitle = "loc_enemy_nemesis_wolfer_a__heresy_cinematic_ritual_atmos_a_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 1.76,
				subtitle_start = 9.5,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__cryptic_prologue_b_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 5.43,
				subtitle_start = 11.923,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__cryptic_prologue_m_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 5.45,
				subtitle_start = 30.458,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__cryptic_prologue_n_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 3.1,
				subtitle_start = 36.325,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__cryptic_prologue_o_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 4.15,
				subtitle_start = 39.81,
			},
			{
				currently_playing_subtitle = "loc_interrogator_a__cryptic_prologue_g_01",
				speaker_name = "interrogator_a",
				subtitle_duration = 2.87,
				subtitle_start = 55.45,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__cryptic_prologue_h_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 2.04,
				subtitle_start = 59.43,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__cryptic_prologue_e_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 3.5,
				subtitle_start = 63,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__cryptic_prologue_i_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 4.62,
				subtitle_start = 91.32,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__cryptic_prologue_k_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 10.8,
				subtitle_start = 103.94,
			},
			{
				currently_playing_subtitle = "loc_cryptic_a__binharic_long_aggressive_01",
				speaker_name = nil,
				subtitle_duration = 8.5,
				subtitle_start = 140.1,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__cryptic_prologue_l_01",
				speaker_name = "tech_priest_a",
				subtitle_duration = 3.32,
				subtitle_start = 180.75,
			},
			{
				currently_playing_subtitle = "loc_tech_priest_a__crafting_complete_05",
				speaker_name = "tech_priest_a",
				subtitle_duration = 2.32,
				subtitle_start = 202.65,
			},
		},
	},
}

return cinematic_video_template
