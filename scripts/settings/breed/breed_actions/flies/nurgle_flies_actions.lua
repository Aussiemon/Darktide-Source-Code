-- chunkname: @scripts/settings/breed/breed_actions/flies/nurgle_flies_actions.lua

local action_data = {
	name = "nurgle_flies",
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
	nurgle_flies_chase_target = {},
}

return action_data
