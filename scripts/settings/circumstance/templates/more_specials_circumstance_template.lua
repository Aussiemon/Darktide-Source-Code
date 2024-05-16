-- chunkname: @scripts/settings/circumstance/templates/more_specials_circumstance_template.lua

local circumstance_templates = {
	more_specials_01 = {
		theme_tag = "default",
		wwise_state = "more_specials_01",
		mutators = {
			"mutator_more_specials",
		},
		ui = {
			description = "loc_circumstance_more_specials_description",
			display_name = "loc_circumstance_more_specials_title",
			icon = "content/ui/materials/icons/circumstances/placeholder",
		},
	},
}

return circumstance_templates
