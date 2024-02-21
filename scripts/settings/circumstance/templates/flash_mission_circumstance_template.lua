local only_melee_mission_overrides = {
	pickup_settings = {
		rubberband_pool = {
			ammo = {
				small_clip = {
					-99,
					-99,
					-99,
					-99,
					-99
				},
				large_clip = {
					-99,
					-99,
					-99,
					-99,
					-99
				},
				ammo_cache_pocketable = {
					-99,
					-99,
					-99,
					-99,
					-99
				}
			},
			grenade = {
				small_grenade = {
					3,
					3,
					3,
					3,
					3
				}
			}
		},
		mid_event = {
			ammo = {
				small_clip = {
					-99,
					-99,
					-99,
					-99,
					-99
				},
				large_clip = {
					-99,
					-99,
					-99,
					-99,
					-99
				},
				ammo_cache_pocketable = {
					-99,
					-99,
					-99,
					-99,
					-99
				}
			}
		},
		end_event = {
			ammo = {
				small_clip = {
					-99,
					-99,
					-99,
					-99,
					-99
				},
				large_clip = {
					-99,
					-99,
					-99,
					-99,
					-99
				},
				ammo_cache_pocketable = {
					-99,
					-99,
					-99,
					-99,
					-99
				}
			}
		},
		primary = {
			ammo = {
				small_clip = {
					-99,
					-99,
					-99,
					-99,
					-99
				},
				large_clip = {
					-99,
					-99,
					-99,
					-99,
					-99
				},
				ammo_cache_pocketable = {
					-99,
					-99,
					-99,
					-99,
					-99
				}
			},
			grenade = {
				small_grenade = {
					4,
					4,
					4,
					4,
					4
				}
			}
		},
		secondary = {
			ammo = {
				small_clip = {
					-99,
					-99,
					-99,
					-99,
					-99
				},
				large_clip = {
					-99,
					-99,
					-99,
					-99,
					-99
				},
				ammo_cache_pocketable = {
					-99,
					-99,
					-99,
					-99,
					-99
				}
			}
		}
	}
}
local circumstance_templates = {
	flash_mission_01 = {
		theme_tag = "default",
		mutators = {
			"mutator_monster_specials",
			"mutator_waves_of_specials"
		},
		ui = {
			description = "loc_circumstance_flash_mission_01_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_flash_mission_01_title"
		}
	},
	flash_mission_02 = {
		theme_tag = "default",
		mutators = {
			"mutator_minion_nurgle_blessing",
			"mutator_waves_of_specials"
		},
		ui = {
			description = "loc_circumstance_flash_mission_02_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_flash_mission_02_title"
		}
	},
	flash_mission_03 = {
		theme_tag = "default",
		mutators = {
			"mutator_waves_of_specials",
			"mutator_chaos_hounds"
		},
		ui = {
			description = "loc_circumstance_flash_mission_03_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_flash_mission_03_title"
		}
	},
	flash_mission_04 = {
		theme_tag = "default",
		mutators = {
			"mutator_chaos_hounds",
			"mutator_minion_nurgle_blessing",
			"mutator_ability_cooldown_reduction"
		},
		ui = {
			description = "loc_circumstance_flash_mission_04_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_flash_mission_04_title"
		}
	},
	flash_mission_05 = {
		dialogue_id = "circumstance_vo_darkness",
		wwise_state = "darkness_01",
		theme_tag = "darkness",
		mutators = {
			"mutator_monster_specials",
			"mutator_waves_of_specials",
			"mutator_darkness_los"
		},
		ui = {
			description = "loc_circumstance_flash_mission_05_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_flash_mission_05_title"
		}
	},
	flash_mission_06 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		wwise_state = "ventilation_purge_01",
		theme_tag = "ventilation_purge",
		mutators = {
			"mutator_waves_of_specials",
			"mutator_ventilation_purge_los",
			"mutator_snipers"
		},
		ui = {
			description = "loc_circumstance_flash_mission_06_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_flash_mission_06_title"
		}
	},
	flash_mission_07 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_flash_mission_07_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_flash_mission_07_title"
		},
		mutators = {
			"mutator_only_melee_roamers",
			"mutator_only_melee_trickle_hordes",
			"mutator_only_melee_terror_events",
			"mutator_waves_of_specials",
			"mutator_only_traitor_guard_faction",
			"mutator_more_ogryns"
		},
		mission_overrides = only_melee_mission_overrides
	},
	flash_mission_08 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_flash_mission_08_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_flash_mission_08_title"
		},
		mutators = {
			"mutator_chaos_hounds",
			"mutator_waves_of_specials",
			"mutator_mutants",
			"mutator_ability_cooldown_reduction"
		}
	},
	flash_mission_09 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		wwise_state = "ventilation_purge_01",
		theme_tag = "ventilation_purge",
		mutators = {
			"mutator_no_encampments",
			"mutator_only_ranged_roamers",
			"mutator_only_ranged_trickle_hordes",
			"mutator_only_ranged_terror_events",
			"mutator_only_traitor_guard_faction",
			"mutator_ability_cooldown_reduction",
			"mutator_ventilation_purge_los",
			"mutator_more_ogryns"
		},
		ui = {
			description = "loc_circumstance_flash_mission_09_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_flash_mission_09_title"
		}
	},
	flash_mission_10 = {
		theme_tag = "default",
		mutators = {
			"mutator_no_encampments",
			"mutator_waves_of_specials",
			"mutator_minion_nurgle_blessing",
			"mutator_only_traitor_guard_faction",
			"mutator_monster_specials",
			"mutator_enchanced_grenade_ability"
		},
		ui = {
			description = "loc_circumstance_flash_mission_10_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_flash_mission_10_title"
		}
	},
	flash_mission_11 = {
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_flash_mission_11_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_flash_mission_11_title"
		},
		mutators = {
			"mutator_poxwalker_bombers",
			"mutator_snipers",
			"mutator_waves_of_specials",
			"mutator_enchanced_grenade_ability"
		},
		mission_overrides = {
			hazard_prop_settings = {
				explosion = 1,
				fire = 1,
				none = 0
			}
		}
	},
	flash_mission_12 = {
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_flash_mission_12_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_flash_mission_12_title"
		},
		mutators = {
			"mutator_poxwalker_bombers",
			"mutator_mutants",
			"mutator_chaos_hounds",
			"mutator_enchanced_grenade_ability"
		},
		mission_overrides = {
			hazard_prop_settings = {
				explosion = 1,
				fire = 1,
				none = 0
			}
		}
	},
	flash_mission_13 = {
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_flash_mission_13_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_flash_mission_13_title"
		},
		mutators = {
			"mutator_mutants",
			"mutator_minion_nurgle_blessing",
			"mutator_waves_of_specials",
			"mutator_ability_cooldown_reduction"
		},
		mission_overrides = {
			hazard_prop_settings = {
				explosion = 1,
				fire = 1,
				none = 0
			}
		}
	},
	flash_mission_14 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_flash_mission_14_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_flash_mission_14_title"
		},
		mutators = {
			"mutator_no_encampments",
			"mutator_waves_of_specials",
			"mutator_more_boss_patrols",
			"mutator_more_ogryns"
		}
	},
	high_flash_mission_01 = {
		theme_tag = "default",
		mutators = {
			"mutator_monster_specials",
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier"
		},
		ui = {
			description = "loc_circumstance_flash_mission_01_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_01_title"
		}
	},
	high_flash_mission_02 = {
		theme_tag = "default",
		mutators = {
			"mutator_minion_nurgle_blessing",
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier"
		},
		ui = {
			description = "loc_circumstance_flash_mission_02_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_02_title"
		}
	},
	high_flash_mission_03 = {
		theme_tag = "default",
		mutators = {
			"mutator_waves_of_specials",
			"mutator_chaos_hounds",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier"
		},
		ui = {
			description = "loc_circumstance_flash_mission_03_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_03_title"
		}
	},
	high_flash_mission_04 = {
		theme_tag = "default",
		mutators = {
			"mutator_chaos_hounds",
			"mutator_minion_nurgle_blessing",
			"mutator_add_resistance",
			"mutator_ability_cooldown_reduction",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier"
		},
		ui = {
			description = "loc_circumstance_flash_mission_04_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_04_title"
		}
	},
	high_flash_mission_05 = {
		dialogue_id = "circumstance_vo_darkness",
		wwise_state = "darkness_01",
		theme_tag = "darkness",
		mutators = {
			"mutator_monster_specials",
			"mutator_add_resistance",
			"mutator_waves_of_specials",
			"mutator_darkness_los",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier"
		},
		ui = {
			description = "loc_circumstance_flash_mission_05_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_05_title"
		}
	},
	high_flash_mission_06 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		wwise_state = "ventilation_purge_01",
		theme_tag = "ventilation_purge",
		mutators = {
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_ventilation_purge_los",
			"mutator_snipers",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier"
		},
		ui = {
			description = "loc_circumstance_flash_mission_06_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_06_title"
		}
	},
	high_flash_mission_07 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_flash_mission_07_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_07_title"
		},
		mutators = {
			"mutator_only_melee_roamers",
			"mutator_only_melee_trickle_hordes",
			"mutator_only_melee_terror_events",
			"mutator_add_resistance",
			"mutator_waves_of_specials",
			"mutator_only_traitor_guard_faction",
			"mutator_more_ogryns",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier"
		},
		mission_overrides = only_melee_mission_overrides
	},
	high_flash_mission_08 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_flash_mission_08_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_08_title"
		},
		mutators = {
			"mutator_chaos_hounds",
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_mutants",
			"mutator_ability_cooldown_reduction",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier"
		}
	},
	high_flash_mission_09 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		wwise_state = "ventilation_purge_01",
		theme_tag = "ventilation_purge",
		mutators = {
			"mutator_no_encampments",
			"mutator_only_ranged_roamers",
			"mutator_only_ranged_trickle_hordes",
			"mutator_only_ranged_terror_events",
			"mutator_add_resistance",
			"mutator_only_traitor_guard_faction",
			"mutator_ability_cooldown_reduction",
			"mutator_ventilation_purge_los",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier",
			"mutator_more_ogryns"
		},
		ui = {
			description = "loc_circumstance_flash_mission_09_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_09_title"
		}
	},
	high_flash_mission_10 = {
		theme_tag = "default",
		mutators = {
			"mutator_no_encampments",
			"mutator_add_resistance",
			"mutator_waves_of_specials",
			"mutator_minion_nurgle_blessing",
			"mutator_only_traitor_guard_faction",
			"mutator_monster_specials",
			"mutator_enchanced_grenade_ability",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier"
		},
		ui = {
			description = "loc_circumstance_flash_mission_10_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_10_title"
		}
	},
	high_flash_mission_11 = {
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_flash_mission_11_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_11_title"
		},
		mutators = {
			"mutator_poxwalker_bombers",
			"mutator_snipers",
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_enchanced_grenade_ability",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier"
		},
		mission_overrides = {
			hazard_prop_settings = {
				explosion = 1,
				fire = 1,
				none = 0
			}
		}
	},
	high_flash_mission_12 = {
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_flash_mission_12_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_12_title"
		},
		mutators = {
			"mutator_poxwalker_bombers",
			"mutator_mutants",
			"mutator_chaos_hounds",
			"mutator_add_resistance",
			"mutator_enchanced_grenade_ability",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier"
		},
		mission_overrides = {
			hazard_prop_settings = {
				explosion = 1,
				fire = 1,
				none = 0
			}
		}
	},
	high_flash_mission_13 = {
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_flash_mission_13_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_13_title"
		},
		mutators = {
			"mutator_mutants",
			"mutator_minion_nurgle_blessing",
			"mutator_add_resistance",
			"mutator_waves_of_specials",
			"mutator_ability_cooldown_reduction",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier"
		},
		mission_overrides = {
			hazard_prop_settings = {
				explosion = 1,
				fire = 1,
				none = 0
			}
		}
	},
	high_flash_mission_14 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_flash_mission_14_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_14_title"
		},
		mutators = {
			"mutator_no_encampments",
			"mutator_waves_of_specials",
			"mutator_more_boss_patrols",
			"mutator_more_ogryns",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier"
		}
	},
	high_flash_mission_15 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_flash_mission_14_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_14_title"
		},
		mutators = {
			"mutator_no_encampments",
			"mutator_waves_of_specials",
			"mutator_more_boss_patrols",
			"mutator_more_elites",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier"
		}
	},
	high_flash_mission_16 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_flash_mission_14_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_14_title"
		},
		mutators = {
			"mutator_no_encampments",
			"mutator_waves_of_specials",
			"mutator_more_boss_patrols",
			"mutator_more_elites",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points_high",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier"
		}
	},
	high_flash_mission_17 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_flash_mission_14_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_02",
			display_name = "loc_circumstance_flash_mission_14_title"
		},
		mutators = {
			"mutator_no_encampments",
			"mutator_waves_of_specials",
			"mutator_higher_stagger_thresholds",
			"mutator_increase_terror_event_points_high",
			"mutator_reduced_ramp_duration",
			"mutator_auric_tension_modifier",
			"mutator_modify_challenge_resistance_scale_six_one",
			"mutator_always_allow_all_spawn_types",
			"mutator_more_hordes_02"
		}
	},
	six_one_flash_mission_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_six_one_flash_mission_01_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_six_one_flash_mission_01_title"
		},
		mutators = {
			"mutator_modify_challenge_resistance_scale_six_one",
			"mutator_specials_required_challenge_rating",
			"mutator_travel_distance_spawning_specials",
			"mutator_travel_distance_spawning_hordes",
			"mutator_more_alive_specials",
			"mutator_higher_stagger_thresholds",
			"mutator_no_encampments"
		}
	},
	six_one_flash_mission_02 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		wwise_state = "ventilation_purge_01",
		theme_tag = "ventilation_purge",
		ui = {
			description = "loc_circumstance_six_one_flash_mission_02_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_six_one_flash_mission_02_title"
		},
		mutators = {
			"mutator_modify_challenge_resistance_scale_six_one",
			"mutator_specials_required_challenge_rating",
			"mutator_travel_distance_spawning_specials",
			"mutator_travel_distance_spawning_hordes",
			"mutator_more_alive_specials",
			"mutator_higher_stagger_thresholds",
			"mutator_no_encampments",
			"mutator_ventilation_purge_los"
		}
	},
	six_one_flash_mission_03 = {
		dialogue_id = "circumstance_vo_darkness",
		wwise_state = "darkness_01",
		theme_tag = "darkness",
		ui = {
			description = "loc_circumstance_six_one_flash_mission_03_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_six_one_flash_mission_03_title"
		},
		mutators = {
			"mutator_darkness_los",
			"mutator_modify_challenge_resistance_scale_six_one",
			"mutator_specials_required_challenge_rating",
			"mutator_travel_distance_spawning_specials",
			"mutator_travel_distance_spawning_hordes",
			"mutator_more_alive_specials",
			"mutator_higher_stagger_thresholds",
			"mutator_no_encampments"
		}
	},
	six_one_flash_mission_04 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_six_one_flash_mission_04_description",
			icon = "content/ui/materials/icons/circumstances/maelstrom_01",
			display_name = "loc_circumstance_six_one_flash_mission_04_title"
		},
		mutators = {
			"mutator_modify_challenge_resistance_scale_six_one",
			"mutator_specials_required_challenge_rating",
			"mutator_travel_distance_spawning_specials",
			"mutator_travel_distance_spawning_hordes",
			"mutator_more_alive_specials",
			"mutator_higher_stagger_thresholds",
			"mutator_no_encampments",
			"mutator_waves_of_specials"
		}
	}
}

return circumstance_templates
