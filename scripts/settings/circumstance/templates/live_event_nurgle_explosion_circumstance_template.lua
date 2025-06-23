﻿-- chunkname: @scripts/settings/circumstance/templates/live_event_nurgle_explosion_circumstance_template.lua

local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local circumstance_templates = {}

circumstance_templates.nurgle_explosion_01 = {
	wwise_state = "None",
	theme_tag = "default",
	mutators = {
		"mutator_maelstrom_mutated_poxwalker",
		"mutator_live_event_only_beast",
		"mutator_headshot_parasite_enemies"
	},
	ui = {
		description = "loc_circumstance_nurgle_explosion_01_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_nurgle_explosion_01_title",
		happening_display_name = "loc_happening_assault"
	}
}
circumstance_templates.nurgle_explosion_02 = {
	dialogue_id = "circumstance_vo_hunting_grounds",
	wwise_event_stop = "wwise/events/world/stop_hunting_grounds_occasionals",
	wwise_event_init = "wwise/events/world/play_hunting_grounds_occasionals",
	theme_tag = "default",
	wwise_state = "hunting_grounds_01",
	mutators = {
		"mutator_chaos_hounds",
		"mutator_add_resistance",
		"mutator_maelstrom_mutated_poxwalker",
		"mutator_live_event_only_beast",
		"mutator_headshot_parasite_enemies"
	},
	ui = {
		description = "loc_circumstance_nurgle_explosion_02_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_nurgle_explosion_02_title",
		happening_display_name = "loc_happening_hunting_grounds"
	}
}
circumstance_templates.nurgle_explosion_03 = {
	wwise_state = "None",
	theme_tag = "default",
	ui = {
		description = "loc_circumstance_nurgle_explosion_03_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_nurgle_explosion_03_title"
	},
	mutators = {
		"mutator_add_resistance",
		"mutator_maelstrom_mutated_poxwalker",
		"mutator_live_event_only_beast",
		"mutator_headshot_parasite_enemies"
	}
}
circumstance_templates.nurgle_explosion_04 = {
	dialogue_id = "circumstance_vo_darkness",
	wwise_state = "darkness_01",
	theme_tag = "darkness",
	ui = {
		description = "loc_circumstance_nurgle_explosion_04_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_nurgle_explosion_04_title",
		happening_display_name = "loc_happening_darkness"
	},
	mutators = {
		"mutator_more_witches",
		"mutator_more_encampments",
		"mutator_add_resistance",
		"mutator_darkness_los",
		"mutator_maelstrom_mutated_poxwalker",
		"mutator_live_event_only_beast",
		"mutator_headshot_parasite_enemies"
	}
}
circumstance_templates.nurgle_explosion_05 = {
	dialogue_id = "circumstance_vo_toxic_gas",
	wwise_state = "ventilation_purge_01",
	theme_tag = "toxic_gas",
	mutators = {
		"mutator_toxic_gas_volumes",
		"mutator_add_resistance",
		"mutator_maelstrom_mutated_poxwalker",
		"mutator_live_event_only_beast",
		"mutator_headshot_parasite_enemies"
	},
	ui = {
		description = "loc_circumstance_nurgle_explosion_05_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_nurgle_explosion_05_title",
		happening_display_name = "loc_happening_ventilation_purge"
	},
	mission_overrides = MissionOverrides.more_corruption_syringes
}
circumstance_templates.nurgle_explosion_06 = {
	dialogue_id = "circumstance_vo_ventilation_purge",
	wwise_state = "ventilation_purge_01",
	theme_tag = "ventilation_purge",
	mutators = {
		"mutator_snipers",
		"mutator_add_resistance",
		"mutator_ventilation_purge_los",
		"mutator_maelstrom_mutated_poxwalker",
		"mutator_live_event_only_beast",
		"mutator_headshot_parasite_enemies"
	},
	ui = {
		description = "loc_circumstance_nurgle_explosion_06_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_nurgle_explosion_06_title",
		happening_display_name = "loc_happening_ventilation_purge"
	}
}
circumstance_templates.nurgle_explosion_07 = {
	wwise_state = "None",
	theme_tag = "default",
	ui = {
		description = "loc_circumstance_nurgle_explosion_07_description",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		display_name = "loc_circumstance_nurgle_explosion_07_title"
	},
	mutators = {
		"mutator_waves_of_specials",
		"mutator_add_resistance",
		"mutator_increase_terror_event_points",
		"mutator_reduced_ramp_duration_low",
		"mutator_auric_tension_modifier",
		"mutator_maelstrom_mutated_poxwalker",
		"mutator_live_event_only_beast",
		"mutator_headshot_parasite_enemies"
	}
}

return circumstance_templates
