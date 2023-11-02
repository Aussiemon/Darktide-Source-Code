return {
	name = "zealot_tree",
	node_points = 30,
	version = 15,
	background_height = 2800,
	archetype_name = "zealot",
	talent_points = 30,
	nodes = {
		{
			max_points = 1,
			widget_name = "node_64bdbaac-0e34-4440-812b-6ce9003ac0f9",
			type = "default",
			y = 545,
			y_normalized = 0,
			talent = "zealot_more_toughness_on_melee",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_more_toughness_on_melee",
			x = 1295,
			x_normalized = 0,
			children = {
				"node_0581bad8-f8c0-4321-a90b-756013fd3981"
			},
			parents = {
				"node_93e48d01-3936-4771-896e-a898c06100ca",
				"node_36d9319a-e724-493d-baf1-efdbd77f736c"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_b8248af4-b195-43b3-b322-15a4feb1977d",
			type = "default",
			y = 545,
			y_normalized = 0,
			talent = "zealot_increased_coherency_toughness",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_increased_coherency_toughness",
			x = 995,
			x_normalized = 0,
			children = {
				"node_dc98ac1f-f437-42c1-a5a9-ffa4d8ba19dd"
			},
			parents = {
				"node_93e48d01-3936-4771-896e-a898c06100ca",
				"node_18bd9f66-02ab-4d6b-93ef-c860bbdf62e4"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_0e6bc32b-bdab-4856-94e7-f141355cc9a0",
			type = "default",
			y = 485,
			y_normalized = 0,
			talent = "zealot_crits_apply_bleed",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_crits_apply_bleed",
			x = 1385,
			x_normalized = 0,
			children = {
				"node_0581bad8-f8c0-4321-a90b-756013fd3981"
			},
			parents = {
				"node_36d9319a-e724-493d-baf1-efdbd77f736c"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_36d9319a-e724-493d-baf1-efdbd77f736c",
			type = "default",
			y = 425,
			y_normalized = 0,
			talent = "zealot_backstab_damage",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_backstab_damage",
			x = 1265,
			x_normalized = 0,
			children = {
				"node_64bdbaac-0e34-4440-812b-6ce9003ac0f9",
				"node_0e6bc32b-bdab-4856-94e7-f141355cc9a0"
			},
			parents = {
				"node_2e95d28a-ee00-43d3-8bff-5b2461aa8ecf"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "stat",
			max_points = 1,
			widget_name = "node_0581bad8-f8c0-4321-a90b-756013fd3981",
			y = 604,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_3",
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			x = 1414,
			x_normalized = 0,
			children = {
				"node_0dbb9346-b495-40d9-81d2-3d69b24056f7",
				"node_7e007113-75ff-4081-af02-5512abe200dc"
			},
			parents = {
				"node_0e6bc32b-bdab-4856-94e7-f141355cc9a0",
				"node_64bdbaac-0e34-4440-812b-6ce9003ac0f9"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_88dfd7e8-94f2-4d58-8bfa-06e53dca3286",
			type = "default",
			y = 425,
			y_normalized = 0,
			talent = "zealot_multi_hits_increase_damage",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_multi_hits_increase_damage",
			x = 905,
			x_normalized = 0,
			children = {
				"node_019a38fd-8454-4e5c-961b-7e74d408f0af"
			},
			parents = {
				"node_af65a706-5285-4016-a7bf-d3a9473e6096",
				"node_2e95d28a-ee00-43d3-8bff-5b2461aa8ecf"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "stat",
			max_points = 1,
			widget_name = "node_f1b1a1ec-4614-4f62-8602-5ffe9b4a95a7",
			y = 604,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_2",
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			x = 754,
			x_normalized = 0,
			children = {
				"node_a5510705-1db7-4086-aa35-04833ebb8527",
				"node_b71544c5-61d9-4c06-8de3-0b834357c0c9"
			},
			parents = {
				"node_019a38fd-8454-4e5c-961b-7e74d408f0af"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_a827f270-b198-4fa8-be77-59feaebb2fc1",
			type = "default",
			y = 545,
			y_normalized = 0,
			talent = "zealot_increased_damage_vs_resilient",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_increased_damage_vs_resilient",
			x = 1175,
			x_normalized = 0,
			children = {
				"node_dc98ac1f-f437-42c1-a5a9-ffa4d8ba19dd"
			},
			parents = {
				"node_18bd9f66-02ab-4d6b-93ef-c860bbdf62e4"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_18bd9f66-02ab-4d6b-93ef-c860bbdf62e4",
			type = "default",
			y = 455,
			y_normalized = 0,
			talent = "zealot_increase_ranged_close_damage",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_increase_ranged_close_damage",
			x = 1085,
			x_normalized = 0,
			children = {
				"node_a827f270-b198-4fa8-be77-59feaebb2fc1",
				"node_b8248af4-b195-43b3-b322-15a4feb1977d"
			},
			parents = {
				"node_2e95d28a-ee00-43d3-8bff-5b2461aa8ecf"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "stat",
			max_points = 1,
			widget_name = "node_dc98ac1f-f437-42c1-a5a9-ffa4d8ba19dd",
			y = 634,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_1",
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			x = 1084,
			x_normalized = 0,
			children = {
				"node_b5ef81ae-d72f-4e83-8fd4-077fad7f6fe0",
				"node_53add57a-526d-4fc6-b8b2-1899b30b37a8"
			},
			parents = {
				"node_b8248af4-b195-43b3-b322-15a4feb1977d",
				"node_a827f270-b198-4fa8-be77-59feaebb2fc1"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_998a79be-ed3f-4b78-acb5-cb788438a76c",
			type = "tactical",
			y = 830,
			y_normalized = 0,
			talent = "zealot_flame_grenade",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_blitz_fire_grenade",
			x = 1070,
			x_normalized = 0,
			children = {
				"node_da5a6b52-fed6-46df-9118-37ebe377eed0"
			},
			parents = {
				"node_b5ef81ae-d72f-4e83-8fd4-077fad7f6fe0",
				"node_53add57a-526d-4fc6-b8b2-1899b30b37a8"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "blitz"
			}
		},
		{
			max_points = 1,
			widget_name = "node_f830003e-bb99-448f-aac6-f8a4dbf61d50",
			type = "tactical",
			y = 800,
			y_normalized = 0,
			talent = "zealot_throwing_knives",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_blitz_throwing_knife",
			x = 1400,
			x_normalized = 0,
			children = {
				"node_ac2f3e1c-641a-4132-98f5-5e13c199a21a"
			},
			parents = {
				"node_0dbb9346-b495-40d9-81d2-3d69b24056f7",
				"node_7e007113-75ff-4081-af02-5512abe200dc"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "blitz"
			}
		},
		{
			max_points = 1,
			widget_name = "node_0dbb9346-b495-40d9-81d2-3d69b24056f7",
			type = "default",
			y = 695,
			y_normalized = 0,
			talent = "zealot_crits_reduce_toughness_damage",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_crits_reduce_toughness_damage",
			x = 1505,
			x_normalized = 0,
			children = {
				"node_f830003e-bb99-448f-aac6-f8a4dbf61d50"
			},
			parents = {
				"node_0581bad8-f8c0-4321-a90b-756013fd3981"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_7e007113-75ff-4081-af02-5512abe200dc",
			type = "default",
			y = 695,
			y_normalized = 0,
			talent = "zealot_toughness_on_dodge",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_toughness_on_dodge",
			x = 1325,
			x_normalized = 0,
			children = {
				"node_f830003e-bb99-448f-aac6-f8a4dbf61d50"
			},
			parents = {
				"node_0581bad8-f8c0-4321-a90b-756013fd3981"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "stat",
			max_points = 1,
			widget_name = "node_ac2f3e1c-641a-4132-98f5-5e13c199a21a",
			y = 934,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_low_1",
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			x = 1414,
			x_normalized = 0,
			children = {
				"node_2976ba77-400e-4fca-9cc7-827a1618f2ec",
				"node_da5a6b52-fed6-46df-9118-37ebe377eed0"
			},
			parents = {
				"node_f830003e-bb99-448f-aac6-f8a4dbf61d50",
				"node_da5a6b52-fed6-46df-9118-37ebe377eed0"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_b5ef81ae-d72f-4e83-8fd4-077fad7f6fe0",
			type = "default",
			y = 725,
			y_normalized = 0,
			talent = "zealot_toughness_on_ranged_kill",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			x = 995,
			x_normalized = 0,
			children = {
				"node_998a79be-ed3f-4b78-acb5-cb788438a76c"
			},
			parents = {
				"node_dc98ac1f-f437-42c1-a5a9-ffa4d8ba19dd"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_53add57a-526d-4fc6-b8b2-1899b30b37a8",
			type = "default",
			y = 725,
			y_normalized = 0,
			talent = "zealot_heal_part_of_damage_taken",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_heal_part_of_damage_taken",
			x = 1175,
			x_normalized = 0,
			children = {
				"node_998a79be-ed3f-4b78-acb5-cb788438a76c"
			},
			parents = {
				"node_dc98ac1f-f437-42c1-a5a9-ffa4d8ba19dd"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "stat",
			max_points = 1,
			widget_name = "node_da5a6b52-fed6-46df-9118-37ebe377eed0",
			y = 934,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_4",
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			x = 1084,
			x_normalized = 0,
			children = {
				"node_14281eca-699a-40bc-888d-a61f85c3372c",
				"node_ac2f3e1c-641a-4132-98f5-5e13c199a21a",
				"node_13a3b9c2-d919-4e05-9ec4-01ee813c01f1"
			},
			parents = {
				"node_998a79be-ed3f-4b78-acb5-cb788438a76c",
				"node_ac2f3e1c-641a-4132-98f5-5e13c199a21a",
				"node_13a3b9c2-d919-4e05-9ec4-01ee813c01f1"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_a5510705-1db7-4086-aa35-04833ebb8527",
			type = "default",
			y = 695,
			y_normalized = 0,
			talent = "zealot_reduced_damage_on_wound",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_reduced_damage_on_wound",
			x = 665,
			x_normalized = 0,
			children = {
				"node_efeefa9a-f503-46e7-afae-a61d76ad3a7e"
			},
			parents = {
				"node_f1b1a1ec-4614-4f62-8602-5ffe9b4a95a7"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_b71544c5-61d9-4c06-8de3-0b834357c0c9",
			type = "default",
			y = 695,
			y_normalized = 0,
			talent = "zealot_toughness_on_heavy_kills",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_toughness_on_heavy_kills",
			x = 845,
			x_normalized = 0,
			children = {
				"node_efeefa9a-f503-46e7-afae-a61d76ad3a7e"
			},
			parents = {
				"node_f1b1a1ec-4614-4f62-8602-5ffe9b4a95a7"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "stat",
			max_points = 1,
			widget_name = "node_13a3b9c2-d919-4e05-9ec4-01ee813c01f1",
			y = 934,
			y_normalized = 0,
			talent = "base_melee_damage_node_buff_low_1",
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			x = 754,
			x_normalized = 0,
			children = {
				"node_cadd181a-a8bc-4595-b335-a939925cbede",
				"node_da5a6b52-fed6-46df-9118-37ebe377eed0"
			},
			parents = {
				"node_efeefa9a-f503-46e7-afae-a61d76ad3a7e",
				"node_da5a6b52-fed6-46df-9118-37ebe377eed0"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_2976ba77-400e-4fca-9cc7-827a1618f2ec",
			type = "default",
			y = 1025,
			y_normalized = 0,
			talent = "zealot_improved_weapon_handling_after_dodge",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_improved_weapon_handling_after_dodge",
			x = 1415,
			x_normalized = 0,
			children = {
				"node_624be7c0-5f2c-402d-81ba-f9d6de01897c",
				"node_7ee3c5f1-cc73-412b-9e62-f013af339bc4"
			},
			parents = {
				"node_ac2f3e1c-641a-4132-98f5-5e13c199a21a"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_756e7183-2bcf-482d-9ab2-8fb7f6b1c7cd",
			type = "aura",
			y = 1340,
			y_normalized = 0,
			talent = "zealot_always_in_coherency",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_aura_always_in_coherency",
			x = 1400,
			x_normalized = 0,
			children = {
				"node_0c22fa98-2651-45b4-8ae8-d7d777a0b529"
			},
			parents = {
				"node_2aa8cb10-8d27-4716-b001-85aa3bf9cc41",
				"node_7335a6d9-ee51-4c11-92a9-2290fe36edd4"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "aura"
			}
		},
		{
			max_points = 1,
			widget_name = "node_4411a1ae-e625-4cd6-9ae3-403b4a346801",
			type = "aura",
			y = 1340,
			y_normalized = 0,
			talent = "zealot_toughness_damage_reduction_coherency_improved",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_aura_the_emperor_demand",
			x = 740,
			x_normalized = 0,
			children = {
				"node_7dc8720d-c371-47a4-8f77-39264310fdb3"
			},
			parents = {
				"node_cb819666-6781-499a-bb33-9a43ed61b4b3",
				"node_9b7ccd7d-8eba-4b0e-9759-7e674c7dfde9"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "aura"
			}
		},
		{
			max_points = 1,
			widget_name = "node_664d1608-49a2-47bc-8aa6-b2c9b655e865",
			type = "default",
			y = 1115,
			y_normalized = 0,
			talent = "zealot_increased_crit_and_weakspot_damage_after_dodge",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_increased_crit_and_weakspot_damage_after_dodge",
			x = 665,
			x_normalized = 0,
			children = {
				"node_cb819666-6781-499a-bb33-9a43ed61b4b3"
			},
			parents = {
				"node_cadd181a-a8bc-4595-b335-a939925cbede"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_69985978-58fd-4215-9404-5ebfe1869483",
			type = "aura",
			y = 1340,
			y_normalized = 0,
			talent = "zealot_corruption_healing_coherency_improved",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_aura_cleansing_prayer",
			x = 1070,
			x_normalized = 0,
			children = {
				"node_2a4793f6-24fb-4f75-b087-9e763d5cc694"
			},
			parents = {
				"node_9268c62c-b81f-4679-b8bb-6995270dedae",
				"node_9543d43e-5fd6-4f71-81e1-a9b4d9b46f15"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "aura"
			}
		},
		{
			max_points = 1,
			widget_name = "node_14281eca-699a-40bc-888d-a61f85c3372c",
			type = "default",
			y = 1025,
			y_normalized = 0,
			talent = "zealot_improved_melee_after_no_ammo",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_improved_melee_after_no_ammo",
			x = 1085,
			x_normalized = 0,
			children = {
				"node_101154ca-57f6-45a4-beea-41dcd21be41f",
				"node_5245354b-aefd-4f44-906a-785d896b4a30"
			},
			parents = {
				"node_da5a6b52-fed6-46df-9118-37ebe377eed0"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_c286494b-4e57-42a2-9c41-04809ee97c41",
			type = "ability",
			y = 1569,
			y_normalized = 0,
			talent = "zealot_bolstering_prayer",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_ability_bolstering_prayer",
			x = 1059,
			x_normalized = 0,
			children = {
				"node_8922b54d-6532-4ac0-910f-c12a9e77bb01"
			},
			parents = {
				"node_2a4793f6-24fb-4f75-b087-9e763d5cc694"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "combat"
			}
		},
		{
			max_points = 1,
			widget_name = "node_101154ca-57f6-45a4-beea-41dcd21be41f",
			type = "default",
			y = 1115,
			y_normalized = 0,
			talent = "zealot_ally_damage_taken_reduced",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_ally_damage_taken_reduced",
			x = 1175,
			x_normalized = 0,
			children = {
				"node_9543d43e-5fd6-4f71-81e1-a9b4d9b46f15"
			},
			parents = {
				"node_14281eca-699a-40bc-888d-a61f85c3372c"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "stat",
			max_points = 1,
			widget_name = "node_cadd181a-a8bc-4595-b335-a939925cbede",
			y = 1024,
			y_normalized = 0,
			talent = "base_movement_speed_node_buff_low_1",
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			x = 754,
			x_normalized = 0,
			children = {
				"node_664d1608-49a2-47bc-8aa6-b2c9b655e865",
				"node_cf60d947-e174-49d8-881d-79aaa602cc4d"
			},
			parents = {
				"node_13a3b9c2-d919-4e05-9ec4-01ee813c01f1"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_5bf70f4d-96f3-446a-8a74-f4b4db160455",
			type = "ability",
			y = 1599,
			y_normalized = 0,
			talent = "zealot_attack_speed_post_ability",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_attack_speed_post_ability",
			x = 729,
			x_normalized = 0,
			children = {
				"node_f562ee33-5fec-4016-a312-d10e7af1cd32",
				"node_f9919123-5c32-4bbe-a1c1-6adb84e2286f"
			},
			parents = {
				"node_7dc8720d-c371-47a4-8f77-39264310fdb3"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "combat"
			}
		},
		{
			max_points = 1,
			widget_name = "node_cf60d947-e174-49d8-881d-79aaa602cc4d",
			type = "default",
			y = 1115,
			y_normalized = 0,
			talent = "zealot_resist_death",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_resist_death",
			x = 845,
			x_normalized = 0,
			children = {
				"node_9b7ccd7d-8eba-4b0e-9759-7e674c7dfde9"
			},
			parents = {
				"node_cadd181a-a8bc-4595-b335-a939925cbede"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_5245354b-aefd-4f44-906a-785d896b4a30",
			type = "default",
			y = 1115,
			y_normalized = 0,
			talent = "zealot_reduced_sprint_cost",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_always_in_coherency",
			x = 995,
			x_normalized = 0,
			children = {
				"node_9268c62c-b81f-4679-b8bb-6995270dedae"
			},
			parents = {
				"node_14281eca-699a-40bc-888d-a61f85c3372c"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_9543d43e-5fd6-4f71-81e1-a9b4d9b46f15",
			type = "default",
			y = 1235,
			y_normalized = 0,
			talent = "zealot_increased_impact",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_increased_impact",
			x = 1175,
			x_normalized = 0,
			children = {
				"node_69985978-58fd-4215-9404-5ebfe1869483"
			},
			parents = {
				"node_101154ca-57f6-45a4-beea-41dcd21be41f"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_8922b54d-6532-4ac0-910f-c12a9e77bb01",
			type = "ability_modifier",
			y = 1715,
			y_normalized = 0,
			talent = "zealot_channel_staggers",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_channel_staggers",
			x = 1085,
			x_normalized = 0,
			children = {
				"node_518fc5ca-a334-46b2-9177-42cc04f43002",
				"node_72c78ca8-a422-429a-90cf-b85d0b36aa19",
				"node_7f263cb5-3031-4d9d-8c8a-8d2b83683105"
			},
			parents = {
				"node_c286494b-4e57-42a2-9c41-04809ee97c41"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_9268c62c-b81f-4679-b8bb-6995270dedae",
			type = "default",
			y = 1235,
			y_normalized = 0,
			talent = "zealot_increased_reload_speed_on_melee_kills",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_increased_reload_speed_on_melee_kills",
			x = 995,
			x_normalized = 0,
			children = {
				"node_69985978-58fd-4215-9404-5ebfe1869483"
			},
			parents = {
				"node_5245354b-aefd-4f44-906a-785d896b4a30"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_72c78ca8-a422-429a-90cf-b85d0b36aa19",
			type = "ability_modifier",
			y = 1745,
			y_normalized = 0,
			talent = "zealot_channel_grants_toughness_damage_reduction",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_channel_grants_toughness_damage_reduction",
			x = 965,
			x_normalized = 0,
			children = {},
			parents = {
				"node_8922b54d-6532-4ac0-910f-c12a9e77bb01"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "prayer_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_518fc5ca-a334-46b2-9177-42cc04f43002",
			type = "ability_modifier",
			y = 1745,
			y_normalized = 0,
			talent = "zealot_channel_grants_damage",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_channel_grants_damage",
			x = 1205,
			x_normalized = 0,
			children = {},
			parents = {
				"node_8922b54d-6532-4ac0-910f-c12a9e77bb01"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "prayer_1"
			}
		},
		{
			type = "stat",
			max_points = 1,
			widget_name = "node_f9919123-5c32-4bbe-a1c1-6adb84e2286f",
			y = 1834,
			y_normalized = 0,
			talent = "base_suppression_node_buff_low_1",
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			x = 874,
			x_normalized = 0,
			children = {
				"node_6ab8617d-6ddd-4d56-a6c3-7ead4e4f1648",
				"node_7f263cb5-3031-4d9d-8c8a-8d2b83683105"
			},
			parents = {
				"node_7f263cb5-3031-4d9d-8c8a-8d2b83683105",
				"node_5bf70f4d-96f3-446a-8a74-f4b4db160455"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "stat",
			max_points = 1,
			widget_name = "node_2a4793f6-24fb-4f75-b087-9e763d5cc694",
			y = 1474,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_low_3",
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			x = 1084,
			x_normalized = 0,
			children = {
				"node_0c22fa98-2651-45b4-8ae8-d7d777a0b529",
				"node_7dc8720d-c371-47a4-8f77-39264310fdb3",
				"node_c286494b-4e57-42a2-9c41-04809ee97c41"
			},
			parents = {
				"node_69985978-58fd-4215-9404-5ebfe1869483",
				"node_7dc8720d-c371-47a4-8f77-39264310fdb3",
				"node_0c22fa98-2651-45b4-8ae8-d7d777a0b529"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "stat",
			max_points = 1,
			widget_name = "node_16bb35c6-cb04-4156-afa8-c9de10fdaba9",
			y = 2074,
			y_normalized = 0,
			talent = "base_health_node_buff_medium_1",
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			x = 1084,
			x_normalized = 0,
			children = {
				"node_5b313422-552e-4e6c-b89c-d35acad88fc9",
				"node_5a6a015e-77a8-4675-a51b-7fd233eb1b26"
			},
			parents = {
				"node_81b042fd-5ffb-4317-917d-8ea465181053"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_6ab8617d-6ddd-4d56-a6c3-7ead4e4f1648",
			type = "default",
			y = 1955,
			y_normalized = 0,
			talent = "zealot_multi_hits_grant_impact_and_uninterruptible",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_multi_hits_grant_impact_and_uninterruptible",
			x = 845,
			x_normalized = 0,
			children = {
				"node_d3fb80e3-38c7-4b89-be87-f0156d33c771"
			},
			parents = {
				"node_f9919123-5c32-4bbe-a1c1-6adb84e2286f"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_cb819666-6781-499a-bb33-9a43ed61b4b3",
			type = "default",
			y = 1235,
			y_normalized = 0,
			talent = "zealot_more_damage_when_low_on_stamina",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_more_damage_when_low_on_stamina",
			x = 665,
			x_normalized = 0,
			children = {
				"node_4411a1ae-e625-4cd6-9ae3-403b4a346801"
			},
			parents = {
				"node_664d1608-49a2-47bc-8aa6-b2c9b655e865"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_f562ee33-5fec-4016-a312-d10e7af1cd32",
			type = "ability_modifier",
			y = 1715,
			y_normalized = 0,
			talent = "zealot_additional_charge_of_ability",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_additional_charge_of_ability",
			x = 635,
			x_normalized = 0,
			children = {
				"node_c2d4e355-cfd0-4ca6-8068-a5bc7335ffbd"
			},
			parents = {
				"node_5bf70f4d-96f3-446a-8a74-f4b4db160455"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_9b7ccd7d-8eba-4b0e-9759-7e674c7dfde9",
			type = "default",
			y = 1235,
			y_normalized = 0,
			talent = "zealot_resist_death_healing",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_resist_death_healing",
			x = 845,
			x_normalized = 0,
			children = {
				"node_4411a1ae-e625-4cd6-9ae3-403b4a346801"
			},
			parents = {
				"node_cf60d947-e174-49d8-881d-79aaa602cc4d"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "stat",
			max_points = 1,
			widget_name = "node_7dc8720d-c371-47a4-8f77-39264310fdb3",
			y = 1474,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_4",
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			x = 754,
			x_normalized = 0,
			children = {
				"node_2a4793f6-24fb-4f75-b087-9e763d5cc694",
				"node_5bf70f4d-96f3-446a-8a74-f4b4db160455"
			},
			parents = {
				"node_4411a1ae-e625-4cd6-9ae3-403b4a346801",
				"node_2a4793f6-24fb-4f75-b087-9e763d5cc694"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_f1b10508-b92d-45c4-8661-941d3eadac13",
			type = "ability",
			y = 1599,
			y_normalized = 0,
			talent = "zealot_stealth",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_ability_stealth",
			x = 1359,
			x_normalized = 0,
			children = {
				"node_374f4845-26ff-40f4-a893-75b4e4ac324d",
				"node_748ebcf8-f38e-4ff1-badf-8f74f9b2efb7",
				"node_228ca33d-e567-42c7-8ff2-316ce4464a5b"
			},
			parents = {
				"node_0c22fa98-2651-45b4-8ae8-d7d777a0b529"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "combat"
			}
		},
		{
			max_points = 1,
			widget_name = "node_624be7c0-5f2c-402d-81ba-f9d6de01897c",
			type = "default",
			y = 1115,
			y_normalized = 0,
			talent = "zealot_damage_boosts_movement",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_damage_boosts_movement",
			x = 1325,
			x_normalized = 0,
			children = {
				"node_2aa8cb10-8d27-4716-b001-85aa3bf9cc41"
			},
			parents = {
				"node_2976ba77-400e-4fca-9cc7-827a1618f2ec"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_374f4845-26ff-40f4-a893-75b4e4ac324d",
			type = "ability_modifier",
			y = 1655,
			y_normalized = 0,
			talent = "zealot_increased_duration",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_increased_duration",
			x = 1535,
			x_normalized = 0,
			children = {
				"node_d4c52149-9efe-492d-947e-f4c9e1b4bef7"
			},
			parents = {
				"node_f1b10508-b92d-45c4-8661-941d3eadac13"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "stealth_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_2aa8cb10-8d27-4716-b001-85aa3bf9cc41",
			type = "default",
			y = 1235,
			y_normalized = 0,
			talent = "zealot_increased_stagger_on_weakspot_melee",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_increased_stagger_on_weakspot_melee",
			x = 1325,
			x_normalized = 0,
			children = {
				"node_756e7183-2bcf-482d-9ab2-8fb7f6b1c7cd"
			},
			parents = {
				"node_624be7c0-5f2c-402d-81ba-f9d6de01897c"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_7ee3c5f1-cc73-412b-9e62-f013af339bc4",
			type = "default",
			y = 1115,
			y_normalized = 0,
			talent = "zealot_reduced_damage_after_dodge",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_reduced_damage_after_dodge",
			x = 1505,
			x_normalized = 0,
			children = {
				"node_7335a6d9-ee51-4c11-92a9-2290fe36edd4"
			},
			parents = {
				"node_2976ba77-400e-4fca-9cc7-827a1618f2ec"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_7335a6d9-ee51-4c11-92a9-2290fe36edd4",
			type = "default",
			y = 1235,
			y_normalized = 0,
			talent = "zealot_increased_damage_when_flanking",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_increased_damage_when_flanking",
			x = 1505,
			x_normalized = 0,
			children = {
				"node_756e7183-2bcf-482d-9ab2-8fb7f6b1c7cd"
			},
			parents = {
				"node_7ee3c5f1-cc73-412b-9e62-f013af339bc4"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "start",
			y = 370,
			widget_name = "node_2e95d28a-ee00-43d3-8bff-5b2461aa8ecf",
			y_normalized = 0,
			max_points = 1,
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			x = 1120,
			x_normalized = 0,
			children = {
				"node_88dfd7e8-94f2-4d58-8bfa-06e53dca3286",
				"node_18bd9f66-02ab-4d6b-93ef-c860bbdf62e4",
				"node_36d9319a-e724-493d-baf1-efdbd77f736c"
			},
			parents = {},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 0,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_019a38fd-8454-4e5c-961b-7e74d408f0af",
			type = "default",
			y = 515,
			y_normalized = 0,
			talent = "zealot_toughness_in_melee",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_toughness_in_melee",
			x = 785,
			x_normalized = 0,
			children = {
				"node_f1b1a1ec-4614-4f62-8602-5ffe9b4a95a7"
			},
			parents = {
				"node_88dfd7e8-94f2-4d58-8bfa-06e53dca3286"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_d4c52149-9efe-492d-947e-f4c9e1b4bef7",
			type = "ability_modifier",
			y = 1775,
			y_normalized = 0,
			talent = "zealot_leaving_stealth_restores_toughness",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_leaving_stealth_restores_toughness",
			x = 1595,
			x_normalized = 0,
			children = {},
			parents = {
				"node_748ebcf8-f38e-4ff1-badf-8f74f9b2efb7",
				"node_374f4845-26ff-40f4-a893-75b4e4ac324d"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_748ebcf8-f38e-4ff1-badf-8f74f9b2efb7",
			type = "ability_modifier",
			y = 1745,
			y_normalized = 0,
			talent = "zealot_stealth_more_cd_more_damage",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_stealth_more_cd_more_damage",
			x = 1445,
			x_normalized = 0,
			children = {
				"node_d4c52149-9efe-492d-947e-f4c9e1b4bef7"
			},
			parents = {
				"node_f1b10508-b92d-45c4-8661-941d3eadac13"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "stealth_1"
			}
		},
		{
			type = "stat",
			max_points = 1,
			widget_name = "node_0c22fa98-2651-45b4-8ae8-d7d777a0b529",
			y = 1474,
			y_normalized = 0,
			talent = "base_stamina_node_buff_low_3",
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			x = 1384,
			x_normalized = 0,
			children = {
				"node_f1b10508-b92d-45c4-8661-941d3eadac13",
				"node_2a4793f6-24fb-4f75-b087-9e763d5cc694"
			},
			parents = {
				"node_756e7183-2bcf-482d-9ab2-8fb7f6b1c7cd",
				"node_2a4793f6-24fb-4f75-b087-9e763d5cc694"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "stat",
			max_points = 1,
			widget_name = "node_228ca33d-e567-42c7-8ff2-316ce4464a5b",
			y = 1834,
			y_normalized = 0,
			talent = "base_melee_damage_node_buff_low_2",
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			x = 1294,
			x_normalized = 0,
			children = {
				"node_80eebf49-eccb-40ef-b6ca-5916f3f088b0",
				"node_7f263cb5-3031-4d9d-8c8a-8d2b83683105"
			},
			parents = {
				"node_7f263cb5-3031-4d9d-8c8a-8d2b83683105",
				"node_f1b10508-b92d-45c4-8661-941d3eadac13"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "stat",
			max_points = 1,
			widget_name = "node_7f263cb5-3031-4d9d-8c8a-8d2b83683105",
			y = 1834,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_low_4",
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			x = 1084,
			x_normalized = 0,
			children = {
				"node_228ca33d-e567-42c7-8ff2-316ce4464a5b",
				"node_f9919123-5c32-4bbe-a1c1-6adb84e2286f",
				"node_81b042fd-5ffb-4317-917d-8ea465181053"
			},
			parents = {
				"node_f9919123-5c32-4bbe-a1c1-6adb84e2286f",
				"node_228ca33d-e567-42c7-8ff2-316ce4464a5b",
				"node_8922b54d-6532-4ac0-910f-c12a9e77bb01"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_81b042fd-5ffb-4317-917d-8ea465181053",
			type = "default",
			y = 1955,
			y_normalized = 0,
			talent = "zealot_attack_speed",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_attack_speed",
			x = 1085,
			x_normalized = 0,
			children = {
				"node_16bb35c6-cb04-4156-afa8-c9de10fdaba9"
			},
			parents = {
				"node_7f263cb5-3031-4d9d-8c8a-8d2b83683105"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_5a6a015e-77a8-4675-a51b-7fd233eb1b26",
			type = "ability_modifier",
			y = 2165,
			y_normalized = 0,
			talent = "zealot_restore_stealth_cd_on_damage",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_restore_stealth_cd_on_damage",
			x = 1175,
			x_normalized = 0,
			children = {
				"node_00de95af-259d-4c82-ae16-91fa3b533ed9"
			},
			parents = {
				"node_16bb35c6-cb04-4156-afa8-c9de10fdaba9"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_5b313422-552e-4e6c-b89c-d35acad88fc9",
			type = "default",
			y = 2165,
			y_normalized = 0,
			talent = "zealot_additional_wounds",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_additional_wounds",
			x = 995,
			x_normalized = 0,
			children = {
				"node_00de95af-259d-4c82-ae16-91fa3b533ed9"
			},
			parents = {
				"node_16bb35c6-cb04-4156-afa8-c9de10fdaba9"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_00de95af-259d-4c82-ae16-91fa3b533ed9",
			type = "keystone",
			y = 2270,
			y_normalized = 0,
			talent = "zealot_martyrdom",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_keystone_martyrdom",
			x = 1070,
			x_normalized = 0,
			children = {
				"node_2d176f63-527c-4758-a1c1-eed8dfd6ac78",
				"node_9d8273b3-4c5d-4317-b480-54a125376f0d"
			},
			parents = {
				"node_5b313422-552e-4e6c-b89c-d35acad88fc9",
				"node_5a6a015e-77a8-4675-a51b-7fd233eb1b26"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "keystone"
			}
		},
		{
			max_points = 1,
			widget_name = "node_2d176f63-527c-4758-a1c1-eed8dfd6ac78",
			type = "keystone_modifier",
			y = 2375,
			y_normalized = 0,
			talent = "zealot_martyrdom_grants_toughness",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_martyrdom_grants_toughness",
			x = 1025,
			x_normalized = 0,
			children = {},
			parents = {
				"node_00de95af-259d-4c82-ae16-91fa3b533ed9"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_9d8273b3-4c5d-4317-b480-54a125376f0d",
			type = "keystone_modifier",
			y = 2375,
			y_normalized = 0,
			talent = "zealot_martyrdom_grants_attack_speed",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_martyrdom_grants_attack_speed",
			x = 1145,
			x_normalized = 0,
			children = {},
			parents = {
				"node_00de95af-259d-4c82-ae16-91fa3b533ed9"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_80eebf49-eccb-40ef-b6ca-5916f3f088b0",
			type = "default",
			y = 1955,
			y_normalized = 0,
			talent = "zealot_hits_grant_stacking_damage",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_hits_grant_stacking_damage",
			x = 1325,
			x_normalized = 0,
			children = {
				"node_002a8e09-c324-4263-bc4d-39a948c2a5b2"
			},
			parents = {
				"node_228ca33d-e567-42c7-8ff2-316ce4464a5b"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_5321e553-acec-4b27-9d43-a5af507fa953",
			type = "ability_modifier",
			y = 2165,
			y_normalized = 0,
			talent = "zealot_backstab_kills_restore_cd",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_backstab_kills_restore_cd",
			x = 1505,
			x_normalized = 0,
			children = {
				"node_86295aae-d8b7-4c66-9862-29d98ae57798"
			},
			parents = {
				"node_002a8e09-c324-4263-bc4d-39a948c2a5b2"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_11938780-5758-4e6e-90ee-81d5c51c0daf",
			type = "default",
			y = 2165,
			y_normalized = 0,
			talent = "zealot_improved_sprint",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_improved_sprint",
			x = 1325,
			x_normalized = 0,
			children = {
				"node_86295aae-d8b7-4c66-9862-29d98ae57798"
			},
			parents = {
				"node_002a8e09-c324-4263-bc4d-39a948c2a5b2"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_86295aae-d8b7-4c66-9862-29d98ae57798",
			type = "keystone",
			y = 2270,
			y_normalized = 0,
			talent = "zealot_quickness_passive",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_keystone_quickness",
			x = 1400,
			x_normalized = 0,
			children = {
				"node_1473ca58-1a77-4543-b2e5-9c4491d240c8",
				"node_4edf073e-7aa4-4234-9d90-c0551ccdfb32"
			},
			parents = {
				"node_11938780-5758-4e6e-90ee-81d5c51c0daf",
				"node_5321e553-acec-4b27-9d43-a5af507fa953"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "keystone"
			}
		},
		{
			max_points = 1,
			widget_name = "node_1473ca58-1a77-4543-b2e5-9c4491d240c8",
			type = "keystone_modifier",
			y = 2375,
			y_normalized = 0,
			talent = "zealot_quickness_toughness_per_stack",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_quickness_toughness_per_stack",
			x = 1355,
			x_normalized = 0,
			children = {},
			parents = {
				"node_86295aae-d8b7-4c66-9862-29d98ae57798"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_4edf073e-7aa4-4234-9d90-c0551ccdfb32",
			type = "keystone_modifier",
			y = 2375,
			y_normalized = 0,
			talent = "zealot_quickness_passive_dodge_stacks",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_03",
			icon = "content/ui/textures/icons/talents/zealot/zealot_quickness_passive_dodge_stacks",
			x = 1475,
			x_normalized = 0,
			children = {},
			parents = {
				"node_86295aae-d8b7-4c66-9862-29d98ae57798"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_5e1591e1-f942-4d8d-9b53-0d11864a59ef",
			type = "ability_modifier",
			y = 2165,
			y_normalized = 0,
			talent = "zealot_crits_grant_cd",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_crits_grant_cd",
			x = 845,
			x_normalized = 0,
			children = {
				"node_9e19621f-a49c-46a1-837a-056d1ea935bb"
			},
			parents = {
				"node_d3fb80e3-38c7-4b89-be87-f0156d33c771"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_18bc94af-2948-4b9a-84e8-5c9408b37343",
			type = "default",
			y = 2165,
			y_normalized = 0,
			talent = "zealot_defensive_knockback",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_defensive_knockback",
			x = 665,
			x_normalized = 0,
			children = {
				"node_9e19621f-a49c-46a1-837a-056d1ea935bb"
			},
			parents = {
				"node_d3fb80e3-38c7-4b89-be87-f0156d33c771"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_9e19621f-a49c-46a1-837a-056d1ea935bb",
			type = "keystone",
			y = 2270,
			y_normalized = 0,
			talent = "zealot_fanatic_rage",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_keystone_fanatic_rage",
			x = 740,
			x_normalized = 0,
			children = {
				"node_e079e0d7-8d4b-45de-8e6b-5ed57f82c641",
				"node_1ff0a25d-5a9b-432d-a5ee-733ca4958030"
			},
			parents = {
				"node_5e1591e1-f942-4d8d-9b53-0d11864a59ef",
				"node_18bc94af-2948-4b9a-84e8-5c9408b37343"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "keystone"
			}
		},
		{
			max_points = 1,
			widget_name = "node_e079e0d7-8d4b-45de-8e6b-5ed57f82c641",
			type = "keystone_modifier",
			y = 2375,
			y_normalized = 0,
			talent = "zealot_fanatic_rage_toughness_on_max",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_fanatic_rage_toughness_on_max",
			x = 665,
			x_normalized = 0,
			children = {
				"node_2a3a12a6-983c-4998-8541-83e9266b031d"
			},
			parents = {
				"node_9e19621f-a49c-46a1-837a-056d1ea935bb"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "fanatic_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_23264a41-d011-4792-a45e-ea68c7d5b27f",
			type = "keystone_modifier",
			y = 2465,
			y_normalized = 0,
			talent = "zealot_fanatic_rage_improved",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_fanatic_rage_improved",
			x = 815,
			x_normalized = 0,
			children = {},
			parents = {
				"node_1ff0a25d-5a9b-432d-a5ee-733ca4958030"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_2a3a12a6-983c-4998-8541-83e9266b031d",
			type = "keystone_modifier",
			y = 2465,
			y_normalized = 0,
			talent = "zealot_shared_fanatic_rage",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_shared_fanatic_rage",
			x = 695,
			x_normalized = 0,
			children = {},
			parents = {
				"node_e079e0d7-8d4b-45de-8e6b-5ed57f82c641"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_1ff0a25d-5a9b-432d-a5ee-733ca4958030",
			type = "keystone_modifier",
			y = 2375,
			y_normalized = 0,
			talent = "zealot_fanatic_rage_stacks_on_crit",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_01",
			icon = "content/ui/textures/icons/talents/zealot/zealot_fanatic_rage_stacks_on_crit",
			x = 845,
			x_normalized = 0,
			children = {
				"node_23264a41-d011-4792-a45e-ea68c7d5b27f"
			},
			parents = {
				"node_9e19621f-a49c-46a1-837a-056d1ea935bb"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "fanatic_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_efeefa9a-f503-46e7-afae-a61d76ad3a7e",
			type = "tactical",
			y = 800,
			y_normalized = 0,
			talent = "zealot_improved_stun_grenade",
			gradient_color = "content/ui/textures/color_ramps/class_node_colors/zealot_02",
			icon = "content/ui/textures/icons/talents/zealot/zealot_improved_stun_grenade",
			x = 740,
			x_normalized = 0,
			children = {
				"node_13a3b9c2-d919-4e05-9ec4-01ee813c01f1"
			},
			parents = {
				"node_a5510705-1db7-4086-aa35-04833ebb8527",
				"node_b71544c5-61d9-4c06-8de3-0b834357c0c9"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "blitz"
			}
		},
		{
			type = "stat",
			max_points = 1,
			widget_name = "node_002a8e09-c324-4263-bc4d-39a948c2a5b2",
			y = 2074,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_low_5",
			x = 1414,
			x_normalized = 0,
			children = {
				"node_5321e553-acec-4b27-9d43-a5af507fa953",
				"node_11938780-5758-4e6e-90ee-81d5c51c0daf"
			},
			parents = {
				"node_80eebf49-eccb-40ef-b6ca-5916f3f088b0"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "stat",
			max_points = 1,
			widget_name = "node_d3fb80e3-38c7-4b89-be87-f0156d33c771",
			y = 2074,
			y_normalized = 0,
			talent = "base_movement_speed_node_buff_low_2",
			x = 754,
			x_normalized = 0,
			children = {
				"node_18bc94af-2948-4b9a-84e8-5c9408b37343",
				"node_5e1591e1-f942-4d8d-9b53-0d11864a59ef"
			},
			parents = {
				"node_6ab8617d-6ddd-4d56-a6c3-7ead4e4f1648"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		}
	},
	offset = {
		0,
		0
	},
	size = {
		4096,
		5000
	}
}
