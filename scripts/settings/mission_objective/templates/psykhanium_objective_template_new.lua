-- chunkname: @scripts/settings/mission_objective/templates/psykhanium_objective_template_new.lua

local HordesModeSettings = require("scripts/settings/hordes_mode_settings")
local mission_objective_templates = {
	psykhanium = {
		objectives = {
			objective_psykhanium_capture_luggables = {
				description = "Capture the luggables",
				header = "Capture the luggables",
				mission_objective_type = "luggable",
			},
			objective_psykhanium_mission_timer = {
				description = "Timer:",
				duration = 300,
				header = "Timer:",
				mission_objective_type = "timed",
				progress_bar = true,
			},
			objective_psykhanium_survive_waves = {
				description = "Survive the waves",
				header = "Survive the waves",
				mission_objective_type = "goal",
				music_wwise_state = "horde_mode_wave",
			},
			objective_psykhanium_start_waves = {
				description = "loc_objective_psykhanium_start_waves_desc",
				header = "loc_objective_psykhanium_start_waves_header",
				mission_objective_type = "goal",
			},
			objective_psykhanium_pull_power_lever_a = {
				description = "loc_objective_psykhanium_pull_power_lever_01_desc",
				header = "loc_objective_psykhanium_pull_power_lever_01_header",
				mission_objective_type = "goal",
			},
			objective_psykhanium_pull_power_lever_b = {
				description = "loc_objective_psykhanium_pull_power_lever_01_desc",
				header = "loc_objective_psykhanium_pull_power_lever_01_header",
				mission_objective_type = "goal",
			},
			objective_psykhanium_pull_power_lever_c = {
				description = "loc_objective_psykhanium_pull_power_lever_01_desc",
				header = "loc_objective_psykhanium_pull_power_lever_01_header",
				mission_objective_type = "goal",
			},
			objective_psykhanium_scanning_a = {
				description = "loc_objective_psykhanium_scanning_01_desc",
				event_type = "mid_event",
				header = "loc_objective_psykhanium_scanning_01_header",
				mission_objective_type = "scanning",
				show_progression_popup_on_update = false,
			},
			objective_psykhanium_scanning_b = {
				description = "loc_objective_psykhanium_scanning_01_desc",
				event_type = "mid_event",
				header = "loc_objective_psykhanium_scanning_01_header",
				mission_objective_type = "scanning",
				show_progression_popup_on_update = false,
			},
			objective_psykhanium_scanning_c = {
				description = "loc_objective_psykhanium_scanning_01_desc",
				event_type = "mid_event",
				header = "loc_objective_psykhanium_scanning_01_header",
				mission_objective_type = "scanning",
				show_progression_popup_on_update = false,
			},
			objective_psykhanium_scanning_d = {
				description = "loc_objective_psykhanium_scanning_01_desc",
				event_type = "mid_event",
				header = "loc_objective_psykhanium_scanning_01_header",
				mission_objective_type = "scanning",
				show_progression_popup_on_update = false,
			},
			objective_psykhanium_scanning_e = {
				description = "loc_objective_psykhanium_scanning_01_desc",
				event_type = "mid_event",
				header = "loc_objective_psykhanium_scanning_01_header",
				mission_objective_type = "scanning",
				show_progression_popup_on_update = false,
			},
			objective_psykhanium_machine_scanning = {
				description = "loc_objective_psykhanium_scanning_01_desc",
				event_type = "mid_event",
				header = "loc_objective_psykhanium_scanning_01_header",
				mission_objective_type = "scanning",
				show_progression_popup_on_update = false,
			},
			objective_psykhanium_place_memory_shard_01 = {
				description = "loc_objective_psykhanium_place_memory_shard_01_desc",
				header = "loc_objective_psykhanium_place_memory_shard_01_header",
				mission_objective_type = "goal",
			},
			objective_psykhanium_deploy_servo_skull = {
				description = "loc_objective_psykhanium_deploy_servo_skull_desc",
				header = "loc_objective_psykhanium_deploy_servo_skull_header",
				mission_objective_type = "goal",
			},
			objective_psykhanium_place_servo_skull = {
				description = "loc_objective_psykhanium_place_servo_skull_desc",
				header = "loc_objective_psykhanium_place_servo_skull_header",
				mission_objective_type = "goal",
			},
			objective_psykhanium_pull_lever = {
				description = "loc_objective_psykhanium_pull_lever_desc",
				header = "loc_objective_psykhanium_pull_lever_header",
				mission_objective_type = "goal",
			},
			objective_psykhanium_luggable_machine = {
				description = "loc_objective_psykhanium_luggable_machine_desc",
				event_type = "mid_event",
				header = "loc_objective_psykhanium_luggable_machine_header",
				mission_objective_type = "luggable",
			},
			objective_psykhanium_machine_activate_power = {
				description = "loc_objective_psykhanium_machine_activate_power_desc",
				header = "loc_objective_psykhanium_machine_activate_power_header",
				mission_objective_type = "goal",
			},
			objective_psykhanium_machine_open_gate = {
				description = "loc_objective_psykhanium_machine_open_gate_desc",
				header = "loc_objective_psykhanium_machine_open_gate_header",
				mission_objective_type = "goal",
			},
			objective_psykhanium_machine_destroy_ice = {
				description = "loc_objective_psykhanium_machine_destroy_ice_desc",
				header = "loc_objective_psykhanium_machine_destroy_ice_header",
				mission_objective_type = "goal",
			},
			objective_psykhanium_machine_activate_engine = {
				description = "loc_objective_psykhanium_pull_power_lever_01_desc",
				header = "loc_objective_psykhanium_pull_power_lever_01_header",
				mission_objective_type = "goal",
			},
			objective_psykhanium_pickup_memory = {
				description = "loc_objective_psykhanium_pickup_memory_desc",
				header = "loc_objective_psykhanium_pickup_memory_header",
				mission_objective_type = "goal",
			},
			objective_psykhanium_enter_portal = {
				description = "loc_objective_psykhanium_enter_portal_desc",
				header = "loc_objective_psykhanium_enter_portal_header",
				mission_objective_type = "goal",
				music_wwise_state = "horde_mode_win",
			},
			objective_psykhanium_place_macguffin = {
				description = "loc_objective_psykhanium_place_macguffin_desc",
				header = "loc_objective_psykhanium_place_macguffin_header",
				mission_objective_type = "goal",
				music_wwise_state = "horde_mode_win",
			},
			objective_psykhanium_wave = {
				hidden = true,
				hide_widget = true,
				mission_objective_type = "goal",
				music_wwise_state = "horde_mode_wave",
			},
			objective_psykhanium_objective_wave = {
				hidden = true,
				hide_widget = true,
				mission_objective_type = "goal",
				music_wwise_state = "horde_mode_objective",
			},
			objective_psykhanium_last_wave = {
				hidden = true,
				hide_widget = true,
				mission_objective_type = "goal",
				music_wwise_state = "horde_mode_wave_last",
			},
		},
	},
}
local num_waves = HordesModeSettings.waves_per_island

