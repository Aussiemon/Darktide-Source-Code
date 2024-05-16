-- chunkname: @scripts/settings/circumstance/templates/more_monsters_circumstance_template.lua

local circumstance_templates = {
	more_monsters_01 = {
		theme_tag = "default",
		wwise_state = "more_monsters_01",
		mutators = {
			"mutator_more_monsters",
		},
		ui = {
			description = "loc_circumstance_more_monsters_description",
			display_name = "loc_circumstance_more_monsters_title",
			icon = "content/ui/materials/icons/circumstances/placeholder",
		},
	},
}

return circumstance_templates
