-- chunkname: @scripts/settings/circumstance/templates/live_event_barrel_grounds_circumstance_template.lua

local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local circumstance_templates = {}

circumstance_templates.barrel_grounds = {
	theme_tag = "default",
	wwise_state = "None",
	ui = {
		background = "content/ui/materials/backgrounds/mutators/mutators_bg_default",
		description = "loc_circumstance_barrel_grounds_description",
		display_name = "loc_circumstance_barrel_grounds_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
	mutators = {
		"mutator_extra_shocktrooper",
		"mutator_extra_grenadiers",
		"mutator_poxwalker_bombers",
		"mutator_headshot_parasite_enemies",
		"mutator_drop_shocktrooper_grenade_on_death",
		"mutator_increased_catapult_force",
	},
	mission_overrides = MissionOverrides.all_explosive_barrels,
}
circumstance_templates.barrel_grounds_hunt_grou = {
	dialogue_id = "circumstance_vo_hunting_grounds",
	theme_tag = "default",
	wwise_event_init = "wwise/events/world/play_hunting_grounds_occasionals",
	wwise_event_stop = "wwise/events/world/stop_hunting_grounds_occasionals",
	wwise_state = "hunting_grounds_01",
	mutators = {
		"mutator_chaos_hounds",
		"mutator_extra_shocktrooper",
		"mutator_extra_grenadiers",
		"mutator_poxwalker_bombers",
		"mutator_headshot_parasite_enemies",
		"mutator_drop_shocktrooper_grenade_on_death",
		"mutator_increased_catapult_force",
	},
	mission_overrides = MissionOverrides.all_explosive_barrels,
	ui = {
		description = "loc_circumstance_barrel_grounds_hunt_grou_description",
		display_name = "loc_circumstance_barrel_grounds_hunt_grou_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
}
circumstance_templates.barrel_grounds_more_res = {
	theme_tag = "default",
	wwise_state = "None",
	ui = {
		description = "loc_circumstance_barrel_grounds_more_res_description",
		display_name = "loc_circumstance_barrel_grounds_more_res_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
	mutators = {
		"mutator_add_resistance",
		"mutator_extra_shocktrooper",
		"mutator_extra_grenadiers",
		"mutator_poxwalker_bombers",
		"mutator_headshot_parasite_enemies",
		"mutator_drop_shocktrooper_grenade_on_death",
		"mutator_increased_catapult_force",
	},
	mission_overrides = MissionOverrides.all_explosive_barrels,
}
circumstance_templates.barrel_grounds_darkness = {
	dialogue_id = "circumstance_vo_darkness",
	theme_tag = "darkness",
	wwise_state = "darkness_01",
	ui = {
		description = "loc_circumstance_barrel_grounds_darkness_description",
		display_name = "loc_circumstance_barrel_grounds_darkness_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
	mutators = {
		"mutator_more_witches",
		"mutator_more_encampments",
		"mutator_add_resistance",
		"mutator_darkness_los",
		"mutator_extra_shocktrooper",
		"mutator_extra_grenadiers",
		"mutator_poxwalker_bombers",
		"mutator_headshot_parasite_enemies",
		"mutator_drop_shocktrooper_grenade_on_death",
		"mutator_increased_catapult_force",
	},
	mission_overrides = MissionOverrides.all_explosive_barrels,
}
circumstance_templates.barrel_grounds_gas = {
	dialogue_id = "circumstance_vo_toxic_gas",
	theme_tag = "toxic_gas",
	wwise_state = "ventilation_purge_01",
	mutators = {
		"mutator_toxic_gas_volumes",
		"mutator_extra_shocktrooper",
		"mutator_extra_grenadiers",
		"mutator_poxwalker_bombers",
		"mutator_headshot_parasite_enemies",
		"mutator_drop_shocktrooper_grenade_on_death",
		"mutator_increased_catapult_force",
	},
	ui = {
		description = "loc_circumstance_barrel_grounds_gas_description",
		display_name = "loc_circumstance_barrel_grounds_gas_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
	mission_overrides = MissionOverrides.merge("all_explosive_barrels", "more_corruption_syringes"),
}
circumstance_templates.barrel_grounds_waves_spec = {
	theme_tag = "default",
	wwise_state = "None",
	ui = {
		description = "loc_circumstance_barrel_grounds_waves_spec_description",
		display_name = "loc_circumstance_barrel_grounds_waves_spec_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
	mutators = {
		"mutator_waves_of_specials",
		"mutator_increase_terror_event_points",
		"mutator_reduced_ramp_duration_low",
		"mutator_auric_tension_modifier",
		"mutator_extra_shocktrooper",
		"mutator_extra_grenadiers",
		"mutator_poxwalker_bombers",
		"mutator_headshot_parasite_enemies",
		"mutator_drop_shocktrooper_grenade_on_death",
		"mutator_increased_catapult_force",
	},
	mission_overrides = MissionOverrides.all_explosive_barrels,
}
circumstance_templates.barrel_grounds_ventilation = {
	dialogue_id = "circumstance_vo_ventilation_purge",
	theme_tag = "ventilation_purge",
	wwise_state = "ventilation_purge_01",
	ui = {
		description = "loc_circumstance_barrel_grounds_ventilation_description",
		display_name = "loc_circumstance_barrel_grounds_ventilation_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
	mutators = {
		"mutator_snipers",
		"mutator_ventilation_purge_los",
		"mutator_extra_shocktrooper",
		"mutator_extra_grenadiers",
		"mutator_poxwalker_bombers",
		"mutator_headshot_parasite_enemies",
		"mutator_drop_shocktrooper_grenade_on_death",
		"mutator_increased_catapult_force",
	},
	mission_overrides = MissionOverrides.all_explosive_barrels,
}

return circumstance_templates
