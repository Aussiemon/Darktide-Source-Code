local pickup_settings = {
	distribution_types = table.enum("guaranteed", "end_event", "mid_event", "primary", "secondary", "side_mission", "manual")
}
pickup_settings.min_chest_spawner_ratio = {
	[pickup_settings.distribution_types.primary] = 0.25,
	[pickup_settings.distribution_types.secondary] = 0.25
}
pickup_settings.pickup_pool_value = {
	large_clip = 2.5,
	small_clip = 1.5,
	ammo_cache_pocketable = 5,
	small_grenade = 2,
	medical_crate_pocketable = 4
}
pickup_settings.distribution_pool = {
	rubberband_pool = {
		ammo = {
			small_clip = {
				4,
				4,
				4,
				3,
				3
			},
			large_clip = {
				5,
				5,
				5,
				5,
				5
			},
			ammo_cache_pocketable = {
				1,
				1,
				1,
				1,
				1
			}
		},
		grenade = {
			small_grenade = {
				3,
				3,
				3,
				3,
				3
			}
		},
		health = {
			medical_crate_pocketable = {
				1,
				1,
				1,
				1,
				1
			}
		}
	},
	mid_event = {
		ammo = {
			small_clip = {
				2,
				2,
				2,
				2,
				2
			},
			large_clip = {
				1,
				1,
				1,
				1,
				1
			}
		}
	},
	end_event = {
		ammo = {
			small_clip = {
				2,
				2,
				2,
				2,
				2
			},
			large_clip = {
				1,
				1,
				1,
				1,
				1
			}
		}
	},
	primary = {
		ammo = {
			small_clip = {
				9,
				9,
				8,
				8,
				8
			},
			large_clip = {
				2,
				2,
				2,
				2,
				2
			},
			ammo_cache_pocketable = {
				1,
				1,
				1,
				1,
				1
			}
		},
		grenade = {
			small_grenade = {
				2,
				2,
				2,
				1,
				1
			}
		},
		health = {
			medical_crate_pocketable = {
				1,
				1,
				1,
				1,
				1
			}
		},
		forge_material = {
			small_metal = {
				4,
				5,
				5,
				6,
				7
			},
			large_metal = {
				1,
				1,
				2,
				3,
				7
			}
		}
	},
	secondary = {
		ammo = {
			small_clip = {
				14,
				14,
				14,
				13,
				13
			},
			large_clip = {
				3,
				3,
				3,
				3,
				3
			}
		},
		grenade = {
			small_grenade = {
				2,
				2,
				2,
				3,
				3
			}
		},
		forge_material = {
			small_metal = {
				7,
				8,
				9,
				13,
				16
			},
			large_metal = {
				1,
				2,
				3,
				7,
				16
			},
			small_platinum = {
				0,
				4,
				5,
				7,
				10
			},
			large_platinum = {
				0,
				0,
				3,
				5,
				8
			}
		}
	}
}
pickup_settings.rubberband = {
	special_block_distance = 0.2,
	base_spawn_rate = 0.85,
	pocketable_weight = {
		max = 1,
		min = 0.4
	},
	status_weight = {
		[pickup_settings.distribution_types.mid_event] = {
			0.4,
			1
		},
		[pickup_settings.distribution_types.end_event] = {
			0.4,
			1
		},
		[pickup_settings.distribution_types.primary] = {
			0.05,
			1
		},
		[pickup_settings.distribution_types.secondary] = {
			0.05,
			1
		}
	},
	distribution_type_weight = {
		ammo = {
			[pickup_settings.distribution_types.mid_event] = 1.8,
			[pickup_settings.distribution_types.end_event] = 2.4
		},
		grenade = {
			[pickup_settings.distribution_types.mid_event] = 1.2,
			[pickup_settings.distribution_types.end_event] = 2.5
		},
		health = {
			[pickup_settings.distribution_types.mid_event] = 2.5,
			[pickup_settings.distribution_types.end_event] = 4
		}
	}
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
	syringe_generic_pocketable = _syringe_selector
}

return settings("PickupSettings", pickup_settings)
