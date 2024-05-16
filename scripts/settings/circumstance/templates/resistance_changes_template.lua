-- chunkname: @scripts/settings/circumstance/templates/resistance_changes_template.lua

local circumstance_templates = {
	more_resistance_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_dummy_more_resistance_description",
			display_name = "loc_circumstance_dummy_more_resistance_title",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
		},
		mutators = {
			"mutator_add_resistance",
		},
	},
	less_resistance_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_dummy_less_resistance_description",
			display_name = "loc_circumstance_dummy_less_resistance_title",
			icon = "content/ui/materials/icons/circumstances/less_resistance_01",
		},
		mutators = {
			"mutator_subtract_resistance",
		},
	},
	min_resistance_max_challenge_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_dummy_more_resistance_description",
			display_name = "loc_circumstance_dummy_more_resistance_title",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
		},
		mutators = {
			"mutator_set_min_resistance",
			"mutator_set_max_challenge",
		},
	},
	min_challenge_max_resistance_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_dummy_more_resistance_description",
			display_name = "loc_circumstance_dummy_more_resistance_title",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
		},
		mutators = {
			"mutator_set_max_resistance",
			"mutator_set_min_challenge",
		},
	},
	six_one_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_min_resistance_max_challenge_description",
			display_name = "loc_circumstance_min_resistance_max_challenge_title",
			icon = "content/ui/materials/icons/circumstances/six_one_01",
		},
		mutators = {
			"mutator_more_alive_specials",
			"mutator_specials_required_challenge_rating",
			"mutator_travel_distance_spawning_specials",
			"mutator_travel_distance_spawning_hordes",
			"mutator_higher_stagger_thresholds",
			"mutator_no_encampments",
			"mutator_move_specials_timer_when_horde_active",
			"mutator_move_specials_timer_when_monster_active",
			"mutator_modify_challenge_resistance_scale_six_one",
		},
	},
	speedrun_challenge_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_dummy_more_resistance_description",
			display_name = "loc_circumstance_dummy_more_resistance_title",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
		},
		mutators = {
			"mutator_no_encampments",
			"mutator_more_specials",
			"mutator_no_hordes",
			"mutator_only_none_roamer_packs",
			"mutator_low_roamer_amount",
			"mutator_corruption_over_time_2",
		},
	},
	waves_of_specials_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_waves_of_specials_description",
			display_name = "loc_circumstance_waves_of_specials_title",
			icon = "content/ui/materials/icons/circumstances/special_waves_01",
		},
		mutators = {
			"mutator_waves_of_specials",
		},
	},
	waves_of_specials_more_resistance_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_waves_of_specials_more_resistance_description",
			display_name = "loc_circumstance_waves_of_specials_more_resistance_title",
			icon = "content/ui/materials/icons/circumstances/special_waves_02",
		},
		mutators = {
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration_low",
			"mutator_auric_tension_modifier",
		},
	},
	waves_of_specials_less_resistance_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_waves_of_specials_less_resistance_description",
			display_name = "loc_circumstance_waves_of_specials_less_resistance_title",
			icon = "content/ui/materials/icons/circumstances/special_waves_03",
		},
		mutators = {
			"mutator_waves_of_specials",
			"mutator_subtract_resistance",
		},
	},
	exploration_mode_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_exploration_mode_description",
			display_name = "loc_circumstance_exploration_mode_title",
			icon = "content/ui/materials/icons/circumstances/less_resistance_01",
		},
		mutators = {
			"mutator_set_min_resistance",
			"mutator_travel_distance_spawning_specials",
			"mutator_travel_distance_spawning_hordes",
			"mutator_no_hordes",
			"mutator_only_none_roamer_packs",
			"mutator_low_roamer_amount",
		},
	},
	solo_mode_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_dummy_more_resistance_description",
			display_name = "loc_circumstance_dummy_more_resistance_title",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
		},
		mutators = {
			"mutator_no_encampments",
			"mutator_travel_distance_spawning_specials",
			"mutator_travel_distance_spawning_hordes",
			"mutator_subtract_resistance_02",
			"mutator_half_boss_health",
			"mutator_movement_speed_on_spawn",
		},
	},
	only_melee_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_dummy_only_melee_description",
			display_name = "loc_circumstance_dummy_only_melee_title",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
		},
		mutators = {
			"mutator_only_melee_roamers",
			"mutator_only_melee_trickle_hordes",
			"mutator_only_melee_terror_events",
		},
	},
	only_ranged_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_dummy_only_ranged_description",
			display_name = "loc_circumstance_dummy_only_ranged_title",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
		},
		mutators = {
			"mutator_no_encampments",
			"mutator_only_ranged_roamers",
			"mutator_only_ranged_trickle_hordes",
			"mutator_only_ranged_terror_events",
		},
	},
	monster_specials_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_dummy_only_melee_description",
			display_name = "loc_circumstance_waves_of_specials_more_resistance_title",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
		},
		mutators = {
			"mutator_monster_specials",
		},
	},
	monster_specials_more_specials_more_resistance_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_dummy_only_melee_description",
			display_name = "loc_circumstance_waves_of_specials_more_resistance_title",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
		},
		mutators = {
			"mutator_monster_specials",
			"mutator_waves_of_specials",
			"mutator_add_resistance",
		},
	},
	only_melee_no_ammo_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_dummy_only_melee_description",
			display_name = "loc_circumstance_dummy_only_melee_title",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
		},
		mutators = {
			"mutator_only_melee_roamers",
			"mutator_only_melee_trickle_hordes",
			"mutator_only_melee_terror_events",
		},
		mission_overrides = {
			pickup_settings = {
				rubberband_pool = {
					ammo = {
						small_clip = {
							-99,
							-99,
							-99,
							-99,
							-99,
						},
						large_clip = {
							-99,
							-99,
							-99,
							-99,
							-99,
						},
						ammo_cache_pocketable = {
							-99,
							-99,
							-99,
							-99,
							-99,
						},
					},
					grenade = {
						small_grenade = {
							3,
							3,
							3,
							3,
							3,
						},
					},
				},
				mid_event = {
					ammo = {
						small_clip = {
							-99,
							-99,
							-99,
							-99,
							-99,
						},
						large_clip = {
							-99,
							-99,
							-99,
							-99,
							-99,
						},
						ammo_cache_pocketable = {
							-99,
							-99,
							-99,
							-99,
							-99,
						},
					},
				},
				end_event = {
					ammo = {
						small_clip = {
							-99,
							-99,
							-99,
							-99,
							-99,
						},
						large_clip = {
							-99,
							-99,
							-99,
							-99,
							-99,
						},
						ammo_cache_pocketable = {
							-99,
							-99,
							-99,
							-99,
							-99,
						},
					},
				},
				primary = {
					ammo = {
						small_clip = {
							-99,
							-99,
							-99,
							-99,
							-99,
						},
						large_clip = {
							-99,
							-99,
							-99,
							-99,
							-99,
						},
						ammo_cache_pocketable = {
							-99,
							-99,
							-99,
							-99,
							-99,
						},
					},
					grenade = {
						small_grenade = {
							4,
							4,
							4,
							4,
							4,
						},
					},
				},
				secondary = {
					ammo = {
						small_clip = {
							-99,
							-99,
							-99,
							-99,
							-99,
						},
						large_clip = {
							-99,
							-99,
							-99,
							-99,
							-99,
						},
						ammo_cache_pocketable = {
							-99,
							-99,
							-99,
							-99,
							-99,
						},
					},
				},
			},
		},
	},
	more_captains_01 = {
		theme_tag = "default",
		mutators = {
			"mutator_more_captains",
		},
		ui = {
			description = "loc_circumstance_more_captains_description",
			display_name = "loc_circumstance_more_captains_title",
			icon = "content/ui/materials/icons/circumstances/placeholder",
		},
	},
	more_boss_patrols_01 = {
		theme_tag = "default",
		mutators = {
			"mutator_more_boss_patrols",
		},
		ui = {
			description = "loc_circumstance_more_boss_patrols_description",
			display_name = "loc_circumstance_more_boss_patrols_title",
			icon = "content/ui/materials/icons/circumstances/placeholder",
		},
	},
}

return circumstance_templates
