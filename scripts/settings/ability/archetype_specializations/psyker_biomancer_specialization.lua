local archetype_specialization = {
	description_short = "loc_ability_specialization_biomancy_description_short",
	name = "psyker_2",
	title = "loc_ability_specialization_biomancy",
	description = "loc_ability_specialization_biomancy_description",
	choice_banner = "content/ui/materials/backgrounds/careers/psyker_career_2",
	archetype = "psyker",
	video = "content/videos/fatshark_splash",
	specialization_banner = "content/ui/textures/icons/class_illustrations/biomancer",
	background_large = "content/ui/materials/placeholders/ability_backgrounds/psyker_2",
	choice_order = 2,
	show_in_debug_selection = true,
	talent_groups = {
		{
			group_boundary_widget_template = "talent_group_main_specialization",
			group_name = "loc_abilities_category_combat",
			non_selectable_group = true,
			required_level = 1,
			top_left_grid_position = {
				8,
				4
			},
			talents = {
				"psyker_2_combat"
			}
		},
		{
			non_selectable_group = true,
			group_name = "loc_abilities_category_combat",
			invisible_in_ui = true,
			required_level = 1,
			talents = {
				"psyker_2_smite"
			}
		},
		{
			group_boundary_widget_template = "talent_group_triangle_up",
			group_name = "loc_abilities_category_passive",
			non_selectable_group = true,
			required_level = 1,
			top_left_grid_position = {
				10,
				5
			},
			talents = {
				"psyker_2_base_1",
				"psyker_2_base_2",
				"psyker_2_base_3"
			}
		},
		{
			group_boundary_widget_template = "talent_group_triangle_down",
			group_name = "loc_abilities_category_offensive",
			required_level = 5,
			top_left_grid_position = {
				7,
				7
			},
			talents = {
				"psyker_2_tier_1_name_1",
				"psyker_2_tier_1_name_2",
				"psyker_2_tier_1_name_3"
			}
		},
		{
			group_boundary_widget_template = "talent_group_triangle_up",
			group_name = "loc_abilities_category_offensive",
			required_level = 10,
			top_left_grid_position = {
				5,
				5
			},
			talents = {
				"psyker_2_tier_2_name_1",
				"psyker_2_tier_2_name_2",
				"psyker_2_tier_2_name_3"
			}
		},
		{
			group_boundary_widget_template = "talent_group_horizontal_row",
			group_name = "loc_abilities_category_mobility",
			required_level = 15,
			top_left_grid_position = {
				2,
				4
			},
			talents = {
				"psyker_2_tier_3_name_1",
				"psyker_2_tier_3_name_2",
				"psyker_2_tier_3_name_3"
			}
		},
		{
			group_boundary_widget_template = "talent_group_diagonal_left",
			group_name = "loc_abilities_category_support",
			required_level = 20,
			top_left_grid_position = {
				4,
				1
			},
			talents = {
				"psyker_2_tier_4_name_1",
				"psyker_2_tier_4_name_2",
				"psyker_2_tier_4_name_3"
			}
		},
		{
			group_boundary_widget_template = "talent_group_diagonal_right",
			group_name = "loc_abilities_category_mobility",
			required_level = 25,
			top_left_grid_position = {
				10,
				1
			},
			talents = {
				"psyker_2_tier_5_name_1",
				"psyker_2_tier_5_name_2",
				"psyker_2_tier_5_name_3"
			}
		},
		{
			group_boundary_widget_template = "talent_group_horizontal_row",
			group_name = "loc_abilities_category_support",
			required_level = 30,
			top_left_grid_position = {
				12,
				4
			},
			talents = {
				"psyker_2_tier_6_name_1",
				"psyker_2_tier_6_name_2",
				"psyker_2_tier_6_name_3"
			}
		}
	}
}

return archetype_specialization
