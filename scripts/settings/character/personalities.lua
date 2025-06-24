-- chunkname: @scripts/settings/character/personalities.lua

local personality_options = {
	{
		character_voice = "veteran_male_a",
		description = "loc_veteran_male_a__intro_01",
		display_name = "loc_personality_name_male_veteran_1",
		preview_sound_event = "wwise/events/vo/play_preview_mask_veteran_male_a",
		sample_sound_event = "wwise/events/vo/play_preview_veteran_male_a",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"male",
			},
			archetypes = {
				"veteran",
			},
		},
	},
	{
		character_voice = "veteran_male_b",
		description = "loc_veteran_male_b__intro_01",
		display_name = "loc_personality_name_male_veteran_2",
		preview_sound_event = "wwise/events/vo/play_preview_mask_veteran_male_b",
		sample_sound_event = "wwise/events/vo/play_preview_veteran_male_b",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"male",
			},
			archetypes = {
				"veteran",
			},
		},
	},
	{
		character_voice = "veteran_male_c",
		description = "loc_veteran_male_c__intro_01",
		display_name = "loc_personality_name_male_veteran_3",
		preview_sound_event = "wwise/events/vo/play_preview_mask_veteran_male_c",
		sample_sound_event = "wwise/events/vo/play_preview_veteran_male_c",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"male",
			},
			archetypes = {
				"veteran",
			},
		},
		restrictions = {
			home_planets = {
				"option_7",
			},
		},
	},
	{
		character_voice = "veteran_female_a",
		description = "loc_veteran_female_a__intro_01",
		display_name = "loc_personality_name_female_veteran_1",
		preview_sound_event = "wwise/events/vo/play_preview_mask_veteran_female_a",
		sample_sound_event = "wwise/events/vo/play_preview_veteran_female_a",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"female",
			},
			archetypes = {
				"veteran",
			},
		},
	},
	{
		character_voice = "veteran_female_b",
		description = "loc_veteran_female_b__intro_01",
		display_name = "loc_personality_name_female_veteran_2",
		preview_sound_event = "wwise/events/vo/play_preview_mask_veteran_female_b",
		sample_sound_event = "wwise/events/vo/play_preview_veteran_female_b",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"female",
			},
			archetypes = {
				"veteran",
			},
		},
	},
	{
		character_voice = "veteran_female_c",
		description = "loc_veteran_female_c__intro_01",
		display_name = "loc_personality_name_female_veteran_3",
		preview_sound_event = "wwise/events/vo/play_preview_mask_veteran_female_c",
		sample_sound_event = "wwise/events/vo/play_preview_veteran_female_c",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"female",
			},
			archetypes = {
				"veteran",
			},
		},
		restrictions = {
			home_planets = {
				"option_7",
			},
		},
	},
	{
		character_voice = "zealot_male_a",
		description = "loc_zealot_male_a__intro_01",
		display_name = "loc_personality_name_male_zealot_1",
		preview_sound_event = "wwise/events/vo/play_preview_mask_zealot_male_a",
		sample_sound_event = "wwise/events/vo/play_preview_zealot_male_a",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"male",
			},
			archetypes = {
				"zealot",
			},
		},
	},
	{
		character_voice = "zealot_male_b",
		description = "loc_zealot_male_b__intro_01",
		display_name = "loc_personality_name_male_zealot_2",
		preview_sound_event = "wwise/events/vo/play_preview_mask_zealot_male_b",
		sample_sound_event = "wwise/events/vo/play_preview_zealot_male_b",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"male",
			},
			archetypes = {
				"zealot",
			},
		},
	},
	{
		character_voice = "zealot_male_c",
		description = "loc_zealot_male_c__intro_01",
		display_name = "loc_personality_name_male_zealot_3",
		preview_sound_event = "wwise/events/vo/play_preview_mask_zealot_male_c",
		sample_sound_event = "wwise/events/vo/play_preview_zealot_male_c",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"male",
			},
			archetypes = {
				"zealot",
			},
		},
	},
	{
		character_voice = "zealot_female_a",
		description = "loc_zealot_female_a__intro_01",
		display_name = "loc_personality_name_female_zealot_1",
		preview_sound_event = "wwise/events/vo/play_preview_mask_zealot_female_a",
		sample_sound_event = "wwise/events/vo/play_preview_zealot_female_a",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"female",
			},
			archetypes = {
				"zealot",
			},
		},
	},
	{
		character_voice = "zealot_female_b",
		description = "loc_zealot_female_b__intro_01",
		display_name = "loc_personality_name_female_zealot_2",
		preview_sound_event = "wwise/events/vo/play_preview_mask_zealot_female_b",
		sample_sound_event = "wwise/events/vo/play_preview_zealot_female_b",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"female",
			},
			archetypes = {
				"zealot",
			},
		},
	},
	{
		character_voice = "zealot_female_c",
		description = "loc_zealot_female_c__intro_01",
		display_name = "loc_personality_name_female_zealot_3",
		preview_sound_event = "wwise/events/vo/play_preview_mask_zealot_female_c",
		sample_sound_event = "wwise/events/vo/play_preview_zealot_female_c",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"female",
			},
			archetypes = {
				"zealot",
			},
		},
	},
	{
		character_voice = "psyker_male_a",
		description = "loc_psyker_male_a__intro_01",
		display_name = "loc_personality_name_male_psyker_1",
		preview_sound_event = "wwise/events/vo/play_preview_mask_psyker_male_a",
		sample_sound_event = "wwise/events/vo/play_preview_psyker_male_a",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"male",
			},
			archetypes = {
				"psyker",
			},
		},
	},
	{
		character_voice = "psyker_male_b",
		description = "loc_psyker_male_b__intro_01",
		display_name = "loc_personality_name_male_psyker_2",
		preview_sound_event = "wwise/events/vo/play_preview_mask_psyker_male_b",
		sample_sound_event = "wwise/events/vo/play_preview_psyker_male_b",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"male",
			},
			archetypes = {
				"psyker",
			},
		},
	},
	{
		character_voice = "psyker_male_c",
		description = "loc_psyker_male_c__intro_01",
		display_name = "loc_personality_name_male_psyker_3",
		preview_sound_event = "wwise/events/vo/play_preview_mask_psyker_male_c",
		sample_sound_event = "wwise/events/vo/play_preview_psyker_male_c",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"male",
			},
			archetypes = {
				"psyker",
			},
		},
	},
	{
		character_voice = "psyker_female_a",
		description = "loc_psyker_female_a__intro_01",
		display_name = "loc_personality_name_female_psyker_1",
		preview_sound_event = "wwise/events/vo/play_preview_mask_psyker_female_a",
		sample_sound_event = "wwise/events/vo/play_preview_psyker_female_a",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"female",
			},
			archetypes = {
				"psyker",
			},
		},
	},
	{
		character_voice = "psyker_female_b",
		description = "loc_psyker_female_b__intro_01",
		display_name = "loc_personality_name_female_psyker_2",
		preview_sound_event = "wwise/events/vo/play_preview_mask_psyker_female_b",
		sample_sound_event = "wwise/events/vo/play_preview_psyker_female_b",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"female",
			},
			archetypes = {
				"psyker",
			},
		},
	},
	{
		character_voice = "psyker_female_c",
		description = "loc_psyker_female_c__intro_01",
		display_name = "loc_personality_name_female_psyker_3",
		preview_sound_event = "wwise/events/vo/play_preview_mask_psyker_female_c",
		sample_sound_event = "wwise/events/vo/play_preview_psyker_female_c",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"female",
			},
			archetypes = {
				"psyker",
			},
		},
	},
	{
		character_voice = "ogryn_a",
		description = "loc_ogryn_a__intro_01",
		display_name = "loc_personality_name_ogryn_1",
		preview_sound_event = "wwise/events/vo/play_preview_mask_ogryn_a",
		sample_sound_event = "wwise/events/vo/play_preview_ogryn_a",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			archetypes = {
				"ogryn",
			},
		},
	},
	{
		character_voice = "ogryn_b",
		description = "loc_ogryn_b__intro_01",
		display_name = "loc_personality_name_ogryn_2",
		preview_sound_event = "wwise/events/vo/play_preview_mask_ogryn_b",
		sample_sound_event = "wwise/events/vo/play_preview_ogryn_b",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			archetypes = {
				"ogryn",
			},
		},
	},
	{
		character_voice = "ogryn_c",
		description = "loc_ogryn_c__intro_01",
		display_name = "loc_personality_name_ogryn_3",
		preview_sound_event = "wwise/events/vo/play_preview_mask_ogryn_c",
		sample_sound_event = "wwise/events/vo/play_preview_ogryn_c",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			archetypes = {
				"ogryn",
			},
		},
	},
	{
		character_voice = "adamant_male_a",
		description = "loc_adamant_male_a__intro_01",
		display_name = "loc_personality_name_male_adamant_1",
		preview_sound_event = "wwise/events/vo/play_preview_mask_adamant_male_a",
		sample_sound_event = "wwise/events/vo/play_preview_adamant_male_a",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"male",
			},
			archetypes = {
				"adamant",
			},
		},
	},
	{
		character_voice = "adamant_male_b",
		description = "loc_adamant_male_b__intro_01",
		display_name = "loc_personality_name_male_adamant_2",
		preview_sound_event = "wwise/events/vo/play_preview_mask_adamant_male_b",
		sample_sound_event = "wwise/events/vo/play_preview_adamant_male_b",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"male",
			},
			archetypes = {
				"adamant",
			},
		},
	},
	{
		character_voice = "adamant_male_c",
		description = "loc_adamant_male_c__intro_01",
		display_name = "loc_personality_name_male_adamant_3",
		preview_sound_event = "wwise/events/vo/play_preview_mask_adamant_male_c",
		sample_sound_event = "wwise/events/vo/play_preview_adamant_male_c",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"male",
			},
			archetypes = {
				"adamant",
			},
		},
	},
	{
		character_voice = "adamant_female_a",
		description = "loc_adamant_female_a__intro_01",
		display_name = "loc_personality_name_female_adamant_1",
		preview_sound_event = "wwise/events/vo/play_preview_mask_adamant_female_a",
		sample_sound_event = "wwise/events/vo/play_preview_adamant_female_a",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"female",
			},
			archetypes = {
				"adamant",
			},
		},
	},
	{
		character_voice = "adamant_female_b",
		description = "loc_adamant_female_b__intro_01",
		display_name = "loc_personality_name_female_adamant_2",
		preview_sound_event = "wwise/events/vo/play_preview_mask_adamant_female_b",
		sample_sound_event = "wwise/events/vo/play_preview_adamant_female_b",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"female",
			},
			archetypes = {
				"adamant",
			},
		},
	},
	{
		character_voice = "adamant_female_c",
		description = "loc_adamant_female_c__intro_01",
		display_name = "loc_personality_name_female_adamant_3",
		preview_sound_event = "wwise/events/vo/play_preview_mask_adamant_female_c",
		sample_sound_event = "wwise/events/vo/play_preview_adamant_female_c",
		unlocks = {
			{
				text = "loc_personality_effect_description",
				type = "text",
			},
		},
		visibility = {
			genders = {
				"female",
			},
			archetypes = {
				"adamant",
			},
		},
	},
}
local personality_options_by_id = {}

for i = 1, #personality_options do
	local personality_option = personality_options[i]
	local id = string.format("option_%d", i)

	personality_option.id = id
	personality_options_by_id[id] = personality_option
end

return settings("Personalities", personality_options_by_id)
