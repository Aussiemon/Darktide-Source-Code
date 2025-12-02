-- chunkname: @scripts/settings/mission_objective/templates/op_no_mans_land_objective_template.lua

local mission_objective_templates = {
	op_no_mans_land = {
		objectives = {
			objective_op_no_mans_land_start = {
				description = "loc_objective_op_no_mans_land_start_desc",
				header = "loc_objective_op_no_mans_land_start_header",
				mission_objective_type = "goal",
				music_wwise_state = "operation_2_stage_1",
			},
			objective_op_no_mans_trenches = {
				description = "loc_objective_op_no_mans_trenches_desc",
				header = "loc_objective_op_no_mans_trenches_header",
				mission_objective_type = "goal",
				music_wwise_state = "operation_2_stage_1",
			},
			objective_op_no_mans_ruined_archway_music = {
				hidden = true,
				hide_widget = true,
				mission_objective_type = "goal",
				music_wwise_state = "operation_2_stage_2",
			},
			objective_op_no_mans_ruined_archway = {
				description = "loc_objective_op_no_mans_ruined_archway_desc",
				header = "loc_objective_op_no_mans_ruined_archway_header",
				mission_objective_type = "goal",
			},
			objective_op_no_mans_ruined_archway_bridge = {
				description = "loc_objective_op_no_mans_ruined_archway_bridge_desc",
				header = "loc_objective_op_no_mans_ruined_archway_bridge_header",
				mission_objective_type = "goal",
			},
			objective_op_no_mans_dead_zone = {
				description = "loc_objective_op_no_mans_dead_zone_desc",
				header = "loc_objective_op_no_mans_dead_zone_header",
				mission_objective_type = "goal",
			},
			objective_op_no_mans_dead_zone_breaching_charge = {
				description = "loc_objective_op_no_mans_dead_zone_breaching_charge_desc",
				header = "loc_objective_op_no_mans_dead_zone_breaching_charge_header",
				mission_objective_type = "goal",
			},
			objective_op_no_mans_dead_zone_music = {
				hidden = true,
				hide_widget = true,
				mission_objective_type = "goal",
				music_wwise_state = "operation_2_stage_3",
			},
			objective_op_no_mans_clear_bastion = {
				description = "loc_objective_op_no_mans_clear_bastion_desc",
				header = "loc_objective_op_no_mans_clear_bastion_header",
				mission_objective_type = "goal",
			},
			objective_op_no_mans_locate_basement = {
				description = "loc_objective_op_no_mans_locate_basement_desc",
				header = "loc_objective_op_no_mans_locate_basement_header",
				mission_objective_type = "goal",
			},
			objective_op_no_mans_collect_coordinates = {
				collect_amount = 4,
				description = "loc_objective_op_no_mans_collect_coordinates_desc",
				header = "loc_objective_op_no_mans_collect_coordinates_header",
				icon = "content/ui/materials/icons/objectives/secondary",
				mission_objective_type = "collect",
			},
			objective_op_no_mans_light_flare = {
				description = "loc_objective_op_no_mans_light_flare_desc",
				header = "loc_objective_op_no_mans_light_flare_header",
				mission_objective_type = "goal",
			},
			objective_op_no_mans_reach_valkyrie = {
				description = "loc_objective_op_no_mans_reach_valkyrie_desc",
				header = "loc_objective_op_no_mans_reach_valkyrie_header",
				mission_objective_type = "goal",
				music_wwise_state = "escape_event",
			},
			objective_op_no_mans_endevent_music = {
				hidden = true,
				hide_widget = true,
				mission_objective_type = "goal",
				music_wwise_state = "operation_2_stage_4",
			},
		},
	},
}

return mission_objective_templates
