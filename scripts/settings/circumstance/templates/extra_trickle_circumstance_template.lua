-- chunkname: @scripts/settings/circumstance/templates/extra_trickle_circumstance_template.lua

local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local circumstance_templates = {
	snipers_01 = {
		theme_tag = "default",
		wwise_event_init = "wwise/events/world/play_hunting_grounds_occasionals",
		wwise_event_stop = "wwise/events/world/stop_hunting_grounds_occasionals",
		wwise_state = "hunting_grounds_01",
		mutators = {
			"mutator_snipers",
		},
		ui = {
			description = "loc_circumstance_hunting_grounds_description",
			display_name = "loc_circumstance_hunting_grounds_title",
			happening_display_name = "loc_happening_hunting_grounds",
			icon = "content/ui/materials/icons/circumstances/hunting_grounds_01",
			mission_board_icon = "content/ui/materials/mission_board/circumstances/hunting_grounds_01",
		},
	},
	poxwalker_bombers_01 = {
		theme_tag = "default",
		wwise_event_init = "wwise/events/world/play_hunting_grounds_occasionals",
		wwise_event_stop = "wwise/events/world/stop_hunting_grounds_occasionals",
		wwise_state = "hunting_grounds_01",
		mutators = {
			"mutator_poxwalker_bombers",
		},
		ui = {
			description = "loc_circumstance_hunting_grounds_description",
			display_name = "loc_circumstance_hunting_grounds_title",
			happening_display_name = "loc_happening_hunting_grounds",
			icon = "content/ui/materials/icons/circumstances/hunting_grounds_01",
			mission_board_icon = "content/ui/materials/mission_board/circumstances/hunting_grounds_01",
		},
		mission_overrides = MissionOverrides.no_empty_hazards,
	},
	mutants_01 = {
		theme_tag = "default",
		wwise_event_init = "wwise/events/world/play_hunting_grounds_occasionals",
		wwise_event_stop = "wwise/events/world/stop_hunting_grounds_occasionals",
		wwise_state = "hunting_grounds_01",
		mutators = {
			"mutator_mutants",
		},
		ui = {
			description = "loc_circumstance_hunting_grounds_description",
			display_name = "loc_circumstance_hunting_grounds_title",
			happening_display_name = "loc_happening_hunting_grounds",
			icon = "content/ui/materials/icons/circumstances/hunting_grounds_01",
			mission_board_icon = "content/ui/materials/mission_board/circumstances/hunting_grounds_01",
		},
	},
}

return circumstance_templates
