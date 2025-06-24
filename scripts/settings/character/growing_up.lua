-- chunkname: @scripts/settings/character/growing_up.lua

local growing_up_options = {
	{
		description = "loc_character_growing_up_01_description",
		display_name = "loc_character_growing_up_01_name",
		name = "Isolated",
		story_snippet = "loc_character_growing_up_01_description_snippet",
		visibility = {
			archetypes = {
				"psyker",
				"zealot",
			},
		},
	},
	{
		description = "loc_character_growing_up_02_description",
		display_name = "loc_character_growing_up_02_name",
		name = "Felt calling",
		story_snippet = "loc_character_growing_up_02_description_snippet",
		visibility = {
			archetypes = {
				"zealot",
			},
		},
	},
	{
		description = "loc_character_growing_up_03_description",
		display_name = "loc_character_growing_up_03_name",
		name = "Injured",
		story_snippet = "loc_character_growing_up_03_description_snippet",
		visibility = {
			archetypes = {
				"zealot",
			},
		},
	},
	{
		description = "loc_character_growing_up_04_description",
		display_name = "loc_character_growing_up_04_name",
		name = "Enlisted",
		story_snippet = "loc_character_growing_up_04_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
				"veteran",
			},
		},
	},
	{
		description = "loc_character_growing_up_05_description",
		display_name = "loc_character_growing_up_05_name",
		name = "Local Fighter",
		story_snippet = "loc_character_growing_up_05_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
			},
		},
	},
	{
		description = "loc_character_growing_up_06_description",
		display_name = "loc_character_growing_up_06_name",
		name = "Grew from toil",
		story_snippet = "loc_character_growing_up_06_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
				"psyker",
			},
		},
	},
	{
		description = "loc_character_growing_up_07_description",
		display_name = "loc_character_growing_up_07_name",
		name = "Unpaid debt",
		story_snippet = "loc_character_growing_up_07_description_snippet",
		visibility = {
			archetypes = {
				"veteran",
			},
		},
	},
	{
		description = "loc_character_growing_up_08_description",
		display_name = "loc_character_growing_up_08_name",
		name = "Crime Witness",
		story_snippet = "loc_character_growing_up_08_description_snippet",
		visibility = {
			archetypes = {
				"veteran",
			},
		},
	},
	{
		description = "loc_character_growing_up_09_description",
		display_name = "loc_character_growing_up_09_name",
		name = "Escaped to the wastes",
		story_snippet = "loc_character_growing_up_09_description_snippet",
		visibility = {
			archetypes = {
				"psyker",
			},
		},
	},
	{
		description = "loc_character_growing_up_10_description",
		display_name = "loc_character_growing_up_10_name",
		name = "Joined Mining Guild",
		story_snippet = "loc_character_growing_up_10_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
			},
		},
	},
	{
		description = "loc_character_growing_up_11_description",
		display_name = "loc_character_growing_up_11_name",
		name = "Hive ganger",
		story_snippet = "loc_character_growing_up_11_description_snippet",
		visibility = {
			archetypes = {
				"veteran",
			},
		},
	},
	{
		description = "loc_character_growing_up_12_description",
		display_name = "loc_character_growing_up_12_name",
		name = "Pilgrimage",
		story_snippet = "loc_character_growing_up_12_description_snippet",
		visibility = {
			archetypes = {
				"zealot",
			},
		},
	},
	{
		description = "loc_character_growing_up_13_description",
		display_name = "loc_character_growing_up_13_name",
		name = "Hive Guide",
		story_snippet = "loc_character_growing_up_13_description_snippet",
		visibility = {
			archetypes = {
				"veteran",
			},
		},
	},
	{
		description = "loc_character_growing_up_14_description",
		display_name = "loc_character_growing_up_14_name",
		name = "Found Discipline",
		story_snippet = "loc_character_growing_up_14_description_snippet",
		visibility = {
			archetypes = {
				"veteran",
			},
		},
	},
	{
		description = "loc_character_growing_up_15_description",
		display_name = "loc_character_growing_up_15_name",
		name = "Salvation",
		story_snippet = "loc_character_growing_up_15_description_snippet",
		visibility = {
			archetypes = {
				"zealot",
			},
		},
	},
	{
		description = "loc_character_growing_up_16_description",
		display_name = "loc_character_growing_up_16_name",
		name = "Grinding Toil",
		story_snippet = "loc_character_growing_up_16_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
				"psyker",
			},
		},
	},
	{
		description = "loc_character_growing_up_17_description",
		display_name = "loc_character_growing_up_17_name",
		name = "Strong arm",
		story_snippet = "loc_character_growing_up_17_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
			},
		},
	},
	{
		description = "loc_character_growing_up_18_description",
		display_name = "loc_character_growing_up_18_name",
		name = "Visions",
		story_snippet = "loc_character_growing_up_18_description_snippet",
		visibility = {
			archetypes = {
				"psyker",
			},
		},
	},
	{
		description = "loc_character_growing_up_19_description",
		display_name = "loc_character_growing_up_19_name",
		name = "Lesser Scribe",
		story_snippet = "loc_character_growing_up_19_description_snippet",
		visibility = {
			archetypes = {
				"zealot",
			},
		},
	},
	{
		description = "loc_character_growing_up_20_description",
		display_name = "loc_character_growing_up_20_name",
		name = "Conscripted",
		story_snippet = "loc_character_growing_up_20_description_snippet",
		visibility = {
			archetypes = {
				"veteran",
			},
		},
	},
	{
		description = "loc_character_growing_up_21_description",
		display_name = "loc_character_growing_up_21_name",
		name = "Outcast",
		story_snippet = "loc_character_growing_up_21_description_snippet",
		visibility = {
			archetypes = {
				"ogryn",
				"psyker",
			},
		},
	},
	{
		description = "loc_character_growing_up_22_description",
		display_name = "loc_character_growing_up_22_name",
		name = "Became self-reliant",
		story_snippet = "loc_character_growing_up_22_description_snippet",
		visibility = {
			archetypes = {
				"psyker",
				"zealot",
			},
		},
	},
	{
		description = "loc_character_key_event_01_description",
		display_name = "loc_character_key_event_01_name",
		name = "Adamant 1",
		story_snippet = "loc_character_key_event_01_description_snippet",
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
	{
		description = "loc_character_key_event_02_description",
		display_name = "loc_character_key_event_02_name",
		name = "Adamant 2",
		story_snippet = "loc_character_key_event_02_description_snippet",
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
	{
		description = "loc_character_key_event_03_description",
		display_name = "loc_character_key_event_03_name",
		name = "Adamant 3",
		story_snippet = "loc_character_key_event_03_description_snippet",
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
	{
		description = "loc_character_key_event_04_description",
		display_name = "loc_character_key_event_04_name",
		name = "Adamant 4",
		story_snippet = "loc_character_key_event_04_description_snippet",
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
	{
		description = "loc_character_key_event_05_description",
		display_name = "loc_character_key_event_05_name",
		name = "Adamant 5",
		story_snippet = "loc_character_key_event_05_description_snippet",
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
	{
		description = "loc_character_key_event_06_description",
		display_name = "loc_character_key_event_06_name",
		name = "Adamant 6",
		story_snippet = "loc_character_key_event_06_description_snippet",
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
	{
		description = "loc_character_key_event_07_description",
		display_name = "loc_character_key_event_07_name",
		name = "Adamant 7",
		story_snippet = "loc_character_key_event_07_description_snippet",
		visibility = {
			archetypes = {
				"adamant",
			},
		},
	},
}
local growing_up_options_by_id = {}

for i = 1, #growing_up_options do
	local growing_up_option = growing_up_options[i]
	local id = string.format("option_%d", i)

	growing_up_option.id = id
	growing_up_options_by_id[id] = growing_up_option
end

return settings("GrowingUp", growing_up_options_by_id)
