-- chunkname: @scripts/settings/circumstance/templates/ember_circumstance_template.lua

local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local circumstance_templates = {}

circumstance_templates.ember_01 = {
	dialogue_id = "circumstance_vo_ember",
	theme_tag = "ember",
	wwise_state = "ember_01",
	ui = {
		description = "loc_circumstance_ember_description",
		display_name = "loc_circumstance_ember_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
	mutators = {
		"mutator_renegade_flamer_none_packs",
		"mutator_only_traitor_guard_faction",
		"mutator_renegade_grenadier",
	},
	mission_overrides = MissionOverrides.all_fire_barrels,
}
circumstance_templates.ember_01_hunt_grou = {
	dialogue_id = "circumstance_vo_ember",
	theme_tag = "ember",
	wwise_event_init = "wwise/events/world/play_hunting_grounds_occasionals",
	wwise_event_stop = "wwise/events/world/stop_hunting_grounds_occasionals",
	wwise_state = "ember_01",
	ui = {
		description = "loc_circumstance_ember_hunting_grounds_description",
		display_name = "loc_circumstance_ember_hunting_grounds_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
	mutators = {
		"mutator_renegade_flamer_none_packs",
		"mutator_only_traitor_guard_faction",
		"mutator_renegade_grenadier",
		"mutator_chaos_hounds",
	},
	mission_overrides = MissionOverrides.all_fire_barrels,
}
circumstance_templates.ember_01_waves_spec = {
	dialogue_id = "circumstance_vo_ember",
	theme_tag = "ember",
	wwise_state = "ember_01",
	ui = {
		description = "loc_circumstance_ember_waves_of_specials_description",
		display_name = "loc_circumstance_ember_waves_of_specials_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
	mutators = {
		"mutator_renegade_flamer_none_packs",
		"mutator_only_traitor_guard_faction",
		"mutator_renegade_grenadier",
		"mutator_waves_of_specials",
		"mutator_increase_terror_event_points",
		"mutator_auric_tension_modifier",
		"mutator_reduced_ramp_duration_low",
	},
	mission_overrides = MissionOverrides.all_fire_barrels,
}
circumstance_templates.ember_01_more_res = {
	dialogue_id = "circumstance_vo_ember",
	theme_tag = "ember",
	wwise_state = "ember_01",
	ui = {
		description = "loc_circumstance_ember_more_resistance_description",
		display_name = "loc_circumstance_ember_more_resistance_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
	mutators = {
		"mutator_renegade_flamer_none_packs",
		"mutator_only_traitor_guard_faction",
		"mutator_renegade_grenadier",
		"mutator_add_resistance",
	},
	mission_overrides = MissionOverrides.all_fire_barrels,
}

return circumstance_templates
