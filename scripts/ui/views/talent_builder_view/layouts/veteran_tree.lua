return {
	name = "veteran_tree",
	node_points = 30,
	version = 18,
	background_height = 2860,
	archetype_name = "veteran",
	talent_points = 30,
	nodes = {
		{
			type = "start",
			max_points = 1,
			widget_name = "node_8376d017-537b-45f4-b3c5-e653fd1ac6d2",
			y = 430,
			y_normalized = 0,
			talent = "veteran_combat_ability_stance",
			icon = "content/ui/textures/icons/talents/veteran/veteran_default_general_talent",
			x = 1030,
			x_normalized = 0,
			children = {
				"node_864a1e68-33d3-4beb-86ee-e18a6351a637",
				"node_8dae58e9-9625-4e01-ac1b-209a13301c56",
				"node_12b3bc42-7582-41cd-b56e-af8a9685bb15",
				"node_90d61df3-340c-4ddf-b802-ef29d3878e0c",
				"node_62b7b680-7096-40ed-9303-7ba124a5d812",
				"node_41d2b96f-c399-47c0-88c3-9e60a07638fc"
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
			widget_name = "node_6ca44996-e5ae-470c-9546-dca6d66b1095",
			y = 605,
			y_normalized = 0,
			talent = "veteran_coherency_aura_size_increase",
			icon = "content/ui/textures/icons/talents/veteran/veteran_coherency_aura_size_increase",
			x = 905,
			x_normalized = 0,
			children = {
				"node_29b3560b-2a50-46cd-b0bb-352b34897c49"
			},
			parents = {
				"node_8dae58e9-9625-4e01-ac1b-209a13301c56",
				"node_90d61df3-340c-4ddf-b802-ef29d3878e0c"
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
			widget_name = "node_743e6ff1-6bb2-4816-9270-ef9c92d9d376",
			y = 605,
			y_normalized = 0,
			talent = "veteran_aura_elite_kills_restore_grenade",
			icon = "content/ui/textures/icons/talents/veteran/veteran_aura_elite_kills_restore_grenade",
			x = 1085,
			x_normalized = 0,
			children = {
				"node_29b3560b-2a50-46cd-b0bb-352b34897c49"
			},
			parents = {
				"node_8dae58e9-9625-4e01-ac1b-209a13301c56",
				"node_90d61df3-340c-4ddf-b802-ef29d3878e0c"
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
			widget_name = "node_be2f4721-6e3e-4594-9393-6654b6c234cd",
			y = 605,
			y_normalized = 0,
			talent = "veteran_faster_reload_on_non_empty_clips",
			icon = "content/ui/textures/icons/talents/veteran/veteran_faster_reload_on_non_empty_clips",
			x = 1265,
			x_normalized = 0,
			children = {
				"node_4bde1a72-40bd-46ad-950f-8546a48ccb9f"
			},
			parents = {
				"node_864a1e68-33d3-4beb-86ee-e18a6351a637",
				"node_41d2b96f-c399-47c0-88c3-9e60a07638fc"
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
			widget_name = "node_d99d3163-8528-4232-af21-f29cbf453fb1",
			y = 605,
			y_normalized = 0,
			talent = "veteran_reload_speed_on_elite_kill",
			icon = "content/ui/textures/icons/talents/veteran/veteran_reload_speed_on_elite_kill",
			x = 725,
			x_normalized = 0,
			children = {
				"node_0800a598-65f0-4293-a838-43c21ce1849c"
			},
			parents = {
				"node_864a1e68-33d3-4beb-86ee-e18a6351a637",
				"node_62b7b680-7096-40ed-9303-7ba124a5d812"
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
			widget_name = "node_a6dcece9-435c-4d88-83a6-8c58bd9240b9",
			y = 605,
			y_normalized = 0,
			talent = "veteran_increase_suppression",
			icon = "content/ui/textures/icons/talents/veteran/veteran_increase_suppression",
			x = 545,
			x_normalized = 0,
			children = {
				"node_0800a598-65f0-4293-a838-43c21ce1849c"
			},
			parents = {
				"node_12b3bc42-7582-41cd-b56e-af8a9685bb15",
				"node_62b7b680-7096-40ed-9303-7ba124a5d812"
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
			widget_name = "node_7e94349b-d6c6-446e-bb39-0b367f6477bf",
			y = 605,
			y_normalized = 0,
			talent = "veteran_crits_apply_rending",
			icon = "content/ui/textures/icons/talents/veteran/veteran_crits_apply_rending",
			x = 1445,
			x_normalized = 0,
			children = {
				"node_4bde1a72-40bd-46ad-950f-8546a48ccb9f"
			},
			parents = {
				"node_12b3bc42-7582-41cd-b56e-af8a9685bb15",
				"node_41d2b96f-c399-47c0-88c3-9e60a07638fc"
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
			widget_name = "node_e0e0d8de-9787-4ecb-b7b8-43cb0eb133d9",
			y = 2464,
			y_normalized = 0,
			talent = "base_toughness_node_buff_medium_1",
			icon = "content/ui/textures/icons/talents/veteran/veteran_default_general_talent",
			x = 1354,
			x_normalized = 0,
			children = {
				"node_7c08ee90-6528-4188-915f-41e330db49f5"
			},
			parents = {
				"node_340ef70a-75c5-4a84-9627-6ccd00409d01"
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
			widget_name = "node_2b1367de-8019-4fe2-9561-222316ba63cb",
			y = 935,
			y_normalized = 0,
			talent = "veteran_extra_grenade_throw_chance",
			icon = "content/ui/textures/icons/talents/veteran/veteran_extra_grenade_throw_chance",
			x = 1265,
			x_normalized = 0,
			children = {
				"node_06b8c8de-0e09-40c9-af16-a6018e9984a8"
			},
			parents = {
				"node_694ecfe2-f3c8-4b6f-866e-ac18e233a434"
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
			widget_name = "node_06b90705-95b0-44bd-b357-bbb061cf0cb4",
			y = 935,
			y_normalized = 0,
			talent = "veteran_all_kills_replenish_toughness",
			icon = "content/ui/textures/icons/talents/veteran/veteran_all_kills_replenish_toughness",
			x = 1445,
			x_normalized = 0,
			children = {
				"node_06b8c8de-0e09-40c9-af16-a6018e9984a8"
			},
			parents = {
				"node_694ecfe2-f3c8-4b6f-866e-ac18e233a434"
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
			widget_name = "node_39129a53-b8c1-4d7e-82bd-e2b9d49315a1",
			y = 2255,
			y_normalized = 0,
			talent = "veteran_increase_damage_after_sprinting",
			icon = "content/ui/textures/icons/talents/veteran/veteran_increase_damage_after_sprinting",
			x = 1265,
			x_normalized = 0,
			children = {
				"node_340ef70a-75c5-4a84-9627-6ccd00409d01"
			},
			parents = {
				"node_d3b3904b-a497-4ac9-b885-ae8ebc13410c"
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
			widget_name = "node_a8044c1f-dda9-4a0b-b503-d549fd2ad5f9",
			y = 2255,
			y_normalized = 0,
			talent = "veteran_increased_melee_crit_chance_and_melee_finesse",
			icon = "content/ui/textures/icons/talents/veteran/veteran_increased_melee_crit_chance_and_melee_finesse",
			x = 1445,
			x_normalized = 0,
			children = {
				"node_340ef70a-75c5-4a84-9627-6ccd00409d01"
			},
			parents = {
				"node_d0153587-ddb9-4325-b48a-166fd86624bb"
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
			widget_name = "node_4bde1a72-40bd-46ad-950f-8546a48ccb9f",
			y = 710,
			y_normalized = 0,
			talent = "veteran_smoke_grenade",
			icon = "content/ui/textures/icons/talents/veteran/veteran_blitz_smoke_grenade",
			x = 1340,
			x_normalized = 0,
			children = {
				"node_694ecfe2-f3c8-4b6f-866e-ac18e233a434"
			},
			parents = {
				"node_7e94349b-d6c6-446e-bb39-0b367f6477bf",
				"node_be2f4721-6e3e-4594-9393-6654b6c234cd"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "blitz"
			}
		},
		{
			type = "ability",
			max_points = 1,
			widget_name = "node_04923c84-a6e7-428b-9074-19b157f088bb",
			y = 1359,
			y_normalized = 0,
			talent = "veteran_invisibility_on_combat_ability",
			icon = "content/ui/textures/icons/talents/veteran/veteran_ability_undercover",
			x = 1329,
			x_normalized = 0,
			children = {
				"node_fa0ae054-51ac-4488-90ee-58d24f90fb63",
				"node_4f9d7c7d-ae7e-4d54-afc0-298eedca8342",
				"node_af5f3f23-6829-4999-8cc8-b93639b6729d",
				"node_6469a1ec-589f-49a3-a53e-3676c3181dad",
				"node_a85c31ac-40a1-48e3-8585-0e04d85adfcf"
			},
			parents = {
				"node_c6d92993-58ab-4f1c-ac76-0e3b36af29a5",
				"node_8c9efccd-3b95-45aa-a620-98f9d4d7133e"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "combat"
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_c6d92993-58ab-4f1c-ac76-0e3b36af29a5",
			y = 1265,
			y_normalized = 0,
			talent = "veteran_movement_speed_towards_downed",
			icon = "content/ui/textures/icons/talents/veteran/veteran_movement_speed_towards_downed",
			x = 1445,
			x_normalized = 0,
			children = {
				"node_04923c84-a6e7-428b-9074-19b157f088bb"
			},
			parents = {
				"node_e617d07a-cf6b-4672-8d2a-7b423ce61803"
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
			widget_name = "node_4f9d7c7d-ae7e-4d54-afc0-298eedca8342",
			y = 1505,
			y_normalized = 0,
			talent = "veteran_damage_bonus_leaving_invisibility",
			icon = "content/ui/textures/icons/talents/veteran/veteran_damage_bonus_leaving_invisibility",
			x = 1445,
			x_normalized = 0,
			children = {},
			parents = {
				"node_04923c84-a6e7-428b-9074-19b157f088bb"
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
			widget_name = "node_8c9efccd-3b95-45aa-a620-98f9d4d7133e",
			y = 1265,
			y_normalized = 0,
			talent = "veteran_extra_grenade",
			icon = "content/ui/textures/icons/talents/veteran/veteran_extra_grenade",
			x = 1265,
			x_normalized = 0,
			children = {
				"node_04923c84-a6e7-428b-9074-19b157f088bb"
			},
			parents = {
				"node_e617d07a-cf6b-4672-8d2a-7b423ce61803"
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
			widget_name = "node_316c1c83-a411-4b99-bda1-b64c3fc31338",
			y = 1894,
			y_normalized = 0,
			talent = "base_stamina_regen_delay_1",
			icon = "content/ui/textures/icons/talents/veteran/veteran_default_general_talent",
			x = 1354,
			x_normalized = 0,
			children = {
				"node_74b661bf-16f2-459d-b2ae-4c0f784ae306",
				"node_9971a100-0ec5-4252-a20f-f33e94a34442",
				"node_96335f86-60f8-46e4-a6df-47c0a4ee2719"
			},
			parents = {
				"node_38aad78e-4d8f-4fba-b66c-947b4486f34e",
				"node_8c17e249-1082-43cd-82b1-42e18c7f29e8"
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
			widget_name = "node_c36508a3-b4f2-4b5a-837e-132101c8739d",
			y = 2345,
			y_normalized = 0,
			talent = "veteran_rending_bonus",
			icon = "content/ui/textures/icons/talents/veteran/veteran_rending_bonus",
			x = 995,
			x_normalized = 0,
			children = {
				"node_33819d8f-8635-4356-97b1-4cf1d67dd6d5"
			},
			parents = {
				"node_7163a098-c55a-47f0-a861-38509acc0d44",
				"node_efcadf37-2626-40eb-b9e5-5baecdcecd0a"
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
			widget_name = "node_06b8c8de-0e09-40c9-af16-a6018e9984a8",
			y = 1040,
			y_normalized = 0,
			talent = "veteran_movement_speed_coherency",
			icon = "content/ui/textures/icons/talents/veteran/veteran_aura_assault_unit",
			x = 1340,
			x_normalized = 0,
			children = {
				"node_e617d07a-cf6b-4672-8d2a-7b423ce61803"
			},
			parents = {
				"node_06b90705-95b0-44bd-b357-bbb061cf0cb4",
				"node_2b1367de-8019-4fe2-9561-222316ba63cb"
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
			widget_name = "node_8c17e249-1082-43cd-82b1-42e18c7f29e8",
			y = 1805,
			y_normalized = 0,
			talent = "veteran_dodging_grants_crit",
			icon = "content/ui/textures/icons/talents/veteran/veteran_dodging_grants_crit",
			x = 1265,
			x_normalized = 0,
			children = {
				"node_316c1c83-a411-4b99-bda1-b64c3fc31338"
			},
			parents = {
				"node_e17c1b44-cbfd-4f58-bc7e-dc80ff90fbcc"
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
			widget_name = "node_38aad78e-4d8f-4fba-b66c-947b4486f34e",
			y = 1805,
			y_normalized = 0,
			talent = "veteran_kill_grants_damage_to_other_slot",
			icon = "content/ui/textures/icons/talents/veteran/veteran_kill_grants_damage_to_other_slot",
			x = 1445,
			x_normalized = 0,
			children = {
				"node_316c1c83-a411-4b99-bda1-b64c3fc31338"
			},
			parents = {
				"node_e17c1b44-cbfd-4f58-bc7e-dc80ff90fbcc"
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
			widget_name = "node_9971a100-0ec5-4252-a20f-f33e94a34442",
			y = 1985,
			y_normalized = 0,
			talent = "veteran_hits_cause_bleed",
			icon = "content/ui/textures/icons/talents/veteran/veteran_hits_cause_bleed",
			x = 1265,
			x_normalized = 0,
			children = {
				"node_6dd3ceaa-4d3c-4493-9836-79584c994fcf"
			},
			parents = {
				"node_316c1c83-a411-4b99-bda1-b64c3fc31338"
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
			widget_name = "node_340ef70a-75c5-4a84-9627-6ccd00409d01",
			y = 2345,
			y_normalized = 0,
			talent = "veteran_attack_speed",
			icon = "content/ui/textures/icons/talents/veteran/veteran_attack_speed",
			x = 1355,
			x_normalized = 0,
			children = {
				"node_e0e0d8de-9787-4ecb-b7b8-43cb0eb133d9"
			},
			parents = {
				"node_39129a53-b8c1-4d7e-82bd-e2b9d49315a1",
				"node_a8044c1f-dda9-4a0b-b503-d549fd2ad5f9"
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
			widget_name = "node_96335f86-60f8-46e4-a6df-47c0a4ee2719",
			y = 1985,
			y_normalized = 0,
			talent = "veteran_continous_hits_apply_rending",
			icon = "content/ui/textures/icons/talents/veteran/veteran_continous_hits_apply_rending",
			x = 1445,
			x_normalized = 0,
			children = {
				"node_c933a40e-4bf6-4c60-a83f-ed8bbdfb885f",
				"node_6dd3ceaa-4d3c-4493-9836-79584c994fcf"
			},
			parents = {
				"node_316c1c83-a411-4b99-bda1-b64c3fc31338"
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
			widget_name = "node_33819d8f-8635-4356-97b1-4cf1d67dd6d5",
			y = 2464,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_2",
			icon = "content/ui/textures/icons/talents/veteran/veteran_default_general_talent",
			x = 994,
			x_normalized = 0,
			children = {
				"node_93ef2e46-69f8-46b1-a48a-9c35ad057681",
				"node_a546dbd5-a9c7-456c-af69-e4df3eb5da25"
			},
			parents = {
				"node_c36508a3-b4f2-4b5a-837e-132101c8739d"
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
			widget_name = "node_a85c31ac-40a1-48e3-8585-0e04d85adfcf",
			y = 1415,
			y_normalized = 0,
			talent = "veteran_reduced_threat_after_combat_ability",
			icon = "content/ui/textures/icons/talents/veteran/veteran_reduced_threat_when_still",
			x = 1205,
			x_normalized = 0,
			children = {},
			parents = {
				"node_04923c84-a6e7-428b-9074-19b157f088bb"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "left_end_1"
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_3a5e822f-27dd-4ec0-ab2f-ee8638d959af",
			y = 935,
			y_normalized = 0,
			talent = "veteran_replenish_toughness_outside_melee",
			icon = "content/ui/textures/icons/talents/veteran/veteran_replenish_toughness_outside_melee",
			x = 725,
			x_normalized = 0,
			children = {
				"node_5ae6929c-f9fe-43b2-b2d9-079d6737de23"
			},
			parents = {
				"node_07a96f92-1fe9-49e3-810d-b5baa4bf2b1c"
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
			widget_name = "node_40c7bc1e-e4a2-40c1-ab28-459d599cc30b",
			y = 1265,
			y_normalized = 0,
			talent = "veteran_bonus_crit_chance_on_ammo",
			icon = "content/ui/textures/icons/talents/veteran/veteran_bonus_crit_chance_on_ammo",
			x = 725,
			x_normalized = 0,
			children = {
				"node_bbd51147-0e4f-4bec-a020-b23d16efb29a"
			},
			parents = {
				"node_0a263862-582d-4b55-80fa-6978c907efd5"
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
			widget_name = "node_b0c4f49c-fd47-4b1c-9279-82e12dc3ac7d",
			y = 1265,
			y_normalized = 0,
			talent = "veteran_ranged_power_out_of_melee",
			icon = "content/ui/textures/icons/talents/veteran/veteran_ranged_power_out_of_melee",
			x = 545,
			x_normalized = 0,
			children = {
				"node_bbd51147-0e4f-4bec-a020-b23d16efb29a"
			},
			parents = {
				"node_0a263862-582d-4b55-80fa-6978c907efd5"
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
			widget_name = "node_bbd51147-0e4f-4bec-a020-b23d16efb29a",
			y = 1359,
			y_normalized = 0,
			talent = "veteran_combat_ability_elite_and_special_outlines",
			icon = "content/ui/textures/icons/talents/veteran/veteran_ability_volley_fire",
			x = 609,
			x_normalized = 0,
			children = {
				"node_92793f3d-46d0-4a20-a4af-b5fe7ea28b22",
				"node_3843e597-be1c-44dc-b07f-e7b0b2f779dd",
				"node_b40ef26d-5e6e-4f30-87e6-a96091d5ce0a",
				"node_0a5464cb-bd8e-4fbc-87b5-a005d73d809c"
			},
			parents = {
				"node_0c9d022b-d4ea-4a0e-9a0e-84d560eac1f0",
				"node_b0c4f49c-fd47-4b1c-9279-82e12dc3ac7d",
				"node_40c7bc1e-e4a2-40c1-ab28-459d599cc30b"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "combat"
			}
		},
		{
			type = "default",
			max_points = 1,
			widget_name = "node_d195ddb0-73e5-4774-8bd7-e8f93e1e7ab2",
			y = 1985,
			y_normalized = 0,
			talent = "veteran_no_ammo_consumption_on_lasweapon_crit",
			icon = "content/ui/textures/icons/talents/veteran/veteran_no_ammo_consumption_on_lasweapon_crit",
			x = 725,
			x_normalized = 0,
			children = {
				"node_f8ddc6f2-43f9-43b8-8799-716707b3bbd8"
			},
			parents = {
				"node_1d15000d-efbd-44bf-ab63-1cf0134cb4f0"
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
			widget_name = "node_92793f3d-46d0-4a20-a4af-b5fe7ea28b22",
			y = 1415,
			y_normalized = 0,
			talent = "veteran_combat_ability_coherency_outlines",
			icon = "content/ui/textures/icons/talents/veteran/veteran_combat_ability_coherency_outlines",
			x = 485,
			x_normalized = 0,
			children = {},
			parents = {
				"node_bbd51147-0e4f-4bec-a020-b23d16efb29a"
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
			widget_name = "node_92ce0aa9-e7c8-4620-9ad3-de2cedbf9431",
			y = 935,
			y_normalized = 0,
			talent = "veteran_movement_bonuses_on_toughness_broken",
			icon = "content/ui/textures/icons/talents/veteran/veteran_movement_speed_on_toughness_broken",
			x = 545,
			x_normalized = 0,
			children = {
				"node_5ae6929c-f9fe-43b2-b2d9-079d6737de23"
			},
			parents = {
				"node_07a96f92-1fe9-49e3-810d-b5baa4bf2b1c"
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
			widget_name = "node_3843e597-be1c-44dc-b07f-e7b0b2f779dd",
			y = 1505,
			y_normalized = 0,
			talent = "veteran_combat_ability_ranged_roamer_outlines",
			icon = "content/ui/textures/icons/talents/veteran/veteran_combat_ability_ranged_enemies_outlines_ranged_weakspot_damage_bonus",
			x = 725,
			x_normalized = 0,
			children = {
				"node_129ff9f1-a7ba-4556-8617-c63d53c68f7c"
			},
			parents = {
				"node_bbd51147-0e4f-4bec-a020-b23d16efb29a"
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
			widget_name = "node_f0744989-1f87-4da4-aa97-30a821197ed9",
			y = 1805,
			y_normalized = 0,
			talent = "veteran_replenish_toughness_on_weakspot_kill",
			icon = "content/ui/textures/icons/talents/veteran/veteran_replenish_toughness_on_weakspot_kill",
			x = 545,
			x_normalized = 0,
			children = {
				"node_129ff9f1-a7ba-4556-8617-c63d53c68f7c",
				"node_1d15000d-efbd-44bf-ab63-1cf0134cb4f0"
			},
			parents = {
				"node_61b07fc5-4a0a-43cb-ae89-87918f7c201a"
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
			widget_name = "node_af5f3f23-6829-4999-8cc8-b93639b6729d",
			y = 1505,
			y_normalized = 0,
			talent = "veteran_toughness_bonus_leaving_invisibility",
			icon = "content/ui/textures/icons/talents/veteran/veteran_toughness_damage_reduction_during_ability",
			x = 1265,
			x_normalized = 0,
			children = {},
			parents = {
				"node_129ff9f1-a7ba-4556-8617-c63d53c68f7c",
				"node_04923c84-a6e7-428b-9074-19b157f088bb"
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
			widget_name = "node_c56789ed-287a-4fe0-9e94-f50ffabe1992",
			y = 2165,
			y_normalized = 0,
			talent = "veteran_supression_immunity",
			icon = "content/ui/textures/icons/talents/veteran/veteran_supression_immunity",
			x = 635,
			x_normalized = 0,
			children = {
				"node_630f40a6-c9ca-4337-8af3-541d274dbcab",
				"node_9f8799fb-9107-462b-9adb-204b2d257650"
			},
			parents = {
				"node_129ff9f1-a7ba-4556-8617-c63d53c68f7c",
				"node_f8ddc6f2-43f9-43b8-8799-716707b3bbd8"
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
			widget_name = "node_0a5464cb-bd8e-4fbc-87b5-a005d73d809c",
			y = 1505,
			y_normalized = 0,
			talent = "veteran_combat_ability_outlined_kills_extends_duration",
			icon = "content/ui/textures/icons/talents/veteran/veteran_combat_ability_outlined_kills_extends_duration",
			x = 545,
			x_normalized = 0,
			children = {},
			parents = {
				"node_bbd51147-0e4f-4bec-a020-b23d16efb29a"
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
			widget_name = "node_8e3a147f-47f0-42d7-9d5e-fae02c2aa525",
			y = 2464,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_1",
			icon = "content/ui/textures/icons/talents/veteran/veteran_default_general_talent",
			x = 634,
			x_normalized = 0,
			children = {
				"node_891f1d0a-96ac-40b0-8a37-7dd491212599"
			},
			parents = {
				"node_06272211-2d9a-47c7-bf84-8e7ea1eb8a01"
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
			widget_name = "node_7163a098-c55a-47f0-a861-38509acc0d44",
			y = 2255,
			y_normalized = 0,
			talent = "veteran_ally_kills_increase_damage",
			icon = "content/ui/textures/icons/talents/veteran/veteran_ally_kills_increase_damage",
			x = 905,
			x_normalized = 0,
			children = {
				"node_c36508a3-b4f2-4b5a-837e-132101c8739d"
			},
			parents = {
				"node_ad51b981-cdaf-4370-b3df-2575f85c8016"
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
			widget_name = "node_5888acc4-4572-49ef-b277-f38b174bb166",
			y = 935,
			y_normalized = 0,
			talent = "veteran_improved_grenades",
			icon = "content/ui/textures/icons/talents/veteran/veteran_improved_grenades",
			x = 905,
			x_normalized = 0,
			children = {
				"node_bd398c77-960a-41f8-af1c-e4e15ef9ee7d"
			},
			parents = {
				"node_153bb7e9-e848-4663-a681-388180c446ad"
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
			widget_name = "node_efcadf37-2626-40eb-b9e5-5baecdcecd0a",
			y = 2255,
			y_normalized = 0,
			talent = "veteran_allies_in_coherency_share_toughness_gain",
			icon = "content/ui/textures/icons/talents/veteran/veteran_allies_in_coherency_share_toughness_gain",
			x = 1085,
			x_normalized = 0,
			children = {
				"node_c36508a3-b4f2-4b5a-837e-132101c8739d"
			},
			parents = {
				"node_ad51b981-cdaf-4370-b3df-2575f85c8016"
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
			widget_name = "node_29b3560b-2a50-46cd-b0bb-352b34897c49",
			y = 710,
			y_normalized = 0,
			talent = "veteran_krak_grenade",
			icon = "content/ui/textures/icons/talents/veteran/veteran_blitz_krak_grenade",
			x = 980,
			x_normalized = 0,
			children = {
				"node_153bb7e9-e848-4663-a681-388180c446ad"
			},
			parents = {
				"node_6ca44996-e5ae-470c-9546-dca6d66b1095",
				"node_743e6ff1-6bb2-4816-9270-ef9c92d9d376"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "blitz"
			}
		},
		{
			type = "ability",
			max_points = 1,
			widget_name = "node_73319c64-81e7-4234-8fb7-4e65ebb620f5",
			y = 1359,
			y_normalized = 0,
			talent = "veteran_combat_ability_stagger_nearby_enemies",
			icon = "content/ui/textures/icons/talents/veteran/veteran_ability_voice_of_command",
			x = 969,
			x_normalized = 0,
			children = {
				"node_acd02218-225d-418d-ad97-9b9ee7d4c5b1",
				"node_5c3c2498-e9f8-497c-ad3a-a99d5ccfdefd",
				"node_66fbd2b5-f51e-4e1e-a77f-ae8aa2687303"
			},
			parents = {
				"node_525102a2-f841-4434-b141-f126ec88103f",
				"node_8acdddd9-366b-4601-bf16-13574eb1cb24",
				"node_51cd0e84-38e8-4df8-b703-bf34e5b166eb"
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
			widget_name = "node_5c3c2498-e9f8-497c-ad3a-a99d5ccfdefd",
			y = 1505,
			y_normalized = 0,
			talent = "veteran_combat_ability_revive_nearby_allies",
			icon = "content/ui/textures/icons/talents/veteran/veteran_combat_ability_revive_nearby_allies",
			x = 1085,
			x_normalized = 0,
			children = {},
			parents = {
				"node_73319c64-81e7-4234-8fb7-4e65ebb620f5"
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
			widget_name = "node_8acdddd9-366b-4601-bf16-13574eb1cb24",
			y = 1265,
			y_normalized = 0,
			talent = "veteran_replenish_grenades",
			icon = "content/ui/textures/icons/talents/veteran/veteran_replenish_grenades",
			x = 1085,
			x_normalized = 0,
			children = {
				"node_73319c64-81e7-4234-8fb7-4e65ebb620f5"
			},
			parents = {
				"node_e720a653-370e-4ad5-bee4-be9db87ff5f9"
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
			widget_name = "node_f97d772b-7e89-46a8-9327-fdf6ce98acfe",
			y = 1894,
			y_normalized = 0,
			talent = "base_health_node_buff_medium_1",
			icon = "content/ui/textures/icons/talents/veteran/veteran_default_general_talent",
			x = 994,
			x_normalized = 0,
			children = {
				"node_f6d4c7b7-c386-45ad-829c-1101a655c268"
			},
			parents = {
				"node_181e4412-cb3f-4b80-b3f9-10c5bb61d022",
				"node_6dca445f-a83e-442c-89dd-04a1deb408ee"
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
			widget_name = "node_51cd0e84-38e8-4df8-b703-bf34e5b166eb",
			y = 1265,
			y_normalized = 0,
			talent = "veteran_better_deployables",
			icon = "content/ui/textures/icons/talents/veteran/veteran_better_deployables",
			x = 905,
			x_normalized = 0,
			children = {
				"node_73319c64-81e7-4234-8fb7-4e65ebb620f5"
			},
			parents = {
				"node_e720a653-370e-4ad5-bee4-be9db87ff5f9"
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
			widget_name = "node_bd398c77-960a-41f8-af1c-e4e15ef9ee7d",
			y = 1040,
			y_normalized = 0,
			talent = "veteran_increased_damage_coherency",
			icon = "content/ui/textures/icons/talents/veteran/veteran_aura_commanding_presence",
			x = 980,
			x_normalized = 0,
			children = {
				"node_e720a653-370e-4ad5-bee4-be9db87ff5f9"
			},
			parents = {
				"node_5888acc4-4572-49ef-b277-f38b174bb166",
				"node_f607f1a6-5fe0-4814-b534-4177cbe9b2c0"
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
			widget_name = "node_6dca445f-a83e-442c-89dd-04a1deb408ee",
			y = 1805,
			y_normalized = 0,
			talent = "veteran_increase_damage_vs_elites",
			icon = "content/ui/textures/icons/talents/veteran/veteran_increased_damage_vs_elites",
			x = 1085,
			x_normalized = 0,
			children = {
				"node_f97d772b-7e89-46a8-9327-fdf6ce98acfe"
			},
			parents = {
				"node_7faaad0d-aebf-44f2-ba30-6a23ce68d320"
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
			widget_name = "node_f607f1a6-5fe0-4814-b534-4177cbe9b2c0",
			y = 935,
			y_normalized = 0,
			talent = "veteran_replenish_toughness_and_boost_allies",
			icon = "content/ui/textures/icons/talents/veteran/veteran_replenish_toughness_and_boost_allies",
			x = 1085,
			x_normalized = 0,
			children = {
				"node_bd398c77-960a-41f8-af1c-e4e15ef9ee7d"
			},
			parents = {
				"node_153bb7e9-e848-4663-a681-388180c446ad"
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
			widget_name = "node_7faaad0d-aebf-44f2-ba30-6a23ce68d320",
			y = 1715,
			y_normalized = 0,
			talent = "veteran_elite_kills_reduce_cooldown",
			icon = "content/ui/textures/icons/talents/veteran/veteran_elite_kills_reduce_cooldown",
			x = 995,
			x_normalized = 0,
			children = {
				"node_181e4412-cb3f-4b80-b3f9-10c5bb61d022",
				"node_6dca445f-a83e-442c-89dd-04a1deb408ee"
			},
			parents = {
				"node_acd02218-225d-418d-ad97-9b9ee7d4c5b1"
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
			widget_name = "node_ad51b981-cdaf-4370-b3df-2575f85c8016",
			y = 2164,
			y_normalized = 0,
			talent = "base_coherency_regen_node_buff_low_1",
			icon = "content/ui/textures/icons/talents/veteran/veteran_default_general_talent",
			x = 994,
			x_normalized = 0,
			children = {
				"node_7163a098-c55a-47f0-a861-38509acc0d44",
				"node_efcadf37-2626-40eb-b9e5-5baecdcecd0a"
			},
			parents = {
				"node_60000569-87a7-4c75-874b-02b86af43f52",
				"node_ba8679cd-fc19-435d-a317-ebeccb210f87"
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
			widget_name = "node_ba8679cd-fc19-435d-a317-ebeccb210f87",
			y = 2075,
			y_normalized = 0,
			talent = "veteran_elite_kills_replenish_toughness",
			icon = "content/ui/textures/icons/talents/veteran/veteran_elite_kills_replenish_toughness",
			x = 1085,
			x_normalized = 0,
			children = {
				"node_ad51b981-cdaf-4370-b3df-2575f85c8016"
			},
			parents = {
				"node_f6d4c7b7-c386-45ad-829c-1101a655c268"
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
			widget_name = "node_a546dbd5-a9c7-456c-af69-e4df3eb5da25",
			y = 2585,
			y_normalized = 0,
			talent = "veteran_combat_ability_melee_and_ranged_damage_to_coherency",
			icon = "content/ui/textures/icons/talents/veteran/veteran_combat_ability_melee_and_ranged_damage_to_coherency",
			x = 995,
			x_normalized = 0,
			children = {},
			parents = {
				"node_33819d8f-8635-4356-97b1-4cf1d67dd6d5"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "left_end_1"
			}
		},
		{
			type = "ability_modifier",
			max_points = 1,
			widget_name = "node_66fbd2b5-f51e-4e1e-a77f-ae8aa2687303",
			y = 1505,
			y_normalized = 0,
			talent = "veteran_combat_ability_increase_and_restore_toughness_to_coherency",
			icon = "content/ui/textures/icons/talents/veteran/veteran_combat_ability_increase_and_restore_toughness_to_coherency",
			x = 905,
			x_normalized = 0,
			children = {},
			parents = {
				"node_73319c64-81e7-4234-8fb7-4e65ebb620f5"
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
			widget_name = "node_6469a1ec-589f-49a3-a53e-3676c3181dad",
			y = 1415,
			y_normalized = 0,
			talent = "veteran_combat_ability_extra_charge",
			icon = "content/ui/textures/icons/talents/veteran/veteran_combat_ability_extra_charge",
			x = 1505,
			x_normalized = 0,
			children = {},
			parents = {
				"node_04923c84-a6e7-428b-9074-19b157f088bb"
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
			widget_name = "node_90d61df3-340c-4ddf-b802-ef29d3878e0c",
			y = 515,
			y_normalized = 0,
			talent = "veteran_reduced_toughness_damage_in_coherency",
			icon = "content/ui/textures/icons/talents/veteran/veteran_reduced_toughness_damage_in_coherency",
			x = 995,
			x_normalized = 0,
			children = {
				"node_6ca44996-e5ae-470c-9546-dca6d66b1095",
				"node_743e6ff1-6bb2-4816-9270-ef9c92d9d376"
			},
			parents = {
				"node_8376d017-537b-45f4-b3c5-e653fd1ac6d2"
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
			widget_name = "node_62b7b680-7096-40ed-9303-7ba124a5d812",
			y = 515,
			y_normalized = 0,
			talent = "veteran_increased_damage_based_on_range",
			icon = "content/ui/textures/icons/talents/veteran/veteran_increased_damage_based_on_range",
			x = 635,
			x_normalized = 0,
			children = {
				"node_d99d3163-8528-4232-af21-f29cbf453fb1",
				"node_a6dcece9-435c-4d88-83a6-8c58bd9240b9"
			},
			parents = {
				"node_8376d017-537b-45f4-b3c5-e653fd1ac6d2"
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
			widget_name = "node_41d2b96f-c399-47c0-88c3-9e60a07638fc",
			y = 515,
			y_normalized = 0,
			talent = "veteran_reduce_sprinting_cost",
			icon = "content/ui/textures/icons/talents/veteran/veteran_reduce_sprinting_cost",
			x = 1355,
			x_normalized = 0,
			children = {
				"node_7e94349b-d6c6-446e-bb39-0b367f6477bf",
				"node_be2f4721-6e3e-4594-9393-6654b6c234cd"
			},
			parents = {
				"node_8376d017-537b-45f4-b3c5-e653fd1ac6d2"
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
			widget_name = "node_416f354e-b04f-4749-9b7d-b6aa72168637",
			y = 1985,
			y_normalized = 0,
			talent = "veteran_increased_weakspot_damage",
			icon = "content/ui/textures/icons/talents/veteran/veteran_default_offensive_talent",
			x = 545,
			x_normalized = 0,
			children = {
				"node_f8ddc6f2-43f9-43b8-8799-716707b3bbd8"
			},
			parents = {
				"node_1d15000d-efbd-44bf-ab63-1cf0134cb4f0"
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
			widget_name = "node_7adfbd19-7df3-4337-875b-2a9dfa00d378",
			y = 1805,
			y_normalized = 0,
			talent = "veteran_ads_drain_stamina",
			icon = "content/ui/textures/icons/talents/veteran/veteran_ads_drain_stamina",
			x = 725,
			x_normalized = 0,
			children = {
				"node_1d15000d-efbd-44bf-ab63-1cf0134cb4f0"
			},
			parents = {
				"node_e2997cb5-1c4e-4696-925f-fe1d4cf78950"
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
			widget_name = "node_181e4412-cb3f-4b80-b3f9-10c5bb61d022",
			y = 1805,
			y_normalized = 0,
			talent = "veteran_big_game_hunter",
			icon = "content/ui/textures/icons/talents/veteran/veteran_big_game_hunter",
			x = 905,
			x_normalized = 0,
			children = {
				"node_f97d772b-7e89-46a8-9327-fdf6ce98acfe"
			},
			parents = {
				"node_7faaad0d-aebf-44f2-ba30-6a23ce68d320"
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
			widget_name = "node_5ae6929c-f9fe-43b2-b2d9-079d6737de23",
			y = 1040,
			y_normalized = 0,
			talent = "veteran_aura_gain_ammo_on_elite_kill_improved",
			icon = "content/ui/textures/icons/talents/veteran/veteran_aura_scavengers",
			x = 620,
			x_normalized = 0,
			children = {
				"node_0a263862-582d-4b55-80fa-6978c907efd5"
			},
			parents = {
				"node_92ce0aa9-e7c8-4620-9ad3-de2cedbf9431",
				"node_3a5e822f-27dd-4ec0-ab2f-ee8638d959af"
			},
			requirements = {
				min_points_spent = 0,
				children_unlock_points = 1,
				all_parents_chosen = false,
				exclusive_group = "aura"
			}
		},
		{
			type = "tactical",
			max_points = 1,
			widget_name = "node_0800a598-65f0-4293-a838-43c21ce1849c",
			y = 710,
			y_normalized = 0,
			talent = "veteran_grenade_apply_bleed",
			icon = "content/ui/textures/icons/talents/veteran/veteran_blitz_frag_grenade_bleed",
			x = 620,
			x_normalized = 0,
			children = {
				"node_07a96f92-1fe9-49e3-810d-b5baa4bf2b1c"
			},
			parents = {
				"node_d99d3163-8528-4232-af21-f29cbf453fb1",
				"node_a6dcece9-435c-4d88-83a6-8c58bd9240b9"
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
			widget_name = "node_e720a653-370e-4ad5-bee4-be9db87ff5f9",
			y = 1174,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_low_2",
			x = 994,
			x_normalized = 0,
			children = {
				"node_8acdddd9-366b-4601-bf16-13574eb1cb24",
				"node_51cd0e84-38e8-4df8-b703-bf34e5b166eb",
				"node_d0a1f707-5176-4297-b32f-08efc487eb02",
				"node_0a263862-582d-4b55-80fa-6978c907efd5",
				"node_e617d07a-cf6b-4672-8d2a-7b423ce61803"
			},
			parents = {
				"node_bd398c77-960a-41f8-af1c-e4e15ef9ee7d",
				"node_d0a1f707-5176-4297-b32f-08efc487eb02",
				"node_0a263862-582d-4b55-80fa-6978c907efd5",
				"node_e617d07a-cf6b-4672-8d2a-7b423ce61803"
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
			widget_name = "node_0a263862-582d-4b55-80fa-6978c907efd5",
			y = 1174,
			y_normalized = 0,
			talent = "base_reload_speed_node_buff_low_1",
			x = 634,
			x_normalized = 0,
			children = {
				"node_69c3cc17-56a9-4c39-b702-451bf3d0f5ab",
				"node_d0a1f707-5176-4297-b32f-08efc487eb02",
				"node_0e2e135f-4bcc-4497-9a1b-fc9555cb6105",
				"node_e720a653-370e-4ad5-bee4-be9db87ff5f9",
				"node_b0c4f49c-fd47-4b1c-9279-82e12dc3ac7d",
				"node_40c7bc1e-e4a2-40c1-ab28-459d599cc30b"
			},
			parents = {
				"node_5ae6929c-f9fe-43b2-b2d9-079d6737de23",
				"node_69c3cc17-56a9-4c39-b702-451bf3d0f5ab",
				"node_d0a1f707-5176-4297-b32f-08efc487eb02",
				"node_0e2e135f-4bcc-4497-9a1b-fc9555cb6105",
				"node_e720a653-370e-4ad5-bee4-be9db87ff5f9"
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
			widget_name = "node_e617d07a-cf6b-4672-8d2a-7b423ce61803",
			y = 1174,
			y_normalized = 0,
			talent = "base_crit_chance_node_buff_low_2",
			x = 1354,
			x_normalized = 0,
			children = {
				"node_c6d92993-58ab-4f1c-ac76-0e3b36af29a5",
				"node_8c9efccd-3b95-45aa-a620-98f9d4d7133e",
				"node_0e2e135f-4bcc-4497-9a1b-fc9555cb6105",
				"node_e720a653-370e-4ad5-bee4-be9db87ff5f9"
			},
			parents = {
				"node_06b8c8de-0e09-40c9-af16-a6018e9984a8",
				"node_0e2e135f-4bcc-4497-9a1b-fc9555cb6105",
				"node_e720a653-370e-4ad5-bee4-be9db87ff5f9"
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
			widget_name = "node_694ecfe2-f3c8-4b6f-866e-ac18e233a434",
			y = 844,
			y_normalized = 0,
			talent = "base_melee_damage_node_buff_low_2",
			x = 1354,
			x_normalized = 0,
			children = {
				"node_2b1367de-8019-4fe2-9561-222316ba63cb",
				"node_06b90705-95b0-44bd-b357-bbb061cf0cb4",
				"node_153bb7e9-e848-4663-a681-388180c446ad"
			},
			parents = {
				"node_4bde1a72-40bd-46ad-950f-8546a48ccb9f",
				"node_153bb7e9-e848-4663-a681-388180c446ad"
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
			widget_name = "node_07a96f92-1fe9-49e3-810d-b5baa4bf2b1c",
			y = 844,
			y_normalized = 0,
			talent = "base_ranged_damage_node_buff_low_1",
			x = 634,
			x_normalized = 0,
			children = {
				"node_153bb7e9-e848-4663-a681-388180c446ad",
				"node_3a5e822f-27dd-4ec0-ab2f-ee8638d959af",
				"node_92ce0aa9-e7c8-4620-9ad3-de2cedbf9431"
			},
			parents = {
				"node_0800a598-65f0-4293-a838-43c21ce1849c",
				"node_153bb7e9-e848-4663-a681-388180c446ad"
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
			widget_name = "node_153bb7e9-e848-4663-a681-388180c446ad",
			y = 844,
			y_normalized = 0,
			talent = "base_health_node_buff_low_2",
			x = 994,
			x_normalized = 0,
			children = {
				"node_07a96f92-1fe9-49e3-810d-b5baa4bf2b1c",
				"node_694ecfe2-f3c8-4b6f-866e-ac18e233a434",
				"node_5888acc4-4572-49ef-b277-f38b174bb166",
				"node_f607f1a6-5fe0-4814-b534-4177cbe9b2c0"
			},
			parents = {
				"node_29b3560b-2a50-46cd-b0bb-352b34897c49",
				"node_694ecfe2-f3c8-4b6f-866e-ac18e233a434",
				"node_07a96f92-1fe9-49e3-810d-b5baa4bf2b1c"
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
			widget_name = "node_acd02218-225d-418d-ad97-9b9ee7d4c5b1",
			y = 1594,
			y_normalized = 0,
			talent = "base_stamina_node_buff_low_1",
			x = 994,
			x_normalized = 0,
			children = {
				"node_b40ef26d-5e6e-4f30-87e6-a96091d5ce0a",
				"node_fa0ae054-51ac-4488-90ee-58d24f90fb63",
				"node_7faaad0d-aebf-44f2-ba30-6a23ce68d320"
			},
			parents = {
				"node_73319c64-81e7-4234-8fb7-4e65ebb620f5",
				"node_b40ef26d-5e6e-4f30-87e6-a96091d5ce0a",
				"node_fa0ae054-51ac-4488-90ee-58d24f90fb63"
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
			widget_name = "node_fa0ae054-51ac-4488-90ee-58d24f90fb63",
			y = 1594,
			y_normalized = 0,
			talent = "base_suppression_node_buff_low_1",
			x = 1354,
			x_normalized = 0,
			children = {
				"node_e17c1b44-cbfd-4f58-bc7e-dc80ff90fbcc",
				"node_acd02218-225d-418d-ad97-9b9ee7d4c5b1"
			},
			parents = {
				"node_04923c84-a6e7-428b-9074-19b157f088bb",
				"node_acd02218-225d-418d-ad97-9b9ee7d4c5b1"
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
			widget_name = "node_b40ef26d-5e6e-4f30-87e6-a96091d5ce0a",
			y = 1594,
			y_normalized = 0,
			talent = "base_ranged_damage_node_buff_low_2",
			x = 634,
			x_normalized = 0,
			children = {
				"node_acd02218-225d-418d-ad97-9b9ee7d4c5b1",
				"node_e2997cb5-1c4e-4696-925f-fe1d4cf78950",
				"node_61b07fc5-4a0a-43cb-ae89-87918f7c201a"
			},
			parents = {
				"node_acd02218-225d-418d-ad97-9b9ee7d4c5b1",
				"node_bbd51147-0e4f-4bec-a020-b23d16efb29a"
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
			widget_name = "node_06272211-2d9a-47c7-bf84-8e7ea1eb8a01",
			y = 2345,
			y_normalized = 0,
			talent = "veteran_ammo_increase",
			icon = "content/ui/textures/icons/talents/veteran/veteran_ammo_increase",
			x = 635,
			x_normalized = 0,
			children = {
				"node_8e3a147f-47f0-42d7-9d5e-fae02c2aa525"
			},
			parents = {
				"node_630f40a6-c9ca-4337-8af3-541d274dbcab",
				"node_9f8799fb-9107-462b-9adb-204b2d257650"
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
			widget_name = "node_e17c1b44-cbfd-4f58-bc7e-dc80ff90fbcc",
			y = 1715,
			y_normalized = 0,
			talent = "veteran_dodging_grants_stamina",
			icon = "content/ui/textures/icons/talents/veteran/veteran_dodging_grants_stamina",
			x = 1355,
			x_normalized = 0,
			children = {
				"node_8c17e249-1082-43cd-82b1-42e18c7f29e8",
				"node_38aad78e-4d8f-4fba-b66c-947b4486f34e"
			},
			parents = {
				"node_fa0ae054-51ac-4488-90ee-58d24f90fb63"
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
			widget_name = "node_60000569-87a7-4c75-874b-02b86af43f52",
			y = 2075,
			y_normalized = 0,
			talent = "veteran_tdr_on_high_toughness",
			icon = "content/ui/textures/icons/talents/veteran/veteran_block_break_gives_tdr",
			x = 905,
			x_normalized = 0,
			children = {
				"node_ad51b981-cdaf-4370-b3df-2575f85c8016"
			},
			parents = {
				"node_f6d4c7b7-c386-45ad-829c-1101a655c268"
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
			widget_name = "node_630f40a6-c9ca-4337-8af3-541d274dbcab",
			y = 2254,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_medium_1",
			x = 544,
			x_normalized = 0,
			children = {
				"node_06272211-2d9a-47c7-bf84-8e7ea1eb8a01"
			},
			parents = {
				"node_c56789ed-287a-4fe0-9e94-f50ffabe1992"
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
			widget_name = "node_1d15000d-efbd-44bf-ab63-1cf0134cb4f0",
			y = 1894,
			y_normalized = 0,
			talent = "base_toughness_damage_reduction_node_buff_low_1",
			x = 634,
			x_normalized = 0,
			children = {
				"node_416f354e-b04f-4749-9b7d-b6aa72168637",
				"node_d195ddb0-73e5-4774-8bd7-e8f93e1e7ab2"
			},
			parents = {
				"node_7adfbd19-7df3-4337-875b-2a9dfa00d378",
				"node_f0744989-1f87-4da4-aa97-30a821197ed9"
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
			widget_name = "node_e2997cb5-1c4e-4696-925f-fe1d4cf78950",
			y = 1684,
			y_normalized = 0,
			talent = "base_ranged_damage_node_buff_low_3",
			x = 724,
			x_normalized = 0,
			children = {
				"node_7adfbd19-7df3-4337-875b-2a9dfa00d378"
			},
			parents = {
				"node_b40ef26d-5e6e-4f30-87e6-a96091d5ce0a"
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
			widget_name = "node_d0153587-ddb9-4325-b48a-166fd86624bb",
			y = 2164,
			y_normalized = 0,
			talent = "base_melee_damage_node_buff_low_3",
			x = 1444,
			x_normalized = 0,
			children = {
				"node_a8044c1f-dda9-4a0b-b503-d549fd2ad5f9"
			},
			parents = {
				"node_6dd3ceaa-4d3c-4493-9836-79584c994fcf"
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
			widget_name = "node_f8ddc6f2-43f9-43b8-8799-716707b3bbd8",
			y = 2074,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_3",
			x = 634,
			x_normalized = 0,
			children = {
				"node_c56789ed-287a-4fe0-9e94-f50ffabe1992"
			},
			parents = {
				"node_416f354e-b04f-4749-9b7d-b6aa72168637",
				"node_d195ddb0-73e5-4774-8bd7-e8f93e1e7ab2"
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
			widget_name = "node_f6d4c7b7-c386-45ad-829c-1101a655c268",
			y = 1984,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_4",
			x = 994,
			x_normalized = 0,
			children = {
				"node_60000569-87a7-4c75-874b-02b86af43f52",
				"node_ba8679cd-fc19-435d-a317-ebeccb210f87"
			},
			parents = {
				"node_f97d772b-7e89-46a8-9327-fdf6ce98acfe"
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
			widget_name = "node_6dd3ceaa-4d3c-4493-9836-79584c994fcf",
			y = 2074,
			y_normalized = 0,
			talent = "base_toughness_node_buff_low_5",
			x = 1354,
			x_normalized = 0,
			children = {
				"node_d0153587-ddb9-4325-b48a-166fd86624bb",
				"node_d3b3904b-a497-4ac9-b885-ae8ebc13410c"
			},
			parents = {
				"node_9971a100-0ec5-4252-a20f-f33e94a34442",
				"node_96335f86-60f8-46e4-a6df-47c0a4ee2719"
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
			widget_name = "node_9f8799fb-9107-462b-9adb-204b2d257650",
			y = 2254,
			y_normalized = 0,
			talent = "base_stamina_regen_delay_2",
			x = 724,
			x_normalized = 0,
			children = {
				"node_06272211-2d9a-47c7-bf84-8e7ea1eb8a01"
			},
			parents = {
				"node_c56789ed-287a-4fe0-9e94-f50ffabe1992"
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
			widget_name = "node_d3b3904b-a497-4ac9-b885-ae8ebc13410c",
			y = 2164,
			y_normalized = 0,
			talent = "base_ranged_damage_node_buff_low_4",
			x = 1264,
			x_normalized = 0,
			children = {
				"node_39129a53-b8c1-4d7e-82bd-e2b9d49315a1"
			},
			parents = {
				"node_6dd3ceaa-4d3c-4493-9836-79584c994fcf"
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
			widget_name = "node_61b07fc5-4a0a-43cb-ae89-87918f7c201a",
			y = 1684,
			y_normalized = 0,
			talent = "base_reload_speed_node_buff_low_2",
			x = 544,
			x_normalized = 0,
			children = {
				"node_f0744989-1f87-4da4-aa97-30a821197ed9"
			},
			parents = {
				"node_b40ef26d-5e6e-4f30-87e6-a96091d5ce0a"
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
			widget_name = "node_7c08ee90-6528-4188-915f-41e330db49f5",
			y = 2585,
			y_normalized = 0,
			talent = "veteran_increased_close_damage_after_combat_ability",
			icon = "content/ui/textures/icons/talents/veteran/veteran_increased_close_damage_after_combat_ability",
			x = 1355,
			x_normalized = 0,
			children = {},
			parents = {
				"node_e0e0d8de-9787-4ecb-b7b8-43cb0eb133d9"
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
			widget_name = "node_891f1d0a-96ac-40b0-8a37-7dd491212599",
			y = 2585,
			y_normalized = 0,
			talent = "veteran_increased_weakspot_power_after_combat_ability",
			icon = "content/ui/textures/icons/talents/veteran/veteran_ability_marksman",
			x = 635,
			x_normalized = 0,
			children = {},
			parents = {
				"node_8e3a147f-47f0-42d7-9d5e-fae02c2aa525"
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
