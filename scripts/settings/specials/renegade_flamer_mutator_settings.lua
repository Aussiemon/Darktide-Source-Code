-- chunkname: @scripts/settings/specials/renegade_flamer_mutator_settings.lua

local STATES = table.index_lookup_table("passive", "aiming", "shooting")
local renegade_flamer_mutator_settings = {
	fx_source_name = "muzzle",
	inventory_slot = "slot_ranged_weapon",
	min_range = 3,
	radius = 0.2,
	range = 20,
	set_muzzle_as_control_point_1 = true,
	states = STATES,
	vfx = {
		flamer_particle = "content/fx/particles/enemies/renegade_flamer/renegade_flame_thrower",
		flamer_velocity_variable_name = "velocity",
		ground_impact_particle = "content/fx/particles/enemies/renegade_flamer/renegade_flame_thrower_hit",
		ground_impact_velocity_variable_name = "velocity",
		num_parabola_control_points = 4,
	},
	sfx = {
		aim_sfx_event = "wwise/events/weapon/play_minion_flamethrower_mutator_wind_up",
		looping_sfx_start_event = "wwise/events/weapon/play_minion_flamethrower_mutator_start",
		looping_sfx_stop_event = "wwise/events/weapon/play_minion_flamethrower_mutator_stop",
	},
	trajectory_config = {
		acceptable_accuracy = 1,
		gravity = 8.82,
		initial_speed = 12,
	},
}

return settings("RenegadeFlamerMutatorSettings", renegade_flamer_mutator_settings)
