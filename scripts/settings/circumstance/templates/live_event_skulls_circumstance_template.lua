﻿-- chunkname: @scripts/settings/circumstance/templates/live_event_skulls_circumstance_template.lua

local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local circumstance_templates = {}

circumstance_templates.skulls_event_01 = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_nurgle_totem",
		"mutator_drop_pickup_on_death",
	},
	ui = {
		description = "loc_circumstance_skulls_event_01_01_description",
		display_name = "loc_circumstance_skulls_event_01_01_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
	mission_overrides = MissionOverrides.add_skulls_pickup,
}
circumstance_templates.skulls_event_01_02 = {
	dialogue_id = "circumstance_vo_hunting_grounds",
	theme_tag = "default",
	wwise_event_init = "wwise/events/world/play_hunting_grounds_occasionals",
	wwise_event_stop = "wwise/events/world/stop_hunting_grounds_occasionals",
	wwise_state = "hunting_grounds_01",
	mutators = {
		"mutator_chaos_hounds",
		"mutator_add_resistance",
		"mutator_nurgle_totem",
		"mutator_drop_pickup_on_death",
	},
	ui = {
		description = "loc_circumstance_skulls_event_01_02_description",
		display_name = "loc_circumstance_skulls_event_01_02_title",
		happening_display_name = "loc_happening_hunting_grounds",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
	mission_overrides = MissionOverrides.add_skulls_pickup,
}
circumstance_templates.skulls_event_01_03 = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_add_resistance",
		"mutator_nurgle_totem",
		"mutator_drop_pickup_on_death",
	},
	ui = {
		description = "loc_circumstance_skulls_event_01_03_description",
		display_name = "loc_circumstance_skulls_event_01_03_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
	mission_overrides = MissionOverrides.add_skulls_pickup,
}
circumstance_templates.skulls_event_01_04 = {
	dialogue_id = "circumstance_vo_darkness",
	theme_tag = "darkness",
	wwise_state = "darkness_01",
	mutators = {
		"mutator_more_witches",
		"mutator_more_encampments",
		"mutator_add_resistance",
		"mutator_darkness_los",
		"mutator_nurgle_totem",
		"mutator_drop_pickup_on_death",
	},
	ui = {
		description = "loc_circumstance_skulls_event_01_04_description",
		display_name = "loc_circumstance_skulls_event_01_04_title",
		happening_display_name = "loc_happening_darkness",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
	mission_overrides = MissionOverrides.add_skulls_pickup,
}
circumstance_templates.skulls_event_01_05 = {
	dialogue_id = "circumstance_vo_toxic_gas",
	theme_tag = "toxic_gas",
	wwise_state = "ventilation_purge_01",
	mutators = {
		"mutator_toxic_gas_volumes",
		"mutator_add_resistance",
		"mutator_nurgle_totem",
		"mutator_drop_pickup_on_death",
	},
	ui = {
		description = "loc_circumstance_skulls_event_01_05_description",
		display_name = "loc_circumstance_skulls_event_01_05_title",
		happening_display_name = "loc_happening_ventilation_purge",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
	mission_overrides = MissionOverrides.merge("add_skulls_pickup", "more_corruption_syringes"),
}
circumstance_templates.skulls_event_01_06 = {
	dialogue_id = "circumstance_vo_ventilation_purge",
	theme_tag = "ventilation_purge",
	wwise_state = "ventilation_purge_01",
	mutators = {
		"mutator_snipers",
		"mutator_add_resistance",
		"mutator_ventilation_purge_los",
		"mutator_nurgle_totem",
		"mutator_drop_pickup_on_death",
	},
	ui = {
		description = "loc_circumstance_skulls_event_01_06_description",
		display_name = "loc_circumstance_skulls_event_01_06_title",
		happening_display_name = "loc_happening_ventilation_purge",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
	mission_overrides = MissionOverrides.add_skulls_pickup,
}
circumstance_templates.skulls_event_01_07 = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_waves_of_specials",
		"mutator_add_resistance",
		"mutator_increase_terror_event_points",
		"mutator_reduced_ramp_duration_low",
		"mutator_auric_tension_modifier",
		"mutator_nurgle_totem",
		"mutator_drop_pickup_on_death",
	},
	ui = {
		description = "loc_circumstance_skulls_event_01_07_description",
		display_name = "loc_circumstance_skulls_event_01_07_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
	},
	mission_overrides = MissionOverrides.add_skulls_pickup,
}

return circumstance_templates
