local circumstance_templates = {
	nurgle_manifestation_01 = {
		wwise_state = "nurgle_manifestation_01",
		theme_tag = "nurgle_manifestation",
		ui = {
			description = "loc_circumstance_nurgle_manifestation_description",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
			display_name = "loc_circumstance_nurgle_manifestation_title",
			favourable_to_players = true
		},
		mutators = {
			"mutator_minion_nurgle_blessing"
		},
		mission_overrides = {}
	},
	heretical_disruption_01 = {
		wwise_state = "nurgle_manifestation_01",
		theme_tag = "nurgle_manifestation",
		ui = {
			description = "loc_circumstance_nurgle_manifestation_description",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
			display_name = "loc_circumstance_nurgle_manifestation_title",
			favourable_to_players = true
		},
		mutators = {
			"mutator_corruption_over_time"
		},
		mission_overrides = {}
	}
}

return circumstance_templates
