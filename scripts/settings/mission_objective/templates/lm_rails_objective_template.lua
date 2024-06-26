-- chunkname: @scripts/settings/mission_objective/templates/lm_rails_objective_template.lua

local mission_objective_templates = {
	lm_rails = {
		objectives = {
			objective_lm_rails_find_rail_tunnels = {
				description = "loc_objective_lm_rails_find_rail_tunnels_desc",
				header = "loc_objective_lm_rails_find_rail_tunnels_header",
				mission_objective_type = "goal",
			},
			objective_lm_rails_descend_elevator_shaft = {
				description = "loc_objective_lm_rails_descend_elevator_shaft_desc",
				header = "loc_objective_lm_rails_descend_elevator_shaft_header",
				mission_objective_type = "goal",
			},
			objective_lm_rails_hack_door = {
				description = "loc_objective_lm_rails_hack_door_desc",
				event_type = "mid_event",
				header = "loc_objective_lm_rails_hack_door_header",
				mission_objective_type = "decode",
				music_wwise_state = "hacking_event",
				progress_bar = true,
			},
			objective_lm_rails_open_mid_airlock = {
				description = "loc_objective_lm_rails_open_mid_airlock_desc",
				header = "loc_objective_lm_rails_open_mid_airlock_header",
				mission_objective_type = "goal",
			},
			objective_lm_rails_through_railways = {
				description = "loc_objective_lm_rails_through_railways_desc",
				header = "loc_objective_lm_rails_through_railways_header",
				mission_objective_type = "goal",
			},
			objective_lm_rails_through_abandoned_railway = {
				description = "loc_objective_lm_rails_through_abandoned_railway_desc",
				header = "loc_objective_lm_rails_through_abandoned_railway_header",
				mission_objective_type = "goal",
			},
			objective_lm_rails_find_control_cogitator = {
				description = "loc_objective_lm_rails_find_control_cogitator_desc",
				header = "loc_objective_lm_rails_find_control_cogitator_header",
				mission_objective_type = "goal",
			},
			objective_lm_rails_reach_logistratum = {
				description = "loc_objective_lm_rails_reach_logistratum_desc",
				header = "loc_objective_lm_rails_reach_logistratum_header",
				mission_objective_type = "goal",
			},
			objective_lm_rails_deactivate_skyfire = {
				description = "loc_objective_lm_rails_deactivate_skyfire_desc",
				header = "loc_objective_lm_rails_deactivate_skyfire_header",
				mission_objective_type = "goal",
			},
			objective_lm_rails_collect_cargo = {
				description = "loc_objective_lm_rails_collect_cargo_desc",
				event_type = "end_event",
				header = "loc_objective_lm_rails_collect_cargo_header",
				mission_objective_type = "luggable",
				music_wwise_state = "collect_event",
				turn_off_backfill = true,
			},
			objective_lm_rails_escape_valkyrie = {
				description = "loc_objective_lm_rails_escape_valkyrie_desc",
				header = "loc_objective_lm_rails_escape_valkyrie_header",
				mission_objective_type = "goal",
				music_wwise_state = "escape_event",
			},
		},
	},
}

return mission_objective_templates
