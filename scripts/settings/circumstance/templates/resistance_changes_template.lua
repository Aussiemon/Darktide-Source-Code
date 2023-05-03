local circumstance_templates = {
	more_resistance_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_dummy_more_resistance_description",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
			display_name = "loc_circumstance_dummy_more_resistance_title"
		},
		mutators = {
			"mutator_add_resistance"
		}
	},
	less_resistance_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_dummy_less_resistance_description",
			icon = "content/ui/materials/icons/circumstances/less_resistance_01",
			display_name = "loc_circumstance_dummy_less_resistance_title"
		},
		mutators = {
			"mutator_subtract_resistance"
		}
	},
	min_resistance_max_challenge_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_dummy_more_resistance_description",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
			display_name = "loc_circumstance_dummy_more_resistance_title"
		},
		mutators = {
			"mutator_set_min_resistance",
			"mutator_set_max_challenge"
		}
	},
	min_challenge_max_resistance_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_dummy_more_resistance_description",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
			display_name = "loc_circumstance_dummy_more_resistance_title"
		},
		mutators = {
			"mutator_set_max_resistance",
			"mutator_set_min_challenge"
		}
	},
	six_one_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_min_resistance_max_challenge_description",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
			display_name = "loc_circumstance_min_resistance_max_challenge_title"
		},
		mutators = {
			"mutator_modify_challenge_resistance_scale_six_one",
			"mutator_travel_distance_spawning_specials",
			"mutator_travel_distance_spawning_hordes",
			"mutator_more_alive_specials",
			"mutator_higher_stagger_thresholds",
			"mutator_no_encampments"
		}
	},
	speedrun_challenge_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_dummy_more_resistance_description",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
			display_name = "loc_circumstance_dummy_more_resistance_title"
		},
		mutators = {
			"mutator_no_encampments",
			"mutator_more_specials",
			"mutator_no_hordes",
			"mutator_only_none_roamer_packs",
			"mutator_low_roamer_amount",
			"mutator_corruption_over_time_2"
		}
	},
	waves_of_specials_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_waves_of_specials_description",
			icon = "content/ui/materials/icons/circumstances/special_waves_01",
			display_name = "loc_circumstance_waves_of_specials_title"
		},
		mutators = {
			"mutator_waves_of_specials"
		}
	},
	waves_of_specials_more_resistance_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_waves_of_specials_more_resistance_description",
			icon = "content/ui/materials/icons/circumstances/special_waves_02",
			display_name = "loc_circumstance_waves_of_specials_more_resistance_title"
		},
		mutators = {
			"mutator_waves_of_specials",
			"mutator_add_resistance"
		}
	},
	waves_of_specials_less_resistance_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_waves_of_specials_less_resistance_description",
			icon = "content/ui/materials/icons/circumstances/special_waves_03",
			display_name = "loc_circumstance_waves_of_specials_less_resistance_title"
		},
		mutators = {
			"mutator_waves_of_specials",
			"mutator_subtract_resistance"
		}
	},
	exploration_mode_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_exploration_mode_description",
			icon = "content/ui/materials/icons/circumstances/less_resistance_01",
			display_name = "loc_circumstance_exploration_mode_title"
		},
		mutators = {
			"mutator_set_min_resistance",
			"mutator_travel_distance_spawning_specials",
			"mutator_travel_distance_spawning_hordes"
		}
	},
	solo_mode_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_dummy_more_resistance_description",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
			display_name = "loc_circumstance_dummy_more_resistance_title"
		},
		mutators = {
			"mutator_no_encampments",
			"mutator_travel_distance_spawning_specials",
			"mutator_travel_distance_spawning_hordes",
			"mutator_subtract_resistance_02",
			"mutator_half_boss_health"
		}
	},
	only_melee_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_dummy_only_melee_description",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
			display_name = "loc_circumstance_dummy_only_melee_title"
		},
		mutators = {
			"mutator_only_melee_roamers",
			"mutator_only_melee_trickle_hordes",
			"mutator_only_melee_terror_events"
		}
	},
	only_ranged_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_dummy_only_ranged_description",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
			display_name = "loc_circumstance_dummy_only_ranged_title"
		},
		mutators = {
			"mutator_no_encampments",
			"mutator_only_ranged_roamers",
			"mutator_only_ranged_trickle_hordes",
			"mutator_only_ranged_terror_events"
		}
	},
	only_melee_no_ammo_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_dummy_only_melee_description",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
			display_name = "loc_circumstance_dummy_only_melee_title"
		},
		mutators = {
			"mutator_only_melee_roamers",
			"mutator_only_melee_trickle_hordes",
			"mutator_only_melee_terror_events"
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
	}
}

return circumstance_templates
