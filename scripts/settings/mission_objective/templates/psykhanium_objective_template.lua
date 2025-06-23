-- chunkname: @scripts/settings/mission_objective/templates/psykhanium_objective_template.lua

local HordesModeSettings = require("scripts/settings/hordes_mode_settings")
local mission_objective_templates = {
	psykhanium = {
		objectives = {
			objective_psykhanium_capture_luggables = {
				description = "Capture the luggables",
				mission_objective_type = "luggable",
				header = "Capture the luggables"
			},
			objective_psykhanium_mission_timer = {
				description = "Timer:",
				progress_bar = true,
				header = "Timer:",
				duration = 300,
				mission_objective_type = "timed"
			},
			objective_psykhanium_survive_waves = {
				description = "Survive the waves",
				music_wwise_state = "horde_mode_wave",
				mission_objective_type = "goal",
				header = "Survive the waves"
			},
			objective_psykhanium_start_waves = {
				description = "loc_objective_psykhanium_start_waves_desc",
				mission_objective_type = "goal",
				header = "loc_objective_psykhanium_start_waves_header"
			},
			objective_psykhanium_pull_power_lever_a = {
				description = "loc_objective_psykhanium_pull_power_lever_01_desc",
				mission_objective_type = "goal",
				header = "loc_objective_psykhanium_pull_power_lever_01_header"
			},
			objective_psykhanium_pull_power_lever_b = {
				description = "loc_objective_psykhanium_pull_power_lever_01_desc",
				mission_objective_type = "goal",
				header = "loc_objective_psykhanium_pull_power_lever_01_header"
			},
			objective_psykhanium_pull_power_lever_c = {
				description = "loc_objective_psykhanium_pull_power_lever_01_desc",
				mission_objective_type = "goal",
				header = "loc_objective_psykhanium_pull_power_lever_01_header"
			},
			objective_psykhanium_scanning_a = {
				description = "loc_objective_psykhanium_scanning_01_desc",
				show_progression_popup_on_update = false,
				header = "loc_objective_psykhanium_scanning_01_header",
				event_type = "mid_event",
				mission_objective_type = "scanning"
			},
			objective_psykhanium_scanning_b = {
				description = "loc_objective_psykhanium_scanning_01_desc",
				show_progression_popup_on_update = false,
				header = "loc_objective_psykhanium_scanning_01_header",
				event_type = "mid_event",
				mission_objective_type = "scanning"
			},
			objective_psykhanium_scanning_c = {
				description = "loc_objective_psykhanium_scanning_01_desc",
				show_progression_popup_on_update = false,
				header = "loc_objective_psykhanium_scanning_01_header",
				event_type = "mid_event",
				mission_objective_type = "scanning"
			},
			objective_psykhanium_scanning_d = {
				description = "loc_objective_psykhanium_scanning_01_desc",
				show_progression_popup_on_update = false,
				header = "loc_objective_psykhanium_scanning_01_header",
				event_type = "mid_event",
				mission_objective_type = "scanning"
			},
			objective_psykhanium_scanning_e = {
				description = "loc_objective_psykhanium_scanning_01_desc",
				show_progression_popup_on_update = false,
				header = "loc_objective_psykhanium_scanning_01_header",
				event_type = "mid_event",
				mission_objective_type = "scanning"
			},
			objective_psykhanium_place_memory_shard_01 = {
				description = "loc_objective_psykhanium_place_memory_shard_01_desc",
				mission_objective_type = "goal",
				header = "loc_objective_psykhanium_place_memory_shard_01_header"
			},
			objective_psykhanium_deploy_servo_skull = {
				description = "loc_objective_psykhanium_deploy_servo_skull_desc",
				mission_objective_type = "goal",
				header = "loc_objective_psykhanium_deploy_servo_skull_header"
			},
			objective_psykhanium_place_servo_skull = {
				description = "loc_objective_psykhanium_place_servo_skull_desc",
				mission_objective_type = "goal",
				header = "loc_objective_psykhanium_place_servo_skull_header"
			},
			objective_psykhanium_pull_lever = {
				description = "loc_objective_psykhanium_pull_lever_desc",
				mission_objective_type = "goal",
				header = "loc_objective_psykhanium_pull_lever_header"
			},
			objective_psykhanium_pickup_memory = {
				description = "loc_objective_psykhanium_pickup_memory_desc",
				mission_objective_type = "goal",
				header = "loc_objective_psykhanium_pickup_memory_header"
			},
			objective_psykhanium_enter_portal = {
				description = "loc_objective_psykhanium_enter_portal_desc",
				music_wwise_state = "horde_mode_win",
				mission_objective_type = "goal",
				header = "loc_objective_psykhanium_enter_portal_header"
			},
			objective_psykhanium_place_macguffin = {
				description = "loc_objective_psykhanium_place_macguffin_desc",
				music_wwise_state = "horde_mode_win",
				mission_objective_type = "goal",
				header = "loc_objective_psykhanium_place_macguffin_header"
			},
			objective_psykhanium_wave = {
				hidden = true,
				music_wwise_state = "horde_mode_wave",
				mission_objective_type = "goal",
				hide_widget = true
			},
			objective_psykhanium_objective_wave = {
				hidden = true,
				music_wwise_state = "horde_mode_objective",
				mission_objective_type = "goal",
				hide_widget = true
			},
			objective_psykhanium_last_wave = {
				hidden = true,
				music_wwise_state = "horde_mode_wave_last",
				mission_objective_type = "goal",
				hide_widget = true
			}
		}
	}
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
		popups_enabled = false,
		header = "loc_horde_wave_start",
		mission_objective_type = "goal",
		hide_widget = false,
		header_data = {
			wave = i
		},
		description_data = {
			wave = i
		}
	}

	if i < num_waves then
		objectives[inbetween_objective_name] = {
			description = "loc_horde_wave_completed",
			progress_bar = true,
			popups_enabled = false,
			header = "loc_horde_wave_completed",
			mission_objective_type = "timed",
			hide_widget = true,
			duration = post_wave_pause_duration[i],
			header_data = {
				wave = i + 1
			},
			description_data = {
				wave = i + 1
			}
		}
	end
