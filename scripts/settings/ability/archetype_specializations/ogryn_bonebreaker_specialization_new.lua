local archetype_specialization = {
	description_short = "loc_archetype_specialization_ogryn_2_description_short",
	name = "ogryn_2",
	title = "loc_archetype_specialization_ogryn_2",
	description = "loc_archetype_specialization_ogryn_2_description",
	choice_banner = "content/ui/materials/backgrounds/careers/ogryn_career_2",
	archetype = "ogryn",
	video = "content/videos/class_selection/ogryn_2",
	specialization_banner = "content/ui/textures/icons/class_illustrations/bonebreaker",
	background_large = "content/ui/materials/placeholders/ability_backgrounds/ogryn_2",
	choice_order = 2,
	show_in_debug_selection = true,
	unique_weapons = {
		{
			item = "content/items/weapons/player/melee/ogryn_powermaul_slabshield_p1_m1",
			display_name = "loc_class_selection_unique_weapon_ogryn_melee_1"
		},
		{
			item = "content/items/weapons/player/ranged/ogryn_gauntlet_p1_m1",
			display_name = "loc_class_selection_unique_weapon_ogryn_ranged_1"
		}
	},
	talent_groups = {
		{
			group_name = "combat",
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
			non_selectable_group = true,
			invisible_in_ui = true,
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
