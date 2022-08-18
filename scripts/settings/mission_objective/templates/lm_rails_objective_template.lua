local mission_objective_templates = {
	lm_rails = {
		main_objective_type = "luggable_objective",
		objectives = {
			objective_lm_rails_find_rail_tunnels = {
				description = "loc_objective_lm_rails_find_rail_tunnels_desc",
				mission_objective_type = "goal",
				header = "loc_objective_lm_rails_find_rail_tunnels_header"
			},
			objective_lm_rails_descend_elevator_shaft = {
				description = "loc_objective_lm_rails_descend_elevator_shaft_desc",
				mission_objective_type = "goal",
				header = "loc_objective_lm_rails_descend_elevator_shaft_header"
			},
			objective_lm_rails_hack_door = {
				description = "loc_objective_lm_rails_hack_door_desc",
				use_music_event = "hacking_event",
				header = "loc_objective_lm_rails_hack_door_header",
				event_type = "mid_event",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_lm_rails_open_mid_airlock = {
				description = "loc_objective_lm_rails_open_mid_airlock_desc",
				mission_objective_type = "goal",
				header = "loc_objective_lm_rails_open_mid_airlock_header"
			},
			objective_lm_rails_through_railways = {
				description = "loc_objective_lm_rails_through_railways_desc",
				mission_objective_type = "goal",
				header = "loc_objective_lm_rails_through_railways_header"
			},
			objective_lm_rails_through_abandoned_railway = {
				description = "loc_objective_lm_rails_through_abandoned_railway_desc",
				mission_objective_type = "goal",
				header = "loc_objective_lm_rails_through_abandoned_railway_header"
			},
			objective_lm_rails_find_control_cogitator = {
				description = "loc_objective_lm_rails_find_control_cogitator_desc",
				mission_objective_type = "goal",
				header = "loc_objective_lm_rails_find_control_cogitator_header"
			},
			objective_lm_rails_reach_logistratum = {
				description = "loc_objective_lm_rails_reach_logistratum_desc",
				mission_objective_type = "goal",
				header = "loc_objective_lm_rails_reach_logistratum_header"
			},
			objective_lm_rails_deactivate_skyfire = {
				description = "loc_objective_lm_rails_deactivate_skyfire_desc",
				mission_objective_type = "goal",
				header = "loc_objective_lm_rails_deactivate_skyfire_header"
			},
			objective_lm_rails_collect_cargo = {
				use_music_event = "collect_event",
				description = "loc_objective_lm_rails_collect_cargo_desc",
				turn_off_backfill = true,
				header = "loc_objective_lm_rails_collect_cargo_header",
				event_type = "end_event",
				mission_objective_type = "luggable"
			},
			objective_lm_rails_escape_valkyrie = {
				description = "loc_objective_lm_rails_escape_valkyrie_desc",
				use_music_event = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_lm_rails_escape_valkyrie_header"
			}
		}
	}
}

return mission_objective_templates
