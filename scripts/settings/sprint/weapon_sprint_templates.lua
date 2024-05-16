-- chunkname: @scripts/settings/sprint/weapon_sprint_templates.lua

local weapon_sprint_templates = {}

weapon_sprint_templates.default = {
	sprint_forward_deceleration = 1.25,
	sprint_sideway_acceleration = 5,
	sprint_sideway_deceleration = 5,
	sprint_forward_acceleration = {
		lerp_basic = 0.15,
		lerp_perfect = 0.4,
	},
	sprint_speed_mod = {
		lerp_basic = -0.5,
		lerp_perfect = 0.5,
	},
}
weapon_sprint_templates.killshot = {
	sprint_forward_deceleration = 1.25,
	sprint_sideway_acceleration = 5,
	sprint_sideway_deceleration = 5,
	sprint_forward_acceleration = {
		lerp_basic = 0.15,
		lerp_perfect = 0.4,
	},
	sprint_speed_mod = {
		lerp_basic = -0.5,
		lerp_perfect = 0.5,
	},
}
weapon_sprint_templates.support = {
	sprint_forward_deceleration = 1.45,
	sprint_sideway_acceleration = 5,
	sprint_sideway_deceleration = 5,
	sprint_forward_acceleration = {
		lerp_basic = 0.15,
		lerp_perfect = 0.4,
	},
	sprint_speed_mod = {
		lerp_basic = -0.6,
		lerp_perfect = 0.2,
	},
}
weapon_sprint_templates.luggable = {
	no_stamina_sprint_speed_mod = 0.6,
	sprint_forward_deceleration = 1.45,
	sprint_sideway_acceleration = 5,
	sprint_sideway_deceleration = 5,
	sprint_forward_acceleration = {
		lerp_basic = 0.15,
		lerp_perfect = 0.4,
	},
	sprint_speed_mod = {
		lerp_basic = 0.5,
		lerp_perfect = 0.5,
	},
}
weapon_sprint_templates.ogryn = {
	sprint_forward_deceleration = 1.45,
	sprint_sideway_acceleration = 2,
	sprint_sideway_deceleration = 5,
	sprint_forward_acceleration = {
		lerp_basic = 0.15,
		lerp_perfect = 0.4,
	},
	sprint_speed_mod = {
		lerp_basic = -0.25,
		lerp_perfect = 0.25,
	},
}
weapon_sprint_templates.ogryn_assault = {
	sprint_forward_deceleration = 1.45,
	sprint_sideway_acceleration = 4,
	sprint_sideway_deceleration = 5,
	sprint_forward_acceleration = {
		lerp_basic = 0.15,
		lerp_perfect = 0.4,
	},
	sprint_speed_mod = {
		lerp_basic = -0.25,
		lerp_perfect = 1,
	},
}
weapon_sprint_templates.ogryn_sprint_fast = {
	sprint_forward_deceleration = 1.45,
	sprint_sideway_acceleration = 3,
	sprint_sideway_deceleration = 5,
	sprint_forward_acceleration = {
		lerp_basic = 0.15,
		lerp_perfect = 0.4,
	},
	sprint_speed_mod = {
		lerp_basic = -0.25,
		lerp_perfect = 0.5,
	},
}
weapon_sprint_templates.ogryn_sprint_slow = {
	sprint_forward_deceleration = 1.38,
	sprint_sideway_acceleration = 1.7,
	sprint_sideway_deceleration = 5,
	sprint_forward_acceleration = {
		lerp_basic = 0.15,
		lerp_perfect = 0.3,
	},
	sprint_speed_mod = {
		lerp_basic = -0.5,
		lerp_perfect = 0.1,
	},
}
weapon_sprint_templates.ogryn_hub = {
	sprint_forward_deceleration = 1.45,
	sprint_sideway_acceleration = 2,
	sprint_sideway_deceleration = 5,
	sprint_speed_mod = 1,
	sprint_forward_acceleration = {
		lerp_basic = 0.25,
		lerp_perfect = 0.45,
	},
}
weapon_sprint_templates.assault = {
	sprint_forward_deceleration = 2.1,
	sprint_sideway_acceleration = 7,
	sprint_sideway_deceleration = 7,
	sprint_forward_acceleration = {
		lerp_basic = 0.4,
		lerp_perfect = 0.8,
	},
	sprint_speed_mod = {
		lerp_basic = -0.25,
		lerp_perfect = 0.85,
	},
}
weapon_sprint_templates.ninja_l = {
	sprint_forward_deceleration = 2.45,
	sprint_sideway_acceleration = 7,
	sprint_sideway_deceleration = 7,
	sprint_forward_acceleration = {
		lerp_basic = 0.5,
		lerp_perfect = 1,
	},
	sprint_speed_mod = {
		lerp_basic = 0.5,
		lerp_perfect = 1,
	},
}

return settings("WeaponSprintTemplates", weapon_sprint_templates)
