-- chunkname: @scripts/settings/character/home_planets.lua

local HOME_PLANETS_BROKER = require("scripts/settings/character/home_planets_broker")
local HOME_PLANETS_CRYPTIC = require("scripts/settings/character/home_planets_cryptic")
local home_planet_options = {
	{
		description = "loc_character_birthplace_planet_01_description",
		display_name = "loc_character_birthplace_planet_01_name",
		name = "Branx Magna",
		story_snippet = "loc_character_birthplace_planet_01_description_snippet",
		image = {
			path = "content/ui/textures/backgrounds/backstory/planets/branx_magna",
			size = {
				512,
				512,
			},
		},
		position = {
			3040,
			2416,
		},
		visibility = {
			archetypes = {
				"adamant",
				"ogryn",
				"psyker",
				"veteran",
				"zealot",
			},
		},
	},
	{
		description = "loc_character_birthplace_planet_02_description",
		display_name = "loc_character_birthplace_planet_02_name",
		name = "Crucis",
		story_snippet = "loc_character_birthplace_planet_02_description_snippet",
		image = {
			path = "content/ui/textures/backgrounds/backstory/planets/crucis",
			size = {
				512,
				512,
			},
		},
		position = {
			4185,
			2447,
		},
		visibility = {
			archetypes = {
				"adamant",
				"ogryn",
				"psyker",
				"veteran",
				"zealot",
			},
		},
	},
	{
		description = "loc_character_birthplace_planet_03_description",
		display_name = "loc_character_birthplace_planet_03_name",
		name = "Mornax",
		story_snippet = "loc_character_birthplace_planet_03_description_snippet",
		image = {
			path = "content/ui/textures/backgrounds/backstory/planets/mornax",
			size = {
				512,
				512,
			},
		},
		position = {
			3751,
			1698,
		},
		visibility = {
			archetypes = {
				"adamant",
				"ogryn",
				"psyker",
				"veteran",
				"zealot",
			},
		},
	},
	{
		description = "loc_character_birthplace_planet_04_description",
		display_name = "loc_character_birthplace_planet_04_name",
		name = "Incron",
		story_snippet = "loc_character_birthplace_planet_04_description_snippet",
		image = {
			path = "content/ui/textures/backgrounds/backstory/planets/incron",
			size = {
				512,
				512,
			},
		},
		position = {
			2426,
			1626,
		},
		visibility = {
			archetypes = {
				"adamant",
				"ogryn",
				"psyker",
				"veteran",
				"zealot",
			},
		},
	},
	{
		description = "loc_character_birthplace_planet_05_description",
		display_name = "loc_character_birthplace_planet_05_name",
		name = "Rocyria",
		story_snippet = "loc_character_birthplace_planet_05_description_snippet",
		image = {
			path = "content/ui/textures/backgrounds/backstory/planets/rocyria",
			size = {
				512,
				512,
			},
		},
		position = {
			3074,
			822,
		},
		visibility = {
			archetypes = {
				"adamant",
				"ogryn",
				"psyker",
				"veteran",
				"zealot",
			},
		},
	},
	{
		description = "loc_character_birthplace_planet_06_description",
		display_name = "loc_character_birthplace_planet_06_name",
		name = "Pavane",
		story_snippet = "loc_character_birthplace_planet_06_description_snippet",
		image = {
			path = "content/ui/textures/backgrounds/backstory/planets/pavane",
			size = {
				512,
				512,
			},
		},
		position = {
			1472,
			1364,
		},
		visibility = {
			archetypes = {
				"adamant",
				"ogryn",
				"psyker",
				"veteran",
				"zealot",
			},
		},
	},
	{
		description = "loc_character_birthplace_planet_07_description",
		display_name = "loc_character_birthplace_planet_07_name",
		name = "Cadia",
		story_snippet = "loc_character_birthplace_planet_07_description_snippet",
		image = {
			path = "content/ui/textures/backgrounds/backstory/planets/cadia",
			size = {
				1536,
				512,
			},
		},
		position = {
			1786,
			2588,
		},
		visibility = {
			archetypes = {
				"adamant",
				"ogryn",
				"psyker",
				"veteran",
				"zealot",
			},
		},
	},
	{
		description = "loc_character_birthplace_planet_08_description",
		display_name = "loc_character_birthplace_planet_08_name",
		name = "Messelina Gloriana",
		story_snippet = "loc_character_birthplace_planet_08_description_snippet",
		image = {
			path = "content/ui/textures/backgrounds/backstory/planets/messelina_gloriana",
			size = {
				512,
				512,
			},
		},
		position = {
			1400,
			1926,
		},
		visibility = {
			archetypes = {
				"adamant",
				"ogryn",
				"psyker",
				"veteran",
				"zealot",
			},
		},
	},
}

table.append(home_planet_options, HOME_PLANETS_BROKER)
table.append(home_planet_options, HOME_PLANETS_CRYPTIC)

local home_planet_options_by_id = {}

for ii = 1, #home_planet_options do
	local home_planet_option = home_planet_options[ii]
	local id = string.format("option_%d", ii)

	home_planet_option.id = id
	home_planet_options_by_id[id] = home_planet_option
end

return settings("HomePlanet", home_planet_options_by_id)
