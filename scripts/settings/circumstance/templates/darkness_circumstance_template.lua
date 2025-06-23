-- chunkname: @scripts/settings/circumstance/templates/darkness_circumstance_template.lua

local circumstance_templates = {
	darkness_01 = {
		dialogue_id = "circumstance_vo_darkness",
		wwise_state = "darkness_01",
		theme_tag = "darkness",
		ui = {
			description = "loc_circumstance_darkness_description",
			happening_display_name = "loc_happening_darkness",
			display_name = "loc_circumstance_darkness_title",
			background = "content/ui/materials/backgrounds/mutators/mutator_lights_out",
			mission_board_icon = "content/ui/materials/mission_board/circumstances/darkness_01",
			icon = "content/ui/materials/icons/circumstances/darkness_01"
		},
		mutators = {
			"mutator_more_witches",
			"mutator_more_encampments",
			"mutator_darkness_los"
		}
	},
	darkness_hunting_grounds_01 = {
		dialogue_id = "circumstance_vo_darkness",
		wwise_state = "darkness_01",
		theme_tag = "darkness",
		dialogue_load_files = {
			"circumstance_vo_darkness",
			"circumstance_vo_hunting_grounds"
		},
		ui = {
			description = "loc_circumstance_darkness_hunting_grounds_description",
			happening_display_name = "loc_happening_darkness",
			display_name = "loc_circumstance_darkness_hunting_grounds_title",
			background = "content/ui/materials/backgrounds/mutators/mutator_lights_out",
			mission_board_icon = "content/ui/materials/mission_board/circumstances/darkness_02",
			icon = "content/ui/materials/icons/circumstances/darkness_02"
		},
		mutators = {
			"mutator_more_witches",
			"mutator_more_encampments",
			"mutator_chaos_hounds",
			"mutator_darkness_los"
		}
	},
	darkness_more_resistance_01 = {
		dialogue_id = "circumstance_vo_darkness",
		wwise_state = "darkness_01",
		theme_tag = "darkness",
		ui = {
			description = "loc_circumstance_darkness_more_resistance_description",
			happening_display_name = "loc_happening_darkness",
			display_name = "loc_circumstance_darkness_more_resistance_title",
			mission_board_icon = "content/ui/materials/mission_board/circumstances/darkness_03",
			icon = "content/ui/materials/icons/circumstances/darkness_03"
		},
		mutators = {
			"mutator_more_witches",
			"mutator_more_encampments",
			"mutator_add_resistance",
			"mutator_darkness_los"
		}
	},
	darkness_less_resistance_01 = {
		dialogue_id = "circumstance_vo_darkness",
		wwise_state = "darkness_01",
		theme_tag = "darkness",
		ui = {
			description = "loc_circumstance_darkness_less_resistance_description",
			happening_display_name = "loc_happening_darkness",
			display_name = "loc_circumstance_darkness_less_resistance_title",
			mission_board_icon = "content/ui/materials/mission_board/circumstances/darkness_04",
			icon = "content/ui/materials/icons/circumstances/darkness_04"
		},
		mutators = {
			"mutator_more_witches",
			"mutator_more_encampments",
			"mutator_subtract_resistance",
			"mutator_darkness_los"
		}
	},
	darkness_twins_solo_01 = {
		dialogue_id = "circumstance_vo_darkness_twin",
		wwise_state = "darkness_01",
		theme_tag = "darkness",
		dialogue_load_files = {
			"circumstance_vo_darkness"
		},
		vo_units = {
			"renegade_twin_captain_two",
			"dreg_lector"
		},
		ui = {
			description = "loc_circumstance_darkness_twins_solo_description",
			happening_display_name = "loc_happening_darkness",
			display_name = "loc_circumstance_darkness_twins_solo_title",
			mission_board_icon = "content/ui/materials/mission_board/circumstances/darkness_01",
			icon = "content/ui/materials/icons/circumstances/darkness_01"
		},
		mutators = {
			"mutator_single_twin",
			"mutator_more_encampments",
			"mutator_darkness_los"
		}
	}
}

return circumstance_templates
