-- chunkname: @scripts/settings/circumstance/templates/live_story_nomansland_circumstance_template.lua

local circumstance_templates = {}

circumstance_templates.story_nomansland_01 = {
	theme_tag = "default",
	wwise_state = "None",
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

for _, template in pairs(circumstance_templates) do
	template.is_default = true
	template.is_story = true
end

return circumstance_templates
