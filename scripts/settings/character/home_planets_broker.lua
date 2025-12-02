-- chunkname: @scripts/settings/character/home_planets_broker.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local home_planet_options = {
	{
		description = "loc_character_gang_01_description",
		display_name = "loc_character_gang_01_name",
		name = "Broker 1",
		story_snippet = "loc_character_gang_01_description_snippet",
		unlocks = {
			{
				text = "loc_character_gang_unlocks",
				type = "text",
			},
		},
		rotation = {
			0,
			0,
			0,
		},
		on_pressed_sound = UISoundEvents.play_ui_character_create_select_cartel_water,
		slot_items = {
			slot_gear_head = "content/items/characters/player/human/gear_head/broker_headgear_15_var_04",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/broker_lowerbody_progression_a_var_04",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/broker_upperbody_progression_a_var_04",
		},
		visibility = {
			archetypes = {
				"broker",
			},
		},
	},
	{
		description = "loc_character_gang_02_description",
		display_name = "loc_character_gang_02_name",
		name = "Broker 2",
		story_snippet = "loc_character_gang_02_description_snippet",
		unlocks = {
			{
				text = "loc_character_gang_unlocks",
				type = "text",
			},
		},
		rotation = {
			0,
			0,
			90,
		},
		on_pressed_sound = UISoundEvents.play_ui_character_create_select_cartel_iron,
		slot_items = {
			slot_gear_head = "content/items/characters/player/human/gear_head/broker_headgear_15_var_03",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/broker_lowerbody_progression_a_var_03",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/broker_upperbody_progression_a_var_03",
		},
		visibility = {
			archetypes = {
				"broker",
			},
		},
	},
	{
		description = "loc_character_gang_03_description",
		display_name = "loc_character_gang_03_name",
		name = "Broker 3",
		story_snippet = "loc_character_gang_03_description_snippet",
		unlocks = {
			{
				text = "loc_character_gang_unlocks",
				type = "text",
			},
		},
		rotation = {
			0,
			0,
			180,
		},
		on_pressed_sound = UISoundEvents.play_ui_character_create_select_cartel_show,
		slot_items = {
			slot_gear_head = "content/items/characters/player/human/gear_head/broker_headgear_15_var_02",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/broker_lowerbody_progression_a_var_02",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/broker_upperbody_progression_a_var_02",
		},
		visibility = {
			archetypes = {
				"broker",
			},
		},
	},
	{
		description = "loc_character_gang_04_description",
		display_name = "loc_character_gang_04_name",
		name = "Broker 4",
		story_snippet = "loc_character_gang_04_description_snippet",
		unlocks = {
			{
				text = "loc_character_gang_unlocks",
				type = "text",
			},
		},
		rotation = {
			0,
			0,
			270,
		},
		on_pressed_sound = UISoundEvents.play_ui_character_create_select_cartel_threadlighties,
		slot_items = {
			slot_gear_head = "content/items/characters/player/human/gear_head/broker_headgear_15_var_01",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/broker_lowerbody_progression_a_var_01",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/broker_upperbody_progression_a_var_01",
		},
		visibility = {
			archetypes = {
				"broker",
			},
		},
	},
}

return home_planet_options
