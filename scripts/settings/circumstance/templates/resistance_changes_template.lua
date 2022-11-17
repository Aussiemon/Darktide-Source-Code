local circumstance_templates = {
	more_resistance_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_dummy_more_resistance_description",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
			display_name = "loc_circumstance_dummy_more_resistance_title"
		},
		mutators = {
			"mutator_add_resistance"
		}
	},
	less_resistance_01 = {
		wwise_state = "None",
		theme_tag = "default",
		ui = {
			description = "loc_circumstance_dummy_less_resistance_description",
			icon = "content/ui/materials/icons/circumstances/less_resistance_01",
			display_name = "loc_circumstance_dummy_less_resistance_title"
		},
		mutators = {
			"mutator_subtract_resistance"
		}
	}
}

return circumstance_templates
