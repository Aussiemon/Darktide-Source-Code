-- chunkname: @scripts/settings/circumstance/templates/darkness_circumstance_template.lua

local circumstance_templates = {
	darkness_01 = {
		dialogue_id = "circumstance_vo_darkness",
		theme_tag = "darkness",
		wwise_state = "darkness_01",
		ui = {
			description = "loc_circumstance_darkness_description",
			display_name = "loc_circumstance_darkness_title",
			happening_display_name = "loc_happening_darkness",
			icon = "content/ui/materials/icons/circumstances/darkness_01",
		},
		mutators = {
			"mutator_more_witches",
			"mutator_more_encampments",
			"mutator_darkness_los",
		},
	},
	darkness_hunting_grounds_01 = {
		dialogue_id = "circumstance_vo_darkness",
		theme_tag = "darkness",
		wwise_state = "darkness_01",
		dialogue_load_files = {
			"circumstance_vo_darkness",
			"circumstance_vo_hunting_grounds",
		},
		ui = {
			description = "loc_circumstance_darkness_hunting_grounds_description",
			display_name = "loc_circumstance_darkness_hunting_grounds_title",
			happening_display_name = "loc_happening_darkness",
			icon = "content/ui/materials/icons/circumstances/darkness_02",
		},
		mutators = {
			"mutator_more_witches",
			"mutator_more_encampments",
			"mutator_chaos_hounds",
			"mutator_darkness_los",
		},
	},
	darkness_more_resistance_01 = {
		dialogue_id = "circumstance_vo_darkness",
		theme_tag = "darkness",
		wwise_state = "darkness_01",
		ui = {
			description = "loc_circumstance_darkness_more_resistance_description",
			display_name = "loc_circumstance_darkness_more_resistance_title",
			happening_display_name = "loc_happening_darkness",
			icon = "content/ui/materials/icons/circumstances/darkness_03",
		},
		mutators = {
			"mutator_more_witches",
			"mutator_more_encampments",
			"mutator_add_resistance",
			"mutator_darkness_los",
		},
	},
	darkness_less_resistance_01 = {
		dialogue_id = "circumstance_vo_darkness",
		theme_tag = "darkness",
		wwise_state = "darkness_01",
		ui = {
			description = "loc_circumstance_darkness_less_resistance_description",
			display_name = "loc_circumstance_darkness_less_resistance_title",
			happening_display_name = "loc_happening_darkness",
			icon = "content/ui/materials/icons/circumstances/darkness_04",
		},
		mutators = {
			"mutator_more_witches",
			"mutator_more_encampments",
			"mutator_subtract_resistance",
			"mutator_darkness_los",
		},
	},
}

return circumstance_templates
