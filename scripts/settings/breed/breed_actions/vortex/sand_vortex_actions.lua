-- chunkname: @scripts/settings/breed/breed_actions/vortex/sand_vortex_actions.lua

local action_data = {
	name = "sand_vortex",
	idle = {
		ignore_rotate_towards_target = true,
		vo_event = nil,
		anim_events = {
			"idle",
		},
	},
	death = {
		instant_ragdoll_chance = 0,
		death_animations = {},
		ragdoll_timings = {},
	},
	vortex_wander = {},
}

return action_data
