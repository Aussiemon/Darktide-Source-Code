-- chunkname: @scripts/settings/circumstance/templates/hunting_grounds_circumstance_template.lua

local circumstance_templates = {
	hunting_grounds_01 = {
		dialogue_id = "circumstance_vo_hunting_grounds",
		wwise_event_stop = "wwise/events/world/stop_hunting_grounds_occasionals",
		wwise_event_init = "wwise/events/world/play_hunting_grounds_occasionals",
		theme_tag = "default",
		wwise_state = "hunting_grounds_01",
		mutators = {
			"mutator_chaos_hounds"
		},
		ui = {
			description = "loc_circumstance_hunting_grounds_description",
			happening_display_name = "loc_happening_hunting_grounds",
			display_name = "loc_circumstance_hunting_grounds_title",
			mission_board_icon = "content/ui/materials/mission_board/circumstances/hunting_grounds_01",
			icon = "content/ui/materials/icons/circumstances/hunting_grounds_01"
		}
	},
	hunting_grounds_more_resistance_01 = {
		dialogue_id = "circumstance_vo_hunting_grounds",
		wwise_event_stop = "wwise/events/world/stop_hunting_grounds_occasionals",
		wwise_event_init = "wwise/events/world/play_hunting_grounds_occasionals",
		theme_tag = "default",
		wwise_state = "hunting_grounds_01",
		mutators = {
			"mutator_chaos_hounds",
			"mutator_add_resistance"
		},
		ui = {
			description = "loc_circumstance_hunting_grounds_more_resistance_description",
			happening_display_name = "loc_happening_hunting_grounds",
			display_name = "loc_circumstance_hunting_grounds_more_resistance_title",
			mission_board_icon = "content/ui/materials/mission_board/circumstances/hunting_grounds_02",
			icon = "content/ui/materials/icons/circumstances/hunting_grounds_02"
		}
	},
	hunting_grounds_less_resistance_01 = {
		dialogue_id = "circumstance_vo_hunting_grounds",
		wwise_event_stop = "wwise/events/world/stop_hunting_grounds_occasionals",
		wwise_event_init = "wwise/events/world/play_hunting_grounds_occasionals",
		theme_tag = "default",
		wwise_state = "hunting_grounds_01",
		mutators = {
			"mutator_chaos_hounds",
			"mutator_subtract_resistance"
		},
		ui = {
			description = "loc_circumstance_hunting_grounds_less_resistance_description",
			happening_display_name = "loc_happening_hunting_grounds",
			display_name = "loc_circumstance_hunting_grounds_less_resistance_title",
			mission_board_icon = "content/ui/materials/mission_board/circumstances/hunting_grounds_03",
			icon = "content/ui/materials/icons/circumstances/hunting_grounds_03"
		}
	}
}

return circumstance_templates
