-- chunkname: @scripts/ui/views/talent_builder_view/layouts/psyker_tree.lua

return {
	name = "psyker_tree",
	node_points = 30,
	version = 17,
	background_height = 2800,
	archetype_name = "psyker",
	talent_points = 30,
	nodes = {
		{
			type = "start",
			max_points = 1,
			widget_name = "node_98df89ba-6894-4d94-9a36-a870d3962ba9",
			y = 430,
			y_normalized = 0,
			talent = "not_selected",
			icon = "content/ui/textures/icons/talents/psyker/psyker_default_general_talent",
			x = 1060,
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
			y = 455,
			y_normalized = 0,
			talent = "psyker_toughness_on_warp_kill",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_1_name_2",
			x = 785,
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
			y = 545,
			y_normalized = 0,
			talent = "psyker_toughness_on_vent",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_1_name_3",
			x = 905,
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
			y = 545,
			y_normalized = 0,
			talent = "psyker_warp_charge_generation_generates_toughness",
			icon = "content/ui/textures/icons/talents/psyker/psyker_warp_charge_generation_generates_toughness",
			x = 1145,
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
			y = 455,
			y_normalized = 0,
			talent = "psyker_crits_regen_toughness_movement_speed",
			icon = "content/ui/textures/icons/talents/psyker/psyker_1_tier_4_name_2",
			x = 1265,
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
			y = 605,
			y_normalized = 0,
			talent = "psyker_elite_kills_add_warpfire",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_2_name_3",
			x = 695,
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
			y = 665,
			y_normalized = 0,
			talent = "psyker_chance_to_vent_on_kill",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_base_2",
			x = 1025,
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
			y = 605,
			y_normalized = 0,
			talent = "psyker_crits_empower_next_attack",
			icon = "content/ui/textures/icons/talents/psyker/psyker_1_tier_2_name_3",
			x = 1355,
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
			y = 937.5,
			y_normalized = 0,
			talent = "psyker_smite_on_hit",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_5_name_3",
			x = 637.5,
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
			y = 800,
			y_normalized = 0,
			talent = "psyker_brain_burst_improved",
			icon = "content/ui/textures/icons/talents/psyker/psyker_brain_burst_improved",
			x = 710,
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
			y = 800,
			y_normalized = 0,
			talent = "psyker_grenade_throwing_knives",
			icon = "content/ui/textures/icons/talents/psyker/psyker_blitz_warp_infused_shards",
			x = 1310,
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
			y = 817.5,
			y_normalized = 0,
			talent = "psyker_throwing_knives_piercing",
			icon = "content/ui/textures/icons/talents/psyker/psyker_throwing_knives_piercing",
			x = 1477.5,
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
			y = 830,
			y_normalized = 0,
			talent = "psyker_grenade_chain_lightning",
			icon = "content/ui/textures/icons/talents/psyker/psyker_blitz_chain_lightning",
			x = 1010,
			x_normalized = 0,
			children = {
				"node_4da2356c-4742-4000-9dd3-e6f3ee0280bd",
				"node_8da8c02b-211b-48bc-a170-f06b79b545b9",
				"node_6059d69d-2c39-48eb-a87a-05bfb38aea89",
				"node_26e1692a-d918-4407-915d-026f8957efe0"
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
			y = 1250,
			y_normalized = 0,
			talent = "psyker_aura_damage_vs_elites",
			icon = "content/ui/textures/icons/talents/psyker/psyker_aura_kinetic_presence",
			x = 770,
			x_normalized = 0,
			children = {
				"node_1c90c96d-394f-49e6-8e5c-d5ae5fe44fdb",
				"node_1943527f-b930-43f0-98b6-340d14d596d5"
			},
			parents = {
				"node_579235ed-79b0-4532-8028-6cee7e154d94",
				"node_ff791f9e-aa3a-40e0-b677-8a7b10649495",
				"node_d17100f5-03fb-4f7d-8918-b046bb713b25",
				"node_7b4e0ecc-fba4-418c-a34c-8ae1739e341c",
				"node_abe7fd7e-2bcc-4883-a9bc-8dd192933ee5"
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
			y = 967.5,
			y_normalized = 0,
			talent = "psyker_increased_chain_lightning_size",
			icon = "content/ui/textures/icons/talents/psyker/psyker_3_tier_2_name_1",
			x = 967.5,
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
			y = 817.5,
			y_normalized = 0,
			talent = "psyker_ability_increase_brain_burst_speed",
			icon = "content/ui/textures/icons/talents/psyker/psyker_ability_increase_brain_burst_speed",
			x = 577.5,
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
			y = 1250,
			y_normalized = 0,
			talent = "psyker_cooldown_aura_improved",
			icon = "content/ui/textures/icons/talents/psyker/psyker_aura_seers_presence",
			x = 1010,
			x_normalized = 0,
			children = {
				"node_1943527f-b930-43f0-98b6-340d14d596d5",
				"node_1c28e8f1-c647-401d-80f1-38263a6b616b"
			},
			parents = {
				"node_ff791f9e-aa3a-40e0-b677-8a7b10649495",
				"node_abe7fd7e-2bcc-4883-a9bc-8dd192933ee5"
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
			y = 1569,
			y_normalized = 0,
			talent = "psyker_shout_vent_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker/psyker_shout_vent_warp_charge",
			x = 609,
			x_normalized = 0,
			children = {
				"node_b6b57be7-9aa8-483b-a127-6c1815d452a4",
				"node_3707077c-1f49-4605-9d6a-9fa062edbbf8",
				"node_1f52a8dd-e3bb-400a-85d7-314dd3884ce7",
				"node_15ffb139-928c-406e-a4b5-71c9d5bebadc"
			},
			parents = {
				"node_e7bb75f7-fc49-4ef3-9e47-db8173419886"
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
			y = 1569,
			y_normalized = 0,
			talent = "psyker_combat_ability_stance",
			icon = "content/ui/textures/icons/talents/psyker/psyker_ability_overcharge_stance",
			x = 1389,
			x_normalized = 0,
			children = {
				"node_7e0096b1-511c-4ca6-a4dd-81836758e85c",
				"node_3f52126e-dbc7-492b-912d-26e4cc53a80e",
				"node_229f2961-ef6f-4ccb-942e-8c4945f1f90f",
				"node_17c2bf3f-7235-4e00-be33-5931be3bb011",
				"node_79ffb5f6-b82f-47c0-8eeb-5e28dcb2766a"
			},
			parents = {
				"node_b8bc29fc-5fd2-41dc-89ac-25628444b75a",
				"node_34463b1b-0fff-436a-bcbb-4abc601bd2be"
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
			y = 1685,
			y_normalized = 0,
			talent = "psyker_shout_reduces_warp_charge_generation",
			icon = "content/ui/textures/icons/talents/psyker/psyker_shout_reduces_warp_charge_generation",
			x = 545,
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
			y = 1775,
			y_normalized = 0,
			talent = "psyker_shout_damage_per_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker/psyker_shout_damage_per_warp_charge",
			x = 485,
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
			y = 1775,
			y_normalized = 0,
			talent = "psyker_warpfire_on_shout",
			icon = "content/ui/textures/icons/talents/psyker/psyker_warpfire_on_shout",
			x = 605,
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
			y = 1595,
			y_normalized = 0,
			talent = "psyker_overcharge_weakspot_kill_bonuses",
			icon = "content/ui/textures/icons/talents/psyker/psyker_overcharge_weakspot_kill_bonuses",
			x = 1565,
			x_normalized = 0,
			children = {
				"node_da8959b5-f8dd-4efb-8fee-c1600e6ee831"
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
			y = 1775,
			y_normalized = 0,
			talent = "psyker_overcharge_reduced_toughness_damage_taken",
			icon = "content/ui/textures/icons/talents/psyker/psyker_overcharge_reduced_toughness_damage_taken",
			x = 1595,
			x_normalized = 0,
			children = {
				"node_e14caf37-49e7-4d6d-8d95-22e14ce41a64",
				"node_dbfc4dc4-8eeb-4112-92cf-74bce7deea72"
			},
			parents = {
				"node_17c2bf3f-7235-4e00-be33-5931be3bb011",
				"node_79ffb5f6-b82f-47c0-8eeb-5e28dcb2766a"
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
			y = 1685,
			y_normalized = 0,
			talent = "psyker_overcharge_increased_movement_speed",
			icon = "content/ui/textures/icons/talents/psyker/psyker_overcharge_increased_movement_speed",
			x = 1505,
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
			y = 937.5,
			y_normalized = 0,
			talent = "psyker_throwing_knives_cast_speed",
			icon = "content/ui/textures/icons/talents/psyker/psyker_throwing_knives_reduced_cooldown",
			x = 1447.5,
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
			y = 1250,
			y_normalized = 0,
			talent = "psyker_aura_crit_chance_aura",
			icon = "content/ui/textures/icons/talents/psyker/psyker_aura_gunslinger_aura",
			x = 1250,
			x_normalized = 0,
			children = {
				"node_0c96d4f4-ec5f-41da-aaa8-6507b10c03dd",
				"node_1c28e8f1-c647-401d-80f1-38263a6b616b",
				"node_b64d3e49-d2d6-4565-8195-fba8f68d014c"
			},
			parents = {
				"node_ff791f9e-aa3a-40e0-b677-8a7b10649495",
				"node_9049de9c-7aef-4bda-bc26-2892d147c486",
				"node_abe7fd7e-2bcc-4883-a9bc-8dd192933ee5"
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
			y = 1055,
			y_normalized = 0,
			talent = "psyker_spread_warpfire_on_kill",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_5_name_2",
			x = 695,
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
			y = 1055,
			y_normalized = 0,
			talent = "psyker_2_tier_3_name_2",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_3_name_2",
			x = 875,
			x_normalized = 0,
			children = {
				"node_7b4e0ecc-fba4-418c-a34c-8ae1739e341c",
				"node_abe7fd7e-2bcc-4883-a9bc-8dd192933ee5"
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
			y = 1055,
			y_normalized = 0,
			talent = "psyker_venting_improvements",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_4_name_3",
			x = 1175,
			x_normalized = 0,
			children = {
				"node_9049de9c-7aef-4bda-bc26-2892d147c486",
				"node_abe7fd7e-2bcc-4883-a9bc-8dd192933ee5"
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
			y = 1055,
			y_normalized = 0,
			talent = "psyker_kills_stack_other_weapon_damage",
			icon = "content/ui/textures/icons/talents/psyker/psyker_1_tier_2_name_2",
			x = 1355,
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
			y = 1745,
			y_normalized = 0,
			talent = "psyker_overcharge_reduced_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker/psyker_overcharge_reduced_warp_charge",
			x = 1415,
			x_normalized = 0,
			children = {
				"node_da8959b5-f8dd-4efb-8fee-c1600e6ee831"
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
			y = 967.5,
			y_normalized = 0,
			talent = "psyker_chain_lightning_improved_target_buff",
			icon = "content/ui/textures/icons/talents/psyker/psyker_chain_lightning_improved_target_buff",
			x = 1087.5,
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
			y = 1385,
			y_normalized = 0,
			talent = "psyker_warp_charge_reduces_toughness_damage_taken",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_4_name_2",
			x = 905,
			x_normalized = 0,
			children = {
				"node_e7bb75f7-fc49-4ef3-9e47-db8173419886",
				"node_db36197a-b900-4b31-bfc2-66d251459e29"
			},
			parents = {
				"node_d323e130-860b-42f1-acd2-dc50cacde619",
				"node_c2759b06-3158-4d95-a860-492fd3b6594e"
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
			y = 1385,
			y_normalized = 0,
			talent = "psyker_dodge_after_crits",
			icon = "content/ui/textures/icons/talents/psyker/psyker_1_tier_4_name_1",
			x = 1145,
			x_normalized = 0,
			children = {
				"node_34463b1b-0fff-436a-bcbb-4abc601bd2be",
				"node_db36197a-b900-4b31-bfc2-66d251459e29"
			},
			parents = {
				"node_c2759b06-3158-4d95-a860-492fd3b6594e",
				"node_592db669-6d46-45a9-aa87-c66bc5d52a53"
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
			y = 1385,
			y_normalized = 0,
			talent = "psyker_aura_toughness_on_ally_knocked_down",
			icon = "content/ui/textures/icons/talents/psyker/psyker_3_tier_3_name_1",
			x = 665,
			x_normalized = 0,
			children = {
				"node_e7bb75f7-fc49-4ef3-9e47-db8173419886"
			},
			parents = {
				"node_d323e130-860b-42f1-acd2-dc50cacde619"
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
			y = 1385,
			y_normalized = 0,
			talent = "psyker_improved_dodge",
			icon = "content/ui/textures/icons/talents/psyker/psyker_1_tier_4_name_3",
			x = 1385,
			x_normalized = 0,
			children = {
				"node_34463b1b-0fff-436a-bcbb-4abc601bd2be"
			},
			parents = {
				"node_592db669-6d46-45a9-aa87-c66bc5d52a53"
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
			y = 1474,
			y_normalized = 0,
			talent = "base_warp_charge_node_buff_low_3",
			icon = "content/ui/textures/icons/talents/psyker/psyker_default_general_talent",
			x = 784,
			x_normalized = 0,
			children = {
				"node_650c5469-5194-4722-a4f8-7d62487039df",
				"node_ba340289-3623-4920-b6cb-0a665eff8c0e"
			},
			parents = {
				"node_1943527f-b930-43f0-98b6-340d14d596d5",
				"node_1c90c96d-394f-49e6-8e5c-d5ae5fe44fdb"
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
			y = 1474,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_low_2",
			x = 1024,
			x_normalized = 0,
			children = {
				"node_ba340289-3623-4920-b6cb-0a665eff8c0e"
			},
			parents = {
				"node_1943527f-b930-43f0-98b6-340d14d596d5",
				"node_1c28e8f1-c647-401d-80f1-38263a6b616b"
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
			y = 1474,
			y_normalized = 0,
			talent = "base_ranged_damage_node_buff_low_1",
			x = 1264,
			x_normalized = 0,
			children = {
				"node_ba340289-3623-4920-b6cb-0a665eff8c0e",
				"node_2a022d3f-fddf-4faf-a79d-c8fe6a18fe36"
			},
			parents = {
				"node_1c28e8f1-c647-401d-80f1-38263a6b616b",
				"node_b64d3e49-d2d6-4565-8195-fba8f68d014c"
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
			y = 2045,
			y_normalized = 0,
			talent = "psyker_increased_vent_speed",
			icon = "content/ui/textures/icons/talents/psyker/psyker_3_tier_1_name_3",
			x = 755,
			x_normalized = 0,
			children = {
				"node_3f08eb1a-09e8-4213-ab90-84032e51f7ae"
			},
			parents = {
				"node_e45f9fa0-1a78-47b4-9f04-c69857e46a6d",
				"node_5c4a163b-68e5-4123-80dd-ccf9c5282b76",
				"node_652174b2-b6c8-4ff7-9ba8-087954a21022"
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
			y = 1895,
			y_normalized = 0,
			talent = "psyker_damage_based_on_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker/psyker_damage_based_on_warp_charge",
			x = 1025,
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
			y = 2045,
			y_normalized = 0,
			talent = "psyker_guaranteed_crit_on_multiple_weakspot_hits",
			icon = "content/ui/textures/icons/talents/psyker/psyker_1_tier_2_name_1",
			x = 1295,
			x_normalized = 0,
			children = {
				"node_8f13724d-f213-4559-969e-74dcf1053468"
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
			y = 1865,
			y_normalized = 0,
			talent = "psyker_coherency_aura_size_increase",
			icon = "content/ui/textures/icons/talents/psyker/psyker_1_tier_3_name_1",
			x = 785,
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
			y = 1865,
			y_normalized = 0,
			talent = "psyker_block_costs_warp_charge",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_4_name_1",
			x = 1265,
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
			y = 1599,
			y_normalized = 0,
			talent = "psyker_combat_ability_force_field",
			icon = "content/ui/textures/icons/talents/psyker/psyker_ability_warp_barrier",
			x = 999,
			x_normalized = 0,
			children = {
				"node_a10c7d87-9c54-4268-b6be-ca862dcc59ae",
				"node_15ffb139-928c-406e-a4b5-71c9d5bebadc",
				"node_3f52126e-dbc7-492b-912d-26e4cc53a80e",
				"node_b965d30f-4412-43e5-856a-c571751925a7"
			},
			parents = {
				"node_c6386e49-221f-43c7-b30a-a4d5f415e6e1",
				"node_e7bb75f7-fc49-4ef3-9e47-db8173419886",
				"node_db36197a-b900-4b31-bfc2-66d251459e29",
				"node_34463b1b-0fff-436a-bcbb-4abc601bd2be"
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
			y = 1625,
			y_normalized = 0,
			talent = "psyker_shield_stun_passive",
			icon = "content/ui/textures/icons/talents/psyker/psyker_3_tier_2_name_3",
			x = 875,
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
			y = 1625,
			y_normalized = 0,
			talent = "psyker_boost_allies_in_sphere",
			icon = "content/ui/textures/icons/talents/psyker/psyker_3_tier_4_name_1",
			x = 1265,
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
			y = 1625,
			y_normalized = 0,
			talent = "psyker_sphere_shield",
			icon = "content/ui/textures/icons/talents/psyker/psyker_sphere_shield",
			x = 1175,
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
			y = 1625,
			y_normalized = 0,
			talent = "psyker_shield_extra_charge",
			icon = "content/ui/textures/icons/talents/psyker/psyker_shield_extra_charge",
			x = 785,
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
			y = 724,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_1",
			x = 844,
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
			y = 724,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_2",
			x = 1204,
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
			y = 1774,
			y_normalized = 0,
			talent = "base_warp_charge_node_buff_low_2",
			x = 784,
			x_normalized = 0,
			children = {
				"node_c6386e49-221f-43c7-b30a-a4d5f415e6e1",
				"node_b2a9dab7-310f-4938-a070-97187d356f75",
				"node_bad7157a-70c9-4b5a-80c5-c4930b8c16d8"
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
			y = 1774,
			y_normalized = 0,
			talent = "base_crit_chance_node_buff_low_2",
			x = 1264,
			x_normalized = 0,
			children = {
				"node_c6386e49-221f-43c7-b30a-a4d5f415e6e1",
				"node_59a39703-43ce-432e-b853-c80517a08947",
				"node_bad7157a-70c9-4b5a-80c5-c4930b8c16d8"
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
			y = 2210,
			y_normalized = 0,
			talent = "psyker_passive_souls_from_elite_kills",
			icon = "content/ui/textures/icons/talents/psyker/psyker_keystone_warp_syphon",
			x = 650,
			x_normalized = 0,
			children = {
				"node_3879efd1-ebac-4cd2-b004-8c7927d16924",
				"node_cec906f5-721d-46dd-95e9-78b903190c9d"
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
			widget_name = "node_44ce21ca-9b23-46b9-a6df-eae7ee03114b",
			y = 2210,
			y_normalized = 0,
			talent = "psyker_new_mark_passive",
			icon = "content/ui/textures/icons/talents/psyker/psyker_keystone_unnatural_talent",
			x = 1370,
			x_normalized = 0,
			children = {
				"node_31fbc1eb-b397-449d-adb8-f5c9adb5d883",
				"node_0ee8a9f7-a62a-4bd7-996e-050a9f445d10",
				"node_4941c66a-d4ff-4dca-917f-a6bbf2bbdbfc"
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
			widget_name = "node_8d367c1d-ce78-44f3-a7b8-6a4b55341929",
			y = 2090,
			y_normalized = 0,
			talent = "psyker_empowered_ability",
			icon = "content/ui/textures/icons/talents/psyker/psyker_keystone_empowered_psyche",
			x = 1010,
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
			y = 2255,
			y_normalized = 0,
			talent = "psyker_reduced_warp_charge_cost_and_venting_speed",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_2_name_2",
			x = 545,
			x_normalized = 0,
			children = {
				"node_20f0e5f6-c24d-4e29-809d-d264ecb5613f"
			},
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
			y = 2345,
			y_normalized = 0,
			talent = "psyker_toughness_on_soul",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_1_name_1",
			x = 725,
			x_normalized = 0,
			children = {
				"node_20f0e5f6-c24d-4e29-809d-d264ecb5613f"
			},
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
			y = 2375,
			y_normalized = 0,
			talent = "psyker_souls_increase_damage",
			icon = "content/ui/textures/icons/talents/psyker/psyker_souls_increase_damage",
			x = 605,
			x_normalized = 0,
			children = {
				"node_97dc5762-872f-4746-b48c-2f1f2bd4cca0",
				"node_b5482701-b516-444a-92d4-df82bc410afd",
				"node_97a70547-63e0-473c-9e2f-79096161d4e5"
			},
			parents = {
				"node_3879efd1-ebac-4cd2-b004-8c7927d16924",
				"node_cec906f5-721d-46dd-95e9-78b903190c9d"
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
			y = 2225,
			y_normalized = 0,
			talent = "psyker_empowered_grenades_passive_improved",
			icon = "content/ui/textures/icons/talents/psyker/psyker_3_tier_5_name_2",
			x = 905,
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
			y = 2225,
			y_normalized = 0,
			talent = "psyker_empowered_chain_lightnings_replenish_toughness_to_allies",
			icon = "content/ui/textures/icons/talents/psyker/psyker_3_tier_5_name_1",
			x = 1025,
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
			y = 2225,
			y_normalized = 0,
			talent = "psyker_empowered_ability_on_elite_kills",
			icon = "content/ui/textures/icons/talents/psyker/psyker_empowered_ability_on_elite_kills",
			x = 1145,
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
			y = 2375,
			y_normalized = 0,
			talent = "psyker_mark_increased_max_stacks",
			icon = "content/ui/textures/icons/talents/psyker/psyker_mark_increased_max_stacks",
			x = 1355,
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
			y = 2315,
			y_normalized = 0,
			talent = "psyker_mark_kills_can_vent",
			icon = "content/ui/textures/icons/talents/psyker/psyker_mark_kills_can_vent",
			x = 1445,
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
			y = 2255,
			y_normalized = 0,
			talent = "psyker_mark_increased_duration",
			icon = "content/ui/textures/icons/talents/psyker/psyker_mark_increased_range",
			x = 1535,
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
			y = 2345,
			y_normalized = 0,
			talent = "psyker_empowered_grenades_increased_max_stacks",
			icon = "content/ui/textures/icons/talents/psyker/psyker_3_tier_2_name_2",
			x = 1025,
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
			y = 2405,
			y_normalized = 0,
			talent = "psyker_warpfire_generate_souls",
			icon = "content/ui/textures/icons/talents/psyker/psyker_warpfire_generate_souls",
			x = 485,
			x_normalized = 0,
			children = {
				"node_0eee06a4-3acd-4b44-ae64-61376c34b3da"
			},
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
			y = 2495,
			y_normalized = 0,
			talent = "psyker_aura_souls_on_kill",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_3_name_1",
			x = 665,
			x_normalized = 0,
			children = {
				"node_0eee06a4-3acd-4b44-ae64-61376c34b3da"
			},
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
			y = 2525,
			y_normalized = 0,
			talent = "psyker_increased_max_souls",
			icon = "content/ui/textures/icons/talents/psyker/psyker_2_tier_5_name_1",
			x = 545,
			x_normalized = 0,
			children = {},
			parents = {
				"node_97a70547-63e0-473c-9e2f-79096161d4e5",
				"node_b5482701-b516-444a-92d4-df82bc410afd"
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
			y = 2405,
			y_normalized = 0,
			talent = "psyker_mark_weakspot_kills",
			icon = "content/ui/textures/icons/talents/psyker/psyker_mark_weakspot_kills",
			x = 1505,
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
			y = 1774,
			y_normalized = 0,
			talent = "base_health_node_buff_medium_1",
			x = 1024,
			x_normalized = 0,
			children = {
				"node_502ba655-95d9-419a-a825-c688915e2983",
				"node_3f52126e-dbc7-492b-912d-26e4cc53a80e",
				"node_15ffb139-928c-406e-a4b5-71c9d5bebadc"
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
			y = 2134,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_3",
			x = 724,
			x_normalized = 0,
			children = {
				"node_25c8ee81-d16b-4d5b-b0fa-fc1e7b40c26f"
			},
			parents = {
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
			widget_name = "node_7b4e0ecc-fba4-418c-a34c-8ae1739e341c",
			y = 1144,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_low_1",
			x = 784,
			x_normalized = 0,
			children = {
				"node_d323e130-860b-42f1-acd2-dc50cacde619"
			},
			parents = {
				"node_ebeb44ed-54d4-44f6-a211-f7060668f98a",
				"node_25cef95d-234f-4299-a964-2ca42056cb5a"
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
			y = 1144,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_low_3",
			x = 1264,
			x_normalized = 0,
			children = {
				"node_592db669-6d46-45a9-aa87-c66bc5d52a53"
			},
			parents = {
				"node_dafc9b1b-859e-44df-bea9-33fecbd3afc7",
				"node_8e7a1179-6cbd-4f0d-9992-a0ca5282b30b"
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
			y = 934,
			y_normalized = 0,
			talent = "base_warp_charge_node_buff_low_4",
			x = 784,
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
			y = 934,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_low_4",
			x = 1264,
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
			y = 1954,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_low_5",
			x = 784,
			x_normalized = 0,
			children = {
				"node_57581786-6c2f-45d1-a396-8e58299d84d8"
			},
			parents = {
				"node_b2a9dab7-310f-4938-a070-97187d356f75"
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
			y = 2134,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_5",
			x = 1324,
			x_normalized = 0,
			children = {
				"node_44ce21ca-9b23-46b9-a6df-eae7ee03114b"
			},
			parents = {
				"node_9674b583-7566-4f0c-a334-99e83f4715b2"
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
			y = 1984,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_4",
			x = 1024,
			x_normalized = 0,
			children = {
				"node_8d367c1d-ce78-44f3-a7b8-6a4b55341929"
			},
			parents = {
				"node_502ba655-95d9-419a-a825-c688915e2983"
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
			y = 1954,
			y_normalized = 0,
			talent = "base_movement_speed_node_buff_low_1",
			x = 1264,
			x_normalized = 0,
			children = {
				"node_9674b583-7566-4f0c-a334-99e83f4715b2"
			},
			parents = {
				"node_59a39703-43ce-432e-b853-c80517a08947"
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
			widget_name = "node_abe7fd7e-2bcc-4883-a9bc-8dd192933ee5",
			y = 1114,
			y_normalized = 0,
			talent = "base_coherency_regen_node_buff_low_1",
			x = 1024,
			x_normalized = 0,
			children = {
				"node_d323e130-860b-42f1-acd2-dc50cacde619",
				"node_c2759b06-3158-4d95-a860-492fd3b6594e",
				"node_592db669-6d46-45a9-aa87-c66bc5d52a53"
			},
			parents = {
				"node_dafc9b1b-859e-44df-bea9-33fecbd3afc7",
				"node_25cef95d-234f-4299-a964-2ca42056cb5a"
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