end

local num_objectives = 5

for i = 1, num_objectives do
	local objectives = mission_objective_templates.psykhanium.objectives
	local decode_obejctive_name = string.format("objective_psykhanium_decode_0%d", i)

	objectives[decode_obejctive_name] = {
		progress_bar = true,
		mission_objective_type = "decode",
		header = string.format("loc_objective_psykhanium_decode_01_header", i),
		description = string.format("loc_objective_psykhanium_decode_01_desc", i)
	}

	local demo_obejctive_name = string.format("objective_psykhanium_demo_0%d", i)

	objectives[demo_obejctive_name] = {
		show_progression_popup_on_update = true,
		mission_objective_type = "demolition",
		header = string.format("loc_objective_psykhanium_demo_01_header", i),
		description = string.format("loc_objective_psykhanium_demo_01_desc", i)
	}

	local pull_power_obejctive_name = string.format("objective_psykhanium_pull_power_lever_0%d", i)

	objectives[pull_power_obejctive_name] = {
		mission_objective_type = "goal",
		header = string.format("loc_objective_psykhanium_pull_power_lever_01_header", i),
		description = string.format("loc_objective_psykhanium_pull_power_lever_01_desc", i)
	}

	local luggable_objective_name = string.format("objective_psykhanium_luggable_0%d", i)

	objectives[luggable_objective_name] = {
		mission_objective_type = "luggable",
		header = string.format("loc_objective_psykhanium_luggable_01_header", i),
		description = string.format("loc_objective_psykhanium_luggable_01_desc", i)
	}

	local ammo_container_objective_name = string.format("objective_psykhanium_ammo_container_0%d", i)

	objectives[ammo_container_objective_name] = {
		popups_enabled = false,
		mission_objective_type = "goal",
		hide_widget = true
	}

	local ammo_container_rooftops_objective_name = string.format("objective_psykhanium_ammo_container_rooftops_0%d", i)

	objectives[ammo_container_rooftops_objective_name] = {
		popups_enabled = false,
		mission_objective_type = "goal",
		hide_widget = true
	}

	local pickup_servo_skull_container_rooftops_objective_name = string.format("objective_psykhanium_pickup_servo_skull_0%d", i)

	objectives[pickup_servo_skull_container_rooftops_objective_name] = {
		mission_objective_type = "goal",
		header = string.format("loc_objective_psykhanium_pickup_servo_skull_01_header", i),
		description = string.format("loc_objective_psykhanium_pickup_servo_skull_01_desc", i)
	}

	local void_zone_objective_name = string.format("objective_psykhanium_void_zone_0%d", i)

	objectives[void_zone_objective_name] = {
		progress_bar = true,
		event_type = "mid_event",
		duration = 60,
		mission_objective_type = "capture",
		header = string.format("loc_objective_psykhanium_void_zone_01_header", i),
		description = string.format("loc_objective_psykhanium_void_zone_01_desc", i)
	}

	local rooftops_zone_objective_name = string.format("objective_psykhanium_rooftops_zone_0%d", i)

	objectives[rooftops_zone_objective_name] = {
		progress_bar = true,
		event_type = "mid_event",
		duration = 60,
		mission_objective_type = "capture",
		header = string.format("loc_objective_psykhanium_rooftops_zone_01_header", i),
		description = string.format("loc_objective_psykhanium_rooftops_zone_01_desc", i)
	}
end

return mission_objective_templates
