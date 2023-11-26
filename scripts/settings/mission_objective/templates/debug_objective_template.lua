-- chunkname: @scripts/settings/mission_objective/templates/debug_objective_template.lua

local mission_objective_templates = {
	debug = {
		objectives = {
			kill_objective = {
				description = "loc_kill_mission_desc",
				use_music_event = "kill_mission",
				mission_objective_type = "kill",
				header = "loc_kill_mission_header"
			},
			objective_cm_locate_scanner = {
				description = "loc_objective_debug_locate_scanner_desc",
				use_music_event = "None",
				mission_objective_type = "goal",
				header = "loc_objective_debug_locate_scanner_header"
			},
			objective_goal_objective_one = {
				description = "loc_objective_debug_locate_scanner_desc",
				mission_objective_type = "goal",
				header = "loc_objective_debug_locate_scanner_header"
			},
			objective_goal_objective_two = {
				description = "loc_objective_debug_locate_scanner_desc",
				mission_objective_type = "goal",
				header = "loc_objective_debug_locate_scanner_header"
			},
			capture_objective = {
				use_music_event = "control_mission",
				description = "loc_objective_zone_capture_desc",
				has_second_progression = true,
				header = "loc_objective_zone_capture_header",
				show_progression_popup_on_update = false,
				progress_bar = true,
				mission_objective_type = "scanning"
			},
			capture_objective_spline = {
				use_music_event = "control_mission",
				description = "loc_objective_zone_capture_desc",
				has_second_progression = true,
				header = "loc_objective_zone_capture_header",
				show_progression_popup_on_update = false,
				progress_bar = true,
				mission_objective_type = "scanning"
			},
			scanning_objective_spline = {
				use_music_event = "control_mission",
				description = "loc_objective_zone_scanning_desc",
				mission_giver_voice_profile = "tech_priest_a",
				header = "loc_objective_zone_scanning_header",
				show_progression_popup_on_update = false,
				mission_objective_type = "scanning"
			},
			find_event_area_objective = {
				description = "loc_objective_debug_area_objective_desc",
				use_music_event = "vip_mission",
				mission_objective_type = "goal",
				header = "loc_objective_debug_area_objective_header"
			},
			demolition_objective_test_1 = {
				description = "loc_objective_debug_demolition_test_1_desc",
				use_music_event = "purge_mission",
				mission_objective_type = "demolition",
				header = "loc_objective_debug_demolition_test_1_header"
			},
			destination_objective_test = {
				description = "loc_objective_debug_destination_test_desc",
				finish_distance = 1,
				header = "loc_objective_debug_destination_test_header",
				progress_bar = true,
				mission_objective_type = "destination"
			},
			destination_objective_test_local = {
				description = "loc_objective_debug_destination_test_desc",
				finish_distance = 1,
				header = "loc_objective_debug_destination_test_header",
				progress_bar = true,
				mission_objective_type = "destination"
			},
			objective_jacopo_interact_deactivate_first_protocol = {
				description = "Interact with the lever.",
				mission_objective_type = "goal",
				header = "Deactivate the first security protocols."
			},
			objective_jacopo_deactivate_second_protocol = {
				description = "Plant the data interrogators.",
				progress_bar = true,
				mission_objective_type = "decode",
				header = "Bypass the second security protocols."
			},
			objective_jacopo_first_interact_deactivate_second_protocol = {
				description = "Interact with the lever.",
				mission_objective_type = "goal",
				header = "Deactivate the second security protocols."
			},
			objective_jacopo_second_interact_deactivate_second_protocol = {
				description = "Interact with the lever.",
				mission_objective_type = "goal",
				header = "Deactivate the second security protocols."
			},
			objective_jacopo_plant_misinformation = {
				description = "Wait and defend the central data center.",
				progress_bar = true,
				mission_objective_type = "decode",
				header = "Plant the misinformation."
			},
			objective_jacopo_extract = {
				description = "Escape!",
				mission_objective_type = "goal",
				header = "Escape!"
			},
			objective_ship_port_arena_main = {
				description = "Survive while data is being transferred",
				mission_objective_type = "luggable",
				header = "Ensure Vox Array Data Transfer"
			},
			objective_harvest_hack_first = {
				description = "Hack the gate",
				progress_bar = true,
				mission_objective_type = "decode",
				header = "Hack the gate"
			},
			objective_harvest_hack_second = {
				description = "Hack the gate",
				progress_bar = true,
				mission_objective_type = "decode",
				header = "Hack the gate"
			},
			objective_harvest_hack_third = {
				description = "Hack your way forward",
				progress_bar = true,
				mission_objective_type = "decode",
				header = "Hack your way forward"
			},
			objective_kristoffer_plant_charges = {
				description = "Plant the charges.",
				mission_objective_type = "goal",
				header = "Plant the charges."
			},
			objective_kristoffer_use_detonator = {
				description = "Use your detonator.",
				mission_objective_type = "goal",
				header = "Use your detonator (Capslock)"
			},
			objective_kristoffer_lower_side_platforms = {
				description = "Lower the side platforms.",
				progress_bar = true,
				mission_objective_type = "decode",
				header = "Lower the side platforms."
			},
			objective_kristoffer_proceed_forward = {
				description = "Fight your way forward.",
				mission_objective_type = "goal",
				header = "Fight your way forward."
			}
		}
	}
}

return mission_objective_templates
