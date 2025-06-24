-- chunkname: @scripts/settings/character/crimes.lua

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
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_c",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_c",
		},
		visibility = {
			archetypes = {
				"veteran",
				"zealot",
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
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_a",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_a",
		},
		visibility = {
			archetypes = {
				"veteran",
				"zealot",
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
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_b",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_b",
		},
		visibility = {
			archetypes = {
				"veteran",
				"zealot",
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
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_d",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_d",
		},
		visibility = {
			archetypes = {
				"veteran",
				"zealot",
			},
		},
	},
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
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_c",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_psyker_c",
		},
		visibility = {
			archetypes = {
				"psyker",
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
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_a",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_psyker_a",
		},
		visibility = {
			archetypes = {
				"psyker",
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
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_b",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_psyker_b",
		},
		visibility = {
			archetypes = {
				"psyker",
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
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/prisoner_lowerbody_d",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/prisoner_upperbody_psyker_d",
		},
		visibility = {
			archetypes = {
				"psyker",
			},
		},
	},
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
	{
		description = "loc_character_precinct_01_description",
		display_name = "loc_character_precinct_01_name",
		name = "Adamant 1",
		story_snippet = "loc_character_precinct_01_description_snippet",
		unlocks = {
			{
				text = "loc_character_precinct_01_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_head = "content/items/characters/player/human/gear_head/adamant_headgear_01_var_01",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/adamant_lowerbody_a_var_01",
			slot_gear_material_override_decal = "content/items/characters/player/human/gear_material_override_decal/decal_atlas_adamant_precincts_01_decal_01",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/adamant_upperbody_a_var_01",
		},
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
	{
		description = "loc_character_precinct_02_description",
		display_name = "loc_character_precinct_02_name",
		name = "Adamant 2",
		story_snippet = "loc_character_precinct_02_description_snippet",
		unlocks = {
			{
				text = "loc_character_precinct_02_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_head = "content/items/characters/player/human/gear_head/adamant_headgear_01_var_01",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/adamant_lowerbody_a_var_01",
			slot_gear_material_override_decal = "content/items/characters/player/human/gear_material_override_decal/decal_atlas_adamant_precincts_01_decal_02",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/adamant_upperbody_a_var_01",
		},
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
	{
		description = "loc_character_precinct_03_description",
		display_name = "loc_character_precinct_03_name",
		name = "Adamant 3",
		story_snippet = "loc_character_precinct_03_description_snippet",
		unlocks = {
			{
				text = "loc_character_precinct_03_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_head = "content/items/characters/player/human/gear_head/adamant_headgear_01_var_01",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/adamant_lowerbody_a_var_01",
			slot_gear_material_override_decal = "content/items/characters/player/human/gear_material_override_decal/decal_atlas_adamant_precincts_01_decal_03",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/adamant_upperbody_a_var_01",
		},
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
	{
		description = "loc_character_precinct_04_description",
		display_name = "loc_character_precinct_04_name",
		name = "Adamant 4",
		story_snippet = "loc_character_precinct_04_description_snippet",
		unlocks = {
			{
				text = "loc_character_precinct_04_unlocks",
				type = "text",
			},
		},
		slot_items = {
			slot_gear_head = "content/items/characters/player/human/gear_head/adamant_headgear_01_var_01",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/adamant_lowerbody_a_var_01",
			slot_gear_material_override_decal = "content/items/characters/player/human/gear_material_override_decal/decal_atlas_adamant_precincts_01_decal_04",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/adamant_upperbody_a_var_01",
		},
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
}
local crime_options_by_id = {}

for i = 1, #crime_options do
	local crime_option = crime_options[i]
	local id = string.format("option_%d", i)

	crime_option.id = id
	crime_options_by_id[id] = crime_option
end

return settings("Crimes", crime_options_by_id)
