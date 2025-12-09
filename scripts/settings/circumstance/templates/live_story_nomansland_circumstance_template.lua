-- chunkname: @scripts/settings/circumstance/templates/live_story_nomansland_circumstance_template.lua

local circumstance_templates = {}
local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local mission_overrides = MissionOverrides.merge("stats_story", "stats_default")

circumstance_templates.story_nomansland_01 = {
	theme_tag = "default",
	wwise_state = "None",
	mission_overrides = mission_overrides,
	mutators = {
		"mutator_havoc_armored_infected",
	},
	ui = {
		description = "loc_circumstance_story_nomansland_01_description",
		display_name = "loc_circumstance_story_nomansland_01_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
}
circumstance_templates.story_nomansland_02 = {
	theme_tag = "default",
	wwise_state = "None",
	mission_overrides = mission_overrides,
	mutators = {
		"mutator_havoc_armored_infected",
		"mutator_only_traitor_guard_faction",
	},
	ui = {
		description = "loc_circumstance_story_nomansland_02_description",
		display_name = "loc_circumstance_story_nomansland_02_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
}
circumstance_templates.story_nomansland_03 = {
	theme_tag = "default",
	wwise_state = "None",
	mission_overrides = mission_overrides,
	mutators = {
		"mutator_havoc_armored_infected",
		"mutator_only_traitor_guard_faction",
	},
	ui = {
		description = "loc_circumstance_story_nomansland_03_description",
		display_name = "loc_circumstance_story_nomansland_03_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
}

return circumstance_templates
