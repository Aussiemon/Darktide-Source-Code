local weapon_sprint_templates = {
	default = {
		sprint_sideway_acceleration = 5,
		sprint_forward_deceleration = 1.25,
		sprint_sideway_deceleration = 5,
		sprint_forward_acceleration = {
			lerp_perfect = 0.4,
			lerp_basic = 0.15
		},
		sprint_speed_mod = {
			lerp_perfect = 0.5,
			lerp_basic = -0.5
		}
	},
	killshot = {
		sprint_sideway_acceleration = 5,
		sprint_forward_deceleration = 1.25,
		sprint_sideway_deceleration = 5,
		sprint_forward_acceleration = {
			lerp_perfect = 0.4,
			lerp_basic = 0.15
		},
		sprint_speed_mod = {
			lerp_perfect = 0.5,
			lerp_basic = -0.5
		}
	},
	support = {
		sprint_sideway_acceleration = 5,
		sprint_forward_deceleration = 1.45,
		sprint_sideway_deceleration = 5,
		sprint_forward_acceleration = {
			lerp_perfect = 0.4,
			lerp_basic = 0.15
		},
		sprint_speed_mod = {
			lerp_perfect = 0.2,
			lerp_basic = -0.6
		}
	},
	luggable = {
		sprint_sideway_acceleration = 5,
		sprint_forward_deceleration = 1.45,
		no_stamina_sprint_speed_mod = 0.6,
		sprint_sideway_deceleration = 5,
		sprint_forward_acceleration = {
			lerp_perfect = 0.4,
			lerp_basic = 0.15
		},
		sprint_speed_mod = {
			lerp_perfect = 0.5,
			lerp_basic = 0.5
		}
	},
	ogryn = {
		sprint_sideway_acceleration = 2,
		sprint_forward_deceleration = 1.45,
		sprint_sideway_deceleration = 5,
		sprint_forward_acceleration = {
			lerp_perfect = 0.4,
			lerp_basic = 0.15
		},
		sprint_speed_mod = {
			lerp_perfect = 0.25,
			lerp_basic = -0.25
		}
	},
	ogryn_assault = {
		sprint_sideway_acceleration = 4,
		sprint_forward_deceleration = 1.45,
		sprint_sideway_deceleration = 5,
		sprint_forward_acceleration = {
			lerp_perfect = 0.4,
			lerp_basic = 0.15
		},
		sprint_speed_mod = {
			lerp_perfect = 1,
			lerp_basic = -0.25
		}
	},
	ogryn_hub = {
		sprint_sideway_acceleration = 2,
		sprint_forward_deceleration = 1.45,
		sprint_sideway_deceleration = 5,
		sprint_speed_mod = 1,
		sprint_forward_acceleration = {
			lerp_perfect = 0.45,
			lerp_basic = 0.25
		}
	},
	assault = {
		sprint_sideway_acceleration = 7,
		sprint_forward_deceleration = 1.45,
		sprint_sideway_deceleration = 7,
		sprint_forward_acceleration = {
			lerp_perfect = 0.4,
			lerp_basic = 0.15
		},
		sprint_speed_mod = {
			lerp_perfect = 0.75,
			lerp_basic = -0.25
		}
	},
	ninja_l = {
		sprint_sideway_acceleration = 7,
		sprint_forward_deceleration = 2.45,
		sprint_sideway_deceleration = 7,
		sprint_forward_acceleration = {
			lerp_perfect = 1,
			lerp_basic = 0.5
		},
		sprint_speed_mod = {
			lerp_perfect = 1,
			lerp_basic = 0.5
		}
	}
}

return settings("WeaponSprintTemplates", weapon_sprint_templates)
