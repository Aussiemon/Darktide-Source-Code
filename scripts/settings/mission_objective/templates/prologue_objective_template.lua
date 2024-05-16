-- chunkname: @scripts/settings/mission_objective/templates/prologue_objective_template.lua

local mission_objective_templates = {
	prologue = {
		objectives = {
			objective_prologue_start = {
				description = "loc_objective_prologue_start_desc",
				header = "loc_objective_prologue_start_header",
				mission_objective_type = "goal",
				use_music_event = "prologue_explore",
			},
			objective_prologue_melee = {
				description = "loc_objective_prologue_melee_desc",
				header = "loc_objective_prologue_melee_header",
				mission_objective_type = "goal",
				use_music_event = "prologue_explore",
			},
			objective_prologue_guardhouse_interact = {
				description = "loc_objective_prologue_guardhouse_interact_desc",
				header = "loc_objective_prologue_guardhouse_interact_header",
				mission_objective_type = "goal",
				use_music_event = "prologue_explore",
			},
			objective_prologue_goto_bay = {
				description = "loc_objective_prologue_goto_bay_desc",
				header = "loc_objective_prologue_goto_bay_header",
				mission_objective_type = "goal",
				use_music_event = "prologue_explore",
			},
			objective_prologue_goto_hangar = {
				description = "loc_objective_prologue_goto_hangar_desc",
				header = "loc_objective_prologue_goto_hangar_header",
				mission_objective_type = "goal",
				use_music_event = "prologue_combat",
			},
			objective_prologue_hangar_reach = {
				description = "loc_objective_prologue_hangar_reach_desc",
				header = "loc_objective_prologue_hangar_reach_header",
				mission_objective_type = "goal",
				use_music_event = "prologue_combat",
			},
			objective_prologue_hangar_survive = {
				description = "loc_objective_prologue_hangar_survive_desc",
				header = "loc_objective_prologue_hangar_survive_header",
				mission_objective_type = "goal",
				use_music_event = "prologue_end_event",
			},
		},
	},
}

return mission_objective_templates
