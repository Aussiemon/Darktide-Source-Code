-- chunkname: @scripts/settings/circumstance/templates/base_live_event_template.lua

local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local BaseLiveEventTemplate = {}
local default_ui = {
	description = false,
	display_name = false,
	icon = "content/ui/materials/icons/circumstances/live_event_01",
	mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
}
local default_circumstance = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {},
	ui = default_ui,
}

BaseLiveEventTemplate["<ID>"] = table.clone(default_circumstance)
BaseLiveEventTemplate["<ID>_hunt_grou"] = table.add_missing({
	dialogue_id = "circumstance_vo_hunting_grounds",
	wwise_event_init = "wwise/events/world/play_hunting_grounds_occasionals",
	wwise_event_stop = "wwise/events/world/stop_hunting_grounds_occasionals",
	wwise_state = "hunting_grounds_01",
	mutators = {
		"mutator_chaos_hounds",
	},
}, table.clone(default_circumstance))
BaseLiveEventTemplate["<ID>_more_res"] = table.add_missing({
	mutators = {
		"mutator_add_resistance",
	},
}, table.clone(default_circumstance))
BaseLiveEventTemplate["<ID>_darkness"] = table.add_missing({
	dialogue_id = "circumstance_vo_darkness",
	theme_tag = "darkness",
	wwise_state = "darkness_01",
	mutators = {
		"mutator_more_witches",
		"mutator_more_encampments",
		"mutator_add_resistance",
		"mutator_darkness_los",
	},
}, table.clone(default_circumstance))
BaseLiveEventTemplate["<ID>_gas"] = table.add_missing({
	dialogue_id = "circumstance_vo_toxic_gas",
	theme_tag = "toxic_gas",
	wwise_state = "ventilation_purge_01",
	mutators = {
		"mutator_toxic_gas_volumes",
	},
	mission_overrides = MissionOverrides.more_corruption_syringes,
}, table.clone(default_circumstance))
BaseLiveEventTemplate["<ID>_waves_spec"] = table.add_missing({
	mutators = {
		"mutator_waves_of_specials",
		"mutator_increase_terror_event_points",
		"mutator_reduced_ramp_duration_low",
		"mutator_auric_tension_modifier",
	},
}, table.clone(default_circumstance))
BaseLiveEventTemplate["<ID>_ventilation"] = table.add_missing({
	dialogue_id = "circumstance_vo_ventilation_purge",
	theme_tag = "ventilation_purge",
	wwise_state = "ventilation_purge_01",
	mutators = {
		"mutator_snipers",
		"mutator_ventilation_purge_los",
	},
}, table.clone(default_circumstance))

return BaseLiveEventTemplate
