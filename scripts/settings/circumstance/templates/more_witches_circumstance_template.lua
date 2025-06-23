-- chunkname: @scripts/settings/circumstance/templates/more_witches_circumstance_template.lua

local circumstance_templates = {
	more_witches_01 = {
		wwise_state = "more_witches_01",
		theme_tag = "default",
		mutators = {
			"mutator_more_witches"
		},
		ui = {
			description = "loc_circumstance_more_witches_description",
			icon = "content/ui/materials/icons/circumstances/placeholder",
			display_name = "loc_circumstance_more_witches_title"
		}
	}
}

return circumstance_templates
