-- chunkname: @scripts/settings/circumstance/templates/more_witches_circumstance_template.lua

local circumstance_templates = {
	more_witches_01 = {
		theme_tag = "default",
		wwise_state = "more_witches_01",
		mutators = {
			"mutator_more_witches",
		},
		ui = {
			description = "loc_circumstance_more_witches_description",
			display_name = "loc_circumstance_more_witches_title",
			icon = "content/ui/materials/icons/circumstances/placeholder",
		},
	},
}

return circumstance_templates
