-- chunkname: @scripts/settings/character/formative_event.lua

local formative_event_options = {
	{
		description = "loc_character_event_01_description",
		display_name = "loc_character_event_01_name",
		name = "Stranded",
		story_snippet = "loc_character_event_01_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
			},
		},
	},
	{
		description = "loc_character_event_02_description",
		display_name = "loc_character_event_02_name",
		name = "Ulk Station Massacre",
		story_snippet = "loc_character_event_02_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
			},
		},
	},
	{
		description = "loc_character_event_03_description",
		display_name = "loc_character_event_03_name",
		name = "Captured",
		story_snippet = "loc_character_event_03_description_snippet",
		visibility = {
			archetypes = {
				"psyker",
			},
		},
	},
	{
		description = "loc_character_event_04_description",
		display_name = "loc_character_event_04_name",
		name = "Recruited",
		story_snippet = "loc_character_event_04_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
				"veteran",
			},
		},
	},
	{
		description = "loc_character_event_05_description",
		display_name = "loc_character_event_05_name",
		name = "Contact with Cult",
		story_snippet = "loc_character_event_05_description_snippet",
		visibility = {
			archetypes = {
				"zealot",
			},
		},
	},
	{
		description = "loc_character_event_06_description",
		display_name = "loc_character_event_06_name",
		name = "Found strange artifact",
		story_snippet = "loc_character_event_06_description_snippet",
		visibility = {
			archetypes = {
				"zealot",
			},
		},
	},
	{
		description = "loc_character_event_07_description",
		display_name = "loc_character_event_07_name",
		name = "Hunted",
		story_snippet = "loc_character_event_07_description_snippet",
		visibility = {
			archetypes = {
				"zealot",
			},
		},
	},
	{
		description = "loc_character_event_08_description",
		display_name = "loc_character_event_08_name",
		name = "Sickened",
		story_snippet = "loc_character_event_08_description_snippet",
		visibility = {
			archetypes = {
				"zealot",
			},
		},
	},
	{
		description = "loc_character_event_09_description",
		display_name = "loc_character_event_09_name",
		name = "Identified as Psyker",
		story_snippet = "loc_character_event_09_description_snippet",
		visibility = {
			archetypes = {
				"psyker",
			},
		},
	},
	{
		description = "loc_character_event_10_description",
		display_name = "loc_character_event_10_name",
		name = "Mine Collapse",
		story_snippet = "loc_character_event_10_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
			},
		},
	},
	{
		description = "loc_character_event_11_description",
		display_name = "loc_character_event_11_name",
		name = "Promotion to NCO",
		story_snippet = "loc_character_event_11_description_snippet",
		visibility = {
			archetypes = {
				"veteran",
			},
		},
	},
	{
		description = "loc_character_event_12_description",
		display_name = "loc_character_event_12_name",
		name = "Psychic Awakening",
		story_snippet = "loc_character_event_12_description_snippet",
		visibility = {
			archetypes = {
				"psyker",
			},
		},
	},
	{
		description = "loc_character_event_13_description",
		display_name = "loc_character_event_13_name",
		name = "Mutant incident",
		story_snippet = "loc_character_event_13_description_snippet",
		visibility = {
			archetypes = {
				"psyker",
				"zealot",
			},
		},
	},
	{
		description = "loc_character_event_14_description",
		display_name = "loc_character_event_14_name",
		name = "Spell of Madness",
		story_snippet = "loc_character_event_14_description_snippet",
		visibility = {
			archetypes = {
				"psyker",
			},
		},
	},
	{
		description = "loc_character_event_15_description",
		display_name = "loc_character_event_15_name",
		name = "Hatred of Heretics",
		story_snippet = "loc_character_event_15_description_snippet",
		visibility = {
			archetypes = {
				"zealot",
			},
		},
	},
	{
		description = "loc_character_event_16_description",
		display_name = "loc_character_event_16_name",
		name = "Bad Warp",
		story_snippet = "loc_character_event_16_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
				"veteran",
			},
		},
	},
	{
		description = "loc_character_event_17_description",
		display_name = "loc_character_event_17_name",
		name = "Elite formation",
		story_snippet = "loc_character_event_17_description_snippet",
		visibility = {
			archetypes = {
				"veteran",
			},
		},
	},
	{
		description = "loc_character_event_18_description",
		display_name = "loc_character_event_18_name",
		name = "Internal voices",
		story_snippet = "loc_character_event_18_description_snippet",
		visibility = {
			archetypes = {
				"psyker",
				"zealot",
			},
		},
	},
	{
		description = "loc_character_event_19_description",
		display_name = "loc_character_event_19_name",
		name = "Saved by Sergeant",
		story_snippet = "loc_character_event_19_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
				"veteran",
			},
		},
	},
	{
		description = "loc_character_event_20_description",
		display_name = "loc_character_event_20_name",
		name = "Avoided the Blackships",
		story_snippet = "loc_character_event_20_description_snippet",
		visibility = {
			archetypes = {
				"psyker",
			},
		},
	},
	{
		description = "loc_character_event_21_description",
		display_name = "loc_character_event_21_name",
		name = "Decorated for Bravery",
		story_snippet = "loc_character_event_21_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
				"veteran",
			},
		},
	},
	{
		description = "loc_character_event_22_description",
		display_name = "loc_character_event_22_name",
		name = "Duel",
		story_snippet = "loc_character_event_22_description_snippet",
		visibility = {
			archetypes = {
				"veteran",
			},
		},
	},
	{
		description = "loc_character_commendations_01_description",
		display_name = "loc_character_commendations_01_name",
		name = "Adamant 1",
		story_snippet = "loc_character_commendations_01_description_snippet",
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
	{
		description = "loc_character_commendations_02_description",
		display_name = "loc_character_commendations_02_name",
		name = "Adamant 2",
		story_snippet = "loc_character_commendations_02_description_snippet",
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
	{
		description = "loc_character_commendations_03_description",
		display_name = "loc_character_commendations_03_name",
		name = "Adamant 3",
		story_snippet = "loc_character_commendations_03_description_snippet",
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
	{
		description = "loc_character_commendations_04_description",
		display_name = "loc_character_commendations_04_name",
		name = "Adamant 4",
		story_snippet = "loc_character_commendations_04_description_snippet",
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
	{
		description = "loc_character_commendations_05_description",
		display_name = "loc_character_commendations_05_name",
		name = "Adamant 5",
		story_snippet = "loc_character_commendations_05_description_snippet",
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
	{
		description = "loc_character_commendations_06_description",
		display_name = "loc_character_commendations_06_name",
		name = "Adamant 6",
		story_snippet = "loc_character_commendations_06_description_snippet",
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
	{
		description = "loc_character_commendations_07_description",
		display_name = "loc_character_commendations_07_name",
		name = "Adamant 7",
		story_snippet = "loc_character_commendations_07_description_snippet",
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
}
local formative_event_options_by_id = {}

for i = 1, #formative_event_options do
	local formative_event_option = formative_event_options[i]
	local id = string.format("option_%d", i)

	formative_event_option.id = id
	formative_event_options_by_id[id] = formative_event_option
end

return settings("FormativeEvent", formative_event_options_by_id)
