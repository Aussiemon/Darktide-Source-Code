local circumstance_templates = {
	darkness_01 = {
		wwise_state = "darkness_01",
		theme_tag = "darkness",
		ui = {
			description = "loc_circumstance_darkness_description",
			icon = "content/ui/materials/icons/circumstances/darkness_01",
			display_name = "loc_circumstance_darkness_title",
			happening_display_name = "loc_happening_darkness"
		},
		mutators = {
			"mutator_more_witches",
			"mutator_more_encampments",
			"mutator_darkness_los"
		}
	},
	darkness_hunting_grounds_01 = {
		wwise_state = "darkness_01",
		theme_tag = "darkness",
		ui = {
			description = "loc_circumstance_darkness_hunting_grounds_description",
			icon = "content/ui/materials/icons/circumstances/darkness_02",
			display_name = "loc_circumstance_darkness_hunting_grounds_title",
			happening_display_name = "loc_happening_darkness"
		},
		mutators = {
			"mutator_more_witches",
			"mutator_more_encampments",
			"mutator_chaos_hounds",
			"mutator_darkness_los"
		}
	},
	darkness_more_resistance_01 = {
		wwise_state = "darkness_01",
		theme_tag = "darkness",
		ui = {
			description = "loc_circumstance_darkness_more_resistance_description",
			icon = "content/ui/materials/icons/circumstances/darkness_03",
			display_name = "loc_circumstance_darkness_more_resistance_title",
			happening_display_name = "loc_happening_darkness"
		},
		mutators = {
			"mutator_more_witches",
			"mutator_more_encampments",
			"mutator_add_resistance",
			"mutator_darkness_los"
		}
	},
	darkness_less_resistance_01 = {
		wwise_state = "darkness_01",
		theme_tag = "darkness",
		ui = {
			description = "loc_circumstance_darkness_less_resistance_description",
			icon = "content/ui/materials/icons/circumstances/darkness_04",
			display_name = "loc_circumstance_darkness_less_resistance_title",
			happening_display_name = "loc_happening_darkness"
		},
		mutators = {
			"mutator_more_witches",
			"mutator_more_encampments",
			"mutator_subtract_resistance",
			"mutator_darkness_los"
		}
	}
}

return circumstance_templates
