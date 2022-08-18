local archetype_specialization = {
	description_short = "loc_ability_specialization_squad_leader_description_short",
	name = "veteran_3",
	title = "loc_ability_specialization_squad_leader",
	description = "loc_ability_specialization_squad_leader_description",
	choice_banner = "content/ui/materials/backgrounds/careers/veteran_career_3",
	archetype = "veteran",
	disabled = true,
	specialization_banner = "content/ui/textures/icons/class_illustrations/squadleader",
	video = "content/videos/fatshark_splash",
	background_large = "content/ui/materials/placeholders/ability_backgrounds/veteran_3",
	choice_order = 3,
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
				"veteran_3_combat"
			}
		},
		{
			group_boundary_widget_template = "talent_group_diamond_4_slots",
			group_name = "loc_abilities_category_passive",
			non_selectable_group = true,
			required_level = 1,
			top_left_grid_position = {
				8,
				6
			},
			talents = {
				"veteran_3_base_1",
				"veteran_3_base_2",
				"veteran_3_base_3",
				"veteran_3_base_4"
			}
		},
		{
			group_boundary_widget_template = "talent_group_triangle_down",
			group_name = "loc_abilities_category_offensive",
			required_level = 5,
			top_left_grid_position = {
				9,
				1
			},
			talents = {
				"veteran_3_tier_1_name_1",
				"veteran_3_tier_1_name_2",
				"veteran_3_tier_1_name_3"
			}
		},
		{
			group_boundary_widget_template = "talent_group_triangle_down",
			group_name = "loc_abilities_category_offensive",
			required_level = 10,
			top_left_grid_position = {
				9,
				1
			},
			talents = {
				"veteran_3_tier_2_name_1",
				"veteran_3_tier_2_name_2",
				"veteran_3_tier_2_name_3"
			}
		},
		{
			group_boundary_widget_template = "talent_group_triangle_down",
			group_name = "loc_abilities_category_mobility",
			required_level = 15,
			top_left_grid_position = {
				4,
				1
			},
			talents = {
				"veteran_3_tier_3_name_1",
				"veteran_3_tier_3_name_2",
				"veteran_3_tier_3_name_3"
			}
		},
		{
			group_boundary_widget_template = "talent_group_vertical_bend_right",
			group_name = "loc_abilities_category_support",
			required_level = 20,
			top_left_grid_position = {
				13,
				2
			},
			talents = {
				"veteran_3_tier_4_name_1",
				"veteran_3_tier_4_name_2",
				"veteran_3_tier_4_name_3"
			}
		},
		{
			group_boundary_widget_template = "talent_group_vertical_bend_left",
			group_name = "loc_abilities_category_mobility",
			required_level = 25,
			top_left_grid_position = {
				3,
				2
			},
			talents = {
				"veteran_3_tier_5_name_1",
				"veteran_3_tier_5_name_2",
				"veteran_3_tier_5_name_3"
			}
		},
		{
			group_boundary_widget_template = "talent_group_triangle_up",
			group_name = "loc_abilities_category_support",
			required_level = 30,
			top_left_grid_position = {
				5,
				4
			},
			talents = {
				"veteran_3_tier_6_name_1",
				"veteran_3_tier_6_name_2",
				"veteran_3_tier_6_name_3"
			}
		}
	}
}

return archetype_specialization
