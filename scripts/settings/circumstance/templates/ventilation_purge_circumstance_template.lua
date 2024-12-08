-- chunkname: @scripts/settings/circumstance/templates/ventilation_purge_circumstance_template.lua

local circumstance_templates = {
	ventilation_purge_01 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		theme_tag = "ventilation_purge",
		wwise_state = "ventilation_purge_01",
		mutators = {
			"mutator_ventilation_purge_los",
		},
		ui = {
			background = "content/ui/materials/backgrounds/mutators/mutator_vent",
			description = "loc_circumstance_ventilation_purge_description",
			display_name = "loc_circumstance_ventilation_purge_title",
			happening_display_name = "loc_happening_ventilation_purge",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_01",
		},
	},
	ventilation_purge_more_resistance_01 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		theme_tag = "ventilation_purge",
		wwise_state = "ventilation_purge_01",
		mutators = {
			"mutator_add_resistance",
			"mutator_ventilation_purge_los",
		},
		ui = {
			description = "loc_circumstance_ventilation_purge_more_resistance_description",
			display_name = "loc_circumstance_ventilation_purge_more_resistance_title",
			happening_display_name = "loc_happening_ventilation_purge",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_03",
		},
	},
	ventilation_purge_less_resistance_01 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		theme_tag = "ventilation_purge",
		wwise_state = "ventilation_purge_01",
		mutators = {
			"mutator_subtract_resistance",
			"mutator_ventilation_purge_los",
		},
		ui = {
			description = "loc_circumstance_ventilation_purge_less_resistance_description",
			display_name = "loc_circumstance_ventilation_purge_less_resistance_title",
			happening_display_name = "loc_happening_ventilation_purge",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_04",
		},
	},
	ventilation_purge_with_snipers_01 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		theme_tag = "ventilation_purge",
		wwise_state = "ventilation_purge_01",
		mutators = {
			"mutator_snipers",
			"mutator_ventilation_purge_los",
		},
		ui = {
			background = "content/ui/materials/backgrounds/mutators/mutator_vent_sniper",
			description = "loc_circumstance_ventilation_purge_with_snipers_description",
			display_name = "loc_circumstance_ventilation_purge_with_snipers_title",
			happening_display_name = "loc_happening_ventilation_purge",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_02",
		},
	},
	ventilation_purge_with_snipers_more_resistance_01 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		theme_tag = "ventilation_purge",
		wwise_state = "ventilation_purge_01",
		mutators = {
			"mutator_snipers",
			"mutator_add_resistance",
			"mutator_ventilation_purge_los",
		},
		ui = {
			description = "loc_circumstance_ventilation_purge_with_snipers_more_resistance_description",
			display_name = "loc_circumstance_ventilation_purge_with_snipers_more_resistance_title",
			happening_display_name = "loc_happening_ventilation_purge",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_03",
		},
	},
	ventilation_purge_with_snipers_less_resistance_01 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		theme_tag = "ventilation_purge",
		wwise_state = "ventilation_purge_01",
		mutators = {
			"mutator_snipers",
			"mutator_subtract_resistance",
			"mutator_ventilation_purge_los",
		},
		ui = {
			description = "loc_circumstance_ventilation_purge_with_snipers_less_resistance_description",
			display_name = "loc_circumstance_ventilation_purge_with_snipers_less_resistance_title",
			happening_display_name = "loc_happening_ventilation_purge",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_04",
		},
	},
}

return circumstance_templates
