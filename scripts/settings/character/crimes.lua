-- chunkname: @scripts/settings/character/crimes.lua

local crimes = {
	veteran_1 = {
		archetype = "veteran",
		description = "loc_character_sentence_01_description",
		display_name = "loc_character_sentence_01_name",
		id = "sentence_01",
		name = "Insubordination",
		story_snippet = "loc_character_sentence_01_description_snippet",
		unlocks = {
			{
				text = "loc_character_sentence_01_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_c",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_c",
		},
	},
	veteran_2 = {
		archetype = "veteran",
		description = "loc_character_sentence_02_description",
		display_name = "loc_character_sentence_02_name",
		id = "sentence_02",
		name = "Theft",
		story_snippet = "loc_character_sentence_02_description_snippet",
		unlocks = {
			{
				text = "loc_character_sentence_02_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_a",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_a",
		},
	},
	veteran_3 = {
		archetype = "veteran",
		description = "loc_character_sentence_03_description",
		display_name = "loc_character_sentence_03_name",
		id = "sentence_03",
		name = "Unauthorized absence",
		story_snippet = "loc_character_sentence_03_description_snippet",
		unlocks = {
			{
				text = "loc_character_sentence_03_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_b",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_b",
		},
	},
	veteran_4 = {
		archetype = "veteran",
		description = "loc_character_sentence_04_description",
		display_name = "loc_character_sentence_04_name",
		id = "sentence_04",
		name = "Smuggling",
		story_snippet = "loc_character_sentence_04_description_snippet",
		unlocks = {
			{
				text = "loc_character_sentence_04_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_d",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_d",
		},
	},
	zealot_1 = {
		archetype = "zealot",
		description = "loc_character_sentence_01_description",
		display_name = "loc_character_sentence_01_name",
		id = "sentence_01",
		name = "Insubordination",
		story_snippet = "loc_character_sentence_01_description_snippet",
		unlocks = {
			{
				text = "loc_character_sentence_01_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_c",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_c",
		},
	},
	zealot_2 = {
		archetype = "zealot",
		description = "loc_character_sentence_02_description",
		display_name = "loc_character_sentence_02_name",
		id = "sentence_02",
		name = "Theft",
		story_snippet = "loc_character_sentence_02_description_snippet",
		unlocks = {
			{
				text = "loc_character_sentence_02_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_a",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_a",
		},
	},
	zealot_3 = {
		archetype = "zealot",
		description = "loc_character_sentence_03_description",
		display_name = "loc_character_sentence_03_name",
		id = "sentence_03",
		name = "Unauthorized absence",
		story_snippet = "loc_character_sentence_03_description_snippet",
		unlocks = {
			{
				text = "loc_character_sentence_03_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_b",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_b",
		},
	},
	zealot_4 = {
		archetype = "zealot",
		description = "loc_character_sentence_04_description",
		display_name = "loc_character_sentence_04_name",
		id = "sentence_04",
		name = "Smuggling",
		story_snippet = "loc_character_sentence_04_description_snippet",
		unlocks = {
			{
				text = "loc_character_sentence_04_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_d",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_d",
		},
	},
	psyker_1 = {
		archetype = "psyker",
		description = "loc_character_sentence_01_description",
		display_name = "loc_character_sentence_01_name",
		id = "sentence_01",
		name = "Insubordination",
		story_snippet = "loc_character_sentence_01_description_snippet",
		unlocks = {
			{
				text = "loc_character_sentence_01_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_c",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_psyker_c",
		},
	},
	psyker_2 = {
		archetype = "psyker",
		description = "loc_character_sentence_02_description",
		display_name = "loc_character_sentence_02_name",
		id = "sentence_02",
		name = "Theft",
		story_snippet = "loc_character_sentence_02_description_snippet",
		unlocks = {
			{
				text = "loc_character_sentence_02_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_a",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_psyker_a",
		},
	},
	psyker_3 = {
		archetype = "psyker",
		description = "loc_character_sentence_03_description",
		display_name = "loc_character_sentence_03_name",
		id = "sentence_03",
		name = "Unauthorized absence",
		story_snippet = "loc_character_sentence_03_description_snippet",
		unlocks = {
			{
				text = "loc_character_sentence_03_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_b",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_psyker_b",
		},
	},
	psyker_4 = {
		archetype = "psyker",
		description = "loc_character_sentence_04_description",
		display_name = "loc_character_sentence_04_name",
		id = "sentence_04",
		name = "Smuggling",
		story_snippet = "loc_character_sentence_04_description_snippet",
		unlocks = {
			{
				text = "loc_character_sentence_04_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_d",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_psyker_d",
		},
	},
	ogryn_1 = {
		archetype = "ogryn",
		description = "loc_character_sentence_01_description",
		display_name = "loc_character_sentence_01_name",
		id = "sentence_01",
		name = "Insubordination",
		story_snippet = "loc_character_sentence_01_description_snippet",
		unlocks = {
			{
				text = "loc_character_sentence_01_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_lowerbody = "content/items/characters/player/ogryn/gear_lowerbody/ogryn_prisoner_lowerbody_c",
			slot_gear_upperbody = "content/items/characters/player/ogryn/gear_upperbody/ogryn_prisoner_upperbody_c",
		},
	},
	ogryn_2 = {
		archetype = "ogryn",
		description = "loc_character_sentence_02_description",
		display_name = "loc_character_sentence_02_name",
		id = "sentence_02",
		name = "Theft",
		story_snippet = "loc_character_sentence_02_description_snippet",
		unlocks = {
			{
				text = "loc_character_sentence_02_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_lowerbody = "content/items/characters/player/ogryn/gear_lowerbody/ogryn_prisoner_lowerbody_a",
			slot_gear_upperbody = "content/items/characters/player/ogryn/gear_upperbody/ogryn_prisoner_upperbody_a",
		},
	},
	ogryn_3 = {
		archetype = "ogryn",
		description = "loc_character_sentence_03_description",
		display_name = "loc_character_sentence_03_name",
		id = "sentence_03",
		name = "Unauthorized absence",
		story_snippet = "loc_character_sentence_03_description_snippet",
		unlocks = {
			{
				text = "loc_character_sentence_03_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_lowerbody = "content/items/characters/player/ogryn/gear_lowerbody/ogryn_prisoner_lowerbody_b",
			slot_gear_upperbody = "content/items/characters/player/ogryn/gear_upperbody/ogryn_prisoner_upperbody_b",
		},
	},
	ogryn_4 = {
		archetype = "ogryn",
		description = "loc_character_sentence_04_description",
		display_name = "loc_character_sentence_04_name",
		id = "sentence_04",
		name = "Smuggling",
		story_snippet = "loc_character_sentence_04_description_snippet",
		unlocks = {
			{
				text = "loc_character_sentence_04_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_lowerbody = "content/items/characters/player/ogryn/gear_lowerbody/ogryn_prisoner_lowerbody_d",
			slot_gear_upperbody = "content/items/characters/player/ogryn/gear_upperbody/ogryn_prisoner_upperbody_d",
		},
	},
}

return settings("Crimes", crimes)
