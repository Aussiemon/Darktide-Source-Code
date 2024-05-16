-- chunkname: @scripts/settings/circumstance/templates/more_hordes_circumstance_template.lua

local circumstance_templates = {
	more_hordes_01 = {
		theme_tag = "default",
		wwise_state = "more_hordes_01",
		mutators = {
			"mutator_more_hordes",
		},
		ui = {
			description = "loc_circumstance_more_hordes_description",
			display_name = "loc_circumstance_more_hordes_title",
			icon = "content/ui/materials/icons/circumstances/placeholder",
		},
	},
}

return circumstance_templates
