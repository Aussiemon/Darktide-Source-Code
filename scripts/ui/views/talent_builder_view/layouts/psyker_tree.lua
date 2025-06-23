﻿-- chunkname: @scripts/ui/views/talent_builder_view/layouts/psyker_tree.lua

return {
	name = "psyker_tree",
	node_points = 30,
	version = 20,
	background_height = 2650,
	archetype_name = "psyker",
	talent_points = 30,
	nodes = {
		{
			type = "start",
			max_points = 1,
			widget_name = "node_98df89ba-6894-4d94-9a36-a870d3962ba9",
			y = 392.30089116729476,
			y_normalized = 0,
			talent = "not_selected",
			icon = "content/ui/textures/icons/talents/psyker/psyker_default_general_talent",
			x = 1061.327392578125,
			x_normalized = 0,
			children = {
				"node_5cdd458f-bbfc-40a3-ac1f-4a229ddbbb6a",
				"node_aeefc406-9103-4749-a827-a90a0525baea",
				"node_a9e156c8-8c1a-4421-a5de-ec60da158b5d",
				"node_0866df78-dac3-46dc-9af6-30119a64acbe"
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
			group_name = "psyker_1",
			type = "default",
			widget_name = "node_5cdd458f-bbfc-40a3-ac1f-4a229ddbbb6a",
			y = 421.0176993851111,
			y_normalized = 0,
			talent = "psyker_toughness_on_warp_kill",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_1_name_2",
			x = 835.177001953125,
			x_normalized = 0,
			children = {
				"node_dbf51b8d-f6d8-418b-a1dc-29435eea34b0"
			},
			parents = {
				"node_98df89ba-6894-4d94-9a36-a870d3962ba9"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			group_name = "psyker_1",
			type = "default",
			widget_name = "node_0866df78-dac3-46dc-9af6-30119a64acbe",
			y = 484.7345267776892,
			y_normalized = 0,
			talent = "psyker_toughness_on_vent",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_1_name_3",
			x = 962.610595703125,
			x_normalized = 0,
			children = {
				"node_dbf51b8d-f6d8-418b-a1dc-29435eea34b0",
				"node_a665def4-3336-44eb-b7ed-1023d01cfd99"
			},
			parents = {
				"node_98df89ba-6894-4d94-9a36-a870d3962ba9"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			group_name = "psyker_1",
			type = "default",
			widget_name = "node_aeefc406-9103-4749-a827-a90a0525baea",
			y = 484.7345267776892,
			y_normalized = 0,
			talent = "psyker_warp_charge_generation_generates_toughness",
			icon = "content/ui/textures/icons/talents/psyker/psyker_warp_charge_generation_generates_toughness",
			x = 1090.044189453125,
			x_normalized = 0,
			children = {
				"node_a665def4-3336-44eb-b7ed-1023d01cfd99",
				"node_70bf8f4f-c0be-4c83-9c62-4b47ef5e3300"
			},
			parents = {
				"node_98df89ba-6894-4d94-9a36-a870d3962ba9"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			max_points = 1,
			group_name = "psyker_1",
			type = "default",
			widget_name = "node_a9e156c8-8c1a-4421-a5de-ec60da158b5d",
			y = 421.0176993851111,
			y_normalized = 0,
			talent = "psyker_crits_regen_toughness_movement_speed",
			icon = "content/ui/textures/icons/talents/psyker/psyker_1_tier_4_name_2",
			x = 1217.4779052734375,
			x_normalized = 0,
			children = {
				"node_70bf8f4f-c0be-4c83-9c62-4b47ef5e3300"
			},
			parents = {
				"node_98df89ba-6894-4d94-9a36-a870d3962ba9"
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
			widget_name = "node_dbf51b8d-f6d8-418b-a1dc-29435eea34b0",
			y = 548.4513247329577,
			y_normalized = 0,
			talent = "psyker_elite_kills_add_warpfire",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_2_name_3",
			x = 803.318603515625,
			x_normalized = 0,
			children = {
				"node_0bbf73c4-d47e-4205-b8a3-1ee5879708cb"
			},
			parents = {
				"node_5cdd458f-bbfc-40a3-ac1f-4a229ddbbb6a",
				"node_0866df78-dac3-46dc-9af6-30119a64acbe"
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
			widget_name = "node_a665def4-3336-44eb-b7ed-1023d01cfd99",
			y = 580.3097231704577,
			y_normalized = 0,
			talent = "psyker_chance_to_vent_on_kill",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_base_2",
			x = 1026.327392578125,
			x_normalized = 0,
			children = {
				"node_d17100f5-03fb-4f7d-8918-b046bb713b25",
				"node_0bbf73c4-d47e-4205-b8a3-1ee5879708cb",
				"node_7a0b6272-1fb7-409e-ab01-cb500736cc3d"
			},
			parents = {
				"node_0866df78-dac3-46dc-9af6-30119a64acbe",
				"node_aeefc406-9103-4749-a827-a90a0525baea"
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
			widget_name = "node_70bf8f4f-c0be-4c83-9c62-4b47ef5e3300",
			y = 548.4513247329577,
			y_normalized = 0,
			talent = "psyker_crits_empower_next_attack",
			icon = "content/ui/textures/icons/talents/psyker/psyker_1_tier_2_name_3",
			x = 1249.3363037109375,
			x_normalized = 0,
			children = {
				"node_7a0b6272-1fb7-409e-ab01-cb500736cc3d"
			},
			parents = {
				"node_aeefc406-9103-4749-a827-a90a0525baea",
				"node_a9e156c8-8c1a-4421-a5de-ec60da158b5d"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "tactical_modifier",
			max_points = 1,
			widget_name = "node_fbf53cbf-026b-4076-aa50-08813d53dbb6",
			y = 805.8185732681139,
			y_normalized = 0,
			talent = "psyker_smite_on_hit",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_5_name_3",
			x = 646.5265502929688,
			x_normalized = 0,
			children = {},
			parents = {
				"node_58a8d92f-0b8c-43c4-ac80-f0c597fffc54"
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
			widget_name = "node_58a8d92f-0b8c-43c4-ac80-f0c597fffc54",
			y = 692.7433779556139,
			y_normalized = 0,
			talent = "psyker_brain_burst_improved",
			icon = "content/ui/textures/icons/talents/psyker/psyker_brain_burst_improved",
			x = 724.6017456054688,
			x_normalized = 0,
			children = {
				"node_579235ed-79b0-4532-8028-6cee7e154d94",
				"node_d0f28c39-50b3-4f6f-893f-52e71aaba392",
				"node_fbf53cbf-026b-4076-aa50-08813d53dbb6",
				"node_26e1692a-d918-4407-915d-026f8957efe0"
			},
			parents = {
				"node_d17100f5-03fb-4f7d-8918-b046bb713b25",
				"node_0bbf73c4-d47e-4205-b8a3-1ee5879708cb"
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
			widget_name = "node_35ce2086-9081-49c7-9703-f3c07eb0be86",
			y = 692.7433779556139,
			y_normalized = 0,
			talent = "psyker_grenade_throwing_knives",
			icon = "content/ui/textures/icons/talents/psyker/psyker_blitz_warp_infused_shards",
			x = 1298.0531005859375,
			x_normalized = 0,
			children = {
				"node_df9852a3-36e2-40ab-bd6b-c8ce430cfaa4",
				"node_0bf7158c-dd89-4db0-a864-53369c029cac",
				"node_a0e99f21-5abe-407d-a328-c955e9cc27f2",
				"node_6059d69d-2c39-48eb-a87a-05bfb38aea89"
			},
			parents = {
				"node_0c96d4f4-ec5f-41da-aaa8-6507b10c03dd",
				"node_7a0b6272-1fb7-409e-ab01-cb500736cc3d"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "blitz"
			}
		},
		{
			type = "tactical_modifier",
			max_points = 1,
			widget_name = "node_df9852a3-36e2-40ab-bd6b-c8ce430cfaa4",
			y = 710.2433779556139,
			y_normalized = 0,
			talent = "psyker_throwing_knives_piercing",
			icon = "content/ui/textures/icons/talents/psyker/psyker_throwing_knives_piercing",
			x = 1474.8450927734375,
			x_normalized = 0,
			children = {},
			parents = {
				"node_35ce2086-9081-49c7-9703-f3c07eb0be86"
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
			widget_name = "node_88eb687e-bd2e-449e-b198-1bd2318eeda1",
			y = 692.7433779556139,
			y_normalized = 0,
			talent = "psyker_grenade_chain_lightning",
			icon = "content/ui/textures/icons/talents/psyker/psyker_blitz_chain_lightning",
			x = 1011.327392578125,
			x_normalized = 0,
			children = {
				"node_4da2356c-4742-4000-9dd3-e6f3ee0280bd",
				"node_8da8c02b-211b-48bc-a170-f06b79b545b9",
				"node_6059d69d-2c39-48eb-a87a-05bfb38aea89",
				"node_26e1692a-d918-4407-915d-026f8957efe0",
				"node_d958faa6-e3ea-4c79-bc84-3477063b09f7"
			},
			parents = {
				"node_0bf7158c-dd89-4db0-a864-53369c029cac",
				"node_579235ed-79b0-4532-8028-6cee7e154d94",
				"node_0bbf73c4-d47e-4205-b8a3-1ee5879708cb",
				"node_7a0b6272-1fb7-409e-ab01-cb500736cc3d"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "blitz"
			}
		},
		{
			type = "aura",
			max_points = 1,
			widget_name = "node_d323e130-860b-42f1-acd2-dc50cacde619",
			y = 1075.0442483277445,
			y_normalized = 0,
			talent = "psyker_aura_damage_vs_elites",
			icon = "content/ui/textures/icons/talents/psyker/psyker_aura_kinetic_presence",
			x = 852.035400390625,
			x_normalized = 0,
			children = {
				"node_e7bb75f7-fc49-4ef3-9e47-db8173419886",
				"node_db36197a-b900-4b31-bfc2-66d251459e29"
			},
			parents = {
				"node_579235ed-79b0-4532-8028-6cee7e154d94",
				"node_ff791f9e-aa3a-40e0-b677-8a7b10649495",
				"node_d17100f5-03fb-4f7d-8918-b046bb713b25",
				"node_7b4e0ecc-fba4-418c-a34c-8ae1739e341c"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "aura"
			}
		},
		{
			type = "tactical_modifier",
			max_points = 1,
			widget_name = "node_4da2356c-4742-4000-9dd3-e6f3ee0280bd",
			y = 805.8185732681139,
			y_normalized = 0,
			talent = "psyker_increased_chain_lightning_size",
			icon = "content/ui/textures/icons/talents/psyker/psyker_3_tier_2_name_1",
			x = 965.110595703125,
			x_normalized = 0,
			children = {},
			parents = {
				"node_88eb687e-bd2e-449e-b198-1bd2318eeda1"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "tactical_modifier",
			max_points = 1,
			widget_name = "node_d0f28c39-50b3-4f6f-893f-52e71aaba392",
			y = 710.2433779556139,
			y_normalized = 0,
			talent = "psyker_ability_increase_brain_burst_speed",
			icon = "content/ui/textures/icons/talents/psyker/psyker_ability_increase_brain_burst_speed",
			x = 582.8097534179688,
			x_normalized = 0,
			children = {},
			parents = {
				"node_58a8d92f-0b8c-43c4-ac80-f0c597fffc54"
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
			widget_name = "node_c2759b06-3158-4d95-a860-492fd3b6594e",
			y = 1075.0442618310979,
			y_normalized = 0,
			talent = "psyker_cooldown_aura_improved",
			icon = "content/ui/textures/icons/talents/psyker/psyker_aura_seers_presence",
			x = 1011.327392578125,
			x_normalized = 0,
			children = {
				"node_db36197a-b900-4b31-bfc2-66d251459e29"
			},
			parents = {
				"node_ff791f9e-aa3a-40e0-b677-8a7b10649495",
				"node_9049de9c-7aef-4bda-bc26-2892d147c486",
				"node_7b4e0ecc-fba4-418c-a34c-8ae1739e341c"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "aura"
			}
		},
		{
			type = "ability",
			max_points = 1,
			widget_name = "node_650c5469-5194-4722-a4f8-7d62487039df",
			y = 1382.6282910372302,
			y_normalized = 0,
			talent = "psyker_shout_vent_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker/psyker_shout_vent_warp_charge",
			x = 681.7433471679688,
			x_normalized = 0,
			children = {
				"node_b6b57be7-9aa8-483b-a127-6c1815d452a4",
				"node_3707077c-1f49-4605-9d6a-9fa062edbbf8",
				"node_1f52a8dd-e3bb-400a-85d7-314dd3884ce7",
				"node_15ffb139-928c-406e-a4b5-71c9d5bebadc"
			},
			parents = {
				"node_1c90c96d-394f-49e6-8e5c-d5ae5fe44fdb",
				"node_1943527f-b930-43f0-98b6-340d14d596d5"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "combat"
			}
		},
		{
			type = "ability",
			max_points = 1,
			widget_name = "node_2a022d3f-fddf-4faf-a79d-c8fe6a18fe36",
			y = 1382.6282910372302,
			y_normalized = 0,
			talent = "psyker_combat_ability_stance",
			icon = "content/ui/textures/icons/talents/psyker/psyker_ability_overcharge_stance",
			x = 1318.9114990234375,
			x_normalized = 0,
			children = {
				"node_7e0096b1-511c-4ca6-a4dd-81836758e85c",
				"node_3f52126e-dbc7-492b-912d-26e4cc53a80e",
				"node_229f2961-ef6f-4ccb-942e-8c4945f1f90f",
				"node_17c2bf3f-7235-4e00-be33-5931be3bb011",
				"node_79ffb5f6-b82f-47c0-8eeb-5e28dcb2766a",
				"node_da8959b5-f8dd-4efb-8fee-c1600e6ee831"
			},
			parents = {
				"node_b8bc29fc-5fd2-41dc-89ac-25628444b75a",
				"node_1c28e8f1-c647-401d-80f1-38263a6b616b",
				"node_b64d3e49-d2d6-4565-8195-fba8f68d014c"
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
			widget_name = "node_b6b57be7-9aa8-483b-a127-6c1815d452a4",
			y = 1472.3451540786607,
			y_normalized = 0,
			talent = "psyker_shout_reduces_warp_charge_generation",
			icon = "content/ui/textures/icons/talents/psyker/psyker_shout_reduces_warp_charge_generation",
			x = 580.3097534179688,
			x_normalized = 0,
			children = {
				"node_685300ac-9564-437d-9611-de94d66ec880",
				"node_c5704647-fc14-437e-9906-5ab5f3ded524",
				"node_400d79d6-4aaa-47e4-b9c4-127b79ef639a"
			},
			parents = {
				"node_650c5469-5194-4722-a4f8-7d62487039df"
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
			widget_name = "node_685300ac-9564-437d-9611-de94d66ec880",
			y = 1567.9203799087388,
			y_normalized = 0,
			talent = "psyker_shout_damage_per_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker/psyker_shout_damage_per_warp_charge",
			x = 516.5928955078125,
			x_normalized = 0,
			children = {},
			parents = {
				"node_b6b57be7-9aa8-483b-a127-6c1815d452a4"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "shout_1"
			}
		},
		{
			type = "ability_modifier",
			max_points = 1,
			widget_name = "node_400d79d6-4aaa-47e4-b9c4-127b79ef639a",
			y = 1567.9203799087388,
			y_normalized = 0,
			talent = "psyker_warpfire_on_shout",
			icon = "content/ui/textures/icons/talents/psyker/psyker_warpfire_on_shout",
			x = 644.0265502929688,
			x_normalized = 0,
			children = {},
			parents = {
				"node_b6b57be7-9aa8-483b-a127-6c1815d452a4"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "shout_1"
			}
		},
		{
			type = "ability_modifier",
			max_points = 1,
			widget_name = "node_17c2bf3f-7235-4e00-be33-5931be3bb011",
			y = 1536.0619512237276,
			y_normalized = 0,
			talent = "psyker_overcharge_weakspot_kill_bonuses",
			icon = "content/ui/textures/icons/talents/psyker/psyker_overcharge_weakspot_kill_bonuses",
			x = 1536.0618896484375,
			x_normalized = 0,
			children = {
				"node_012fb3aa-bcfb-429b-8bd9-376cd7ad7915"
			},
			parents = {
				"node_2a022d3f-fddf-4faf-a79d-c8fe6a18fe36"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "stance_1"
			}
		},
		{
			type = "ability_modifier",
			max_points = 1,
			widget_name = "node_da8959b5-f8dd-4efb-8fee-c1600e6ee831",
			y = 1440.4867253936495,
			y_normalized = 0,
			talent = "psyker_overcharge_reduced_toughness_damage_taken",
			icon = "content/ui/textures/icons/talents/psyker/psyker_overcharge_reduced_toughness_damage_taken",
			x = 1504.2034912109375,
			x_normalized = 0,
			children = {
				"node_e14caf37-49e7-4d6d-8d95-22e14ce41a64",
				"node_dbfc4dc4-8eeb-4112-92cf-74bce7deea72"
			},
			parents = {
				"node_2a022d3f-fddf-4faf-a79d-c8fe6a18fe36"
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
			widget_name = "node_229f2961-ef6f-4ccb-942e-8c4945f1f90f",
			y = 1567.9203631645807,
			y_normalized = 0,
			talent = "psyker_overcharge_increased_movement_speed",
			icon = "content/ui/textures/icons/talents/psyker/psyker_overcharge_increased_movement_speed",
			x = 1376.7698974609375,
			x_normalized = 0,
			children = {},
			parents = {
				"node_2a022d3f-fddf-4faf-a79d-c8fe6a18fe36"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "tactical_modifier",
			max_points = 1,
			widget_name = "node_a0e99f21-5abe-407d-a328-c955e9cc27f2",
			y = 805.8185732681139,
			y_normalized = 0,
			talent = "psyker_throwing_knives_cast_speed",
			icon = "content/ui/textures/icons/talents/psyker/psyker_throwing_knives_reduced_cooldown",
			x = 1411.1282958984375,
			x_normalized = 0,
			children = {},
			parents = {
				"node_35ce2086-9081-49c7-9703-f3c07eb0be86"
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
			widget_name = "node_592db669-6d46-45a9-aa87-c66bc5d52a53",
			y = 1075.0442483277445,
			y_normalized = 0,
			talent = "psyker_aura_crit_chance_aura",
			icon = "content/ui/textures/icons/talents/psyker/psyker_aura_gunslinger_aura",
			x = 1170.6195068359375,
			x_normalized = 0,
			children = {
				"node_0c96d4f4-ec5f-41da-aaa8-6507b10c03dd",
				"node_34463b1b-0fff-436a-bcbb-4abc601bd2be",
				"node_db36197a-b900-4b31-bfc2-66d251459e29"
			},
			parents = {
				"node_ff791f9e-aa3a-40e0-b677-8a7b10649495",
				"node_9049de9c-7aef-4bda-bc26-2892d147c486"
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
			widget_name = "node_ebeb44ed-54d4-44f6-a211-f7060668f98a",
			y = 898.8938296157702,
			y_normalized = 0,
			talent = "psyker_spread_warpfire_on_kill",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_5_name_2",
			x = 771.460205078125,
			x_normalized = 0,
			children = {
				"node_7b4e0ecc-fba4-418c-a34c-8ae1739e341c"
			},
			parents = {
				"node_26e1692a-d918-4407-915d-026f8957efe0"
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
			widget_name = "node_25cef95d-234f-4299-a964-2ca42056cb5a",
			y = 898.8938296157702,
			y_normalized = 0,
			talent = "psyker_2_tier_3_name_2",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_3_name_2",
			x = 898.893798828125,
			x_normalized = 0,
			children = {
				"node_7b4e0ecc-fba4-418c-a34c-8ae1739e341c"
			},
			parents = {
				"node_26e1692a-d918-4407-915d-026f8957efe0"
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
			widget_name = "node_dafc9b1b-859e-44df-bea9-33fecbd3afc7",
			y = 898.8938296157702,
			y_normalized = 0,
			talent = "psyker_venting_improvements",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_4_name_3",
			x = 1153.7611083984375,
			x_normalized = 0,
			children = {
				"node_9049de9c-7aef-4bda-bc26-2892d147c486"
			},
			parents = {
				"node_6059d69d-2c39-48eb-a87a-05bfb38aea89"
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
			widget_name = "node_8e7a1179-6cbd-4f0d-9992-a0ca5282b30b",
			y = 898.8938296157702,
			y_normalized = 0,
			talent = "psyker_kills_stack_other_weapon_damage",
			icon = "content/ui/textures/icons/talents/psyker/psyker_1_tier_2_name_2",
			x = 1281.1947021484375,
			x_normalized = 0,
			children = {
				"node_9049de9c-7aef-4bda-bc26-2892d147c486"
			},
			parents = {
				"node_6059d69d-2c39-48eb-a87a-05bfb38aea89"
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
			widget_name = "node_79ffb5f6-b82f-47c0-8eeb-5e28dcb2766a",
			y = 1599.7787480987276,
			y_normalized = 0,
			talent = "psyker_overcharge_reduced_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker/psyker_overcharge_reduced_warp_charge",
			x = 1472.3450927734375,
			x_normalized = 0,
			children = {
				"node_012fb3aa-bcfb-429b-8bd9-376cd7ad7915"
			},
			parents = {
				"node_2a022d3f-fddf-4faf-a79d-c8fe6a18fe36"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "stance_1"
			}
		},
		{
			type = "tactical_modifier",
			max_points = 1,
			widget_name = "node_8da8c02b-211b-48bc-a170-f06b79b545b9",
			y = 805.8185732681139,
			y_normalized = 0,
			talent = "psyker_chain_lightning_improved_target_buff",
			icon = "content/ui/textures/icons/talents/psyker/psyker_chain_lightning_improved_target_buff",
			x = 1092.544189453125,
			x_normalized = 0,
			children = {},
			parents = {
				"node_88eb687e-bd2e-449e-b198-1bd2318eeda1"
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
			widget_name = "node_1943527f-b930-43f0-98b6-340d14d596d5",
			y = 1281.1946773022676,
			y_normalized = 0,
			talent = "psyker_warp_charge_reduces_toughness_damage_taken",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_4_name_2",
			x = 898.893798828125,
			x_normalized = 0,
			children = {
				"node_ba340289-3623-4920-b6cb-0a665eff8c0e",
				"node_650c5469-5194-4722-a4f8-7d62487039df"
			},
			parents = {
				"node_e7bb75f7-fc49-4ef3-9e47-db8173419886",
				"node_db36197a-b900-4b31-bfc2-66d251459e29"
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
			widget_name = "node_1c28e8f1-c647-401d-80f1-38263a6b616b",
			y = 1281.1946773022676,
			y_normalized = 0,
			talent = "psyker_dodge_after_crits",
			icon = "content/ui/textures/icons/talents/psyker/psyker_1_tier_4_name_1",
			x = 1153.7611083984375,
			x_normalized = 0,
			children = {
				"node_ba340289-3623-4920-b6cb-0a665eff8c0e",
				"node_2a022d3f-fddf-4faf-a79d-c8fe6a18fe36"
			},
			parents = {
				"node_db36197a-b900-4b31-bfc2-66d251459e29",
				"node_34463b1b-0fff-436a-bcbb-4abc601bd2be"
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
			widget_name = "node_1c90c96d-394f-49e6-8e5c-d5ae5fe44fdb",
			y = 1281.1946751417313,
			y_normalized = 0,
			talent = "psyker_aura_toughness_on_ally_knocked_down",
			icon = "content/ui/textures/icons/talents/psyker/psyker_3_tier_3_name_1",
			x = 675.8849487304688,
			x_normalized = 0,
			children = {
				"node_650c5469-5194-4722-a4f8-7d62487039df"
			},
			parents = {
				"node_e7bb75f7-fc49-4ef3-9e47-db8173419886"
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
			widget_name = "node_b64d3e49-d2d6-4565-8195-fba8f68d014c",
			y = 1281.1946751417313,
			y_normalized = 0,
			talent = "psyker_improved_dodge",
			icon = "content/ui/textures/icons/talents/psyker/psyker_1_tier_4_name_3",
			x = 1376.7698974609375,
			x_normalized = 0,
			children = {
				"node_2a022d3f-fddf-4faf-a79d-c8fe6a18fe36"
			},
			parents = {
				"node_34463b1b-0fff-436a-bcbb-4abc601bd2be"
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
			widget_name = "node_e7bb75f7-fc49-4ef3-9e47-db8173419886",
			y = 1184.619457953799,
			y_normalized = 0,
			talent = "base_warp_charge_node_buff_low_3",
			icon = "content/ui/textures/icons/talents/psyker/psyker_default_general_talent",
			x = 802.318603515625,
			x_normalized = 0,
			children = {
				"node_1c90c96d-394f-49e6-8e5c-d5ae5fe44fdb",
				"node_1943527f-b930-43f0-98b6-340d14d596d5",
				"node_db36197a-b900-4b31-bfc2-66d251459e29"
			},
			parents = {
				"node_d323e130-860b-42f1-acd2-dc50cacde619",
				"node_db36197a-b900-4b31-bfc2-66d251459e29"
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
			widget_name = "node_db36197a-b900-4b31-bfc2-66d251459e29",
			y = 1184.6194571435979,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_low_2",
			x = 1025.327392578125,
			x_normalized = 0,
			children = {
				"node_1943527f-b930-43f0-98b6-340d14d596d5",
				"node_1c28e8f1-c647-401d-80f1-38263a6b616b",
				"node_e7bb75f7-fc49-4ef3-9e47-db8173419886",
				"node_34463b1b-0fff-436a-bcbb-4abc601bd2be"
			},
			parents = {
				"node_c2759b06-3158-4d95-a860-492fd3b6594e",
				"node_592db669-6d46-45a9-aa87-c66bc5d52a53",
				"node_d323e130-860b-42f1-acd2-dc50cacde619",
				"node_34463b1b-0fff-436a-bcbb-4abc601bd2be",
				"node_e7bb75f7-fc49-4ef3-9e47-db8173419886"
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
			widget_name = "node_34463b1b-0fff-436a-bcbb-4abc601bd2be",
			y = 1184.619457953799,
			y_normalized = 0,
			talent = "base_ranged_damage_node_buff_low_1",
			x = 1248.3363037109375,
			x_normalized = 0,
			children = {
				"node_1c28e8f1-c647-401d-80f1-38263a6b616b",
				"node_b64d3e49-d2d6-4565-8195-fba8f68d014c",
				"node_db36197a-b900-4b31-bfc2-66d251459e29"
			},
			parents = {
				"node_592db669-6d46-45a9-aa87-c66bc5d52a53",
				"node_db36197a-b900-4b31-bfc2-66d251459e29"
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
			widget_name = "node_57581786-6c2f-45d1-a396-8e58299d84d8",
			y = 1663.495546053996,
			y_normalized = 0,
			talent = "psyker_increased_vent_speed",
			icon = "content/ui/textures/icons/talents/psyker/psyker_3_tier_1_name_3",
			x = 739.6017456054688,
			x_normalized = 0,
			children = {
				"node_e45f9fa0-1a78-47b4-9f04-c69857e46a6d"
			},
			parents = {
				"node_5c4a163b-68e5-4123-80dd-ccf9c5282b76",
				"node_652174b2-b6c8-4ff7-9ba8-087954a21022",
				"node_15ffb139-928c-406e-a4b5-71c9d5bebadc"
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
			widget_name = "node_502ba655-95d9-419a-a825-c688915e2983",
			y = 1663.495546053996,
			y_normalized = 0,
			talent = "psyker_damage_based_on_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker/psyker_damage_based_on_warp_charge",
			x = 962.610595703125,
			x_normalized = 0,
			children = {
				"node_50f4db9f-a576-43cf-b4a3-a96996f103a6"
			},
			parents = {
				"node_bad7157a-70c9-4b5a-80c5-c4930b8c16d8"
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
			widget_name = "node_9674b583-7566-4f0c-a334-99e83f4715b2",
			y = 1854.6459977141521,
			y_normalized = 0,
			talent = "psyker_guaranteed_crit_on_multiple_weakspot_hits",
			icon = "content/ui/textures/icons/talents/psyker/psyker_1_tier_2_name_1",
			x = 1185.6195068359375,
			x_normalized = 0,
			children = {
				"node_3f08eb1a-09e8-4213-ab90-84032e51f7ae"
			},
			parents = {
				"node_28f80048-978b-420d-b0f8-8d3883a36334"
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
			widget_name = "node_b2a9dab7-310f-4938-a070-97187d356f75",
			y = 1663.495546053996,
			y_normalized = 0,
			talent = "psyker_coherency_aura_size_increase",
			icon = "content/ui/textures/icons/talents/psyker/psyker_1_tier_3_name_1",
			x = 867.035400390625,
			x_normalized = 0,
			children = {
				"node_50c20065-9156-4d29-a908-2e69f7b5ca48",
				"node_e45f9fa0-1a78-47b4-9f04-c69857e46a6d",
				"node_5c4a163b-68e5-4123-80dd-ccf9c5282b76",
				"node_652174b2-b6c8-4ff7-9ba8-087954a21022"
			},
			parents = {
				"node_15ffb139-928c-406e-a4b5-71c9d5bebadc"
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
			widget_name = "node_59a39703-43ce-432e-b853-c80517a08947",
			y = 1663.495546053996,
			y_normalized = 0,
			talent = "psyker_block_costs_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_4_name_1",
			x = 1185.6195068359375,
			x_normalized = 0,
			children = {
				"node_cb488818-7e33-4b04-aee2-7c515ffcbde2",
				"node_28f80048-978b-420d-b0f8-8d3883a36334"
			},
			parents = {
				"node_3f52126e-dbc7-492b-912d-26e4cc53a80e"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "ability",
			max_points = 1,
			widget_name = "node_ba340289-3623-4920-b6cb-0a665eff8c0e",
			y = 1350.769921226839,
			y_normalized = 0,
			talent = "psyker_combat_ability_force_field",
			icon = "content/ui/textures/icons/talents/psyker/psyker_ability_warp_barrier",
			x = 1000.327392578125,
			x_normalized = 0,
			children = {
				"node_a10c7d87-9c54-4268-b6be-ca862dcc59ae",
				"node_15ffb139-928c-406e-a4b5-71c9d5bebadc",
				"node_3f52126e-dbc7-492b-912d-26e4cc53a80e",
				"node_b965d30f-4412-43e5-856a-c571751925a7"
			},
			parents = {
				"node_c6386e49-221f-43c7-b30a-a4d5f415e6e1",
				"node_1943527f-b930-43f0-98b6-340d14d596d5",
				"node_1c28e8f1-c647-401d-80f1-38263a6b616b"
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
			group_name = "",
			type = "ability_modifier",
			widget_name = "node_a10c7d87-9c54-4268-b6be-ca862dcc59ae",
			y = 1376.7699012418764,
			y_normalized = 0,
			talent = "psyker_shield_stun_passive",
			icon = "content/ui/textures/icons/talents/psyker/psyker_3_tier_2_name_3",
			x = 898.893798828125,
			x_normalized = 0,
			children = {
				"node_959bd205-bf6c-48fc-ab14-f59364fedd6c"
			},
			parents = {
				"node_ba340289-3623-4920-b6cb-0a665eff8c0e"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "force_1"
			}
		},
		{
			max_points = 1,
			group_name = "",
			type = "ability_modifier",
			widget_name = "node_d64a57d2-05d8-4077-92a2-d12069d8d628",
			y = 1440.4867283643875,
			y_normalized = 0,
			talent = "psyker_boost_allies_in_sphere",
			icon = "content/ui/textures/icons/talents/psyker/psyker_3_tier_4_name_1",
			x = 1217.4779052734375,
			x_normalized = 0,
			children = {},
			parents = {
				"node_b965d30f-4412-43e5-856a-c571751925a7"
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
			widget_name = "node_b965d30f-4412-43e5-856a-c571751925a7",
			y = 1376.769921226839,
			y_normalized = 0,
			talent = "psyker_sphere_shield",
			icon = "content/ui/textures/icons/talents/psyker/psyker_sphere_shield",
			x = 1153.7611083984375,
			x_normalized = 0,
			children = {
				"node_d64a57d2-05d8-4077-92a2-d12069d8d628"
			},
			parents = {
				"node_ba340289-3623-4920-b6cb-0a665eff8c0e"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "force_1"
			}
		},
		{
			type = "ability_modifier",
			max_points = 1,
			widget_name = "node_959bd205-bf6c-48fc-ab14-f59364fedd6c",
			y = 1440.4866981168764,
			y_normalized = 0,
			talent = "psyker_shield_extra_charge",
			icon = "content/ui/textures/icons/talents/psyker/psyker_shield_extra_charge",
			x = 835.177001953125,
			x_normalized = 0,
			children = {},
			parents = {
				"node_a10c7d87-9c54-4268-b6be-ca862dcc59ae"
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
			widget_name = "node_0bbf73c4-d47e-4205-b8a3-1ee5879708cb",
			y = 643.0265505630358,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_1",
			x = 897.893798828125,
			x_normalized = 0,
			children = {
				"node_58a8d92f-0b8c-43c4-ac80-f0c597fffc54",
				"node_88eb687e-bd2e-449e-b198-1bd2318eeda1"
			},
			parents = {
				"node_dbf51b8d-f6d8-418b-a1dc-29435eea34b0",
				"node_a665def4-3336-44eb-b7ed-1023d01cfd99"
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
			widget_name = "node_7a0b6272-1fb7-409e-ab01-cb500736cc3d",
			y = 643.0265447172708,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_2",
			x = 1152.7611083984375,
			x_normalized = 0,
			children = {
				"node_35ce2086-9081-49c7-9703-f3c07eb0be86",
				"node_88eb687e-bd2e-449e-b198-1bd2318eeda1"
			},
			parents = {
				"node_a665def4-3336-44eb-b7ed-1023d01cfd99",
				"node_70bf8f4f-c0be-4c83-9c62-4b47ef5e3300"
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
			widget_name = "node_15ffb139-928c-406e-a4b5-71c9d5bebadc",
			y = 1566.920350741496,
			y_normalized = 0,
			talent = "base_warp_charge_node_buff_low_2",
			x = 802.318603515625,
			x_normalized = 0,
			children = {
				"node_c6386e49-221f-43c7-b30a-a4d5f415e6e1",
				"node_b2a9dab7-310f-4938-a070-97187d356f75",
				"node_bad7157a-70c9-4b5a-80c5-c4930b8c16d8",
				"node_57581786-6c2f-45d1-a396-8e58299d84d8"
			},
			parents = {
				"node_650c5469-5194-4722-a4f8-7d62487039df",
				"node_ba340289-3623-4920-b6cb-0a665eff8c0e",
				"node_bad7157a-70c9-4b5a-80c5-c4930b8c16d8"
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
			widget_name = "node_3f52126e-dbc7-492b-912d-26e4cc53a80e",
			y = 1566.920350741496,
			y_normalized = 0,
			talent = "base_crit_chance_node_buff_low_2",
			x = 1248.3363037109375,
			x_normalized = 0,
			children = {
				"node_c6386e49-221f-43c7-b30a-a4d5f415e6e1",
				"node_59a39703-43ce-432e-b853-c80517a08947",
				"node_bad7157a-70c9-4b5a-80c5-c4930b8c16d8",
				"node_237fc277-fe42-473b-aeda-70d82fc2d9e8"
			},
			parents = {
				"node_2a022d3f-fddf-4faf-a79d-c8fe6a18fe36",
				"node_ba340289-3623-4920-b6cb-0a665eff8c0e",
				"node_bad7157a-70c9-4b5a-80c5-c4930b8c16d8"
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
			widget_name = "node_25c8ee81-d16b-4d5b-b0fa-fc1e7b40c26f",
			y = 2030.7964782714844,
			y_normalized = 0,
			talent = "psyker_passive_souls_from_elite_kills",
			icon = "content/ui/textures/icons/talents/psyker/psyker_keystone_warp_syphon",
			x = 788.318603515625,
			x_normalized = 0,
			children = {
				"node_3879efd1-ebac-4cd2-b004-8c7927d16924",
				"node_cec906f5-721d-46dd-95e9-78b903190c9d",
				"node_20f0e5f6-c24d-4e29-809d-d264ecb5613f"
			},
			parents = {
				"node_8f13724d-f213-4559-969e-74dcf1053468"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "keystone"
			}
		},
		{
			type = "keystone",
			max_points = 1,
			widget_name = "node_44ce21ca-9b23-46b9-a6df-eae7ee03114b",
			y = 2030.7964782714844,
			y_normalized = 0,
			talent = "psyker_new_mark_passive",
			icon = "content/ui/textures/icons/talents/psyker/psyker_keystone_unnatural_talent",
			x = 1234.3363037109375,
			x_normalized = 0,
			children = {
				"node_31fbc1eb-b397-449d-adb8-f5c9adb5d883",
				"node_0ee8a9f7-a62a-4bd7-996e-050a9f445d10",
				"node_4941c66a-d4ff-4dca-917f-a6bbf2bbdbfc"
			},
			parents = {
				"node_3f08eb1a-09e8-4213-ab90-84032e51f7ae"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "keystone"
			}
		},
		{
			type = "keystone",
			max_points = 1,
			widget_name = "node_8d367c1d-ce78-44f3-a7b8-6a4b55341929",
			y = 1839.6460266113281,
			y_normalized = 0,
			talent = "psyker_empowered_ability",
			icon = "content/ui/textures/icons/talents/psyker/psyker_keystone_empowered_psyche",
			x = 1011.327392578125,
			x_normalized = 0,
			children = {
				"node_0bb80aeb-f367-4e65-bcb5-04e91aad3c23",
				"node_8ff8fcfb-3f13-497f-9288-0afc05b5cb55",
				"node_a5fc8414-3a27-4c9b-833c-a5b6c1836a86"
			},
			parents = {
				"node_50f4db9f-a576-43cf-b4a3-a96996f103a6"
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
			widget_name = "node_3879efd1-ebac-4cd2-b004-8c7927d16924",
			y = 2141.3716430664062,
			y_normalized = 0,
			talent = "psyker_reduced_warp_charge_cost_and_venting_speed",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_2_name_2",
			x = 707.7433471679688,
			x_normalized = 0,
			children = {},
			parents = {
				"node_25c8ee81-d16b-4d5b-b0fa-fc1e7b40c26f"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "soul_1"
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_cec906f5-721d-46dd-95e9-78b903190c9d",
			y = 2141.3716430664062,
			y_normalized = 0,
			talent = "psyker_toughness_on_soul",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_1_name_1",
			x = 898.893798828125,
			x_normalized = 0,
			children = {},
			parents = {
				"node_25c8ee81-d16b-4d5b-b0fa-fc1e7b40c26f"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "soul_1"
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_20f0e5f6-c24d-4e29-809d-d264ecb5613f",
			y = 2173.2300415039062,
			y_normalized = 0,
			talent = "psyker_souls_increase_damage",
			icon = "content/ui/textures/icons/talents/psyker/psyker_souls_increase_damage",
			x = 803.318603515625,
			x_normalized = 0,
			children = {
				"node_97dc5762-872f-4746-b48c-2f1f2bd4cca0",
				"node_b5482701-b516-444a-92d4-df82bc410afd",
				"node_97a70547-63e0-473c-9e2f-79096161d4e5",
				"node_0eee06a4-3acd-4b44-ae64-61376c34b3da"
			},
			parents = {
				"node_25c8ee81-d16b-4d5b-b0fa-fc1e7b40c26f"
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
			widget_name = "node_0bb80aeb-f367-4e65-bcb5-04e91aad3c23",
			y = 1982.0796508789062,
			y_normalized = 0,
			talent = "psyker_empowered_grenades_passive_improved",
			icon = "content/ui/textures/icons/talents/psyker/psyker_3_tier_5_name_2",
			x = 930.752197265625,
			x_normalized = 0,
			children = {
				"node_56a1da66-78b5-4f11-8b20-967dc92650da"
			},
			parents = {
				"node_8d367c1d-ce78-44f3-a7b8-6a4b55341929"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "emp_1"
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_8ff8fcfb-3f13-497f-9288-0afc05b5cb55",
			y = 1982.0796508789062,
			y_normalized = 0,
			talent = "psyker_empowered_chain_lightnings_replenish_toughness_to_allies",
			icon = "content/ui/textures/icons/talents/psyker/psyker_3_tier_5_name_1",
			x = 1026.327392578125,
			x_normalized = 0,
			children = {},
			parents = {
				"node_8d367c1d-ce78-44f3-a7b8-6a4b55341929"
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
			widget_name = "node_a5fc8414-3a27-4c9b-833c-a5b6c1836a86",
			y = 1982.0796508789062,
			y_normalized = 0,
			talent = "psyker_empowered_ability_on_elite_kills",
			icon = "content/ui/textures/icons/talents/psyker/psyker_empowered_ability_on_elite_kills",
			x = 1121.9027099609375,
			x_normalized = 0,
			children = {
				"node_56a1da66-78b5-4f11-8b20-967dc92650da"
			},
			parents = {
				"node_8d367c1d-ce78-44f3-a7b8-6a4b55341929"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "emp_1"
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_31fbc1eb-b397-449d-adb8-f5c9adb5d883",
			y = 2173.2300415039062,
			y_normalized = 0,
			talent = "psyker_mark_increased_max_stacks",
			icon = "content/ui/textures/icons/talents/psyker/psyker_mark_increased_max_stacks",
			x = 1153.7611083984375,
			x_normalized = 0,
			children = {
				"node_9c95d8c4-7304-4a56-a9fa-6a727d553105"
			},
			parents = {
				"node_44ce21ca-9b23-46b9-a6df-eae7ee03114b"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "mark_1"
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_4941c66a-d4ff-4dca-917f-a6bbf2bbdbfc",
			y = 2173.2300415039062,
			y_normalized = 0,
			talent = "psyker_mark_kills_can_vent",
			icon = "content/ui/textures/icons/talents/psyker/psyker_mark_kills_can_vent",
			x = 1249.3363037109375,
			x_normalized = 0,
			children = {},
			parents = {
				"node_44ce21ca-9b23-46b9-a6df-eae7ee03114b"
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
			widget_name = "node_0ee8a9f7-a62a-4bd7-996e-050a9f445d10",
			y = 2173.2300415039062,
			y_normalized = 0,
			talent = "psyker_mark_increased_duration",
			icon = "content/ui/textures/icons/talents/psyker/psyker_mark_increased_range",
			x = 1344.9114990234375,
			x_normalized = 0,
			children = {
				"node_9c95d8c4-7304-4a56-a9fa-6a727d553105"
			},
			parents = {
				"node_44ce21ca-9b23-46b9-a6df-eae7ee03114b"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "mark_1"
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_56a1da66-78b5-4f11-8b20-967dc92650da",
			y = 2077.6549072265625,
			y_normalized = 0,
			talent = "psyker_empowered_grenades_increased_max_stacks",
			icon = "content/ui/textures/icons/talents/psyker/psyker_3_tier_2_name_2",
			x = 1026.327392578125,
			x_normalized = 0,
			children = {},
			parents = {
				"node_0bb80aeb-f367-4e65-bcb5-04e91aad3c23",
				"node_a5fc8414-3a27-4c9b-833c-a5b6c1836a86"
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
			widget_name = "node_97a70547-63e0-473c-9e2f-79096161d4e5",
			y = 2268.8052978515625,
			y_normalized = 0,
			talent = "psyker_warpfire_generate_souls",
			icon = "content/ui/textures/icons/talents/psyker/psyker_warpfire_generate_souls",
			x = 707.7433471679688,
			x_normalized = 0,
			children = {},
			parents = {
				"node_20f0e5f6-c24d-4e29-809d-d264ecb5613f"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "soul_2"
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_b5482701-b516-444a-92d4-df82bc410afd",
			y = 2268.8052978515625,
			y_normalized = 0,
			talent = "psyker_aura_souls_on_kill",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_3_name_1",
			x = 898.893798828125,
			x_normalized = 0,
			children = {},
			parents = {
				"node_20f0e5f6-c24d-4e29-809d-d264ecb5613f"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "soul_2"
			}
		},
		{
			type = "keystone_modifier",
			max_points = 1,
			widget_name = "node_0eee06a4-3acd-4b44-ae64-61376c34b3da",
			y = 2332.5220947265625,
			y_normalized = 0,
			talent = "psyker_increased_max_souls",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_5_name_1",
			x = 803.318603515625,
			x_normalized = 0,
			children = {},
			parents = {
				"node_20f0e5f6-c24d-4e29-809d-d264ecb5613f"
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
			widget_name = "node_9c95d8c4-7304-4a56-a9fa-6a727d553105",
			y = 2268.8052978515625,
			y_normalized = 0,
			talent = "psyker_mark_weakspot_kills",
			icon = "content/ui/textures/icons/talents/psyker/psyker_mark_weakspot_kills",
			x = 1249.3363037109375,
			x_normalized = 0,
			children = {},
			parents = {
				"node_31fbc1eb-b397-449d-adb8-f5c9adb5d883",
				"node_0ee8a9f7-a62a-4bd7-996e-050a9f445d10"
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
			widget_name = "node_bad7157a-70c9-4b5a-80c5-c4930b8c16d8",
			y = 1566.920350741496,
			y_normalized = 0,
			talent = "base_health_node_buff_medium_1",
			x = 1025.327392578125,
			x_normalized = 0,
			children = {
				"node_502ba655-95d9-419a-a825-c688915e2983",
				"node_3f52126e-dbc7-492b-912d-26e4cc53a80e",
				"node_15ffb139-928c-406e-a4b5-71c9d5bebadc",
				"node_25ffe424-4f39-4206-8304-66333fe44fa5"
			},
			parents = {
				"node_15ffb139-928c-406e-a4b5-71c9d5bebadc",
				"node_3f52126e-dbc7-492b-912d-26e4cc53a80e"
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
			widget_name = "node_3f08eb1a-09e8-4213-ab90-84032e51f7ae",
			y = 1949.2211930266521,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_3",
			x = 1248.3363037109375,
			x_normalized = 0,
			children = {
				"node_44ce21ca-9b23-46b9-a6df-eae7ee03114b"
			},
			parents = {
				"node_9674b583-7566-4f0c-a334-99e83f4715b2",
				"node_e3d09295-0206-4166-91c4-2371e8abf9e3"
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
			widget_name = "node_7b4e0ecc-fba4-418c-a34c-8ae1739e341c",
			y = 994.4690224976664,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_low_1",
			x = 866.035400390625,
			x_normalized = 0,
			children = {
				"node_d323e130-860b-42f1-acd2-dc50cacde619",
				"node_9049de9c-7aef-4bda-bc26-2892d147c486",
				"node_c2759b06-3158-4d95-a860-492fd3b6594e",
				"node_96081a40-cced-4558-9427-b2aabca97e0c"
			},
			parents = {
				"node_ebeb44ed-54d4-44f6-a211-f7060668f98a",
				"node_25cef95d-234f-4299-a964-2ca42056cb5a",
				"node_9049de9c-7aef-4bda-bc26-2892d147c486"
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
			widget_name = "node_9049de9c-7aef-4bda-bc26-2892d147c486",
			y = 993.4690211473311,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_low_3",
			x = 1184.6195068359375,
			x_normalized = 0,
			children = {
				"node_592db669-6d46-45a9-aa87-c66bc5d52a53",
				"node_f33e4491-1a9b-444b-b4f8-835aa37a6a87",
				"node_7b4e0ecc-fba4-418c-a34c-8ae1739e341c",
				"node_c2759b06-3158-4d95-a860-492fd3b6594e"
			},
			parents = {
				"node_dafc9b1b-859e-44df-bea9-33fecbd3afc7",
				"node_8e7a1179-6cbd-4f0d-9992-a0ca5282b30b",
				"node_7b4e0ecc-fba4-418c-a34c-8ae1739e341c"
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
			widget_name = "node_26e1692a-d918-4407-915d-026f8957efe0",
			y = 802.3185732681139,
			y_normalized = 0,
			talent = "base_warp_charge_node_buff_low_4",
			x = 834.177001953125,
			x_normalized = 0,
			children = {
				"node_ebeb44ed-54d4-44f6-a211-f7060668f98a",
				"node_25cef95d-234f-4299-a964-2ca42056cb5a"
			},
			parents = {
				"node_88eb687e-bd2e-449e-b198-1bd2318eeda1",
				"node_58a8d92f-0b8c-43c4-ac80-f0c597fffc54"
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
			widget_name = "node_6059d69d-2c39-48eb-a87a-05bfb38aea89",
			y = 802.3185835306622,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_low_4",
			x = 1216.4779052734375,
			x_normalized = 0,
			children = {
				"node_dafc9b1b-859e-44df-bea9-33fecbd3afc7",
				"node_8e7a1179-6cbd-4f0d-9992-a0ca5282b30b"
			},
			parents = {
				"node_35ce2086-9081-49c7-9703-f3c07eb0be86",
				"node_88eb687e-bd2e-449e-b198-1bd2318eeda1"
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
			widget_name = "node_e45f9fa0-1a78-47b4-9f04-c69857e46a6d",
			y = 1758.0708024016521,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_low_5",
			x = 802.318603515625,
			x_normalized = 0,
			children = {
				"node_427cefce-0443-4754-becd-ae4967e84f5a",
				"node_1a3b8fd0-026d-4a46-b89e-6c1889f85a78"
			},
			parents = {
				"node_b2a9dab7-310f-4938-a070-97187d356f75",
				"node_57581786-6c2f-45d1-a396-8e58299d84d8"
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
			widget_name = "node_8f13724d-f213-4559-969e-74dcf1053468",
			y = 1949.2211930266521,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_5",
			x = 802.318603515625,
			x_normalized = 0,
			children = {
				"node_25c8ee81-d16b-4d5b-b0fa-fc1e7b40c26f"
			},
			parents = {
				"node_427cefce-0443-4754-becd-ae4967e84f5a",
				"node_1a3b8fd0-026d-4a46-b89e-6c1889f85a78"
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
			widget_name = "node_50f4db9f-a576-43cf-b4a3-a96996f103a6",
			y = 1758.0708024016521,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_4",
			x = 1025.327392578125,
			x_normalized = 0,
			children = {
				"node_8d367c1d-ce78-44f3-a7b8-6a4b55341929"
			},
			parents = {
				"node_502ba655-95d9-419a-a825-c688915e2983",
				"node_25ffe424-4f39-4206-8304-66333fe44fa5"
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
			widget_name = "node_28f80048-978b-420d-b0f8-8d3883a36334",
			y = 1758.0708024016521,
			y_normalized = 0,
			talent = "base_movement_speed_node_buff_low_1",
			x = 1248.3363037109375,
			x_normalized = 0,
			children = {
				"node_9674b583-7566-4f0c-a334-99e83f4715b2",
				"node_e3d09295-0206-4166-91c4-2371e8abf9e3"
			},
			parents = {
				"node_59a39703-43ce-432e-b853-c80517a08947",
				"node_237fc277-fe42-473b-aeda-70d82fc2d9e8"
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
			widget_name = "node_012fb3aa-bcfb-429b-8bd9-376cd7ad7915",
			y = 1631.6371465362276,
			y_normalized = 0,
			talent = "psyker_overcharge_stance_infinite_casting",
			icon = "content/ui/textures/icons/talents/psyker/psyker_overcharge_infinite_casting",
			x = 1567.92041015625,
			x_normalized = 0,
			children = {},
			parents = {
				"node_79ffb5f6-b82f-47c0-8eeb-5e28dcb2766a",
				"node_17c2bf3f-7235-4e00-be33-5931be3bb011"
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
			widget_name = "node_f33e4491-1a9b-444b-b4f8-835aa37a6a87",
			y = 994.4690224976664,
			y_normalized = 0,
			talent = "psyker_melee_attack_speed",
			icon = "content/ui/textures/icons/talents/psyker/psyker_melee_attack_speed",
			x = 1313.0531005859375,
			x_normalized = 0,
			children = {
				"node_3d79a0fe-26e0-4ff4-9ecd-6b5d4b228404",
				"node_c648889c-ff07-4664-81b7-b9fafcd93a04",
				"node_4315ba13-1c64-4293-981d-9bd75a1c6612"
			},
			parents = {
				"node_9049de9c-7aef-4bda-bc26-2892d147c486"
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
			widget_name = "node_c648889c-ff07-4664-81b7-b9fafcd93a04",
			y = 1090.0442483277445,
			y_normalized = 0,
			talent = "psyker_cleave_from_peril",
			icon = "content/ui/textures/icons/talents/psyker/psyker_cleave_from_peril",
			x = 1408.6282958984375,
			x_normalized = 0,
			children = {},
			parents = {
				"node_f33e4491-1a9b-444b-b4f8-835aa37a6a87"
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
			widget_name = "node_4315ba13-1c64-4293-981d-9bd75a1c6612",
			y = 994.4690224976664,
			y_normalized = 0,
			talent = "psyker_killing_enemy_with_warpfire_boosts",
			icon = "content/ui/textures/icons/talents/psyker/psyker_nearby_soulblaze_reduced_damage",
			x = 1440.4866943359375,
			x_normalized = 0,
			children = {},
			parents = {
				"node_f33e4491-1a9b-444b-b4f8-835aa37a6a87"
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
			widget_name = "node_3d79a0fe-26e0-4ff4-9ecd-6b5d4b228404",
			y = 1090.0442483277445,
			y_normalized = 0,
			talent = "psyker_melee_weaving",
			icon = "content/ui/textures/icons/talents/psyker/psyker_blocking_soulblaze",
			x = 1313.0531005859375,
			x_normalized = 0,
			children = {},
			parents = {
				"node_f33e4491-1a9b-444b-b4f8-835aa37a6a87"
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
			widget_name = "node_427cefce-0443-4754-becd-ae4967e84f5a",
			y = 1854.6459977141521,
			y_normalized = 0,
			talent = "psyker_warp_glass_cannon",
			icon = "content/ui/textures/icons/talents/psyker/psyker_warp_glass_cannon",
			x = 739.6017456054688,
			x_normalized = 0,
			children = {
				"node_8f13724d-f213-4559-969e-74dcf1053468"
			},
			parents = {
				"node_e45f9fa0-1a78-47b4-9f04-c69857e46a6d"
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
			widget_name = "node_1a3b8fd0-026d-4a46-b89e-6c1889f85a78",
			y = 1854.6459977141521,
			y_normalized = 0,
			talent = "psyker_warp_attacks_rending",
			icon = "content/ui/textures/icons/talents/psyker/psyker_warp_attacks_rending",
			x = 867.035400390625,
			x_normalized = 0,
			children = {
				"node_8f13724d-f213-4559-969e-74dcf1053468"
			},
			parents = {
				"node_e45f9fa0-1a78-47b4-9f04-c69857e46a6d"
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
			widget_name = "node_237fc277-fe42-473b-aeda-70d82fc2d9e8",
			y = 1663.495546053996,
			y_normalized = 0,
			talent = "psyker_ranged_crits_vent",
			icon = "content/ui/textures/icons/talents/psyker/psyker_ranged_shots_soulblaze",
			x = 1313.0531005859375,
			x_normalized = 0,
			children = {
				"node_28f80048-978b-420d-b0f8-8d3883a36334"
			},
			parents = {
				"node_3f52126e-dbc7-492b-912d-26e4cc53a80e"
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
			widget_name = "node_e3d09295-0206-4166-91c4-2371e8abf9e3",
			y = 1854.6459977141521,
			y_normalized = 0,
			talent = "psyker_reload_speed_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker/psyker_soulblaze_reduces_damage_taken",
			x = 1313.0531005859375,
			x_normalized = 0,
			children = {
				"node_3f08eb1a-09e8-4213-ab90-84032e51f7ae"
			},
			parents = {
				"node_28f80048-978b-420d-b0f8-8d3883a36334"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false
			}
		},
		{
			type = "tactical_modifier",
			max_points = 1,
			widget_name = "node_d958faa6-e3ea-4c79-bc84-3477063b09f7",
			y = 869.5353701431139,
			y_normalized = 0,
			talent = "psyker_chain_lightning_heavy_attacks",
			icon = "content/ui/textures/icons/talents/psyker/psyker_chain_lightning_heavy_attacks",
			x = 1028.827392578125,
			x_normalized = 0,
			children = {},
			parents = {
				"node_88eb687e-bd2e-449e-b198-1bd2318eeda1"
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
			widget_name = "node_25ffe424-4f39-4206-8304-66333fe44fa5",
			y = 1663.495546053996,
			y_normalized = 0,
			talent = "psyker_alternative_peril_explosion",
			icon = "content/ui/textures/icons/talents/psyker/psyker_alternative_peril_explosion",
			x = 1090.044189453125,
			x_normalized = 0,
			children = {
				"node_50f4db9f-a576-43cf-b4a3-a96996f103a6"
			},
			parents = {
				"node_bad7157a-70c9-4b5a-80c5-c4930b8c16d8"
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
			widget_name = "node_f0bb8060-6afc-4ae9-954d-3817cc054b35",
			y = 993.4690211473311,
			y_normalized = 0,
			talent = "psyker_force_staff_bonus",
			icon = "content/ui/textures/icons/talents/psyker/psyker_force_staff_bonus",
			x = 617.2200317382812,
			x_normalized = 0,
			children = {
				"node_33f800cc-9538-4964-ac84-bfb3751c70a9",
				"node_4badc199-b432-420c-ae2f-9d13a253a48d",
				"node_41dad090-f3f7-4ee5-8402-25d97161a590",
				"node_9c3b1d9e-e531-47f1-bd27-e0a8ff27b50e"
			},
			parents = {
				"node_96081a40-cced-4558-9427-b2aabca97e0c"
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
			widget_name = "node_96081a40-cced-4558-9427-b2aabca97e0c",
			y = 994.4690224976664,
			y_normalized = 0,
			talent = "psyker_force_staff_wield_speed",
			icon = "content/ui/textures/icons/talents/psyker/psyker_force_staff_melee_attack_bonus",
			x = 745.6640014648438,
			x_normalized = 0,
			children = {
				"node_f0bb8060-6afc-4ae9-954d-3817cc054b35",
				"node_de28df8a-4aed-426c-8122-73893a04aa5b"
			},
			parents = {
				"node_7b4e0ecc-fba4-418c-a34c-8ae1739e341c"
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
			widget_name = "node_de28df8a-4aed-426c-8122-73893a04aa5b",
			y = 1098.885009765625,
			y_normalized = 0,
			talent = "psyker_force_staff_quick_attack_bonus",
			icon = "content/ui/textures/icons/talents/psyker/psyker_force_staff_quick_attack_bonus",
			x = 649.3309936523438,
			x_normalized = 0,
			children = {},
			parents = {
				"node_96081a40-cced-4558-9427-b2aabca97e0c"
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
		4096
	}
}
