-- chunkname: @scripts/settings/damage/push_settings.lua

local push_settings = {}

push_settings.default_max_push_speed = 4
push_settings.push_templates = {
	block_broken = {
		max_speed_override = 3,
		speed = 3.5,
	},
	toughness = {
		max_speed_override = nil,
		speed = 1.5,
	},
	very_light = {
		max_speed_override = nil,
		speed = 1.2,
	},
	gunner_very_light = {
		max_speed_override = nil,
		speed = 0.6,
	},
	gunner_light = {
		max_speed_override = nil,
		speed = 0.8,
	},
	ogryn_very_light = {
		max_speed_override = nil,
		speed = 0.25,
	},
	light = {
		max_speed_override = 2,
		speed = 2.5,
	},
	medium = {
		max_speed_override = 3,
		speed = 4,
	},
	heavy = {
		max_speed_override = 3,
		speed = 5,
	},
	shocktrooper_shotgun = {
		max_speed_override = 4,
		speed = 7,
	},
	renegade_captain_shotgun = {
		max_speed_override = 4,
		speed = 7,
	},
	sniper_bullet = {
		max_speed_override = 8,
		speed = 12,
	},
	grenadier_explosion = {
		max_speed_override = 4,
		speed = 4,
	},
	melee_executor_default = {
		ignore_stun_immunity = true,
		max_speed_override = 6,
		push_through_block = true,
		speed = 6,
	},
	ogryn_executor_push = {
		ignore_stun_immunity = true,
		max_speed_override = 8,
		push_through_block = true,
		speed = 8,
	},
	shield_push = {
		ignore_stun_immunity = true,
		max_speed_override = 8,
		speed = 8,
	},
	chaos_hound_push = {
		max_speed_override = 4,
		speed = 4,
	},
	cyber_mastiff_push = {
		max_speed_override = 2,
		speed = 2,
	},
	chaos_ogryn_gunner_bullet = {
		max_speed_override = 2,
		speed = 2,
	},
	chaos_ogryn_gunner_bullet_ogryn = {
		max_speed_override = 2,
		speed = 0.5,
	},
	renegade_plasma_gunner = {
		ignore_stun_immunity = true,
		max_speed_override = 3,
		push_through_block = true,
		speed = 5,
	},
	renegade_captain = {
		ignore_stun_immunity = true,
		max_speed_override = 6,
		push_through_block = true,
		speed = 10,
	},
	renegade_captain_light = {
		ignore_stun_immunity = true,
		max_speed_override = 4,
		push_through_block = true,
		speed = 6,
	},
	renegade_captain_heavy = {
		abort_stickyness = true,
		ignore_stun_immunity = true,
		max_speed_override = 6,
		push_through_block = true,
		speed = 12,
	},
	daemonhost = {
		ignore_stun_immunity = true,
		max_speed_override = 6,
		push_through_block = true,
		speed = 8,
	},
	daemonhost_offtarget = {
		max_speed_override = 10,
		push_through_block = true,
		speed = 14,
	},
	cultist_flamer_push = {
		max_speed_override = 4,
		speed = 5.5,
	},
	renegade_flamer_push = {
		max_speed_override = 4,
		speed = 5.5,
	},
	shocktrooper_frag = {
		max_speed_override = 6,
		push_through_block = true,
		speed = 12,
	},
	renegade_grenadier_frag = {
		max_speed_override = 6,
		push_through_block = true,
		speed = 8,
	},
	chaos_hound_pounced_push = {
		max_speed_override = 8,
		speed = 10,
	},
	plague_ogryn_charge = {
		ignore_stun_immunity = true,
		max_speed_override = 9,
		push_through_block = true,
		speed = 12,
	},
	plague_ogryn_light = {
		ignore_stun_immunity = true,
		max_speed_override = 5,
		push_through_block = true,
		speed = 5.5,
	},
	plague_ogryn_medium = {
		ignore_stun_immunity = true,
		max_speed_override = 9,
		push_through_block = true,
		speed = 9,
	},
	chaos_spawn_light = {
		max_speed_override = 5,
		push_through_block = true,
		speed = 5.5,
	},
	chaos_spawn_leap = {
		max_speed_override = 8,
		push_through_block = true,
		speed = 8,
	},
	ranged_light = {
		dont_trigger_on_toughness = true,
		max_speed_override = 2,
		speed = 1,
	},
	ranged_light_auto = {
		dont_trigger_on_toughness = true,
		speed = 0.1,
	},
	ogryn_ranged_light_auto = {
		dont_trigger_on_toughness = true,
		speed = 0.05,
	},
	beast_of_nurgle_move_push = {
		ignore_stun_immunity = true,
		max_speed_override = 7,
		push_through_block = true,
		speed = 8,
	},
	chaos_spawn_tentacle = {
		max_speed_override = 10,
		speed = 10,
		push_through_block = {
			max_speed_override = 6,
			speed = 6,
		},
	},
	chaos_spawn_combo = {
		ignore_stun_immunity = true,
		max_speed_override = 7,
		push_through_block = true,
		speed = 7,
	},
	chaos_spawn_combo_heavy = {
		ignore_stun_immunity = true,
		max_speed_override = 9,
		push_through_block = true,
		speed = 9,
	},
	ogryn_shovel_special = {
		max_speed_override = 4,
		speed = 3,
	},
	twin_dash = {
		ignore_stun_immunity = true,
		max_speed_override = 6,
		push_through_block = true,
		speed = 12,
	},
	twin_dash_light = {
		ignore_stun_immunity = true,
		max_speed_override = 6,
		push_through_block = true,
		speed = 8,
	},
	twin_grenade = {
		ignore_stun_immunity = true,
		max_speed_override = 8,
		speed = 8,
	},
	renegade_twin_captain_sweep = {
		ignore_stun_immunity = true,
		max_speed_override = 6,
		push_through_block = true,
		speed = 10,
	},
	renegade_twin_captain_combo = {
		ignore_stun_immunity = true,
		max_speed_override = 4,
		push_through_block = true,
		speed = 6,
	},
}

return settings("PushSettings", push_settings)
