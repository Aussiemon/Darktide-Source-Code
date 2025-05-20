-- chunkname: @scripts/settings/pickup/pickup_settings.lua

local pickup_settings = {}

pickup_settings.distribution_types = table.enum("guaranteed", "end_event", "mid_event", "primary", "secondary", "side_mission", "manual")
pickup_settings.min_chest_spawner_ratio = {
	[pickup_settings.distribution_types.primary] = 0.25,
	[pickup_settings.distribution_types.secondary] = 0.25,
}
pickup_settings.pickup_pool_value = {
	ammo_cache_pocketable = 5,
	large_clip = 2.5,
	medical_crate_pocketable = 4,
	small_clip = 1.5,
	small_grenade = 2,
	syringe_corruption_pocketable = 2,
}
pickup_settings.empty_distribution_pool = {}
pickup_settings.default_distribution_pool = {
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
				2,
				2,
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
				9,
				9,
				8,
				8,
				8,
			},
			large_clip = {
				2,
				2,
				2,
				2,
				2,
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
				2,
				2,
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
				2,
				2,
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
				14,
				14,
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
				2,
				2,
				2,
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
pickup_settings.operations_distribution_pool = {
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
pickup_settings.horde_distribution_pool = {
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
pickup_settings.rubberband = {
	base_spawn_rate = 0.85,
	special_block_distance = 0.2,
	special_block_distance_short = 0.05,
	pocketable_weight = {
		max = 1,
		min = 0.4,
	},
	pocketable_small_weight = {
		max = 1,
		min = 0.4,
	},
	status_weight = {
		[pickup_settings.distribution_types.mid_event] = {
			0.4,
			1,
		},
		[pickup_settings.distribution_types.end_event] = {
			0.4,
			1,
		},
		[pickup_settings.distribution_types.primary] = {
			0.05,
			1,
		},
		[pickup_settings.distribution_types.secondary] = {
			0.05,
			1,
		},
	},
	distribution_type_weight = {
		ammo = {
			[pickup_settings.distribution_types.mid_event] = 1.8,
			[pickup_settings.distribution_types.end_event] = 2.4,
		},
		grenade = {
			[pickup_settings.distribution_types.mid_event] = 1.2,
			[pickup_settings.distribution_types.end_event] = 2.5,
		},
		health = {
			[pickup_settings.distribution_types.mid_event] = 2.5,
			[pickup_settings.distribution_types.end_event] = 4,
		},
		wounds = {
			[pickup_settings.distribution_types.mid_event] = 2,
			[pickup_settings.distribution_types.end_event] = 3,
		},
		stimms = {},
	},
}
pickup_settings.animation_time = 0.15
pickup_settings.end_scale = 0.2
pickup_settings.target_height_offset = -0.2
pickup_settings.placement_arch_height = 0.2

local function _syringe_selector(seed)
	local new_seed, rnd = math.next_random(seed)
	local weight = rnd * 5

	if weight < 1 then
		return "syringe_ability_boost_pocketable", new_seed
	elseif weight < 3 then
		return "syringe_power_boost_pocketable", new_seed
	else
		return "syringe_speed_boost_pocketable", new_seed
	end
end

pickup_settings.pickup_selector = {
	syringe_generic_pocketable = _syringe_selector,
}
pickup_settings.skip_group = {
	hard_cap = 24,
	soft_cap = 16,
}

return settings("PickupSettings", pickup_settings)
