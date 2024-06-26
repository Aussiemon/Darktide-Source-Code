﻿-- chunkname: @scripts/settings/mission_objective/templates/core_research_objective_template.lua

local mission_objective_templates = {
	core_research = {
		objectives = {
			objective_core_research_start = {
				description = "loc_objective_core_research_start_desc",
				header = "loc_objective_core_research_start_header",
				mission_objective_type = "goal",
			},
			objective_core_research_locate_power_central = {
				description = "loc_objective_core_research_locate_power_central_desc",
				header = "loc_objective_core_research_locate_power_central_header",
				mission_objective_type = "goal",
			},
			objective_core_research_activate_transistors = {
				description = "loc_objective_core_research_activate_transistors_desc",
				header = "loc_objective_core_research_activate_transistors_header",
				mission_objective_type = "goal",
			},
			objective_core_research_mid_event_dummy = {
				description = "loc_objective_core_research_activate_transistors_desc",
				event_type = "end_event",
				header = "loc_objective_core_research_activate_transistors_header",
				hidden = true,
				mission_objective_type = "goal",
				music_wwise_state = "fortification_event",
				popups_enabled = false,
			},
			objective_core_research_repair_transistor = {
				description = "loc_objective_core_research_repair_transistor_desc",
				event_type = "end_event",
				header = "loc_objective_core_research_repair_transistor_header",
				mission_objective_type = "goal",
				music_wwise_state = "fortification_event",
			},
			objective_core_research_reactivate_transistors = {
				description = "loc_objective_core_research_reactivate_transistors_desc",
				event_type = "end_event",
				header = "loc_objective_core_research_reactivate_transistors_header",
				mission_objective_type = "goal",
				music_wwise_state = "fortification_event",
			},
			objective_core_research_transfer_power = {
				description = "loc_objective_core_research_transfer_power_desc",
				header = "loc_objective_core_research_transfer_power_header",
				mission_objective_type = "goal",
			},
			objective_core_research_transfer_power2 = {
				description = "loc_objective_core_research_transfer_power2_desc",
				header = "loc_objective_core_research_transfer_power2_header",
				mission_objective_type = "goal",
			},
			objective_core_research_ride_transport = {
				description = "loc_objective_core_research_ride_transport_desc",
				header = "loc_objective_core_research_ride_transport_header",
				mission_objective_type = "goal",
			},
			objective_core_research_enter_machine = {
				description = "loc_objective_core_research_enter_machine_desc",
				header = "loc_objective_core_research_enter_machine_header",
				mission_objective_type = "goal",
			},
			objective_core_research_climb_machine = {
				description = "loc_objective_core_research_climb_machine_desc",
				header = "loc_objective_core_research_climb_machine_header",
				mission_objective_type = "goal",
			},
			objective_core_research_enable_machine = {
				description = "loc_objective_core_research_start_machine_desc",
				header = "loc_objective_core_research_start_machine_header",
				mission_objective_type = "goal",
				turn_off_backfill = true,
			},
			objective_core_research_reach_research = {
				description = "loc_objective_core_research_reach_research_desc",
				header = "loc_objective_core_research_reach_research_header",
				mission_objective_type = "goal",
				turn_off_backfill = true,
			},
			objective_core_research_break_ice = {
				description = "loc_objective_core_research_break_ice_desc",
				header = "loc_objective_core_research_break_ice_header",
				mission_objective_type = "goal",
			},
			objective_core_research_leave_research = {
				description = "loc_objective_core_research_leave_research_desc",
				header = "loc_objective_core_research_leave_research_header",
				mission_objective_type = "goal",
				popups_enabled = false,
				turn_off_backfill = true,
			},
			objective_core_research_excavation_produce_steel_stage_01 = {
				description = "loc_objective_core_research_excavation_produce_steel_desc",
				event_type = "end_event",
				header = "loc_objective_core_research_excavation_produce_steel_header",
				hidden = true,
				mission_objective_type = "goal",
				music_wwise_state = "progression_stage_1",
				popups_enabled = false,
			},
			objective_core_research_excavation_produce_steel_stage_02 = {
				description = "loc_objective_core_research_excavation_produce_steel_desc",
				event_type = "end_event",
				header = "loc_objective_core_research_excavation_produce_steel_header",
				hidden = true,
				mission_objective_type = "goal",
				music_wwise_state = "progression_stage_2",
				popups_enabled = false,
			},
			objective_core_research_excavation_produce_steel_stage_03 = {
				description = "loc_objective_core_research_excavation_produce_steel_desc",
				event_type = "end_event",
				header = "loc_objective_core_research_excavation_produce_steel_header",
				hidden = true,
				mission_objective_type = "goal",
				music_wwise_state = "progression_stage_3b",
				popups_enabled = false,
			},
			objective_core_research_excavation_produce_steel_stage_04 = {
				description = "loc_objective_core_research_excavation_produce_steel_desc",
				event_type = "end_event",
				header = "loc_objective_core_research_excavation_produce_steel_header",
				hidden = true,
				mission_objective_type = "goal",
				music_wwise_state = "progression_stage_4",
				popups_enabled = false,
			},
			objective_core_research_excavation_start_conveyor = {
				description = "loc_objective_core_research_excavation_start_conveyor_desc",
				header = "loc_objective_core_research_excavation_start_conveyor_header",
				mission_objective_type = "goal",
				turn_off_backfill = true,
			},
			objective_core_research_excavation_cables = {
				description = "loc_objective_core_research_excavation_cables_desc",
				event_type = "end_event",
				header = "loc_objective_core_research_excavation_cables_header",
				mission_objective_type = "goal",
			},
			objective_core_research_excavation_decode = {
				description = "loc_objective_core_research_excavation_decode_desc",
				event_type = "end_event",
				header = "loc_objective_core_research_excavation_decode_header",
				mission_objective_type = "decode",
				progress_bar = true,
			},
			objective_core_research_heatshields = {
				description = "loc_objective_core_research_heatshields_desc",
				header = "loc_objective_core_research_heatshields_header",
				mission_objective_type = "goal",
			},
			objective_core_research_heatshields_fake = {
				description = "loc_objective_core_research_heatshields_desc",
				header = "loc_objective_core_research_heatshields_header",
				mission_objective_type = "goal",
			},
			objective_core_research_heatshields_ice = {
				collect_amount = 7,
				description = "loc_objective_core_research_heatshields_ice_desc",
				header = "loc_objective_core_research_heatshields_ice_header",
				mission_objective_type = "collect",
				show_progression_popup_on_update = false,
			},
			objective_core_research_auxiliary_gen = {
				collect_amount = 2,
				description = "loc_objective_core_research_auxiliary_gen_desc",
				header = "loc_objective_core_research_auxiliary_gen_header",
				mission_objective_type = "collect",
				show_progression_popup_on_update = false,
			},
			objective_core_research_auxiliary_gen_timer = {
				description = "loc_objective_core_research_auxiliary_gen_desc",
				duration = 30,
				header = "loc_objective_core_research_auxiliary_gen_header",
				mission_objective_type = "timed",
				popups_enabled = false,
				progress_bar = true,
				show_progression_popup_on_update = false,
			},
			objective_core_research_excavation_luggables = {
				description = "loc_objective_core_research_excavation_luggable_desc",
				event_type = "end_event",
				header = "loc_objective_core_research_excavation_luggable_header",
				mission_objective_type = "luggable",
			},
			objective_core_research_extract = {
				description = "loc_objective_core_research_extract_desc",
				header = "loc_objective_core_research_extract_header",
				mission_objective_type = "goal",
				music_wwise_state = "escape_event",
			},
		},
	},
}

return mission_objective_templates
