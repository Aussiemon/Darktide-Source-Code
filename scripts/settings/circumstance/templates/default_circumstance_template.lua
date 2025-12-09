-- chunkname: @scripts/settings/circumstance/templates/default_circumstance_template.lua

local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local circumstance_templates = {
	default = {
		theme_tag = "default",
		wwise_state = "None",
		mission_overrides = MissionOverrides.stats_default,
	},
}

return circumstance_templates
