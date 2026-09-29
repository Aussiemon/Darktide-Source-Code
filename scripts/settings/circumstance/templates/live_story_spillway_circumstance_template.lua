-- chunkname: @scripts/settings/circumstance/templates/live_story_spillway_circumstance_template.lua

local circumstance_templates = {}
local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local mission_overrides = MissionOverrides.merge("stats_live_event_spillway", "stats_story", "stats_default")

circumstance_templates.story_spillway_01 = {
	theme_tag = "default",
	wwise_state = "None",
	mission_overrides = mission_overrides,
	mutators = {
		"mutator_only_traitor_guard_faction",
		"mutator_spillway_cargo_event_spawner",
	},
	ui = {
		description = "loc_circumstance_story_spillway_01_description",
		display_name = "loc_circumstance_story_spillway_01_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
}
circumstance_templates.story_spillway_02 = {
	theme_tag = "default",
	wwise_state = "None",
	mission_overrides = mission_overrides,
	mutators = {
		"mutator_only_traitor_guard_faction",
		"mutator_live_story_spillway_ranged_elite_drops",
		"mutator_live_story_spillway_melee_elite_drops",
	},
	ui = {
		description = "loc_circumstance_story_spillway_02_description",
		display_name = "loc_circumstance_story_spillway_02_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
}
circumstance_templates.story_spillway_03 = {
	theme_tag = "default",
	wwise_state = "None",
	mission_overrides = mission_overrides,
	mutators = {
		"mutator_only_traitor_guard_faction",
		"mutator_live_story_spillway_void_shield",
	},
	ui = {
		description = "loc_circumstance_story_spillway_03_description",
		display_name = "loc_circumstance_story_spillway_03_title",
		icon = "content/ui/materials/icons/circumstances/live_event_01",
		mission_board_icon = "content/ui/materials/mission_board/circumstances/live_event_01",
	},
}

return circumstance_templates
