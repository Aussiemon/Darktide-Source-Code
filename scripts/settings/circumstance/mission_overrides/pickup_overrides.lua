-- chunkname: @scripts/settings/circumstance/mission_overrides/pickup_overrides.lua

local PickupOverrides = {}

local function flat(v)
	return {
		v,
		v,
		v,
		v,
		v,
	}
end

local removed = flat(-99)
local not_changed = flat(0)

do
	local no_ammo_pickup = {
		small_clip = removed,
		large_clip = removed,
		ammo_cache_pocketable = removed,
	}

	PickupOverrides.no_ammo_pickups = {
		pickup_settings = {
			rubberband_pool = {
				ammo = no_ammo_pickup,
			},
			mid_event = {
				ammo = no_ammo_pickup,
			},
			end_event = {
				ammo = no_ammo_pickup,
			},
			primary = {
				ammo = no_ammo_pickup,
			},
			secondary = {
				ammo = no_ammo_pickup,
			},
		},
	}
end

PickupOverrides.more_grenade_pickups = {
	pickup_settings = {
		rubberband_pool = {
			grenade = {
				small_grenade = flat(3),
			},
		},
		primary = {
			grenade = {
				small_grenade = flat(4),
			},
		},
		secondary = {
			grenade = {
				small_grenade = flat(3),
			},
		},
	},
}
PickupOverrides.more_corruption_syringes = {
	pickup_settings = {
		rubberband_pool = {
			wounds = {
				syringe_corruption_pocketable = flat(10),
			},
		},
		mid_event = {
			wounds = {
				syringe_corruption_pocketable = flat(1),
			},
		},
		end_event = {
			wounds = {
				syringe_corruption_pocketable = flat(1),
			},
		},
		primary = {
			wounds = {
				syringe_corruption_pocketable = flat(10),
			},
		},
		secondary = {
			wounds = {
				syringe_corruption_pocketable = flat(10),
			},
		},
	},
}
PickupOverrides.less_healing_pocketables = {
	pickup_settings = {
		rubberband_pool = {
			health = {
				medical_crate_pocketable = flat(-2),
			},
		},
		mid_event = {
			health = {
				medical_crate_pocketable = flat(-2),
			},
		},
		end_event = {
			health = {
				medical_crate_pocketable = flat(-2),
			},
		},
		primary = {
			health = {
				medical_crate_pocketable = flat(-2),
			},
		},
	},
}
PickupOverrides.extra_ammo_pickups = {
	pickup_settings = {
		rubberband_pool = {
			ammo = {
				small_clip = not_changed,
				large_clip = flat(5),
				ammo_cache_pocketable = flat(2),
			},
		},
		mid_event = {
			ammo = {
				small_clip = not_changed,
				large_clip = flat(2),
				ammo_cache_pocketable = flat(2),
			},
		},
		end_event = {
			ammo = {
				small_clip = not_changed,
				large_clip = flat(2),
				ammo_cache_pocketable = flat(2),
			},
		},
		primary = {
			ammo = {
				small_clip = not_changed,
				large_clip = {
					35,
					35,
					35,
					30,
					30,
				},
				ammo_cache_pocketable = {
					5,
					5,
					5,
					4,
					4,
				},
			},
		},
		secondary = {
			ammo = {
				small_clip = not_changed,
				large_clip = {
					8,
					8,
					8,
					5,
					5,
				},
				ammo_cache_pocketable = {
					5,
					5,
					5,
					4,
					4,
				},
			},
		},
	},
}

return PickupOverrides
