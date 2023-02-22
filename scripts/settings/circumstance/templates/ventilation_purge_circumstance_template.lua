local circumstance_templates = {
	ventilation_purge_01 = {
		wwise_state = "ventilation_purge_01",
		theme_tag = "ventilation_purge",
		ui = {
			description = "loc_circumstance_ventilation_purge_description",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_01",
			display_name = "loc_circumstance_ventilation_purge_title",
			happening_display_name = "loc_happening_ventilation_purge"
		}
	},
	ventilation_purge_with_snipers_01 = {
		wwise_state = "ventilation_purge_01",
		theme_tag = "ventilation_purge",
		mutators = {
			"mutator_snipers"
		},
		ui = {
			description = "loc_circumstance_ventilation_purge_with_snipers_description",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_01",
			display_name = "loc_circumstance_ventilation_purge_with_snipers_title",
			happening_display_name = "loc_happening_ventilation_purge"
		}
	}
}

return circumstance_templates
