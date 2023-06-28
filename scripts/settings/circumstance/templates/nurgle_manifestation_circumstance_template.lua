local circumstance_templates = {
	nurgle_manifestation_01 = {
		dialogue_id = "circumstance_vo_nurgle_rot",
		wwise_state = "nurgle_manifestation_01",
		theme_tag = "nurgle_manifestation",
		ui = {
			description = "loc_circumstance_nurgle_manifestation_description",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
			display_name = "loc_circumstance_nurgle_manifestation_title",
			happening_display_name = "loc_happening_nurgle_manifestation"
		},
		mutators = {
			"mutator_minion_nurgle_blessing"
		},
		mission_overrides = {}
	},
	heretical_disruption_01 = {
		dialogue_id = "circumstance_vo_nurgle_rot",
		wwise_state = "nurgle_manifestation_01",
		theme_tag = "nurgle_manifestation",
		ui = {
			description = "loc_circumstance_nurgle_manifestation_description",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
			display_name = "loc_circumstance_nurgle_manifestation_title",
			happening_display_name = "loc_happening_nurgle_manifestation"
		},
		mutators = {
			"mutator_corruption_over_time"
		},
		mission_overrides = {}
	},
	stimmed_minions_blue_01 = {
		ui = {
			description = "loc_circumstance_nurgle_manifestation_description",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
			display_name = "loc_circumstance_nurgle_manifestation_title",
			happening_display_name = "loc_happening_nurgle_manifestation"
		},
		mutators = {
			"mutator_stimmed_minions_blue"
		},
		mission_overrides = {}
	},
	stimmed_minions_green_01 = {
		ui = {
			description = "loc_circumstance_nurgle_manifestation_description",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
			display_name = "loc_circumstance_nurgle_manifestation_title",
			happening_display_name = "loc_happening_nurgle_manifestation"
		},
		mutators = {
			"mutator_stimmed_minions_green"
		},
		mission_overrides = {}
	},
	stimmed_minions_red_01 = {
		ui = {
			description = "loc_circumstance_nurgle_manifestation_description",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
			display_name = "loc_circumstance_nurgle_manifestation_title",
			happening_display_name = "loc_happening_nurgle_manifestation"
		},
		mutators = {
			"mutator_stimmed_minions_red"
		},
		mission_overrides = {}
	},
	stimmed_minions_yellow_01 = {
		ui = {
			description = "loc_circumstance_nurgle_manifestation_description",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
			display_name = "loc_circumstance_nurgle_manifestation_title",
			happening_display_name = "loc_happening_nurgle_manifestation"
		},
		mutators = {
			"mutator_stimmed_minions_yellow"
		},
		mission_overrides = {}
	},
	stimmed_minions_purple_01 = {
		ui = {
			description = "loc_circumstance_nurgle_manifestation_description",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
			display_name = "loc_circumstance_nurgle_manifestation_title",
			happening_display_name = "loc_happening_nurgle_manifestation"
		},
		mutators = {
			"mutator_stimmed_minions_purple"
		},
		mission_overrides = {}
	},
	stimmed_minions_mixed_01 = {
		ui = {
			description = "loc_circumstance_nurgle_manifestation_description",
			icon = "content/ui/materials/icons/circumstances/nurgle_manifestation_01",
			display_name = "loc_circumstance_nurgle_manifestation_title",
			happening_display_name = "loc_happening_nurgle_manifestation"
		},
		mutators = {
			"mutator_stimmed_minions_yellow",
			"mutator_stimmed_minions_blue",
			"mutator_stimmed_minions_red",
			"mutator_stimmed_minions_purple"
		},
		mission_overrides = {}
	}
}

return circumstance_templates
