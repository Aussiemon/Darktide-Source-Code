-- chunkname: @scripts/settings/breed/breed_actions/valkyrie/attack_valkyrie_actions.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local action_data = {
	name = "attack_valkyrie",
	idle = {
		ignore_rotate_towards_target = true,
		vo_event = nil,
		anim_events = {},
	},
	death = {
		instant_ragdoll_chance = 0,
		death_animations = {},
		ragdoll_timings = {},
	},
	rendezvous = {
		rendezvous_radius = 50,
		rotation_speed = 0,
		slowdown_distance_from_goal = 30,
		stop_distance = 30,
		rendezvous_offset = {
			0,
			0,
			20,
		},
	},
	shoot = {
		projectile_item = "content/items/weapons/player/ranged/bullets/attack_valkyrie_missile",
		rotation_speed = 0,
		slowdown_distance_from_goal = 30,
		stop_distance = 30,
		transition_speed_friction = 1,
		projectile_template = ProjectileTemplates.attack_valkyrie_missile,
		shooting_settings = {
			num_shots_in_salvo = 4,
			time_between_salvos = 4,
			time_between_shots = 0.75,
			sfx = {
				ready = "wwise/events/world/play_expeditions_attack_valkyrie_ready_missiles",
				ready_delay = 1,
				shoot = "wwise/events/world/play_expeditions_attack_valkyrie_shoot",
			},
		},
	},
	fallback_rendezvous = {
		rendezvous_radius = 25,
		rotation_speed = 0,
		slowdown_distance_from_goal = 30,
		stop_distance = 30,
		rendezvous_offset = {
			0,
			0,
			20,
		},
	},
	flee = {
		rotation_speed = 0,
		stop_distance = 30,
	},
}

return action_data
