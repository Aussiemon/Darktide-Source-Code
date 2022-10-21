local circumstance_templates = {
	extra_chaos_hounds_01 = {
		wwise_state = "extra_chaos_hounds_01",
		theme_tag = "default",
		mutators = {
			"mutator_chaos_hounds"
		},
		ui = {
			description = "loc_circumstance_extra_chaos_hounds_description",
			icon = "content/ui/materials/icons/circumstances/placeholder",
			display_name = "loc_circumstance_extra_chaos_hounds_title"
		}
	},
	extra_snipers_01 = {
		wwise_state = "extra_snipers_01",
		theme_tag = "default",
		mutators = {
			"mutator_snipers"
		},
		ui = {
			description = "loc_circumstance_extra_snipers_description",
			icon = "content/ui/materials/icons/circumstances/placeholder",
			display_name = "loc_circumstance_extra_snipers_title"
		}
	}
}

return circumstance_templates
