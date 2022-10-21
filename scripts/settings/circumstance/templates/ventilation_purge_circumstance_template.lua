local circumstance_templates = {
	ventilation_purge_01 = {
		wwise_state = "ventilation_purge_01",
		theme_tag = "ventilation_purge",
		mutators = {
			"mutator_snipers"
		},
		ui = {
			description = "loc_circumstance_ventilation_purge_description",
			icon = "content/ui/materials/icons/circumstances/ventilation_purge_01",
			display_name = "loc_circumstance_ventilation_purge_title",
			favourable_to_players = true
		}
	}
}

return circumstance_templates
