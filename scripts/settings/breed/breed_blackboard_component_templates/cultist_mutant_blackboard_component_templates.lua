local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local cultist_mutant = {
	behavior = {
		move_state = "string"
	},
	record_state = {
		has_disabled_player = "boolean"
	}
}

table.merge(cultist_mutant, base_template)

local templates = {
	cultist_mutant = cultist_mutant
}

return templates
