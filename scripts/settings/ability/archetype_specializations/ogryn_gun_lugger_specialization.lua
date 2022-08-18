local archetype_specialization = {
	description = "loc_ability_specialization_gun_lugger_description",
	name = "ogryn_1",
	archetype = "ogryn",
	disabled = true,
	choice_banner = "content/ui/materials/backgrounds/careers/ogryn_career_1",
	title = "loc_ability_specialization_gun_lugger",
	video = "content/videos/fatshark_splash",
	specialization_banner = "content/ui/textures/icons/class_illustrations/gunlugger",
	background_large = "content/ui/materials/placeholders/ability_backgrounds/ogryn_1",
	choice_order = 1,
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
				"ogryn_1_combat",
				"ogryn_1_grenade"
			}
		},
		{
			group_boundary_widget_template = "talent_group_horizontal_row_2_slots",
			group_name = "loc_abilities_category_passive",
			non_selectable_group = true,
			required_level = 1,
			top_left_grid_position = {
				7,
				7
			},
			talents = {
				"ogryn_1_base_1",
				"ogryn_1_base_2",
				"ogryn_1_base_3",
				"ogryn_1_base_4"
			}
		},
		{
			group_boundary_widget_template = "talent_group_triangle_up",
			group_name = "loc_talents_category_mixed",
			required_level = 5,
			top_left_grid_position = {
				9,
				1
			},
			talents = {
				"ogryn_1_tier_1_name_1",
				"ogryn_1_tier_1_name_2",
				"ogryn_1_tier_1_name_3"
			}
		},
		{
			group_boundary_widget_template = "talent_group_triangle_down",
			group_name = "loc_abilities_category_offensive",
			required_level = 10,
			top_left_grid_position = {
				4,
				1
			},
			talents = {
				"ogryn_1_tier_2_name_1",
				"ogryn_1_tier_2_name_2",
				"ogryn_1_tier_2_name_3"
			}
		},
		{
			group_boundary_widget_template = "talent_group_triangle_down",
			group_name = "loc_abilities_category_mobility",
			required_level = 15,
			top_left_grid_position = {
				13,
				2
			},
			talents = {
				"ogryn_1_tier_3_name_1",
				"ogryn_1_tier_3_name_2",
				"ogryn_1_tier_3_name_3"
			}
		},
		{
			group_boundary_widget_template = "talent_group_vertical_bend_right",
			group_name = "loc_abilities_category_support",
			required_level = 20,
			top_left_grid_position = {
				3,
				2
			},
			talents = {
				"ogryn_1_tier_4_name_1",
				"ogryn_1_tier_4_name_2",
				"ogryn_1_tier_4_name_3"
			}
		},
		{
			group_boundary_widget_template = "talent_group_vertical_bend_left",
			group_name = "loc_abilities_category_mobility",
			required_level = 25,
			top_left_grid_position = {
				5,
				4
			},
			talents = {
				"ogryn_1_tier_5_name_1",
				"ogryn_1_tier_5_name_2",
				"ogryn_1_tier_5_name_3"
			}
		},
		{
			group_boundary_widget_template = "talent_group_triangle_up",
			group_name = "loc_abilities_category_support",
			required_level = 30,
			top_left_grid_position = {
				11,
				4
			},
			talents = {
				"ogryn_1_tier_6_name_1",
				"ogryn_1_tier_6_name_2",
				"ogryn_1_tier_6_name_3"
			}
		}
	}
}

return archetype_specialization
