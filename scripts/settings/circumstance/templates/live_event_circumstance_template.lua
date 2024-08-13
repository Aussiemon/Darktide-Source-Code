-- chunkname: @scripts/settings/circumstance/templates/live_event_circumstance_template.lua

local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local circumstance_templates = {}

circumstance_templates.friendly_explosives_01 = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {
		"mutator_explosive_friendly_fire",
	},
	ui = {
		description = "loc_circumstance_more_hordes_description",
		display_name = "loc_circumstance_more_hordes_title",
		icon = "content/ui/materials/icons/circumstances/placeholder",
	},
}

return circumstance_templates
