﻿-- chunkname: @scripts/settings/circumstance/templates/stealth_circumstance_template.lua

local circumstance_templates = {
	stealth_01 = {
		dialogue_id = "circumstance_vo_darkness",
		theme_tag = "default",
		wwise_state = "darkness_01",
		mutators = {
			"mutator_darkness_los",
		},
	},
}

return circumstance_templates
