-- chunkname: @scripts/settings/pickup/pickup_pools.lua

local pickup_pools = {}

pickup_pools.empty_distribution_pool = {}
pickup_pools.default_distribution_pool = {
	rubberband_pool = {
		ammo = {
			small_clip = {
				4,
				4,
				4,
				3,
				3,
			},
			large_clip = {
				5,
				5,
				5,
				5,
				5,
			},
			ammo_cache_pocketable = {
				1,
				1,
				1,
				1,
				1,
			},
		},
		grenade = {
			small_grenade = {
				3,
				3,
				3,
				3,
				3,
			},
		},
		health = {
			medical_crate_pocketable = {
				3,
				3,
				2,
				2,
				2,
			},
		},
		wounds = {
			syringe_corruption_pocketable = {
				2,
				2,
				2,
				2,
				2,
			},
		},
		stimms = {
			syringe_generic_pocketable = {
				2,
				2,
				2,
				2,
				2,
			},
		},
	},
	mid_event = {
		ammo = {
			small_clip = {
				2,
				2,
				2,
				2,
				2,
			},
			large_clip = {
				1,
				1,
				1,
				1,
				1,
			},
		},
	},
	end_event = {
		ammo = {
			small_clip = {
				2,
				2,
				2,
				2,
				2,
			},
			large_clip = {
				1,
				1,
				1,
				1,
				1,
			},
		},
	},
	primary = {
		ammo = {
			small_clip = {
				12,
				12,
				8,
				8,
				8,
			},
			large_clip = {
				3,
				3,
				2,
				2,
				2,
			},
			ammo_cache_pocketable = {
				2,
				2,
				1,
				1,
				1,
			},
		},
		grenade = {
			small_grenade = {
				3,
				3,
				2,
				1,
				1,
			},
		},
		wounds = {
			syringe_corruption_pocketable = {
				0,
				0,
				0,
				0,
				0,
			},
		},
		stimms = {
			syringe_generic_pocketable = {
				3,
				3,
				2,
				2,
				2,
			},
		},
		forge_material = {
			small_metal = {
				4,
				5,
				5,
				6,
				7,
			},
			large_metal = {
				1,
				1,
				2,
				3,
				7,
			},
		},
	},
	secondary = {
		ammo = {
			small_clip = {
				17,
				17,
				14,
				13,
				13,
			},
			large_clip = {
				3,
				3,
				3,
				3,
				3,
			},
		},
		grenade = {
			small_grenade = {
				3,
				3,
				3,
				3,
				3,
			},
		},
		wounds = {
			syringe_corruption_pocketable = {
				2,
				2,
				2,
				2,
				2,
			},
		},
		stimms = {
			syringe_generic_pocketable = {
				4,
				4,
				4,
				4,
				4,
			},
		},
		forge_material = {
			small_metal = {
				7,
				8,
				9,
				13,
				16,
			},
			large_metal = {
				1,
				2,
				3,
				7,
				16,
			},
			small_platinum = {
				0,
				4,
				5,
				7,
				10,
			},
			large_platinum = {
				0,
				0,
				3,
				5,
				8,
			},
		},
	},
}
pickup_pools.operations_distribution_pool = {
	rubberband_pool = {
		ammo = {
			small_clip = {
				2,
			},
			large_clip = {
				2,
			},
			ammo_cache_pocketable = {
				0,
			},
		},
		grenade = {
			small_grenade = {
				1,
			},
		},
		health = {
			medical_crate_pocketable = {
				1,
			},
		},
		wounds = {
			syringe_corruption_pocketable = {
				1,
			},
		},
		stimms = {
			syringe_generic_pocketable = {
				2,
			},
		},
	},
	mid_event = {},
	end_event = {},
	primary = {
		ammo = {
			small_clip = {
				3,
				3,
				2,
				2,
				2,
			},
			large_clip = {
				1,
			},
		},
	},
	secondary = {
		ammo = {
			small_clip = {
				4,
				4,
				4,
				3,
				3,
			},
			large_clip = {
				2,
			},
		},
		grenade = {
			small_grenade = {
				1,
			},
		},
		forge_material = {
			small_metal = {
				5,
				4,
				6,
				7,
				9,
			},
			large_metal = {
				0,
				1,
				1,
				3,
				7,
			},
			small_platinum = {
				0,
				1,
				4,
				4,
				5,
			},
			large_platinum = {
				0,
				0,
				0,
				1,
				2,
			},
		},
	},
}
pickup_pools.horde_distribution_pool = {
	primary = {
		forge_material = {
			small_metal = {
				5,
				3,
				2,
				2,
				0,
			},
			large_metal = {
				1,
				2,
				4,
				15,
				23,
			},
			small_platinum = {
				3,
				1,
				4,
				5,
				0,
			},
			large_platinum = {
				0,
				1,
				0,
				1,
				4,
			},
		},
	},
}
pickup_pools.expedition_distribution_pool = {
	primary = {
		forge_material = {
			small_metal = {
				0,
				2,
				2,
				4,
				4,
			},
			large_metal = {
				0,
				1,
				2,
				4,
				6,
			},
			small_platinum = {
				0,
				1,
				1,
				1,
				1,
			},
			large_platinum = {
				0,
				0,
				0,
				1,
				2,
			},
		},
	},
	secondary = {
		forge_material = {
			small_metal = {
				0,
				4,
				5,
				5,
				6,
			},
			large_metal = {
				0,
				0,
				1,
				1,
				5,
			},
			small_platinum = {
				0,
				0,
				1,
				1,
				2,
			},
			large_platinum = {
				0,
				0,
				0,
				0,
				0,
			},
		},
	},
}

return settings("PickupPools", pickup_pools)
