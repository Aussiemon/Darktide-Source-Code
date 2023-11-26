-- chunkname: @scripts/settings/circumstance/templates/more_monsters_circumstance_template.lua

local circumstance_templates = {
	more_monsters_01 = {
		wwise_state = "more_monsters_01",
		theme_tag = "default",
		mutators = {
			"mutator_more_monsters"
		},
		ui = {
			description = "loc_circumstance_more_monsters_description",
			icon = "content/ui/materials/icons/circumstances/placeholder",
			display_name = "loc_circumstance_more_monsters_title"
		}
	}
}

return circumstance_templates
