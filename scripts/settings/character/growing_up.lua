-- chunkname: @scripts/settings/character/growing_up.lua

local growing_up_options = {
	{
		description = "loc_character_growing_up_01_description",
		name = "Isolated",
		display_name = "loc_character_growing_up_01_name",
		story_snippet = "loc_character_growing_up_01_description_snippet",
		visibility = {
			archetypes = {
				"psyker",
				"zealot"
			}
		}
	},
	{
		description = "loc_character_growing_up_02_description",
		name = "Felt calling",
		display_name = "loc_character_growing_up_02_name",
		story_snippet = "loc_character_growing_up_02_description_snippet",
		visibility = {
			archetypes = {
				"zealot"
			}
		}
	},
	{
		description = "loc_character_growing_up_03_description",
		name = "Injured",
		display_name = "loc_character_growing_up_03_name",
		story_snippet = "loc_character_growing_up_03_description_snippet",
		visibility = {
			archetypes = {
				"zealot"
			}
		}
	},
	{
		description = "loc_character_growing_up_04_description",
		name = "Enlisted",
		display_name = "loc_character_growing_up_04_name",
		story_snippet = "loc_character_growing_up_04_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
				"veteran"
			}
		}
	},
	{
		description = "loc_character_growing_up_05_description",
		name = "Local Fighter",
		display_name = "loc_character_growing_up_05_name",
		story_snippet = "loc_character_growing_up_05_description_snippet",
		visibility = {
			archetypes = {
				"ogryn"
			}
		}
	},
	{
		description = "loc_character_growing_up_06_description",
		name = "Grew from toil",
		display_name = "loc_character_growing_up_06_name",
		story_snippet = "loc_character_growing_up_06_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
				"psyker"
			}
		}
	},
	{
		description = "loc_character_growing_up_07_description",
		name = "Unpaid debt",
		display_name = "loc_character_growing_up_07_name",
		story_snippet = "loc_character_growing_up_07_description_snippet",
		visibility = {
			archetypes = {
				"veteran"
			}
		}
	},
	{
		description = "loc_character_growing_up_08_description",
		name = "Crime Witness",
		display_name = "loc_character_growing_up_08_name",
		story_snippet = "loc_character_growing_up_08_description_snippet",
		visibility = {
			archetypes = {
				"veteran"
			}
		}
	},
	{
		description = "loc_character_growing_up_09_description",
		name = "Escaped to the wastes",
		display_name = "loc_character_growing_up_09_name",
		story_snippet = "loc_character_growing_up_09_description_snippet",
		visibility = {
			archetypes = {
				"psyker"
			}
		}
	},
	{
		description = "loc_character_growing_up_10_description",
		name = "Joined Mining Guild",
		display_name = "loc_character_growing_up_10_name",
		story_snippet = "loc_character_growing_up_10_description_snippet",
		visibility = {
			archetypes = {
				"ogryn"
			}
		}
	},
	{
		description = "loc_character_growing_up_11_description",
		name = "Hive ganger",
		display_name = "loc_character_growing_up_11_name",
		story_snippet = "loc_character_growing_up_11_description_snippet",
		visibility = {
			archetypes = {
				"veteran"
			}
		}
	},
	{
		description = "loc_character_growing_up_12_description",
		name = "Pilgrimage",
		display_name = "loc_character_growing_up_12_name",
		story_snippet = "loc_character_growing_up_12_description_snippet",
		visibility = {
			archetypes = {
				"zealot"
			}
		}
	},
	{
		description = "loc_character_growing_up_13_description",
		name = "Hive Guide",
		display_name = "loc_character_growing_up_13_name",
		story_snippet = "loc_character_growing_up_13_description_snippet",
		visibility = {
			archetypes = {
				"veteran"
			}
		}
	},
	{
		description = "loc_character_growing_up_14_description",
		name = "Found Discipline",
		display_name = "loc_character_growing_up_14_name",
		story_snippet = "loc_character_growing_up_14_description_snippet",
		visibility = {
			archetypes = {
				"veteran"
			}
		}
	},
	{
		description = "loc_character_growing_up_15_description",
		name = "Salvation",
		display_name = "loc_character_growing_up_15_name",
		story_snippet = "loc_character_growing_up_15_description_snippet",
		visibility = {
			archetypes = {
				"zealot"
			}
		}
	},
	{
		description = "loc_character_growing_up_16_description",
		name = "Grinding Toil",
		display_name = "loc_character_growing_up_16_name",
		story_snippet = "loc_character_growing_up_16_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
				"psyker"
			}
		}
	},
	{
		description = "loc_character_growing_up_17_description",
		name = "Strong arm",
		display_name = "loc_character_growing_up_17_name",
		story_snippet = "loc_character_growing_up_17_description_snippet",
		visibility = {
			archetypes = {
				"ogryn"
			}
		}
	},
	{
		description = "loc_character_growing_up_18_description",
		name = "Visions",
		display_name = "loc_character_growing_up_18_name",
		story_snippet = "loc_character_growing_up_18_description_snippet",
		visibility = {
			archetypes = {
				"psyker"
			}
		}
	},
	{
		description = "loc_character_growing_up_19_description",
		name = "Lesser Scribe",
		display_name = "loc_character_growing_up_19_name",
		story_snippet = "loc_character_growing_up_19_description_snippet",
		visibility = {
			archetypes = {
				"zealot"
			}
		}
	},
	{
		description = "loc_character_growing_up_20_description",
		name = "Conscripted",
		display_name = "loc_character_growing_up_20_name",
		story_snippet = "loc_character_growing_up_20_description_snippet",
		visibility = {
			archetypes = {
				"veteran"
			}
		}
	},
	{
		description = "loc_character_growing_up_21_description",
		name = "Outcast",
		display_name = "loc_character_growing_up_21_name",
		story_snippet = "loc_character_growing_up_21_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
				"psyker"
			}
		}
	},
	{
		description = "loc_character_growing_up_22_description",
		name = "Became self-reliant",
		display_name = "loc_character_growing_up_22_name",
		story_snippet = "loc_character_growing_up_22_description_snippet",
		visibility = {
			archetypes = {
				"psyker",
				"zealot"
			}
		}
	},
	{
		description = "loc_character_key_event_01_description",
		name = "Adamant 1",
		display_name = "loc_character_key_event_01_name",
		story_snippet = "loc_character_key_event_01_description_snippet",
		visibility = {
			archetypes = {
				"adamant"
			}
		}
	},
	{
		description = "loc_character_key_event_02_description",
		name = "Adamant 2",
		display_name = "loc_character_key_event_02_name",
		story_snippet = "loc_character_key_event_02_description_snippet",
		visibility = {
			archetypes = {
				"adamant"
			}
		}
	},
	{
		description = "loc_character_key_event_03_description",
		name = "Adamant 3",
		display_name = "loc_character_key_event_03_name",
		story_snippet = "loc_character_key_event_03_description_snippet",
		visibility = {
			archetypes = {
				"adamant"
			}
		}
	},
	{
		description = "loc_character_key_event_04_description",
		name = "Adamant 4",
		display_name = "loc_character_key_event_04_name",
		story_snippet = "loc_character_key_event_04_description_snippet",
		visibility = {
			archetypes = {
				"adamant"
			}
		}
	},
	{
		description = "loc_character_key_event_05_description",
		name = "Adamant 5",
		display_name = "loc_character_key_event_05_name",
		story_snippet = "loc_character_key_event_05_description_snippet",
		visibility = {
			archetypes = {
				"adamant"
			}
		}
	},
	{
		description = "loc_character_key_event_06_description",
		name = "Adamant 6",
		display_name = "loc_character_key_event_06_name",
		story_snippet = "loc_character_key_event_06_description_snippet",
		visibility = {
			archetypes = {
				"adamant"
			}
		}
	},
	{
		description = "loc_character_key_event_07_description",
		name = "Adamant 7",
		display_name = "loc_character_key_event_07_name",
		story_snippet = "loc_character_key_event_07_description_snippet",
		visibility = {
			archetypes = {
				"adamant"
			}
		}
	}
}
local growing_up_options_by_id = {}

for i = 1, #growing_up_options do
	local growing_up_option = growing_up_options[i]
	local id = string.format("option_%d", i)

	growing_up_option.id = id
	growing_up_options_by_id[id] = growing_up_option
end

return settings("GrowingUp", growing_up_options_by_id)
