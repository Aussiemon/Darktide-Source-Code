local circumstance_templates = {
	ventilation_purge_01 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		wwise_state = "ventilation_purge_01",
		theme_tag = "ventilation_purge",
		mutators = {
			"mutator_ventilation_purge_los"
		},
		ui = {
			description = "loc_circumstance_ventilation_purge_description",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_01",
			display_name = "loc_circumstance_ventilation_purge_title",
			happening_display_name = "loc_happening_ventilation_purge"
		}
	},
	ventilation_purge_more_resistance_01 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		wwise_state = "ventilation_purge_01",
		theme_tag = "ventilation_purge",
		mutators = {
			"mutator_add_resistance",
			"mutator_ventilation_purge_los"
		},
		ui = {
			description = "loc_circumstance_ventilation_purge_more_resistance_description",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_04",
			display_name = "loc_circumstance_ventilation_purge_more_resistance_title",
			happening_display_name = "loc_happening_ventilation_purge"
		}
	},
	ventilation_purge_less_resistance_01 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		wwise_state = "ventilation_purge_01",
		theme_tag = "ventilation_purge",
		mutators = {
			"mutator_subtract_resistance",
			"mutator_ventilation_purge_los"
		},
		ui = {
			description = "loc_circumstance_ventilation_purge_less_resistance_description",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_04",
			display_name = "loc_circumstance_ventilation_purge_less_resistance_title",
			happening_display_name = "loc_happening_ventilation_purge"
		}
	},
	ventilation_purge_with_snipers_01 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		wwise_state = "ventilation_purge_01",
		theme_tag = "ventilation_purge",
		mutators = {
			"mutator_snipers",
			"mutator_ventilation_purge_los"
		},
		ui = {
			description = "loc_circumstance_ventilation_purge_with_snipers_description",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_02",
			display_name = "loc_circumstance_ventilation_purge_with_snipers_title",
			happening_display_name = "loc_happening_ventilation_purge"
		}
	},
	ventilation_purge_with_snipers_more_resistance_01 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		wwise_state = "ventilation_purge_01",
		theme_tag = "ventilation_purge",
		mutators = {
			"mutator_snipers",
			"mutator_add_resistance",
			"mutator_ventilation_purge_los"
		},
		ui = {
			description = "loc_circumstance_ventilation_purge_with_snipers_more_resistance_description",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_03",
			display_name = "loc_circumstance_ventilation_purge_with_snipers_more_resistance_title",
			happening_display_name = "loc_happening_ventilation_purge"
		}
	},
	ventilation_purge_with_snipers_less_resistance_01 = {
		dialogue_id = "circumstance_vo_ventilation_purge",
		wwise_state = "ventilation_purge_01",
		theme_tag = "ventilation_purge",
		mutators = {
			"mutator_snipers",
			"mutator_subtract_resistance",
			"mutator_ventilation_purge_los"
		},
		ui = {
			description = "loc_circumstance_ventilation_purge_with_snipers_less_resistance_description",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_04",
			display_name = "loc_circumstance_ventilation_purge_with_snipers_less_resistance_title",
			happening_display_name = "loc_happening_ventilation_purge"
		}
	},
	toxic_gas_01 = {
		dialogue_id = "circumstance_vo_toxic_gas",
		wwise_state = "ventilation_purge_01",
		theme_tag = "default",
		mutators = {
			"mutator_toxic_gas"
		},
		ui = {
			description = "loc_circumstance_toxic_gas_description",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_01",
			display_name = "loc_circumstance_toxic_gas_title",
			happening_display_name = "loc_happening_ventilation_purge"
		}
	},
	toxic_gas_volumes_01 = {
		dialogue_id = "circumstance_vo_toxic_gas",
		wwise_state = "ventilation_purge_01",
		theme_tag = "toxic_gas",
		mutators = {
			"mutator_toxic_gas_volumes"
		},
		ui = {
			description = "loc_circumstance_toxic_gas_description",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_01",
			display_name = "loc_circumstance_toxic_gas_title",
			happening_display_name = "loc_happening_ventilation_purge"
		}
	},
	toxic_gas_twins_01 = {
		dialogue_id = "circumstance_vo_toxic_gas",
		wwise_state = "ventilation_purge_01",
		theme_tag = "toxic_gas",
		mutators = {
			"mutator_toxic_gas_twins",
			"mutator_no_hordes",
			"mutator_only_none_roamer_packs",
			"mutator_low_roamer_amount",
			"mutator_no_monsters",
			"mutator_no_witches",
			"mutator_no_boss_patrols",
			"mutator_only_traitor_guard_faction"
		}
	}
}

return circumstance_templates
