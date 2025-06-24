-- chunkname: @scripts/settings/circumstance/templates/player_journey_circumstance_template.lua

local circumstance_templates = {}

circumstance_templates.player_journey_01 = {
	minion_health_modifier = -0.3,
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_player_journey_01_replacement",
		"mutator_no_monsters",
		"mutator_no_witches",
		"mutator_only_traitor_guard_faction",
	},
	ui = {
		description = "loc_circumstance_player_journey_01_description",
		display_name = "loc_circumstance_player_journey_01_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}
circumstance_templates.player_journey_02 = {
	minion_health_modifier = -0.2,
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_player_journey_02_replacement",
		"mutator_no_monsters",
		"mutator_no_witches",
		"mutator_only_traitor_guard_faction",
	},
	ui = {
		description = "loc_circumstance_player_journey_02_description",
		display_name = "loc_circumstance_player_journey_02_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}
circumstance_templates.player_journey_03 = {
	minion_health_modifier = -0.1,
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_player_journey_03_replacement",
		"mutator_no_monsters",
		"mutator_no_witches",
		"mutator_only_traitor_guard_faction",
	},
	ui = {
		description = "loc_circumstance_player_journey_03_description",
		display_name = "loc_circumstance_player_journey_03_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}
circumstance_templates.player_journey_04 = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_player_journey_04_replacement",
		"mutator_no_monsters",
		"mutator_no_witches",
		"mutator_only_traitor_guard_faction",
	},
	ui = {
		description = "loc_circumstance_player_journey_04_description",
		display_name = "loc_circumstance_player_journey_04_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}
circumstance_templates.player_journey_05 = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_player_journey_05_replacement",
		"mutator_no_witches",
		"mutator_only_cultist_faction",
	},
	ui = {
		description = "loc_circumstance_player_journey_05_description",
		display_name = "loc_circumstance_player_journey_05_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}
circumstance_templates.player_journey_06_A = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_player_journey_06_A_replacement",
		"mutator_no_witches",
		"mutator_only_cultist_faction",
	},
	ui = {
		description = "loc_circumstance_player_journey_06_A_description",
		display_name = "loc_circumstance_player_journey_06_A_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}
circumstance_templates.player_journey_07_A = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_player_journey_07_A_replacement",
		"mutator_no_witches",
		"mutator_only_cultist_faction",
	},
	ui = {
		description = "loc_circumstance_player_journey_07_A_description",
		display_name = "loc_circumstance_player_journey_07_A_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}
circumstance_templates.player_journey_06_B = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_player_journey_06_B_replacement",
		"mutator_no_witches",
		"mutator_only_cultist_faction",
	},
	ui = {
		description = "loc_circumstance_player_journey_06_B_description",
		display_name = "loc_circumstance_player_journey_06_B_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}
circumstance_templates.player_journey_07_B = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_player_journey_07_B_replacement",
		"mutator_no_witches",
	},
	ui = {
		description = "loc_circumstance_player_journey_07_B_description",
		display_name = "loc_circumstance_player_journey_07_B_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}
circumstance_templates.player_journey_08 = {
	theme_tag = "default",
	wwise_state = "None",
	vo_units = {
		"renegade_twin_captain",
		"renegade_twin_captain_two",
	},
	mutators = {
		"mutator_player_journey_08_replacement",
		"mutator_no_witches",
		"mutator_single_twin",
	},
	ui = {
		description = "loc_circumstance_player_journey_08_description",
		display_name = "loc_circumstance_player_journey_08_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}
circumstance_templates.player_journey_09 = {
	theme_tag = "default",
	wwise_state = "None",
	vo_units = {
		"renegade_twin_captain",
		"renegade_twin_captain_two",
	},
	mutators = {
		"mutator_player_journey_09_replacement",
		"mutator_no_witches",
		"mutator_single_twin",
	},
	ui = {
		description = "loc_circumstance_player_journey_09_description",
		display_name = "loc_circumstance_player_journey_09_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}
circumstance_templates.player_journey_010 = {
	theme_tag = "default",
	wwise_state = "None",
	vo_units = {
		"renegade_twin_captain",
		"renegade_twin_captain_two",
	},
	mutators = {
		"mutator_toxic_gas_twins",
		"mutator_no_hordes",
		"mutator_only_none_roamer_packs",
		"mutator_low_roamer_amount",
		"mutator_no_monsters",
		"mutator_no_witches",
		"mutator_no_boss_patrols",
		"mutator_only_traitor_guard_faction",
	},
	ui = {
		description = "loc_circumstance_player_journey_010_description",
		display_name = "loc_circumstance_player_journey_010_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}
circumstance_templates.player_journey_011_A = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_player_journey_011_A_replacement",
		"mutator_no_witches",
	},
	ui = {
		description = "loc_circumstance_player_journey_011_A_description",
		display_name = "loc_circumstance_player_journey_011_A_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}
circumstance_templates.player_journey_012_A = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_no_witches",
	},
	ui = {
		description = "loc_circumstance_player_journey_012_A_description",
		display_name = "loc_circumstance_player_journey_012_A_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}
circumstance_templates.player_journey_013_A = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_no_witches",
	},
	ui = {
		description = "loc_circumstance_player_journey_013_A_description",
		display_name = "loc_circumstance_player_journey_013_A_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}
circumstance_templates.player_journey_011_B = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_no_witches",
	},
	ui = {
		description = "loc_circumstance_player_journey_011_B_description",
		display_name = "loc_circumstance_player_journey_011_B_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}
circumstance_templates.player_journey_014 = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_no_witches",
	},
	ui = {
		description = "loc_circumstance_player_journey_014_description",
		display_name = "loc_circumstance_player_journey_014_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
}

return circumstance_templates
