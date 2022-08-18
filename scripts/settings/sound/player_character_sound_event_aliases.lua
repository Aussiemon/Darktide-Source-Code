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
			lasgun_p1_m1 = "wwise/events/weapon/play_lasgun_reload_grab_clip",
			bot_lasgun_killshot = "wwise/events/weapon/play_lasgun_reload_grab_clip",
			laspistol_p1_m1 = "wwise/events/weapon/play_lasgun_reload_grab_clip",
			lasgun_p1_m2 = "wwise/events/weapon/play_lasgun_reload_grab_clip",
			lasgun_p1_m3 = "wwise/events/weapon/play_lasgun_reload_grab_clip"
		}
	},
	sfx_grab_weapon = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/player/play_foley_hands_grab_range_weapon",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_lever_grab",
			combatsword_p1_m1 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			forcesword_p1_m1 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_lever_grab",
			combatsword_p3_m1 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			autopistol_p1_m1 = "wwise/events/weapon/play_autopistol_reload_end",
			forcesword_p1_m3 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			combatsword_p1_m2 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_lever_grab",
			powersword_p1_m1 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			thunderhammer_2h_p1_m1 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			autopistol_p2_m1 = "wwise/events/weapon/play_autopistol_reload_end",
			forcesword_p1_m2 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			combatsword_p1_m3 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			powermaul_2h_p1_m1 = "wwise/events/player/play_foley_hands_grip_melee_handle"
		}
	},
	sfx_pull_pin = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_grenade_pull_pin",
			krak_grenade = "wwise/events/weapon/play_grenade_pull_pin",
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
			autogun_p2_m2 = "wwise/events/weapon/play_autogun_equip",
			combatsword_p3_m1 = "wwise/events/weapon/play_weapon_equip_medium_sword",
			flamer_p1_m1 = "wwise/events/weapon/play_flametrower_equip_var_1",
			autogun_p1_m2 = "wwise/events/weapon/play_autogun_equip",
			forcesword_p1_m1 = "wwise/events/weapon/play_sword_light_equip",
			powermaul_2h_p1_m1 = "wwise/events/player/play_foley_hands_grip_melee_handle",
			autogun_p1_m3 = "wwise/events/weapon/play_autogun_equip",
			powersword_p1_m1 = "wwise/events/weapon/play_weapon_equip_medium_sword",
			autogun_p3_m2 = "wwise/events/weapon/play_autogun_equip",
			forcestaff_p2_m1 = "wwise/events/weapon/play_force_staff_equip",
			autogun_p2_m1 = "wwise/events/weapon/play_autogun_equip",
			bot_lasgun_killshot = "wwise/events/weapon/play_weapon_lasgun_equip",
			forcesword_p1_m2 = "wwise/events/weapon/play_sword_light_equip",
			forcestaff_p3_m1 = "wwise/events/weapon/play_force_staff_equip",
			lasgun_p1_m1 = "wwise/events/weapon/play_weapon_lasgun_equip",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_equip",
			lasgun_p1_m2 = "wwise/events/weapon/play_weapon_lasgun_equip",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/thumper_shotgun_close",
			autogun_p3_m1 = "wwise/events/weapon/play_autogun_equip",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/thumper_shotgun_close",
			combataxe_p1_m1 = "wwise/events/weapon/play_pipe_club_equip",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_equip",
			forcesword_p1_m3 = "wwise/events/weapon/play_sword_light_equip",
			plasmagun_p2_m1 = "wwise/events/weapon/play_weapon_equip_plasma_gun",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_equip_var_1",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_stub_revolver_equip",
			fire_grenade = "wwise/events/weapon/play_grenade_equip",
			autopistol_p2_m1 = "wwise/events/weapon/play_autopistol_equip",
			krak_grenade = "wwise/events/weapon/play_grenade_equip",
			ogryn_combatblade_p1_m1 = "wwise/events/weapon/play_ogryn_knife_equip",
			plasmagun_p1_m1 = "wwise/events/weapon/play_weapon_equip_plasma_gun",
			combatknife_p1_m1 = "wwise/events/weapon/play_combat_knife_equip_var_1",
			ogryn_club_p1_m1 = "wwise/events/weapon/play_pipe_club_equip",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/play_weapon_equip_thunder_hammer",
			auspex_scanner = "wwise/events/weapon/play_stub_revolver_equip",
			autogun_p1_m1 = "wwise/events/weapon/play_autogun_equip",
			combatsword_p1_m3 = "wwise/events/weapon/play_weapon_equip_medium_sword",
			lasgun_p1_m3 = "wwise/events/weapon/play_weapon_lasgun_equip",
			ogryn_powermaul_p1_m1 = "wwise/events/weapon/play_pipe_club_equip",
			combatsword_p1_m1 = "wwise/events/weapon/play_weapon_equip_medium_sword",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_weapon_rippergun_equip",
			laspistol_p1_m1 = "wwise/events/weapon/play_autopistol_equip",
			autopistol_p1_m1 = "wwise/events/weapon/play_autopistol_equip",
			frag_grenade = "wwise/events/weapon/play_grenade_equip",
			combatsword_p1_m2 = "wwise/events/weapon/play_weapon_equip_medium_sword",
			forcestaff_p1_m1 = "wwise/events/weapon/play_force_staff_equip",
			psyker_throwing_knives = "wwise/events/weapon/play_psyker_gunslinger_equip",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_equip",
			autogun_p3_m3 = "wwise/events/weapon/play_autogun_equip"
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
			powermaul_2h_p1_m1 = "wwise/events/weapon/play_weapon_thunder_hammer_spin",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_equip_var_2",
			flamer_p1_m1 = "wwise/events/weapon/play_flametrower_equip_var_2",
			ogryn_club_p2_m1 = "wwise/events/weapon/play_physical_swing",
			combatknife_p1_m1 = "wwise/events/weapon/play_combat_knife_equip_var_2",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/play_weapon_thunder_hammer_spin"
		}
	},
	sfx_equip_03 = {
		no_default = true,
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			combatknife_p1_m1 = "wwise/events/weapon/play_combat_knife_equip_var_3"
		}
	},
	sfx_equip_04 = {
		no_default = true,
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			combatknife_p1_m1 = "wwise/events/weapon/play_combat_knife_equip_var_4"
		}
	},
	sfx_foley_equip = {
		has_husk_events = false,
		switch = {
			"body_material"
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
			default = "wwise/events/weapon/play_rifle_ads_up",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_ads_up",
			shotgun_p1_m1 = "wwise/events/weapon/play_weapon_ads_foley_autogun",
			flamer_p1_m1 = "wwise/events/weapon/play_flametrower_alt_fire_on",
			laspistol_p1_m1 = "wwise/events/weapon/play_rifle_ads_up",
			lasgun_p1_m2 = "wwise/events/weapon/play_rifle_ads_up",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_ads_up",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_ads_up",
			bot_lasgun_killshot = "wwise/events/weapon/play_rifle_ads_up",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_wpn_up",
			shotgun_p3_m1 = "wwise/events/weapon/play_weapon_ads_foley_autogun",
			lasgun_p1_m1 = "wwise/events/weapon/play_rifle_ads_up",
			autopistol_p2_m1 = "wwise/events/weapon/play_rifle_ads_up",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_revolver_ads_up",
			lasgun_p1_m3 = "wwise/events/weapon/play_rifle_ads_up"
		}
	},
	sfx_ads_down = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_rifle_ads_down",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_ads_down",
			shotgun_p1_m1 = "wwise/events/weapon/play_weapon_ads_foley_autogun",
			flamer_p1_m1 = "wwise/events/weapon/play_flametrower_alt_fire_off",
			laspistol_p1_m1 = "wwise/events/weapon/play_rifle_ads_down",
			lasgun_p1_m2 = "wwise/events/weapon/play_rifle_ads_down",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_ads_down",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_ads_down",
			bot_lasgun_killshot = "wwise/events/weapon/play_rifle_ads_down",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_wpn_down",
			shotgun_p3_m1 = "wwise/events/weapon/play_weapon_ads_foley_autogun",
			lasgun_p1_m1 = "wwise/events/weapon/play_rifle_ads_down",
			autopistol_p2_m1 = "wwise/events/weapon/play_rifle_ads_down",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_revolver_ads_down",
			lasgun_p1_m3 = "wwise/events/weapon/play_rifle_ads_down"
		}
	},
	sfx_weapon_down = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_rifle_subtle",
			bolter_p1_m3 = "wwise/events/weapon/play_rifle_heavy_subtle",
			shotgun_p1_m1 = "wwise/events/weapon/play_rifle_subtle",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_reload_hand_to_barrel",
			laspistol_p1_m1 = "wwise/events/weapon/play_rifle_subtle",
			lasgun_p1_m2 = "wwise/events/weapon/play_rifle_subtle",
			bolter_p1_m2 = "wwise/events/weapon/play_rifle_heavy_subtle",
			bolter_p1_m1 = "wwise/events/weapon/play_rifle_heavy_subtle",
			luggable = "wwise/events/player/play_item_luggable_throw",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_weapon_rippergun_placed",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_weapon_rippergun_placed",
			lasgun_p1_m1 = "wwise/events/weapon/play_rifle_subtle",
			autopistol_p2_m1 = "wwise/events/weapon/play_rifle_subtle",
			bot_lasgun_killshot = "wwise/events/weapon/play_rifle_subtle"
		}
	},
	sfx_weapon_up = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_rifle_wpn_up",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_reload_lift",
			shotgun_p1_m1 = "wwise/events/weapon/play_rifle_wpn_up",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_reload_lift",
			laspistol_p1_m1 = "wwise/events/weapon/play_rifle_wpn_up",
			lasgun_p1_m2 = "wwise/events/weapon/play_rifle_wpn_up",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_reload_lift",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_reload_lift",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_weapon_rippergun_lift",
			shotgun_p3_m1 = "wwise/events/weapon/play_rifle_wpn_up",
			bot_lasgun_killshot = "wwise/events/weapon/play_rifle_wpn_up",
			lasgun_p1_m1 = "wwise/events/weapon/play_rifle_wpn_up",
			autopistol_p2_m1 = "wwise/events/weapon/play_rifle_wpn_up",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_weapon_rippergun_lift",
			lasgun_p1_m3 = "wwise/events/weapon/play_rifle_wpn_up"
		}
	},
	sfx_weapon_locomotion = {
		has_husk_events = false,
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			autopistol_p2_m3 = "wwise/events/weapon/play_smg_locomotion",
			autogun_p2_m2 = "wwise/events/weapon/play_rifle_locomotion",
			autogun_p3_m2 = "wwise/events/weapon/play_rifle_locomotion",
			flamer_p1_m1 = "wwise/events/weapon/play_heavy_locomotion",
			autopistol_p3_m2 = "wwise/events/weapon/play_smg_locomotion",
			bot_lasgun_killshot = "wwise/events/weapon/play_rifle_locomotion",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_heavy_locomotion",
			shotgun_p1_m1 = "wwise/events/weapon/play_heavy_locomotion",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_heavy_locomotion",
			autogun_p2_m1 = "wwise/events/weapon/play_rifle_locomotion",
			autopistol_p3_m3 = "wwise/events/weapon/play_smg_locomotion",
			bolter_p1_m1 = "wwise/events/weapon/play_heavy_locomotion",
			autogun_p3_m1 = "wwise/events/weapon/play_rifle_locomotion",
			lasgun_p1_m2 = "wwise/events/weapon/play_rifle_locomotion",
			bolter_p1_m2 = "wwise/events/weapon/play_heavy_locomotion",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_heavy_locomotion",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_heavy_locomotion",
			autopistol_p3_m1 = "wwise/events/weapon/play_smg_locomotion",
			autopistol_p2_m1 = "wwise/events/weapon/play_smg_locomotion",
			plasmagun_p2_m1 = "wwise/events/weapon/play_weapon_plasma_gun_movement_foley",
			autopistol_p1_m2 = "wwise/events/weapon/play_smg_locomotion",
			plasmagun_p1_m1 = "wwise/events/weapon/play_weapon_plasma_gun_movement_foley",
			autopistol_p2_m2 = "wwise/events/weapon/play_smg_locomotion",
			autopistol_p1_m3 = "wwise/events/weapon/play_smg_locomotion",
			autogun_p1_m1 = "wwise/events/weapon/play_rifle_locomotion",
			lasgun_p1_m3 = "wwise/events/weapon/play_rifle_locomotion",
			autogun_p1_m2 = "wwise/events/weapon/play_rifle_locomotion",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_heavy_locomotion",
			laspistol_p1_m1 = "wwise/events/weapon/play_rifle_locomotion",
			autopistol_p1_m1 = "wwise/events/weapon/play_smg_locomotion",
			autogun_p1_m3 = "wwise/events/weapon/play_rifle_locomotion",
			lasgun_p1_m1 = "wwise/events/weapon/play_rifle_locomotion",
			bolter_p1_m3 = "wwise/events/weapon/play_heavy_locomotion",
			autogun_p3_m3 = "wwise/events/weapon/play_rifle_locomotion"
		}
	},
	sfx_weapon_foley_subtle = {
		has_husk_events = false,
		no_default = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			bot_lasgun_killshot = "wwise/events/weapon/play_rifle_subtle",
			autogun_p2_m2 = "wwise/events/weapon/play_rifle_subtle",
			autogun_p1_m2 = "wwise/events/weapon/play_rifle_subtle",
			autogun_p3_m1 = "wwise/events/weapon/play_rifle_subtle",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_reload_lift",
			lasgun_p1_m2 = "wwise/events/weapon/play_rifle_subtle",
			lasgun_p1_m1 = "wwise/events/weapon/play_rifle_subtle",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_ogryn_wpn_up",
			autogun_p1_m3 = "wwise/events/weapon/play_rifle_subtle",
			autogun_p3_m2 = "wwise/events/weapon/play_rifle_subtle",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_wpn_up",
			autogun_p2_m1 = "wwise/events/weapon/play_rifle_subtle",
			autogun_p1_m1 = "wwise/events/weapon/play_rifle_subtle",
			lasgun_p1_m3 = "wwise/events/weapon/play_rifle_subtle",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_ogryn_wpn_up",
			autogun_p3_m3 = "wwise/events/weapon/play_rifle_subtle"
		}
	},
	sfx_weapon_foley_heavy = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_foley_plasma_rifle_heavy_movement",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_hand",
			plasmagun_p1_m1 = "wwise/events/weapon/play_foley_plasma_rifle_heavy_movement",
			plasmagun_p2_m1 = "wwise/events/weapon/play_foley_plasma_rifle_heavy_movement",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_hand",
			luggable = "wwise/events/player/play_item_luggable_foley",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_hand"
		}
	},
	sfx_hit_weapon = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/player/play_foley_hand_hit_weapon_plasma_rifle",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_hit",
			plasmagun_p1_m1 = "wwise/events/player/play_foley_hand_hit_weapon_plasma_rifle",
			flamer_p1_m1 = "wwise/events/weapon/play_flametrower_alt_fire_off",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_hit",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_hit",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_hit",
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
			plasmagun_p2_m1 = "wwise/events/weapon/play_weapon_plasmagun_vent_rattle",
			plasmagun_p1_m1 = "wwise/events/weapon/play_weapon_plasmagun_vent_rattle"
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
	ranged_charging_done = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_lasgun_charge_ready",
			lasgun_p2_m1 = "wwise/events/weapon/play_weapon_lasgun_charge_ready"
		}
	},
	sfx_magazine_eject = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_reload_foley_plasma_flask_connect",
			autogun_p2_m2 = "wwise/events/weapon/play_autogun_reload_clip_out",
			plasmagun_p1_m1 = "wwise/events/weapon/play_weapon_plasma_vent",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_reload_mag_out",
			autopistol_p1_m1 = "wwise/events/weapon/play_autopistol_mag_out",
			bot_lasgun_killshot = "wwise/events/weapon/play_lasgun_reload_clip_out",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_eject",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/thumper_shotgun_open",
			autopistol_p2_m1 = "wwise/events/weapon/play_autopistol_mag_out",
			autogun_p3_m2 = "wwise/events/weapon/play_autogun_reload_clip_out",
			autogun_p2_m1 = "wwise/events/weapon/play_autogun_reload_clip_out",
			autogun_p1_m1 = "wwise/events/weapon/play_autogun_reload_clip_out",
			lasgun_p1_m3 = "wwise/events/weapon/play_lasgun_reload_clip_out",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_clip_out",
			autogun_p1_m2 = "wwise/events/weapon/play_autogun_reload_clip_out",
			autogun_p3_m1 = "wwise/events/weapon/play_autogun_reload_clip_out",
			laspistol_p1_m1 = "wwise/events/weapon/play_reload_foley_laspistol_clip_out",
			lasgun_p1_m2 = "wwise/events/weapon/play_lasgun_reload_clip_out",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_clip_out",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/thumper_shotgun_open",
			autogun_p1_m3 = "wwise/events/weapon/play_autogun_reload_clip_out",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_mag_out",
			lasgun_p1_m1 = "wwise/events/weapon/play_lasgun_reload_clip_out",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_clip_out",
			autogun_p3_m3 = "wwise/events/weapon/play_autogun_reload_clip_out"
		}
	},
	sfx_magazine_insert = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_reload_foley_plasma_flask_connect",
			autogun_p2_m2 = "wwise/events/weapon/play_autogun_reload_clip_in",
			plasmagun_p1_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_insert",
			bot_lasgun_killshot = "wwise/events/weapon/play_lasgun_reload_clip_in",
			autopistol_p1_m1 = "wwise/events/weapon/play_autopistol_mag_in",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_insert",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/thumper_shotgun_insert",
			autopistol_p2_m1 = "wwise/events/weapon/play_autopistol_mag_in",
			autogun_p3_m2 = "wwise/events/weapon/play_autogun_reload_clip_in",
			autogun_p2_m1 = "wwise/events/weapon/play_autogun_reload_clip_in",
			autogun_p1_m1 = "wwise/events/weapon/play_autogun_reload_clip_in",
			lasgun_p1_m3 = "wwise/events/weapon/play_lasgun_reload_clip_in",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_clip_in",
			autogun_p1_m2 = "wwise/events/weapon/play_autogun_reload_clip_in",
			autogun_p3_m1 = "wwise/events/weapon/play_autogun_reload_clip_in",
			laspistol_p1_m1 = "wwise/events/weapon/play_reload_foley_laspistol_clip_in",
			lasgun_p1_m2 = "wwise/events/weapon/play_lasgun_reload_clip_in",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_clip_in",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/thumper_shotgun_insert",
			autogun_p1_m3 = "wwise/events/weapon/play_autogun_reload_clip_in",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_mag_in",
			lasgun_p1_m1 = "wwise/events/weapon/play_lasgun_reload_clip_in",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_clip_in",
			plasmagun_p2_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_insert",
			autogun_p3_m3 = "wwise/events/weapon/play_autogun_reload_clip_in"
		}
	},
	sfx_reload_lever_pull = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_reload_foley_plasma_flask_connect",
			autogun_p2_m2 = "wwise/events/weapon/play_autogun_reload_lever_pull",
			autogun_p1_m2 = "wwise/events/weapon/play_autogun_reload_lever_pull",
			autogun_p3_m1 = "wwise/events/weapon/play_autogun_reload_lever_pull",
			autopistol_p2_m1 = "wwise/events/weapon/play_autopistol_lever",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_lever_pull",
			autopistol_p1_m1 = "wwise/events/weapon/play_autopistol_lever",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_lever_pull",
			autogun_p1_m3 = "wwise/events/weapon/play_autogun_reload_lever_pull",
			autogun_p3_m2 = "wwise/events/weapon/play_autogun_reload_lever_pull",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_lever_pull",
			autogun_p2_m1 = "wwise/events/weapon/play_autogun_reload_lever_pull",
			autogun_p1_m1 = "wwise/events/weapon/play_autogun_reload_lever_pull",
			shotgun_p1_m1 = "wwise/events/weapon/play_shotgun_reload_pull",
			shotgun_p3_m1 = "wwise/events/weapon/play_shotgun_reload_pull",
			autogun_p3_m3 = "wwise/events/weapon/play_autogun_reload_lever_pull"
		}
	},
	sfx_reload_lever_release = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_reload_foley_plasma_flask_connect",
			autogun_p2_m2 = "wwise/events/weapon/play_autogun_reload_lever_release",
			shotgun_p1_m1 = "wwise/events/weapon/play_shotgun_reload_push",
			bot_lasgun_killshot = "wwise/events/weapon/play_lasgun_reload_lever_release",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/thumper_shotgun_close",
			shotgun_p3_m1 = "wwise/events/weapon/play_shotgun_reload_push",
			autogun_p3_m2 = "wwise/events/weapon/play_autogun_reload_lever_release",
			autogun_p2_m1 = "wwise/events/weapon/play_autogun_reload_lever_release",
			autogun_p1_m1 = "wwise/events/weapon/play_autogun_reload_lever_release",
			lasgun_p1_m3 = "wwise/events/weapon/play_lasgun_reload_lever_release",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_lever_release",
			autogun_p1_m2 = "wwise/events/weapon/play_autogun_reload_lever_release",
			autogun_p3_m1 = "wwise/events/weapon/play_autogun_reload_lever_release",
			laspistol_p1_m1 = "wwise/events/weapon/play_reload_foley_laspistol_recharge_on",
			lasgun_p1_m2 = "wwise/events/weapon/play_lasgun_reload_lever_release",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_lever_release",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/thumper_shotgun_close",
			autogun_p1_m3 = "wwise/events/weapon/play_autogun_reload_lever_release",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_reload_finish",
			lasgun_p1_m1 = "wwise/events/weapon/play_lasgun_reload_lever_release",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_lever_release",
			autogun_p3_m3 = "wwise/events/weapon/play_autogun_reload_lever_release"
		}
	},
	magazine_fail = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			plasmagun_p2_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_connect",
			plasmagun_p1_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_connect",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_reload_foley_rippergun_magazine_pull"
		}
	},
	sfx_mag_contact = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			bot_lasgun_killshot = "wwise/events/weapon/play_lasgun_reload_clip_contact",
			plasmagun_p1_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_connect",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_reload_screw",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_clip_contact",
			lasgun_p1_m2 = "wwise/events/weapon/play_lasgun_reload_clip_contact",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_clip_contact",
			frag_grenade = "wwise/events/weapon/play_combat_knife_equip_var_4",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_rippergun_mag_contact",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_mag_contact",
			lasgun_p1_m1 = "wwise/events/weapon/play_lasgun_reload_clip_contact",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_clip_contact",
			plasmagun_p2_m1 = "wwise/events/weapon/play_reload_foley_plasma_flask_connect",
			lasgun_p1_m3 = "wwise/events/weapon/play_lasgun_reload_clip_contact"
		}
	},
	sfx_button = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			shotgun_p3_m1 = "wwise/events/weapon/play_shotgun_reload_insert_ammo_special",
			shotgun_p1_m1 = "wwise/events/weapon/play_shotgun_reload_insert_ammo_special",
			bolter_p1_m1 = "wwise/events/weapon/play_bolter_reload_clip_button",
			bolter_p1_m3 = "wwise/events/weapon/play_bolter_reload_clip_button",
			bolter_p1_m2 = "wwise/events/weapon/play_bolter_reload_clip_button"
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
			default = "wwise/events/debug/play_debug_sound_short",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_weapon_rippergun_handle_out"
		}
	},
	sfx_weapon_handle_in = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_weapon_rippergun_handle_in"
		}
	},
	sfx_weapon_revolver_open = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_stub_revolver_open"
		}
	},
	sfx_weapon_revolver_close = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_stub_revolver_cock"
		}
	},
	sfx_weapon_eject_ammo = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_stub_revolver_eject"
		}
	},
	sfx_weapon_insert_ammo = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			shotgun_p1_m1 = "wwise/events/weapon/play_weapon_shotgun_human_reload_insert_ammo",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_stub_revolver_insert_bullet"
		}
	},
	sfx_weapon_twist = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/play_debug_sound_short",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_stub_revolver_cylinder_twist",
			flamer_p1_m1 = "wwise/events/weapon/play_flamethrower_reload_screw"
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
			default = "wwise/events/weapon/play_weapon_silence",
			combatsword_p1_m3 = "wwise/events/weapon/play_sword_swing_medium",
			combatsword_p3_m1 = "wwise/events/weapon/play_sword_swing_medium",
			forcesword_p1_m1 = "wwise/events/weapon/play_force_sword_swing",
			ogryn_club_p2_m1 = "wwise/events/weapon/play_pipe_swing",
			combatknife_p1_m1 = "wwise/events/weapon/play_swing_knife",
			ogryn_club_p1_m1 = "wwise/events/weapon/play_pipe_swing",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/play_thunder_hammer_swing",
			powersword_p1_m1 = "wwise/events/weapon/play_power_sword_swing",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_ogryn_gauntlet_swing",
			powermaul_2h_p1_m1 = "wwise/events/weapon/play_thunder_hammer_swing",
			ogryn_powermaul_p1_m1 = "wwise/events/weapon/play_power_maul_swing",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_swing",
			forcesword_p1_m2 = "wwise/events/weapon/play_force_sword_swing",
			chainaxe_p1_m1 = "wwise/events/weapon/play_chainaxe_swing",
			shovel_p1_m1 = "wwise/events/weapon/play_pipe_swing",
			chainsword_2h_p1_m1 = "wwise/events/weapon/play_combat_weapon_chainsword_swing",
			chainsword_p1_m1 = "wwise/events/weapon/play_combat_weapon_chainsword_swing",
			combatsword_p1_m1 = "wwise/events/weapon/play_sword_swing_medium",
			combataxe_p3_m2 = "wwise/events/weapon/play_axe_swing_light",
			combataxe_p1_m1 = "wwise/events/weapon/play_axe_swing_light",
			forcesword_p1_m3 = "wwise/events/weapon/play_force_sword_swing",
			combatsword_p1_m2 = "wwise/events/weapon/play_sword_swing_medium",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_swing",
			prologue_shovel_human = "wwise/events/weapon/play_axe_swing_light",
			ogryn_combatblade_p1_m1 = "wwise/events/weapon/play_combat_weapon_combat_knife_ogryn_swing"
		}
	},
	sfx_swing_heavy = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_silence",
			combatsword_p1_m3 = "wwise/events/weapon/play_sword_swing_medium",
			combatsword_p3_m1 = "wwise/events/weapon/play_sword_swing_medium",
			forcesword_p1_m1 = "wwise/events/weapon/play_force_sword_swing",
			ogryn_club_p2_m1 = "wwise/events/weapon/play_pipe_swing",
			combatknife_p1_m1 = "wwise/events/weapon/play_swing_knife",
			ogryn_club_p1_m1 = "wwise/events/weapon/play_pipe_swing",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/play_thunder_hammer_swing",
			powersword_p1_m1 = "wwise/events/weapon/play_power_sword_swing",
			shovel_p1_m1 = "wwise/events/weapon/play_combat_weapon_shovel_swing",
			powermaul_2h_p1_m1 = "wwise/events/weapon/play_thunder_hammer_swing",
			ogryn_powermaul_p1_m1 = "wwise/events/weapon/play_power_maul_swing",
			forcesword_p1_m2 = "wwise/events/weapon/play_force_sword_swing",
			chainaxe_p1_m1 = "wwise/events/weapon/play_chainaxe_swing",
			chainsword_2h_p1_m1 = "wwise/events/weapon/play_combat_weapon_chainsword_swing",
			chainsword_p1_m1 = "wwise/events/weapon/play_combat_weapon_chainsword_swing",
			combatsword_p1_m1 = "wwise/events/weapon/play_sword_swing_medium",
			combataxe_p3_m2 = "wwise/events/weapon/play_axe_swing_light",
			combataxe_p1_m1 = "wwise/events/weapon/play_axe_swing_light",
			forcesword_p1_m3 = "wwise/events/weapon/play_force_sword_swing",
			combatsword_p1_m2 = "wwise/events/weapon/play_sword_swing_medium",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_swing",
			prologue_shovel_human = "wwise/events/weapon/play_axe_swing_light",
			ogryn_combatblade_p1_m1 = "wwise/events/weapon/play_combat_weapon_combat_knife_ogryn_swing"
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
				default = "wwise/events/weapon/play_weapon_silence",
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
			true = "wwise/events/weapon/play_indicator_crit_melee_swing"
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
			combataxe_p1_m1 = "wwise/events/weapon/play_metal_pipe_block_gen",
			forcesword_p1_m1 = "wwise/events/weapon/play_force_shield_block",
			ogryn_club_p2_m1 = "wwise/events/weapon/play_metal_pipe_block_gen",
			combatknife_p1_m1 = "wwise/events/weapon/play_knife_block",
			ogryn_club_p1_m1 = "wwise/events/weapon/play_metal_pipe_block_gen",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/play_metal_pipe_block_gen",
			powermaul_2h_p1_m1 = "wwise/events/weapon/play_metal_pipe_block_gen",
			ogryn_powermaul_p1_m1 = "wwise/events/weapon/play_metal_pipe_block_gen",
			forcesword_p1_m2 = "wwise/events/weapon/play_force_shield_block",
			chainaxe_p1_m1 = "wwise/events/weapon/play_chainsword_block",
			chainsword_2h_p1_m1 = "wwise/events/weapon/play_chainsword_block",
			chainsword_p1_m1 = "wwise/events/weapon/play_chainsword_block",
			shovel_p1_m1 = "wwise/events/weapon/play_metal_pipe_block_gen",
			forcesword_p1_m3 = "wwise/events/weapon/play_force_shield_block",
			ogryn_combatblade_p1_m1 = "wwise/events/weapon/play_metal_pipe_block_gen"
		}
	},
	melee_sweep_hit = {
		no_default = true,
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			combatsword_p3_m1 = "wwise/events/weapon/stop_sword_swing_medium",
			powersword_p1_m1 = "wwise/events/weapon/stop_sword_swing_large",
			combatsword_p1_m1 = "wwise/events/weapon/stop_sword_swing_medium",
			forcesword_p1_m1 = "wwise/events/weapon/stop_sword_swing_large",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/stop_swing_2h_powerhammer",
			combatknife_p1_m1 = "wwise/events/weapon/stop_swing_knife",
			forcesword_p1_m3 = "wwise/events/weapon/stop_sword_swing_large",
			combatsword_p1_m2 = "wwise/events/weapon/stop_sword_swing_medium",
			forcesword_p1_m2 = "wwise/events/weapon/stop_sword_swing_large",
			combatsword_p1_m3 = "wwise/events/weapon/stop_sword_swing_medium"
		}
	},
	melee_heavy_sweep_hit = {
		no_default = true,
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			powermaul_2h_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			combatsword_p3_m1 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			combataxe_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			forcesword_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			ogryn_club_p2_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			combatknife_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			ogryn_club_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			powersword_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			combataxe_p3_m1 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			ogryn_powermaul_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			forcesword_p1_m2 = "wwise/events/weapon/play_heavy_swing_hit",
			combatsword_p1_m3 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			chainsword_2h_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			chainsword_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			combatsword_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			shovel_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			forcesword_p1_m3 = "wwise/events/weapon/play_heavy_swing_hit",
			combatsword_p1_m2 = "wwise/events/weapon/play_heavy_swing_hit_slashing",
			chainsaxe_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit",
			ogryn_combatblade_p1_m1 = "wwise/events/weapon/play_heavy_swing_hit_slashing"
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
			true = {
				default = "wwise/events/weapon/play_indicator_crit_melee_hit",
				combataxe_p3_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combatsword_p1_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				forcesword_p1_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combatsword_p1_m3 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combatknife_p1_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combataxe_p1_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				forcesword_p1_m3 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combatsword_p1_m2 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				powersword_p1_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				shovel_p1_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				ogryn_combatblade_p1_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				forcesword_p1_m2 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing",
				combatsword_p3_m1 = "wwise/events/weapon/play_indicator_crit_melee_hit_slashing"
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
			true = "wwise/events/weapon/play_indicator_crit_melee_hit"
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
			chainsword_p1_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			combatsword_p1_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			forcesword_p1_m1 = "wwise/events/weapon/play_force_sword_push_follow_up",
			laspistol_p1_m1 = "wwise/events/weapon/play_force_sword_push_follow_up",
			chainsword_2h_p1_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_force_sword_push_follow_up",
			forcesword_p1_m3 = "wwise/events/weapon/play_force_sword_push_follow_up",
			combatsword_p1_m2 = "wwise/events/weapon/play_pushback_sword_stab",
			chainaxe_p1_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			combatsword_p1_m3 = "wwise/events/weapon/play_pushback_sword_stab",
			combatsword_p3_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			ogryn_combatblade_p1_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			forcesword_p1_m2 = "wwise/events/weapon/play_force_sword_push_follow_up",
			combatsword_p2_m1 = "wwise/events/weapon/play_pushback_sword_stab"
		}
	},
	sfx_special_activate = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_silence",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_pushback_sword_stab",
			forcesword_p1_m1 = "wwise/events/weapon/play_force_sword_on",
			flamer_p1_m1 = "wwise/events/weapon/play_flametrower_equip_var_1",
			powermaul_2h_p1_m1 = "wwise/events/weapon/play_thunder_hammer_power_start",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/play_thunder_hammer_power_start",
			ogryn_powermaul_p1_m1 = "wwise/events/weapon/play_power_sword_on",
			forcesword_p1_m3 = "wwise/events/weapon/play_force_sword_on",
			powersword_p1_m1 = "wwise/events/weapon/play_power_sword_on",
			forcesword_p1_m2 = "wwise/events/weapon/play_force_sword_on"
		}
	},
	weapon_special_end = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_weapon_silence",
			powersword_p1_m1 = "wwise/events/weapon/play_power_sword_off",
			ogryn_powermaul_p1_m1 = "wwise/events/weapon/play_power_sword_off",
			forcesword_p1_m1 = "wwise/events/weapon/play_force_sword_off",
			forcesword_p1_m2 = "wwise/events/weapon/play_force_sword_off",
			forcesword_p1_m3 = "wwise/events/weapon/play_force_sword_off"
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
			autogun_p2_m2 = "wwise/events/weapon/play_weapon_autogun_v2_first",
			autogun_p1_m2 = "wwise/events/weapon/play_weapon_autogun_first",
			autogun_p3_m1 = "wwise/events/weapon/play_weapon_autogun_first",
			autopistol_p1_m2 = "wwise/events/weapon/play_weapon_autopistol",
			autopistol_p2_m1 = "wwise/events/weapon/play_weapon_autopistol",
			autopistol_p1_m1 = "wwise/events/weapon/play_weapon_autopistol",
			autopistol_p2_m2 = "wwise/events/weapon/play_weapon_autopistol",
			autogun_p1_m3 = "wwise/events/weapon/play_weapon_autogun_first",
			autogun_p3_m2 = "wwise/events/weapon/play_weapon_autogun_first",
			autopistol_p1_m3 = "wwise/events/weapon/play_weapon_autopistol",
			autogun_p2_m1 = "wwise/events/weapon/play_weapon_autogun_v2_first",
			autogun_p1_m1 = "wwise/events/weapon/play_weapon_autogun_first",
			autopistol_p2_m3 = "wwise/events/weapon/play_weapon_autopistol",
			autogun_p3_m3 = "wwise/events/weapon/play_weapon_autogun_first"
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
			bolter_p1_m1 = "wwise/events/weapon/play_weapon_bolter",
			psyker_throwing_knives = "wwise/events/weapon/play_psyker_throw_knife",
			psyker_smite = "wwise/events/weapon/play_psyker_smite_fire",
			autogun_p3_m2 = "wwise/events/weapon/play_weapon_autogun_single",
			lasgun_p2_m2 = "wwise/events/weapon/play_weapon_lasgun_p1_m1",
			bot_lasgun_killshot = "wwise/events/weapon/play_weapon_lasgun_p1_m1",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_stub_revolver",
			shotgun_p3_m1 = "wwise/events/weapon/play_combat_weapon_shotgun",
			forcestaff_p2_m1 = "wwise/events/weapon/play_psyker_smite_fire",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_ogryn_thumper_p1_m1",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_ogryn_thumper_p1_m2",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_weapon_bolter",
			lasgun_p3_m2 = "wwise/events/weapon/play_weapon_lasgun_p1_m1",
			autogun_p3_m1 = "wwise/events/weapon/play_weapon_autogun_single",
			lasgun_p1_m2 = "wwise/events/weapon/play_weapon_lasgun_p1_m2",
			bolter_p1_m2 = "wwise/events/weapon/play_weapon_bolter",
			lasgun_p3_m1 = "wwise/events/weapon/play_weapon_lasgun_p1_m1",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_ogryn_gauntlet_fire",
			lasgun_p2_m1 = "wwise/events/weapon/play_weapon_lasgun_p1_m1",
			forcestaff_p3_m1 = "wwise/events/weapon/play_psyker_smite_fire",
			autopistol_p1_m2 = "wwise/events/weapon/play_weapon_autogun_single",
			shotgun_p1_m1 = "wwise/events/weapon/play_combat_weapon_shotgun",
			autopistol_p1_m3 = "wwise/events/weapon/play_weapon_autogun_single",
			lasgun_p1_m3 = "wwise/events/weapon/play_weapon_lasgun_p1_m3",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_weapon_rippergun",
			laspistol_p1_m1 = "wwise/events/weapon/play_weapon_laspistol",
			autopistol_p1_m1 = "wwise/events/weapon/play_weapon_autogun_single",
			forcestaff_p1_m1 = "wwise/events/weapon/play_psyker_smite_fire",
			lasgun_p1_m1 = "wwise/events/weapon/play_weapon_lasgun_p1_m1",
			bolter_p1_m3 = "wwise/events/weapon/play_weapon_bolter",
			autogun_p3_m3 = "wwise/events/weapon/play_weapon_autogun_single",
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
			shotgun_p3_m1 = "wwise/events/weapon/play_shotgun_punch_special",
			shotgun_p1_m1 = "wwise/events/weapon/play_shotgun_punch_special"
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
			autogun_p3_m2 = "wwise/events/weapon/play_player_wpn_refl_rifle",
			bot_lasgun_killshot = "wwise/events/weapon/play_player_wpn_refl_las",
			bolter_p1_m2 = "wwise/events/weapon/play_player_wpn_refl_bolter",
			lasgun_p2_m2 = "wwise/events/weapon/play_player_wpn_refl_las",
			plasmagun_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_plasma",
			bolter_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_bolter",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_rippergun",
			shotgun_p3_m1 = "wwise/events/weapon/play_player_wpn_refl_shotgun",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_weapon_silence",
			autogun_p2_m1 = "wwise/events/weapon/play_player_wpn_refl_rifle",
			ogryn_heavystubber_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_bolter",
			lasgun_p3_m2 = "wwise/events/weapon/play_player_wpn_refl_las",
			autogun_p3_m1 = "wwise/events/weapon/play_player_wpn_refl_rifle",
			plasmagun_p1_m2 = "wwise/events/weapon/play_player_wpn_refl_plasma",
			lasgun_p1_m2 = "wwise/events/weapon/play_player_wpn_refl_las",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_revolver",
			lasgun_p3_m1 = "wwise/events/weapon/play_player_wpn_refl_las",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_weapon_silence",
			lasgun_p2_m1 = "wwise/events/weapon/play_player_wpn_refl_las",
			autopistol_p2_m1 = "wwise/events/weapon/play_player_wpn_refl_smg",
			autopistol_p1_m2 = "wwise/events/weapon/play_player_wpn_refl_smg",
			shotgun_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_shotgun",
			autogun_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_rifle",
			lasgun_p1_m3 = "wwise/events/weapon/play_player_wpn_refl_las",
			autogun_p1_m2 = "wwise/events/weapon/play_player_wpn_refl_rifle",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_rippergun",
			laspistol_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_las_pistol",
			autopistol_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_smg",
			autogun_p1_m3 = "wwise/events/weapon/play_player_wpn_refl_rifle",
			lasgun_p1_m1 = "wwise/events/weapon/play_player_wpn_refl_las",
			bolter_p1_m3 = "wwise/events/weapon/play_player_wpn_refl_bolter",
			autogun_p3_m3 = "wwise/events/weapon/play_player_wpn_refl_rifle"
		}
	},
	ranged_no_ammo = {
		has_husk_events = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			autopistol_p1_m2 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			autogun_p2_m2 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			shotgun_p1_m1 = "wwise/events/weapon/play_combat_weapon_shotgun_no_ammo",
			bot_lasgun_killshot = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			default = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			lasgun_p2_m1 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			lasgun_p2_m2 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			autopistol_p1_m1 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			shotgun_p3_m1 = "wwise/events/weapon/play_combat_weapon_shotgun_no_ammo",
			autogun_p3_m2 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			autogun_p2_m1 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			autogun_p1_m1 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_weapon_ogryn_shotgun_no_ammo",
			ogryn_thumper_p1_m1 = "wwise/events/weapon/play_weapon_ogryn_shotgun_no_ammo",
			ogryn_thumper_p1_m2 = "wwise/events/weapon/play_weapon_ogryn_shotgun_no_ammo",
			bolter_p1_m1 = "wwise/events/weapon/play_weapon_bolter_no_ammo",
			lasgun_p3_m2 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			autogun_p1_m2 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			autogun_p3_m1 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			laspistol_p1_m1 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			lasgun_p1_m2 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			bolter_p1_m2 = "wwise/events/weapon/play_weapon_bolter_no_ammo",
			lasgun_p3_m1 = "wwise/events/weapon/play_weapon_lasgun_no_ammo",
			autogun_p1_m3 = "wwise/events/weapon/play_weapon_autogun_no_ammo",
			ogryn_gauntlet_p1_m1 = "wwise/events/weapon/play_weapon_ogryn_shotgun_no_ammo",
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
			autopistol_p1_m2 = "wwise/events/weapon/play_last_bullet_autopistol",
			autogun_p2_m2 = "wwise/events/weapon/play_last_bullet_autogun",
			shotgun_p1_m1 = "wwise/events/weapon/play_last_bullet_shotgun",
			flamer_p1_m1 = "wwise/events/weapon/play_last_bullet_flamethrower",
			autopistol_p1_m1 = "wwise/events/weapon/play_last_bullet_autopistol",
			default = "wwise/events/weapon/play_weapon_silence",
			lasgun_p2_m1 = "wwise/events/weapon/play_last_bullet_lasgun",
			lasgun_p2_m2 = "wwise/events/weapon/play_last_bullet_lasgun",
			laspistol_p2_m1 = "wwise/events/weapon/play_last_bullet_lasgun",
			autogun_p3_m2 = "wwise/events/weapon/play_last_bullet_autogun",
			laspistol_p2_m2 = "wwise/events/weapon/play_last_bullet_lasgun",
			autogun_p2_m1 = "wwise/events/weapon/play_last_bullet_autogun",
			autogun_p1_m1 = "wwise/events/weapon/play_last_bullet_autogun",
			bot_lasgun_killshot = "wwise/events/weapon/play_last_bullet_lasgun",
			shotgun_p3_m1 = "wwise/events/weapon/play_last_bullet_shotgun",
			stubrevolver_p1_m1 = "wwise/events/weapon/play_last_bullet_revolver",
			bolter_p1_m1 = "wwise/events/weapon/play_last_bullet_bolter",
			lasgun_p3_m2 = "wwise/events/weapon/play_last_bullet_lasgun",
			autogun_p1_m2 = "wwise/events/weapon/play_last_bullet_autogun",
			autogun_p3_m1 = "wwise/events/weapon/play_last_bullet_autogun",
			laspistol_p1_m1 = "wwise/events/weapon/play_last_bullet_lasgun",
			lasgun_p1_m2 = "wwise/events/weapon/play_last_bullet_lasgun",
			bolter_p1_m2 = "wwise/events/weapon/play_last_bullet_bolter",
			lasgun_p3_m1 = "wwise/events/weapon/play_last_bullet_lasgun",
			autogun_p1_m3 = "wwise/events/weapon/play_last_bullet_autogun",
			ogryn_rippergun_p1_m1 = "wwise/events/weapon/play_rippergun_last_bullet",
			laspistol_p1_m2 = "wwise/events/weapon/play_last_bullet_lasgun",
			lasgun_p1_m1 = "wwise/events/weapon/play_last_bullet_lasgun",
			bolter_p1_m3 = "wwise/events/weapon/play_last_bullet_bolter",
			autogun_p3_m3 = "wwise/events/weapon/play_last_bullet_autogun"
		}
	},
	critical_shot_extra = {
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/play_indicator_crit",
			autogun_p2_m2 = "wwise/events/weapon/play_indicator_crit_weak",
			autogun_p1_m2 = "wwise/events/weapon/play_indicator_crit_weak",
			autogun_p3_m1 = "wwise/events/weapon/play_indicator_crit_weak",
			laspistol_p1_m1 = "wwise/events/weapon/play_indicator_crit_weak",
			autopistol_p1_m2 = "wwise/events/weapon/play_indicator_crit_weak",
			autopistol_p1_m1 = "wwise/events/weapon/play_indicator_crit_weak",
			laspistol_p2_m1 = "wwise/events/weapon/play_indicator_crit_weak",
			autogun_p1_m3 = "wwise/events/weapon/play_indicator_crit_weak",
			autogun_p3_m2 = "wwise/events/weapon/play_indicator_crit_weak",
			laspistol_p1_m2 = "wwise/events/weapon/play_indicator_crit_weak",
			autogun_p2_m1 = "wwise/events/weapon/play_indicator_crit_weak",
			autogun_p1_m1 = "wwise/events/weapon/play_indicator_crit_weak",
			laspistol_p2_m2 = "wwise/events/weapon/play_indicator_crit_weak",
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
	sfx_catch_charge = {
		no_default = true,
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			psyker_throwing_knives = "wwise/events/weapon/play_psyker_throwing_knife_pre_fetch"
		}
	},
	sfx_catch = {
		no_default = true,
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			psyker_throwing_knives = "wwise/events/weapon/play_psyker_knife_fetch"
		}
	},
	sfx_catch_cancel = {
		no_default = true,
		has_husk_events = false,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			psyker_throwing_knives = "wwise/events/weapon/play_psyker_knife_fetch_cancel"
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
			"minion_tag"
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
			hanging = "wwise/events/player/play_player_disabled_exit",
			pounced = "wwise/events/player/play_player_disabled_exit",
			hogtied = "wwise/events/player/play_player_disabled_exit"
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
			special = "wwise/events/player/play_player_dodge_melee_success_specials",
			elite = "wwise/events/player/play_player_dodge_melee_success",
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
			default = "wwise/events/debug/%s_debug_sound_loop",
			chainsword_p1_m1 = "wwise/events/weapon/%s_combat_weapon_chainsword",
			chainaxe_p1_m1 = "wwise/events/weapon/%s_chainaxe",
			chainsword_2h_p1_m1 = "wwise/events/weapon/%s_combat_weapon_chainsword"
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
			plasmagun_p2_m1 = "wwise/events/weapon/%s_plasmagun_charge",
			plasmagun_p1_m1 = "wwise/events/weapon/%s_plasmagun_charge",
			psyker_chain_lightning = "wwise/events/weapon/%s_psyker_chain_lightning_charge"
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
			plasmagun_p2_m1 = "wwise/events/weapon/%s_weapon_plasmagun_charge_fast",
			plasmagun_p1_m1 = "wwise/events/weapon/%s_weapon_plasmagun_charge_fast"
		}
	},
	weapon_temperature = {
		has_husk_events = false,
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/weapon/%s_laspistol_heat_loop",
			bot_lasgun_killshot = "wwise/events/weapon/%s_laspistol_heat_loop",
			lasgun_p1_m1 = "wwise/events/weapon/%s_laspistol_heat_loop",
			laspistol_p1_m1 = "wwise/events/weapon/%s_laspistol_heat_loop",
			lasgun_p1_m2 = "wwise/events/weapon/%s_laspistol_heat_loop",
			lasgun_p1_m3 = "wwise/events/weapon/%s_laspistol_heat_loop"
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
	psyker_headpop_hands = {
		has_husk_events = true,
		has_stop_event = true,
		switch = {},
		events = {
			default = "wwise/events/weapon/%s_psyker_headpop_hands"
		}
	},
	ranged_shooting = {
		has_husk_events = true,
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/%s_debug_sound_loop",
			autogun_p2_m2 = "wwise/events/weapon/%s_weapon_autogun_v2_auto",
			autogun_p1_m1 = "wwise/events/weapon/%s_weapon_autogun_auto",
			autogun_p3_m1 = "wwise/events/weapon/%s_weapon_autogun_auto",
			flamer_p1_m1 = "wwise/events/weapon/%s_flamethrower_fire_loop",
			scanner_equip = "wwise/events/player/%s_device_scanning",
			autopistol_p1_m1 = "wwise/events/weapon/%s_weapon_autopistol_auto",
			psyker_chain_lightning = "wwise/events/weapon/%s_psyker_chain_lightning",
			autogun_p2_m1 = "wwise/events/weapon/%s_weapon_autogun_v2_auto",
			autopistol_p2_m1 = "wwise/events/weapon/%s_weapon_autopistol_auto",
			autogun_p3_m3 = "wwise/events/weapon/%s_weapon_autogun_auto"
		}
	},
	ranged_braced_shooting = {
		has_husk_events = true,
		has_stop_event = true,
		switch = {
			"wielded_weapon_template"
		},
		events = {
			default = "wwise/events/debug/%s_debug_sound_loop",
			autogun_p2_m2 = "wwise/events/weapon/%s_weapon_autogun_v2_auto",
			autogun_p1_m1 = "wwise/events/weapon/%s_weapon_autogun_auto",
			autogun_p3_m1 = "wwise/events/weapon/%s_weapon_autogun_auto",
			autopistol_p1_m1 = "wwise/events/weapon/%s_weapon_autopistol_auto",
			psyker_chain_lightning = "wwise/events/weapon/%s_psyker_chain_lightning_heavy",
			autogun_p3_m2 = "wwise/events/weapon/%s_weapon_autogun_auto",
			autogun_p2_m1 = "wwise/events/weapon/%s_weapon_autogun_v2_auto",
			autopistol_p2_m1 = "wwise/events/weapon/%s_weapon_autopistol_auto",
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
			chainsword_2h_p1_m1 = "wwise/events/weapon/%s_combat_weapon_chainsword_stuck_loop",
			chainsword_p1_m1 = "wwise/events/weapon/%s_combat_weapon_chainsword_stuck_loop",
			default = "wwise/events/debug/%s_debug_sound_loop",
			forcesword_p1_m1 = "wwise/events/weapon/%s_force_sword_stuck",
			forcesword_p1_m2 = "wwise/events/weapon/%s_force_sword_stuck",
			chainaxe_p1_m1 = "wwise/events/weapon/%s_combat_weapon_chainsword_stuck_loop",
			forcesword_p1_m3 = "wwise/events/weapon/%s_force_sword_stuck"
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
			powersword_p1_m1 = "wwise/events/weapon/%s_power_sword_loop",
			thunderhammer_2h_p1_m1 = "wwise/events/weapon/%s_thunder_hammer_powered_loop",
			forcesword_p1_m1 = "wwise/events/weapon/%s_force_sword_loop",
			ogryn_powermaul_p1_m1 = "wwise/events/weapon/%s_thunder_hammer_powered_loop",
			forcesword_p1_m2 = "wwise/events/weapon/%s_force_sword_loop",
			powermaul_2h_p1_m1 = "wwise/events/weapon/%s_thunder_hammer_powered_loop",
			forcesword_p1_m3 = "wwise/events/weapon/%s_force_sword_loop"
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
