-- chunkname: @scripts/settings/monster/chaos_beast_of_nurgle_settings.lua

local STATES = table.index_lookup_table("passive", "aiming", "shooting")
local chaos_beast_of_nurgle_settings = {
	dodge_radius = 0.5,
	from_node = "j_tongue_mouth",
	min_range = 0,
	radius = 2.25,
	range = 20,
	states = STATES,
	vfx = {
		flamer_particle = "content/fx/particles/enemies/beast_of_nurgle/bon_vomit_projectile",
		flamer_velocity_variable_name = "velocity",
		ground_impact_particle = "content/fx/particles/enemies/beast_of_nurgle/bon_vomit_splatter",
		num_parabola_control_points = 4,
	},
	sfx = {
		ground_impact_sfx_start_event = "wwise/events/minions/play_beast_of_nurgle_vomit_ground_impact",
		looping_sfx_start_event = "wwise/events/minions/play_beast_of_nurgle_vce_vomit",
		looping_sfx_stop_event = "wwise/events/minions/stop_beast_of_nurgle_vce_vomit",
	},
	trajectory_config = {
		acceptable_accuracy = 1,
		gravity = 8.82,
		initial_speed = 6,
	},
	cooldowns = {
		consume = 10,
		consume_failed = 1,
		melee = 1.5,
		melee_aoe = 7,
		vomit = 2,
	},
}

return settings("ChaosBeastOfNurgleSettings", chaos_beast_of_nurgle_settings)
