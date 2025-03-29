-- chunkname: @scripts/settings/havoc_settings.lua

local havoc_settings = {
	chance_for_default_theme = 0.95,
	max_circumstances = 2,
	max_modifier_level = 5,
	num_ranks_per_circumstance = 5,
	num_ranks_per_positive_modifier = 3,
	forced_themes_ranks = {
		5,
		10,
		15,
		20,
		25,
		30,
		35,
	},
	themes = {
		"darkness",
		"ventilation_purge",
		"toxic_gas",
	},
	circumstances_per_theme = {
		darkness = {
			[1] = "darkness_01",
			[2] = "darkness_hunting_grounds_01",
		},
		ventilation_purge = {
			[1] = "ventilation_purge_01",
			[2] = "ventilation_purge_with_snipers_01",
		},
		toxic_gas = {
			[1] = "toxic_gas_01",
			[2] = "toxic_gas_cultist_grenadier",
		},
	},
	missions = {
		default = {
			"cm_archives",
			"cm_habs",
			"cm_raid",
			"dm_forge",
			"dm_propaganda",
			"dm_rise",
			"dm_stockpile",
			"fm_armoury",
			"fm_cargo",
			"fm_resurgence",
			"hm_cartel",
			"hm_complex",
			"hm_strain",
			"km_enforcer",
			"km_station",
			"lm_cooling",
			"lm_rails",
			"lm_scavenge",
			"core_research",
		},
		darkness = {
			"cm_archives",
			"cm_habs",
			"dm_forge",
			"dm_stockpile",
			"fm_armoury",
			"fm_cargo",
			"fm_resurgence",
			"hm_cartel",
			"hm_complex",
			"km_enforcer",
			"km_station",
			"lm_cooling",
			"lm_rails",
		},
		ventilation_purge = {
			"cm_habs",
			"cm_raid",
			"dm_forge",
			"dm_stockpile",
			"fm_armoury",
			"fm_cargo",
			"hm_cartel",
			"km_station",
			"lm_rails",
		},
		toxic_gas = {
			"cm_raid",
			"fm_resurgence",
			"hm_cartel",
			"hm_strain",
			"km_station",
			"lm_cooling",
		},
	},
	factions = {
		"mixed",
		"renegade",
		"cultist",
	},
	circumstances = {
		"mutator_havoc_enemies_corrupted",
		"mutator_havoc_enemies_parasite_headshot",
		"mutator_havoc_armored_infected",
		"mutator_havoc_tougher_skin",
	},
	modifier_templates = {
		buff_elites = {
			{
				modify_elite_health = 0.1,
			},
			{
				modify_elite_health = 0.15,
			},
			{
				modify_elite_health = 0.2,
			},
			{
				modify_elite_health = 0.25,
			},
			{
				modify_elite_health = 0.5,
			},
		},
		more_alive_specials = {
			{
				add_max_alive_specials = 2,
			},
			{
				add_max_alive_specials = 3,
			},
			{
				add_max_alive_specials = 4,
			},
			{
				add_max_alive_specials = 5,
			},
			{
				add_max_alive_specials = 6,
			},
		},
		buff_specials = {
			{
				modify_special_health = 0.1,
			},
			{
				modify_special_health = 0.15,
			},
			{
				modify_special_health = 0.2,
			},
			{
				modify_special_health = 0.25,
			},
			{
				modify_special_health = 0.5,
			},
		},
		buff_monsters = {
			{
				add_num_monsters = 1,
				modify_monster_health = 0.1,
			},
			{
				add_num_monsters = 1,
				modify_monster_health = 0.2,
			},
			{
				add_num_monsters = 2,
				modify_monster_health = 0.3,
			},
			{
				add_num_monsters = 3,
				modify_monster_health = 0.4,
			},
			{
				add_num_monsters = 3,
				modify_monster_health = 0.7,
			},
		},
		buff_horde = {
			{
				modify_horde_health = 0.1,
				modify_horde_hit_mass = 0.4,
			},
			{
				modify_horde_health = 0.15,
				modify_horde_hit_mass = 0.8,
			},
			{
				2,
				modify_horde_health = 0.2,
				modify_horde_hit_mass = 1,
			},
			{
				modify_horde_health = 0.25,
				modify_horde_hit_mass = 1.5,
			},
			{
				modify_horde_health = 0.3,
				modify_horde_hit_mass = 1.7,
			},
		},
		more_elites = {
			{
				add_more_elites = 0.15,
			},
			{
				add_more_elites = 0.35,
			},
			{
				add_more_elites = 0.5,
			},
			{
				add_more_elites = 0.75,
			},
			{
				add_more_elites = 1,
			},
		},
		more_ogryns = {
			{
				add_more_ogryns = 0.15,
			},
			{
				add_more_ogryns = 0.35,
			},
			{
				add_more_ogryns = 0.5,
			},
			{
				add_more_ogryns = 0.75,
			},
			{
				add_more_ogryns = 1,
			},
		},
		melee_minion_attack_speed = {
			{
				melee_minion_attack_speed_buff = "havoc_melee_attack_speed_01",
			},
			{
				melee_minion_attack_speed_buff = "havoc_melee_attack_speed_02",
			},
			{
				melee_minion_attack_speed_buff = "havoc_melee_attack_speed_03",
			},
			{
				melee_minion_attack_speed_buff = "havoc_melee_attack_speed_04",
			},
			{
				melee_minion_attack_speed_buff = "havoc_melee_attack_speed_05",
			},
		},
		ranged_minion_attack_speed = {
			{
				ranged_minion_attack_speed_buff = "havoc_ranged_attack_speed_01",
			},
			{
				ranged_minion_attack_speed_buff = "havoc_ranged_attack_speed_02",
			},
			{
				ranged_minion_attack_speed_buff = "havoc_ranged_attack_speed_03",
			},
			{
				ranged_minion_attack_speed_buff = "havoc_ranged_attack_speed_04",
			},
			{
				ranged_minion_attack_speed_buff = "havoc_ranged_attack_speed_05",
			},
		},
		melee_minion_permanent_damage = {
			{
				melee_minion_permanent_damage_buff = "havoc_melee_permanent_damage_01",
			},
			{
				melee_minion_permanent_damage_buff = "havoc_melee_permanent_damage_02",
			},
			{
				melee_minion_permanent_damage_buff = "havoc_melee_permanent_damage_03",
			},
			{
				melee_minion_permanent_damage_buff = "havoc_melee_permanent_damage_04",
			},
			{
				melee_minion_permanent_damage_buff = "havoc_melee_permanent_damage_05",
			},
		},
		ammo_pickup_modifier = {
			{
				ammo_pickup_modifier = 0.85,
			},
			{
				ammo_pickup_modifier = 0.65,
			},
			{
				ammo_pickup_modifier = 0.5,
			},
			{
				ammo_pickup_modifier = 0.45,
			},
			{
				ammo_pickup_modifier = 0.4,
			},
		},
		horde_spawn_rate_increase = {
			{
				horde_spawn_rate_modifier = 0.2,
			},
			{
				horde_spawn_rate_modifier = 0.4,
			},
			{
				horde_spawn_rate_modifier = 0.6,
			},
			{
				horde_spawn_rate_modifier = 0.8,
			},
			{
				horde_spawn_rate_modifier = 1,
			},
			{
				horde_spawn_rate_modifier = 1.2,
			},
			{
				horde_spawn_rate_modifier = 1.4,
			},
		},
		terror_event_point_increase = {
			{
				terror_event_point_modifier = 0.3,
			},
			{
				terror_event_point_modifier = 0.4,
			},
			{
				terror_event_point_modifier = 0.5,
			},
			{
				terror_event_point_modifier = 0.6,
			},
			{
				terror_event_point_modifier = 0.85,
			},
		},
		melee_minion_power_level_buff = {
			{
				melee_minion_power_level_modifier = 0.1,
			},
			{
				melee_minion_power_level_modifier = 0.2,
			},
			{
				melee_minion_power_level_modifier = 0.3,
			},
			{
				melee_minion_power_level_modifier = 0.4,
			},
			{
				melee_minion_power_level_modifier = 0.5,
			},
		},
		reduce_toughness_regen = {
			{
				add_player_buff = "havoc_toughness_regen_modifier_1",
			},
			{
				add_player_buff = "havoc_toughness_regen_modifier_2",
			},
			{
				add_player_buff = "havoc_toughness_regen_modifier_3",
			},
			{
				add_player_buff = "havoc_toughness_regen_modifier_4",
			},
			{
				add_player_buff = "havoc_toughness_regen_modifier_5",
			},
		},
		reduce_toughness = {
			{
				add_player_buff = "havoc_toughness_modifier_1",
			},
			{
				add_player_buff = "havoc_toughness_modifier_2",
			},
			{
				add_player_buff = "havoc_toughness_modifier_3",
			},
			{
				add_player_buff = "havoc_toughness_modifier_4",
			},
			{
				add_player_buff = "havoc_toughness_modifier_5",
			},
		},
		reduce_health_and_wounds = {
			{
				add_player_buff = "havoc_health_modifier_1",
			},
			{
				add_player_buff = "havoc_health_modifier_2",
			},
			{
				add_player_buff = "havoc_health_modifier_3",
			},
			{
				add_player_buff = "havoc_health_modifier_4",
			},
			{
				add_player_buff = "havoc_health_modifier_5",
			},
		},
		havoc_vent_speed_reduction = {
			{
				add_player_buff = "havoc_vent_speed_reduction_1",
			},
			{
				add_player_buff = "havoc_vent_speed_reduction_2",
			},
			{
				add_player_buff = "havoc_vent_speed_reduction_3",
			},
			{
				add_player_buff = "havoc_vent_speed_reduction_4",
			},
			{
				add_player_buff = "havoc_vent_speed_reduction_5",
			},
		},
	},
	positive_modifier_templates = {
		positive_grenade_buff = {
			{
				add_player_buff = "havoc_positive_grenade_buff_1",
			},
			{
				add_player_buff = "havoc_positive_grenade_buff_2",
			},
			{
				add_player_buff = "havoc_positive_grenade_buff_3",
			},
			{
				add_player_buff = "havoc_positive_grenade_buff_4",
			},
			{
				add_player_buff = "havoc_positive_grenade_buff_5",
			},
		},
		positive_stamina_modifier = {
			{
				add_player_buff = "havoc_positive_stamina_01",
			},
			{
				add_player_buff = "havoc_positive_stamina_02",
			},
			{
				add_player_buff = "havoc_positive_stamina_03",
			},
			{
				add_player_buff = "havoc_positive_stamina_04",
			},
			{
				add_player_buff = "havoc_positive_stamina_05",
			},
		},
		positive_weakspot_damage_bonus = {
			{
				add_player_buff = "havoc_positive_weakspot_01",
			},
			{
				add_player_buff = "havoc_positive_weakspot_02",
			},
			{
				add_player_buff = "havoc_positive_weakspot_03",
			},
			{
				add_player_buff = "havoc_positive_weakspot_04",
			},
			{
				add_player_buff = "havoc_positive_weakspot_05",
			},
		},
		positive_knocked_down_health_modifier = {
			{
				add_player_buff = "havoc_knocked_down_health_modifier_1",
			},
			{
				add_player_buff = "havoc_knocked_down_health_modifier_2",
			},
			{
				add_player_buff = "havoc_knocked_down_health_modifier_3",
			},
			{
				add_player_buff = "havoc_knocked_down_health_modifier_4",
			},
			{
				add_player_buff = "havoc_knocked_down_health_modifier_5",
			},
		},
		positive_reload_speed = {
			{
				add_player_buff = "havoc_positive_reload_speed_1",
			},
			{
				add_player_buff = "havoc_positive_reload_speed_2",
			},
			{
				add_player_buff = "havoc_positive_reload_speed_3",
			},
			{
				add_player_buff = "havoc_positive_reload_speed_4",
			},
			{
				add_player_buff = "havoc_positive_reload_speed_5",
			},
		},
		positive_crit_chance = {
			{
				add_player_buff = "havoc_positive_critical_chance_1",
			},
			{
				add_player_buff = "havoc_positive_critical_chance_2",
			},
			{
				add_player_buff = "havoc_positive_critical_chance_3",
			},
			{
				add_player_buff = "havoc_positive_critical_chance_4",
			},
			{
				add_player_buff = "havoc_positive_critical_chance_5",
			},
		},
		positive_movement_speed = {
			{
				add_player_buff = "havoc_positive_movement_speed_1",
			},
			{
				add_player_buff = "havoc_positive_movement_speed_2",
			},
			{
				add_player_buff = "havoc_positive_movement_speed_3",
			},
			{
				add_player_buff = "havoc_positive_movement_speed_4",
			},
			{
				add_player_buff = "havoc_positive_movement_speed_5",
			},
		},
		positive_attack_speed = {
			{
				add_player_buff = "havoc_positive_attack_speed_1",
			},
			{
				add_player_buff = "havoc_positive_attack_speed_2",
			},
			{
				add_player_buff = "havoc_positive_attack_speed_3",
			},
			{
				add_player_buff = "havoc_positive_attack_speed_4",
			},
			{
				add_player_buff = "havoc_positive_attack_speed_5",
			},
		},
	},
	ui_settings = {
		modifiers = {
			buff_elites = {
				percent = true,
				text = "Elite HP increased by %d%%",
			},
			more_alive_specials = {
				text = "Max spawned Specialists increased by %d",
			},
			buff_specials = {
				percent = true,
				text = "Specialists HP increased by %d%%",
			},
			buff_monsters = {
				percent = true,
				text = "%d Monstrosities are guaranteed to spawn, HP increased by %d%%",
			},
			more_elites = {
				percent = true,
				text = "Elite amount increased by %d%%",
			},
			more_ogryns = {
				percent = true,
				text = "Ogryn amount increased by %d%%",
			},
			ammo_pickup_modifier = {
				percent = true,
				text = "Ammo pickups ammo capacity reduced to %d%%",
			},
			horde_spawn_rate_increase = {
				percent = true,
				text = "Horde spawn rate increased by %d%%",
			},
			weakspot_damage_bonus = {
				percent = true,
				positive = true,
				text = "Weakspot damage is increased by %d%%",
			},
			terror_event_point_increase = {
				percent = true,
				text = "Objective Event enemy spawns increased by %d%%",
			},
			buff_horde = {
				text_per_level = {
					{
						text = "Horde hit mass increased by 40%%, HP increased by 10%%",
					},
					{
						text = "Horde hit mass increased by 80%%, HP increased by 15%%",
					},
					{
						text = "Horde hit mass increased by 120%%, HP increased by 20%%",
					},
					{
						text = "Horde hit mass increased by 150%%, HP increased by 25%%",
					},
					{
						text = "Horde hit mass increased by 200%%, HP increased by 30%%",
					},
				},
			},
			melee_minion_attack_speed = {
				text_per_level = {
					{
						text = "Melee enemies gain 20%% attack speed",
					},
					{
						text = "Melee enemies gain 35%% attack speed",
					},
					{
						text = "Melee enemies gain 50%% attack speed",
					},
					{
						text = "Melee enemies gain 75%% attack speed",
					},
					{
						text = "Melee enemies gain 100%% attack speed",
					},
				},
			},
			melee_minion_permanent_damage = {
				text_per_level = {
					{
						text = "Melee enemy attack damage gain 10%% corruption",
					},
					{
						text = "Melee enemy attack damage gain 15%% corruption",
					},
					{
						text = "Melee enemy attack damage gain 20%% corruption",
					},
					{
						text = "Melee enemy attack damage gain 25%% corruption",
					},
					{
						text = "Melee enemy attack damage gain 30%% corruption",
					},
				},
			},
			ranged_minion_attack_speed = {
				text_per_level = {
					{
						text = "Ranged enemies gain 10%% attack speed",
					},
					{
						text = "Ranged enemies gain 15%% attack speed",
					},
					{
						text = "Ranged enemies gain 20%% attack speed",
					},
					{
						text = "Ranged enemies gain 25%% attack speed",
					},
					{
						text = "Ranged enemies gain 30%% attack speed",
					},
				},
			},
			melee_minion_power_level_buff = {
				text_per_level = {
					{
						text = "Enemy melee attacks deal 10%% more damage",
					},
					{
						text = "Enemy melee attacks deal 20%% more damage",
					},
					{
						text = "Enemy melee attacks deal 30%% more damage",
					},
					{
						text = "Enemy melee attacks deal 40%% more damage",
					},
					{
						text = "Enemy melee attacks deal 50%% more damage",
					},
				},
			},
			reduce_health_and_wounds = {
				text_per_level = {
					{
						text = "Players have 15%% less health",
					},
					{
						text = "Players have 20%% less health",
					},
					{
						text = "Players have 25%% less health",
					},
					{
						text = "Players have 30%% less health",
					},
					{
						text = "Players have 35%% less health",
					},
				},
			},
			reduce_toughness = {
				text_per_level = {
					{
						text = "Players have 15 less Toughness",
					},
					{
						text = "Players have 20 less Toughness",
					},
					{
						text = "Players have 30 less Toughness",
					},
					{
						text = "Players have 40 less Toughness",
					},
					{
						text = "Players have 50 less Toughness",
					},
				},
			},
			reduce_toughness_regen = {
				text_per_level = {
					{
						text = "Players have 15%% slower Toughness regen",
					},
					{
						text = "Players have 20%% slower Toughness regen",
					},
					{
						text = "Players have 30%% slower Toughness regen",
					},
					{
						text = "Players have 40%% slower Toughness regen",
					},
					{
						text = "Players have 50%% slower Toughness regen",
					},
				},
			},
			positive_grenade_buff = {
				text_per_level = {
					{
						positive = true,
						text = "Players gain 1 more grenade ability usage",
					},
					{
						positive = true,
						text = "Players gain 1 more grenade ability usage",
					},
					{
						positive = true,
						text = "Players gain 2 more grenade ability usage",
					},
					{
						positive = true,
						text = "Players gain 2 more grenade ability usage",
					},
					{
						positive = true,
						text = "Players gain 3 more grenade ability usage",
					},
				},
			},
			positive_knocked_down_health_modifier = {
				text_per_level = {
					{
						positive = true,
						text = "Players gain 20%% more health when knocked down",
					},
					{
						positive = true,
						text = "Players gain 40%% more health when knocked down",
					},
					{
						positive = true,
						text = "Players gain 60%% more health when knocked down",
					},
					{
						positive = true,
						text = "Players gain 80%% more health when knocked down",
					},
					{
						positive = true,
						text = "Players gain 100%% more health when knocked down",
					},
				},
			},
			positive_weakspot_damage_bonus = {
				text_per_level = {
					{
						positive = true,
						text = "Weakspot damage is increased by 10%%",
					},
					{
						positive = true,
						text = "Weakspot damage is increased by 20%%",
					},
					{
						positive = true,
						text = "Weakspot damage is increased by 30%%",
					},
					{
						positive = true,
						text = "Weakspot damage is increased by 40%%",
					},
					{
						positive = true,
						text = "Weakspot damage is increased by 50%%",
					},
				},
			},
			positive_stamina_modifier = {
				text_per_level = {
					{
						positive = true,
						text = "Stamina increased by 1",
					},
					{
						positive = true,
						text = "Stamina increased by 2",
					},
					{
						positive = true,
						text = "Stamina increased by 3",
					},
					{
						positive = true,
						text = "Stamina increased by 4",
					},
					{
						positive = true,
						text = "Stamina increased by 5",
					},
				},
			},
			positive_reload_speed = {
				text_per_level = {
					{
						positive = true,
						text = "Reload speed increased by 5%%",
					},
					{
						positive = true,
						text = "Reload speed increased by 10%%",
					},
					{
						positive = true,
						text = "Reload speed increased by 15%%",
					},
					{
						positive = true,
						text = "Reload speed increased by 20%%",
					},
					{
						positive = true,
						text = "Reload speed increased by 25%%",
					},
				},
			},
			positive_crit_chance = {
				text_per_level = {
					{
						positive = true,
						text = "Critical chance increased by 4%%",
					},
					{
						positive = true,
						text = "Critical chance increased by 8%%",
					},
					{
						positive = true,
						text = "Critical chance increased by 12%%",
					},
					{
						positive = true,
						text = "Critical chance increased by 16%%",
					},
					{
						positive = true,
						text = "Critical chance increased by 20%%",
					},
				},
			},
			positive_movement_speed = {
				text_per_level = {
					{
						positive = true,
						text = "Movement speed increased by 3%%",
					},
					{
						positive = true,
						text = "Movement speed increased by 6%%",
					},
					{
						positive = true,
						text = "Movement speed increased by 9%%",
					},
					{
						positive = true,
						text = "Movement speed increased by 12%%",
					},
					{
						positive = true,
						text = "Movement speed increased by 15%%",
					},
				},
			},
			positive_attack_speed = {
				text_per_level = {
					{
						positive = true,
						text = "Attack speed increased by 3%%",
					},
					{
						positive = true,
						text = "Attack speed increased by 6%%",
					},
					{
						positive = true,
						text = "Attack speed increased by 9%%",
					},
					{
						positive = true,
						text = "Attack speed increased by 12%%",
					},
					{
						positive = true,
						text = "Attack speed increased by 15%%",
					},
				},
			},
		},
		circumstances = {
			darkness_01 = {
				description = "loc_circumstance_darkness_description",
				title = "loc_circumstance_darkness_title",
			},
			darkness_hunting_grounds_01 = {
				description = "loc_circumstance_darkness_hunting_grounds_description",
				title = "loc_circumstance_darkness_hunting_grounds_title",
			},
			ventilation_purge_01 = {
				description = "loc_circumstance_ventilation_purge_description",
				title = "loc_circumstance_ventilation_purge_title",
			},
			ventilation_purge_with_snipers_01 = {
				description = "loc_circumstance_ventilation_purge_with_snipers_description",
				title = "loc_circumstance_ventilation_purge_with_snipers_title",
			},
			hunting_grounds_01 = {
				description = "loc_happening_hunting_grounds",
				title = "loc_circumstance_hunting_grounds_title",
			},
			toxic_gas_01 = {
				description = "loc_circumstance_toxic_gas_description",
				title = "loc_circumstance_toxic_gas_title",
			},
			toxic_gas_cultist_grenadier = {
				description = "loc_circumstance_toxic_gas_cultist_grenadier_description",
				title = "loc_circumstance_toxic_gas_cultist_grenadier_title",
			},
			mutants_01 = {
				description = "Groups of Mutants have been identified in this area.",
				title = "Mutant Rumble",
			},
			poxwalker_bombers_01 = {
				description = "Groups of Poxbursters have been identified in this area.",
				title = "Poxbursters",
			},
			snipers_01 = {
				description = "Groups of Snipers have been identified in this area.",
				title = "Snipers",
			},
			common_minion_on_fire = {
				description = "loc_havoc_common_minion_on_fire_description",
				title = "loc_havoc_common_minion_on_fire_name",
			},
			mutator_havoc_duplicating_enemies = {
				description = "Reports indicates that the warp rift is really thin here.",
				title = "Warp rift",
			},
			mutator_havoc_enemies_parasite_headshot = {
				description = "loc_havoc_enemies_parasite_headshot_description",
				title = "loc_havoc_enemies_parasite_headshot_name",
			},
			mutator_havoc_enemies_corrupted = {
				description = "loc_havoc_enemies_corrupted_description",
				title = "loc_havoc_enemies_corrupted_name",
			},
			mutator_havoc_armored_infected = {
				description = "loc_havoc_armored_infected_description",
				title = "loc_havoc_armored_infected_name",
			},
			stimmed_minions_yellow_01 = {
				description = "Some enemies have taken combat stims, but they take more weakspot damage.",
				title = "Combat Stims",
			},
			mutator_havoc_tougher_skin = {
				description = "loc_havoc_tougher_skin_description",
				title = "loc_havoc_tougher_skin_name",
			},
			stimmed_minions_blue_01 = {
				description = "Some enemies have taken defensive stims, making them much harder to kill.",
				title = "Defensive Stims",
			},
			stimmed_minions_purple_01 = {
				description = "Some toxins in the air is causing some enemies appear as one.",
				title = "Illusions",
			},
			monster_specials_01 = {
				description = "Reports indicate that weaker Monstrosities inhabit this area..",
				title = "Monstrosity Concentration",
			},
			bolstering_minions_01 = {
				description = "loc_havoc_bolstering_enemies_description",
				title = "loc_havoc_bolstering_enemies_name",
			},
			more_captains_01 = {
				description = "Traitor Guard Captains have been seen in the area.",
				title = "Kill Target Revenge",
			},
			more_boss_patrols_01 = {
				description = "Elite Patrols have been seen in the area.",
				title = "Elite Patrols",
			},
			mutator_havoc_sticky_poxbursters = {
				description = "loc_havoc_sticky_poxbursters_description",
				title = "loc_havoc_sticky_poxbursters_name",
			},
			mutator_havoc_thorny_armor = {
				description = "loc_havoc_thorny_armor_description",
				title = "loc_havoc_thorny_armor_name",
			},
			mutator_increased_difficulty = {
				description = "loc_havoc_increased_difficulty_description",
				title = "loc_havoc_increased_difficulty_name",
			},
			mutator_highest_difficulty = {
				description = "loc_havoc_highest_difficulty_description",
				title = "loc_havoc_highest_difficulty_name",
			},
		},
	},
}

havoc_settings.modifiers = {}

for modifier_name, _ in pairs(havoc_settings.modifier_templates) do
	havoc_settings.modifiers[#havoc_settings.modifiers + 1] = modifier_name
end

havoc_settings.positive_modifiers = {}

for modifier_name, _ in pairs(havoc_settings.positive_modifier_templates) do
	havoc_settings.positive_modifiers[#havoc_settings.positive_modifiers + 1] = modifier_name
end

return settings("havoc_settings", havoc_settings)
