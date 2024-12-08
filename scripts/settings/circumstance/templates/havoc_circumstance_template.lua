-- chunkname: @scripts/settings/circumstance/templates/havoc_circumstance_template.lua

local circumstance_templates = {
	common_minion_on_fire = {
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_mutator_nurgle",
			description = "loc_havoc_common_minion_on_fire_description",
			display_name = "loc_havoc_common_minion_on_fire_name",
			happening_display_name = "loc_happening_nurgle_manifestation",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
		},
		mutators = {
			"mutator_common_minions_on_fire",
		},
		mission_overrides = {},
	},
	mutator_havoc_enemies_corrupted = {
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_mutator_nurgle",
			description = "loc_havoc_enemies_corrupted_description",
			display_name = "loc_havoc_enemies_corrupted_name",
			happening_display_name = "loc_happening_nurgle_manifestation",
			icon = "content/ui/materials/icons/circumstances/havoc/havoc_mutator_nurgle",
		},
		mutators = {
			"mutator_corrupted_enemies",
		},
		mission_overrides = {},
	},
	mutator_havoc_enemies_parasite_headshot = {
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_mutator_parasite",
			description = "loc_havoc_enemies_parasite_headshot_description",
			display_name = "loc_havoc_enemies_parasite_headshot_name",
			happening_display_name = "loc_happening_nurgle_manifestation",
			icon = "content/ui/materials/icons/circumstances/havoc/havoc_mutator_parasite",
		},
		mutators = {
			"mutator_headshot_parasite_enemies",
		},
		mission_overrides = {},
	},
	mutator_havoc_duplicating_enemies = {
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_mutator_nurgle",
			description = "loc_circumstance_nurgle_manifestation_description",
			display_name = "loc_circumstance_nurgle_manifestation_title",
			happening_display_name = "loc_happening_nurgle_manifestation",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
		},
		mutators = {
			"mutator_duplicating_enemies",
		},
		mission_overrides = {},
	},
	bolstering_minions_01 = {
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_mutator_nurgle",
			description = "loc_circumstance_nurgle_manifestation_description",
			display_name = "loc_circumstance_nurgle_manifestation_title",
			happening_display_name = "loc_happening_nurgle_manifestation",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
		},
		mutators = {
			"mutator_bolstering_minions",
		},
		mission_overrides = {},
	},
	mutator_havoc_armored_infected = {
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_mutator_moebian21st",
			description = "loc_havoc_armored_infected_description",
			display_name = "loc_havoc_armored_infected_name",
			happening_display_name = "loc_happening_nurgle_manifestation",
			icon = "content/ui/materials/icons/circumstances/havoc/havoc_mutator_moebian21st",
		},
		mutators = {
			"mutator_havoc_armored_infected",
		},
		mission_overrides = {},
	},
	mutator_havoc_tougher_skin = {
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_mutator_skin",
			description = "loc_havoc_tougher_skin_description",
			display_name = "loc_havoc_tougher_skin_name",
			happening_display_name = "loc_happening_nurgle_manifestation",
			icon = "content/ui/materials/icons/circumstances/havoc/havoc_mutator_skin",
		},
		mutators = {
			"mutator_tough_skin_enemies",
		},
		mission_overrides = {},
	},
	mutator_havoc_sticky_poxbursters = {
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_mutator_nurgle",
			description = "loc_havoc_sticky_poxbursters_description",
			display_name = "loc_havoc_sticky_poxbursters_name",
			happening_display_name = "loc_happening_nurgle_manifestation",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
		},
		mutators = {
			"mutator_havoc_sticky_poxburster",
			"mutator_poxwalker_bombers",
		},
		mission_overrides = {},
	},
	mutator_havoc_thorny_armor = {
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_mutator_nurgle",
			description = "loc_havoc_thorny_armor_description",
			display_name = "loc_havoc_thorny_armor_name",
			happening_display_name = "loc_happening_nurgle_manifestation",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
		},
		mutators = {
			"mutator_havoc_thorny_armor",
		},
		mission_overrides = {},
	},
	mutator_increased_difficulty = {
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_emperor_01",
			description = "loc_havoc_increased_difficulty_description",
			display_name = "loc_havoc_increased_difficulty_name",
			happening_display_name = "loc_happening_nurgle_manifestation",
			icon = "content/ui/materials/icons/circumstances/havoc/havoc_mutator_fading_light_1",
		},
		mutators = {
			"mutator_auric_tension_modifier",
			"mutator_enable_auric",
			"havoc_mutator_more_captains_01",
			"havoc_mutator_more_hordes_01",
		},
		mission_overrides = {},
	},
	mutator_highest_difficulty = {
		ui = {
			background = "content/ui/materials/backgrounds/mutators/havoc_emperor_02",
			description = "loc_havoc_highest_difficulty_description",
			display_name = "loc_havoc_highest_difficulty_name",
			happening_display_name = "loc_happening_nurgle_manifestation",
			icon = "content/ui/materials/icons/circumstances/havoc/havoc_mutator_fading_light_2",
		},
		mutators = {
			"mutator_always_allow_all_spawn_types",
			"mutator_enable_auric",
			"mutator_auric_tension_modifier",
			"mutator_add_resistance",
			"havoc_mutator_more_captains_02",
			"havoc_mutator_more_hordes_02",
			"havoc_higher_stagger_thresholds",
			"mutator_decreased_horde_pacing_stinger",
		},
		mission_overrides = {},
	},
}

return circumstance_templates
