-- chunkname: @scripts/settings/ability/archetype_specializations/zealot_maniac_specialization_new.lua

local archetype_specialization = {
	description_short = "loc_archetype_specialization_zealot_maniac_description_short",
	name = "zealot_2",
	title = "loc_archetype_specialization_zealot_maniac",
	description = "loc_archetype_specialization_zealot_maniac_description",
	choice_banner = "content/ui/materials/backgrounds/careers/zealot_career_2",
	archetype = "zealot",
	video = "content/videos/class_selection/zealot_2",
	specialization_banner = "content/ui/textures/icons/class_illustrations/scourge",
	background_large = "content/ui/materials/placeholders/ability_backgrounds/zealot_2",
	choice_order = 2,
	show_in_debug_selection = true,
	unique_weapons = {
		{
			item = "content/items/weapons/player/melee/chainsword_2h_p1_m1",
			display_name = "loc_class_selection_unique_weapon_zealot_melee_1"
		},
		{
			item = "content/items/weapons/player/ranged/flamer_p1_m1",
			display_name = "loc_class_selection_unique_weapon_zealot_ranged_1"
		}
	},
	talent_groups = {
		{
			group_name = "combat",
			non_selectable_group = true,
			required_level = 1,
			talents = {}
		},
		{
			group_name = "tactical",
			non_selectable_group = true,
			required_level = 1,
			talents = {}
		},
		{
			group_name = "aura",
			non_selectable_group = true,
			required_level = 1,
			talents = {}
		},
		{
			group_name = "passive",
			non_selectable_group = true,
			required_level = 1,
			talents = {}
		},
		{
			group_name = "tier_1",
			required_level = 5,
			talents = {}
		},
		{
			group_name = "tier_2",
			required_level = 10,
			talents = {}
		},
		{
			group_name = "tier_3",
			required_level = 15,
			talents = {}
		},
		{
			group_name = "tier_4",
			required_level = 20,
			talents = {}
		},
		{
			group_name = "tier_5",
			required_level = 25,
			talents = {}
		},
		{
			group_name = "tier_6",
			required_level = 30,
			talents = {}
		}
	}
}

return archetype_specialization
