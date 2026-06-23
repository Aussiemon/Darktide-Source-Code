-- chunkname: @scripts/settings/character/home_planets_cryptic.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local home_planet_options = {
	{
		description = "loc_character_forge_world_01_description",
		display_name = "loc_character_forge_world_01_name",
		name = "Cryptic 1",
		sort_order = 1,
		story_snippet = "loc_character_forge_world_01_description_snippet",
		unlocks = {
			{
				text = "loc_character_forge_world_unlocks",
				type = "text",
			},
		},
		rotation = {
			0,
			0,
			90,
		},
		on_pressed_sound = UISoundEvents.play_ui_character_create_select_forge_world_01,
		page_leave_sound = UISoundEvents.stop_ui_character_create_select_forge_world_loops,
		slot_items = {
			slot_gear_extra_cosmetic = "content/items/characters/player/human/backpacks/cryptic_backpack_d_var_01",
			slot_gear_head = "content/items/characters/player/human/gear_head/cryptic_headgear_10_var_01",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/cryptic_lowerbody_b_var_01",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/cryptic_upperbody_b_var_01",
		},
		visibility = {
			archetypes = {
				"cryptic",
			},
		},
	},
	{
		description = "loc_character_forge_world_02_description",
		display_name = "loc_character_forge_world_02_name",
		name = "Cryptic 2",
		sort_order = 2,
		story_snippet = "loc_character_forge_world_02_description_snippet",
		unlocks = {
			{
				text = "loc_character_forge_world_unlocks",
				type = "text",
			},
		},
		rotation = {
			0,
			0,
			180,
		},
		on_pressed_sound = UISoundEvents.play_ui_character_create_select_forge_world_02,
		page_leave_sound = UISoundEvents.stop_ui_character_create_select_forge_world_loops,
		slot_items = {
			slot_gear_extra_cosmetic = "content/items/characters/player/human/backpacks/cryptic_backpack_d_var_01",
			slot_gear_head = "content/items/characters/player/human/gear_head/cryptic_headgear_10_var_02",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/cryptic_lowerbody_b_var_02",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/cryptic_upperbody_b_var_02",
		},
		visibility = {
			archetypes = {
				"cryptic",
			},
		},
	},
	{
		description = "loc_character_forge_world_03_description",
		display_name = "loc_character_forge_world_03_name",
		name = "Cryptic 3",
		sort_order = 3,
		story_snippet = "loc_character_forge_world_03_description_snippet",
		unlocks = {
			{
				text = "loc_character_forge_world_unlocks",
				type = "text",
			},
		},
		rotation = {
			0,
			0,
			270,
		},
		on_pressed_sound = UISoundEvents.play_ui_character_create_select_forge_world_03,
		page_leave_sound = UISoundEvents.stop_ui_character_create_select_forge_world_loops,
		slot_items = {
			slot_gear_extra_cosmetic = "content/items/characters/player/human/backpacks/cryptic_backpack_d_var_01",
			slot_gear_head = "content/items/characters/player/human/gear_head/cryptic_headgear_10_var_03",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/cryptic_lowerbody_b_var_03",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/cryptic_upperbody_b_var_03",
		},
		visibility = {
			archetypes = {
				"cryptic",
			},
		},
	},
	{
		description = "loc_character_forge_world_04_description",
		display_name = "loc_character_forge_world_04_name",
		name = "Cryptic 4",
		sort_order = 4,
		story_snippet = "loc_character_forge_world_04_description_snippet",
		unlocks = {
			{
				text = "loc_character_forge_world_unlocks",
				type = "text",
			},
		},
		rotation = {
			0,
			0,
			0,
		},
		on_pressed_sound = UISoundEvents.play_ui_character_create_select_forge_world_04,
		page_leave_sound = UISoundEvents.stop_ui_character_create_select_forge_world_loops,
		slot_items = {
			slot_gear_extra_cosmetic = "content/items/characters/player/human/backpacks/cryptic_backpack_d_var_01",
			slot_gear_head = "content/items/characters/player/human/gear_head/cryptic_headgear_10_var_04",
			slot_gear_lowerbody = "content/items/characters/player/human/gear_lowerbody/cryptic_lowerbody_b_var_04",
			slot_gear_upperbody = "content/items/characters/player/human/gear_upperbody/cryptic_upperbody_b_var_04",
		},
		visibility = {
			archetypes = {
				"cryptic",
			},
		},
	},
}

return home_planet_options
