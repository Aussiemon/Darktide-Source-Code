-- chunkname: @scripts/settings/circumstance/templates/ember_circumstance_template.lua

local circumstance_templates = {
	ember_01 = {
		dialogue_id = "circumstance_vo_ember",
		theme_tag = "ember",
		wwise_state = "ember_01",
		ui = {
			description = "loc_circumstance_ember_description",
			display_name = "loc_circumstance_ember_title",
			happening_display_name = "loc_happening_ventilation_purge",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_01",
		},
		mutators = {
			"mutator_renegade_flamer_none_packs",
			"mutator_only_traitor_guard_faction",
		},
	},
}

return circumstance_templates
