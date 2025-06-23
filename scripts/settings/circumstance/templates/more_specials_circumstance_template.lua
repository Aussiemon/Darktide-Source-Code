-- chunkname: @scripts/settings/circumstance/templates/more_specials_circumstance_template.lua

local circumstance_templates = {
	more_specials_01 = {
		wwise_state = "more_specials_01",
		theme_tag = "default",
		mutators = {
			"mutator_more_specials"
		},
		ui = {
			description = "loc_circumstance_more_specials_description",
			icon = "content/ui/materials/icons/circumstances/placeholder",
			display_name = "loc_circumstance_more_specials_title"
		}
	}
}

return circumstance_templates
