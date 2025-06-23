-- chunkname: @scripts/ui/views/talent_builder_view/layouts/adamant_tree.lua

return {
	name = "adamant_tree",
	node_points = 30,
	version = 17,
	background_height = 2850,
	archetype_name = "adamant",
	talent_points = 30,
	nodes = {
		{
			max_points = 1,
			widget_name = "node_43567fd7-f7c3-4b73-9cb5-3fb72af27a23",
			x = 1120,
			type = "start",
			y = 430,
			y_normalized = 0,
			rendered_y = 430,
			icon = "content/ui/textures/icons/talents/zealot/zealot_default_general_talent",
			rendered_x = 1120,
			x_normalized = 0,
			children = {
				"node_577dcd33-0991-437a-ac3f-93d5cf1eda97",
				"node_0ebf45d0-b4da-42ea-8735-1d9c31ac2a9f",
				"node_a9e22eac-7d0d-4567-ae6c-e7be34534eaa"
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
			widget_name = "node_d11bcab3-f47e-43ef-8f26-72e4ed2760fe",
			type = "aura",
			x = 830,
			y = 1400,
			y_normalized = 0,
			rendered_y = 1400,
			talent = "adamant_companion_coherency",
			icon = "content/ui/textures/icons/talents/adamant/adamant_companion_coherency",
			rendered_x = 830,
			x_normalized = 0,
			children = {
				"node_9b9dbee9-4fbc-4422-bdce-865d5759fe70",
				"node_49bbfafc-233f-4a23-9a72-0412b4fcf719"
			},
			parents = {
				"node_4137c1d3-f155-4dbb-ae2f-01eeae998353",
				"node_b4efa6cf-bc1d-4616-9518-4b9fc363dcf8"
			},
			requirements = {
				min_points_spent = 0,
				all_parents_chosen = false,
				incompatible_talent = "adamant_disable_companion",
				children_unlock_points = 1,
				exclusive_group = "aura_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_d9c8ac91-9f39-43f5-9655-c836de0bb997",
			type = "aura",
			x = 1070,
			y = 1400,
			y_normalized = 0,
			rendered_y = 1400,
			talent = "adamant_reload_speed_aura",
			icon = "content/ui/textures/icons/talents/adamant/adamant_wield_speed_aura",
			rendered_x = 1070,
			x_normalized = 0,
			children = {
				"node_49bbfafc-233f-4a23-9a72-0412b4fcf719"
			},
			parents = {
				"node_5aaad316-c107-420b-9010-48668b673c58",
				"node_b4efa6cf-bc1d-4616-9518-4b9fc363dcf8"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "aura_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_52c3f35e-7fe4-4321-a04c-2a51eccac74c",
			type = "keystone",
			x = 710,
			y = 2390,
			y_normalized = 0,
			rendered_y = 2390,
			talent = "adamant_execution_order",
			icon = "content/ui/textures/icons/talents/adamant/adamant_exterminator",
			rendered_x = 710,
			x_normalized = 0,
			children = {
				"node_dbdb2b08-b8ce-4dc5-88c9-139f0486b54c",
				"node_8abdbb78-a06d-4d97-959a-a46930ab0752",
				"node_e686dc62-a877-4eef-8a96-52743b1c0fcd",
				"node_939b77d7-9bd1-48a9-8ae6-66beae3686ec"
			},
			parents = {
				"node_62deceb2-66cd-4494-b96d-27b9fcc8732b",
				"node_939b77d7-9bd1-48a9-8ae6-66beae3686ec",
				"node_e992d16b-4372-4874-93ca-7a520cceb74c"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "keystone_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_65d7f26b-711e-4ef9-ae0e-5bad2ac7a818",
			type = "keystone",
			x = 1070,
			y = 2390,
			y_normalized = 0,
			rendered_y = 2390,
			talent = "adamant_terminus_warrant",
			icon = "content/ui/textures/icons/talents/adamant/adamant_terminus_warrant",
			rendered_x = 1070,
			x_normalized = 0,
			children = {
				"node_9a64c5d0-9d4b-479f-90d2-4c48d8523a70",
				"node_b6adf64e-bc34-455a-a059-552c4fb0f8a0",
				"node_446b745a-e92e-4e31-8cc0-0ee5327f5674",
				"node_9964320a-cf72-40d7-ad57-d4e5bc4a7345",
				"node_48e362cb-c6b4-4d38-a325-08667444b783"
			},
			parents = {
				"node_eea35a28-d324-4f45-b682-edadc7d4c5ef",
				"node_48e362cb-c6b4-4d38-a325-08667444b783",
				"node_b93d4978-d0c5-4257-8725-9a1b20596f93"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "keystone_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_23717e1a-a7ea-44f6-b168-9bd668cd29a3",
			type = "keystone",
			x = 1430,
			y = 2390,
			y_normalized = 0,
			rendered_y = 2390,
			talent = "adamant_forceful",
			icon = "content/ui/textures/icons/talents/adamant/adamant_forceful",
			rendered_x = 1430,
			x_normalized = 0,
			children = {
				"node_011c39aa-3025-4c37-b8de-608a36813a25",
				"node_26aa2932-e1d8-4b3b-9a28-f6d71f977f56",
				"node_adef8607-f04c-4b80-84a9-70247ea03536",
				"node_f74129c0-c6ba-47d0-a058-315793b06763",
				"node_433d6dd9-c8c4-4f9b-8f0f-e86cc9e69c8a"
			},
			parents = {
				"node_f74129c0-c6ba-47d0-a058-315793b06763",
				"node_433d6dd9-c8c4-4f9b-8f0f-e86cc9e69c8a",
				"node_b4b7879c-20cc-40d3-ac4f-955b154a16e7"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "keystone_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_2d88b9f8-d7dc-402f-8c33-9d836f577ec6",
			type = "tactical",
			x = 890,
			y = 980,
			y_normalized = 0,
			rendered_y = 980,
			talent = "adamant_whistle",
			icon = "content/ui/textures/icons/talents/adamant/adamant_whistle_improved",
			rendered_x = 890,
			x_normalized = 0,
			children = {
				"node_1b027142-867d-492d-a12c-a31f83808c10",
				"node_2e0a468a-8d8b-4a41-9e29-f78d4bf96a90",
				"node_81f36e46-082d-4693-bc19-3bb557c2f818"
			},
			parents = {
				"node_dda8cd93-78f0-4e39-90cd-9b151ee8bc22",
				"node_0b81c83e-9fd8-40e1-845d-08574cbca744",
				"node_840a6834-a491-4e29-8e44-2f9ccb6e2f03",
				"node_9bb51d57-e584-40a7-98cf-313f7e557773",
				"node_2af481c5-1995-4a67-897d-3c755692d325",
				"node_dcf01775-39a4-4a2e-a1b7-f2f68ff24fba",
				"node_3fb66d94-8500-432f-86e2-4c4ea2a49095",
				"node_429b1166-55ac-4676-893b-5b56055fbca6",
				"node_6b1ed144-097b-4dd0-9fab-c56e5722ee5f",
				"node_a40126d6-c985-42b7-bffb-7234639e6704"
			},
			requirements = {
				min_points_spent = 0,
				all_parents_chosen = false,
				incompatible_talent = "adamant_disable_companion",
				children_unlock_points = 1,
				exclusive_group = "blitz_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_44cf93b1-fbc8-48a4-ba29-40c84aa6051f",
			type = "tactical",
			x = 1250,
			y = 980,
			y_normalized = 0,
			rendered_y = 980,
			talent = "adamant_grenade_improved",
			icon = "content/ui/textures/icons/talents/adamant/adamant_grenade",
			rendered_x = 1250,
			x_normalized = 0,
			children = {
				"node_1b027142-867d-492d-a12c-a31f83808c10",
				"node_0b4c5516-2cbb-479e-a82a-64e822112aba",
				"node_001a326c-f2a5-4b92-a514-fa5c1fe85c7d",
				"node_1611ea64-2ba9-4ce6-a41e-d074a5849db8",
				"node_bcbcf78f-94b1-40d3-860e-5481fc0fc1ab"
			},
			parents = {
				"node_dda8cd93-78f0-4e39-90cd-9b151ee8bc22",
				"node_0b81c83e-9fd8-40e1-845d-08574cbca744",
				"node_840a6834-a491-4e29-8e44-2f9ccb6e2f03",
				"node_9bb51d57-e584-40a7-98cf-313f7e557773",
				"node_2af481c5-1995-4a67-897d-3c755692d325",
				"node_dcf01775-39a4-4a2e-a1b7-f2f68ff24fba",
				"node_3fb66d94-8500-432f-86e2-4c4ea2a49095",
				"node_429b1166-55ac-4676-893b-5b56055fbca6",
				"node_6b1ed144-097b-4dd0-9fab-c56e5722ee5f",
				"node_030fde55-407f-4bb3-bd36-46d70fe56bbf"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "blitz_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_6857741a-5da7-40c1-871b-4b62f91a52ea",
			type = "aura",
			x = 1310,
			y = 1400,
			y_normalized = 0,
			rendered_y = 1400,
			talent = "adamant_damage_vs_staggered_aura",
			icon = "content/ui/textures/icons/talents/adamant/adamant_damage_vs_staggered_aura",
			rendered_x = 1310,
			x_normalized = 0,
			children = {
				"node_49bbfafc-233f-4a23-9a72-0412b4fcf719"
			},
			parents = {
				"node_edc914ed-dc63-47f0-b8e5-97a051892616",
				"node_5aaad316-c107-420b-9010-48668b673c58"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "aura_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_db2750a5-ac31-469f-8e7d-294b6c750b35",
			type = "ability",
			x = 1418.9999719431503,
			y = 1929.0000027192182,
			y_normalized = 0,
			rendered_y = 1929.0000027192182,
			talent = "adamant_charge",
			icon = "content/ui/textures/icons/talents/adamant/adamant_ability_charge",
			rendered_x = 1418.9999719431503,
			x_normalized = 0,
			children = {
				"node_b0947b3d-cb39-43c3-8922-1a9c48dfb8d8",
				"node_6f8fc4e4-c5cd-423f-b612-4eb26dc2dadb",
				"node_51aaefd1-2772-4d9e-b458-80c449db677e",
				"node_4bd3e71e-c621-4727-bedc-141b052cbee5"
			},
			parents = {
				"node_da43a66a-4f23-41fb-8257-6cf06d157433"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "ability_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_ccb98e10-453f-425b-8242-9d264faf7b25",
			type = "ability",
			x = 1059.0000167015905,
			y = 1868.9999788524103,
			y_normalized = 0,
			rendered_y = 1868.9999788524103,
			talent = "adamant_area_buff_drone_improved",
			icon = "content/ui/textures/icons/talents/adamant/adamant_ability_area_buff_drone",
			rendered_x = 1059.0000167015905,
			x_normalized = 0,
			children = {
				"node_0db1fa97-50eb-44b9-9c27-730da36404d1",
				"node_99a483b6-3ac6-42da-b2ab-b0d3dcc062e9",
				"node_51aaefd1-2772-4d9e-b458-80c449db677e"
			},
			parents = {
				"node_4cb10022-552a-4499-84e1-b956aa007511",
				"node_da43a66a-4f23-41fb-8257-6cf06d157433"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "ability_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_f1a66593-132e-4464-9c20-c7a7cf79a4b0",
			type = "ability",
			x = 698.9999719431503,
			y = 1929.0000027192182,
			y_normalized = 0,
			rendered_y = 1929.0000027192182,
			talent = "adamant_stance",
			icon = "content/ui/textures/icons/talents/adamant/adamant_ability_stance",
			rendered_x = 698.9999719431503,
			x_normalized = 0,
			children = {
				"node_7de43e6e-167c-4e17-9975-e23e5ef390ec",
				"node_bdab99db-3a50-4368-a9d7-7dc613f86f2d",
				"node_51aaefd1-2772-4d9e-b458-80c449db677e"
			},
			parents = {
				"node_4cb10022-552a-4499-84e1-b956aa007511"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "ability_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_ff1dbe2a-92b6-46f8-9c71-dc777431a537",
			type = "tactical",
			x = 1070,
			y = 980,
			y_normalized = 0,
			rendered_y = 980,
			talent = "adamant_shock_mine",
			icon = "content/ui/textures/icons/talents/adamant/adamant_shock_mine",
			rendered_x = 1070,
			x_normalized = 0,
			children = {
				"node_1b027142-867d-492d-a12c-a31f83808c10",
				"node_1a58fa51-a282-4ba9-b700-031cd1c9ef58",
				"node_884e841b-bc3d-4a45-bb74-16a1fe3b5504"
			},
			parents = {
				"node_6b1ed144-097b-4dd0-9fab-c56e5722ee5f"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "blitz_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_3684f20d-bb13-4f40-ba64-43d402eea435",
			type = "default",
			x = 905,
			y = 755,
			y_normalized = 0,
			rendered_y = 755,
			talent = "adamant_toughness_regen_near_companion",
			icon = "content/ui/textures/icons/talents/adamant/adamant_toughness_regen_near_companion",
			rendered_x = 905,
			x_normalized = 0,
			children = {
				"node_6b1ed144-097b-4dd0-9fab-c56e5722ee5f",
				"node_a40126d6-c985-42b7-bffb-7234639e6704"
			},
			parents = {
				"node_f3713ddf-8e7b-443e-97a6-b997188f6096",
				"node_3541dea3-3eba-4635-a80b-9dd635c02298",
				"node_efb7ef59-9432-462f-b551-91a5e93f0789"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				incompatible_talent = "adamant_disable_companion"
			}
		},
		{
			max_points = 1,
			widget_name = "node_0ebf45d0-b4da-42ea-8735-1d9c31ac2a9f",
			type = "default",
			x = 1085,
			y = 515,
			y_normalized = 0,
			rendered_y = 515,
			talent = "adamant_damage_after_reloading",
			icon = "content/ui/textures/icons/talents/adamant/adamant_damage_after_reloading",
			rendered_x = 1085,
			x_normalized = 0,
			children = {
				"node_efb7ef59-9432-462f-b551-91a5e93f0789"
			},
			parents = {
				"node_43567fd7-f7c3-4b73-9cb5-3fb72af27a23"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_577dcd33-0991-437a-ac3f-93d5cf1eda97",
			type = "default",
			x = 1265,
			y = 515,
			y_normalized = 0,
			rendered_y = 515,
			talent = "adamant_multiple_hits_attack_speed",
			icon = "content/ui/textures/icons/talents/adamant/adamant_multiple_hits_attack_speed",
			rendered_x = 1265,
			x_normalized = 0,
			children = {
				"node_0986767e-393b-4625-af18-8f085a9a8557",
				"node_3910099b-f9f7-472c-bbaa-f66e23e67962",
				"node_ff7e488d-67b2-4139-a794-6032177b6d56",
				"node_efb7ef59-9432-462f-b551-91a5e93f0789"
			},
			parents = {
				"node_43567fd7-f7c3-4b73-9cb5-3fb72af27a23"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_3541dea3-3eba-4635-a80b-9dd635c02298",
			type = "default",
			x = 905,
			y = 635,
			y_normalized = 0,
			rendered_y = 635,
			talent = "adamant_elite_special_kills_replenish_toughness",
			icon = "content/ui/textures/icons/talents/adamant/adamant_elite_special_kills_replenish_toughness",
			rendered_x = 905,
			x_normalized = 0,
			children = {
				"node_3684f20d-bb13-4f40-ba64-43d402eea435",
				"node_efb7ef59-9432-462f-b551-91a5e93f0789",
				"node_f3713ddf-8e7b-443e-97a6-b997188f6096"
			},
			parents = {
				"node_a9e22eac-7d0d-4567-ae6c-e7be34534eaa",
				"node_f3713ddf-8e7b-443e-97a6-b997188f6096",
				"node_efb7ef59-9432-462f-b551-91a5e93f0789"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_efb7ef59-9432-462f-b551-91a5e93f0789",
			type = "default",
			x = 1085,
			y = 635,
			y_normalized = 0,
			rendered_y = 635,
			talent = "adamant_close_kills_restore_toughness",
			icon = "content/ui/textures/icons/talents/adamant/adamant_close_kills_restore_toughness",
			rendered_x = 1085,
			x_normalized = 0,
			children = {
				"node_0986767e-393b-4625-af18-8f085a9a8557",
				"node_89e56162-d28d-49d5-a01a-ca818154041f",
				"node_ff7e488d-67b2-4139-a794-6032177b6d56",
				"node_3541dea3-3eba-4635-a80b-9dd635c02298",
				"node_3684f20d-bb13-4f40-ba64-43d402eea435",
				"node_2c04a28e-bcad-4554-b738-37f89f37eee2"
			},
			parents = {
				"node_0986767e-393b-4625-af18-8f085a9a8557",
				"node_0ebf45d0-b4da-42ea-8735-1d9c31ac2a9f",
				"node_3541dea3-3eba-4635-a80b-9dd635c02298",
				"node_ff7e488d-67b2-4139-a794-6032177b6d56",
				"node_a9e22eac-7d0d-4567-ae6c-e7be34534eaa",
				"node_577dcd33-0991-437a-ac3f-93d5cf1eda97"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_ff7e488d-67b2-4139-a794-6032177b6d56",
			type = "default",
			x = 1265,
			y = 635,
			y_normalized = 0,
			rendered_y = 635,
			talent = "adamant_staggers_replenish_toughness",
			icon = "content/ui/textures/icons/talents/adamant/adamant_staggers_replenish_toughness",
			rendered_x = 1265,
			x_normalized = 0,
			children = {
				"node_2c04a28e-bcad-4554-b738-37f89f37eee2",
				"node_3910099b-f9f7-472c-bbaa-f66e23e67962",
				"node_efb7ef59-9432-462f-b551-91a5e93f0789"
			},
			parents = {
				"node_577dcd33-0991-437a-ac3f-93d5cf1eda97",
				"node_efb7ef59-9432-462f-b551-91a5e93f0789",
				"node_3910099b-f9f7-472c-bbaa-f66e23e67962"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_4c33cf5f-8516-4c2d-bc50-7afd037eb239",
			type = "default",
			x = 845,
			y = 1235,
			y_normalized = 0,
			rendered_y = 1235,
			talent = "adamant_dog_attacks_electrocute",
			icon = "content/ui/textures/icons/talents/adamant/adamant_dog_attacks_electrocute",
			rendered_x = 845,
			x_normalized = 0,
			children = {
				"node_4137c1d3-f155-4dbb-ae2f-01eeae998353",
				"node_b4efa6cf-bc1d-4616-9518-4b9fc363dcf8"
			},
			parents = {
				"node_1b027142-867d-492d-a12c-a31f83808c10"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				incompatible_talent = "adamant_disable_companion"
			}
		},
		{
			max_points = 1,
			widget_name = "node_89e56162-d28d-49d5-a01a-ca818154041f",
			type = "default",
			x = 1085,
			y = 755,
			y_normalized = 0,
			rendered_y = 755,
			talent = "adamant_stamina_spent_replenish_toughness",
			icon = "content/ui/textures/icons/talents/adamant/adamant_stamina_regens_toughness",
			rendered_x = 1085,
			x_normalized = 0,
			children = {
				"node_6b1ed144-097b-4dd0-9fab-c56e5722ee5f"
			},
			parents = {
				"node_efb7ef59-9432-462f-b551-91a5e93f0789"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_433d6dd9-c8c4-4f9b-8f0f-e86cc9e69c8a",
			type = "default",
			x = 1565,
			y = 2405,
			y_normalized = 0,
			rendered_y = 2405,
			talent = "adamant_limit_dmg_taken_from_hits",
			icon = "content/ui/textures/icons/talents/adamant/adamant_limit_dmg_taken_from_hits",
			rendered_x = 1565,
			x_normalized = 0,
			children = {
				"node_23717e1a-a7ea-44f6-b168-9bd668cd29a3"
			},
			parents = {
				"node_44740858-05d7-46c6-a2f0-a51c3aadadaf",
				"node_b4b7879c-20cc-40d3-ac4f-955b154a16e7",
				"node_23717e1a-a7ea-44f6-b168-9bd668cd29a3"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_6b1ed144-097b-4dd0-9fab-c56e5722ee5f",
			type = "stat",
			x = 1084,
			y = 874,
			y_normalized = 0,
			rendered_y = 874,
			talent = "base_toughness_damage_reduction_node_buff_medium_1",
			rendered_x = 1084,
			x_normalized = 0,
			children = {
				"node_2d88b9f8-d7dc-402f-8c33-9d836f577ec6",
				"node_ff1dbe2a-92b6-46f8-9c71-dc777431a537",
				"node_44cf93b1-fbc8-48a4-ba29-40c84aa6051f",
				"node_a40126d6-c985-42b7-bffb-7234639e6704",
				"node_030fde55-407f-4bb3-bd36-46d70fe56bbf"
			},
			parents = {
				"node_3684f20d-bb13-4f40-ba64-43d402eea435",
				"node_89e56162-d28d-49d5-a01a-ca818154041f",
				"node_2c04a28e-bcad-4554-b738-37f89f37eee2",
				"node_030fde55-407f-4bb3-bd36-46d70fe56bbf",
				"node_a40126d6-c985-42b7-bffb-7234639e6704"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_1b027142-867d-492d-a12c-a31f83808c10",
			type = "default",
			x = 1085,
			y = 1115,
			y_normalized = 0,
			rendered_y = 1115,
			talent = "adamant_armor",
			icon = "content/ui/textures/icons/talents/adamant/adamant_armor",
			rendered_x = 1085,
			x_normalized = 0,
			children = {
				"node_4c33cf5f-8516-4c2d-bc50-7afd037eb239",
				"node_8cd80a54-2e4c-435c-9cdd-2ff7e4715505",
				"node_46db21b8-af36-49bf-a4b3-8a79d303edb2"
			},
			parents = {
				"node_ff1dbe2a-92b6-46f8-9c71-dc777431a537",
				"node_2d88b9f8-d7dc-402f-8c33-9d836f577ec6",
				"node_44cf93b1-fbc8-48a4-ba29-40c84aa6051f"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_8cd80a54-2e4c-435c-9cdd-2ff7e4715505",
			type = "default",
			x = 1085,
			y = 1235,
			y_normalized = 0,
			rendered_y = 1235,
			talent = "adamant_ammo_belt",
			icon = "content/ui/textures/icons/talents/adamant/adamant_ammo_belt",
			rendered_x = 1085,
			x_normalized = 0,
			children = {
				"node_00091489-4546-42b8-8591-9eb519ade295",
				"node_b4efa6cf-bc1d-4616-9518-4b9fc363dcf8",
				"node_5aaad316-c107-420b-9010-48668b673c58"
			},
			parents = {
				"node_1b027142-867d-492d-a12c-a31f83808c10"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_39b2491a-29f2-428c-9dc5-14d41204a76d",
			type = "default",
			x = 965,
			y = 2165,
			y_normalized = 0,
			rendered_y = 2165,
			talent = "adamant_rebreather",
			icon = "content/ui/textures/icons/talents/adamant/adamant_rebreather",
			rendered_x = 965,
			x_normalized = 0,
			children = {
				"node_00091489-4546-42b8-8591-9eb519ade295",
				"node_5d52392f-6daa-479c-9104-67a901e69a32"
			},
			parents = {
				"node_51aaefd1-2772-4d9e-b458-80c449db677e"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_edc914ed-dc63-47f0-b8e5-97a051892616",
			type = "default",
			x = 1445,
			y = 1325,
			y_normalized = 0,
			rendered_y = 1325,
			talent = "adamant_hitting_multiple_gives_tdr",
			icon = "content/ui/textures/icons/talents/adamant/adamant_hitting_multiple_gives_tdr",
			rendered_x = 1445,
			x_normalized = 0,
			children = {
				"node_00091489-4546-42b8-8591-9eb519ade295",
				"node_6857741a-5da7-40c1-871b-4b62f91a52ea"
			},
			parents = {
				"node_46db21b8-af36-49bf-a4b3-8a79d303edb2"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_a40126d6-c985-42b7-bffb-7234639e6704",
			type = "stat",
			x = 904,
			y = 874,
			y_normalized = 0,
			rendered_y = 874,
			talent = "base_ranged_damage_node_buff_medium_1",
			rendered_x = 904,
			x_normalized = 0,
			children = {
				"node_2d88b9f8-d7dc-402f-8c33-9d836f577ec6",
				"node_6b1ed144-097b-4dd0-9fab-c56e5722ee5f"
			},
			parents = {
				"node_3684f20d-bb13-4f40-ba64-43d402eea435",
				"node_6b1ed144-097b-4dd0-9fab-c56e5722ee5f"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_030fde55-407f-4bb3-bd36-46d70fe56bbf",
			type = "stat",
			x = 1264,
			y = 874,
			y_normalized = 0,
			rendered_y = 874,
			talent = "base_melee_damage_node_buff_medium_1",
			rendered_x = 1264,
			x_normalized = 0,
			children = {
				"node_44cf93b1-fbc8-48a4-ba29-40c84aa6051f",
				"node_6b1ed144-097b-4dd0-9fab-c56e5722ee5f"
			},
			parents = {
				"node_2c04a28e-bcad-4554-b738-37f89f37eee2",
				"node_6b1ed144-097b-4dd0-9fab-c56e5722ee5f"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_75d31c92-2869-4bbb-8f63-f0f7b9e15bdf",
			type = "keystone",
			x = 1070.0000167015905,
			y = 1670.0000093699884,
			y_normalized = 0,
			rendered_y = 1670.0000093699884,
			talent = "adamant_disable_companion",
			icon = "content/ui/textures/icons/talents/adamant/adamant_disable_companion",
			rendered_x = 1070.0000167015905,
			x_normalized = 0,
			children = {
				"node_da43a66a-4f23-41fb-8257-6cf06d157433",
				"node_4cb10022-552a-4499-84e1-b956aa007511"
			},
			parents = {
				"node_49bbfafc-233f-4a23-9a72-0412b4fcf719"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_26aa2932-e1d8-4b3b-9a28-f6d71f977f56",
			type = "keystone_modifier",
			x = 1445,
			y = 2525,
			y_normalized = 0,
			rendered_y = 2525,
			talent = "adamant_forceful_toughness_regen_per_stack",
			icon = "content/ui/textures/icons/talents/adamant/adamant_forceful_toughness_regen",
			rendered_x = 1445,
			x_normalized = 0,
			children = {
				"node_284a6993-4069-480f-be4b-ad6bb34c6739",
				"node_deba29d6-030f-474a-9992-b6c75ee570bf"
			},
			parents = {
				"node_23717e1a-a7ea-44f6-b168-9bd668cd29a3"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_011c39aa-3025-4c37-b8de-608a36813a25",
			type = "keystone_modifier",
			x = 1325,
			y = 2525,
			y_normalized = 0,
			rendered_y = 2525,
			talent = "adamant_forceful_stun_immune_and_block_all",
			icon = "content/ui/textures/icons/talents/adamant/adamant_forceful_melee",
			rendered_x = 1325,
			x_normalized = 0,
			children = {
				"node_284a6993-4069-480f-be4b-ad6bb34c6739"
			},
			parents = {
				"node_23717e1a-a7ea-44f6-b168-9bd668cd29a3"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_adef8607-f04c-4b80-84a9-70247ea03536",
			type = "keystone_modifier",
			x = 1565,
			y = 2525,
			y_normalized = 0,
			rendered_y = 2525,
			talent = "adamant_forceful_offensive",
			icon = "content/ui/textures/icons/talents/adamant/adamant_forceful_ranged",
			rendered_x = 1565,
			x_normalized = 0,
			children = {
				"node_deba29d6-030f-474a-9992-b6c75ee570bf"
			},
			parents = {
				"node_23717e1a-a7ea-44f6-b168-9bd668cd29a3"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_284a6993-4069-480f-be4b-ad6bb34c6739",
			type = "keystone_modifier",
			x = 1385,
			y = 2645,
			y_normalized = 0,
			rendered_y = 2645,
			talent = "adamant_forceful_ability_damage",
			icon = "content/ui/textures/icons/talents/adamant/adamant_forceful_refresh_on_ability",
			rendered_x = 1385,
			x_normalized = 0,
			children = {},
			parents = {
				"node_26aa2932-e1d8-4b3b-9a28-f6d71f977f56",
				"node_011c39aa-3025-4c37-b8de-608a36813a25"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_deba29d6-030f-474a-9992-b6c75ee570bf",
			type = "keystone_modifier",
			x = 1505,
			y = 2645,
			y_normalized = 0,
			rendered_y = 2645,
			talent = "adamant_forceful_stagger_on_low_high",
			icon = "content/ui/textures/icons/talents/adamant/adamant_forceful_companion",
			rendered_x = 1505,
			x_normalized = 0,
			children = {},
			parents = {
				"node_adef8607-f04c-4b80-84a9-70247ea03536",
				"node_26aa2932-e1d8-4b3b-9a28-f6d71f977f56"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_f3713ddf-8e7b-443e-97a6-b997188f6096",
			type = "default",
			x = 725,
			y = 635,
			y_normalized = 0,
			rendered_y = 635,
			talent = "adamant_dog_pounces_bleed_nearby",
			icon = "content/ui/textures/icons/talents/adamant/adamant_dog_pounces_bleed_nearby",
			rendered_x = 725,
			x_normalized = 0,
			children = {
				"node_3684f20d-bb13-4f40-ba64-43d402eea435",
				"node_3541dea3-3eba-4635-a80b-9dd635c02298"
			},
			parents = {
				"node_00091489-4546-42b8-8591-9eb519ade295",
				"node_a9e22eac-7d0d-4567-ae6c-e7be34534eaa",
				"node_3541dea3-3eba-4635-a80b-9dd635c02298"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				incompatible_talent = "adamant_disable_companion"
			}
		},
		{
			max_points = 1,
			widget_name = "node_b4efa6cf-bc1d-4616-9518-4b9fc363dcf8",
			type = "default",
			x = 965,
			y = 1325,
			y_normalized = 0,
			rendered_y = 1325,
			talent = "adamant_damage_reduction_after_elite_kill",
			icon = "content/ui/textures/icons/talents/adamant/adamant_damage_reduction_after_elite_kill",
			rendered_x = 965,
			x_normalized = 0,
			children = {
				"node_d11bcab3-f47e-43ef-8f26-72e4ed2760fe",
				"node_d9c8ac91-9f39-43f5-9655-c836de0bb997"
			},
			parents = {
				"node_00091489-4546-42b8-8591-9eb519ade295",
				"node_8cd80a54-2e4c-435c-9cdd-2ff7e4715505",
				"node_4c33cf5f-8516-4c2d-bc50-7afd037eb239"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_4bd3e71e-c621-4727-bedc-141b052cbee5",
			type = "default",
			x = 1445,
			y = 2105,
			y_normalized = 0,
			rendered_y = 2105,
			talent = "adamant_staggers_reduce_damage_taken",
			icon = "content/ui/textures/icons/talents/adamant/adamant_staggers_reduce_damage_taken",
			rendered_x = 1445,
			x_normalized = 0,
			children = {
				"node_b4b7879c-20cc-40d3-ac4f-955b154a16e7",
				"node_bf589f32-33d7-48d4-ae96-2ab3d6a63ee3",
				"node_52362bbc-c8ce-4652-886a-b4039d370d38",
				"node_51aaefd1-2772-4d9e-b458-80c449db677e"
			},
			parents = {
				"node_00091489-4546-42b8-8591-9eb519ade295",
				"node_51aaefd1-2772-4d9e-b458-80c449db677e",
				"node_db2750a5-ac31-469f-8e7d-294b6c750b35"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_4cb10022-552a-4499-84e1-b956aa007511",
			type = "stat",
			x = 934.0000167015907,
			y = 1773.9999788524103,
			y_normalized = 0,
			rendered_y = 1773.9999788524103,
			talent = "base_cleave_node_buff_medium_1",
			rendered_x = 934.0000167015907,
			x_normalized = 0,
			children = {
				"node_f1a66593-132e-4464-9c20-c7a7cf79a4b0",
				"node_ccb98e10-453f-425b-8242-9d264faf7b25",
				"node_da43a66a-4f23-41fb-8257-6cf06d157433"
			},
			parents = {
				"node_da43a66a-4f23-41fb-8257-6cf06d157433",
				"node_49bbfafc-233f-4a23-9a72-0412b4fcf719",
				"node_75d31c92-2869-4bbb-8f63-f0f7b9e15bdf",
				"node_44f3d117-9099-42ab-9b11-8ff7a5ef1a66"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_da43a66a-4f23-41fb-8257-6cf06d157433",
			type = "stat",
			x = 1234.0000167015905,
			y = 1773.9999788524103,
			y_normalized = 0,
			rendered_y = 1773.9999788524103,
			talent = "base_impact_node_buff_medium_1",
			rendered_x = 1234.0000167015905,
			x_normalized = 0,
			children = {
				"node_ccb98e10-453f-425b-8242-9d264faf7b25",
				"node_db2750a5-ac31-469f-8e7d-294b6c750b35",
				"node_4cb10022-552a-4499-84e1-b956aa007511"
			},
			parents = {
				"node_4cb10022-552a-4499-84e1-b956aa007511",
				"node_49bbfafc-233f-4a23-9a72-0412b4fcf719",
				"node_75d31c92-2869-4bbb-8f63-f0f7b9e15bdf",
				"node_524d5b7c-7557-4a87-aa66-5ef726bdcf45"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_c7200201-5541-4b79-bb97-f866d4859bd7",
			type = "ability_modifier",
			x = 455.0000024607284,
			y = 1955.0000027192182,
			y_normalized = 0,
			rendered_y = 1955.0000027192182,
			talent = "adamant_stance_ranged_kills_transfer_ammo",
			icon = "content/ui/textures/icons/talents/adamant/adamant_weapon_handling",
			rendered_x = 455.0000024607284,
			x_normalized = 0,
			children = {},
			parents = {
				"node_7de43e6e-167c-4e17-9975-e23e5ef390ec"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_7de43e6e-167c-4e17-9975-e23e5ef390ec",
			type = "ability_modifier",
			x = 575.0000329783065,
			y = 1955.0000027192182,
			y_normalized = 0,
			rendered_y = 1955.0000027192182,
			talent = "adamant_stance_elite_kills_stack_damage",
			icon = "content/ui/textures/icons/talents/adamant/adamant_verispex",
			rendered_x = 575.0000329783065,
			x_normalized = 0,
			children = {
				"node_cbd2062a-c53b-47d8-a07c-3868aa343031",
				"node_c7200201-5541-4b79-bb97-f866d4859bd7"
			},
			parents = {
				"node_f1a66593-132e-4464-9c20-c7a7cf79a4b0"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_cbd2062a-c53b-47d8-a07c-3868aa343031",
			type = "ability_modifier",
			x = 515.0000329783065,
			y = 2045.0000027192182,
			y_normalized = 0,
			rendered_y = 2045.0000027192182,
			talent = "adamant_stance_dog_bloodlust",
			icon = "content/ui/textures/icons/talents/adamant/adamant_shout_dog",
			rendered_x = 515.0000329783065,
			x_normalized = 0,
			children = {},
			parents = {
				"node_7de43e6e-167c-4e17-9975-e23e5ef390ec"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				incompatible_talent = "adamant_disable_companion"
			}
		},
		{
			max_points = 1,
			widget_name = "node_0db1fa97-50eb-44b9-9c27-730da36404d1",
			type = "ability_modifier",
			x = 965.0000167015907,
			y = 1954.9999788524103,
			y_normalized = 0,
			rendered_y = 1954.9999788524103,
			talent = "adamant_drone_buff_talent",
			icon = "content/ui/textures/icons/talents/adamant/adamant_restore_toughness_to_allies_on_combat_ability",
			rendered_x = 965.0000167015907,
			x_normalized = 0,
			children = {},
			parents = {
				"node_ccb98e10-453f-425b-8242-9d264faf7b25"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_99a483b6-3ac6-42da-b2ab-b0d3dcc062e9",
			type = "ability_modifier",
			x = 1205.0000940134628,
			y = 1955.0000027192182,
			y_normalized = 0,
			rendered_y = 1955.0000027192182,
			talent = "adamant_drone_debuff_talent",
			icon = "content/ui/textures/icons/talents/adamant/adamant_companion_coherency_improved",
			rendered_x = 1205.0000940134628,
			x_normalized = 0,
			children = {},
			parents = {
				"node_ccb98e10-453f-425b-8242-9d264faf7b25"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_b0947b3d-cb39-43c3-8922-1a9c48dfb8d8",
			type = "ability_modifier",
			x = 1595.0000940134628,
			y = 1955.0000027192182,
			y_normalized = 0,
			rendered_y = 1955.0000027192182,
			talent = "adamant_charge_toughness",
			icon = "content/ui/textures/icons/talents/adamant/adamant_terminus_warrant_toughness",
			rendered_x = 1595.0000940134628,
			x_normalized = 0,
			children = {
				"node_20638e8f-5c78-481c-a210-ec3fcdcd60e3",
				"node_ed72b6e9-1213-4760-bd1c-28c0f93c1f55"
			},
			parents = {
				"node_db2750a5-ac31-469f-8e7d-294b6c750b35"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_ed72b6e9-1213-4760-bd1c-28c0f93c1f55",
			type = "ability_modifier",
			x = 1745.0000940134628,
			y = 1955.0000027192182,
			y_normalized = 0,
			rendered_y = 1955.0000027192182,
			talent = "adamant_charge_cooldown_reduction",
			icon = "content/ui/textures/icons/talents/adamant/adamant_pinning_dog_kills_cdr",
			rendered_x = 1745.0000940134628,
			x_normalized = 0,
			children = {},
			parents = {
				"node_b0947b3d-cb39-43c3-8922-1a9c48dfb8d8"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_20638e8f-5c78-481c-a210-ec3fcdcd60e3",
			type = "ability_modifier",
			x = 1685.0000940134628,
			y = 2045.0000027192182,
			y_normalized = 0,
			rendered_y = 2045.0000027192182,
			talent = "adamant_charge_longer_distance",
			icon = "content/ui/textures/icons/talents/adamant/adamant_ability_shout_improved",
			rendered_x = 1685.0000940134628,
			x_normalized = 0,
			children = {},
			parents = {
				"node_b0947b3d-cb39-43c3-8922-1a9c48dfb8d8"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_49bbfafc-233f-4a23-9a72-0412b4fcf719",
			type = "default",
			x = 1085.0000167015905,
			y = 1535.0000093699884,
			y_normalized = 0,
			rendered_y = 1535.0000093699884,
			talent = "adamant_plasteel_plates",
			icon = "content/ui/textures/icons/talents/adamant/adamant_plasteel_plates",
			rendered_x = 1085.0000167015905,
			x_normalized = 0,
			children = {
				"node_4cb10022-552a-4499-84e1-b956aa007511",
				"node_da43a66a-4f23-41fb-8257-6cf06d157433",
				"node_524d5b7c-7557-4a87-aa66-5ef726bdcf45",
				"node_75d31c92-2869-4bbb-8f63-f0f7b9e15bdf",
				"node_44f3d117-9099-42ab-9b11-8ff7a5ef1a66"
			},
			parents = {
				"node_d11bcab3-f47e-43ef-8f26-72e4ed2760fe",
				"node_d9c8ac91-9f39-43f5-9655-c836de0bb997",
				"node_6857741a-5da7-40c1-871b-4b62f91a52ea"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_e992d16b-4372-4874-93ca-7a520cceb74c",
			type = "default",
			x = 605,
			y = 2405,
			y_normalized = 0,
			rendered_y = 2405,
			talent = "adamant_dog_applies_brittleness",
			icon = "content/ui/textures/icons/talents/adamant/adamant_whistle",
			rendered_x = 605,
			x_normalized = 0,
			children = {
				"node_52c3f35e-7fe4-4321-a04c-2a51eccac74c"
			},
			parents = {
				"node_021a58e4-4b06-40cb-b978-3823adbd5a15",
				"node_62deceb2-66cd-4494-b96d-27b9fcc8732b"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				incompatible_talent = "adamant_disable_companion"
			}
		},
		{
			max_points = 1,
			widget_name = "node_bdab99db-3a50-4368-a9d7-7dc613f86f2d",
			type = "default",
			x = 725.0000304482837,
			y = 2105.000007851389,
			y_normalized = 0,
			rendered_y = 2105.000007851389,
			talent = "adamant_dodge_grants_damage",
			icon = "content/ui/textures/icons/talents/adamant/adamant_dodge_grants_damage",
			rendered_x = 725.0000304482837,
			x_normalized = 0,
			children = {
				"node_62deceb2-66cd-4494-b96d-27b9fcc8732b",
				"node_4e45edbc-7e9a-43b8-9078-8d8146ca4177",
				"node_9b76913c-5597-404c-ae20-7f3e16ec9273",
				"node_51aaefd1-2772-4d9e-b458-80c449db677e"
			},
			parents = {
				"node_51aaefd1-2772-4d9e-b458-80c449db677e",
				"node_f1a66593-132e-4464-9c20-c7a7cf79a4b0"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_e8d152e8-495b-4da1-86e8-4c78bd1dd63b",
			type = "default",
			x = 845,
			y = 2285,
			y_normalized = 0,
			rendered_y = 2285,
			talent = "adamant_stacking_weakspot_strength",
			icon = "content/ui/textures/icons/talents/adamant/adamant_stacking_weakspot_strength",
			rendered_x = 845,
			x_normalized = 0,
			children = {
				"node_939b77d7-9bd1-48a9-8ae6-66beae3686ec"
			},
			parents = {
				"node_4e45edbc-7e9a-43b8-9078-8d8146ca4177",
				"node_62deceb2-66cd-4494-b96d-27b9fcc8732b"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_9b76913c-5597-404c-ae20-7f3e16ec9273",
			type = "default",
			x = 605,
			y = 2165,
			y_normalized = 0,
			rendered_y = 2165,
			talent = "adamant_elite_special_kills_reload_speed",
			icon = "content/ui/textures/icons/talents/adamant/adamant_elite_special_kills_reload_speed",
			rendered_x = 605,
			x_normalized = 0,
			children = {
				"node_021a58e4-4b06-40cb-b978-3823adbd5a15"
			},
			parents = {
				"node_bdab99db-3a50-4368-a9d7-7dc613f86f2d"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_b93d4978-d0c5-4257-8725-9a1b20596f93",
			type = "default",
			x = 965,
			y = 2405,
			y_normalized = 0,
			rendered_y = 2405,
			talent = "adamant_movement_speed_on_block",
			icon = "content/ui/textures/icons/talents/adamant/adamant_movement_speed_on_block",
			rendered_x = 965,
			x_normalized = 0,
			children = {
				"node_65d7f26b-711e-4ef9-ae0e-5bad2ac7a818"
			},
			parents = {
				"node_eea35a28-d324-4f45-b682-edadc7d4c5ef",
				"node_5d52392f-6daa-479c-9104-67a901e69a32"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_a9e22eac-7d0d-4567-ae6c-e7be34534eaa",
			type = "default",
			x = 905,
			y = 515,
			y_normalized = 0,
			rendered_y = 515,
			talent = "adamant_elite_special_kills_offensive_boost",
			icon = "content/ui/textures/icons/talents/adamant/adamant_elite_special_kills_offensive_boost",
			rendered_x = 905,
			x_normalized = 0,
			children = {
				"node_f3713ddf-8e7b-443e-97a6-b997188f6096",
				"node_3541dea3-3eba-4635-a80b-9dd635c02298",
				"node_efb7ef59-9432-462f-b551-91a5e93f0789"
			},
			parents = {
				"node_43567fd7-f7c3-4b73-9cb5-3fb72af27a23"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_b4b7879c-20cc-40d3-ac4f-955b154a16e7",
			type = "default",
			x = 1445,
			y = 2225,
			y_normalized = 0,
			rendered_y = 2225,
			talent = "adamant_cleave_after_push",
			icon = "content/ui/textures/icons/talents/adamant/adamant_cleave_after_push",
			rendered_x = 1445,
			x_normalized = 0,
			children = {
				"node_45a13e59-6a31-4c9f-89ac-fd66d37b137e",
				"node_f74129c0-c6ba-47d0-a058-315793b06763",
				"node_44740858-05d7-46c6-a2f0-a51c3aadadaf",
				"node_433d6dd9-c8c4-4f9b-8f0f-e86cc9e69c8a",
				"node_8dfe9968-7413-4940-bd87-0a220eb821e7",
				"node_23717e1a-a7ea-44f6-b168-9bd668cd29a3"
			},
			parents = {
				"node_4bd3e71e-c621-4727-bedc-141b052cbee5"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_2c04a28e-bcad-4554-b738-37f89f37eee2",
			type = "default",
			x = 1265,
			y = 755,
			y_normalized = 0,
			rendered_y = 755,
			talent = "adamant_shield_plates",
			icon = "content/ui/textures/icons/talents/adamant/adamant_shield_plates",
			rendered_x = 1265,
			x_normalized = 0,
			children = {
				"node_6b1ed144-097b-4dd0-9fab-c56e5722ee5f",
				"node_030fde55-407f-4bb3-bd36-46d70fe56bbf"
			},
			parents = {
				"node_ff7e488d-67b2-4139-a794-6032177b6d56",
				"node_3910099b-f9f7-472c-bbaa-f66e23e67962",
				"node_efb7ef59-9432-462f-b551-91a5e93f0789"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_44740858-05d7-46c6-a2f0-a51c3aadadaf",
			type = "default",
			x = 1565,
			y = 2285,
			y_normalized = 0,
			rendered_y = 2285,
			talent = "adamant_heavy_attacks_increase_damage",
			icon = "content/ui/textures/icons/talents/adamant/adamant_heavy_attacks_increase_damage",
			rendered_x = 1565,
			x_normalized = 0,
			children = {
				"node_433d6dd9-c8c4-4f9b-8f0f-e86cc9e69c8a"
			},
			parents = {
				"node_b4b7879c-20cc-40d3-ac4f-955b154a16e7",
				"node_bf589f32-33d7-48d4-ae96-2ab3d6a63ee3"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_6f8fc4e4-c5cd-423f-b612-4eb26dc2dadb",
			type = "ability_modifier",
			x = 1534.9999719431503,
			y = 2045.0000027192182,
			y_normalized = 0,
			rendered_y = 2045.0000027192182,
			talent = "adamant_dog_damage_after_ability",
			icon = "content/ui/textures/icons/talents/adamant/adamant_dog_damage_after_ability",
			rendered_x = 1534.9999719431503,
			x_normalized = 0,
			children = {},
			parents = {
				"node_db2750a5-ac31-469f-8e7d-294b6c750b35"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				incompatible_talent = "adamant_disable_companion"
			}
		},
		{
			max_points = 1,
			widget_name = "node_f74129c0-c6ba-47d0-a058-315793b06763",
			type = "default",
			x = 1325,
			y = 2405,
			y_normalized = 0,
			rendered_y = 2405,
			talent = "adamant_melee_attacks_on_staggered_rend",
			icon = "content/ui/textures/icons/talents/adamant/adamant_melee_attacks_on_staggered_rend",
			rendered_x = 1325,
			x_normalized = 0,
			children = {
				"node_23717e1a-a7ea-44f6-b168-9bd668cd29a3"
			},
			parents = {
				"node_45a13e59-6a31-4c9f-89ac-fd66d37b137e",
				"node_b4b7879c-20cc-40d3-ac4f-955b154a16e7",
				"node_8dfe9968-7413-4940-bd87-0a220eb821e7",
				"node_23717e1a-a7ea-44f6-b168-9bd668cd29a3"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_b6adf64e-bc34-455a-a059-552c4fb0f8a0",
			type = "keystone_modifier",
			x = 965,
			y = 2525,
			y_normalized = 0,
			rendered_y = 2525,
			talent = "adamant_terminus_warrant_ranged",
			icon = "content/ui/textures/icons/talents/adamant/adamant_terminus_warrant_ranged",
			rendered_x = 965,
			x_normalized = 0,
			children = {
				"node_69edc205-aa8c-4b72-9b46-8b855516f2c0"
			},
			parents = {
				"node_65d7f26b-711e-4ef9-ae0e-5bad2ac7a818"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_446b745a-e92e-4e31-8cc0-0ee5327f5674",
			type = "keystone_modifier",
			x = 1205,
			y = 2525,
			y_normalized = 0,
			rendered_y = 2525,
			talent = "adamant_terminus_warrant_melee",
			icon = "content/ui/textures/icons/talents/adamant/adamant_terminus_warrant_melee",
			rendered_x = 1205,
			x_normalized = 0,
			children = {
				"node_69edc205-aa8c-4b72-9b46-8b855516f2c0"
			},
			parents = {
				"node_65d7f26b-711e-4ef9-ae0e-5bad2ac7a818"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_40edc5b7-fae7-4043-9cfd-7ec06b1b59cb",
			type = "keystone_modifier",
			x = 1085,
			y = 2645,
			y_normalized = 0,
			rendered_y = 2645,
			talent = "adamant_terminus_warrant_improved",
			icon = "content/ui/textures/icons/talents/adamant/adamant_terminus_warrant_fire_rate",
			rendered_x = 1085,
			x_normalized = 0,
			children = {},
			parents = {
				"node_9a64c5d0-9d4b-479f-90d2-4c48d8523a70",
				"node_9964320a-cf72-40d7-ad57-d4e5bc4a7345"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_e686dc62-a877-4eef-8a96-52743b1c0fcd",
			type = "keystone_modifier",
			x = 605,
			y = 2525,
			y_normalized = 0,
			rendered_y = 2525,
			talent = "adamant_execution_order_crit",
			icon = "content/ui/textures/icons/talents/adamant/adamant_exterminator_stamina_ammo",
			rendered_x = 605,
			x_normalized = 0,
			children = {
				"node_d6d7d5c6-b681-41e1-b6c1-05e35ebb9715"
			},
			parents = {
				"node_52c3f35e-7fe4-4321-a04c-2a51eccac74c"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_dbdb2b08-b8ce-4dc5-88c9-139f0486b54c",
			type = "keystone_modifier",
			x = 725,
			y = 2525,
			y_normalized = 0,
			rendered_y = 2525,
			talent = "adamant_execution_order_cdr",
			icon = "content/ui/textures/icons/talents/adamant/adamant_exterminator_ability_cooldown",
			rendered_x = 725,
			x_normalized = 0,
			children = {
				"node_d6d7d5c6-b681-41e1-b6c1-05e35ebb9715",
				"node_8cd57c7e-dccf-4dd5-9829-c953101e1d34"
			},
			parents = {
				"node_52c3f35e-7fe4-4321-a04c-2a51eccac74c"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_8abdbb78-a06d-4d97-959a-a46930ab0752",
			type = "keystone_modifier",
			x = 845,
			y = 2525,
			y_normalized = 0,
			rendered_y = 2525,
			talent = "adamant_execution_order_rending",
			icon = "content/ui/textures/icons/talents/adamant/adamant_exterminator_stack_during_activation",
			rendered_x = 845,
			x_normalized = 0,
			children = {
				"node_8cd57c7e-dccf-4dd5-9829-c953101e1d34"
			},
			parents = {
				"node_52c3f35e-7fe4-4321-a04c-2a51eccac74c"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_d6d7d5c6-b681-41e1-b6c1-05e35ebb9715",
			type = "keystone_modifier",
			x = 665,
			y = 2645,
			y_normalized = 0,
			rendered_y = 2645,
			talent = "adamant_execution_order_permastack",
			icon = "content/ui/textures/icons/talents/adamant/adamant_exterminator_boss_damage",
			rendered_x = 665,
			x_normalized = 0,
			children = {},
			parents = {
				"node_dbdb2b08-b8ce-4dc5-88c9-139f0486b54c",
				"node_e686dc62-a877-4eef-8a96-52743b1c0fcd"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_8cd57c7e-dccf-4dd5-9829-c953101e1d34",
			type = "keystone_modifier",
			x = 785,
			y = 2645,
			y_normalized = 0,
			rendered_y = 2645,
			talent = "adamant_pinning_dog_bonus_moving_towards",
			icon = "content/ui/textures/icons/talents/adamant/adamant_pinning_dog_bonus_moving_towards",
			rendered_x = 785,
			x_normalized = 0,
			children = {},
			parents = {
				"node_dbdb2b08-b8ce-4dc5-88c9-139f0486b54c",
				"node_8abdbb78-a06d-4d97-959a-a46930ab0752"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_62deceb2-66cd-4494-b96d-27b9fcc8732b",
			type = "default",
			x = 725,
			y = 2225,
			y_normalized = 0,
			rendered_y = 2225,
			talent = "adamant_crit_chance_on_kill",
			icon = "content/ui/textures/icons/talents/adamant/adamant_crit_chance_on_kill",
			rendered_x = 725,
			x_normalized = 0,
			children = {
				"node_939b77d7-9bd1-48a9-8ae6-66beae3686ec",
				"node_021a58e4-4b06-40cb-b978-3823adbd5a15",
				"node_e8d152e8-495b-4da1-86e8-4c78bd1dd63b",
				"node_52c3f35e-7fe4-4321-a04c-2a51eccac74c",
				"node_e992d16b-4372-4874-93ca-7a520cceb74c"
			},
			parents = {
				"node_bdab99db-3a50-4368-a9d7-7dc613f86f2d"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_939b77d7-9bd1-48a9-8ae6-66beae3686ec",
			type = "default",
			x = 845,
			y = 2405,
			y_normalized = 0,
			rendered_y = 2405,
			talent = "adamant_crits_rend",
			icon = "content/ui/textures/icons/talents/adamant/adamant_crits_rend",
			rendered_x = 845,
			x_normalized = 0,
			children = {
				"node_52c3f35e-7fe4-4321-a04c-2a51eccac74c"
			},
			parents = {
				"node_62deceb2-66cd-4494-b96d-27b9fcc8732b",
				"node_e8d152e8-495b-4da1-86e8-4c78bd1dd63b",
				"node_52c3f35e-7fe4-4321-a04c-2a51eccac74c"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_524d5b7c-7557-4a87-aa66-5ef726bdcf45",
			type = "keystone",
			x = 1250,
			y = 1640,
			y_normalized = 0,
			rendered_y = 1640,
			talent = "adamant_companion_focus_ranged",
			icon = "content/ui/textures/icons/talents/adamant/adamant_dog_focus_ranged",
			rendered_x = 1250,
			x_normalized = 0,
			children = {
				"node_da43a66a-4f23-41fb-8257-6cf06d157433"
			},
			parents = {
				"node_49bbfafc-233f-4a23-9a72-0412b4fcf719"
			},
			requirements = {
				min_points_spent = 0,
				all_parents_chosen = false,
				incompatible_talent = "adamant_disable_companion",
				children_unlock_points = 1,
				exclusive_group = "dog_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_44f3d117-9099-42ab-9b11-8ff7a5ef1a66",
			type = "keystone",
			x = 890,
			y = 1640,
			y_normalized = 0,
			rendered_y = 1640,
			talent = "adamant_companion_focus_elite",
			icon = "content/ui/textures/icons/talents/adamant/adamant_dog_focus_elites",
			rendered_x = 890,
			x_normalized = 0,
			children = {
				"node_4cb10022-552a-4499-84e1-b956aa007511"
			},
			parents = {
				"node_49bbfafc-233f-4a23-9a72-0412b4fcf719"
			},
			requirements = {
				min_points_spent = 0,
				all_parents_chosen = false,
				incompatible_talent = "adamant_disable_companion",
				children_unlock_points = 1,
				exclusive_group = "dog_1"
			}
		},
		{
			max_points = 1,
			widget_name = "node_eea35a28-d324-4f45-b682-edadc7d4c5ef",
			type = "default",
			x = 1085,
			y = 2225,
			y_normalized = 0,
			rendered_y = 2225,
			talent = "adamant_dodge_improvement",
			icon = "content/ui/textures/icons/talents/adamant/adamant_suppression_immunity",
			rendered_x = 1085,
			x_normalized = 0,
			children = {
				"node_b93d4978-d0c5-4257-8725-9a1b20596f93",
				"node_48e362cb-c6b4-4d38-a325-08667444b783",
				"node_65d7f26b-711e-4ef9-ae0e-5bad2ac7a818",
				"node_5d52392f-6daa-479c-9104-67a901e69a32",
				"node_2eb48f41-2b1a-42ae-9f0c-e5c6210c9949"
			},
			parents = {
				"node_51aaefd1-2772-4d9e-b458-80c449db677e"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_48e362cb-c6b4-4d38-a325-08667444b783",
			type = "default",
			x = 1205,
			y = 2405,
			y_normalized = 0,
			rendered_y = 2405,
			talent = "adamant_monster_hunter",
			icon = "content/ui/textures/icons/talents/adamant/execution_order_perma_buff",
			rendered_x = 1205,
			x_normalized = 0,
			children = {
				"node_65d7f26b-711e-4ef9-ae0e-5bad2ac7a818"
			},
			parents = {
				"node_eea35a28-d324-4f45-b682-edadc7d4c5ef",
				"node_65d7f26b-711e-4ef9-ae0e-5bad2ac7a818",
				"node_2eb48f41-2b1a-42ae-9f0c-e5c6210c9949"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_bf589f32-33d7-48d4-ae96-2ab3d6a63ee3",
			type = "default",
			x = 1565,
			y = 2165,
			y_normalized = 0,
			rendered_y = 2165,
			talent = "adamant_first_melee_hit_increased_damage",
			icon = "content/ui/textures/icons/talents/adamant/adamant_wield_speed_on_melee_kill",
			rendered_x = 1565,
			x_normalized = 0,
			children = {
				"node_44740858-05d7-46c6-a2f0-a51c3aadadaf"
			},
			parents = {
				"node_4bd3e71e-c621-4727-bedc-141b052cbee5"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_021a58e4-4b06-40cb-b978-3823adbd5a15",
			type = "default",
			x = 605,
			y = 2285,
			y_normalized = 0,
			rendered_y = 2285,
			talent = "adamant_pinning_dog_elite_damage",
			icon = "content/ui/textures/icons/talents/adamant/adamant_pinning_dog_elite_damage",
			rendered_x = 605,
			x_normalized = 0,
			children = {
				"node_e992d16b-4372-4874-93ca-7a520cceb74c"
			},
			parents = {
				"node_62deceb2-66cd-4494-b96d-27b9fcc8732b",
				"node_9b76913c-5597-404c-ae20-7f3e16ec9273"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				incompatible_talent = "adamant_disable_companion"
			}
		},
		{
			max_points = 1,
			widget_name = "node_2eb48f41-2b1a-42ae-9f0c-e5c6210c9949",
			type = "default",
			x = 1205,
			y = 2285,
			y_normalized = 0,
			rendered_y = 2285,
			talent = "adamant_increased_damage_to_high_health",
			icon = "content/ui/textures/icons/talents/adamant/adamant_increased_damage_vs_horde",
			rendered_x = 1205,
			x_normalized = 0,
			children = {
				"node_48e362cb-c6b4-4d38-a325-08667444b783"
			},
			parents = {
				"node_0bf17803-4dbf-4ffd-8c23-2115ca8b2515",
				"node_eea35a28-d324-4f45-b682-edadc7d4c5ef"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_4137c1d3-f155-4dbb-ae2f-01eeae998353",
			type = "default",
			x = 725,
			y = 1325,
			y_normalized = 0,
			rendered_y = 1325,
			talent = "adamant_pinning_dog_kills_buff_allies",
			icon = "content/ui/textures/icons/talents/adamant/adamant_pinning_dog_kills_buff_allies",
			rendered_x = 725,
			x_normalized = 0,
			children = {
				"node_d11bcab3-f47e-43ef-8f26-72e4ed2760fe"
			},
			parents = {
				"node_4c33cf5f-8516-4c2d-bc50-7afd037eb239"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				incompatible_talent = "adamant_disable_companion"
			}
		},
		{
			max_points = 1,
			widget_name = "node_4e45edbc-7e9a-43b8-9078-8d8146ca4177",
			type = "default",
			x = 845,
			y = 2165,
			y_normalized = 0,
			rendered_y = 2165,
			talent = "adamant_sprinting_sliding",
			icon = "content/ui/textures/icons/talents/adamant/adamant_sprinting_sliding",
			rendered_x = 845,
			x_normalized = 0,
			children = {
				"node_e8d152e8-495b-4da1-86e8-4c78bd1dd63b"
			},
			parents = {
				"node_bdab99db-3a50-4368-a9d7-7dc613f86f2d"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_9964320a-cf72-40d7-ad57-d4e5bc4a7345",
			type = "keystone_modifier",
			x = 1085,
			y = 2525,
			y_normalized = 0,
			rendered_y = 2525,
			talent = "adamant_terminus_warrant_upgrade",
			icon = "content/ui/textures/icons/talents/adamant/adamant_terminus_warrant_tdr",
			rendered_x = 1085,
			x_normalized = 0,
			children = {
				"node_40edc5b7-fae7-4043-9cfd-7ec06b1b59cb"
			},
			parents = {
				"node_65d7f26b-711e-4ef9-ae0e-5bad2ac7a818"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_8dfe9968-7413-4940-bd87-0a220eb821e7",
			type = "default",
			x = 1325,
			y = 2285,
			y_normalized = 0,
			rendered_y = 2285,
			talent = "adamant_ranged_damage_on_melee_stagger",
			icon = "content/ui/textures/icons/talents/adamant/adamant_mag_strips",
			rendered_x = 1325,
			x_normalized = 0,
			children = {
				"node_f74129c0-c6ba-47d0-a058-315793b06763"
			},
			parents = {
				"node_b4b7879c-20cc-40d3-ac4f-955b154a16e7",
				"node_52362bbc-c8ce-4652-886a-b4039d370d38"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_5d52392f-6daa-479c-9104-67a901e69a32",
			type = "default",
			x = 965,
			y = 2285,
			y_normalized = 0,
			rendered_y = 2285,
			talent = "adamant_clip_size",
			icon = "content/ui/textures/icons/talents/adamant/adamant_clip_size",
			rendered_x = 965,
			x_normalized = 0,
			children = {
				"node_b93d4978-d0c5-4257-8725-9a1b20596f93"
			},
			parents = {
				"node_eea35a28-d324-4f45-b682-edadc7d4c5ef",
				"node_39b2491a-29f2-428c-9dc5-14d41204a76d"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_0bf17803-4dbf-4ffd-8c23-2115ca8b2515",
			type = "default",
			x = 1205,
			y = 2165,
			y_normalized = 0,
			rendered_y = 2165,
			talent = "adamant_damage_vs_suppressed",
			icon = "content/ui/textures/icons/talents/adamant/adamant_damage_vs_suppressed",
			rendered_x = 1205,
			x_normalized = 0,
			children = {
				"node_2eb48f41-2b1a-42ae-9f0c-e5c6210c9949"
			},
			parents = {
				"node_51aaefd1-2772-4d9e-b458-80c449db677e"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_51aaefd1-2772-4d9e-b458-80c449db677e",
			type = "default",
			x = 1085,
			y = 2105,
			y_normalized = 0,
			rendered_y = 2105,
			talent = "adamant_stacking_damage",
			icon = "content/ui/textures/icons/talents/adamant/adamant_pinning_dog_permanent_stacks",
			rendered_x = 1085,
			x_normalized = 0,
			children = {
				"node_39b2491a-29f2-428c-9dc5-14d41204a76d",
				"node_eea35a28-d324-4f45-b682-edadc7d4c5ef",
				"node_4bd3e71e-c621-4727-bedc-141b052cbee5",
				"node_bdab99db-3a50-4368-a9d7-7dc613f86f2d",
				"node_0bf17803-4dbf-4ffd-8c23-2115ca8b2515"
			},
			parents = {
				"node_4bd3e71e-c621-4727-bedc-141b052cbee5",
				"node_bdab99db-3a50-4368-a9d7-7dc613f86f2d",
				"node_f1a66593-132e-4464-9c20-c7a7cf79a4b0",
				"node_ccb98e10-453f-425b-8242-9d264faf7b25",
				"node_db2750a5-ac31-469f-8e7d-294b6c750b35"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_5aaad316-c107-420b-9010-48668b673c58",
			type = "default",
			x = 1205,
			y = 1325,
			y_normalized = 0,
			rendered_y = 1325,
			talent = "adamant_staggered_enemies_deal_less_damage",
			icon = "content/ui/textures/icons/talents/adamant/adamant_staggered_enemies_deal_less_damage",
			rendered_x = 1205,
			x_normalized = 0,
			children = {
				"node_d9c8ac91-9f39-43f5-9655-c836de0bb997",
				"node_6857741a-5da7-40c1-871b-4b62f91a52ea"
			},
			parents = {
				"node_8cd80a54-2e4c-435c-9cdd-2ff7e4715505",
				"node_46db21b8-af36-49bf-a4b3-8a79d303edb2"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_46db21b8-af36-49bf-a4b3-8a79d303edb2",
			type = "default",
			x = 1325,
			y = 1235,
			y_normalized = 0,
			rendered_y = 1235,
			talent = "adamant_melee_weakspot_hits_count_as_stagger",
			icon = "content/ui/textures/icons/talents/adamant/adamant_melee_weakspot_hits_count_as_stagger",
			rendered_x = 1325,
			x_normalized = 0,
			children = {
				"node_edc914ed-dc63-47f0-b8e5-97a051892616",
				"node_5aaad316-c107-420b-9010-48668b673c58"
			},
			parents = {
				"node_1b027142-867d-492d-a12c-a31f83808c10"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_52362bbc-c8ce-4652-886a-b4039d370d38",
			type = "default",
			x = 1325,
			y = 2165,
			y_normalized = 0,
			rendered_y = 2165,
			talent = "adamant_staggering_enemies_take_more_damage",
			icon = "content/ui/textures/icons/talents/adamant/adamant_pinning_dog_cleave_bonus",
			rendered_x = 1325,
			x_normalized = 0,
			children = {
				"node_8dfe9968-7413-4940-bd87-0a220eb821e7"
			},
			parents = {
				"node_4bd3e71e-c621-4727-bedc-141b052cbee5"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			widget_name = "node_3910099b-f9f7-472c-bbaa-f66e23e67962",
			type = "default",
			x = 1445,
			y = 635,
			y_normalized = 0,
			rendered_y = 635,
			talent = "adamant_perfect_block_damage_boost",
			icon = "content/ui/textures/icons/talents/adamant/adamant_perfect_block_damage_boost",
			rendered_x = 1445,
			x_normalized = 0,
			children = {
				"node_2c04a28e-bcad-4554-b738-37f89f37eee2",
				"node_ff7e488d-67b2-4139-a794-6032177b6d56"
			},
			parents = {
				"node_577dcd33-0991-437a-ac3f-93d5cf1eda97",
				"node_ff7e488d-67b2-4139-a794-6032177b6d56"
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
