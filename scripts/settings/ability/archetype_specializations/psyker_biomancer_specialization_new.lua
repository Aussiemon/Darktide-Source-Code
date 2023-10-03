local archetype_specialization = {
	description_short = "loc_ability_specialization_biomancy_description_short",
	name = "psyker_2",
	show_debug_grid = true,
	choice_banner = "content/ui/materials/backgrounds/careers/psyker_career_2",
	archetype = "psyker",
	description = "loc_ability_specialization_biomancy_description",
	specialization_banner = "content/ui/textures/icons/class_illustrations/biomancer",
	video = "content/videos/class_selection/psyker_2",
	background_large = "content/ui/materials/placeholders/ability_backgrounds/psyker_2",
	choice_order = 2,
	show_in_debug_selection = true,
	title = "loc_ability_specialization_biomancy",
	unique_weapons = {
		{
			item = "content/items/weapons/player/melee/forcesword_p1_m1",
			display_name = "loc_class_selection_unique_weapon_psyker_melee_1"
		},
		{
			item = "content/items/weapons/player/ranged/forcestaff_p1_m1",
			display_name = "loc_class_selection_unique_weapon_psyker_ranged_1"
		}
	},
	talent_groups = {
		{
			group_name = "combat",
			limit_to_one = true,
			required_level = 1,
			talents = {},
			positions = {
				{
					10,
					15
				},
				{
					13,
					15
				},
				{
					16,
					15
				}
			}
		},
		{
			group_name = "combat_ability_1",
			required_level = 1,
			talents = {},
			positions = {
				{
					9,
					15
				}
			}
		},
		{
			group_name = "combat_ability_2",
			required_level = 1,
			talents = {},
			positions = {
				{
					13,
					12
				},
				{
					12,
					13
				},
				{
					12,
					14
				},
				{
					14,
					13
				},
				{
					14,
					14
				}
			}
		},
		{
			group_name = "combat_ability_3",
			required_level = 1,
			talents = {},
			positions = {
				{
					17,
					15
				}
			}
		},
		{
			group_name = "tactical",
			limit_to_one = true,
			required_level = 1,
			talents = {},
			positions = {
				{
					10,
					1
				},
				{
					13,
					1
				},
				{
					16,
					1
				}
			}
		},
		{
			group_name = "grenade_ability_1",
			required_level = 1,
			talents = {},
			positions = {
				{
					8,
					1
				}
			}
		},
		{
			group_name = "grenade_ability_2",
			required_level = 1,
			talents = {},
			positions = {
				{
					12,
					3
				},
				{
					12,
					2
				},
				{
					14,
					3
				},
				{
					14,
					2
				}
			}
		},
		{
			group_name = "grenade_ability_3",
			required_level = 1,
			talents = {},
			positions = {
				{
					18,
					1
				},
				{
					19,
					2
				},
				{
					20,
					3
				},
				{
					18,
					5
				},
				{
					16,
					3
				},
				{
					17,
					4
				},
				{
					19,
					4
				},
				{
					17,
					2
				}
			}
		},
		{
			group_name = "aura",
			limit_to_one = true,
			required_level = 1,
			talents = {},
			positions = {
				{
					1,
					10
				},
				{
					1,
					12
				},
				{
					1,
					14
				}
			}
		},
		{
			group_name = "aura_talents",
			required_level = 1,
			talents = {},
			positions = {
				{
					3,
					10
				},
				{
					3,
					12
				}
			}
		},
		{
			group_name = "passive",
			limit_to_one = true,
			required_level = 1,
			talents = {},
			positions = {
				{
					1,
					6
				},
				{
					1,
					1
				},
				{
					25,
					15
				}
			}
		},
		{
			group_name = "passive_talents_1",
			required_level = 1,
			talents = {},
			positions = {
				{
					3,
					5
				},
				{
					4,
					6
				},
				{
					5,
					5
				},
				{
					5,
					7
				},
				{
					3,
					7
				}
			}
		},
		{
			group_name = "passive_talents_2",
			required_level = 1,
			talents = {},
			positions = {
				{
					3,
					1
				},
				{
					2,
					2
				},
				{
					1,
					3
				}
			}
		},
		{
			group_name = "toughness",
			required_level = 1,
			talents = {},
			positions = {
				{
					23,
					6
				},
				{
					23,
					4
				},
				{
					23,
					10
				}
			}
		},
		{
			group_name = "offensive",
			required_level = 1,
			talents = {},
			positions = {
				{
					15,
					8
				},
				{
					14,
					7
				},
				{
					13,
					8
				},
				{
					14,
					9
				},
				{
					12,
					7
				},
				{
					11,
					8
				},
				{
					12,
					9
				},
				{
					10,
					7
				},
				{
					9,
					8
				},
				{
					10,
					9
				}
			}
		},
		{
			group_name = "coop",
			required_level = 1,
			talents = {},
			positions = {
				{
					18,
					7
				},
				{
					17,
					8
				},
				{
					18,
					9
				}
			}
		},
		{
			group_name = "defensive",
			required_level = 1,
			talents = {},
			positions = {
				{
					24,
					7
				},
				{
					23,
					8
				},
				{
					24,
					9
				},
				{
					22,
					7
				},
				{
					21,
					8
				},
				{
					22,
					9
				}
			}
		}
	},
	talent_connections = {}
}

return archetype_specialization
