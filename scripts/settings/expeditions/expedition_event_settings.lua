-- chunkname: @scripts/settings/expeditions/expedition_event_settings.lua

local toxic_gas_level_grid_settings = {
	cell_depth = 4,
	height = 256,
	num_columns = 2,
	num_rows = 2,
	track_players = false,
	width = 256,
}
local gas_by_depth = {
	{
		broadphase_radius = 50,
		level_name = "content/levels/expeditions/circumstances/toxic_gas/exp_circ_toxic_gas_fog_spawner_large",
		respawn_delay = {
			max = 45,
			min = 30,
		},
		lifetime = {
			max = 40,
			min = 20,
		},
	},
	{
		broadphase_radius = 40,
		level_name = "content/levels/expeditions/circumstances/toxic_gas/exp_circ_toxic_gas_fog_spawner_medium",
		respawn_delay = {
			max = 25,
			min = 15,
		},
		lifetime = {
			max = 20,
			min = 10,
		},
	},
	{
		broadphase_radius = 25,
		level_name = "content/levels/expeditions/circumstances/toxic_gas/exp_circ_toxic_gas_fog_spawner_small",
		respawn_delay = {
			max = 15,
			min = 10,
		},
		lifetime = {
			max = 15,
			min = 10,
		},
	},
}
local gas_settings_by_depth = {}
local index_counter = 0

for i = toxic_gas_level_grid_settings.cell_depth, 1, -1 do
	index_counter = index_counter + 1
	gas_settings_by_depth[i] = gas_by_depth[#gas_by_depth - index_counter]
end

local expedition_event_settings = {
	toxic_gas = {
		broadphase_category = "toxic_gas",
		broadphase_delay = 1.5,
		player_broadphase_radius = 10,
		wakeup_time = 3,
		level_grid_settings = toxic_gas_level_grid_settings,
		gas_settings_by_depth = gas_settings_by_depth,
	},
	spawn_sand_vortex = {
		spawn_delay = 30,
		spawn_distance_infront_of_selected_player_target = 30,
		wait_time_on_spawn_failed = 2,
	},
	spawn_nurgle_flies = {
		spawn_delay = 10,
		spawn_distance_infront_of_selected_player_target = 30,
		wait_time_on_spawn_failed = 2,
	},
	lightning_strikes_looping = {
		backdrop_lightning_strike_frequency = 5,
		lightning_strike_frequency = 4,
		storm_sound_duration = 8,
		storm_sound_frequency = 12,
		storm_sound_start = "wwise/events/world/play_lightning_storm_thunder",
		storm_sound_stop = "wwise/events/world/stop_lightning_storm_thunder",
	},
	lightning_strikes = {
		additional_life_time = 0,
		additional_spawn_height = 50,
		buildup_sound = "wwise/events/world/play_lightning_storm_build_up",
		buildup_stop_sound = "wwise/events/world/stop_lightning_storm_build_up",
		end_time = 3,
		impact_decal_unit_name = "content/fx/units/environment/expeditions/wastes/decal_lightning_strike_charge",
		impact_radius = 5,
		lightning_particle = "content/fx/particles/environment/expeditions/wastes/lightning_strike_ground_indicator_charge",
		lightning_unit_name = "content/fx/units/environment/expeditions/wastes/vfx_lightning_strike_ground_large_01",
		strike_sound = "wwise/events/world/play_lightning_storm_strike",
		amount_of_strikes = {
			max = 1,
			min = 1,
		},
		distance_from_each_player = {
			max = 0,
			min = 0,
		},
		initial_life_time = {
			max = 2.5,
			min = 2.5,
		},
		explosion_settings = {
			charge_level = 1,
			power_level = 1000,
			template_name = "lightning_strike_impact",
		},
	},
	lightning_strikes_backdrop = {
		end_time = 1,
		lightning_unit_name = "content/fx/units/environment/expeditions/wastes/vfx_lightning_strike_ground_large_01",
		strike_sound = "wwise/events/world/play_lightning_storm_strike",
		amount_of_strikes = {
			max = 15,
			min = 8,
		},
		distance_from_level_origo = {
			max = 256,
			min = 0,
		},
		initial_life_time = {
			max = 5,
			min = 0.1,
		},
	},
	lightning_strikes_targeted_random_player_looping = {
		event_to_trigger = "lightning_strikes_targeted_random_player",
		lightning_strike_frequency = 10,
		loop_duration = {
			loop_duration_max = 120,
			loop_duration_min = 40,
			pause_duration_max = 100,
			pause_duration_min = 60,
		},
		sfx = {
			storm_loop_headstart = 5,
			storm_start_event = "wwise/events/world/play_lightning_storm_thunder",
			storm_stop_event = "wwise/events/world/stop_lightning_storm_thunder",
		},
		additional_random_strikes = {
			event_to_trigger = "lightning_strikes_naive",
			lightning_strike_frequency = 3,
		},
	},
	lightning_strikes_naive = {
		additional_life_time = 0,
		additional_spawn_height = 50,
		buildup_sound = "wwise/events/world/play_lightning_storm_build_up",
		buildup_stop_sound = "wwise/events/world/stop_lightning_storm_build_up",
		end_time = 3,
		impact_decal_unit_name = "content/fx/units/environment/expeditions/wastes/decal_lightning_strike_charge",
		impact_radius = 5,
		lightning_particle = "content/fx/particles/environment/expeditions/wastes/lightning_strike_ground_indicator_charge",
		lightning_unit_name = "content/fx/units/environment/expeditions/wastes/vfx_lightning_strike_ground_large_01",
		startup_delay_max = 2,
		strike_sound = "wwise/events/world/play_lightning_storm_strike",
		amount_of_strikes = {
			max = 10,
			min = 10,
		},
		distance_from_level_origo = {
			max = 256,
			min = 0,
		},
		initial_life_time = {
			max = 2.5,
			min = 2.5,
		},
		explosion_settings = {
			charge_level = 1,
			power_level = 500,
			template_name = "lightning_strike_impact",
		},
	},
	lightning_strikes_targeted_random_player = {
		additional_life_time = 0,
		additional_spawn_height = 50,
		buildup_sound = "wwise/events/world/play_lightning_storm_build_up",
		buildup_stop_sound = "wwise/events/world/stop_lightning_storm_build_up",
		end_time = 3,
		impact_decal_unit_name = "content/fx/units/environment/expeditions/wastes/decal_lightning_strike_charge",
		impact_radius = 5,
		lightning_particle = "content/fx/particles/environment/expeditions/wastes/lightning_strike_ground_indicator_charge",
		lightning_unit_name = "content/fx/units/environment/expeditions/wastes/vfx_lightning_strike_ground_large_01",
		startup_delay_max = 4,
		strike_sound = "wwise/events/world/play_lightning_storm_strike",
		amount_of_strikes = {
			max = 3,
			min = 3,
		},
		distance_from_each_player = {
			max = 25,
			min = 0,
		},
		initial_life_time = {
			max = 2.5,
			min = 2.5,
		},
		explosion_settings = {
			charge_level = 1,
			power_level = 500,
			template_name = "lightning_strike_impact",
		},
	},
}

return settings("ExpeditionEventSettings", expedition_event_settings)
