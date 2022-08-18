local pickup_settings = {
	animation_time = 0.15,
	end_scale = 0.2,
	target_height_offset = -0.2,
	placement_arch_height = 0.2,
	pickup_pool_value = {
		large_clip = 1.3,
		small_clip = 1,
		ammo_cache_pocketable = 4,
		small_grenade = 2,
		medical_crate_pocketable = 5
	},
	distribution_pool = {
		primary = {
			ammo = {
				small_clip = {
					8,
					8,
					7,
					6,
					5
				},
				large_clip = {
					5,
					4,
					4,
					3,
					2
				}
			},
			ability = {
				small_grenade = {
					5,
					5,
					4,
					3,
					3
				}
			},
			pocketable = {
				medical_crate_pocketable = {
					2,
					1,
					1,
					1,
					1
				},
				ammo_cache_pocketable = {
					2,
					2,
					1,
					1,
					1
				}
			}
		},
		secondary = {
			ammo = {
				small_clip = {
					8,
					8,
					7,
					6,
					6
				},
				large_clip = {
					4,
					3,
					3,
					2,
					2
				}
			},
			ability = {
				small_grenade = {
					4,
					4,
					4,
					3,
					2
				}
			},
			pocketable = {
				medical_crate_pocketable = {
					1,
					2,
					2,
					1,
					1
				},
				ammo_cache_pocketable = {
					1,
					1,
					1,
					1,
					1
				}
			},
			forge_material = {
				small_metal = {
					10,
					7,
					5,
					0,
					0
				},
				large_metal = {
					5,
					7,
					5,
					8,
					5
				},
				small_platinum = {
					0,
					1,
					5,
					5,
					5
				},
				large_platinum = {
					0,
					0,
					0,
					2,
					5
				}
			}
		}
	},
	distribution_types = table.enum("guaranteed", "primary", "secondary", "side_mission", "manual")
}

return settings("PickupSettings", pickup_settings)
