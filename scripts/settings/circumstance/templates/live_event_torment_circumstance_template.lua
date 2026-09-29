-- chunkname: @scripts/settings/circumstance/templates/live_event_torment_circumstance_template.lua

local circumstance_templates = {}

circumstance_templates.torment = {}

local torment_darkness_mutators = {
	"mutator_more_encampments",
	"mutator_darkness_los",
	"mutator_no_witches",
	"mutator_torment_gameplay_logic",
	"mutator_torment_flashlight_boost",
	"mutator_live_event_torment_witch_spawner",
	"mutator_live_event_torment_eye_glow",
}

circumstance_templates.torment.mutators = torment_darkness_mutators
circumstance_templates.torment.mission_overrides = {
	stat_settings = {
		live_event_torment = true,
	},
}
circumstance_templates.torment.ui = {
	background = "content/ui/materials/backgrounds/mutators/mutator_lights_out",
	description = "loc_circumstance_torment_default_description",
	display_name = "loc_circumstance_torment_default_title",
	happening_display_name = "loc_happening_darkness",
	icon = "content/ui/materials/icons/mission_types/mission_type_event",
	mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_event",
}
circumstance_templates.torment.dialogue_id = "circumstance_vo_darkness"
circumstance_templates.torment.wwise_state = "darkness_01"
circumstance_templates.torment.theme_tag = "darkness"
circumstance_templates.torment_ventilation = {}

local torment_ventilation_mutators = {
	"mutator_snipers",
	"mutator_ventilation_purge_los",
	"mutator_no_witches",
	"mutator_torment_gameplay_logic",
	"mutator_live_event_torment_witch_spawner",
	"mutator_live_event_torment_eye_glow",
}

circumstance_templates.torment_ventilation.ui = {
	background = "content/ui/materials/backgrounds/mutators/mutator_vent",
	description = "loc_circumstance_torment_ventilation_description",
	display_name = "loc_circumstance_torment_ventilation_title",
	happening_display_name = "loc_happening_ventilation_purge",
	icon = "content/ui/materials/icons/mission_types/mission_type_event",
	mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_event",
}
circumstance_templates.torment_ventilation.mission_overrides = {
	stat_settings = {
		live_event_torment = true,
	},
}
circumstance_templates.torment_ventilation.mutators = torment_ventilation_mutators
circumstance_templates.torment_ventilation.wwise_state = "ventilation_purge_01"
circumstance_templates.torment_ventilation.theme_tag = "ventilation_purge"
circumstance_templates.torment_ventilation.dialogue_id = "circumstance_vo_ventilation_purge"

local torment_embers_mutators = {
	"mutator_more_encampments",
	"mutator_no_witches",
	"mutator_torment_gameplay_logic",
	"mutator_live_event_torment_witch_spawner",
	"mutator_live_event_torment_eye_glow",
}

circumstance_templates.torment_embers = {}
circumstance_templates.torment_embers.mutators = torment_embers_mutators
circumstance_templates.torment_embers.mission_overrides = {
	stat_settings = {
		live_event_torment = true,
	},
}
circumstance_templates.torment_embers.ui = {
	background = "content/ui/materials/backgrounds/mutators/mutator_lights_out",
	description = "loc_circumstance_torment_embers_description",
	display_name = "loc_circumstance_torment_embers_title",
	icon = "content/ui/materials/icons/mission_types/mission_type_event",
	mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_event",
}
circumstance_templates.torment_embers.dialogue_id = "circumstance_vo_ember"
circumstance_templates.torment_embers.wwise_state = "ember_01"
circumstance_templates.torment_embers.theme_tag = "ember"

return circumstance_templates
