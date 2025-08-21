-- chunkname: @scripts/settings/character/crimes_ogryn.lua

local crime_options = {
	{
		description = "loc_character_sentence_01_description",
		display_name = "loc_character_sentence_01_name",
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
		visibility = {
			archetypes = {
				"ogryn",
			},
		},
	},
	{
		description = "loc_character_sentence_02_description",
		display_name = "loc_character_sentence_02_name",
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
		visibility = {
			archetypes = {
				"ogryn",
			},
		},
	},
	{
		description = "loc_character_sentence_03_description",
		display_name = "loc_character_sentence_03_name",
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
		visibility = {
			archetypes = {
				"ogryn",
			},
		},
	},
	{
		description = "loc_character_sentence_04_description",
		display_name = "loc_character_sentence_04_name",
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
		visibility = {
			archetypes = {
				"ogryn",
			},
		},
	},
}

return crime_options
