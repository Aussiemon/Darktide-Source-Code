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
			"mutator_more_encampments"
		}
	}
}

return circumstance_templates
