-- chunkname: @scripts/settings/cinematic_video/templates/cs06.lua

local cinematic_video_template = {
	cs06 = {
		loop_video = false,
		music = "cinematic_pot",
		video_name = "content/videos/cs06",
		post_video_action = false,
		stop_only_player_skip = true,
		start_sound_name = "wwise/events/cinematics/play_cs06_surround_mix",
		stop_sound_name = "wwise/events/cinematics/stop_cs06_surround_mix",
		packages = {
			"packages/content/videos/cs06"
		},
		subtitles = {
			{
				subtitle_duration = 8.6,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_01_01",
				speaker_name = "servitor_grendyl_a",
				subtitle_start = 32.3
			},
			{
				subtitle_duration = 4.2,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_02_01",
				speaker_name = "servitor_grendyl_a",
				subtitle_start = 41.8
			},
			{
				subtitle_duration = 0.9,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_03_01",
				speaker_name = "servitor_grendyl_a",
				subtitle_start = 46.6
			},
			{
				subtitle_duration = 1.44,
				currently_playing_subtitle = "loc_crowd_a__cs06_servitor_speech_04_01",
				speaker_name = "crowd_a",
				subtitle_start = 47.86
			},
			{
				subtitle_duration = 4.56,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_05_01",
				speaker_name = "servitor_grendyl_a",
				subtitle_start = 51.24
			},
			{
				subtitle_duration = 6.75,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_06_01",
				speaker_name = "servitor_grendyl_a",
				subtitle_start = 56.55
			},
			{
				subtitle_duration = 4.6,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_07_01",
				speaker_name = "servitor_grendyl_a",
				subtitle_start = 63.7
			},
			{
				subtitle_duration = 0.8,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_08_01",
				speaker_name = "servitor_grendyl_a",
				subtitle_start = 70
			},
			{
				subtitle_duration = 1.4,
				currently_playing_subtitle = "loc_crowd_a__cs06_servitor_speech_09_01",
				speaker_name = "crowd_a",
				subtitle_start = 71.3
			},
			{
				subtitle_duration = 6.9,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_10_01",
				speaker_name = "servitor_grendyl_a",
				subtitle_start = 74.3
			},
			{
				subtitle_duration = 5.2,
				currently_playing_subtitle = "loc_servitor_female_a__cs06_servitor_speech_12_01",
				speaker_name = "servitor_grendyl_a",
				subtitle_start = 81.8
			},
			{
				subtitle_duration = 1.1,
				currently_playing_subtitle = "loc_servitor_female_a__cs06_servitor_speech_13_01",
				speaker_name = "servitor_grendyl_a",
				subtitle_start = 87.4
			},
			{
				subtitle_duration = 1.45,
				currently_playing_subtitle = "loc_crowd_a__cs06_servitor_speech_14_01",
				speaker_name = "crowd_a",
				subtitle_start = 89.25
			},
			{
				subtitle_duration = 5.6,
				currently_playing_subtitle = "loc_servitor_female_a__cs06_servitor_speech_15_01",
				speaker_name = "servitor_grendyl_a",
				subtitle_start = 91.3
			},
			{
				subtitle_duration = 0.95,
				currently_playing_subtitle = "loc_servitor_female_a__cs06_servitor_speech_16_01",
				speaker_name = "servitor_grendyl_a",
				subtitle_start = 97.65
			},
			{
				subtitle_duration = 1.6,
				currently_playing_subtitle = "loc_servitor_female_a__cs06_servitor_speech_17_01",
				speaker_name = "crowd_a",
				subtitle_start = 99.1
			},
			{
				subtitle_duration = 8.65,
				currently_playing_subtitle = "loc_servitor_female_a__cs06_servitor_speech_18_01",
				speaker_name = "servitor_grendyl_a",
				subtitle_start = 102.4
			},
			{
				subtitle_duration = 3.5,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_20_01",
				speaker_name = "servitor_grendyl_a",
				subtitle_start = 111.5
			},
			{
				subtitle_duration = 0.85,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_21_01",
				speaker_name = "servitor_grendyl_a",
				subtitle_start = 116.5
			},
			{
				subtitle_duration = 1.75,
				currently_playing_subtitle = "loc_crowd_a__cs06_servitor_speech_22_01",
				speaker_name = "crowd_a",
				subtitle_start = 117.85
			},
			{
				subtitle_duration = 1.4,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_23_01",
				speaker_name = "servitor_grendyl_a",
				subtitle_start = 127.2
			},
			{
				subtitle_duration = 0.65,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_24_01",
				speaker_name = "explicator_a",
				subtitle_start = 143.6
			},
			{
				subtitle_duration = 1,
				currently_playing_subtitle = "loc_crowd_a__cs06_servitor_speech_25_01",
				speaker_name = "crowd_a",
				subtitle_start = 144.3
			},
			{
				subtitle_duration = 0.5,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_26_01",
				speaker_name = "explicator_a",
				subtitle_start = 145.45
			},
			{
				subtitle_duration = 0.85,
				currently_playing_subtitle = "loc_crowd_a__cs06_servitor_speech_27_01",
				speaker_name = "crowd_a",
				subtitle_start = 145.985
			},
			{
				subtitle_duration = 0.5,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_26_01",
				speaker_name = "explicator_a",
				subtitle_start = 147
			},
			{
				subtitle_duration = 0.9,
				currently_playing_subtitle = "loc_crowd_a__cs06_servitor_speech_27_01",
				speaker_name = "crowd_a",
				subtitle_start = 147.55
			},
			{
				subtitle_duration = 0.45,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_26_01",
				speaker_name = "explicator_a",
				subtitle_start = 148.6
			},
			{
				subtitle_duration = 1,
				currently_playing_subtitle = "loc_crowd_a__cs06_servitor_speech_27_01",
				speaker_name = "crowd_a",
				subtitle_start = 149.1
			},
			{
				subtitle_duration = 0.45,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_26_01",
				speaker_name = "explicator_a",
				subtitle_start = 150.15
			},
			{
				subtitle_duration = 1.05,
				currently_playing_subtitle = "loc_crowd_a__cs06_servitor_speech_27_01",
				speaker_name = "crowd_a",
				subtitle_start = 150.65
			},
			{
				subtitle_duration = 0.45,
				currently_playing_subtitle = "loc_servitor_male_a__cs06_servitor_speech_26_01",
				speaker_name = "explicator_a",
				subtitle_start = 151.75
			},
			{
				subtitle_duration = 3,
				currently_playing_subtitle = "loc_crowd_a__cs06_servitor_speech_28_01",
				speaker_name = "crowd_a",
				subtitle_start = 152.25
			}
		}
	}
}

return cinematic_video_template
