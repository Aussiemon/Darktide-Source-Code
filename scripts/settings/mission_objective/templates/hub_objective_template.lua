-- chunkname: @scripts/settings/mission_objective/templates/hub_objective_template.lua

local mission_objective_templates = {
	hub = {
		objectives = {
			objective_hub_command_central = {
				description = "loc_objective_hub_command_central_desc",
				mission_objective_type = "goal",
				header = "loc_objective_hub_command_central_header"
			},
			objective_hub_mission_board = {
				description = "loc_objective_hub_mission_board_desc",
				mission_objective_type = "goal",
				header = "loc_objective_hub_mission_board_header"
			}
		}
	}
}

return mission_objective_templates