for i = 1, num_waves do
	local objectives = mission_objective_templates.psykhanium.objectives
	local objective_name_formating_function = HordesModeSettings.mission_objectives.name_formating_function
	local start_objective_name = objective_name_formating_function(HordesModeSettings.mission_objectives.wave_objective.name, i)
	local inbetween_objective_name = objective_name_formating_function(HordesModeSettings.mission_objectives.between_waves_objective.name, i)
	local post_wave_pause_duration = HordesModeSettings.post_wave_pause_duration

	objectives[start_objective_name] = {
		description = "loc_horde_wave_start",
		header = "loc_horde_wave_start",
		hide_widget = false,
		mission_objective_type = "goal",
		popups_enabled = false,
		header_data = {
			wave = i,
		},
		description_data = {
			wave = i,
		},
	}

	if i < num_waves then
		objectives[inbetween_objective_name] = {
			description = "loc_horde_wave_completed",
			header = "loc_horde_wave_completed",
			hide_widget = true,
			mission_objective_type = "timed",
			popups_enabled = false,
			progress_bar = true,
			duration = post_wave_pause_duration[i],
			header_data = {
				wave = i + 1,
			},
			description_data = {
				wave = i + 1,
			},
		}
	end
end

local num_objectives = 5

for i = 1, num_objectives do
	local objectives = mission_objective_templates.psykhanium.objectives
	local decode_obejctive_name = string.format("objective_psykhanium_decode_0%d", i)

	objectives[decode_obejctive_name] = {
		mission_objective_type = "decode",
		progress_bar = true,
		header = string.format("loc_objective_psykhanium_decode_01_header", i),
		description = string.format("loc_objective_psykhanium_decode_01_desc", i),
	}

	local demo_obejctive_name = string.format("objective_psykhanium_demo_0%d", i)

	objectives[demo_obejctive_name] = {
		mission_objective_type = "demolition",
		show_progression_popup_on_update = true,
		header = string.format("loc_objective_psykhanium_demo_01_header", i),
		description = string.format("loc_objective_psykhanium_demo_01_desc", i),
	}

	local pull_power_obejctive_name = string.format("objective_psykhanium_pull_power_lever_0%d", i)

	objectives[pull_power_obejctive_name] = {
		mission_objective_type = "goal",
		header = string.format("loc_objective_psykhanium_pull_power_lever_01_header", i),
		description = string.format("loc_objective_psykhanium_pull_power_lever_01_desc", i),
	}

	local luggable_objective_name = string.format("objective_psykhanium_luggable_0%d", i)

	objectives[luggable_objective_name] = {
		mission_objective_type = "luggable",
		header = string.format("loc_objective_psykhanium_luggable_01_header", i),
		description = string.format("loc_objective_psykhanium_luggable_01_desc", i),
	}

	local ammo_container_objective_name = string.format("objective_psykhanium_ammo_container_0%d", i)

	objectives[ammo_container_objective_name] = {
		hide_widget = true,
		mission_objective_type = "goal",
		popups_enabled = false,
	}

	local ammo_container_rooftops_objective_name = string.format("objective_psykhanium_ammo_container_rooftops_0%d", i)

	objectives[ammo_container_rooftops_objective_name] = {
		hide_widget = true,
		mission_objective_type = "goal",
		popups_enabled = false,
	}

	local ammo_container_machine_objective_name = string.format("objective_psykhanium_ammo_container_machine_0%d", i)

	objectives[ammo_container_machine_objective_name] = {
		hide_widget = true,
		mission_objective_type = "goal",
		popups_enabled = false,
	}

	local pickup_servo_skull_container_rooftops_objective_name = string.format("objective_psykhanium_pickup_servo_skull_0%d", i)

	objectives[pickup_servo_skull_container_rooftops_objective_name] = {
		mission_objective_type = "goal",
		header = string.format("loc_objective_psykhanium_pickup_servo_skull_01_header", i),
		description = string.format("loc_objective_psykhanium_pickup_servo_skull_01_desc", i),
	}

	local void_zone_objective_name = string.format("objective_psykhanium_void_zone_0%d", i)

	objectives[void_zone_objective_name] = {
		duration = 60,
		event_type = "mid_event",
		mission_objective_type = "capture",
		progress_bar = true,
		header = string.format("loc_objective_psykhanium_void_zone_01_header", i),
		description = string.format("loc_objective_psykhanium_void_zone_01_desc", i),
	}

	local rooftops_zone_objective_name = string.format("objective_psykhanium_rooftops_zone_0%d", i)

	objectives[rooftops_zone_objective_name] = {
		duration = 60,
		event_type = "mid_event",
		mission_objective_type = "capture",
		progress_bar = true,
		header = string.format("loc_objective_psykhanium_rooftops_zone_01_header", i),
		description = string.format("loc_objective_psykhanium_rooftops_zone_01_desc", i),
	}
end

return mission_objective_templates
