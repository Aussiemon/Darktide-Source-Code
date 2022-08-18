local circumstance_templates = {
	ventilation_purge_01 = {
		wwise_state = "ventilation_purge_01",
		theme_tag = "ventilation_purge",
		mutators = {
			"mutator_snipers"
		},
		ui = {
			icon = "content/ui/materials/icons/circumstances/poison",
			display_name = "loc_circumstance_ventilation_purge_title",
			favourable_to_players = true
		}
	}
}

return circumstance_templates
