local events = {
	sfx_foley_upper_body = {
		has_husk_events = true,
		switch = {
			"archetype",
			"sfx_body_material"
		},
		events = {
			default = {
				default = "wwise/events/player/play_upper_body_gen",
				cloth_metal = "wwise/events/player/play_upper_body_gen",
				cloth = "wwise/events/player/play_foley_material_cloth",
				cloth_chains = "wwise/events/player/play_upper_body_gen",
				nude = "wwise/events/player/play_foley_material_cloth",
				leather_chains = "wwise/events/player/play_foley_material_leather",
				metal = "wwise/events/player/play_foley_material_metal",
				cloth_loose = "wwise/events/player/play_foley_material_cloth",
				leather_metal = "wwise/events/player/play_foley_material_leather",
				leather = "wwise/events/player/play_foley_material_leather"
			},
			ogryn = {
				default = "wwise/events/player/play_ogryn_upper_body_gen",
				cloth_metal = "wwise/events/player/play_ogryn_upper_body_gen",
				cloth = "wwise/events/player/play_ogryn_upper_body_cloth",
				cloth_chains = "wwise/events/player/play_ogryn_upper_body_gen",
				nude = "wwise/events/player/play_ogryn_upper_body_cloth",
				leather_chains = "wwise/events/player/play_ogryn_upper_body_leather",
				metal = "wwise/events/player/play_ogryn_upper_body_armor_metal",
				cloth_loose = "wwise/events/player/play_ogryn_upper_body_cloth",
				leather_metal = "wwise/events/player/play_ogryn_upper_body_leather",
				leather = "wwise/events/player/play_ogryn_upper_body_leather"
			}
		}
	},
	sfx_foley_land = {
		has_husk_events = true,
		switch = {
			"archetype",
			"sfx_body_material"
		},
		events = {
			default = {
				default = "wwise/events/player/play_land_gen",
				cloth_metal = "wwise/events/player/play_land_gen",
				cloth = "wwise/events/player/play_land_gen",
				cloth_chains = "wwise/events/player/play_land_gen",
				nude = "wwise/events/player/play_land_gen",
				leather_chains = "wwise/events/player/play_land_gen",
				metal = "wwise/events/player/play_land_gen",
				cloth_loose = "wwise/events/player/play_land_gen",
				leather_metal = "wwise/events/player/play_land_gen",
				leather = "wwise/events/player/play_land_gen"
			},
			ogryn = {
				default = "wwise/events/player/play_ogryn_land_gen",
				cloth_metal = "wwise/events/player/play_ogryn_land_gen",
				cloth = "wwise/events/player/play_ogryn_land_gen",
				cloth_chains = "wwise/events/player/play_ogryn_land_gen",
				nude = "wwise/events/player/play_ogryn_land_gen",
				leather_chains = "wwise/events/player/play_ogryn_land_gen",
				metal = "wwise/events/player/play_ogryn_land_gen",
				cloth_loose = "wwise/events/player/play_ogryn_land_gen",
				leather_metal = "wwise/events/player/play_ogryn_land_gen",
				leather = "wwise/events/player/play_ogryn_land_gen"
			}
		}
	},
	sfx_player_extra_slot = {
		no_default = true,
		has_husk_events = false,
		switch = {
			"sfx_body_material"
		},
		events = {
			skulls = "wwise/events/player/play_gear_skulls_med",
			backpack = "wwise/events/player/play_gear_light_gen_a",
			chains = "wwise/events/player/play_gear_chain_med"
		}
	},
	sfx_foley_short = {
		has_husk_events = true,
		switch = {
			"archetype",
			"sfx_body_material"
		},
		events = {
			default = {
				default = "wwise/events/player/play_player_foley_arms"
			},
			ogryn = {
				default = "wwise/events/player/play_ogryn_foley_arms_gen"
			}
		}
	},
	sfx_foley_subtle = {
		has_husk_events = false,
		switch = {
			"archetype",
			"sfx_body_material"
		},
		events = {
			default = {
				default = "wwise/events/player/play_player_foley_subtle"
			},
			ogryn = {
				default = "wwise/events/player/play_ogryn_foley_subtle"
			}
		}
	},
	sfx_foley_arms_drastic = {
		has_husk_events = true,
		switch = {
			"archetype",
			"sfx_body_material"
		},
		events = {
			default = {
				default = "wwise/events/player/play_player_foley_arms_drastic"
			},
			ogryn = {
				default = "wwise/events/player/play_ogryn_foley_arms_drastic"
			}
		}
	},
	sfx_foley_swing_light = {
		has_husk_events = true,
		switch = {
			"archetype",
			"sfx_body_material"
		},
		events = {
			default = {
				default = "wwise/events/player/play_swing_light_gen"
			},
			ogryn = {
				default = "wwise/events/player/play_ogryn_swing_light_gen"
			}
		}
	},
	sfx_foley_swing_heavy = {
		has_husk_events = true,
		switch = {
			"archetype",
			"sfx_body_material"
		},
		events = {
			default = {
				default = "wwise/events/player/play_swing_heavy_gen"
			},
			ogryn = {
				default = "wwise/events/player/play_ogryn_swing_heavy_gen"
			}
		}
	},
	ladder_climbing_hands = {
		has_husk_events = true,
		switch = {
			"archetype",
			"sfx_body_material"
		},
		events = {
			default = {
				default = "wwise/events/player/play_foley_hands_ladder_metal"
			},
			ogryn = {
				default = "wwise/events/player/play_foley_hands_ladder_metal"
			}
		}
	},
	ladder_climbing_feet = {
		has_husk_events = true,
		switch = {
			"archetype",
			"sfx_body_material"
		},
		events = {
			default = {
				default = "wwise/events/player/play_footstep_boots_medium_ladder"
			},
			ogryn = {
				default = "wwise/events/player/play_footstep_boots_medium_ladder"
			}
		}
	},
	sfx_hand_scratch = {
		has_husk_events = false,
		switch = {
			"archetype",
			"sfx_body_material"
		},
		events = {
			default = {
				default = "wwise/events/player/play_foley_hands_scratch_beard"
			},
			ogryn = {
				default = "wwise/events/player/play_foley_hands_scratch_beard"
			}
		}
	},
	sfx_hand_knuckle = {
		has_husk_events = false,
		switch = {
			"archetype",
			"sfx_body_material"
		},
		events = {
			default = {
				default = "wwise/events/player/play_foley_hands_knuckle"
			},
			ogryn = {
				default = "wwise/events/player/play_foley_hands_knuckle"
			}
		}
	},
	sfx_hand_snot = {
		has_husk_events = false,
		switch = {
			"archetype",
			"sfx_body_material"
		},
		events = {
			default = {
				default = "wwise/events/player/play_foley_hands_ogryn_snot"
			},
			ogryn = {
				default = "wwise/events/player/play_foley_hands_ogryn_snot"
			}
		}
	},
	sfx_servo_skull_deploy = {
		has_husk_events = false,
		switch = {
			"archetype",
			"sfx_body_material"
		},
		events = {
			default = {
				default = "wwise/events/player/play_servitor_scanning_deploy"
			},
			ogryn = {
				default = "wwise/events/player/play_servitor_scanning_deploy"
			}
		}
	},
	footstep = {
		has_husk_events = true,
		switch = {
			"archetype"
		},
		events = {
			default = "wwise/events/player/play_footstep_boots_medium",
			ogryn = "wwise/events/player/play_footstep_boots_heavy"
		}
	},
	footstep_jump = {
		has_husk_events = true,
		switch = {
			"archetype"
		},
		events = {
			default = "wwise/events/player/play_footstep_boots_medium_jump",
			ogryn = "wwise/events/player/play_footstep_ogryn_jump"
		}
	},
	footstep_land = {
		has_husk_events = true,
		switch = {
			"archetype"
		},
		events = {
			default = "wwise/events/player/play_footstep_boots_medium_land",
			ogryn = "wwise/events/player/play_footstep_ogryn_land"
		}
	},
	sfx_ladder_foot = {
		has_husk_events = true,
		switch = {
			"archetype"
		},
		events = {
			default = "wwise/events/player/play_footstep_boots_medium_ladder",
			ogryn = "wwise/events/player/play_footstep_boots_medium_ladder"
		}
	},
	sfx_ladder_hand = {
		has_husk_events = true,
		switch = {
			"archetype"
		},
		events = {
			default = "wwise/events/player/play_foley_hands_ladder_metal",
			ogryn = "wwise/events/player/play_foley_hands_ladder_metal"
		}
	},
	netted_struggle = {
		has_husk_events = false,
		switch = {
			"archetype"
		},
		events = {
			default = "wwise/events/player/play_foley_player_netted_struggle",
			ogryn = "wwise/events/player/play_foley_player_netted_struggle"
		}
	},
	ground_hit = {
		has_husk_events = false,
		switch = {
			"archetype"
		},
		events = {
			default = "wwise/events/player/play_player_foley_body_impact_medium_ground",
			ogryn = "wwise/events/player/play_player_foley_body_impact_medium_ground"
		}
	},
	sfx_footstep_dodge = {
		has_husk_events = true,
		switch = {
			"archetype"
		},
		events = {
			default = "wwise/events/player/play_footsteps_boots_dodge",
			ogryn = "wwise/events/player/play_footstep_ogryn_dodge"
		}
	},
	player_vault = {
		has_husk_events = true,
		switch = {
			"archetype"
		},
		events = {
			default = "wwise/events/player/play_vault"
		}
	},
	sfx_ability_foley_01 = {
		has_husk_events = false,
		switch = {
			"archetype"
		},
		events = {
			default = "wwise/events/player/play_ability_zealot_preacher_book_open"
		}
	},
	sfx_ability_foley_02 = {
		has_husk_events = false,
		switch = {
			"archetype"
		},
		events = {
			default = "wwise/events/player/play_ability_zealot_preacher_book_close"
		}
	},
	attack_long_vce = {
		has_husk_events = true,
		switch = {
			"selected_voice"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			veteran_male_b = "wwise/events/player/play_veteran_male_b__vce_attack_long",
			zealot_female_c = "wwise/events/player/play_zealot_female_c__vce_attack_long",
			veteran_female_c = "wwise/events/player/play_veteran_female_c__vce_attack_long",
			ogryn_a = "wwise/events/player/play_ogryn_a__vce_attack_long",
			psyker_female_c = "wwise/events/player/play_psyker_female_c__vce_attack_long",
			ogryn_b = "wwise/events/player/play_ogryn_b__vce_attack_long",
			veteran_male_c = "wwise/events/player/play_veteran_male_c__vce_attack_long",
			zealot_female_b = "wwise/events/player/play_zealot_female_b__vce_attack_long",
			explicator_a = "wwise/events/player/play_veteran_female_c__vce_attack_long",
			psyker_male_b = "wwise/events/player/play_psyker_male_b__vce_attack_long",
			zealot_male_a = "wwise/events/player/play_zealot_male_a__vce_attack_long",
			zealot_male_b = "wwise/events/player/play_zealot_male_b__vce_attack_long",
			zealot_male_c = "wwise/events/player/play_zealot_male_c__vce_attack_long",
			psyker_female_b = "wwise/events/player/play_psyker_female_b__vce_attack_long",
			psyker_female_a = "wwise/events/player/play_psyker_female_a__vce_attack_long",
			psyker_male_a = "wwise/events/player/play_psyker_male_a__vce_attack_long",
			zealot_female_a = "wwise/events/player/play_zealot_female_a__vce_attack_long",
			veteran_female_a = "wwise/events/player/play_veteran_female_a__vce_attack_long",
			ogryn_c = "wwise/events/player/play_ogryn_c__vce_attack_long",
			psyker_male_c = "wwise/events/player/play_psyker_male_c__vce_attack_long",
			veteran_male_a = "wwise/events/player/play_veteran_male_a__vce_attack_long",
			veteran_female_b = "wwise/events/player/play_veteran_female_b__vce_attack_long"
		}
	},
	attack_short_vce = {
		has_husk_events = true,
		switch = {
			"selected_voice"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			veteran_male_b = "wwise/events/player/play_veteran_male_b__vce_attack_short",
			zealot_female_c = "wwise/events/player/play_zealot_female_c__vce_attack_short",
			veteran_female_c = "wwise/events/player/play_veteran_female_c__vce_attack_short",
			ogryn_a = "wwise/events/player/play_ogryn_a__vce_attack_short",
			psyker_female_c = "wwise/events/player/play_psyker_female_c__vce_attack_short",
			ogryn_b = "wwise/events/player/play_ogryn_b__vce_attack_short",
			veteran_male_c = "wwise/events/player/play_veteran_male_c__vce_attack_short",
			zealot_female_b = "wwise/events/player/play_zealot_female_b__vce_attack_short",
			explicator_a = "wwise/events/player/play_veteran_female_c__vce_attack_short",
			psyker_male_b = "wwise/events/player/play_psyker_male_b__vce_attack_short",
			zealot_male_a = "wwise/events/player/play_zealot_male_a__vce_attack_short",
			zealot_male_b = "wwise/events/player/play_zealot_male_b__vce_attack_short",
			zealot_male_c = "wwise/events/player/play_zealot_male_c__vce_attack_short",
			psyker_female_b = "wwise/events/player/play_psyker_female_b__vce_attack_short",
			psyker_female_a = "wwise/events/player/play_psyker_female_a__vce_attack_short",
			psyker_male_a = "wwise/events/player/play_psyker_male_a__vce_attack_short",
			zealot_female_a = "wwise/events/player/play_zealot_female_a__vce_attack_short",
			veteran_female_a = "wwise/events/player/play_veteran_female_a__vce_attack_short",
			ogryn_c = "wwise/events/player/play_ogryn_c__vce_attack_short",
			psyker_male_c = "wwise/events/player/play_psyker_male_c__vce_attack_short",
			veteran_male_a = "wwise/events/player/play_veteran_male_a__vce_attack_short",
			veteran_female_b = "wwise/events/player/play_veteran_female_b__vce_attack_short"
		}
	},
	catapulted_vce = {
		has_husk_events = true,
		switch = {
			"selected_voice"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			veteran_male_b = "wwise/events/player/play_veteran_male_b__vce_catapulted",
			zealot_female_c = "wwise/events/player/play_zealot_female_c__vce_catapulted",
			veteran_female_c = "wwise/events/player/play_veteran_female_c__vce_catapulted",
			ogryn_a = "wwise/events/player/play_ogryn_a__vce_catapulted",
			psyker_female_c = "wwise/events/player/play_psyker_female_c__vce_catapulted",
			ogryn_b = "wwise/events/player/play_ogryn_b__vce_catapulted",
			veteran_male_c = "wwise/events/player/play_veteran_male_c__vce_catapulted",
			zealot_female_b = "wwise/events/player/play_zealot_female_b__vce_catapulted",
			explicator_a = "wwise/events/player/play_veteran_female_c__vce_catapulted",
			psyker_male_b = "wwise/events/player/play_psyker_male_b__vce_catapulted",
			zealot_male_a = "wwise/events/player/play_zealot_male_a__vce_catapulted",
			zealot_male_b = "wwise/events/player/play_zealot_male_b__vce_catapulted",
			zealot_male_c = "wwise/events/player/play_zealot_male_c__vce_catapulted",
			psyker_female_b = "wwise/events/player/play_psyker_female_b__vce_catapulted",
			psyker_female_a = "wwise/events/player/play_psyker_female_a__vce_catapulted",
			psyker_male_a = "wwise/events/player/play_psyker_male_a__vce_catapulted",
			zealot_female_a = "wwise/events/player/play_zealot_female_a__vce_catapulted",
			veteran_female_a = "wwise/events/player/play_veteran_female_a__vce_catapulted",
			ogryn_c = "wwise/events/player/play_ogryn_c__vce_catapulted",
			psyker_male_c = "wwise/events/player/play_psyker_male_c__vce_catapulted",
			veteran_male_a = "wwise/events/player/play_veteran_male_a__vce_catapulted",
			veteran_female_b = "wwise/events/player/play_veteran_female_b__vce_catapulted"
		}
	},
	catapulted_land_vce = {
		has_husk_events = true,
		switch = {
			"selected_voice"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			veteran_male_b = "wwise/events/player/play_veteran_male_b__vce_catapulted_land",
			zealot_female_c = "wwise/events/player/play_zealot_female_c__vce_catapulted_land",
			veteran_female_c = "wwise/events/player/play_veteran_female_c__vce_catapulted_land",
			ogryn_a = "wwise/events/player/play_ogryn_a__vce_catapulted_land",
			psyker_female_c = "wwise/events/player/play_psyker_female_c__vce_catapulted_land",
			ogryn_b = "wwise/events/player/play_ogryn_b__vce_catapulted_land",
			veteran_male_c = "wwise/events/player/play_veteran_male_c__vce_catapulted_land",
			zealot_female_b = "wwise/events/player/play_zealot_female_b__vce_catapulted_land",
			explicator_a = "wwise/events/player/play_veteran_female_c__vce_catapulted_land",
			psyker_male_b = "wwise/events/player/play_psyker_male_b__vce_catapulted_land",
			zealot_male_a = "wwise/events/player/play_zealot_male_a__vce_catapulted_land",
			zealot_male_b = "wwise/events/player/play_zealot_male_b__vce_catapulted_land",
			zealot_male_c = "wwise/events/player/play_zealot_male_c__vce_catapulted_land",
			psyker_female_b = "wwise/events/player/play_psyker_female_b__vce_catapulted_land",
			psyker_female_a = "wwise/events/player/play_psyker_female_a__vce_catapulted_land",
			psyker_male_a = "wwise/events/player/play_psyker_male_a__vce_catapulted_land",
			zealot_female_a = "wwise/events/player/play_zealot_female_a__vce_catapulted_land",
			veteran_female_a = "wwise/events/player/play_veteran_female_a__vce_catapulted_land",
			ogryn_c = "wwise/events/player/play_ogryn_c__vce_catapulted_land",
			psyker_male_c = "wwise/events/player/play_psyker_male_c__vce_catapulted_land",
			veteran_male_a = "wwise/events/player/play_veteran_male_a__vce_catapulted_land",
			veteran_female_b = "wwise/events/player/play_veteran_female_b__vce_catapulted_land"
		}
	},
	getting_up_vce = {
		has_husk_events = true,
		switch = {
			"selected_voice"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			veteran_male_b = "wwise/events/player/play_veteran_male_b__vce_getting_up",
			zealot_female_c = "wwise/events/player/play_zealot_female_c__vce_getting_up",
			veteran_female_c = "wwise/events/player/play_veteran_female_c__vce_getting_up",
			ogryn_a = "wwise/events/player/play_ogryn_a__vce_getting_up",
			psyker_female_c = "wwise/events/player/play_psyker_female_c__vce_getting_up",
			ogryn_b = "wwise/events/player/play_ogryn_b__vce_getting_up",
			veteran_male_c = "wwise/events/player/play_veteran_male_c__vce_getting_up",
			zealot_female_b = "wwise/events/player/play_zealot_female_b__vce_getting_up",
			explicator_a = "wwise/events/player/play_veteran_female_c__vce_getting_up",
			psyker_male_b = "wwise/events/player/play_psyker_male_b__vce_getting_up",
			zealot_male_a = "wwise/events/player/play_zealot_male_a__vce_getting_up",
			zealot_male_b = "wwise/events/player/play_zealot_male_b__vce_getting_up",
			zealot_male_c = "wwise/events/player/play_zealot_male_c__vce_getting_up",
			psyker_female_b = "wwise/events/player/play_psyker_female_b__vce_getting_up",
			psyker_female_a = "wwise/events/player/play_psyker_female_a__vce_getting_up",
			psyker_male_a = "wwise/events/player/play_psyker_male_a__vce_getting_up",
			zealot_female_a = "wwise/events/player/play_zealot_female_a__vce_getting_up",
			veteran_female_a = "wwise/events/player/play_veteran_female_a__vce_getting_up",
			ogryn_c = "wwise/events/player/play_ogryn_c__vce_getting_up",
			psyker_male_c = "wwise/events/player/play_psyker_male_c__vce_getting_up",
			veteran_male_a = "wwise/events/player/play_veteran_male_a__vce_getting_up",
			veteran_female_b = "wwise/events/player/play_veteran_female_b__vce_getting_up"
		}
	},
	grunt_short_vce = {
		has_husk_events = true,
		switch = {
			"selected_voice"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			veteran_male_b = "wwise/events/player/play_veteran_male_b__vce_grunt_short",
			zealot_female_c = "wwise/events/player/play_zealot_female_c__vce_grunt_short",
			veteran_female_c = "wwise/events/player/play_veteran_female_c__vce_grunt_short",
			ogryn_a = "wwise/events/player/play_ogryn_a__vce_grunt_short",
			psyker_female_c = "wwise/events/player/play_psyker_female_c__vce_grunt_short",
			ogryn_b = "wwise/events/player/play_ogryn_b__vce_grunt_short",
			veteran_male_c = "wwise/events/player/play_veteran_male_c__vce_grunt_short",
			zealot_female_b = "wwise/events/player/play_zealot_female_b__vce_grunt_short",
			explicator_a = "wwise/events/player/play_veteran_female_c__vce_grunt_short",
			psyker_male_b = "wwise/events/player/play_psyker_male_b__vce_grunt_short",
			zealot_male_a = "wwise/events/player/play_zealot_male_a__vce_grunt_short",
			zealot_male_b = "wwise/events/player/play_zealot_male_b__vce_grunt_short",
			zealot_male_c = "wwise/events/player/play_zealot_male_c__vce_grunt_short",
			psyker_female_b = "wwise/events/player/play_psyker_female_b__vce_grunt_short",
			psyker_female_a = "wwise/events/player/play_psyker_female_a__vce_grunt_short",
			psyker_male_a = "wwise/events/player/play_psyker_male_a__vce_grunt_short",
			zealot_female_a = "wwise/events/player/play_zealot_female_a__vce_grunt_short",
			veteran_female_a = "wwise/events/player/play_veteran_female_a__vce_grunt_short",
			ogryn_c = "wwise/events/player/play_ogryn_c__vce_grunt_short",
			psyker_male_c = "wwise/events/player/play_psyker_male_c__vce_grunt_short",
			veteran_male_a = "wwise/events/player/play_veteran_male_a__vce_grunt_short",
			veteran_female_b = "wwise/events/player/play_veteran_female_b__vce_grunt_short"
		}
	},
	hurt_heavy_vce = {
		has_husk_events = true,
		switch = {
			"selected_voice"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			veteran_male_b = "wwise/events/player/play_veteran_male_b__vce_hurt_heavy",
			zealot_female_c = "wwise/events/player/play_zealot_female_c__vce_hurt_heavy",
			veteran_female_c = "wwise/events/player/play_veteran_female_c__vce_hurt_heavy",
			ogryn_a = "wwise/events/player/play_ogryn_a__vce_hurt_heavy",
			psyker_female_c = "wwise/events/player/play_psyker_female_c__vce_hurt_heavy",
			ogryn_b = "wwise/events/player/play_ogryn_b__vce_hurt_heavy",
			veteran_male_c = "wwise/events/player/play_veteran_male_c__vce_hurt_heavy",
			zealot_female_b = "wwise/events/player/play_zealot_female_b__vce_hurt_heavy",
			explicator_a = "wwise/events/player/play_veteran_female_c__vce_hurt_heavy",
			psyker_male_b = "wwise/events/player/play_psyker_male_b__vce_hurt_heavy",
			zealot_male_a = "wwise/events/player/play_zealot_male_a__vce_hurt_heavy",
			zealot_male_b = "wwise/events/player/play_zealot_male_b__vce_hurt_heavy",
			zealot_male_c = "wwise/events/player/play_zealot_male_c__vce_hurt_heavy",
			psyker_female_b = "wwise/events/player/play_psyker_female_b__vce_hurt_heavy",
			psyker_female_a = "wwise/events/player/play_psyker_female_a__vce_hurt_heavy",
			psyker_male_a = "wwise/events/player/play_psyker_male_a__vce_hurt_heavy",
			zealot_female_a = "wwise/events/player/play_zealot_female_a__vce_hurt_heavy",
			veteran_female_a = "wwise/events/player/play_veteran_female_a__vce_hurt_heavy",
			ogryn_c = "wwise/events/player/play_ogryn_c__vce_hurt_heavy",
			psyker_male_c = "wwise/events/player/play_psyker_male_c__vce_hurt_heavy",
			veteran_male_a = "wwise/events/player/play_veteran_male_a__vce_hurt_heavy",
			veteran_female_b = "wwise/events/player/play_veteran_female_b__vce_hurt_heavy"
		}
	},
	hurt_light_vce = {
		has_husk_events = true,
		switch = {
			"selected_voice"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			veteran_male_b = "wwise/events/player/play_veteran_male_b__vce_hurt_light",
			zealot_female_c = "wwise/events/player/play_zealot_female_c__vce_hurt_light",
			veteran_female_c = "wwise/events/player/play_veteran_female_c__vce_hurt_light",
			ogryn_a = "wwise/events/player/play_ogryn_a__vce_hurt_light",
			psyker_female_c = "wwise/events/player/play_psyker_female_c__vce_hurt_light",
			ogryn_b = "wwise/events/player/play_ogryn_b__vce_hurt_light",
			veteran_male_c = "wwise/events/player/play_veteran_male_c__vce_hurt_light",
			zealot_female_b = "wwise/events/player/play_zealot_female_b__vce_hurt_light",
			explicator_a = "wwise/events/player/play_veteran_female_c__vce_hurt_light",
			psyker_male_b = "wwise/events/player/play_psyker_male_b__vce_hurt_light",
			zealot_male_a = "wwise/events/player/play_zealot_male_a__vce_hurt_light",
			zealot_male_b = "wwise/events/player/play_zealot_male_b__vce_hurt_light",
			zealot_male_c = "wwise/events/player/play_zealot_male_c__vce_hurt_light",
			psyker_female_b = "wwise/events/player/play_psyker_female_b__vce_hurt_light",
			psyker_female_a = "wwise/events/player/play_psyker_female_a__vce_hurt_light",
			psyker_male_a = "wwise/events/player/play_psyker_male_a__vce_hurt_light",
			zealot_female_a = "wwise/events/player/play_zealot_female_a__vce_hurt_light",
			veteran_female_a = "wwise/events/player/play_veteran_female_a__vce_hurt_light",
			ogryn_c = "wwise/events/player/play_ogryn_c__vce_hurt_light",
			psyker_male_c = "wwise/events/player/play_psyker_male_c__vce_hurt_light",
			veteran_male_a = "wwise/events/player/play_veteran_male_a__vce_hurt_light",
			veteran_female_b = "wwise/events/player/play_veteran_female_b__vce_hurt_light"
		}
	},
	idle_vce = {
		has_husk_events = true,
		switch = {
			"selected_voice"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			veteran_male_b = "wwise/events/player/play_veteran_male_b__vce_idle",
			zealot_female_c = "wwise/events/player/play_zealot_female_c__vce_idle",
			veteran_female_c = "wwise/events/player/play_veteran_female_c__vce_idle",
			ogryn_a = "wwise/events/player/play_ogryn_a__vce_idle",
			psyker_female_c = "wwise/events/player/play_psyker_female_c__vce_idle",
			ogryn_b = "wwise/events/player/play_ogryn_b__vce_idle",
			veteran_male_c = "wwise/events/player/play_veteran_male_c__vce_idle",
			zealot_female_b = "wwise/events/player/play_zealot_female_b__vce_idle",
			explicator_a = "wwise/events/player/play_veteran_female_c__vce_idle",
			psyker_male_b = "wwise/events/player/play_psyker_male_b__vce_idle",
			zealot_male_a = "wwise/events/player/play_zealot_male_a__vce_idle",
			zealot_male_b = "wwise/events/player/play_zealot_male_b__vce_idle",
			zealot_male_c = "wwise/events/player/play_zealot_male_c__vce_idle",
			psyker_female_b = "wwise/events/player/play_psyker_female_b__vce_idle",
			psyker_female_a = "wwise/events/player/play_psyker_female_a__vce_idle",
			psyker_male_a = "wwise/events/player/play_psyker_male_a__vce_idle",
			zealot_female_a = "wwise/events/player/play_zealot_female_a__vce_idle",
			veteran_female_a = "wwise/events/player/play_veteran_female_a__vce_idle",
			ogryn_c = "wwise/events/player/play_ogryn_c__vce_idle",
			psyker_male_c = "wwise/events/player/play_psyker_male_c__vce_idle",
			veteran_male_a = "wwise/events/player/play_veteran_male_a__vce_idle",
			veteran_female_b = "wwise/events/player/play_veteran_female_b__vce_idle"
		}
	},
	jump_vce = {
		has_husk_events = true,
		switch = {
			"selected_voice"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			veteran_male_b = "wwise/events/player/play_veteran_male_b__vce_jump",
			zealot_female_c = "wwise/events/player/play_zealot_female_c__vce_jump",
			veteran_female_c = "wwise/events/player/play_veteran_female_c__vce_jump",
			ogryn_a = "wwise/events/player/play_ogryn_a__vce_jump",
			psyker_female_c = "wwise/events/player/play_psyker_female_c__vce_jump",
			ogryn_b = "wwise/events/player/play_ogryn_b__vce_jump",
			veteran_male_c = "wwise/events/player/play_veteran_male_c__vce_jump",
			zealot_female_b = "wwise/events/player/play_zealot_female_b__vce_jump",
			explicator_a = "wwise/events/player/play_veteran_female_c__vce_jump",
			psyker_male_b = "wwise/events/player/play_psyker_male_b__vce_jump",
			zealot_male_a = "wwise/events/player/play_zealot_male_a__vce_jump",
			zealot_male_b = "wwise/events/player/play_zealot_male_b__vce_jump",
			zealot_male_c = "wwise/events/player/play_zealot_male_c__vce_jump",
			psyker_female_b = "wwise/events/player/play_psyker_female_b__vce_jump",
			psyker_female_a = "wwise/events/player/play_psyker_female_a__vce_jump",
			psyker_male_a = "wwise/events/player/play_psyker_male_a__vce_jump",
			zealot_female_a = "wwise/events/player/play_zealot_female_a__vce_jump",
			veteran_female_a = "wwise/events/player/play_veteran_female_a__vce_jump",
			ogryn_c = "wwise/events/player/play_ogryn_c__vce_jump",
			psyker_male_c = "wwise/events/player/play_psyker_male_c__vce_jump",
			veteran_male_a = "wwise/events/player/play_veteran_male_a__vce_jump",
			veteran_female_b = "wwise/events/player/play_veteran_female_b__vce_jump"
		}
	},
	land_heavy_vce = {
		has_husk_events = true,
		switch = {
			"selected_voice"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			veteran_male_b = "wwise/events/player/play_veteran_male_b__vce_land_heavy",
			zealot_female_c = "wwise/events/player/play_zealot_female_c__vce_land_heavy",
			veteran_female_c = "wwise/events/player/play_veteran_female_c__vce_land_heavy",
			ogryn_a = "wwise/events/player/play_ogryn_a__vce_land_heavy",
			psyker_female_c = "wwise/events/player/play_psyker_female_c__vce_land_heavy",
			ogryn_b = "wwise/events/player/play_ogryn_b__vce_land_heavy",
			veteran_male_c = "wwise/events/player/play_veteran_male_c__vce_land_heavy",
			zealot_female_b = "wwise/events/player/play_zealot_female_b__vce_land_heavy",
			explicator_a = "wwise/events/player/play_veteran_female_c__vce_land_heavy",
			psyker_male_b = "wwise/events/player/play_psyker_male_b__vce_land_heavy",
			zealot_male_a = "wwise/events/player/play_zealot_male_a__vce_land_heavy",
			zealot_male_b = "wwise/events/player/play_zealot_male_b__vce_land_heavy",
			zealot_male_c = "wwise/events/player/play_zealot_male_c__vce_land_heavy",
			psyker_female_b = "wwise/events/player/play_psyker_female_b__vce_land_heavy",
			psyker_female_a = "wwise/events/player/play_psyker_female_a__vce_land_heavy",
			psyker_male_a = "wwise/events/player/play_psyker_male_a__vce_land_heavy",
			zealot_female_a = "wwise/events/player/play_zealot_female_a__vce_land_heavy",
			veteran_female_a = "wwise/events/player/play_veteran_female_a__vce_land_heavy",
			ogryn_c = "wwise/events/player/play_ogryn_c__vce_land_heavy",
			psyker_male_c = "wwise/events/player/play_psyker_male_c__vce_land_heavy",
			veteran_male_a = "wwise/events/player/play_veteran_male_a__vce_land_heavy",
			veteran_female_b = "wwise/events/player/play_veteran_female_b__vce_land_heavy"
		}
	},
	lifting_vce = {
		has_husk_events = true,
		switch = {
			"selected_voice"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			veteran_male_b = "wwise/events/player/play_veteran_male_b__vce_lifting",
			zealot_female_c = "wwise/events/player/play_zealot_female_c__vce_lifting",
			veteran_female_c = "wwise/events/player/play_veteran_female_c__vce_lifting",
			ogryn_a = "wwise/events/player/play_ogryn_a__vce_lifting",
			psyker_female_c = "wwise/events/player/play_psyker_female_c__vce_lifting",
			ogryn_b = "wwise/events/player/play_ogryn_b__vce_lifting",
			veteran_male_c = "wwise/events/player/play_veteran_male_c__vce_lifting",
			zealot_female_b = "wwise/events/player/play_zealot_female_b__vce_lifting",
			explicator_a = "wwise/events/player/play_veteran_female_c__vce_lifting",
			psyker_male_b = "wwise/events/player/play_psyker_male_b__vce_lifting",
			zealot_male_a = "wwise/events/player/play_zealot_male_a__vce_lifting",
			zealot_male_b = "wwise/events/player/play_zealot_male_b__vce_lifting",
			zealot_male_c = "wwise/events/player/play_zealot_male_c__vce_lifting",
			psyker_female_b = "wwise/events/player/play_psyker_female_b__vce_lifting",
			psyker_female_a = "wwise/events/player/play_psyker_female_a__vce_lifting",
			psyker_male_a = "wwise/events/player/play_psyker_male_a__vce_lifting",
			zealot_female_a = "wwise/events/player/play_zealot_female_a__vce_lifting",
			veteran_female_a = "wwise/events/player/play_veteran_female_a__vce_lifting",
			ogryn_c = "wwise/events/player/play_ogryn_c__vce_lifting",
			psyker_male_c = "wwise/events/player/play_psyker_male_c__vce_lifting",
			veteran_male_a = "wwise/events/player/play_veteran_male_a__vce_lifting",
			veteran_female_b = "wwise/events/player/play_veteran_female_b__vce_lifting"
		}
	},
	scream_long_vce = {
		has_husk_events = true,
		switch = {
			"selected_voice"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			veteran_male_b = "wwise/events/player/play_veteran_male_b__vce_scream_long",
			zealot_female_c = "wwise/events/player/play_zealot_female_c__vce_scream_long",
			veteran_female_c = "wwise/events/player/play_veteran_female_c__vce_scream_long",
			ogryn_a = "wwise/events/player/play_ogryn_a__vce_scream_long",
			psyker_female_c = "wwise/events/player/play_psyker_female_c__vce_scream_long",
			ogryn_b = "wwise/events/player/play_ogryn_b__vce_scream_long",
			veteran_male_c = "wwise/events/player/play_veteran_male_c__vce_scream_long",
			zealot_female_b = "wwise/events/player/play_zealot_female_b__vce_scream_long",
			explicator_a = "wwise/events/player/play_veteran_female_c__vce_scream_long",
			psyker_male_b = "wwise/events/player/play_psyker_male_b__vce_scream_long",
			zealot_male_a = "wwise/events/player/play_zealot_male_a__vce_scream_long",
			zealot_male_b = "wwise/events/player/play_zealot_male_b__vce_scream_long",
			zealot_male_c = "wwise/events/player/play_zealot_male_c__vce_scream_long",
			psyker_female_b = "wwise/events/player/play_psyker_female_b__vce_scream_long",
			psyker_female_a = "wwise/events/player/play_psyker_female_a__vce_scream_long",
			psyker_male_a = "wwise/events/player/play_psyker_male_a__vce_scream_long",
			zealot_female_a = "wwise/events/player/play_zealot_female_a__vce_scream_long",
			veteran_female_a = "wwise/events/player/play_veteran_female_a__vce_scream_long",
			ogryn_c = "wwise/events/player/play_ogryn_c__vce_scream_long",
			psyker_male_c = "wwise/events/player/play_psyker_male_c__vce_scream_long",
			veteran_male_a = "wwise/events/player/play_veteran_male_a__vce_scream_long",
			veteran_female_b = "wwise/events/player/play_veteran_female_b__vce_scream_long"
		}
	},
	struggle_heavy_vce = {
		has_husk_events = false,
		switch = {
			"selected_voice"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			veteran_male_b = "wwise/events/player/play_veteran_male_b_vce_struggle_heavy",
			zealot_female_c = "wwise/events/player/play_zealot_female_c_vce_struggle_heavy",
			veteran_female_c = "wwise/events/player/play_veteran_female_c_vce_struggle_heavy",
			ogryn_a = "wwise/events/player/play_ogryn_a_vce_struggle_heavy",
			psyker_female_c = "wwise/events/player/play_psyker_female_c_vce_struggle_heavy",
			ogryn_b = "wwise/events/player/play_ogryn_b_vce_struggle_heavy",
			veteran_male_c = "wwise/events/player/play_veteran_male_c_vce_struggle_heavy",
			zealot_female_b = "wwise/events/player/play_zealot_female_b_vce_struggle_heavy",
			explicator_a = "wwise/events/player/play_veteran_female_c_vce_struggle_heavy",
			psyker_male_b = "wwise/events/player/play_psyker_male_b_vce_struggle_heavy",
			zealot_male_a = "wwise/events/player/play_zealot_male_a_vce_struggle_heavy",
			zealot_male_b = "wwise/events/player/play_zealot_male_b_vce_struggle_heavy",
			zealot_male_c = "wwise/events/player/play_zealot_male_c_vce_struggle_heavy",
			psyker_female_b = "wwise/events/player/play_psyker_female_b_vce_struggle_heavy",
			psyker_female_a = "wwise/events/player/play_psyker_female_a_vce_struggle_heavy",
			psyker_male_a = "wwise/events/player/play_psyker_male_a_vce_struggle_heavy",
			zealot_female_a = "wwise/events/player/play_zealot_female_a_vce_struggle_heavy",
			veteran_female_a = "wwise/events/player/play_veteran_female_a_vce_struggle_heavy",
			ogryn_c = "wwise/events/player/play_ogryn_c_vce_struggle_heavy",
			psyker_male_c = "wwise/events/player/play_psyker_male_c_vce_struggle_heavy",
			veteran_male_a = "wwise/events/player/play_veteran_male_a_vce_struggle_heavy",
			veteran_female_b = "wwise/events/player/play_veteran_female_b_vce_struggle_heavy"
		}
	},
	struggle_light_vce = {
		has_husk_events = false,
		switch = {
			"selected_voice"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			veteran_male_b = "wwise/events/player/play_veteran_male_b_vce_struggle_heavy",
			zealot_female_c = "wwise/events/player/play_zealot_female_c_vce_struggle_heavy",
			veteran_female_c = "wwise/events/player/play_veteran_female_c_vce_struggle_heavy",
			ogryn_a = "wwise/events/player/play_ogryn_a_vce_struggle_heavy",
			psyker_female_c = "wwise/events/player/play_psyker_female_c_vce_struggle_heavy",
			ogryn_b = "wwise/events/player/play_ogryn_b_vce_struggle_heavy",
			veteran_male_c = "wwise/events/player/play_veteran_male_c_vce_struggle_heavy",
			zealot_female_b = "wwise/events/player/play_zealot_female_b_vce_struggle_heavy",
			explicator_a = "wwise/events/player/play_veteran_female_c_vce_struggle_heavy",
			psyker_male_b = "wwise/events/player/play_psyker_male_b_vce_struggle_heavy",
			zealot_male_a = "wwise/events/player/play_zealot_male_a_vce_struggle_heavy",
			zealot_male_b = "wwise/events/player/play_zealot_male_b_vce_struggle_heavy",
			zealot_male_c = "wwise/events/player/play_zealot_male_c_vce_struggle_heavy",
			psyker_female_b = "wwise/events/player/play_psyker_female_b_vce_struggle_heavy",
			psyker_female_a = "wwise/events/player/play_psyker_female_a_vce_struggle_heavy",
			psyker_male_a = "wwise/events/player/play_psyker_male_a_vce_struggle_heavy",
			zealot_female_a = "wwise/events/player/play_zealot_female_a_vce_struggle_heavy",
			veteran_female_a = "wwise/events/player/play_veteran_female_a_vce_struggle_heavy",
			ogryn_c = "wwise/events/player/play_ogryn_c_vce_struggle_heavy",
			psyker_male_c = "wwise/events/player/play_psyker_male_c_vce_struggle_heavy",
			veteran_male_a = "wwise/events/player/play_veteran_male_a_vce_struggle_heavy",
			veteran_female_b = "wwise/events/player/play_veteran_female_b_vce_struggle_heavy"
		}
	},
	sfx_grab_clip = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/player/play_foley_hands_grab_clip",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_reload_grab_new",
			bot_zola_laspistol = "wwise/events/weapon/play_lasgun_reload_grab_clip",
			bot_lasgun_killshot = "wwise/events/weapon/play_lasgun_reload_grab_clip",
			laspistol_p1_m1 = "wwise/events/weapon/play_lasgun_reload_grab_clip",
			lasgun_p1_m2 = "wwise/events/weapon/play_lasgun_reload_grab_clip",
			laspistol_p1_m3 = "wwise/events/weapon/play_lasgun_reload_grab_clip",
			laspistol_p1_m2 = "wwise/events/weapon/play_lasgun_reload_grab_clip",
			lasgun_p1_m1 = "wwise/events/weapon/play_lasgun_reload_grab_clip",
			bot_laspistol_killshot = "wwise/events/weapon/play_lasgun_reload_grab_clip",
			lasgun_p1_m3 = "wwise/events/weapon/play_lasgun_reload_grab_clip"
		}
	},
	sfx_grab_weapon = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			autopistol_p1_m2 = "wwise/events/weapon/play_autopistol_reload_end",
			autopistol_p1_m3 = "wwise/events/weapon/play_autopistol_reload_end",
			combatsword_p3_m1 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			forcesword_p1_m1 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			combatsword_p3_m2 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_lever_grab",
			default = "wwise/events/player/play_foley_hands_grab_range_weapon",
			thunderhammer_2h_p1_m1 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			powersword_p1_m1 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			thunderhammer_2h_p1_m2 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			combatsword_p3_m3 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			lasgun_p3_m3 = "wwise/events/weapon/play_lasgun_p3_grab",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_ogryn_hand_on_weapon",
			forcesword_p1_m2 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			combatsword_p1_m3 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			lasgun_p3_m1 = "wwise/events/weapon/play_lasgun_p3_grab",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_lever_grab",
			lasgun_p3_m2 = "wwise/events/weapon/play_lasgun_p3_grab",
			combatsword_p1_m1 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			thunderhammer_2h_p1_m3 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			combatsword_p2_m2 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			powersword_p1_m2 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			autopistol_p1_m1 = "wwise/events/weapon/play_autopistol_reload_end",
			forcesword_p1_m3 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			combatsword_p1_m2 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			powermaul_2h_p1_m1 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			combatsword_p2_m3 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			bot_combatsword_linesman_p1 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_lever_grab",
			bot_combatsword_linesman_p2 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			combatsword_p2_m1 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			powersword_p1_m3 = "wwise/events/player/play_foley_hands_grip_melee_handle"
		}
	},
	sfx_pull_pin = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_grenade_pull_pin",
			krak_grenade = "wwise/events/weapon/play_grenade_pull_pin",
			ogryn_grenade = "wwise/events/weapon/play_grenade_pull_pin",
			fire_grenade = "wwise/events/weapon/play_grenade_pull_pin",
			frag_grenade = "wwise/events/weapon/play_grenade_pull_pin"
		}
	},
	sfx_equip = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_autopistol_equip",
			shock_grenade = "wwise/events/weapon/play_grenade_equip",
			bot_zola_laspistol = "wwise/events/weapon/play_autopistol_equip",
			flamer_p1_m1 = "wwise/events/weapon/play_flametrower_equip_var_1",
			combatsword_p2_m1 = "wwise/events/weapon/play_sword_light_equip",
			luggable = "wwise/events/player/play_foley_melee_equip_gen_short",
			powersword_p1_m2 = "wwise/events/weapon/play_weapon_equip_medium_sword",
			autogun_p1_m3 = "wwise/events/weapon/play_autogun_equip",
			powermaul_2h_p1_m1 = "wwise/events/weapon/play_weapon_equip_thunder_hammer",
			autogun_p3_m2 = "wwise/events/weapon/play_autogun_p3_equip",
			bot_laspistol_killshot = "wwise/events/weapon/play_autopistol_equip",
			autogun_p2_m1 = "wwise/events/weapon/play_autogun_p2_equip",
			bot_combatsword_linesman_p2 = "wwise/events/weapon/play_sword_light_equip",
			thunderhammer_2h_p1_m2 = "wwise/events/weapon/play_weapon_equip_thunder_hammer",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_heavy_stubber_wpn_up",
			ogryn_club_p2_m2 = "wwise/events/weapon/play_pipe_club_equip",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_equip",
			lasgun_p3_m2 = "wwise/events/weapon/play_lasgun_p3_equip",
			forcestaff_p1_m1 = "wwise/events/weapon/play_force_staff_equip",
			autogun_p3_m1 = "wwise/events/weapon/play_autogun_p3_equip",
			ogryn_club_p1_m2 = "wwise/events/weapon/play_ogryn_shovel_equip",
			bot_combatsword_linesman_p1 = "wwise/events/weapon/play_weapon_equip_medium_sword",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_equip",
			lasgun_p3_m1 = "wwise/events/weapon/play_lasgun_p3_equip",
			ogryn_club_p2_m3 = "wwise/events/weapon/play_pipe_club_equip",
			combataxe_p1_m3 = "wwise/events/weapon/play_pipe_club_equip",
			combatsword_p2_m3 = "wwise/events/weapon/play_sword_light_equip",
			lasgun_p2_m1 = "wwise/events/weapon/play_lasgun_p2_equip",
			lasgun_p1_m2 = "wwise/events/weapon/play_weapon_lasgun_equip",
			lasgun_p2_m2 = "wwise/events/weapon/play_lasgun_p2_equip",
			ogryn_combatblade_p1_m1 = "wwise/events/weapon/play_ogryn_knife_equip",
			powersword_p1_m3 = "wwise/events/weapon/play_weapon_equip_medium_sword",
			lasgun_p2_m3 = "wwise/events/weapon/play_lasgun_p2_equip",
			forcestaff_p4_m1 = "wwise/events/weapon/play_force_staff_equip",
			ogryn_club_p2_m1 = "wwise/events/weapon/play_pipe_club_equip",
			ogryn_thumper_p1_m3 = "wwise/events/weapon/thumper_shotgun_close",
			laspistol_p1_m1 = "wwise/events/weapon/play_autopistol_equip",
			combatknife_p1_m1 = "wwise/events/weapon/play_combat_knife_equip_var_1",
			ogryn_club_p1_m1 = "wwise/events/weapon/play_ogryn_shovel_equip",
			laspistol_p1_m3 = "wwise/events/weapon/play_autopistol_equip",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_equip_var_1",
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_weapon_rippergun_equip",
			combatsword_p3_m3 = "wwise/events/weapon/play_weapon_equip_medium_sword",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/thumper_shotgun_close",
			tome_pocketable = "wwise/events/player/play_foley_melee_equip_gen_short",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_heavy_stubber_wpn_up",
			combatsword_p3_m1 = "wwise/events/weapon/play_weapon_equip_medium_sword",
			ogryn_club_p1_m3 = "wwise/events/weapon/play_ogryn_shovel_equip",
			combatknife_p1_m3 = "wwise/events/weapon/play_combat_knife_equip_var_1",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_heavy_stubber_wpn_up",
			combatsword_p1_m1 = "wwise/events/weapon/play_weapon_equip_medium_sword",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_weapon_rippergun_equip",
			combatsword_p2_m2 = "wwise/events/weapon/play_sword_light_equip",
			plasmagun_p1_m1 = "wwise/events/weapon/play_weapon_equip_plasma_gun",
			autopistol_p1_m1 = "wwise/events/weapon/play_autopistol_equip",
			plasmagun_p2_m1 = "wwise/events/weapon/play_weapon_equip_plasma_gun",
			stubrevolver_p1_m3 = "wwise/events/weapon/play_stub_revolver_equip",
			shotgun_p1_m1 = "wwise/events/weapon/play_shotgun_equip",
			combatknife_p1_m2 = "wwise/events/weapon/play_combat_knife_equip_var_1",
			shotgun_p1_m2 = "wwise/events/weapon/play_shotgun_equip",
			fire_grenade = "wwise/events/weapon/play_grenade_equip",
			frag_grenade = "wwise/events/weapon/play_grenade_equip",
			krak_grenade = "wwise/events/weapon/play_grenade_equip",
			bot_lasgun_killshot = "wwise/events/weapon/play_weapon_lasgun_equip",
			stubrevolver_p1_m2 = "wwise/events/weapon/play_stub_revolver_equip",
			autogun_p2_m2 = "wwise/events/weapon/play_autogun_p2_equip",
			syringe_corruption_pocketable = "wwise/events/player/play_syringe_equip",
			forcesword_p1_m1 = "wwise/events/weapon/play_sword_light_equip",
			combatsword_p3_m2 = "wwise/events/weapon/play_weapon_equip_medium_sword",
			lasgun_p3_m3 = "wwise/events/weapon/play_lasgun_p3_equip",
			shotgun_p1_m3 = "wwise/events/weapon/play_shotgun_equip",
			grimoire_pocketable = "wwise/events/player/play_foley_melee_equip_gen_short",
			powersword_p1_m1 = "wwise/events/weapon/play_weapon_equip_medium_sword",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/thumper_shotgun_close",
			forcestaff_p2_m1 = "wwise/events/weapon/play_force_staff_equip",
			autogun_p2_m3 = "wwise/events/weapon/play_autogun_p2_equip",
			forcestaff_p2_m2 = "wwise/events/weapon/play_force_staff_equip",
			forcesword_p1_m2 = "wwise/events/weapon/play_sword_light_equip",
			ogryn_combatblade_p1_m2 = "wwise/events/weapon/play_ogryn_knife_equip",
			thunderhammer_2h_p1_m3 = "wwise/events/weapon/play_weapon_equip_thunder_hammer",
			combataxe_p1_m1 = "wwise/events/weapon/play_pipe_club_equip",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_stub_revolver_equip",
			forcesword_p1_m3 = "wwise/events/weapon/play_sword_light_equip",
			ogryn_powermaul_slabshield_p1_m1 = "wwise/events/weapon/play_pipe_club_equip",
			forcestaff_p3_m1 = "wwise/events/weapon/play_force_staff_equip",
			autopistol_p1_m2 = "wwise/events/weapon/play_autopistol_equip",
			bot_combataxe_linesman = "wwise/events/weapon/play_pipe_club_equip",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_weapon_rippergun_equip",
			bot_autogun_killshot = "wwise/events/weapon/play_autogun_p3_equip",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/play_weapon_equip_thunder_hammer",
			autopistol_p1_m3 = "wwise/events/weapon/play_autopistol_equip",
			auspex_scanner = "wwise/events/weapon/play_stub_revolver_equip",
			autogun_p1_m1 = "wwise/events/weapon/play_autogun_equip",
			combatsword_p1_m3 = "wwise/events/weapon/play_weapon_equip_medium_sword",
			lasgun_p1_m3 = "wwise/events/weapon/play_weapon_lasgun_equip",
			ogryn_powermaul_p1_m1 = "wwise/events/weapon/play_pipe_club_equip",
			ogryn_combatblade_p1_m3 = "wwise/events/weapon/play_ogryn_knife_equip",
			autogun_p1_m2 = "wwise/events/weapon/play_autogun_equip",
			ogryn_grenade_box = "wwise/events/weapon/play_ogryn_grenade_crate_equip",
			combataxe_p1_m2 = "wwise/events/weapon/play_pipe_club_equip",
			combatsword_p1_m2 = "wwise/events/weapon/play_weapon_equip_medium_sword",
			laspistol_p1_m2 = "wwise/events/weapon/play_autopistol_equip",
			lasgun_p1_m1 = "wwise/events/weapon/play_weapon_lasgun_equip",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_equip",
			autogun_p3_m3 = "wwise/events/weapon/play_autogun_p3_equip"
		}
	},
	sfx_int_gen_finish = {
		no_default = true,
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			grimoire_pocketable = "wwise/events/player/play_grimoire_unequip_finish"
		}
	},
	sfx_equip_stop = {
		no_default = true,
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {}
	},
	sfx_equip_02 = {
		no_default = true,
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			flamer_p1_m1 = "wwise/events/weapon/play_flametrower_equip_var_2",
			ogryn_club_p2_m1 = "wwise/events/weapon/play_physical_swing",
			combatknife_p1_m1 = "wwise/events/weapon/play_combat_knife_equip_var_2",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/play_weapon_thunder_hammer_spin",
			lasgun_p3_m3 = "wwise/events/weapon/play_lasgun_p3_equip_grab",
			thunderhammer_2h_p1_m2 = "wwise/events/weapon/play_weapon_thunder_hammer_spin",
			lasgun_p2_m3 = "wwise/events/weapon/play_lasgun_p2_equip_lever",
			combatknife_p1_m3 = "wwise/events/weapon/play_combat_knife_equip_var_2",
			lasgun_p3_m2 = "wwise/events/weapon/play_lasgun_p3_equip_grab",
			thunderhammer_2h_p1_m3 = "wwise/events/weapon/play_weapon_thunder_hammer_spin",
			lasgun_p2_m2 = "wwise/events/weapon/play_lasgun_p2_equip_lever",
			lasgun_p3_m1 = "wwise/events/weapon/play_lasgun_p3_equip_grab",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_equip_var_2",
			combatknife_p1_m2 = "wwise/events/weapon/play_combat_knife_equip_var_2",
			lasgun_p2_m1 = "wwise/events/weapon/play_lasgun_p2_equip_lever",
			ogryn_powermaul_slabshield_p1_m1 = "wwise/events/weapon/play_ogryn_slabshield_equip",
			ogryn_club_p2_m2 = "wwise/events/weapon/play_physical_swing"
		}
	},
	sfx_equip_03 = {
		no_default = true,
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			combatknife_p1_m3 = "wwise/events/weapon/play_combat_knife_equip_var_3",
			combatknife_p1_m1 = "wwise/events/weapon/play_combat_knife_equip_var_3",
			combatknife_p1_m2 = "wwise/events/weapon/play_combat_knife_equip_var_3"
		}
	},
	sfx_equip_04 = {
		no_default = true,
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			combatknife_p1_m3 = "wwise/events/weapon/play_combat_knife_equip_var_4",
			combatknife_p1_m1 = "wwise/events/weapon/play_combat_knife_equip_var_4",
			combatknife_p1_m2 = "wwise/events/weapon/play_combat_knife_equip_var_4"
		}
	},
	sfx_foley_equip = {
		has_husk_events = false,
		switch = {
			"sfx_body_material"
		},
		events = {
			default = "wwise/events/player/play_foley_melee_equip_gen_short"
		}
	},
	sfx_ads_up = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			laspistol_p1_m3 = "wwise/events/weapon/play_rifle_ads_up",
			bot_lasgun_killshot = "wwise/events/weapon/play_rifle_ads_up",
			bot_zola_laspistol = "wwise/events/weapon/play_rifle_ads_up",
			flamer_p1_m1 = "wwise/events/weapon/play_flametrower_alt_fire_on",
			default = "wwise/events/weapon/play_rifle_ads_up",
			ogryn_thumper_p1_m3 = "wwise/events/weapon/play_ogryn_wpn_up",
			shotgun_p1_m3 = "wwise/events/weapon/play_weapon_ads_foley_autogun",
			shotgun_p1_m2 = "wwise/events/weapon/play_weapon_ads_foley_autogun",
			shotgun_p1_m1 = "wwise/events/weapon/play_weapon_ads_foley_autogun",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_ogryn_wpn_up",
			autopistol_p1_m3 = "wwise/events/weapon/play_rifle_ads_up",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_revolver_ads_up",
			bot_laspistol_killshot = "wwise/events/weapon/play_rifle_ads_up",
			stubrevolver_p1_m2 = "wwise/events/weapon/play_revolver_ads_up",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_heavy_stubber_wpn_up",
			lasgun_p1_m3 = "wwise/events/weapon/play_rifle_ads_up",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_ads_up",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_heavy_stubber_wpn_up",
			stubrevolver_p1_m3 = "wwise/events/weapon/play_revolver_ads_up",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_heavy_stubber_wpn_up",
			laspistol_p1_m1 = "wwise/events/weapon/play_rifle_ads_up",
			lasgun_p1_m2 = "wwise/events/weapon/play_rifle_ads_up",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_ads_up",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_ogryn_wpn_up",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_wpn_up",
			laspistol_p1_m2 = "wwise/events/weapon/play_rifle_ads_up",
			lasgun_p1_m1 = "wwise/events/weapon/play_rifle_ads_up",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_ads_up"
		}
	},
	sfx_ads_down = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			laspistol_p1_m3 = "wwise/events/weapon/play_rifle_ads_down",
			default = "wwise/events/weapon/play_rifle_ads_down",
			bot_zola_laspistol = "wwise/events/weapon/play_rifle_ads_down",
			flamer_p1_m1 = "wwise/events/weapon/play_flametrower_alt_fire_off",
			bot_lasgun_killshot = "wwise/events/weapon/play_rifle_ads_down",
			autopistol_p1_m2 = "wwise/events/weapon/play_rifle_ads_down",
			shotgun_p1_m3 = "wwise/events/weapon/play_weapon_ads_foley_autogun",
			shotgun_p1_m1 = "wwise/events/weapon/play_weapon_ads_foley_autogun",
			shotgun_p1_m2 = "wwise/events/weapon/play_weapon_ads_foley_autogun",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_ogryn_wpn_down",
			autopistol_p1_m3 = "wwise/events/weapon/play_rifle_ads_down",
			ogryn_thumper_p1_m3 = "wwise/events/weapon/play_ogryn_wpn_down",
			bot_laspistol_killshot = "wwise/events/weapon/play_rifle_ads_down",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_revolver_ads_down",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_heavy_stubber_wpn_down",
			lasgun_p1_m3 = "wwise/events/weapon/play_rifle_ads_down",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_ads_down",
			stubrevolver_p1_m3 = "wwise/events/weapon/play_revolver_ads_down",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_heavy_stubber_wpn_down",
			stubrevolver_p1_m2 = "wwise/events/weapon/play_revolver_ads_down",
			laspistol_p1_m1 = "wwise/events/weapon/play_rifle_ads_down",
			lasgun_p1_m2 = "wwise/events/weapon/play_rifle_ads_down",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_ads_down",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_ogryn_wpn_down",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_heavy_stubber_wpn_down",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_wpn_down",
			laspistol_p1_m2 = "wwise/events/weapon/play_rifle_ads_down",
			lasgun_p1_m1 = "wwise/events/weapon/play_rifle_ads_down",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_ads_down",
			ogryn_powermaul_slabshield_p1_m1 = "wwise/events/weapon/play_weapon_large_metal_shield_slam"
		}
	},
	sfx_weapon_down = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			laspistol_p1_m3 = "wwise/events/weapon/play_rifle_subtle",
			default = "wwise/events/weapon/play_rifle_subtle",
			bot_zola_laspistol = "wwise/events/weapon/play_rifle_subtle",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_reload_hand_to_barrel",
			bot_lasgun_killshot = "wwise/events/weapon/play_rifle_subtle",
			luggable = "wwise/events/player/play_item_luggable_throw",
			shotgun_p1_m3 = "wwise/events/weapon/play_rifle_subtle",
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_weapon_rippergun_placed",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_weapon_rippergun_placed",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_rifle_heavy_subtle",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_heavy_stubber_wpn_down",
			ogryn_thumper_p1_m3 = "wwise/events/weapon/play_rifle_heavy_subtle",
			bot_laspistol_killshot = "wwise/events/weapon/play_rifle_subtle",
			shotgun_p1_m1 = "wwise/events/weapon/play_rifle_subtle",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_heavy_stubber_wpn_down",
			shotgun_p1_m2 = "wwise/events/weapon/play_rifle_subtle",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_heavy_stubber_wpn_down",
			bolter_p1_m1 = "wwise/events/weapon/play_rifle_heavy_subtle",
			ogryn_grenade_box = "wwise/events/weapon/play_ogryn_grenade_crate_charge",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_weapon_rippergun_placed",
			laspistol_p1_m1 = "wwise/events/weapon/play_rifle_subtle",
			lasgun_p1_m2 = "wwise/events/weapon/play_rifle_subtle",
			bolter_p1_m2 = "wwise/events/weapon/play_rifle_heavy_subtle",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_rifle_heavy_subtle",
			laspistol_p1_m2 = "wwise/events/weapon/play_rifle_subtle",
			lasgun_p1_m1 = "wwise/events/weapon/play_rifle_subtle",
			bolter_p1_m3 = "wwise/events/weapon/play_rifle_heavy_subtle"
		}
	},
	sfx_weapon_up = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_rifle_wpn_up",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_reload_lift",
			bot_zola_laspistol = "wwise/events/weapon/play_rifle_wpn_up",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_reload_lift",
			chainaxe_p1_m2 = "wwise/events/weapon/play_chainaxe_special_start",
			lasgun_p1_m2 = "wwise/events/weapon/play_rifle_wpn_up",
			shotgun_p1_m3 = "wwise/events/weapon/play_rifle_wpn_up",
			bot_lasgun_killshot = "wwise/events/weapon/play_rifle_wpn_up",
			bot_laspistol_killshot = "wwise/events/weapon/play_rifle_wpn_up",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_weapon_rippergun_lift",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_heavy_stubber_wpn_up",
			lasgun_p3_m3 = "wwise/events/weapon/play_rifle_wpn_up",
			shotgun_p1_m2 = "wwise/events/weapon/play_rifle_wpn_up",
			chainaxe_p1_m1 = "wwise/events/weapon/play_chainaxe_special_start",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_heavy_stubber_wpn_up",
			lasgun_p2_m3 = "wwise/events/weapon/play_rifle_wpn_up",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_heavy_stubber_wpn_up",
			lasgun_p3_m2 = "wwise/events/weapon/play_rifle_wpn_up",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_weapon_rippergun_lift",
			chainaxe_p1_m3 = "wwise/events/weapon/play_chainaxe_special_start",
			lasgun_p2_m2 = "wwise/events/weapon/play_rifle_wpn_up",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_reload_lift",
			lasgun_p3_m1 = "wwise/events/weapon/play_rifle_wpn_up",
			lasgun_p2_m1 = "wwise/events/weapon/play_rifle_wpn_up",
			laspistol_p1_m3 = "wwise/events/weapon/play_rifle_wpn_up",
			shotgun_p1_m1 = "wwise/events/weapon/play_rifle_wpn_up",
			ogryn_thumper_p1_m3 = "wwise/events/weapon/play_weapon_rippergun_lift",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_weapon_rippergun_lift",
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_weapon_rippergun_lift",
			lasgun_p1_m3 = "wwise/events/weapon/play_rifle_wpn_up",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_weapon_rippergun_lift",
			laspistol_p1_m1 = "wwise/events/weapon/play_rifle_wpn_up",
			laspistol_p1_m2 = "wwise/events/weapon/play_rifle_wpn_up",
			lasgun_p1_m1 = "wwise/events/weapon/play_rifle_wpn_up",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_reload_lift"
		}
	},
	sfx_weapon_locomotion = {
		has_husk_events = false,
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			lasgun_p2_m2 = "wwise/events/weapon/play_rifle_locomotion",
			autogun_p2_m2 = "wwise/events/weapon/play_rifle_locomotion",
			bot_zola_laspistol = "wwise/events/weapon/play_rifle_locomotion",
			flamer_p1_m1 = "wwise/events/weapon/play_liquid_locomotion",
			autopistol_p3_m2 = "wwise/events/weapon/play_smg_locomotion",
			bot_lasgun_killshot = "wwise/events/weapon/play_rifle_locomotion",
			shotgun_p1_m3 = "wwise/events/weapon/play_heavy_locomotion",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_ammo_belt_locomotion",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_ammo_belt_locomotion",
			autogun_p3_m2 = "wwise/events/weapon/play_rifle_locomotion",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_ammo_belt_locomotion",
			autogun_p2_m1 = "wwise/events/weapon/play_rifle_locomotion",
			bot_laspistol_killshot = "wwise/events/weapon/play_rifle_locomotion",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_heavy_locomotion",
			autopistol_p3_m3 = "wwise/events/weapon/play_smg_locomotion",
			lasgun_p2_m3 = "wwise/events/weapon/play_rifle_locomotion",
			bolter_p1_m1 = "wwise/events/weapon/play_heavy_locomotion",
			shotgun_p1_m1 = "wwise/events/weapon/play_heavy_locomotion",
			shotgun_p1_m2 = "wwise/events/weapon/play_heavy_locomotion",
			autogun_p3_m1 = "wwise/events/weapon/play_rifle_locomotion",
			autopistol_p1_m2 = "wwise/events/weapon/play_smg_locomotion",
			lasgun_p1_m2 = "wwise/events/weapon/play_rifle_locomotion",
			bolter_p1_m2 = "wwise/events/weapon/play_heavy_locomotion",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_heavy_locomotion",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_heavy_locomotion",
			autopistol_p3_m1 = "wwise/events/weapon/play_smg_locomotion",
			lasgun_p2_m1 = "wwise/events/weapon/play_rifle_locomotion",
			laspistol_p1_m3 = "wwise/events/weapon/play_rifle_locomotion",
			plasmagun_p1_m1 = "wwise/events/weapon/play_weapon_plasma_gun_movement_foley",
			ogryn_thumper_p1_m3 = "wwise/events/weapon/play_heavy_locomotion",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_heavy_locomotion",
			bot_autogun_killshot = "wwise/events/weapon/play_rifle_locomotion",
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_heavy_locomotion",
			autopistol_p1_m3 = "wwise/events/weapon/play_smg_locomotion",
			autogun_p1_m1 = "wwise/events/weapon/play_rifle_locomotion",
			lasgun_p1_m3 = "wwise/events/weapon/play_rifle_locomotion",
			autogun_p1_m2 = "wwise/events/weapon/play_rifle_locomotion",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_heavy_locomotion",
			laspistol_p1_m1 = "wwise/events/weapon/play_rifle_locomotion",
			autopistol_p1_m1 = "wwise/events/weapon/play_smg_locomotion",
			autogun_p2_m3 = "wwise/events/weapon/play_rifle_locomotion",
			autogun_p1_m3 = "wwise/events/weapon/play_rifle_locomotion",
			laspistol_p1_m2 = "wwise/events/weapon/play_rifle_locomotion",
			lasgun_p1_m1 = "wwise/events/weapon/play_rifle_locomotion",
			bolter_p1_m3 = "wwise/events/weapon/play_heavy_locomotion",
			autogun_p3_m3 = "wwise/events/weapon/play_rifle_locomotion"
		}
	},
	sfx_inspect = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/player/play_player_foley_subtle",
			autogun_p2_m2 = "wwise/events/weapon/play_rifle_subtle",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_ogryn_wpn_up",
			ogryn_thumper_p1_m3 = "wwise/events/weapon/play_ogryn_wpn_up",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_ogryn_wpn_up",
			ogryn_grenade_box = "wwise/events/weapon/play_ogryn_grenade_crate_shake",
			bot_autogun_killshot = "wwise/events/weapon/play_rifle_subtle",
			forcestaff_p2_m2 = "wwise/events/player/play_player_foley_subtle",
			autogun_p3_m2 = "wwise/events/weapon/play_rifle_subtle",
			forcestaff_p2_m1 = "wwise/events/player/play_player_foley_subtle",
			autogun_p2_m1 = "wwise/events/weapon/play_rifle_subtle",
			autogun_p1_m1 = "wwise/events/weapon/play_rifle_subtle",
			forcestaff_p4_m1 = "wwise/events/player/play_player_foley_subtle",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_ogryn_wpn_up",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_ogryn_wpn_up",
			autogun_p1_m2 = "wwise/events/weapon/play_rifle_subtle",
			autogun_p3_m1 = "wwise/events/weapon/play_rifle_subtle",
			autogun_p2_m3 = "wwise/events/weapon/play_rifle_subtle",
			autogun_p1_m3 = "wwise/events/weapon/play_rifle_subtle",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_wpn_up",
			forcestaff_p1_m1 = "wwise/events/player/play_player_foley_subtle",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_ogryn_wpn_up",
			forcestaff_p3_m1 = "wwise/events/player/play_player_foley_subtle",
			autogun_p3_m3 = "wwise/events/weapon/play_rifle_subtle"
		}
	},
	sfx_inspect_special_01 = {
		has_husk_events = false,
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_rippergun_inspect_up",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_rippergun_inspect_up",
			ogryn_grenade_box = "wwise/events/weapon/play_ogryn_grenade_crate_open",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_rippergun_inspect_up"
		}
	},
	sfx_inspect_special_02 = {
		has_husk_events = false,
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_rippergun_inspect_down",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_rippergun_inspect_down",
			ogryn_grenade_box = "wwise/events/weapon/play_ogryn_grenade_crate_close",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_rippergun_inspect_down"
		}
	},
	sfx_weapon_foley_heavy = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_hand",
			default = "wwise/events/weapon/play_foley_plasma_rifle_heavy_movement",
			plasmagun_p1_m1 = "wwise/events/weapon/play_foley_plasma_rifle_heavy_movement",
			ogryn_thumper_p1_m3 = "wwise/events/weapon/play_thumper_locomotion_metal_plate",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_push",
			luggable = "wwise/events/player/play_item_luggable_foley",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_hand",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_weapon_silence",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_thumper_locomotion_metal_plate",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_hand",
			plasmagun_p2_m1 = "wwise/events/weapon/play_foley_plasma_rifle_heavy_movement"
		}
	},
	sfx_weapon_foley_left_hand_01 = {
		has_husk_events = true,
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			ogryn_powermaul_slabshield_p1_m1 = "wwise/events/weapon/play_ogryn_slabshield_to_parry"
		}
	},
	sfx_weapon_foley_left_hand_02 = {
		has_husk_events = true,
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			ogryn_powermaul_slabshield_p1_m1 = "wwise/events/weapon/play_ogryn_slabshield_from_parry"
		}
	},
	sfx_hit_weapon = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/player/play_foley_hand_hit_weapon_plasma_rifle",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_hit",
			plasmagun_p1_m1 = "wwise/events/player/play_foley_hand_hit_weapon_plasma_rifle",
			flamer_p1_m1 = "wwise/events/weapon/play_flametrower_alt_fire_off",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_hit",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_hit",
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_hit",
			lasgun_p3_m3 = "wwise/events/weapon/play_lasgun_p3_hand_hit",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_hit",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_hit",
			lasgun_p3_m2 = "wwise/events/weapon/play_lasgun_p3_hand_hit",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_hit",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_hit",
			lasgun_p3_m1 = "wwise/events/weapon/play_lasgun_p3_hand_hit",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_special_hit",
			syringe_corruption_pocketable = "wwise/events/player/play_syringe_heal_husk_confirm",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_hit",
			plasmagun_p2_m1 = "wwise/events/player/play_foley_hand_hit_weapon_plasma_rifle"
		}
	},
	sfx_vent_rattle = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_plasmagun_vent_rattle",
			shock_grenade = "wwise/events/weapon/play_grenade_foley_pin_spin",
			plasmagun_p1_m1 = "wwise/events/weapon/play_weapon_plasmagun_vent_rattle",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_dodge",
			krak_grenade = "wwise/events/weapon/play_grenade_foley_pin_spin",
			fire_grenade = "wwise/events/weapon/play_grenade_foley_pin_spin",
			plasmagun_p2_m1 = "wwise/events/weapon/play_weapon_plasmagun_vent_rattle",
			frag_grenade = "wwise/events/weapon/play_grenade_foley_pin_spin"
		}
	},
	sfx_about_to_explode = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_plasmagun_about_to_explode",
			plasmagun_p2_m1 = "wwise/events/weapon/play_weapon_plasmagun_about_to_explode",
			plasmagun_p1_m1 = "wwise/events/weapon/play_weapon_plasmagun_about_to_explode"
		}
	},
	sfx_magazine_eject = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_silence",
			autogun_p2_m2 = "wwise/events/weapon/play_autogun_p2_reload_clip_out",
			bot_zola_laspistol = "wwise/events/weapon/play_reload_foley_laspistol_clip_out",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_reload_mag_out",
			bot_lasgun_killshot = "wwise/events/weapon/play_lasgun_reload_clip_out",
			lasgun_p2_m2 = "wwise/events/weapon/play_lasgun_p2_reload_mag_out",
			autogun_p2_m1 = "wwise/events/weapon/play_autogun_p2_reload_clip_out",
			laspistol_p1_m3 = "wwise/events/weapon/play_reload_foley_laspistol_clip_out",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_heavy_stubber_mag_out",
			autogun_p3_m2 = "wwise/events/weapon/play_autogun_p2_reload_clip_out",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_heavy_stubber_mag_out",
			lasgun_p3_m3 = "wwise/events/weapon/play_lasgun_p3_mag_out",
			bot_laspistol_killshot = "wwise/events/weapon/play_reload_foley_laspistol_clip_out",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/thumper_shotgun_open",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_heavy_stubber_mag_out",
			lasgun_p2_m3 = "wwise/events/weapon/play_lasgun_p2_reload_mag_out",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_clip_out",
			lasgun_p3_m2 = "wwise/events/weapon/play_lasgun_p3_mag_out",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/thumper_shotgun_open",
			autogun_p3_m1 = "wwise/events/weapon/play_autogun_p2_reload_clip_out",
			lasgun_p1_m2 = "wwise/events/weapon/play_lasgun_reload_clip_out",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_clip_out",
			lasgun_p3_m1 = "wwise/events/weapon/play_lasgun_p3_mag_out",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_mag_out",
			lasgun_p2_m1 = "wwise/events/weapon/play_lasgun_p2_reload_mag_out",
			ogryn_powermaul_slabshield_p1_m1 = "wwise/events/weapon/play_ogryn_slabshield_push_foley",
			autopistol_p1_m2 = "wwise/events/weapon/play_autopistol_mag_out",
			plasmagun_p1_m1 = "wwise/events/weapon/play_weapon_plasma_vent",
			ogryn_thumper_p1_m3 = "wwise/events/weapon/thumper_shotgun_open",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_eject",
			bot_autogun_killshot = "wwise/events/weapon/play_autogun_p2_reload_clip_out",
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_eject",
			autopistol_p1_m3 = "wwise/events/weapon/play_autopistol_mag_out",
			autogun_p1_m1 = "wwise/events/weapon/play_autogun_reload_clip_out",
			lasgun_p1_m3 = "wwise/events/weapon/play_lasgun_reload_clip_out",
			autogun_p1_m2 = "wwise/events/weapon/play_autogun_reload_clip_out",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_eject",
			laspistol_p1_m1 = "wwise/events/weapon/play_reload_foley_laspistol_clip_out",
			autopistol_p1_m1 = "wwise/events/weapon/play_autopistol_mag_out",
			autogun_p2_m3 = "wwise/events/weapon/play_autogun_p2_reload_clip_out",
			autogun_p1_m3 = "wwise/events/weapon/play_autogun_reload_clip_out",
			laspistol_p1_m2 = "wwise/events/weapon/play_reload_foley_laspistol_clip_out",
			lasgun_p1_m1 = "wwise/events/weapon/play_lasgun_reload_clip_out",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_clip_out",
			autogun_p3_m3 = "wwise/events/weapon/play_autogun_p2_reload_clip_out"
		}
	},
	sfx_magazine_insert = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_silence",
			autogun_p2_m2 = "wwise/events/weapon/play_autogun_p2_reload_clip_in",
			bot_zola_laspistol = "wwise/events/weapon/play_reload_foley_laspistol_clip_in",
			bot_lasgun_killshot = "wwise/events/weapon/play_lasgun_reload_clip_in",
			lasgun_p2_m2 = "wwise/events/weapon/play_lasgun_p2_reload_mag_in",
			autogun_p2_m1 = "wwise/events/weapon/play_autogun_p2_reload_clip_in",
			autopistol_p1_m2 = "wwise/events/weapon/play_autopistol_mag_in",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_heavy_stubber_mag_in",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_heavy_stubber_mag_in",
			autogun_p3_m2 = "wwise/events/weapon/play_autogun_p2_reload_clip_in",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/thumper_shotgun_insert",
			lasgun_p3_m3 = "wwise/events/weapon/play_lasgun_p3_mag_in",
			bot_laspistol_killshot = "wwise/events/weapon/play_reload_foley_laspistol_clip_in",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/thumper_shotgun_insert",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_heavy_stubber_mag_in",
			lasgun_p2_m3 = "wwise/events/weapon/play_lasgun_p2_reload_mag_in",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_clip_in",
			lasgun_p3_m2 = "wwise/events/weapon/play_lasgun_p3_mag_in",
			autogun_p3_m1 = "wwise/events/weapon/play_autogun_p2_reload_clip_in",
			lasgun_p1_m2 = "wwise/events/weapon/play_lasgun_reload_clip_in",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_clip_in",
			lasgun_p3_m1 = "wwise/events/weapon/play_lasgun_p3_mag_in",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_mag_in",
			lasgun_p2_m1 = "wwise/events/weapon/play_lasgun_p2_reload_mag_in",
			plasmagun_p2_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_insert",
			laspistol_p1_m3 = "wwise/events/weapon/play_reload_foley_laspistol_clip_in",
			plasmagun_p1_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_insert",
			ogryn_thumper_p1_m3 = "wwise/events/weapon/thumper_shotgun_insert",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_insert",
			bot_autogun_killshot = "wwise/events/weapon/play_autogun_p2_reload_clip_in",
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_insert",
			autopistol_p1_m3 = "wwise/events/weapon/play_autopistol_mag_in",
			autogun_p1_m1 = "wwise/events/weapon/play_autogun_reload_clip_in",
			lasgun_p1_m3 = "wwise/events/weapon/play_lasgun_reload_clip_in",
			autogun_p1_m2 = "wwise/events/weapon/play_autogun_reload_clip_in",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_insert",
			laspistol_p1_m1 = "wwise/events/weapon/play_reload_foley_laspistol_clip_in",
			autopistol_p1_m1 = "wwise/events/weapon/play_autopistol_mag_in",
			autogun_p2_m3 = "wwise/events/weapon/play_autogun_p2_reload_clip_in",
			autogun_p1_m3 = "wwise/events/weapon/play_autogun_reload_clip_in",
			laspistol_p1_m2 = "wwise/events/weapon/play_reload_foley_laspistol_clip_in",
			lasgun_p1_m1 = "wwise/events/weapon/play_lasgun_reload_clip_in",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_clip_in",
			autogun_p3_m3 = "wwise/events/weapon/play_autogun_p2_reload_clip_in"
		}
	},
	sfx_reload_lever_pull = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			autopistol_p1_m2 = "wwise/events/weapon/play_autopistol_lever",
			autogun_p2_m2 = "wwise/events/weapon/play_autogun_p2_reload_lever_pull",
			shotgun_p1_m1 = "wwise/events/weapon/play_shotgun_reload_pull",
			default = "wwise/events/weapon/play_weapon_silence",
			autopistol_p1_m1 = "wwise/events/weapon/play_autopistol_lever",
			shotgun_p1_m2 = "wwise/events/weapon/play_shotgun_reload_pull",
			shotgun_p1_m3 = "wwise/events/weapon/play_shotgun_reload_pull",
			shotgun_p3_m1 = "wwise/events/weapon/play_shotgun_reload_pull",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_heavy_stubber_lever_pull",
			autogun_p3_m2 = "wwise/events/weapon/play_autogun_p3_reload_lever_pull",
			autopistol_p1_m3 = "wwise/events/weapon/play_autopistol_lever",
			autogun_p2_m1 = "wwise/events/weapon/play_autogun_p2_reload_lever_pull",
			autogun_p1_m1 = "wwise/events/weapon/play_autogun_reload_lever_pull",
			bot_autogun_killshot = "wwise/events/weapon/play_autogun_p3_reload_lever_pull",
			lasgun_p2_m3 = "wwise/events/weapon/play_lasgun_p2_reload_lever_pull",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_lever_pull",
			autogun_p1_m2 = "wwise/events/weapon/play_autogun_reload_lever_pull",
			autogun_p3_m1 = "wwise/events/weapon/play_autogun_p3_reload_lever_pull",
			lasgun_p2_m2 = "wwise/events/weapon/play_lasgun_p2_reload_lever_pull",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_lever_pull",
			autogun_p2_m3 = "wwise/events/weapon/play_autogun_p2_reload_lever_pull",
			autogun_p1_m3 = "wwise/events/weapon/play_autogun_reload_lever_pull",
			lasgun_p2_m1 = "wwise/events/weapon/play_lasgun_p2_reload_lever_pull",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_lever_pull",
			autogun_p3_m3 = "wwise/events/weapon/play_autogun_p3_reload_lever_pull"
		}
	},
	sfx_reload_lever_release = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_silence",
			autogun_p2_m2 = "wwise/events/weapon/play_autogun_p2_reload_lever_release",
			bot_zola_laspistol = "wwise/events/weapon/play_reload_foley_laspistol_recharge_on",
			bot_lasgun_killshot = "wwise/events/weapon/play_lasgun_reload_lever_release",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/thumper_shotgun_close",
			bot_laspistol_killshot = "wwise/events/weapon/play_reload_foley_laspistol_recharge_on",
			shotgun_p1_m3 = "wwise/events/weapon/play_shotgun_reload_push",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_lever_release",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_heavy_stubber_lever_release",
			autogun_p3_m2 = "wwise/events/weapon/play_autogun_p3_reload_lever_release",
			autogun_p2_m1 = "wwise/events/weapon/play_autogun_p2_reload_lever_release",
			shotgun_p1_m2 = "wwise/events/weapon/play_shotgun_reload_push",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_heavy_stubber_lever_release",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_heavy_stubber_lever_release",
			autogun_p3_m1 = "wwise/events/weapon/play_autogun_p3_reload_lever_release",
			lasgun_p1_m2 = "wwise/events/weapon/play_lasgun_reload_lever_release",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_lever_release",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/thumper_shotgun_close",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_reload_finish",
			laspistol_p1_m3 = "wwise/events/weapon/play_reload_foley_laspistol_recharge_on",
			shotgun_p1_m1 = "wwise/events/weapon/play_shotgun_reload_push",
			ogryn_thumper_p1_m3 = "wwise/events/weapon/thumper_shotgun_close",
			bot_autogun_killshot = "wwise/events/weapon/play_autogun_p3_reload_lever_release",
			autogun_p1_m1 = "wwise/events/weapon/play_autogun_reload_lever_release",
			lasgun_p1_m3 = "wwise/events/weapon/play_lasgun_reload_lever_release",
			autogun_p1_m2 = "wwise/events/weapon/play_autogun_reload_lever_release",
			laspistol_p1_m1 = "wwise/events/weapon/play_reload_foley_laspistol_recharge_on",
			autogun_p2_m3 = "wwise/events/weapon/play_autogun_p2_reload_lever_release",
			autogun_p1_m3 = "wwise/events/weapon/play_autogun_reload_lever_release",
			laspistol_p1_m2 = "wwise/events/weapon/play_reload_foley_laspistol_recharge_on",
			lasgun_p1_m1 = "wwise/events/weapon/play_lasgun_reload_lever_release",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_lever_release",
			autogun_p3_m3 = "wwise/events/weapon/play_autogun_p3_reload_lever_release"
		}
	},
	magazine_fail = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_silence",
			plasmagun_p1_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_connect",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_pull",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_pull",
			plasmagun_p2_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_connect",
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_pull"
		}
	},
	sfx_mag_contact = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_silence",
			autogun_p2_m2 = "wwise/events/weapon/play_autogun_p2_reload_mag_contact",
			plasmagun_p1_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_connect",
			bot_lasgun_killshot = "wwise/events/weapon/play_lasgun_reload_clip_contact",
			autogun_p2_m3 = "wwise/events/weapon/play_autogun_p2_reload_mag_contact",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_rippergun_mag_contact",
			bot_autogun_killshot = "wwise/events/weapon/play_autogun_p2_reload_mag_contact",
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_rippergun_mag_contact",
			lasgun_p2_m3 = "wwise/events/weapon/play_lasgun_p3_mag_contact",
			autogun_p3_m2 = "wwise/events/weapon/play_autogun_p2_reload_mag_contact",
			lasgun_p3_m1 = "wwise/events/weapon/play_lasgun_p3_mag_contact",
			autogun_p2_m1 = "wwise/events/weapon/play_autogun_p2_reload_mag_contact",
			lasgun_p3_m3 = "wwise/events/weapon/play_lasgun_p3_mag_contact",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_heavy_stubber_mag_safety_button",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_heavy_stubber_mag_safety_button",
			lasgun_p1_m3 = "wwise/events/weapon/play_lasgun_reload_clip_contact",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_clip_contact",
			lasgun_p3_m2 = "wwise/events/weapon/play_lasgun_p3_mag_contact",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_heavy_stubber_mag_safety_button",
			autogun_p3_m1 = "wwise/events/weapon/play_autogun_p2_reload_mag_contact",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_rippergun_mag_contact",
			lasgun_p1_m2 = "wwise/events/weapon/play_lasgun_reload_clip_contact",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_clip_contact",
			frag_grenade = "wwise/events/weapon/play_combat_knife_equip_var_4",
			lasgun_p2_m1 = "wwise/events/weapon/play_lasgun_p3_mag_contact",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_mag_contact",
			lasgun_p2_m2 = "wwise/events/weapon/play_lasgun_p3_mag_contact",
			lasgun_p1_m1 = "wwise/events/weapon/play_lasgun_reload_clip_contact",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_clip_contact",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_reload_screw",
			plasmagun_p2_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_connect",
			autogun_p3_m3 = "wwise/events/weapon/play_autogun_p2_reload_mag_contact"
		}
	},
	sfx_button = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_clip_button",
			lasgun_p3_m2 = "wwise/events/weapon/play_lasgun_p3_mag_button",
			shotgun_p1_m1 = "wwise/events/weapon/play_shotgun_reload_insert_ammo_special",
			shotgun_p1_m3 = "wwise/events/weapon/play_shotgun_reload_insert_ammo_special",
			default = "wwise/events/debug/play_debug_sound_short",
			shotgun_p1_m2 = "wwise/events/weapon/play_shotgun_reload_insert_ammo_special",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_clip_button",
			lasgun_p3_m1 = "wwise/events/weapon/play_lasgun_p3_mag_button",
			lasgun_p3_m3 = "wwise/events/weapon/play_lasgun_p3_mag_button",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_clip_button"
		}
	},
	plasma_flask_remove = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			plasmagun_p2_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_remove",
			plasmagun_p1_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_remove"
		}
	},
	plasma_flask_connect = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			plasmagun_p2_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_connect",
			plasmagun_p1_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_connect"
		}
	},
	plasma_button = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			plasmagun_p2_m1 = "wwise/events/weapon/play_reload_foley_plasma_button",
			plasmagun_p1_m1 = "wwise/events/weapon/play_reload_foley_plasma_button"
		}
	},
	plasma_flask_screw = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			plasmagun_p2_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_screw",
			plasmagun_p1_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_screw"
		}
	},
	plasma_flask_disconnect = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			plasmagun_p2_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_disconnect",
			plasmagun_p1_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_disconnect"
		}
	},
	plasma_flask_insert = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			plasmagun_p2_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_insert",
			plasmagun_p1_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_insert"
		}
	},
	sfx_weapon_handle_out = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_weapon_rippergun_handle_out",
			default = "wwise/events/debug/play_debug_sound_short",
			stubrevolver_p1_m2 = "wwise/events/weapon/play_stub_revolver_eject_one",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_weapon_rippergun_handle_out",
			stubrevolver_p1_m3 = "wwise/events/weapon/play_stub_revolver_eject_one",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_weapon_rippergun_handle_out",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_stub_revolver_eject_one",
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_weapon_rippergun_handle_out",
			syringe_corruption_pocketable = "wwise/events/player/play_syringe_heal_husk",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_weapon_rippergun_handle_out",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_weapon_rippergun_handle_out"
		}
	},
	sfx_weapon_handle_in = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_weapon_rippergun_handle_in",
			syringe_corruption_pocketable = "wwise/events/player/play_syringe_heal_self",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_weapon_rippergun_handle_in",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_weapon_rippergun_handle_in",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_weapon_rippergun_handle_in",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_weapon_rippergun_handle_in",
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_weapon_rippergun_handle_in"
		}
	},
	sfx_weapon_revolver_open = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			stubrevolver_p1_m2 = "wwise/events/weapon/play_stub_revolver_open",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_stub_revolver_open",
			stubrevolver_p1_m3 = "wwise/events/weapon/play_stub_revolver_open"
		}
	},
	sfx_weapon_revolver_close = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			stubrevolver_p1_m2 = "wwise/events/weapon/play_stub_revolver_cock",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_stub_revolver_cock",
			stubrevolver_p1_m3 = "wwise/events/weapon/play_stub_revolver_cock"
		}
	},
	sfx_weapon_eject_ammo = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			stubrevolver_p1_m2 = "wwise/events/weapon/play_stub_revolver_eject",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_stub_revolver_eject",
			stubrevolver_p1_m3 = "wwise/events/weapon/play_stub_revolver_eject"
		}
	},
	sfx_weapon_insert_ammo = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			stubrevolver_p1_m2 = "wwise/events/weapon/play_stub_revolver_insert_bullet",
			default = "wwise/events/debug/play_debug_sound_short",
			stubrevolver_p1_m3 = "wwise/events/weapon/play_stub_revolver_insert_bullet",
			shotgun_p1_m1 = "wwise/events/weapon/play_weapon_shotgun_human_reload_insert_ammo",
			shotgun_p1_m2 = "wwise/events/weapon/play_weapon_shotgun_human_reload_insert_ammo",
			shotgun_p1_m3 = "wwise/events/weapon/play_weapon_shotgun_human_reload_insert_ammo",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_stub_revolver_insert_bullet"
		}
	},
	sfx_weapon_twist = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			stubrevolver_p1_m2 = "wwise/events/weapon/play_stub_revolver_cylinder_twist",
			default = "wwise/events/debug/play_debug_sound_short",
			stubrevolver_p1_m3 = "wwise/events/weapon/play_stub_revolver_cylinder_twist",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_reload_screw",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_stub_revolver_cylinder_twist"
		}
	},
	sfx_weapon_untwist = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_reload_unscrew"
		}
	},
	flyby = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_shared_combat_weapon_bullet_flyby_small"
		}
	},
	sfx_swing = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/player/play_swing_light_gen",
			combatsword_p1_m3 = "wwise/events/weapon/play_sword_swing_medium",
			chainaxe_p1_m3 = "wwise/events/weapon/play_chainaxe_swing",
			forcesword_p1_m1 = "wwise/events/weapon/play_force_sword_swing",
			combatsword_p3_m2 = "wwise/events/weapon/play_sword_swing_falchion",
			luggable = "wwise/events/player/play_swing_light_gen",
			chainaxe_p1_m2 = "wwise/events/weapon/play_chainaxe_swing",
			chainsword_p1_m2 = "wwise/events/weapon/play_combat_weapon_chainsword_swing",
			powermaul_2h_p1_m1 = "wwise/events/weapon/play_thunder_hammer_swing",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_ogryn_gauntlet_swing",
			combataxe_p1_m1 = "wwise/events/weapon/play_axe_swing_light",
			chainsword_2h_p1_m1 = "wwise/events/weapon/play_2h_chainsword_swing",
			powersword_p1_m1 = "wwise/events/weapon/play_power_sword_swing",
			forcesword_p1_m2 = "wwise/events/weapon/play_force_sword_swing",
			chainaxe_p1_m1 = "wwise/events/weapon/play_chainaxe_swing",
			ogryn_combatblade_p1_m2 = "wwise/events/weapon/play_combat_weapon_combat_knife_ogryn_swing",
			thunderhammer_2h_p1_m2 = "wwise/events/weapon/play_thunder_hammer_swing",
			combataxe_p3_m1 = "wwise/events/weapon/play_axe_swing_light",
			thunderhammer_2h_p1_m3 = "wwise/events/weapon/play_thunder_hammer_swing",
			combataxe_p3_m2 = "wwise/events/weapon/play_axe_swing_light",
			ogryn_club_p1_m2 = "wwise/events/weapon/play_pipe_swing",
			combataxe_p3_m3 = "wwise/events/weapon/play_axe_swing_light",
			ogryn_club_p1_m3 = "wwise/events/weapon/play_pipe_swing",
			forcesword_p1_m3 = "wwise/events/weapon/play_force_sword_swing",
			ogryn_club_p2_m3 = "wwise/events/weapon/play_pipe_swing",
			combataxe_p1_m3 = "wwise/events/weapon/play_axe_swing_light",
			combatsword_p2_m3 = "wwise/events/weapon/play_sword_swing_medium",
			ogryn_club_p2_m2 = "wwise/events/weapon/play_pipe_swing",
			ogryn_club_p2_m1 = "wwise/events/weapon/play_pipe_swing",
			ogryn_powermaul_slabshield_p1_m1 = "wwise/events/weapon/play_power_maul_swing",
			combatsword_p2_m1 = "wwise/events/weapon/play_sword_swing_medium",
			powersword_p1_m3 = "wwise/events/weapon/play_power_sword_swing",
			powersword_p1_m2 = "wwise/events/weapon/play_power_sword_swing",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_swing",
			bot_combataxe_linesman = "wwise/events/weapon/play_axe_swing_light",
			ogryn_thumper_p1_m3 = "wwise/events/weapon/play_ogryn_gauntlet_swing",
			powermaul_p1_m1 = "wwise/events/weapon/play_power_maul_swing",
			combatknife_p1_m1 = "wwise/events/weapon/play_swing_knife",
			ogryn_club_p1_m1 = "wwise/events/weapon/play_pipe_swing",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/play_thunder_hammer_swing",
			chainsword_2h_p1_m3 = "wwise/events/weapon/play_2h_chainsword_swing",
			ogryn_combatblade_p1_m1 = "wwise/events/weapon/play_combat_weapon_combat_knife_ogryn_swing",
			combatsword_p3_m3 = "wwise/events/weapon/play_sword_swing_falchion",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_swing",
			tome_pocketable = "wwise/events/player/play_swing_light_gen",
			grimoire_pocketable = "wwise/events/player/play_swing_light_gen",
			combatsword_p3_m1 = "wwise/events/weapon/play_sword_swing_falchion",
			chainsword_p1_m1 = "wwise/events/weapon/play_combat_weapon_chainsword_swing",
			combatknife_p1_m3 = "wwise/events/weapon/play_swing_knife",
			ogryn_combatblade_p1_m3 = "wwise/events/weapon/play_combat_weapon_combat_knife_ogryn_swing",
			combatsword_p1_m1 = "wwise/events/weapon/play_sword_swing_medium",
			ogryn_powermaul_p1_m1 = "wwise/events/weapon/play_power_maul_swing",
			combatsword_p2_m2 = "wwise/events/weapon/play_sword_swing_medium",
			bot_combatsword_linesman_p1 = "wwise/events/weapon/play_sword_swing_medium",
			chainsword_2h_p1_m2 = "wwise/events/weapon/play_2h_chainsword_swing",
			combataxe_p1_m2 = "wwise/events/weapon/play_axe_swing_light",
			combatsword_p1_m2 = "wwise/events/weapon/play_sword_swing_medium",
			bot_combatsword_linesman_p2 = "wwise/events/weapon/play_sword_swing_medium",
			combatknife_p1_m2 = "wwise/events/weapon/play_swing_knife",
			chainsword_p1_m3 = "wwise/events/weapon/play_combat_weapon_chainsword_swing"
		}
	},
	sfx_swing_heavy = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/player/play_swing_heavy_gen",
			combatsword_p1_m3 = "wwise/events/weapon/play_sword_swing_medium",
			chainaxe_p1_m3 = "wwise/events/weapon/play_chainaxe_swing",
			forcesword_p1_m1 = "wwise/events/weapon/play_force_sword_swing",
			combatsword_p3_m2 = "wwise/events/weapon/play_sword_swing_falchion",
			chainsword_p1_m1 = "wwise/events/weapon/play_combat_weapon_chainsword_swing_heavy",
			chainaxe_p1_m2 = "wwise/events/weapon/play_chainaxe_swing",
			chainsword_p1_m2 = "wwise/events/weapon/play_combat_weapon_chainsword_swing_heavy",
			powermaul_2h_p1_m1 = "wwise/events/weapon/play_thunder_hammer_swing",
			chainsword_2h_p1_m3 = "wwise/events/weapon/play_2h_chainsword_swing",
			combataxe_p1_m1 = "wwise/events/weapon/play_axe_swing_light",
			chainsword_2h_p1_m1 = "wwise/events/weapon/play_2h_chainsword_swing",
			powersword_p1_m1 = "wwise/events/weapon/play_power_sword_swing",
			forcesword_p1_m2 = "wwise/events/weapon/play_force_sword_swing",
			chainaxe_p1_m1 = "wwise/events/weapon/play_chainaxe_swing",
			ogryn_combatblade_p1_m2 = "wwise/events/weapon/play_combat_weapon_combat_knife_ogryn_swing",
			thunderhammer_2h_p1_m2 = "wwise/events/weapon/play_thunder_hammer_swing",
			combataxe_p3_m1 = "wwise/events/weapon/play_axe_swing_light",
			thunderhammer_2h_p1_m3 = "wwise/events/weapon/play_thunder_hammer_swing",
			combataxe_p3_m2 = "wwise/events/weapon/play_axe_swing_light",
			ogryn_club_p1_m2 = "wwise/events/weapon/play_pipe_swing",
			combataxe_p3_m3 = "wwise/events/weapon/play_axe_swing_light",
			ogryn_club_p1_m3 = "wwise/events/weapon/play_pipe_swing",
			forcesword_p1_m3 = "wwise/events/weapon/play_force_sword_swing",
			ogryn_club_p2_m3 = "wwise/events/weapon/play_pipe_swing",
			combataxe_p1_m3 = "wwise/events/weapon/play_axe_swing_light",
			combatsword_p2_m3 = "wwise/events/weapon/play_sword_swing_medium",
			ogryn_club_p2_m2 = "wwise/events/weapon/play_pipe_swing",
			ogryn_club_p2_m1 = "wwise/events/weapon/play_pipe_swing",
			ogryn_powermaul_slabshield_p1_m1 = "wwise/events/weapon/play_power_maul_swing",
			combatsword_p2_m1 = "wwise/events/weapon/play_sword_swing_medium",
			powersword_p1_m3 = "wwise/events/weapon/play_power_sword_swing",
			powersword_p1_m2 = "wwise/events/weapon/play_power_sword_swing",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_swing",
			bot_combataxe_linesman = "wwise/events/weapon/play_axe_swing_light",
			ogryn_combatblade_p1_m1 = "wwise/events/weapon/play_combat_weapon_combat_knife_ogryn_swing",
			powermaul_p1_m1 = "wwise/events/weapon/play_power_maul_swing",
			combatknife_p1_m1 = "wwise/events/weapon/play_swing_knife",
			ogryn_club_p1_m1 = "wwise/events/weapon/play_pipe_swing",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/play_thunder_hammer_swing",
			ogryn_powermaul_p1_m1 = "wwise/events/weapon/play_power_maul_swing",
			bot_combatsword_linesman_p1 = "wwise/events/weapon/play_sword_swing_medium",
			combatsword_p3_m3 = "wwise/events/weapon/play_sword_swing_falchion",
			bot_combatsword_linesman_p2 = "wwise/events/weapon/play_sword_swing_medium",
			combatsword_p3_m1 = "wwise/events/weapon/play_sword_swing_falchion",
			combatknife_p1_m3 = "wwise/events/weapon/play_swing_knife",
			ogryn_combatblade_p1_m3 = "wwise/events/weapon/play_combat_weapon_combat_knife_ogryn_swing",
			combatsword_p1_m1 = "wwise/events/weapon/play_sword_swing_medium",
			combatsword_p2_m2 = "wwise/events/weapon/play_sword_swing_medium",
			chainsword_2h_p1_m2 = "wwise/events/weapon/play_2h_chainsword_swing",
			combataxe_p1_m2 = "wwise/events/weapon/play_axe_swing_light",
			combatsword_p1_m2 = "wwise/events/weapon/play_sword_swing_medium",
			combatknife_p1_m2 = "wwise/events/weapon/play_swing_knife",
			chainsword_p1_m3 = "wwise/events/weapon/play_combat_weapon_chainsword_swing_heavy"
		}
	},
	sfx_swing_heavy_left_hand = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/player/play_swing_light_gen",
			ogryn_powermaul_slabshield_p1_m1 = "wwise/events/weapon/play_ogryn_slabshield_swing",
			tome_pocketable = "wwise/events/player/play_ogryn_swing_light_gen",
			grimoire_pocketable = "wwise/events/player/play_ogryn_swing_light_gen"
		}
	},
	windup_start = {
		has_husk_events = false,
		switch = {
			"archetype",
			"wielded_weapon_template"
		},
		events = {
			default = {
				default = "wwise/events/player/play_melee_charge_grip_hands",
				grimoire_pocketable = "wwise/events/player/play_grimoire_unequip",
				forcesword_p1_m1 = "wwise/events/weapon/play_force_sword_charge_foley",
				forcesword_p1_m2 = "wwise/events/weapon/play_force_sword_charge_foley",
				forcesword_p1_m3 = "wwise/events/weapon/play_force_sword_charge_foley"
			},
			ogryn = {
				default = "wwise/events/weapon/play_weapon_silence",
				grimoire_pocketable = "wwise/events/player/play_grimoire_unequip"
			}
		}
	},
	windup_stop = {
		has_husk_events = false,
		switch = {
			"archetype",
			"wielded_weapon_template"
		},
		events = {
			default = {
				default = "wwise/events/player/stop_melee_charge_grip_hands",
				grimoire_pocketable = "wwise/events/player/stop_grimoire_unequip",
				forcesword_p1_m1 = "wwise/events/weapon/stop_force_sword_charge_foley",
				forcesword_p1_m2 = "wwise/events/weapon/stop_force_sword_charge_foley",
				forcesword_p1_m3 = "wwise/events/weapon/stop_force_sword_charge_foley"
			},
			ogryn = {
				default = "wwise/events/player/stop_ogryn_charge_grip_hands",
				grimoire_pocketable = "wwise/events/player/stop_grimoire_unequip"
			}
		}
	},
	sfx_swing_critical = {
		has_husk_events = true,
		no_default = true,
		switch = {
			"is_critical_strike"
		},
		events = {
			["true"] = "wwise/events/weapon/play_indicator_crit_melee_swing"
		}
	},
	melee_blocked_attack = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_silence",
			combataxe_p3_m1 = "wwise/events/weapon/play_metal_pipe_block_gen",
			chainaxe_p1_m3 = "wwise/events/weapon/play_chainsword_block",
			forcesword_p1_m1 = "wwise/events/weapon/play_force_shield_block",
			chainsword_2h_p1_m3 = "wwise/events/weapon/play_chainsword_block",
			combatsword_p3_m1 = "wwise/events/weapon/play_combat_block_sword_on_sword",
			powersword_p1_m1 = "wwise/events/weapon/play_combat_block_sword_on_sword",
			chainaxe_p1_m2 = "wwise/events/weapon/play_chainsword_block",
			powermaul_2h_p1_m1 = "wwise/events/weapon/play_metal_pipe_block_gen",
			chainsword_p1_m2 = "wwise/events/weapon/play_chainsword_block",
			combataxe_p1_m1 = "wwise/events/weapon/play_metal_pipe_block_gen",
			combatsword_p3_m2 = "wwise/events/weapon/play_combat_block_sword_on_sword",
			chainsword_2h_p1_m1 = "wwise/events/weapon/play_chainsword_block",
			forcesword_p1_m2 = "wwise/events/weapon/play_force_shield_block",
			chainaxe_p1_m1 = "wwise/events/weapon/play_chainsword_block",
			ogryn_combatblade_p1_m2 = "wwise/events/weapon/play_metal_pipe_block_gen",
			ogryn_club_p1_m2 = "wwise/events/weapon/play_metal_pipe_block_gen",
			chainsword_p1_m1 = "wwise/events/weapon/play_chainsword_block",
			ogryn_club_p1_m3 = "wwise/events/weapon/play_metal_pipe_block_gen",
			thunderhammer_2h_p1_m3 = "wwise/events/weapon/play_metal_pipe_block_gen",
			ogryn_club_p2_m1 = "wwise/events/weapon/play_metal_pipe_block_gen",
			powersword_p1_m2 = "wwise/events/weapon/play_combat_block_sword_on_sword",
			ogryn_club_p2_m2 = "wwise/events/weapon/play_metal_pipe_block_gen",
			forcesword_p1_m3 = "wwise/events/weapon/play_force_shield_block",
			ogryn_club_p2_m3 = "wwise/events/weapon/play_metal_pipe_block_gen",
			ogryn_combatblade_p1_m1 = "wwise/events/weapon/play_metal_pipe_block_gen",
			combatsword_p2_m3 = "wwise/events/weapon/play_combat_block_sword_on_sword",
			thunderhammer_2h_p1_m2 = "wwise/events/weapon/play_metal_pipe_block_gen",
			ogryn_powermaul_p1_m1 = "wwise/events/weapon/play_metal_pipe_block_gen",
			ogryn_powermaul_slabshield_p1_m1 = "wwise/events/weapon/play_slabshield_block_melee",
			combatsword_p2_m1 = "wwise/events/weapon/play_combat_block_sword_on_sword",
			powersword_p1_m3 = "wwise/events/weapon/play_combat_block_sword_on_sword",
			bot_combatsword_linesman_p1 = "wwise/events/weapon/play_combat_block_sword_on_sword",
			bot_combatsword_linesman_p2 = "wwise/events/weapon/play_combat_block_sword_on_sword",
			combatknife_p1_m1 = "wwise/events/weapon/play_knife_block",
			ogryn_club_p1_m1 = "wwise/events/weapon/play_metal_pipe_block_gen",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/play_metal_pipe_block_gen",
			combatsword_p3_m3 = "wwise/events/weapon/play_combat_block_sword_on_sword",
			combatsword_p1_m3 = "wwise/events/weapon/play_combat_block_sword_on_sword",
			combatknife_p1_m3 = "wwise/events/weapon/play_knife_block",
			ogryn_combatblade_p1_m3 = "wwise/events/weapon/play_metal_pipe_block_gen",
			combatsword_p1_m1 = "wwise/events/weapon/play_combat_block_sword_on_sword",
			combatsword_p2_m2 = "wwise/events/weapon/play_combat_block_sword_on_sword",
			combataxe_p2_m1 = "wwise/events/weapon/play_metal_pipe_block_gen",
			chainsword_2h_p1_m2 = "wwise/events/weapon/play_chainsword_block",
			combatsword_p1_m2 = "wwise/events/weapon/play_combat_block_sword_on_sword",
			combatknife_p1_m2 = "wwise/events/weapon/play_knife_block",
			chainsword_p1_m3 = "wwise/events/weapon/play_chainsword_block"
		}
	},
	ranged_blocked_attack = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_silence",
			ogryn_powermaul_slabshield_p1_m1 = "wwise/events/weapon/play_slabshield_block_ranged",
			forcesword_p1_m1 = "wwise/events/weapon/play_force_shield_block",
			forcesword_p1_m2 = "wwise/events/weapon/play_force_shield_block",
			forcesword_p1_m3 = "wwise/events/weapon/play_force_shield_block"
		}
	},
	melee_sweep_hit = {
		no_default = true,
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			combatknife_p1_m2 = "wwise/events/weapon/stop_swing_knife",
			combatsword_p1_m3 = "wwise/events/weapon/stop_sword_swing_medium",
			thunderhammer_2h_p1_m2 = "wwise/events/weapon/stop_swing_2h_powerhammer",
			forcesword_p1_m1 = "wwise/events/weapon/stop_sword_swing_large",
			combatsword_p3_m2 = "wwise/events/weapon/stop_sword_swing_medium",
			combatknife_p1_m1 = "wwise/events/weapon/stop_swing_knife",
			bot_combatsword_linesman_p1 = "wwise/events/weapon/stop_sword_swing_medium",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/stop_swing_2h_powerhammer",
			powersword_p1_m1 = "wwise/events/weapon/stop_sword_swing_large",
			bot_combatsword_linesman_p2 = "wwise/events/weapon/stop_sword_swing_medium",
			combatsword_p3_m3 = "wwise/events/weapon/stop_sword_swing_medium",
			forcesword_p1_m2 = "wwise/events/weapon/stop_sword_swing_large",
			combatsword_p3_m1 = "wwise/events/weapon/stop_sword_swing_medium",
			combatknife_p1_m3 = "wwise/events/weapon/stop_swing_knife",
			combatsword_p1_m1 = "wwise/events/weapon/stop_sword_swing_medium",
			thunderhammer_2h_p1_m3 = "wwise/events/weapon/stop_swing_2h_powerhammer",
			combatsword_p2_m2 = "wwise/events/weapon/stop_sword_swing_medium",
			powersword_p1_m2 = "wwise/events/weapon/stop_sword_swing_large",
			forcesword_p1_m3 = "wwise/events/weapon/stop_sword_swing_large",
			combatsword_p1_m2 = "wwise/events/weapon/stop_sword_swing_medium",
			combatsword_p2_m3 = "wwise/events/weapon/stop_sword_swing_medium",
			combatsword_p2_m1 = "wwise/events/weapon/stop_sword_swing_medium",
			powersword_p1_m3 = "wwise/events/weapon/stop_sword_swing_large"
		}
	},
	melee_heavy_sweep_hit = {
		no_default = true,
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			ogryn_club_p1_m2 = "wwise/events/weapon/play_heavy_swing_hit",
			forcesword_p1_m2 = "wwise/events/weapon/play_heavy_swing_hit",
			chainaxe_p1_m3 = "wwise/events/weapon/play_heavy_swing_hit",
			forcesword_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			combatsword_p3_m2 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			powermaul_2h_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			chainsword_2h_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit_chain",
			chainaxe_p1_m2 = "wwise/events/weapon/play_heavy_swing_hit",
			powersword_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			chainsword_p1_m2 = "wwise/events/weapon/play_heavy_swing_hit",
			combatsword_p3_m1 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			chainsword_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			chainsword_2h_p1_m3 = "wwise/events/weapon/play_heavy_swing_hit_chain",
			thunderhammer_2h_p1_m2 = "wwise/events/weapon/play_heavy_swing_hit",
			chainaxe_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			ogryn_combatblade_p1_m2 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			ogryn_club_p1_m3 = "wwise/events/weapon/play_heavy_swing_hit",
			combataxe_p3_m1 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			ogryn_club_p2_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			thunderhammer_2h_p1_m3 = "wwise/events/weapon/play_heavy_swing_hit",
			ogryn_club_p2_m2 = "wwise/events/weapon/play_heavy_swing_hit",
			powersword_p1_m2 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			ogryn_combatblade_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			forcesword_p1_m3 = "wwise/events/weapon/play_heavy_swing_hit",
			ogryn_club_p2_m3 = "wwise/events/weapon/play_heavy_swing_hit",
			combataxe_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			combatsword_p2_m3 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			ogryn_powermaul_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			bot_combatsword_linesman_p1 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			ogryn_powermaul_slabshield_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			combatsword_p2_m1 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			powersword_p1_m3 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			bot_combatsword_linesman_p2 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			combatknife_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			ogryn_club_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			combatsword_p3_m3 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			combatsword_p1_m3 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			combatknife_p1_m3 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			ogryn_combatblade_p1_m3 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			combatsword_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			combatsword_p2_m2 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			chainsword_2h_p1_m2 = "wwise/events/weapon/play_heavy_swing_hit_chain",
			combatsword_p1_m2 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			combatknife_p1_m2 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			chainsword_p1_m3 = "wwise/events/weapon/play_heavy_swing_hit"
		}
	},
	melee_sweep_hit_crit = {
		has_husk_events = true,
		switch = {
			"is_critical_strike",
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_silence",
			["true"] = {
				default = "wwise/events/weapon/play_indicator_crit_melee_hit",
				combatsword_p1_m3 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				powersword_p1_m2 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				forcesword_p1_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combatsword_p3_m2 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combatknife_p1_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				ogryn_combatblade_p1_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				ogryn_combatblade_p1_m3 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				powersword_p1_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				bot_combatsword_linesman_p1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combatsword_p3_m3 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				bot_combatsword_linesman_p2 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				forcesword_p1_m2 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combatsword_p3_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				ogryn_combatblade_p1_m2 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combataxe_p3_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combatsword_p1_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combatsword_p2_m2 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combataxe_p1_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				forcesword_p1_m3 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combatsword_p1_m2 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combatsword_p2_m3 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combatsword_p2_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				powersword_p1_m3 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing"
			}
		}
	},
	melee_heavy_sweep_hit_crit = {
		has_husk_events = true,
		no_default = true,
		switch = {
			"is_critical_strike"
		},
		events = {
			["true"] = "wwise/events/weapon/play_indicator_crit_melee_hit"
		}
	},
	flyby_stop = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/stop_shared_combat_weapon_bullet_flyby_small"
		}
	},
	sfx_push_follow_up_build_up = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_silence",
			forcesword_p1_m2 = "wwise/events/weapon/play_force_sword_push_follow_up_build_up",
			forcesword_p1_m3 = "wwise/events/weapon/play_force_sword_push_follow_up_build_up",
			forcesword_p1_m1 = "wwise/events/weapon/play_force_sword_push_follow_up_build_up"
		}
	},
	sfx_push_follow_up = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_silence",
			laspistol_p1_m1 = "wwise/events/weapon/play_force_sword_push_follow_up",
			bot_zola_laspistol = "wwise/events/weapon/play_force_sword_push_follow_up",
			forcesword_p1_m1 = "wwise/events/weapon/play_force_sword_push_follow_up",
			combatsword_p3_m2 = "wwise/events/weapon/play_pushback_sword_stab",
			combatsword_p3_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			chainsword_2h_p1_m3 = "wwise/events/weapon/play_pushback_sword_stab",
			chainaxe_p1_m2 = "wwise/events/weapon/play_pushback_sword_stab",
			chainsword_p1_m2 = "wwise/events/weapon/play_pushback_sword_stab",
			chainaxe_p1_m3 = "wwise/events/weapon/play_pushback_sword_stab",
			stubrevolver_p1_m3 = "wwise/events/weapon/play_force_sword_push_follow_up",
			stubrevolver_p1_m2 = "wwise/events/weapon/play_force_sword_push_follow_up",
			bot_laspistol_killshot = "wwise/events/weapon/play_force_sword_push_follow_up",
			forcesword_p1_m2 = "wwise/events/weapon/play_force_sword_push_follow_up",
			chainaxe_p1_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			lasgun_p2_m3 = "wwise/events/weapon/play_pushback_sword_stab",
			bot_combatsword_linesman_p1 = "wwise/events/weapon/play_pushback_sword_stab",
			chainsword_p1_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			ogryn_combatblade_p1_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			ogryn_combatblade_p1_m2 = "wwise/events/weapon/play_pushback_sword_stab",
			lasgun_p2_m2 = "wwise/events/weapon/play_pushback_sword_stab",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_force_sword_push_follow_up",
			forcesword_p1_m3 = "wwise/events/weapon/play_force_sword_push_follow_up",
			combatsword_p2_m3 = "wwise/events/weapon/play_pushback_sword_stab",
			lasgun_p2_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			combatsword_p2_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			bot_combatsword_linesman_p2 = "wwise/events/weapon/play_pushback_sword_stab",
			laspistol_p1_m3 = "wwise/events/weapon/play_force_sword_push_follow_up",
			combatsword_p3_m3 = "wwise/events/weapon/play_pushback_sword_stab",
			combatsword_p1_m3 = "wwise/events/weapon/play_pushback_sword_stab",
			chainsword_2h_p1_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			ogryn_combatblade_p1_m3 = "wwise/events/weapon/play_pushback_sword_stab",
			combatsword_p1_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			combatsword_p2_m2 = "wwise/events/weapon/play_pushback_sword_stab",
			chainsword_2h_p1_m2 = "wwise/events/weapon/play_pushback_sword_stab",
			combatsword_p1_m2 = "wwise/events/weapon/play_pushback_sword_stab",
			laspistol_p1_m2 = "wwise/events/weapon/play_force_sword_push_follow_up",
			chainsword_p1_m3 = "wwise/events/weapon/play_pushback_sword_stab"
		}
	},
	sfx_special_activate = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_silence",
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_pushback_sword_stab",
			forcesword_p1_m1 = "wwise/events/weapon/play_force_sword_on",
			flamer_p1_m1 = "wwise/events/weapon/play_flametrower_equip_var_1",
			powermaul_2h_p1_m1 = "wwise/events/weapon/play_ogryn_powermaul_1h_powered_button",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_pushback_sword_stab",
			thunderhammer_2h_p1_m2 = "wwise/events/weapon/play_thunder_hammer_power_start",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/play_thunder_hammer_power_start",
			powersword_p1_m1 = "wwise/events/weapon/play_power_sword_on",
			thunderhammer_2h_p1_m3 = "wwise/events/weapon/play_thunder_hammer_power_start",
			ogryn_powermaul_p1_m1 = "wwise/events/weapon/play_ogryn_powermaul_1h_powered_button",
			forcesword_p1_m2 = "wwise/events/weapon/play_force_sword_on",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_pushback_sword_stab",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			powersword_p1_m2 = "wwise/events/weapon/play_power_sword_on",
			forcesword_p1_m3 = "wwise/events/weapon/play_force_sword_on",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_pushback_sword_stab",
			ogryn_powermaul_slabshield_p1_m1 = "wwise/events/weapon/play_ogryn_powermaul_1h_powered_button",
			powersword_p1_m3 = "wwise/events/weapon/play_power_sword_on"
		}
	},
	weapon_special_end = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_silence",
			chainaxe_p1_m3 = "wwise/events/weapon/play_chainaxe_rev",
			forcesword_p1_m1 = "wwise/events/weapon/play_force_sword_off",
			chainaxe_p1_m2 = "wwise/events/weapon/play_chainaxe_rev",
			powersword_p1_m2 = "wwise/events/weapon/play_power_sword_off",
			forcesword_p1_m3 = "wwise/events/weapon/play_force_sword_off",
			powersword_p1_m1 = "wwise/events/weapon/play_power_sword_off",
			forcesword_p1_m2 = "wwise/events/weapon/play_force_sword_off",
			chainaxe_p1_m1 = "wwise/events/weapon/play_chainaxe_rev",
			powersword_p1_m3 = "wwise/events/weapon/play_power_sword_off"
		}
	},
	weapon_overload = {
		no_default = true,
		has_husk_events = true,
		switch = {
			"wielded_weapon_template",
			"stage"
		},
		events = {
			plasmagun_p1_m1 = {
				high = "wwise/events/weapon/play_plasmagun_overheat_intensity_01",
				critical = "wwise/events/weapon/play_plasmagun_overheat_intensity_02"
			},
			plasmagun_p2_m1 = {
				high = "wwise/events/weapon/play_plasmagun_overheat_intensity_01",
				critical = "wwise/events/weapon/play_plasmagun_overheat_intensity_02"
			}
		}
	},
	sfx_device_start = {
		no_default = true,
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			skull_decoder = "wwise/events/player/play_servitor_hacking"
		}
	},
	sfx_device_stop = {
		no_default = true,
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			skull_decoder = "wwise/events/player/play_servitor_hacking_cancel"
		}
	},
	sfx_minigame_success = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			auspex_scanner = "wwise/events/player/play_device_auspex_scanner_minigame_progress"
		}
	},
	sfx_minigame_success_last = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			auspex_scanner = "wwise/events/player/play_device_auspex_scanner_minigame_progress_last"
		}
	},
	sfx_minigame_fail = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			auspex_scanner = "wwise/events/player/play_device_auspex_scanner_minigame_fail"
		}
	},
	sfx_scanning_sucess = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			scanner_equip = "wwise/events/player/play_scanner_collect_success"
		}
	},
	ranged_pre_loop_shot = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			autogun_p2_m2 = "wwise/events/weapon/play_autogun_p2_m2_first",
			autogun_p1_m2 = "wwise/events/weapon/play_autogun_p1_m2_single",
			autopistol_p1_m2 = "wwise/events/weapon/play_weapon_autopistol",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_heavy_stubber_punch_first",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_heavy_stubber_punch_first",
			autopistol_p1_m1 = "wwise/events/weapon/play_weapon_autopistol",
			autogun_p2_m3 = "wwise/events/weapon/play_autogun_p2_m3_first",
			autogun_p1_m3 = "wwise/events/weapon/play_autogun_p1_m3_first",
			lasgun_p3_m1 = "wwise/events/weapon/play_lasgun_p3_m1_fire_single",
			autopistol_p1_m3 = "wwise/events/weapon/play_weapon_autopistol",
			autogun_p2_m1 = "wwise/events/weapon/play_autogun_p2_m1_first",
			autogun_p1_m1 = "wwise/events/weapon/play_autogun_p1_m1_first",
			lasgun_p3_m2 = "wwise/events/weapon/play_lasgun_p3_m2_fire_single",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_heavy_stubber_punch_first",
			lasgun_p3_m3 = "wwise/events/weapon/play_lasgun_p3_m3_fire_single"
		}
	},
	ranged_single_shot = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template",
			"charge_level"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			laspistol_p1_m2 = "wwise/events/weapon/play_weapon_laspistol",
			bot_zola_laspistol = "wwise/events/weapon/play_weapon_laspistol",
			psyker_smite = "wwise/events/weapon/play_psyker_smite_fire",
			forcestaff_p2_m2 = "wwise/events/weapon/play_psyker_smite_fire",
			shotgun_p1_m3 = "wwise/events/weapon/play_combat_weapon_shotgun",
			autopistol_p1_m2 = "wwise/events/weapon/play_weapon_autopistol",
			autogun_p3_m2 = "wwise/events/weapon/play_autogun_p3_m2_single",
			forcestaff_p2_m1 = "wwise/events/weapon/play_psyker_smite_fire",
			shotgun_p1_m2 = "wwise/events/weapon/play_combat_weapon_shotgun",
			bot_laspistol_killshot = "wwise/events/weapon/play_weapon_laspistol",
			forcestaff_p4_m1 = "wwise/events/weapon/play_psyker_smite_fire",
			bot_lasgun_killshot = "wwise/events/weapon/play_weapon_lasgun_p1_m1",
			bolter_p1_m1 = "wwise/events/weapon/play_weapon_bolter",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_stub_revolver",
			stubrevolver_p1_m2 = "wwise/events/weapon/play_stub_revolver_p1_m2",
			autogun_p3_m1 = "wwise/events/weapon/play_autogun_p3_m1_single",
			lasgun_p1_m2 = "wwise/events/weapon/play_weapon_lasgun_p1_m2",
			bolter_p1_m2 = "wwise/events/weapon/play_weapon_bolter",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_ogryn_thumper_p1_m1",
			stubrevolver_p1_m3 = "wwise/events/weapon/play_stub_revolver_p1_m3",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_fire",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_ogryn_thumper_p1_m2",
			forcestaff_p3_m1 = "wwise/events/weapon/play_psyker_smite_fire",
			laspistol_p1_m3 = "wwise/events/weapon/play_weapon_laspistol",
			shotgun_p1_m1 = "wwise/events/weapon/play_combat_weapon_shotgun",
			ogryn_thumper_p1_m3 = "wwise/events/weapon/play_ogryn_thumper_p1_m1",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_weapon_rippergun",
			bot_autogun_killshot = "wwise/events/weapon/play_autogun_p3_m1_single",
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_weapon_rippergun",
			autopistol_p1_m3 = "wwise/events/weapon/play_weapon_autopistol",
			lasgun_p1_m3 = "wwise/events/weapon/play_weapon_lasgun_p1_m3",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_weapon_rippergun",
			laspistol_p1_m1 = "wwise/events/weapon/play_weapon_laspistol",
			autopistol_p1_m1 = "wwise/events/weapon/play_weapon_autopistol",
			forcestaff_p1_m1 = "wwise/events/weapon/play_psyker_smite_fire",
			lasgun_p1_m1 = "wwise/events/weapon/play_weapon_lasgun_p1_m1",
			bolter_p1_m3 = "wwise/events/weapon/play_weapon_bolter",
			autogun_p3_m3 = "wwise/events/weapon/play_autogun_p3_m3_single",
			lasgun_p2_m1 = {
				default = "wwise/events/weapon/play_lasgun_p2_m1",
				fully_charged = "wwise/events/weapon/play_lasgun_p2_m1_charged"
			},
			lasgun_p2_m2 = {
				default = "wwise/events/weapon/play_lasgun_p2_m2",
				fully_charged = "wwise/events/weapon/play_lasgun_p2_m2_charged"
			},
			lasgun_p2_m3 = {
				default = "wwise/events/weapon/play_lasgun_p2_m3",
				fully_charged = "wwise/events/weapon/play_lasgun_p2_m3_charged"
			},
			plasmagun_p1_m1 = {
				default = "wwise/events/weapon/play_weapon_plasmagun",
				fully_charged = "wwise/events/weapon/play_weapon_plasmagun_charged"
			},
			plasmagun_p1_m2 = {
				default = "wwise/events/weapon/play_weapon_plasmagun",
				fully_charged = "wwise/events/weapon/play_weapon_plasmagun_charged"
			}
		}
	},
	ranged_single_shot_special_extra = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			shotgun_p1_m2 = "wwise/events/weapon/play_shotgun_punch_special",
			shotgun_p1_m1 = "wwise/events/weapon/play_shotgun_punch_special",
			shotgun_p1_m3 = "wwise/events/weapon/play_shotgun_punch_special"
		}
	},
	ranged_shot_tail = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			autogun_p2_m2 = "wwise/events/weapon/play_player_wpn_refl_rifle",
			bot_zola_laspistol = "wwise/events/weapon/play_player_wpn_refl_las_pistol",
			bot_lasgun_killshot = "wwise/events/weapon/play_player_wpn_refl_las",
			lasgun_p2_m2 = "wwise/events/weapon/play_player_wpn_refl_las",
			autogun_p2_m1 = "wwise/events/weapon/play_player_wpn_refl_rifle",
			shotgun_p1_m3 = "wwise/events/weapon/play_player_wpn_refl_shotgun",
			shotgun_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_shotgun",
			shotgun_p1_m2 = "wwise/events/weapon/play_player_wpn_refl_shotgun",
			autogun_p3_m2 = "wwise/events/weapon/play_player_wpn_refl_rifle_heavy",
			stubrevolver_p1_m3 = "wwise/events/weapon/play_player_wpn_refl_revolver",
			lasgun_p3_m3 = "wwise/events/weapon/play_player_wpn_refl_las",
			bot_laspistol_killshot = "wwise/events/weapon/play_player_wpn_refl_las_pistol",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_revolver",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_player_wpn_refl_lmg",
			lasgun_p2_m3 = "wwise/events/weapon/play_player_wpn_refl_rifle_heavy",
			bolter_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_bolter",
			lasgun_p3_m2 = "wwise/events/weapon/play_player_wpn_refl_las",
			autopistol_p1_m2 = "wwise/events/weapon/play_player_wpn_refl_smg",
			autogun_p3_m1 = "wwise/events/weapon/play_player_wpn_refl_rifle_heavy",
			plasmagun_p1_m2 = "wwise/events/weapon/play_player_wpn_refl_plasma",
			lasgun_p1_m2 = "wwise/events/weapon/play_player_wpn_refl_las",
			bolter_p1_m2 = "wwise/events/weapon/play_player_wpn_refl_bolter",
			lasgun_p3_m1 = "wwise/events/weapon/play_player_wpn_refl_las",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_rippergun",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_weapon_silence",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_weapon_silence",
			lasgun_p2_m1 = "wwise/events/weapon/play_player_wpn_refl_rifle_heavy",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_lmg",
			stubrevolver_p1_m2 = "wwise/events/weapon/play_player_wpn_refl_revolver",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_player_wpn_refl_lmg",
			laspistol_p1_m3 = "wwise/events/weapon/play_player_wpn_refl_las_pistol",
			plasmagun_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_plasma",
			ogryn_thumper_p1_m3 = "wwise/events/weapon/play_player_wpn_refl_rippergun",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_player_wpn_refl_rippergun",
			bot_autogun_killshot = "wwise/events/weapon/play_player_wpn_refl_rifle_heavy",
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_player_wpn_refl_rippergun",
			autopistol_p1_m3 = "wwise/events/weapon/play_player_wpn_refl_smg",
			autogun_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_rifle",
			lasgun_p1_m3 = "wwise/events/weapon/play_player_wpn_refl_las",
			autogun_p1_m2 = "wwise/events/weapon/play_player_wpn_refl_rifle",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_rippergun",
			laspistol_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_las_pistol",
			autopistol_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_smg",
			autogun_p2_m3 = "wwise/events/weapon/play_player_wpn_refl_rifle",
			autogun_p1_m3 = "wwise/events/weapon/play_player_wpn_refl_rifle",
			laspistol_p1_m2 = "wwise/events/weapon/play_player_wpn_refl_las_pistol",
			lasgun_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_las",
			bolter_p1_m3 = "wwise/events/weapon/play_player_wpn_refl_bolter",
			autogun_p3_m3 = "wwise/events/weapon/play_player_wpn_refl_rifle_heavy"
		}
	},
	ranged_no_ammo = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			autogun_p2_m2 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			bot_zola_laspistol = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			bot_lasgun_killshot = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			lasgun_p2_m2 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			autogun_p2_m1 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			shotgun_p1_m3 = "wwise/events/weapon/play_combat_weapon_shotgun_no_ammo",
			shotgun_p1_m2 = "wwise/events/weapon/play_combat_weapon_shotgun_no_ammo",
			autopistol_p1_m2 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			autogun_p3_m2 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			stubrevolver_p1_m3 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			lasgun_p3_m3 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			bot_laspistol_killshot = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			stubrevolver_p1_m2 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_weapon_ogryn_shotgun_no_ammo",
			lasgun_p2_m3 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			bolter_p1_m1 = "wwise/events/weapon/play_weapon_bolter_no_ammo",
			lasgun_p3_m2 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_weapon_ogryn_shotgun_no_ammo",
			autogun_p3_m1 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_weapon_ogryn_shotgun_no_ammo",
			lasgun_p1_m2 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			bolter_p1_m2 = "wwise/events/weapon/play_weapon_bolter_no_ammo",
			lasgun_p3_m1 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_weapon_ogryn_shotgun_no_ammo",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_weapon_ogryn_shotgun_no_ammo",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			lasgun_p2_m1 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_weapon_ogryn_shotgun_no_ammo",
			laspistol_p1_m3 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			shotgun_p1_m1 = "wwise/events/weapon/play_combat_weapon_shotgun_no_ammo",
			ogryn_thumper_p1_m3 = "wwise/events/weapon/play_weapon_ogryn_shotgun_no_ammo",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_weapon_ogryn_shotgun_no_ammo",
			bot_autogun_killshot = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_weapon_ogryn_shotgun_no_ammo",
			autopistol_p1_m3 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			autogun_p1_m1 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			autogun_p1_m2 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_weapon_ogryn_shotgun_no_ammo",
			laspistol_p1_m1 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			autopistol_p1_m1 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			autogun_p2_m3 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			autogun_p1_m3 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			laspistol_p1_m2 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			lasgun_p1_m1 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			bolter_p1_m3 = "wwise/events/weapon/play_weapon_bolter_no_ammo",
			autogun_p3_m3 = "wwise/events/weapon/play_weapon_autogun_no_ammo"
		}
	},
	ranged_out_of_ammo = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_silence",
			autogun_p2_m2 = "wwise/events/weapon/play_last_bullet_autogun",
			bot_zola_laspistol = "wwise/events/weapon/play_last_bullet_lasgun",
			flamer_p1_m1 = "wwise/events/weapon/play_last_bullet_flamethrower",
			bot_lasgun_killshot = "wwise/events/weapon/play_last_bullet_lasgun",
			lasgun_p2_m2 = "wwise/events/weapon/play_last_bullet_lasgun",
			shotgun_p1_m3 = "wwise/events/weapon/play_last_bullet_shotgun",
			autopistol_p1_m2 = "wwise/events/weapon/play_last_bullet_autopistol",
			shotgun_p1_m2 = "wwise/events/weapon/play_last_bullet_shotgun",
			autogun_p3_m2 = "wwise/events/weapon/play_last_bullet_rifle_heavy",
			stubrevolver_p1_m3 = "wwise/events/weapon/play_last_bullet_revolver",
			lasgun_p3_m3 = "wwise/events/weapon/play_last_bullet_lasgun",
			bot_laspistol_killshot = "wwise/events/weapon/play_last_bullet_lasgun",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_last_bullet_revolver",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/play_rippergun_last_bullet",
			lasgun_p2_m3 = "wwise/events/weapon/play_last_bullet_lasgun",
			bolter_p1_m1 = "wwise/events/weapon/play_last_bullet_bolter",
			lasgun_p3_m2 = "wwise/events/weapon/play_last_bullet_lasgun",
			autogun_p2_m1 = "wwise/events/weapon/play_last_bullet_autogun",
			autogun_p3_m1 = "wwise/events/weapon/play_last_bullet_rifle_heavy",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_rippergun_last_bullet",
			lasgun_p1_m2 = "wwise/events/weapon/play_last_bullet_lasgun",
			bolter_p1_m2 = "wwise/events/weapon/play_last_bullet_bolter",
			lasgun_p3_m1 = "wwise/events/weapon/play_last_bullet_lasgun",
			stubrevolver_p1_m2 = "wwise/events/weapon/play_last_bullet_revolver",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/play_rippergun_last_bullet",
			lasgun_p2_m1 = "wwise/events/weapon/play_last_bullet_lasgun",
			laspistol_p1_m3 = "wwise/events/weapon/play_last_bullet_lasgun",
			shotgun_p1_m1 = "wwise/events/weapon/play_last_bullet_shotgun",
			ogryn_rippergun_p1_m2 = "wwise/events/weapon/play_rippergun_last_bullet",
			bot_autogun_killshot = "wwise/events/weapon/play_last_bullet_rifle_heavy",
			ogryn_rippergun_p1_m3 = "wwise/events/weapon/play_rippergun_last_bullet",
			autopistol_p1_m3 = "wwise/events/weapon/play_last_bullet_autopistol",
			autogun_p1_m1 = "wwise/events/weapon/play_last_bullet_autogun",
			autogun_p1_m2 = "wwise/events/weapon/play_last_bullet_autogun",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_rippergun_last_bullet",
			laspistol_p1_m1 = "wwise/events/weapon/play_last_bullet_lasgun",
			autopistol_p1_m1 = "wwise/events/weapon/play_last_bullet_autopistol",
			autogun_p2_m3 = "wwise/events/weapon/play_last_bullet_autogun",
			autogun_p1_m3 = "wwise/events/weapon/play_last_bullet_autogun",
			laspistol_p1_m2 = "wwise/events/weapon/play_last_bullet_lasgun",
			lasgun_p1_m1 = "wwise/events/weapon/play_last_bullet_lasgun",
			bolter_p1_m3 = "wwise/events/weapon/play_last_bullet_bolter",
			autogun_p3_m3 = "wwise/events/weapon/play_last_bullet_rifle_heavy"
		}
	},
	critical_shot_extra = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			autopistol_p1_m2 = "wwise/events/weapon/play_indicator_crit_weak",
			autogun_p2_m2 = "wwise/events/weapon/play_indicator_crit_weak",
			bot_zola_laspistol = "wwise/events/weapon/play_indicator_crit_weak",
			bot_laspistol_killshot = "wwise/events/weapon/play_indicator_crit_weak",
			default = "wwise/events/weapon/play_indicator_crit",
			laspistol_p1_m3 = "wwise/events/weapon/play_indicator_crit_weak",
			bot_autogun_killshot = "wwise/events/weapon/play_indicator_crit_weak",
			autopistol_p1_m3 = "wwise/events/weapon/play_indicator_crit_weak",
			autogun_p2_m1 = "wwise/events/weapon/play_indicator_crit_weak",
			autogun_p1_m1 = "wwise/events/weapon/play_indicator_crit_weak",
			autogun_p1_m2 = "wwise/events/weapon/play_indicator_crit_weak",
			autogun_p3_m1 = "wwise/events/weapon/play_indicator_crit_weak",
			laspistol_p1_m1 = "wwise/events/weapon/play_indicator_crit_weak",
			autopistol_p1_m1 = "wwise/events/weapon/play_indicator_crit_weak",
			autogun_p2_m3 = "wwise/events/weapon/play_indicator_crit_weak",
			autogun_p1_m3 = "wwise/events/weapon/play_indicator_crit_weak",
			laspistol_p1_m2 = "wwise/events/weapon/play_indicator_crit_weak",
			autogun_p3_m3 = "wwise/events/weapon/play_indicator_crit_weak"
		}
	},
	ranged_pre_shoot = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_pre_fire"
		}
	},
	ranged_abort = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_interrupt"
		}
	},
	trigger_backstab = {
		has_stop_event = false,
		switch = {
			"attack_type"
		},
		events = {
			melee = "wwise/events/player/play_indicator_backstab_melee",
			default = "wwise/events/debug/play_debug_sound_short",
			ranged = "wwise/events/player/play_indicator_backstab_ranged"
		}
	},
	elite_special_killed_stinger = {
		no_default = true,
		has_husk_events = true,
		switch = {
			"enemy_type"
		},
		events = {
			captain = "wwise/events/player/play_monster_killed",
			monster = "wwise/events/player/play_monster_killed",
			special = "wwise/events/player/play_special_killed",
			elite = "wwise/events/player/play_elite_killed"
		}
	},
	disabled_enter = {
		has_husk_events = true,
		switch = {
			"stinger_type"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			warp_grabbed = "wwise/events/player/play_enemy_daemonhost_grab_stinger",
			teammate_knocked_down = "wwise/events/player/play_teammate_knocked_down",
			mutant_charge = "wwise/events/player/play_hud_player_states_mutant_charger_downed",
			catapulted = "wwise/events/player/play_player_combat_experience_catapulted",
			hanging = "wwise/events/player/play_hud_player_hanging_stinger",
			netted = "wwise/events/player/play_hud_player_states_netgunner_downed",
			teammate_died = "wwise/events/player/play_teammate_died",
			pounced = "wwise/events/player/play_hud_player_states_chaos_hound_downed"
		}
	},
	disabled_exit = {
		no_default = true,
		has_husk_events = false,
		switch = {
			"stinger_type"
		},
		events = {
			netted = "wwise/events/player/play_player_disabled_exit",
			hogtied = "wwise/events/player/play_player_disabled_exit",
			teammate_knocked_down = "wwise/events/player/play_player_disabled_exit",
			pounced = "wwise/events/player/play_player_disabled_exit",
			hanging = "wwise/events/player/play_player_disabled_exit"
		}
	},
	veteran_ranger_highlight = {
		switch = {},
		events = {
			default = "wwise/events/player/play_player_ability_veteran_highlight"
		}
	},
	dodge_success_melee = {
		switch = {
			"enemy_type"
		},
		events = {
			default = "wwise/events/player/play_player_dodge_melee_success",
			elite = "wwise/events/player/play_player_dodge_melee_success",
			special = "wwise/events/player/play_player_dodge_melee_success_specials",
			captain = "wwise/events/player/play_player_dodge_melee_success_specials",
			monster = "wwise/events/player/play_player_dodge_melee_success_specials"
		}
	}
}
local looping_events = {
	ability_no_target_activating = {
		has_husk_events = true,
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/%s_debug_sound_loop"
		}
	},
	ability_target_activating = {
		has_husk_events = true,
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/%s_debug_sound_loop"
		}
	},
	catapulted = {
		has_stop_event = true,
		switch = {},
		events = {
			default = "wwise/events/player/%s_player_combat_experience_catapulted"
		}
	},
	knocked_down = {
		has_stop_event = true,
		switch = {},
		events = {
			default = "wwise/events/player/%s_player_state_knocked_down_loop"
		}
	},
	netted = {
		has_stop_event = true,
		switch = {},
		events = {
			default = "wwise/events/player/%s_player_get_netted_electric_loop"
		}
	},
	toughness_loop = {
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/%s_debug_sound_loop"
		}
	},
	melee_idling = {
		has_husk_events = true,
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			chainsword_2h_p1_m1 = "wwise/events/weapon/%s_2h_chainsword",
			chainsword_p1_m1 = "wwise/events/weapon/%s_combat_weapon_chainsword",
			chainaxe_p1_m3 = "wwise/events/weapon/%s_chainaxe",
			chainsword_p1_m2 = "wwise/events/weapon/%s_combat_weapon_chainsword",
			chainaxe_p1_m2 = "wwise/events/weapon/%s_chainaxe",
			default = "wwise/events/debug/%s_debug_sound_loop",
			chainsword_2h_p1_m2 = "wwise/events/weapon/%s_2h_chainsword",
			chainsword_2h_p1_m3 = "wwise/events/weapon/%s_2h_chainsword",
			chainsword_p1_m3 = "wwise/events/weapon/%s_combat_weapon_chainsword",
			chainaxe_p1_m1 = "wwise/events/weapon/%s_chainaxe"
		}
	},
	ranged_charging = {
		has_husk_events = true,
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/%s_debug_sound_loop",
			forcestaff_p3_m1 = "wwise/events/weapon/%s_psyker_chain_lightning_charge",
			plasmagun_p1_m1 = "wwise/events/weapon/%s_plasmagun_charge",
			psyker_smite = "wwise/events/weapon/%s_psyker_headpop_hands",
			lasgun_p2_m2 = "wwise/events/weapon/%s_lasgun_p2_m2_charge",
			forcestaff_p2_m1 = "wwise/events/weapon/%s_forcestaff_warp_fire_charge_loop",
			lasgun_p2_m1 = "wwise/events/weapon/%s_lasgun_p2_charge",
			forcestaff_p2_m2 = "wwise/events/weapon/%s_forcestaff_warp_fire_charge_loop",
			forcestaff_p4_m1 = "wwise/events/weapon/%s_forcestaff_p4_charge_loop",
			plasmagun_p2_m1 = "wwise/events/weapon/%s_plasmagun_charge",
			lasgun_p2_m3 = "wwise/events/weapon/%s_lasgun_p2_m3_charge"
		}
	},
	ranged_fast_charging = {
		has_husk_events = true,
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/%s_debug_sound_loop",
			plasmagun_p1_m1 = "wwise/events/weapon/%s_weapon_plasmagun_charge_fast",
			lasgun_p2_m1 = "wwise/events/weapon/%s_lasgun_p2_charge",
			lasgun_p2_m2 = "wwise/events/weapon/%s_lasgun_p2_charge",
			plasmagun_p2_m1 = "wwise/events/weapon/%s_weapon_plasmagun_charge_fast",
			lasgun_p2_m3 = "wwise/events/weapon/%s_lasgun_p2_charge"
		}
	},
	weapon_temperature = {
		has_husk_events = false,
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			laspistol_p1_m3 = "wwise/events/weapon/%s_laspistol_heat_loop",
			lasgun_p2_m3 = "wwise/events/weapon/%s_laspistol_heat_loop",
			plasmagun_p1_m1 = "wwise/events/weapon/%s_laspistol_heat_loop",
			flamer_p1_m1 = "wwise/events/weapon/%s_laspistol_heat_loop",
			lasgun_p1_m1 = "wwise/events/weapon/%s_laspistol_heat_loop",
			default = "wwise/events/weapon/%s_laspistol_heat_loop",
			lasgun_p1_m2 = "wwise/events/weapon/%s_laspistol_heat_loop",
			plasmagun_p1_m2 = "wwise/events/weapon/%s_laspistol_heat_loop",
			bot_lasgun_killshot = "wwise/events/weapon/%s_laspistol_heat_loop",
			bot_laspistol_killshot = "wwise/events/weapon/%s_laspistol_heat_loop",
			flamer_p1_m2 = "wwise/events/weapon/%s_laspistol_heat_loop",
			lasgun_p3_m3 = "wwise/events/weapon/%s_laspistol_heat_loop",
			flamer_p1_m3 = "wwise/events/weapon/%s_laspistol_heat_loop",
			bot_zola_laspistol = "wwise/events/weapon/%s_laspistol_heat_loop",
			lasgun_p1_m3 = "wwise/events/weapon/%s_laspistol_heat_loop",
			lasgun_p3_m2 = "wwise/events/weapon/%s_laspistol_heat_loop",
			laspistol_p1_m1 = "wwise/events/weapon/%s_laspistol_heat_loop",
			lasgun_p2_m2 = "wwise/events/weapon/%s_laspistol_heat_loop",
			lasgun_p3_m1 = "wwise/events/weapon/%s_laspistol_heat_loop",
			laspistol_p1_m2 = "wwise/events/weapon/%s_laspistol_heat_loop",
			lasgun_p2_m1 = "wwise/events/weapon/%s_laspistol_heat_loop",
			plasmagun_p1_m3 = "wwise/events/weapon/%s_laspistol_heat_loop"
		}
	},
	psyker_smite_charge = {
		has_husk_events = true,
		has_stop_event = true,
		switch = {},
		events = {
			default = "wwise/events/weapon/%s_psyker_smite_charge"
		}
	},
	ranged_shooting = {
		has_husk_events = true,
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			autopistol_p1_m2 = "wwise/events/weapon/%s_weapon_autopistol_auto",
			autogun_p2_m2 = "wwise/events/weapon/%s_autogun_p2_m2_auto",
			forcestaff_p2_m2 = "wwise/events/weapon/%s_forcestaff_warp_fire",
			flamer_p1_m1 = "wwise/events/weapon/%s_flamethrower_fire_loop",
			forcestaff_p2_m1 = "wwise/events/weapon/%s_forcestaff_warp_fire",
			default = "wwise/events/debug/%s_debug_sound_loop",
			lasgun_p3_m1 = "wwise/events/weapon/%s_lasgun_p3_m1_fire_auto",
			lasgun_p3_m3 = "wwise/events/weapon/%s_lasgun_p3_m3_fire_auto",
			autopistol_p1_m3 = "wwise/events/weapon/%s_weapon_autopistol_auto",
			autogun_p2_m1 = "wwise/events/weapon/%s_autogun_p2_m1_auto",
			autogun_p1_m1 = "wwise/events/weapon/%s_autogun_p1_m1_auto",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/%s_heavy_stubber_auto",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/%s_heavy_stubber_auto",
			lasgun_p3_m2 = "wwise/events/weapon/%s_lasgun_p3_m2_fire_auto",
			autogun_p1_m2 = "wwise/events/weapon/%s_autogun_p1_m2_auto",
			autopistol_p1_m1 = "wwise/events/weapon/%s_weapon_autopistol_auto",
			autogun_p2_m3 = "wwise/events/weapon/%s_autogun_p2_m3_auto",
			autogun_p1_m3 = "wwise/events/weapon/%s_autogun_p1_m3_auto",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/%s_heavy_stubber_auto",
			forcestaff_p3_m1 = "wwise/events/weapon/%s_psyker_chain_lightning",
			scanner_equip = "wwise/events/player/%s_device_scanning"
		}
	},
	ranged_braced_shooting = {
		has_husk_events = true,
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			autopistol_p1_m2 = "wwise/events/weapon/%s_weapon_autopistol_auto",
			autogun_p2_m2 = "wwise/events/weapon/%s_autogun_p2_m2_auto",
			forcestaff_p2_m2 = "wwise/events/weapon/%s_forcestaff_warp_fire",
			forcestaff_p2_m1 = "wwise/events/weapon/%s_forcestaff_warp_fire",
			default = "wwise/events/debug/%s_debug_sound_loop",
			lasgun_p3_m1 = "wwise/events/weapon/%s_lasgun_p3_m1_fire_auto",
			lasgun_p3_m3 = "wwise/events/weapon/%s_lasgun_p3_m3_fire_auto",
			autopistol_p1_m3 = "wwise/events/weapon/%s_weapon_autopistol_auto",
			autogun_p2_m1 = "wwise/events/weapon/%s_autogun_p2_m1_auto",
			autogun_p1_m1 = "wwise/events/weapon/%s_autogun_p1_m1_auto",
			ogryn_heavystubber_p1_m2 = "wwise/events/weapon/%s_heavy_stubber_auto",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/%s_heavy_stubber_auto",
			lasgun_p3_m2 = "wwise/events/weapon/%s_lasgun_p3_m2_fire_auto",
			autogun_p1_m2 = "wwise/events/weapon/%s_autogun_p1_m2_auto",
			autopistol_p1_m1 = "wwise/events/weapon/%s_weapon_autopistol_auto",
			autogun_p2_m3 = "wwise/events/weapon/%s_autogun_p2_m3_auto",
			autogun_p1_m3 = "wwise/events/weapon/%s_autogun_p1_m3_auto",
			ogryn_heavystubber_p1_m3 = "wwise/events/weapon/%s_heavy_stubber_auto",
			forcestaff_p3_m1 = "wwise/events/weapon/%s_psyker_chain_lightning_heavy",
			scanner_equip = "wwise/events/player/%s_scanner_collect_loop"
		}
	},
	melee_sticky_loop = {
		has_husk_events = true,
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			chainsword_2h_p1_m1 = "wwise/events/weapon/%s_2h_chainsword_stuck_loop",
			chainsword_p1_m1 = "wwise/events/weapon/%s_combat_weapon_chainsword_stuck_loop",
			chainaxe_p1_m3 = "wwise/events/weapon/%s_chainaxe_stuck_loop",
			chainsword_p1_m2 = "wwise/events/weapon/%s_combat_weapon_chainsword_stuck_loop",
			chainaxe_p1_m2 = "wwise/events/weapon/%s_chainaxe_stuck_loop",
			default = "wwise/events/debug/%s_debug_sound_loop",
			chainsword_2h_p1_m2 = "wwise/events/weapon/%s_2h_chainsword_stuck_loop",
			forcesword_p1_m3 = "wwise/events/weapon/%s_force_sword_stuck",
			forcesword_p1_m1 = "wwise/events/weapon/%s_force_sword_stuck",
			chainsword_2h_p1_m3 = "wwise/events/weapon/%s_2h_chainsword_stuck_loop",
			powermaul_p1_m1 = "wwise/events/weapon/%s_psyker_chain_lightning_hit",
			chainsword_p1_m3 = "wwise/events/weapon/%s_combat_weapon_chainsword_stuck_loop",
			forcesword_p1_m2 = "wwise/events/weapon/%s_force_sword_stuck",
			chainaxe_p1_m1 = "wwise/events/weapon/%s_chainaxe_stuck_loop"
		}
	},
	ranged_plasma_venting = {
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/%s_debug_sound_loop",
			plasmagun_p2_m1 = "wwise/events/weapon/%s_weapon_plasma_mech_vent",
			plasmagun_p1_m1 = "wwise/events/weapon/%s_weapon_plasma_mech_vent"
		}
	},
	player_slide_loop = {
		has_husk_events = true,
		has_stop_event = true,
		switch = {},
		events = {
			default = "wwise/events/player/%s_player_slide"
		}
	},
	weapon_special_loop = {
		has_husk_events = true,
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/%s_debug_sound_loop",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/%s_thunder_hammer_powered_loop",
			thunderhammer_2h_p1_m2 = "wwise/events/weapon/%s_thunder_hammer_powered_loop",
			forcesword_p1_m1 = "wwise/events/weapon/%s_force_sword_loop",
			thunderhammer_2h_p1_m3 = "wwise/events/weapon/%s_thunder_hammer_powered_loop",
			powersword_p1_m2 = "wwise/events/weapon/%s_power_sword_loop",
			ogryn_powermaul_p1_m1 = "wwise/events/weapon/%s_ogryn_power_maul_1h_loop",
			forcesword_p1_m3 = "wwise/events/weapon/%s_force_sword_loop",
			powersword_p1_m1 = "wwise/events/weapon/%s_power_sword_loop",
			ogryn_powermaul_slabshield_p1_m1 = "wwise/events/weapon/%s_ogryn_power_maul_1h_loop",
			powermaul_2h_p1_m1 = "wwise/events/weapon/%s_ogryn_power_maul_1h_loop",
			forcesword_p1_m2 = "wwise/events/weapon/%s_force_sword_loop",
			powersword_p1_m3 = "wwise/events/weapon/%s_power_sword_loop"
		}
	},
	weapon_overload_loop = {
		has_husk_events = true,
		has_stop_event = true,
		switch = {
			"wielded_weapon_template",
			"stage"
		},
		events = {
			default = "wwise/events/debug/%s_debug_sound_loop",
			plasmagun_p1_m1 = {
				default = "wwise/events/weapon/%s_plasmagun_overheat",
				critical = "wwise/events/weapon/%s_plasmagun_overheat_intensity_03"
			},
			plasmagun_p2_m1 = {
				default = "wwise/events/weapon/%s_plasmagun_overheat",
				critical = "wwise/events/weapon/%s_plasmagun_overheat_intensity_03"
			}
		}
	},
	block_loop = {
		no_default = true,
		has_husk_events = false,
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			forcesword_p1_m3 = "wwise/events/weapon/%s_psyker_smite_charge",
			forcesword_p1_m2 = "wwise/events/weapon/%s_psyker_smite_charge",
			forcesword_p1_m1 = "wwise/events/weapon/%s_psyker_smite_charge"
		}
	},
	interact_loop = {
		has_husk_events = false,
		has_stop_event = true,
		switch = {
			"interaction_type"
		},
		events = {
			rescue = "wwise/events/player/%s_player_interact_gen_loop",
			default = "wwise/events/player/%s_player_interact_gen_loop",
			revive = "wwise/events/player/%s_player_interact_gen_loop"
		}
	},
	equipped_item_passive = {
		has_husk_events = true,
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/%s_debug_sound_loop",
			grimoire_pocketable = "wwise/events/player/%s_grimoire_loop"
		}
	},
	sfx_minigame_loop = {
		has_stop_event = true,
		switch = {
			"wielded_weapon_template",
			"loop_type"
		},
		events = {
			default = "wwise/events/debug/%s_debug_sound_loop",
			auspex_scanner = "wwise/events/player/%s_device_auspex_scanner_minigame_loop"
		}
	}
}

local function _replace_event_values(t, string_value)
	for key, value in pairs(t) do
		local value_type = type(value)

		if value_type == "table" then
			_replace_event_values(value, string_value)
		elseif value_type == "string" then
			t[key] = string.format(value, string_value)
		end
	end
end

for alias, data in pairs(looping_events) do
	local play_data = table.clone(data)

	_replace_event_values(play_data.events, "play")

	play_data.has_stop_event = nil
	local play_alias = "play_" .. alias
	events[play_alias] = play_data

	if data.has_stop_event then
		local stop_data = table.clone(data)

		_replace_event_values(stop_data.events, "stop")

		stop_data.has_stop_event = nil
		local stop_alias = "stop_" .. alias
		events[stop_alias] = stop_data
	end
end

return events
