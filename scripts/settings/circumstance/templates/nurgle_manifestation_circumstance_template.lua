local circumstance_templates = {
	nurgle_manifestation_01 = {
		wwise_state = "nurgle_manifestation_01",
		theme_tag = "nurgle_manifestation",
		ui = {
			icon = "content/ui/materials/icons/circumstances/poison",
			display_name = "loc_circumstance_nurgle_manifestation_title",
			favourable_to_players = true
		},
		mutators = {
			"mutator_minion_nurgle_blessing"
		},
		mission_overrides = {}
	}
}

return circumstance_templates
