﻿-- chunkname: @scripts/settings/specials/cultist_flamer_settings.lua

local STATES = table.index_lookup_table("passive", "aiming", "shooting")
local cultist_flamer_settings = {
	fx_source_name = "muzzle",
	inventory_slot = "slot_ranged_weapon",
	min_range = 3,
	radius = 0.2,
	range = 20,
	set_muzzle_as_control_point_1 = true,
	states = STATES,
	vfx = {
		flamer_particle = "content/fx/particles/enemies/cultist_flamer/cultist_flame_thrower",
		flamer_velocity_variable_name = "velocity",
		ground_impact_particle = "content/fx/particles/enemies/cultist_flamer/cultist_flame_thrower_hit",
		ground_impact_velocity_variable_name = "velocity",
		num_parabola_control_points = 4,
	},
	sfx = {
		aim_sfx_event = "wwise/events/weapon/play_minion_flamethrower_green_wind_up",
		looping_sfx_start_event = "wwise/events/weapon/play_minion_flamethrower_green_start",
		looping_sfx_stop_event = "wwise/events/weapon/play_minion_flamethrower_green_stop",
	},
	trajectory_config = {
		acceptable_accuracy = 1,
		gravity = 8.82,
		initial_speed = 12,
	},
}

return settings("CultistFlamerSettings", cultist_flamer_settings)
