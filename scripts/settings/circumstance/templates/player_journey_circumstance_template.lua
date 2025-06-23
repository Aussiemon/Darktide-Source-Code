-- chunkname: @scripts/settings/circumstance/templates/player_journey_circumstance_template.lua

local circumstance_templates = {}

circumstance_templates.player_journey_01 = {
	minion_health_modifier = -0.3,
	wwise_state = "None",
	theme_tag = "default",
	mutators = {
		"mutator_player_journey_01_replacement",
		"mutator_no_monsters",
		"mutator_no_witches",
		"mutator_only_traitor_guard_faction"
	},
	ui = {
		description = "loc_circumstance_player_journey_01_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_01_title"
	}
}
circumstance_templates.player_journey_02 = {
	minion_health_modifier = -0.2,
	wwise_state = "None",
	theme_tag = "default",
	mutators = {
		"mutator_player_journey_02_replacement",
		"mutator_no_monsters",
		"mutator_no_witches",
		"mutator_only_traitor_guard_faction"
	},
	ui = {
		description = "loc_circumstance_player_journey_02_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_02_title"
	}
}
circumstance_templates.player_journey_03 = {
	minion_health_modifier = -0.1,
	wwise_state = "None",
	theme_tag = "default",
	mutators = {
		"mutator_player_journey_03_replacement",
		"mutator_no_monsters",
		"mutator_no_witches",
		"mutator_only_traitor_guard_faction"
	},
	ui = {
		description = "loc_circumstance_player_journey_03_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_03_title"
	}
}
circumstance_templates.player_journey_04 = {
	wwise_state = "None",
	theme_tag = "default",
	mutators = {
		"mutator_player_journey_04_replacement",
		"mutator_no_monsters",
		"mutator_no_witches",
		"mutator_only_traitor_guard_faction"
	},
	ui = {
		description = "loc_circumstance_player_journey_04_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_04_title"
	}
}
circumstance_templates.player_journey_05 = {
	wwise_state = "None",
	theme_tag = "default",
	mutators = {
		"mutator_player_journey_05_replacement",
		"mutator_no_witches",
		"mutator_only_cultist_faction"
	},
	ui = {
		description = "loc_circumstance_player_journey_05_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_05_title"
	}
}
circumstance_templates.player_journey_06_A = {
	wwise_state = "None",
	theme_tag = "default",
	mutators = {
		"mutator_player_journey_06_A_replacement",
		"mutator_no_witches",
		"mutator_only_cultist_faction"
	},
	ui = {
		description = "loc_circumstance_player_journey_06_A_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_06_A_title"
	}
}
circumstance_templates.player_journey_07_A = {
	wwise_state = "None",
	theme_tag = "default",
	mutators = {
		"mutator_player_journey_07_A_replacement",
		"mutator_no_witches",
		"mutator_only_cultist_faction"
	},
	ui = {
		description = "loc_circumstance_player_journey_07_A_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_07_A_title"
	}
}
circumstance_templates.player_journey_06_B = {
	wwise_state = "None",
	theme_tag = "default",
	mutators = {
		"mutator_player_journey_06_B_replacement",
		"mutator_no_witches",
		"mutator_only_cultist_faction"
	},
	ui = {
		description = "loc_circumstance_player_journey_06_B_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_06_B_title"
	}
}
circumstance_templates.player_journey_07_B = {
	wwise_state = "None",
	theme_tag = "default",
	mutators = {
		"mutator_player_journey_07_B_replacement",
		"mutator_no_witches"
	},
	ui = {
		description = "loc_circumstance_player_journey_07_B_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_07_B_title"
	}
}
circumstance_templates.player_journey_08 = {
	wwise_state = "None",
	theme_tag = "default",
	vo_units = {
		"renegade_twin_captain",
		"renegade_twin_captain_two"
	},
	mutators = {
		"mutator_player_journey_08_replacement",
		"mutator_no_witches",
		"mutator_single_twin"
	},
	ui = {
		description = "loc_circumstance_player_journey_08_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_08_title"
	}
}
circumstance_templates.player_journey_09 = {
	wwise_state = "None",
	theme_tag = "default",
	vo_units = {
		"renegade_twin_captain",
		"renegade_twin_captain_two"
	},
	mutators = {
		"mutator_player_journey_09_replacement",
		"mutator_no_witches",
		"mutator_single_twin"
	},
	ui = {
		description = "loc_circumstance_player_journey_09_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_09_title"
	}
}
circumstance_templates.player_journey_010 = {
	wwise_state = "None",
	theme_tag = "default",
	vo_units = {
		"renegade_twin_captain",
		"renegade_twin_captain_two"
	},
	mutators = {
		"mutator_toxic_gas_twins",
		"mutator_no_hordes",
		"mutator_only_none_roamer_packs",
		"mutator_low_roamer_amount",
		"mutator_no_monsters",
		"mutator_no_witches",
		"mutator_no_boss_patrols",
		"mutator_only_traitor_guard_faction"
	},
	ui = {
		description = "loc_circumstance_player_journey_010_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_010_title"
	}
}
circumstance_templates.player_journey_011_A = {
	wwise_state = "None",
	theme_tag = "default",
	mutators = {
		"mutator_player_journey_011_A_replacement",
		"mutator_no_witches"
	},
	ui = {
		description = "loc_circumstance_player_journey_011_A_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_011_A_title"
	}
}
circumstance_templates.player_journey_012_A = {
	wwise_state = "None",
	theme_tag = "default",
	mutators = {
		"mutator_no_witches"
	},
	ui = {
		description = "loc_circumstance_player_journey_012_A_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_012_A_title"
	}
}
circumstance_templates.player_journey_013_A = {
	wwise_state = "None",
	theme_tag = "default",
	mutators = {
		"mutator_no_witches"
	},
	ui = {
		description = "loc_circumstance_player_journey_013_A_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_013_A_title"
	}
}
circumstance_templates.player_journey_011_B = {
	wwise_state = "None",
	theme_tag = "default",
	mutators = {
		"mutator_no_witches"
	},
	ui = {
		description = "loc_circumstance_player_journey_011_B_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_011_B_title"
	}
}
circumstance_templates.player_journey_014 = {
	wwise_state = "None",
	theme_tag = "default",
	mutators = {
		"mutator_no_witches"
	},
	ui = {
		description = "loc_circumstance_player_journey_014_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_player_journey_014_title"
	}
}

return circumstance_templates
