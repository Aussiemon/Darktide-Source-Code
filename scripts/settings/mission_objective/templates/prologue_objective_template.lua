local mission_objective_templates = {
	prologue = {
		objectives = {
			objective_prologue_start = {
				description = "loc_objective_prologue_start_desc",
				use_music_event = "prologue_explore",
				mission_objective_type = "goal",
				header = "loc_objective_prologue_start_header"
			},
			objective_prologue_melee = {
				description = "loc_objective_prologue_melee_desc",
				use_music_event = "prologue_explore",
				mission_objective_type = "goal",
				header = "loc_objective_prologue_melee_header"
			},
			objective_prologue_guardhouse_interact = {
				description = "loc_objective_prologue_guardhouse_interact_desc",
				use_music_event = "prologue_explore",
				mission_objective_type = "goal",
				header = "loc_objective_prologue_guardhouse_interact_header"
			},
			objective_prologue_goto_bay = {
				description = "loc_objective_prologue_goto_bay_desc",
				use_music_event = "prologue_explore",
				mission_objective_type = "goal",
				header = "loc_objective_prologue_goto_bay_header"
			},
			objective_prologue_goto_hangar = {
				description = "loc_objective_prologue_goto_hangar_desc",
				use_music_event = "prologue_combat",
				mission_objective_type = "goal",
				header = "loc_objective_prologue_goto_hangar_header"
			},
			objective_prologue_hangar_reach = {
				description = "loc_objective_prologue_hangar_reach_desc",
				use_music_event = "prologue_combat",
				mission_objective_type = "goal",
				header = "loc_objective_prologue_hangar_reach_header"
			},
			objective_prologue_hangar_survive = {
				description = "loc_objective_prologue_hangar_survive_desc",
				use_music_event = "prologue_end_event",
				mission_objective_type = "goal",
				header = "loc_objective_prologue_hangar_survive_header"
			}
		}
	}
}

return mission_objective_templates
