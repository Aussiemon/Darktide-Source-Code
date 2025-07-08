-- chunkname: @scripts/settings/circumstance/templates/live_event_rotten_armor_circumstance_template.lua

local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local circumstance_templates = {}

circumstance_templates.rotten_armor = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_only_traitor_guard_faction",
		"mutator_rotten_armor",
		"mutator_live_rotten_armor_trickle_horde",
	},
	ui = {
		description = "loc_circumstance_live_rotten_armor_description",
		display_name = "loc_circumstance_live_rotten_armor_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
}
circumstance_templates.rotten_armor_hunt_grou = {
	dialogue_id = "circumstance_vo_hunting_grounds",
	theme_tag = "default",
	wwise_event_init = "wwise/events/world/play_hunting_grounds_occasionals",
	wwise_event_stop = "wwise/events/world/stop_hunting_grounds_occasionals",
	wwise_state = "hunting_grounds_01",
	mutators = {
		"mutator_chaos_hounds",
		"mutator_add_resistance",
		"mutator_only_traitor_guard_faction",
		"mutator_rotten_armor",
		"mutator_live_rotten_armor_trickle_horde",
	},
	ui = {
		description = "loc_circumstance_live_rotten_armor_hunt_grou_description",
		display_name = "loc_circumstance_live_rotten_armor_hunt_grou_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
}
circumstance_templates.rotten_armor_more_res = {
	theme_tag = "default",
	wwise_state = "None",
	ui = {
		description = "loc_circumstance_live_rotten_armor_more_res_description",
		display_name = "loc_circumstance_live_rotten_armor_more_res_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
	mutators = {
		"mutator_add_resistance",
		"mutator_only_traitor_guard_faction",
		"mutator_rotten_armor",
		"mutator_live_rotten_armor_trickle_horde",
	},
}
circumstance_templates.rotten_armor_darkness = {
	dialogue_id = "circumstance_vo_darkness",
	theme_tag = "darkness",
	wwise_state = "darkness_01",
	ui = {
		description = "loc_circumstance_live_rotten_armor_darkness_description",
		display_name = "loc_circumstance_live_rotten_armor_darkness_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
	mutators = {
		"mutator_more_witches",
		"mutator_more_encampments",
		"mutator_add_resistance",
		"mutator_darkness_los",
		"mutator_only_traitor_guard_faction",
		"mutator_rotten_armor",
		"mutator_live_rotten_armor_trickle_horde",
	},
}
circumstance_templates.rotten_armor_gas = {
	dialogue_id = "circumstance_vo_toxic_gas",
	theme_tag = "toxic_gas",
	wwise_state = "ventilation_purge_01",
	mutators = {
		"mutator_toxic_gas_volumes",
		"mutator_add_resistance",
		"mutator_only_traitor_guard_faction",
		"mutator_rotten_armor",
		"mutator_live_rotten_armor_trickle_horde",
	},
	ui = {
		description = "loc_circumstance_live_rotten_armor_gas_description",
		display_name = "loc_circumstance_live_rotten_armor_gas_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
	mission_overrides = MissionOverrides.more_corruption_syringes,
}
circumstance_templates.rotten_armor_waves_spec = {
	theme_tag = "default",
	wwise_state = "None",
	ui = {
		description = "loc_circumstance_live_rotten_armor_waves_spec_description",
		display_name = "loc_circumstance_live_rotten_armor_waves_spec_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
	mutators = {
		"mutator_waves_of_specials",
		"mutator_add_resistance",
		"mutator_increase_terror_event_points",
		"mutator_reduced_ramp_duration_low",
		"mutator_auric_tension_modifier",
		"mutator_only_traitor_guard_faction",
		"mutator_rotten_armor",
		"mutator_live_rotten_armor_trickle_horde",
	},
}
circumstance_templates.rotten_armor_ventilation = {
	dialogue_id = "circumstance_vo_ventilation_purge",
	theme_tag = "ventilation_purge",
	wwise_state = "ventilation_purge_01",
	ui = {
		description = "loc_circumstance_live_rotten_armor_ventilation_description",
		display_name = "loc_circumstance_live_rotten_armor_ventilation_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
	mutators = {
		"mutator_snipers",
		"mutator_ventilation_purge_los",
		"mutator_add_resistance",
		"mutator_only_traitor_guard_faction",
		"mutator_rotten_armor",
		"mutator_live_rotten_armor_trickle_horde",
	},
}

return circumstance_templates
