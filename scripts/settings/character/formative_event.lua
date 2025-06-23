-- chunkname: @scripts/settings/character/formative_event.lua

local formative_event_options = {
	{
		description = "loc_character_event_01_description",
		name = "Stranded",
		display_name = "loc_character_event_01_name",
		story_snippet = "loc_character_event_01_description_snippet",
		visibility = {
			archetypes = {
				"ogryn"
			}
		}
	},
	{
		description = "loc_character_event_02_description",
		name = "Ulk Station Massacre",
		display_name = "loc_character_event_02_name",
		story_snippet = "loc_character_event_02_description_snippet",
		visibility = {
			archetypes = {
				"ogryn"
			}
		}
	},
	{
		description = "loc_character_event_03_description",
		name = "Captured",
		display_name = "loc_character_event_03_name",
		story_snippet = "loc_character_event_03_description_snippet",
		visibility = {
			archetypes = {
				"psyker"
			}
		}
	},
	{
		description = "loc_character_event_04_description",
		name = "Recruited",
		display_name = "loc_character_event_04_name",
		story_snippet = "loc_character_event_04_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
				"veteran"
			}
		}
	},
	{
		description = "loc_character_event_05_description",
		name = "Contact with Cult",
		display_name = "loc_character_event_05_name",
		story_snippet = "loc_character_event_05_description_snippet",
		visibility = {
			archetypes = {
				"zealot"
			}
		}
	},
	{
		description = "loc_character_event_06_description",
		name = "Found strange artifact",
		display_name = "loc_character_event_06_name",
		story_snippet = "loc_character_event_06_description_snippet",
		visibility = {
			archetypes = {
				"zealot"
			}
		}
	},
	{
		description = "loc_character_event_07_description",
		name = "Hunted",
		display_name = "loc_character_event_07_name",
		story_snippet = "loc_character_event_07_description_snippet",
		visibility = {
			archetypes = {
				"zealot"
			}
		}
	},
	{
		description = "loc_character_event_08_description",
		name = "Sickened",
		display_name = "loc_character_event_08_name",
		story_snippet = "loc_character_event_08_description_snippet",
		visibility = {
			archetypes = {
				"zealot"
			}
		}
	},
	{
		description = "loc_character_event_09_description",
		name = "Identified as Psyker",
		display_name = "loc_character_event_09_name",
		story_snippet = "loc_character_event_09_description_snippet",
		visibility = {
			archetypes = {
				"psyker"
			}
		}
	},
	{
		description = "loc_character_event_10_description",
		name = "Mine Collapse",
		display_name = "loc_character_event_10_name",
		story_snippet = "loc_character_event_10_description_snippet",
		visibility = {
			archetypes = {
				"ogryn"
			}
		}
	},
	{
		description = "loc_character_event_11_description",
		name = "Promotion to NCO",
		display_name = "loc_character_event_11_name",
		story_snippet = "loc_character_event_11_description_snippet",
		visibility = {
			archetypes = {
				"veteran"
			}
		}
	},
	{
		description = "loc_character_event_12_description",
		name = "Psychic Awakening",
		display_name = "loc_character_event_12_name",
		story_snippet = "loc_character_event_12_description_snippet",
		visibility = {
			archetypes = {
				"psyker"
			}
		}
	},
	{
		description = "loc_character_event_13_description",
		name = "Mutant incident",
		display_name = "loc_character_event_13_name",
		story_snippet = "loc_character_event_13_description_snippet",
		visibility = {
			archetypes = {
				"psyker",
				"zealot"
			}
		}
	},
	{
		description = "loc_character_event_14_description",
		name = "Spell of Madness",
		display_name = "loc_character_event_14_name",
		story_snippet = "loc_character_event_14_description_snippet",
		visibility = {
			archetypes = {
				"psyker"
			}
		}
	},
	{
		description = "loc_character_event_15_description",
		name = "Hatred of Heretics",
		display_name = "loc_character_event_15_name",
		story_snippet = "loc_character_event_15_description_snippet",
		visibility = {
			archetypes = {
				"zealot"
			}
		}
	},
	{
		description = "loc_character_event_16_description",
		name = "Bad Warp",
		display_name = "loc_character_event_16_name",
		story_snippet = "loc_character_event_16_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
				"veteran"
			}
		}
	},
	{
		description = "loc_character_event_17_description",
		name = "Elite formation",
		display_name = "loc_character_event_17_name",
		story_snippet = "loc_character_event_17_description_snippet",
		visibility = {
			archetypes = {
				"veteran"
			}
		}
	},
	{
		description = "loc_character_event_18_description",
		name = "Internal voices",
		display_name = "loc_character_event_18_name",
		story_snippet = "loc_character_event_18_description_snippet",
		visibility = {
			archetypes = {
				"psyker",
				"zealot"
			}
		}
	},
	{
		description = "loc_character_event_19_description",
		name = "Saved by Sergeant",
		display_name = "loc_character_event_19_name",
		story_snippet = "loc_character_event_19_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
				"veteran"
			}
		}
	},
	{
		description = "loc_character_event_20_description",
		name = "Avoided the Blackships",
		display_name = "loc_character_event_20_name",
		story_snippet = "loc_character_event_20_description_snippet",
		visibility = {
			archetypes = {
				"psyker"
			}
		}
	},
	{
		description = "loc_character_event_21_description",
		name = "Decorated for Bravery",
		display_name = "loc_character_event_21_name",
		story_snippet = "loc_character_event_21_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
				"veteran"
			}
		}
	},
	{
		description = "loc_character_event_22_description",
		name = "Duel",
		display_name = "loc_character_event_22_name",
		story_snippet = "loc_character_event_22_description_snippet",
		visibility = {
			archetypes = {
				"veteran"
			}
		}
	},
	{
		description = "loc_character_commendations_01_description",
		name = "Adamant 1",
		display_name = "loc_character_commendations_01_name",
		story_snippet = "loc_character_commendations_01_description_snippet",
		visibility = {
			archetypes = {
				"adamant"
			}
		}
	},
	{
		description = "loc_character_commendations_02_description",
		name = "Adamant 2",
		display_name = "loc_character_commendations_02_name",
		story_snippet = "loc_character_commendations_02_description_snippet",
		visibility = {
			archetypes = {
				"adamant"
			}
		}
	},
	{
		description = "loc_character_commendations_03_description",
		name = "Adamant 3",
		display_name = "loc_character_commendations_03_name",
		story_snippet = "loc_character_commendations_03_description_snippet",
		visibility = {
			archetypes = {
				"adamant"
			}
		}
	},
	{
		description = "loc_character_commendations_04_description",
		name = "Adamant 4",
		display_name = "loc_character_commendations_04_name",
		story_snippet = "loc_character_commendations_04_description_snippet",
		visibility = {
			archetypes = {
				"adamant"
			}
		}
	},
	{
		description = "loc_character_commendations_05_description",
		name = "Adamant 5",
		display_name = "loc_character_commendations_05_name",
		story_snippet = "loc_character_commendations_05_description_snippet",
		visibility = {
			archetypes = {
				"adamant"
			}
		}
	},
	{
		description = "loc_character_commendations_06_description",
		name = "Adamant 6",
		display_name = "loc_character_commendations_06_name",
		story_snippet = "loc_character_commendations_06_description_snippet",
		visibility = {
			archetypes = {
				"adamant"
			}
		}
	},
	{
		description = "loc_character_commendations_07_description",
		name = "Adamant 7",
		display_name = "loc_character_commendations_07_name",
		story_snippet = "loc_character_commendations_07_description_snippet",
		visibility = {
			archetypes = {
				"adamant"
			}
		}
	}
}
local formative_event_options_by_id = {}

for i = 1, #formative_event_options do
	local formative_event_option = formative_event_options[i]
	local id = string.format("option_%d", i)

	formative_event_option.id = id
	formative_event_options_by_id[id] = formative_event_option
end

return settings("FormativeEvent", formative_event_options_by_id)
