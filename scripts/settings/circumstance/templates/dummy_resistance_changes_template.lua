-- chunkname: @scripts/settings/circumstance/templates/dummy_resistance_changes_template.lua

local circumstance_templates = {
	dummy_more_resistance_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_dummy_more_resistance_description",
			display_name = "loc_circumstance_dummy_more_resistance_title",
			icon = "content/ui/materials/icons/circumstances/more_resistance_01",
			mission_board_icon = "content/ui/materials/mission_board/circumstances/more_resistance_01",
		},
	},
	dummy_less_resistance_01 = {
		theme_tag = "default",
		wwise_state = "None",
		ui = {
			description = "loc_circumstance_dummy_less_resistance_description",
			display_name = "loc_circumstance_dummy_less_resistance_title",
			icon = "content/ui/materials/icons/circumstances/less_resistance_01",
			mission_board_icon = "content/ui/materials/mission_board/circumstances/less_resistance_01",
		},
	},
}

return circumstance_templates
