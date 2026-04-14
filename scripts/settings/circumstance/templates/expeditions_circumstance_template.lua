-- chunkname: @scripts/settings/circumstance/templates/expeditions_circumstance_template.lua

local circumstance_templates = {
	spawn_sand_vortex = {
		dialogue_id = "circumstance_vo_exp_vortex",
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_mutator_nurgle",
			description = "loc_expedition_sand_vortex_description",
			display_name = "loc_expedition_sand_vortex_name",
			happening_display_name = "loc_expedition_sand_vortex_name",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
		},
		mutators = {
			"mutator_exp_dummy_sand_vortex",
		},
		mission_overrides = {},
		expedition_events = {
			"spawn_sand_vortex",
		},
	},
	circ_exp_nurgle_flies = {
		dialogue_id = "circumstance_vo_exp_flies",
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_mutator_nurgle",
			description = "loc_expedition_sand_vortex_description",
			display_name = "loc_expedition_sand_vortex_name",
			happening_display_name = "loc_expedition_sand_vortex_name",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
		},
		mutators = {
			"mutator_exp_dummy_nurgle_flies",
		},
		mission_overrides = {},
		expedition_events = {
			"spawn_nurgle_flies",
		},
	},
	expedition_toxic_gas = {
		dialogue_id = "circumstance_vo_exp_toxic_gas",
		theme_tag = "darkness",
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_mutator_nurgle",
			description = "loc_expedition_sand_vortex_description",
			display_name = "loc_expedition_sand_vortex_name",
			happening_display_name = "loc_expedition_sand_vortex_name",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
		},
		mutators = {},
		mission_overrides = {},
		expedition_events = {
			"toxic_gas",
		},
	},
	circ_exp_rotten_armor_darkness = {
		theme_tag = "darkness",
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_mutator_nurgle",
			description = "loc_havoc_common_minion_on_fire_description",
			display_name = "loc_havoc_common_minion_on_fire_name",
			happening_display_name = "loc_happening_nurgle_manifestation",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
		},
		mutators = {
			"mutator_rotten_armor",
			"mutator_exp_rotten_armor_trickle_horde",
			"mutator_only_traitor_guard_faction",
		},
		mission_overrides = {},
	},
	circ_exp_rotten_armor_darkness_lightning = {
		dialogue_id = "circumstance_vo_exp_lightning",
		theme_tag = "darkness",
		wwise_state = "darkness_01",
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_mutator_nurgle",
			description = "loc_havoc_common_minion_on_fire_description",
			display_name = "loc_havoc_common_minion_on_fire_name",
			happening_display_name = "loc_happening_nurgle_manifestation",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
		},
		mutators = {
			"mutator_rotten_armor",
			"mutator_exp_rotten_armor_trickle_horde",
			"mutator_only_traitor_guard_faction",
		},
		expedition_events = {
			"lightning_strikes_looping",
		},
	},
	circ_exp_rotten_armor = {
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_mutator_nurgle",
			description = "loc_havoc_common_minion_on_fire_description",
			display_name = "loc_havoc_common_minion_on_fire_name",
			happening_display_name = "loc_happening_nurgle_manifestation",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
		},
		mutators = {
			"mutator_rotten_armor",
			"mutator_exp_rotten_armor_trickle_horde",
			"mutator_only_traitor_guard_faction",
		},
		mission_overrides = {},
	},
	lightning_storm = {
		dialogue_id = "circumstance_vo_exp_lightning",
		theme_tag = "darkness",
		wwise_state = "darkness_01",
		ui = {
			background = "content/ui/materials/backgrounds/mutators/mutator_lights_out",
			description = "loc_circumstance_darkness_description",
			display_name = "loc_circumstance_darkness_title",
			happening_display_name = "loc_happening_darkness",
			icon = "content/ui/materials/icons/circumstances/darkness_01",
			mission_board_icon = "content/ui/materials/mission_board/circumstances/darkness_01",
		},
		mutators = {
			"mutator_exp_dummy_lightning_storm",
			"mutator_more_witches",
			"mutator_more_encampments",
			"mutator_darkness_los",
		},
		expedition_events = {
			"lightning_strikes_targeted_random_player_looping",
		},
	},
	exp_hunting_grounds = {
		ui = {
			background = "content/ui/materials/backgrounds/mutators/mutators_bg_rotten_armor",
			description = "loc_havoc_rotten_armor_description",
			display_name = "loc_havoc_rotten_armor_name",
			happening_display_name = "loc_happening_nurgle_manifestation",
			icon = "content/ui/materials/icons/circumstances/havoc/havoc_mutator_rotten_armor",
		},
		mutators = {
			"exp_mutator_chaos_hounds",
		},
		mission_overrides = {},
	},
	exp_rotten_armor = {
		ui = {
			background = "content/ui/materials/backgrounds/mutators/mutators_bg_rotten_armor",
			description = "loc_havoc_rotten_armor_description",
			display_name = "loc_havoc_rotten_armor_name",
			happening_display_name = "loc_happening_nurgle_manifestation",
			icon = "content/ui/materials/icons/circumstances/havoc/havoc_mutator_rotten_armor",
		},
		mutators = {
			"exp_mutator_rotten_armor",
		},
		mission_overrides = {},
	},
	exps_dark = {
		dialogue_id = "circumstance_vo_darkness",
		theme_tag = "darkness",
		wwise_state = "darkness_01",
		mutators = {
			"mutator_darkness_los",
		},
	},
	exps_tornado = {
		dialogue_id = "circumstance_vo_exp_vortex",
		mutators = {
			"mutator_exp_dummy_sand_vortex",
		},
		expedition_events = {
			"spawn_sand_vortex",
		},
	},
	exps_storm = {
		dialogue_id = "circumstance_vo_exp_lightning",
		theme_tag = "darkness",
		wwise_state = "darkness_01",
		mutators = {
			"mutator_exp_dummy_lightning_storm",
			"mutator_darkness_los",
		},
		expedition_events = {
			"lightning_strikes_targeted_random_player_looping",
		},
	},
	exps_flies = {
		dialogue_id = "circumstance_vo_exp_flies",
		mutators = {
			"mutator_exp_dummy_nurgle_flies",
		},
		expedition_events = {
			"spawn_nurgle_flies",
		},
	},
	exps_dogs = {
		mutators = {
			"exp_mutator_chaos_hounds",
		},
	},
	exps_rotarm = {
		mutators = {
			"mutator_rotten_armor",
			"mutator_exp_rotten_armor_trickle_horde",
			"mutator_only_traitor_guard_faction",
		},
	},
	exps_blight = {
		mutators = {
			"mutator_corrupted_enemies",
		},
	},
	exps_tornadogs = {
		dialogue_id = "circumstance_vo_exp_vortex",
		mutators = {
			"exp_mutator_chaos_hounds",
			"mutator_exp_dummy_sand_vortex",
		},
		expedition_events = {
			"spawn_sand_vortex",
		},
	},
	exps_tornadark = {
		dialogue_id = "circumstance_vo_exp_vortex",
		theme_tag = "darkness",
		wwise_state = "darkness_01",
		mutators = {
			"mutator_exp_dummy_sand_vortex",
			"mutator_darkness_los",
		},
		expedition_events = {
			"spawn_sand_vortex",
		},
	},
	exps_stormblight = {
		dialogue_id = "circumstance_vo_exp_lightning",
		theme_tag = "darkness",
		wwise_state = "darkness_01",
		mutators = {
			"mutator_exp_dummy_lightning_storm",
			"mutator_darkness_los",
			"mutator_corrupted_enemies",
		},
		expedition_events = {
			"lightning_strikes_targeted_random_player_looping",
		},
	},
	exps_auric = {
		mutators = {
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration_low",
			"mutator_auric_tension_modifier",
		},
	},
	exps_dark_au = {
		dialogue_id = "circumstance_vo_darkness",
		theme_tag = "darkness",
		wwise_state = "darkness_01",
		mutators = {
			"mutator_darkness_los",
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration_low",
			"mutator_auric_tension_modifier",
		},
	},
	exps_tornado_au = {
		dialogue_id = "circumstance_vo_exp_vortex",
		mutators = {
			"mutator_exp_dummy_sand_vortex",
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration_low",
			"mutator_auric_tension_modifier",
		},
		expedition_events = {
			"spawn_sand_vortex",
		},
	},
	exps_storm_au = {
		dialogue_id = "circumstance_vo_exp_lightning",
		theme_tag = "darkness",
		wwise_state = "darkness_01",
		mutators = {
			"mutator_exp_dummy_lightning_storm",
			"mutator_darkness_los",
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration_low",
			"mutator_auric_tension_modifier",
		},
		expedition_events = {
			"lightning_strikes_targeted_random_player_looping",
		},
	},
	exps_flies_au = {
		dialogue_id = "circumstance_vo_exp_flies",
		mutators = {
			"mutator_exp_dummy_nurgle_flies",
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration_low",
			"mutator_auric_tension_modifier",
		},
		expedition_events = {
			"spawn_nurgle_flies",
		},
	},
	exps_dogs_au = {
		mutators = {
			"exp_mutator_chaos_hounds",
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration_low",
			"mutator_auric_tension_modifier",
		},
	},
	exps_rotarm_au = {
		mutators = {
			"mutator_rotten_armor",
			"mutator_exp_rotten_armor_trickle_horde",
			"mutator_only_traitor_guard_faction",
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration_low",
			"mutator_auric_tension_modifier",
		},
	},
	exps_blight_au = {
		mutators = {
			"mutator_corrupted_enemies",
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration_low",
			"mutator_auric_tension_modifier",
		},
	},
	exps_tornadogs_au = {
		dialogue_id = "circumstance_vo_exp_vortex",
		mutators = {
			"exp_mutator_chaos_hounds",
			"mutator_exp_dummy_sand_vortex",
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration_low",
			"mutator_auric_tension_modifier",
		},
		expedition_events = {
			"spawn_sand_vortex",
		},
	},
	exps_tornadark_au = {
		dialogue_id = "circumstance_vo_exp_vortex",
		theme_tag = "darkness",
		wwise_state = "darkness_01",
		mutators = {
			"mutator_exp_dummy_sand_vortex",
			"mutator_darkness_los",
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration_low",
			"mutator_auric_tension_modifier",
		},
		expedition_events = {
			"spawn_sand_vortex",
		},
	},
	exps_stormblight_au = {
		dialogue_id = "circumstance_vo_exp_lightning",
		theme_tag = "darkness",
		wwise_state = "darkness_01",
		mutators = {
			"mutator_exp_dummy_lightning_storm",
			"mutator_darkness_los",
			"mutator_corrupted_enemies",
			"mutator_waves_of_specials",
			"mutator_add_resistance",
			"mutator_increase_terror_event_points",
			"mutator_reduced_ramp_duration_low",
			"mutator_auric_tension_modifier",
		},
		expedition_events = {
			"lightning_strikes_targeted_random_player_looping",
		},
	},
}

return circumstance_templates
