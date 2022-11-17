local STATES = table.index_lookup_table("passive", "aiming", "shooting")
local renegade_flamer_settings = {
	min_range = 3,
	radius = 0.2,
	range = 20,
	set_muzzle_as_control_point_1 = true,
	inventory_slot = "slot_ranged_weapon",
	fx_source_name = "muzzle",
	states = STATES,
	vfx = {
		flamer_particle = "content/fx/particles/enemies/renegade_flamer/renegade_flame_thrower",
		ground_impact_particle = "content/fx/particles/enemies/renegade_flamer/renegade_flame_thrower_hit",
		num_parabola_control_points = 4
	},
	sfx = {
		looping_sfx_stop_event = "wwise/events/weapon/play_minion_flamethrower_stop",
		looping_sfx_start_event = "wwise/events/weapon/play_minion_flamethrower_start",
		aim_sfx_event = "wwise/events/weapon/play_minion_flamethrower_green_wind_up"
	},
	trajectory_config = {
		gravity = 8.82,
		acceptable_accuracy = 1,
		initial_speed = 12
	}
}

return settings("RenegadeFlamerSettings", renegade_flamer_settings)
