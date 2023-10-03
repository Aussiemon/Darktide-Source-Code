return {
	name = "ogryn_tree",
	node_points = 30,
	version = 14,
	background_height = 2885,
	archetype_name = "ogryn",
	talent_points = 30,
	nodes = {
		{
			type = "start",
			max_points = 1,
			y = 430,
			widget_name = "node_42376ced-a18f-44da-9bea-a9553169afdd",
			y_normalized = 0,
			x = 1090,
			x_normalized = 0,
			children = {
				"node_c3518d3e-c14f-453b-886b-5f8aac1c93c6",
				"node_09e9b9b7-c1c8-4a9c-88eb-235ca27cc9e0",
				"node_f92c86fb-b19e-47fa-81bc-a78a2d834608"
			},
			parents = {},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 0,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_219a7391-b6de-459c-83fd-631421d4f150",
			y = 515,
			y_normalized = 0,
			talent = "ogryn_multi_heavy_toughness",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_multi_heavy_toughness",
			x = 755,
			x_normalized = 0,
			children = {
				"node_13c684ce-e61d-435b-90d7-917248254ea4"
			},
			parents = {
				"node_c3518d3e-c14f-453b-886b-5f8aac1c93c6"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_5e74a121-356d-454e-baca-0739626cbddd",
			y = 575,
			y_normalized = 0,
			talent = "ogryn_single_heavy_toughness",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_single_heavy_toughness",
			x = 905,
			x_normalized = 0,
			children = {
				"node_13c684ce-e61d-435b-90d7-917248254ea4"
			},
			parents = {
				"node_f92c86fb-b19e-47fa-81bc-a78a2d834608",
				"node_c3518d3e-c14f-453b-886b-5f8aac1c93c6"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_e4d5b83c-4a0c-4080-9bfb-46f46fbbd8f3",
			y = 575,
			y_normalized = 0,
			talent = "ogryn_increased_coherency_toughness",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_increased_coherency_toughness",
			x = 1205,
			x_normalized = 0,
			children = {
				"node_56c81af7-254e-43da-9b53-4a8e02d88748"
			},
			parents = {
				"node_09e9b9b7-c1c8-4a9c-88eb-235ca27cc9e0",
				"node_f92c86fb-b19e-47fa-81bc-a78a2d834608"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_ac9221c9-6033-4a8d-99ca-2bd3b508bdba",
			y = 515,
			y_normalized = 0,
			talent = "ogryn_toughness_while_bracing",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_toughness_while_bracing",
			x = 1355,
			x_normalized = 0,
			children = {
				"node_56c81af7-254e-43da-9b53-4a8e02d88748"
			},
			parents = {
				"node_09e9b9b7-c1c8-4a9c-88eb-235ca27cc9e0"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_c3518d3e-c14f-453b-886b-5f8aac1c93c6",
			y = 455,
			y_normalized = 0,
			talent = "ogryn_more_hits_more_damage",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_more_hits_more_damage",
			x = 905,
			x_normalized = 0,
			children = {
				"node_219a7391-b6de-459c-83fd-631421d4f150",
				"node_5e74a121-356d-454e-baca-0739626cbddd"
			},
			parents = {
				"node_42376ced-a18f-44da-9bea-a9553169afdd"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_f92c86fb-b19e-47fa-81bc-a78a2d834608",
			y = 515,
			y_normalized = 0,
			talent = "ogryn_ogryn_killer",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_ogryn_killer",
			x = 1055,
			x_normalized = 0,
			children = {
				"node_e4d5b83c-4a0c-4080-9bfb-46f46fbbd8f3",
				"node_5e74a121-356d-454e-baca-0739626cbddd"
			},
			parents = {
				"node_42376ced-a18f-44da-9bea-a9553169afdd"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_09e9b9b7-c1c8-4a9c-88eb-235ca27cc9e0",
			y = 455,
			y_normalized = 0,
			talent = "ogryn_reloading_grants_damage",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_reloading_grants_damage",
			x = 1205,
			x_normalized = 0,
			children = {
				"node_ac9221c9-6033-4a8d-99ca-2bd3b508bdba",
				"node_e4d5b83c-4a0c-4080-9bfb-46f46fbbd8f3"
			},
			parents = {
				"node_42376ced-a18f-44da-9bea-a9553169afdd"
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
			widget_name = "node_13c684ce-e61d-435b-90d7-917248254ea4",
			y = 634,
			y_normalized = 0,
			talent = "base_toughness_node_buff_medium_1",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_default_general_talent",
			x = 754,
			x_normalized = 0,
			children = {
				"node_3e19fd5d-9d22-4e5c-8981-be97b1de8854",
				"node_e90b57a5-4f0f-461d-bc9c-c373fcd55243"
			},
			parents = {
				"node_5e74a121-356d-454e-baca-0739626cbddd",
				"node_219a7391-b6de-459c-83fd-631421d4f150"
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
			widget_name = "node_56c81af7-254e-43da-9b53-4a8e02d88748",
			y = 634,
			y_normalized = 0,
			talent = "base_toughness_node_buff_medium_2",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_default_general_talent",
			x = 1354,
			x_normalized = 0,
			children = {
				"node_4b421360-1595-4f94-bcf1-e4a715b9dbca",
				"node_3e19fd5d-9d22-4e5c-8981-be97b1de8854"
			},
			parents = {
				"node_ac9221c9-6033-4a8d-99ca-2bd3b508bdba",
				"node_e4d5b83c-4a0c-4080-9bfb-46f46fbbd8f3"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "aura",
			max_points = 1,
			widget_name = "node_3f7b629b-0f4b-4b74-9086-17b78f2a31c5",
			y = 1640,
			y_normalized = 0,
			talent = "ogryn_melee_damage_coherency_improved",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_aura_intimidating_presence",
			x = 740,
			x_normalized = 0,
			children = {
				"node_da691fd8-8833-4a20-a249-1289c8c8ced0"
			},
			parents = {
				"node_07c1903f-b432-460c-ae9c-16dd153579d3"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "aura"
			}
		},
		{
			type = "aura",
			max_points = 1,
			widget_name = "node_eb153946-19bd-4e03-8dcd-7feb7be78e56",
			y = 1640,
			y_normalized = 0,
			talent = "ogryn_damage_vs_suppressed_coherency",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_aura_bringing_big_guns",
			x = 1340,
			x_normalized = 0,
			children = {
				"node_a99253af-4828-4f63-94ab-80b17442865b"
			},
			parents = {
				"node_e0e49074-00b9-436a-869d-6fa7cf18e92c"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "aura"
			}
		},
		{
			type = "aura",
			max_points = 1,
			widget_name = "node_8d3ffc06-6e43-4888-bddb-adae115908fa",
			y = 1640,
			y_normalized = 0,
			talent = "ogryn_toughness_regen_aura",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_aura_stay_close",
			x = 1040,
			x_normalized = 0,
			children = {
				"node_083e96ae-e6c6-4eb1-9225-d28ee308abff"
			},
			parents = {
				"node_19bc7a64-5626-472e-9a1c-90f412545e96"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "aura"
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_4cf8d6e2-c191-4c71-b49e-f1d1b84cb457",
			y = 875,
			y_normalized = 0,
			talent = "ogryn_melee_stagger",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_melee_stagger",
			x = 875,
			x_normalized = 0,
			children = {
				"node_9d635d3a-59ef-4d38-96ac-51ab2c8828bf",
				"node_228dd214-e42e-40e7-a4b4-7aa427199190"
			},
			parents = {
				"node_e90b57a5-4f0f-461d-bc9c-c373fcd55243",
				"node_3e19fd5d-9d22-4e5c-8981-be97b1de8854"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_94f1d2a8-305c-4d75-bcc4-733a7ef4cd20",
			y = 875,
			y_normalized = 0,
			talent = "ogryn_targets_recieve_damage_taken_increase_debuff",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_targets_recieve_damage_taken_increase_debuff",
			x = 1235,
			x_normalized = 0,
			children = {
				"node_9d635d3a-59ef-4d38-96ac-51ab2c8828bf",
				"node_381a5d0b-75be-474b-a2a4-7f003de9e0f9"
			},
			parents = {
				"node_3e19fd5d-9d22-4e5c-8981-be97b1de8854",
				"node_4b421360-1595-4f94-bcf1-e4a715b9dbca"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "tactical",
			max_points = 1,
			widget_name = "node_3e19fd5d-9d22-4e5c-8981-be97b1de8854",
			y = 710,
			y_normalized = 0,
			talent = "ogryn_box_explodes",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_box_explodes",
			x = 1040,
			x_normalized = 0,
			children = {
				"node_4cf8d6e2-c191-4c71-b49e-f1d1b84cb457",
				"node_94f1d2a8-305c-4d75-bcc4-733a7ef4cd20"
			},
			parents = {
				"node_56c81af7-254e-43da-9b53-4a8e02d88748",
				"node_13c684ce-e61d-435b-90d7-917248254ea4"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "blitz"
			}
		},
		{
			type = "tactical",
			max_points = 1,
			widget_name = "node_4b421360-1595-4f94-bcf1-e4a715b9dbca",
			y = 740,
			y_normalized = 0,
			talent = "ogryn_grenade_frag",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_blitz_big_nade",
			x = 1340,
			x_normalized = 0,
			children = {
				"node_94f1d2a8-305c-4d75-bcc4-733a7ef4cd20"
			},
			parents = {
				"node_56c81af7-254e-43da-9b53-4a8e02d88748"
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
			widget_name = "node_d21dd87f-c648-4250-8723-e931a8dfdeea",
			y = 1264,
			y_normalized = 0,
			talent = "base_armor_pen_node_buff_low_1",
			x = 784,
			x_normalized = 0,
			children = {
				"node_8f283711-065f-4147-af2b-ea22b8d6d9bf",
				"node_950e1baa-f9b8-4d12-a913-514249d4f38a",
				"node_b7dd1da9-16a1-4a3d-b1d2-121338107a34"
			},
			parents = {
				"node_3bdab07a-e8d9-4afb-8f66-71c94c9a546d",
				"node_1642abd3-b5d6-4332-83d0-aec599fd3dca"
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
			widget_name = "node_0966a3c3-55ef-4492-b3d1-7399663aeb55",
			y = 1264,
			y_normalized = 0,
			talent = "base_reload_speed_node_buff_low_1",
			x = 1324,
			x_normalized = 0,
			children = {
				"node_a68be7fb-c454-4cfd-9ab9-626b1facc88b",
				"node_2b77018d-399b-4b87-bc1b-141e27a53e6a",
				"node_b7dd1da9-16a1-4a3d-b1d2-121338107a34"
			},
			parents = {
				"node_2febaa70-bba7-407d-8b22-c1160bd4c271",
				"node_1642abd3-b5d6-4332-83d0-aec599fd3dca"
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
			widget_name = "node_b8d31e67-096c-444e-a00d-a4bf3f5c1b4e",
			y = 2074,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_medium_4",
			x = 694,
			x_normalized = 0,
			children = {
				"node_37a0aac7-ced6-4bdf-a9dc-538be8e4a14e",
				"node_49ec4564-0c9a-4bb4-815e-b023b090d05d"
			},
			parents = {
				"node_08929afd-e60d-457d-8006-b87c917647ff",
				"node_fffcae3d-430c-4955-98ba-098c7eb9d71b"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_8f283711-065f-4147-af2b-ea22b8d6d9bf",
			y = 1415,
			y_normalized = 0,
			talent = "ogryn_fully_charged_attacks_gain_damage_and_stagger",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_fully_charged_attacks_gain_damage_and_stagger",
			x = 725,
			x_normalized = 0,
			children = {
				"node_07c1903f-b432-460c-ae9c-16dd153579d3"
			},
			parents = {
				"node_d21dd87f-c648-4250-8723-e931a8dfdeea"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_950e1baa-f9b8-4d12-a913-514249d4f38a",
			y = 1415,
			y_normalized = 0,
			talent = "ogryn_heavy_bleeds",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_heavy_bleeds",
			x = 845,
			x_normalized = 0,
			children = {
				"node_07c1903f-b432-460c-ae9c-16dd153579d3"
			},
			parents = {
				"node_d21dd87f-c648-4250-8723-e931a8dfdeea"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_19bc7a64-5626-472e-9a1c-90f412545e96",
			y = 1535,
			y_normalized = 0,
			talent = "ogryn_staggering_increases_damage",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_staggering_increases_damage",
			x = 1055,
			x_normalized = 0,
			children = {
				"node_8d3ffc06-6e43-4888-bddb-adae115908fa"
			},
			parents = {
				"node_b7dd1da9-16a1-4a3d-b1d2-121338107a34"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_a68be7fb-c454-4cfd-9ab9-626b1facc88b",
			y = 1415,
			y_normalized = 0,
			talent = "ogryn_multi_hits_grant_reload_speed",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_multi_hits_grant_reload_speed",
			x = 1265,
			x_normalized = 0,
			children = {
				"node_e0e49074-00b9-436a-869d-6fa7cf18e92c"
			},
			parents = {
				"node_0966a3c3-55ef-4492-b3d1-7399663aeb55"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_2b77018d-399b-4b87-bc1b-141e27a53e6a",
			y = 1415,
			y_normalized = 0,
			talent = "ogryn_increased_ammo_reserve",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_increased_ammo_reserve",
			x = 1385,
			x_normalized = 0,
			children = {
				"node_e0e49074-00b9-436a-869d-6fa7cf18e92c"
			},
			parents = {
				"node_0966a3c3-55ef-4492-b3d1-7399663aeb55"
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
			widget_name = "node_07c1903f-b432-460c-ae9c-16dd153579d3",
			y = 1534,
			y_normalized = 0,
			talent = "base_melee_heavy_damage_node_buff_medium_1",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_default_general_talent",
			x = 784,
			x_normalized = 0,
			children = {
				"node_3f7b629b-0f4b-4b74-9086-17b78f2a31c5"
			},
			parents = {
				"node_950e1baa-f9b8-4d12-a913-514249d4f38a",
				"node_8f283711-065f-4147-af2b-ea22b8d6d9bf"
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
			widget_name = "node_b7dd1da9-16a1-4a3d-b1d2-121338107a34",
			y = 1414,
			y_normalized = 0,
			talent = "base_health_node_buff_low_1",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_default_general_talent",
			x = 1054,
			x_normalized = 0,
			children = {
				"node_57d68853-98ea-4767-ba0b-d2a17f863c23",
				"node_1eb8ca16-4b4a-4e89-a0ae-a6b5df90273d",
				"node_19bc7a64-5626-472e-9a1c-90f412545e96"
			},
			parents = {
				"node_37a0aac7-ced6-4bdf-a9dc-538be8e4a14e",
				"node_0966a3c3-55ef-4492-b3d1-7399663aeb55",
				"node_d21dd87f-c648-4250-8723-e931a8dfdeea"
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
			widget_name = "node_e0e49074-00b9-436a-869d-6fa7cf18e92c",
			y = 1534,
			y_normalized = 0,
			talent = "base_ranged_damage_node_buff_low_1",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_default_general_talent",
			x = 1324,
			x_normalized = 0,
			children = {
				"node_eb153946-19bd-4e03-8dcd-7feb7be78e56"
			},
			parents = {
				"node_a68be7fb-c454-4cfd-9ab9-626b1facc88b",
				"node_2b77018d-399b-4b87-bc1b-141e27a53e6a"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_65087f4f-47f2-428b-8c72-a5120e1116ac",
			y = 1865,
			y_normalized = 0,
			talent = "ogryn_coherency_radius_increase",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_coherency_radius_increase",
			x = 1355,
			x_normalized = 0,
			children = {
				"node_a48230be-6330-4e03-871c-0a3881828604"
			},
			parents = {
				"node_a99253af-4828-4f63-94ab-80b17442865b"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_87ca6136-03a7-45da-96b2-7ebd9e04f36a",
			y = 2195,
			y_normalized = 0,
			talent = "ogryn_bracing_reduces_damage_taken",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_bracing_reduces_damage_taken",
			x = 1415,
			x_normalized = 0,
			children = {
				"node_239bc3d0-b8b9-4d46-bb25-92e73e7ee495"
			},
			parents = {
				"node_387adcbf-5a43-4004-b575-862acfb59183"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "keystone",
			max_points = 1,
			widget_name = "node_e64ae2d0-e20a-486a-8cf6-9208cb9dd9e6",
			y = 2420,
			y_normalized = 0,
			talent = "ogryn_leadbelcher_no_ammo_chance",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_keystone_leadbelcher",
			x = 1400,
			x_normalized = 0,
			children = {
				"node_8e2afd01-7306-4800-a570-5691d70e939c",
				"node_efe33c0f-ffa8-441f-bc7a-2e11f76b9d73"
			},
			parents = {
				"node_239bc3d0-b8b9-4d46-bb25-92e73e7ee495"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "keystone"
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_361c0f03-d3f0-47a9-8669-2f71f6c2b5a1",
			y = 2195,
			y_normalized = 0,
			talent = "ogryn_knocked_allies_grant_damage_reduction",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_knocked_allies_grant_damage_reduction",
			x = 1115,
			x_normalized = 0,
			children = {
				"node_1fa7377f-2d7f-462f-9aec-e67d9efb69c6"
			},
			parents = {
				"node_39e9d33e-a2db-41c3-b628-1f45e1ab31af"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "keystone",
			max_points = 1,
			widget_name = "node_916ca2ec-b1d0-41c4-807b-a250950f9d5b",
			y = 2420,
			y_normalized = 0,
			talent = "ogryn_carapace_armor",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_keystone_carapace_armor",
			x = 1040,
			x_normalized = 0,
			children = {
				"node_74124e64-9e74-4e38-a5ce-0ab0a8516736",
				"node_a919d7de-281e-485f-aabb-5d7c18d3aa4c"
			},
			parents = {
				"node_57d68853-98ea-4767-ba0b-d2a17f863c23",
				"node_1fa7377f-2d7f-462f-9aec-e67d9efb69c6"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "keystone"
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_49ec4564-0c9a-4bb4-815e-b023b090d05d",
			y = 2195,
			y_normalized = 0,
			talent = "ogryn_windup_reduces_damage_taken",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_windup_reduces_damage_taken",
			x = 695,
			x_normalized = 0,
			children = {
				"node_551ce3b8-b10d-45e4-9aae-0e99775c11e5"
			},
			parents = {
				"node_b8d31e67-096c-444e-a00d-a4bf3f5c1b4e"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_dd4eee73-3ed9-46e9-be35-e7e4860f0ed8",
			y = 1865,
			y_normalized = 0,
			talent = "ogryn_nearby_bleeds_reduce_damage_taken",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_nearby_bleeds_reduce_damage_taken",
			x = 755,
			x_normalized = 0,
			children = {
				"node_fffcae3d-430c-4955-98ba-098c7eb9d71b"
			},
			parents = {
				"node_da691fd8-8833-4a20-a249-1289c8c8ced0"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "keystone",
			max_points = 1,
			widget_name = "node_894ba06e-9e23-480b-9674-a1f4df246824",
			y = 2420,
			y_normalized = 0,
			talent = "ogryn_passive_heavy_hitter",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_keystone_heavy_hitter",
			x = 680,
			x_normalized = 0,
			children = {
				"node_ce22538b-94b5-4934-8bb1-b99d4c44e906",
				"node_e4167545-23c8-41af-8e59-808f80d3193f"
			},
			parents = {
				"node_551ce3b8-b10d-45e4-9aae-0e99775c11e5"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "keystone"
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_e4167545-23c8-41af-8e59-808f80d3193f",
			y = 2525,
			y_normalized = 0,
			talent = "ogryn_heavy_hitter_max_stacks_improves_attack_speed",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_heavy_hitter_max_stacks_improves_attack_speed",
			x = 605,
			x_normalized = 0,
			children = {
				"node_0df848e4-3cd3-44a3-a669-4c4b069a1bef"
			},
			parents = {
				"node_894ba06e-9e23-480b-9674-a1f4df246824"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_ce22538b-94b5-4934-8bb1-b99d4c44e906",
			y = 2525,
			y_normalized = 0,
			talent = "ogryn_heavy_hitter_max_stacks_improves_toughness",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_heavy_hitter_max_stacks_improves_toughness",
			x = 785,
			x_normalized = 0,
			children = {
				"node_0df848e4-3cd3-44a3-a669-4c4b069a1bef"
			},
			parents = {
				"node_894ba06e-9e23-480b-9674-a1f4df246824"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_0df848e4-3cd3-44a3-a669-4c4b069a1bef",
			y = 2615,
			y_normalized = 0,
			talent = "ogryn_heavy_hitter_light_attacks_refresh",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_heavy_hitter_light_attacks_refresh",
			x = 695,
			x_normalized = 0,
			children = {},
			parents = {
				"node_e4167545-23c8-41af-8e59-808f80d3193f",
				"node_ce22538b-94b5-4934-8bb1-b99d4c44e906"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_a919d7de-281e-485f-aabb-5d7c18d3aa4c",
			y = 2525,
			y_normalized = 0,
			talent = "ogryn_carapace_armor_trigger_on_zero_stacks",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_carapace_armor_trigger_on_zero_stacks",
			x = 965,
			x_normalized = 0,
			children = {
				"node_f4b9c999-6d19-4a1a-b18e-6f448c4b689a"
			},
			parents = {
				"node_916ca2ec-b1d0-41c4-807b-a250950f9d5b"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_74124e64-9e74-4e38-a5ce-0ab0a8516736",
			y = 2525,
			y_normalized = 0,
			talent = "ogryn_carapace_armor_add_stack_on_push",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_carapace_armor_add_stack_on_push",
			x = 1145,
			x_normalized = 0,
			children = {
				"node_f4b9c999-6d19-4a1a-b18e-6f448c4b689a"
			},
			parents = {
				"node_916ca2ec-b1d0-41c4-807b-a250950f9d5b"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_f4b9c999-6d19-4a1a-b18e-6f448c4b689a",
			y = 2615,
			y_normalized = 0,
			talent = "ogryn_carapace_armor_more_toughness",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_carapace_armor_more_toughness",
			x = 1055,
			x_normalized = 0,
			children = {},
			parents = {
				"node_a919d7de-281e-485f-aabb-5d7c18d3aa4c",
				"node_74124e64-9e74-4e38-a5ce-0ab0a8516736"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_efe33c0f-ffa8-441f-bc7a-2e11f76b9d73",
			y = 2525,
			y_normalized = 0,
			talent = "ogryn_leadbelcher_cooldown_reduction",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_leadbelcher_cooldown_reduction",
			x = 1325,
			x_normalized = 0,
			children = {
				"node_e189b488-7881-4acf-ad96-3a90b6913e49"
			},
			parents = {
				"node_e64ae2d0-e20a-486a-8cf6-9208cb9dd9e6"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_8e2afd01-7306-4800-a570-5691d70e939c",
			y = 2525,
			y_normalized = 0,
			talent = "ogryn_leadbelcher_crits",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_leadbelcher_crits",
			x = 1505,
			x_normalized = 0,
			children = {
				"node_e189b488-7881-4acf-ad96-3a90b6913e49"
			},
			parents = {
				"node_e64ae2d0-e20a-486a-8cf6-9208cb9dd9e6"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_e189b488-7881-4acf-ad96-3a90b6913e49",
			y = 2615,
			y_normalized = 0,
			talent = "ogryn_leadbelcher_trigger_chance_increase",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_leadbelcher_trigger_chance_increase",
			x = 1415,
			x_normalized = 0,
			children = {},
			parents = {
				"node_efe33c0f-ffa8-441f-bc7a-2e11f76b9d73",
				"node_8e2afd01-7306-4800-a570-5691d70e939c"
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
			widget_name = "node_9d635d3a-59ef-4d38-96ac-51ab2c8828bf",
			y = 964,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_medium_1",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_default_general_talent",
			x = 1054,
			x_normalized = 0,
			children = {
				"node_1642abd3-b5d6-4332-83d0-aec599fd3dca",
				"node_3bdab07a-e8d9-4afb-8f66-71c94c9a546d",
				"node_2febaa70-bba7-407d-8b22-c1160bd4c271"
			},
			parents = {
				"node_4cf8d6e2-c191-4c71-b49e-f1d1b84cb457",
				"node_94f1d2a8-305c-4d75-bcc4-733a7ef4cd20"
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
			widget_name = "node_a99253af-4828-4f63-94ab-80b17442865b",
			y = 1774,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_medium_2",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_default_general_talent",
			x = 1414,
			x_normalized = 0,
			children = {
				"node_083e96ae-e6c6-4eb1-9225-d28ee308abff",
				"node_65087f4f-47f2-428b-8c72-a5120e1116ac",
				"node_1af9b61a-cb71-4510-9513-f46c0d73a4b0"
			},
			parents = {
				"node_eb153946-19bd-4e03-8dcd-7feb7be78e56",
				"node_083e96ae-e6c6-4eb1-9225-d28ee308abff"
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
			widget_name = "node_083e96ae-e6c6-4eb1-9225-d28ee308abff",
			y = 1774,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_3",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_default_general_talent",
			x = 1054,
			x_normalized = 0,
			children = {
				"node_a99253af-4828-4f63-94ab-80b17442865b",
				"node_da691fd8-8833-4a20-a249-1289c8c8ced0",
				"node_60907136-b068-4b78-9e88-200e0abbf64f",
				"node_439226f9-4126-4a4c-9a7e-58850b64f4c1"
			},
			parents = {
				"node_295a529f-6640-4b4e-aa0c-19f6cd527397",
				"node_8d3ffc06-6e43-4888-bddb-adae115908fa",
				"node_da691fd8-8833-4a20-a249-1289c8c8ced0",
				"node_a99253af-4828-4f63-94ab-80b17442865b"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_a1ee7d5a-d620-416a-854a-96054870ed5d",
			y = 1985,
			y_normalized = 0,
			talent = "ogryn_ally_elite_kills_grant_cooldown",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_ally_elite_kills_grant_cooldown",
			x = 1115,
			x_normalized = 0,
			children = {
				"node_39e9d33e-a2db-41c3-b628-1f45e1ab31af"
			},
			parents = {
				"node_439226f9-4126-4a4c-9a7e-58850b64f4c1"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_439226f9-4126-4a4c-9a7e-58850b64f4c1",
			y = 1865,
			y_normalized = 0,
			talent = "ogryn_ally_movement_boost_on_ability",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_ally_movement_boost_on_ability",
			x = 1115,
			x_normalized = 0,
			children = {
				"node_a1ee7d5a-d620-416a-854a-96054870ed5d"
			},
			parents = {
				"node_083e96ae-e6c6-4eb1-9225-d28ee308abff"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_27d9c0ef-dd49-4aaa-a921-1c334c824caf",
			y = 1865,
			y_normalized = 0,
			talent = "ogryn_toughness_on_low_health",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_toughness_on_low_health",
			x = 635,
			x_normalized = 0,
			children = {
				"node_08929afd-e60d-457d-8006-b87c917647ff"
			},
			parents = {
				"node_da691fd8-8833-4a20-a249-1289c8c8ced0"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_08929afd-e60d-457d-8006-b87c917647ff",
			y = 1985,
			y_normalized = 0,
			talent = "ogryn_windup_is_uninterruptible",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_windup_is_uninterruptible",
			x = 635,
			x_normalized = 0,
			children = {
				"node_b8d31e67-096c-444e-a00d-a4bf3f5c1b4e"
			},
			parents = {
				"node_27d9c0ef-dd49-4aaa-a921-1c334c824caf"
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
			widget_name = "node_da691fd8-8833-4a20-a249-1289c8c8ced0",
			y = 1774,
			y_normalized = 0,
			talent = "base_melee_damage_node_buff_low_2",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_default_general_talent",
			x = 694,
			x_normalized = 0,
			children = {
				"node_083e96ae-e6c6-4eb1-9225-d28ee308abff",
				"node_27d9c0ef-dd49-4aaa-a921-1c334c824caf",
				"node_dd4eee73-3ed9-46e9-be35-e7e4860f0ed8"
			},
			parents = {
				"node_3f7b629b-0f4b-4b74-9086-17b78f2a31c5",
				"node_083e96ae-e6c6-4eb1-9225-d28ee308abff"
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
			widget_name = "node_387adcbf-5a43-4004-b575-862acfb59183",
			y = 2074,
			y_normalized = 0,
			talent = "base_suppression_node_buff_low_1",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_default_general_talent",
			x = 1414,
			x_normalized = 0,
			children = {
				"node_87ca6136-03a7-45da-96b2-7ebd9e04f36a"
			},
			parents = {
				"node_3f0606c3-a70e-461e-a487-031ef17650ba",
				"node_a48230be-6330-4e03-871c-0a3881828604"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_3f0606c3-a70e-461e-a487-031ef17650ba",
			y = 1985,
			y_normalized = 0,
			talent = "ogryn_kills_grant_crit_chance",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_kills_grant_crit_chance",
			x = 1475,
			x_normalized = 0,
			children = {
				"node_387adcbf-5a43-4004-b575-862acfb59183"
			},
			parents = {
				"node_1af9b61a-cb71-4510-9513-f46c0d73a4b0"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_dc6e3ffa-e5cb-4993-a914-04445d983656",
			y = 1985,
			y_normalized = 0,
			talent = "ogryn_revenge_damage",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_revenge_damage",
			x = 995,
			x_normalized = 0,
			children = {
				"node_295a529f-6640-4b4e-aa0c-19f6cd527397",
				"node_39e9d33e-a2db-41c3-b628-1f45e1ab31af"
			},
			parents = {
				"node_60907136-b068-4b78-9e88-200e0abbf64f"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_fffcae3d-430c-4955-98ba-098c7eb9d71b",
			y = 1985,
			y_normalized = 0,
			talent = "ogryn_rending_on_elite_kills",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_rending_on_elite_kills",
			x = 755,
			x_normalized = 0,
			children = {
				"node_b8d31e67-096c-444e-a00d-a4bf3f5c1b4e"
			},
			parents = {
				"node_dd4eee73-3ed9-46e9-be35-e7e4860f0ed8"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_a48230be-6330-4e03-871c-0a3881828604",
			y = 1985,
			y_normalized = 0,
			talent = "ogryn_increase_explosion_radius",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_increase_explosion_radius",
			x = 1355,
			x_normalized = 0,
			children = {
				"node_387adcbf-5a43-4004-b575-862acfb59183"
			},
			parents = {
				"node_65087f4f-47f2-428b-8c72-a5120e1116ac"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_1af9b61a-cb71-4510-9513-f46c0d73a4b0",
			y = 1865,
			y_normalized = 0,
			talent = "ogryn_movement_speed_after_ranged_kills",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_movement_speed_after_ranged_kills",
			x = 1475,
			x_normalized = 0,
			children = {
				"node_3f0606c3-a70e-461e-a487-031ef17650ba"
			},
			parents = {
				"node_a99253af-4828-4f63-94ab-80b17442865b"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			group_name = "taunt",
			type = "ability",
			widget_name = "node_1642abd3-b5d6-4332-83d0-aec599fd3dca",
			y = 1089,
			y_normalized = 0,
			talent = "ogryn_taunt_shout",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_ability_taunt",
			x = 1029,
			x_normalized = 0,
			children = {
				"node_2eef5b19-a13a-4f02-92f6-850ce20bb84f",
				"node_7600d19e-f407-41d6-853d-2bcd13a7a9c8",
				"node_d21dd87f-c648-4250-8723-e931a8dfdeea",
				"node_0966a3c3-55ef-4492-b3d1-7399663aeb55"
			},
			parents = {
				"node_9d635d3a-59ef-4d38-96ac-51ab2c8828bf"
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
			group_name = "charge",
			type = "ability",
			widget_name = "node_3bdab07a-e8d9-4afb-8f66-71c94c9a546d",
			y = 1089,
			y_normalized = 0,
			talent = "ogryn_longer_charge",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_longer_charge",
			x = 759,
			x_normalized = 0,
			children = {
				"node_6639c593-e867-4ee5-9536-b01124b5aa53",
				"node_d21dd87f-c648-4250-8723-e931a8dfdeea"
			},
			parents = {
				"node_9d635d3a-59ef-4d38-96ac-51ab2c8828bf",
				"node_228dd214-e42e-40e7-a4b4-7aa427199190"
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
			group_name = "speshul",
			type = "ability",
			widget_name = "node_2febaa70-bba7-407d-8b22-c1160bd4c271",
			y = 1089,
			y_normalized = 0,
			talent = "ogryn_special_ammo",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_ability_speshul_ammo",
			x = 1299,
			x_normalized = 0,
			children = {
				"node_3c6f836b-d499-4457-959c-8c519347d3c3",
				"node_0966a3c3-55ef-4492-b3d1-7399663aeb55"
			},
			parents = {
				"node_9d635d3a-59ef-4d38-96ac-51ab2c8828bf",
				"node_381a5d0b-75be-474b-a2a4-7f003de9e0f9"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "combat"
			}
		},
		{
			type = "ability_modifier",
			max_points = 1,
			widget_name = "node_6639c593-e867-4ee5-9536-b01124b5aa53",
			y = 1175,
			y_normalized = 0,
			talent = "ogryn_charge_toughness",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_charge_toughness",
			x = 665,
			x_normalized = 0,
			children = {
				"node_c8dc2052-517d-42cf-84e5-ff8161b2f99f",
				"node_b3d3d2eb-a57e-4c0e-bc45-5d0c41b94135"
			},
			parents = {
				"node_3bdab07a-e8d9-4afb-8f66-71c94c9a546d"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "ability_modifier",
			max_points = 1,
			widget_name = "node_c8dc2052-517d-42cf-84e5-ff8161b2f99f",
			y = 1295,
			y_normalized = 0,
			talent = "ogryn_charge_applies_bleed",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_charge_applies_bleed",
			x = 665,
			x_normalized = 0,
			children = {},
			parents = {
				"node_6639c593-e867-4ee5-9536-b01124b5aa53"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "ogryn_charge_2"
			}
		},
		{
			type = "ability_modifier",
			max_points = 1,
			widget_name = "node_7600d19e-f407-41d6-853d-2bcd13a7a9c8",
			y = 1235,
			y_normalized = 0,
			talent = "ogryn_taunt_staggers_reduce_cooldown",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_taunt_staggers_reduce_cooldown",
			x = 1115,
			x_normalized = 0,
			children = {
				"node_2f3d7564-5550-4782-bc81-919d31b686dd"
			},
			parents = {
				"node_1642abd3-b5d6-4332-83d0-aec599fd3dca"
			},
			requirements = {
				min_points_spent = 0,
				all_parents_chosen = false,
				min_points_spent_in_group = "",
				children_unlock_points = 1,
				exclusive_group = "taunt_1"
			}
		},
		{
			type = "ability_modifier",
			max_points = 1,
			widget_name = "node_d2b60f6e-1db0-4ccd-b239-75926acb7839",
			y = 1235,
			y_normalized = 0,
			talent = "ogryn_special_ammo_armor_pen",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_special_ammo_armor_pen",
			x = 1565,
			x_normalized = 0,
			children = {},
			parents = {
				"node_3c6f836b-d499-4457-959c-8c519347d3c3"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "speshul_modifiers"
			}
		},
		{
			type = "ability_modifier",
			max_points = 1,
			widget_name = "node_e4a4e00d-fd7d-49a8-a67e-7a09372c77da",
			y = 1295,
			y_normalized = 0,
			talent = "ogryn_special_ammo_fire_shots",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_special_ammo_fire_shots",
			x = 1445,
			x_normalized = 0,
			children = {},
			parents = {
				"node_3c6f836b-d499-4457-959c-8c519347d3c3"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "speshul_modifiers"
			}
		},
		{
			type = "ability_modifier",
			max_points = 1,
			widget_name = "node_0b0cb1c9-2a29-4b58-90f3-a7986ca8a672",
			y = 1115,
			y_normalized = 0,
			talent = "ogryn_special_ammo_movement",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_special_ammo_movement",
			x = 1535,
			x_normalized = 0,
			children = {},
			parents = {
				"node_3c6f836b-d499-4457-959c-8c519347d3c3"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "speshul_modifiers"
			}
		},
		{
			type = "ability_modifier",
			max_points = 1,
			widget_name = "node_2eef5b19-a13a-4f02-92f6-850ce20bb84f",
			y = 1235,
			y_normalized = 0,
			talent = "ogryn_taunt_damage_taken_increase",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_taunt_damage_taken_increase",
			x = 995,
			x_normalized = 0,
			children = {
				"node_2f3d7564-5550-4782-bc81-919d31b686dd"
			},
			parents = {
				"node_1642abd3-b5d6-4332-83d0-aec599fd3dca"
			},
			requirements = {
				min_points_spent = 0,
				all_parents_chosen = false,
				min_points_spent_in_group = "",
				children_unlock_points = 1,
				exclusive_group = "taunt_1"
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_0de9050d-5ec9-4a98-af4b-d05ce723892d",
			y = 2195,
			y_normalized = 0,
			talent = "ogryn_blocking_reduces_push_cost",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_blocking_reduces_push_cost",
			x = 995,
			x_normalized = 0,
			children = {
				"node_1fa7377f-2d7f-462f-9aec-e67d9efb69c6"
			},
			parents = {
				"node_39e9d33e-a2db-41c3-b628-1f45e1ab31af"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "ability_modifier",
			max_points = 1,
			widget_name = "node_3c6f836b-d499-4457-959c-8c519347d3c3",
			y = 1175,
			y_normalized = 0,
			talent = "ogryn_ranged_stance_toughness_regen",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_ranged_stance_toughness_regen",
			x = 1445,
			x_normalized = 0,
			children = {
				"node_e4a4e00d-fd7d-49a8-a67e-7a09372c77da",
				"node_0b0cb1c9-2a29-4b58-90f3-a7986ca8a672",
				"node_d2b60f6e-1db0-4ccd-b239-75926acb7839"
			},
			parents = {
				"node_2febaa70-bba7-407d-8b22-c1160bd4c271"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "tactical",
			max_points = 1,
			widget_name = "node_e90b57a5-4f0f-461d-bc9c-c373fcd55243",
			y = 740,
			y_normalized = 0,
			talent = "ogryn_grenade_friend_rock",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_blitz_big_friendly_rock",
			x = 740,
			x_normalized = 0,
			children = {
				"node_4cf8d6e2-c191-4c71-b49e-f1d1b84cb457"
			},
			parents = {
				"node_13c684ce-e61d-435b-90d7-917248254ea4"
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
			widget_name = "node_551ce3b8-b10d-45e4-9aae-0e99775c11e5",
			y = 2314,
			y_normalized = 0,
			talent = "base_melee_heavy_damage_node_buff_low_5",
			x = 694,
			x_normalized = 0,
			children = {
				"node_894ba06e-9e23-480b-9674-a1f4df246824"
			},
			parents = {
				"node_49ec4564-0c9a-4bb4-815e-b023b090d05d"
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
			widget_name = "node_1fa7377f-2d7f-462f-9aec-e67d9efb69c6",
			y = 2314,
			y_normalized = 0,
			talent = "base_health_node_buff_medium_5",
			x = 1054,
			x_normalized = 0,
			children = {
				"node_916ca2ec-b1d0-41c4-807b-a250950f9d5b"
			},
			parents = {
				"node_0de9050d-5ec9-4a98-af4b-d05ce723892d",
				"node_361c0f03-d3f0-47a9-8669-2f71f6c2b5a1"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_60907136-b068-4b78-9e88-200e0abbf64f",
			y = 1865,
			y_normalized = 0,
			talent = "ogryn_blocking_ranged_taunts",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_blocking_ranged_taunts",
			x = 995,
			x_normalized = 0,
			children = {
				"node_dc6e3ffa-e5cb-4993-a914-04445d983656"
			},
			parents = {
				"node_083e96ae-e6c6-4eb1-9225-d28ee308abff"
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
			widget_name = "node_239bc3d0-b8b9-4d46-bb25-92e73e7ee495",
			y = 2314,
			y_normalized = 0,
			talent = "base_ranged_damage_node_buff_low_5",
			x = 1414,
			x_normalized = 0,
			children = {
				"node_e64ae2d0-e20a-486a-8cf6-9208cb9dd9e6"
			},
			parents = {
				"node_87ca6136-03a7-45da-96b2-7ebd9e04f36a"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "ability_modifier",
			max_points = 1,
			widget_name = "node_2f3d7564-5550-4782-bc81-919d31b686dd",
			y = 1325,
			y_normalized = 0,
			talent = "ogryn_taunt_radius_increase",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_taunt_radius_increase",
			x = 1055,
			x_normalized = 0,
			children = {},
			parents = {
				"node_2eef5b19-a13a-4f02-92f6-850ce20bb84f",
				"node_7600d19e-f407-41d6-853d-2bcd13a7a9c8"
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
			widget_name = "node_39e9d33e-a2db-41c3-b628-1f45e1ab31af",
			y = 2074,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_4",
			x = 1054,
			x_normalized = 0,
			children = {
				"node_0de9050d-5ec9-4a98-af4b-d05ce723892d",
				"node_361c0f03-d3f0-47a9-8669-2f71f6c2b5a1"
			},
			parents = {
				"node_a1ee7d5a-d620-416a-854a-96054870ed5d",
				"node_dc6e3ffa-e5cb-4993-a914-04445d983656"
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
			widget_name = "node_228dd214-e42e-40e7-a4b4-7aa427199190",
			y = 964,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_1",
			x = 784,
			x_normalized = 0,
			children = {
				"node_3bdab07a-e8d9-4afb-8f66-71c94c9a546d"
			},
			parents = {
				"node_4cf8d6e2-c191-4c71-b49e-f1d1b84cb457"
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
			widget_name = "node_381a5d0b-75be-474b-a2a4-7f003de9e0f9",
			y = 964,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_2",
			x = 1324,
			x_normalized = 0,
			children = {
				"node_2febaa70-bba7-407d-8b22-c1160bd4c271"
			},
			parents = {
				"node_94f1d2a8-305c-4d75-bcc4-733a7ef4cd20"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "ability_modifier",
			max_points = 1,
			widget_name = "node_b3d3d2eb-a57e-4c0e-bc45-5d0c41b94135",
			y = 1235,
			y_normalized = 0,
			talent = "ogryn_charge_trample",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_ability_charge_trample",
			x = 545,
			x_normalized = 0,
			children = {},
			parents = {
				"node_6639c593-e867-4ee5-9536-b01124b5aa53"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "ogryn_charge_2"
			}
		}
	},
	offset = {
		0,
		0
	},
	size = {
		4096,
		4096
	}
}
