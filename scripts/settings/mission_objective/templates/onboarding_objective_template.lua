-- chunkname: @scripts/settings/mission_objective/templates/onboarding_objective_template.lua

local mission_objective_templates = {
	onboarding = {
		objectives = {
			objective_om_hub_01_goto_command_central = {
				description = "loc_objective_om_hub_01_goto_command_central_desc",
				header = "loc_objective_om_hub_01_goto_command_central_header",
				mission_objective_type = "goal",
			},
			objective_om_hub_01_goto_training_grounds = {
				description = "loc_objective_om_hub_01_goto_training_grounds_desc",
				header = "loc_objective_om_hub_01_goto_training_grounds_header",
				mission_objective_type = "goal",
			},
			objective_om_hub_02_goto_cathedral = {
				description = "loc_objective_om_hub_01_goto_cathedral_desc",
				header = "loc_objective_om_hub_01_goto_cathedral_header",
				mission_objective_type = "goal",
			},
		},
	},
}

return mission_objective_templates
