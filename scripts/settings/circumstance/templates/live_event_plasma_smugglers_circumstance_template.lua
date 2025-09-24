-- chunkname: @scripts/settings/circumstance/templates/live_event_plasma_smugglers_circumstance_template.lua

local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local circumstance_templates = {}

circumstance_templates.plasma_smugglers_default = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_attack_selection_template_override_plasma",
		"mutator_only_traitor_guard_faction",
		"mutator_plasma_smuggler_groups",
		"mutator_live_event_plasma_gunner_replacement",
	},
	ui = {
		background = "content/ui/materials/backgrounds/mutators/mutators_bg_default",
		description = "loc_circumstance_plasma_smugglers_default_description",
		display_name = "loc_circumstance_plasma_smugglers_default_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
}
circumstance_templates.plasma_smugglers_hunting_grounds = {
	dialogue_id = "circumstance_vo_hunting_grounds",
	theme_tag = "default",
	wwise_event_init = "wwise/events/world/play_hunting_grounds_occasionals",
	wwise_event_stop = "wwise/events/world/stop_hunting_grounds_occasionals",
	wwise_state = "hunting_grounds_01",
	mutators = {
		"mutator_chaos_hounds",
		"mutator_add_resistance",
		"mutator_attack_selection_template_override_plasma",
		"mutator_only_traitor_guard_faction",
		"mutator_plasma_smuggler_groups",
		"mutator_live_event_plasma_gunner_replacement",
	},
	ui = {
		background = "content/ui/materials/backgrounds/mutators/mutators_bg_default",
		description = "loc_circumstance_plasma_smugglers_hunting_grounds_description",
		display_name = "loc_circumstance_plasma_smugglers_hunting_grounds_title",
		happening_display_name = "loc_happening_hunting_grounds",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
}
circumstance_templates.plasma_smugglers_increased_resistance = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_add_resistance",
		"mutator_attack_selection_template_override_plasma",
		"mutator_only_traitor_guard_faction",
		"mutator_plasma_smuggler_groups",
		"mutator_live_event_plasma_gunner_replacement",
	},
	ui = {
		background = "content/ui/materials/backgrounds/mutators/mutators_bg_default",
		description = "loc_circumstance_plasma_smugglers_increased_resistance_description",
		display_name = "loc_circumstance_plasma_smugglers_increased_resistance_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
}
circumstance_templates.plasma_smugglers_darkness = {
	dialogue_id = "circumstance_vo_darkness",
	theme_tag = "darkness",
	wwise_state = "darkness_01",
	mutators = {
		"mutator_more_witches",
		"mutator_more_encampments",
		"mutator_add_resistance",
		"mutator_darkness_los",
		"mutator_attack_selection_template_override_plasma",
		"mutator_only_traitor_guard_faction",
		"mutator_plasma_smuggler_groups",
		"mutator_live_event_plasma_gunner_replacement",
	},
	ui = {
		background = "content/ui/materials/backgrounds/mutators/mutators_bg_default",
		description = "loc_circumstance_plasma_smugglers_darkness_description",
		display_name = "loc_circumstance_plasma_smugglers_darkness_title",
		happening_display_name = "loc_happening_darkness",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
}
circumstance_templates.plasma_smugglers_toxic_gas = {
	dialogue_id = "circumstance_vo_toxic_gas",
	theme_tag = "toxic_gas",
	wwise_state = "ventilation_purge_01",
	mutators = {
		"mutator_toxic_gas_volumes",
		"mutator_add_resistance",
		"mutator_attack_selection_template_override_plasma",
		"mutator_only_traitor_guard_faction",
		"mutator_plasma_smuggler_groups",
		"mutator_live_event_plasma_gunner_replacement",
	},
	ui = {
		background = "content/ui/materials/backgrounds/mutators/mutators_bg_default",
		description = "loc_circumstance_plasma_smugglers_toxic_gas_description",
		display_name = "loc_circumstance_plasma_smugglers_toxic_gas_title",
		happening_display_name = "loc_happening_ventilation_purge",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
	mission_overrides = MissionOverrides.more_corruption_syringes,
}
circumstance_templates.plasma_smugglers_ventilation = {
	dialogue_id = "circumstance_vo_ventilation_purge",
	theme_tag = "ventilation_purge",
	wwise_state = "ventilation_purge_01",
	mutators = {
		"mutator_snipers",
		"mutator_add_resistance",
		"mutator_ventilation_purge_los",
		"mutator_attack_selection_template_override_plasma",
		"mutator_only_traitor_guard_faction",
		"mutator_plasma_smuggler_groups",
		"mutator_live_event_plasma_gunner_replacement",
	},
	ui = {
		background = "content/ui/materials/backgrounds/mutators/mutators_bg_default",
		description = "loc_circumstance_plasma_smugglers_ventilation_description",
		display_name = "loc_circumstance_plasma_smugglers_ventilation_title",
		happening_display_name = "loc_happening_ventilation_purge",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
}
circumstance_templates.plasma_smugglers_waves_of_specials = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_waves_of_specials",
		"mutator_add_resistance",
		"mutator_increase_terror_event_points",
		"mutator_reduced_ramp_duration_low",
		"mutator_auric_tension_modifier",
		"mutator_attack_selection_template_override_plasma",
		"mutator_only_traitor_guard_faction",
		"mutator_plasma_smuggler_groups",
		"mutator_live_event_plasma_gunner_replacement",
	},
	ui = {
		background = "content/ui/materials/backgrounds/mutators/mutators_bg_default",
		description = "loc_circumstance_plasma_smugglers_waves_of_specials_description",
		display_name = "loc_circumstance_plasma_smugglers_waves_of_specials_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
}

return circumstance_templates
