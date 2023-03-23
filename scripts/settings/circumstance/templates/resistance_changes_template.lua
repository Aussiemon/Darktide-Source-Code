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
			"mutator_set_min_resistance",
			"mutator_set_max_challenge",
			"mutator_travel_distance_spawning_specials",
			"mutator_more_specials",
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
	}
}

return circumstance_templates
