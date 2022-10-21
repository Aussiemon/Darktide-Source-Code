local pickup_settings = {
	distribution_types = table.enum("guaranteed", "end_event", "mid_event", "primary", "secondary", "side_mission", "manual"),
	pickup_pool_value = {
		large_clip = 2.5,
		small_clip = 1.5,
		ammo_cache_pocketable = 5,
		small_grenade = 2,
		medical_crate_pocketable = 4
	},
	distribution_pool = {
		rubberband_pool = {
			ammo = {
				small_clip = {
					4,
					4,
					3,
					3,
					2
				},
				large_clip = {
					3,
					3,
					3,
					2,
					2
				},
				ammo_cache_pocketable = {
					2,
					2,
					2,
					2,
					2
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
					2,
					2,
					2,
					2,
					2
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
					6,
					6,
					5,
					5,
					5
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
					1,
					1
				}
			}
		},
		secondary = {
			ammo = {
				small_clip = {
					6,
					6,
					6,
					5,
					5
				},
				large_clip = {
					3,
					3,
					3,
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
	}
}
pickup_settings.rubberband = {
	special_block_distance = 0.2,
	base_spawn_rate = 0.5,
	status_weight = {
		[pickup_settings.distribution_types.mid_event] = {
			0.3,
			1
		},
		[pickup_settings.distribution_types.end_event] = {
			0.3,
			1
		},
		[pickup_settings.distribution_types.primary] = {
			0,
			1
		},
		[pickup_settings.distribution_types.secondary] = {
			0,
			1
		}
	},
	distribution_type_weight = {
		ammo = {
			[pickup_settings.distribution_types.mid_event] = 1.5,
			[pickup_settings.distribution_types.end_event] = 1.8
		},
		grenade = {
			[pickup_settings.distribution_types.mid_event] = 1.5,
			[pickup_settings.distribution_types.end_event] = 2.5
		},
		health = {
			[pickup_settings.distribution_types.mid_event] = 2,
			[pickup_settings.distribution_types.end_event] = 3.5
		}
	}
}
pickup_settings.animation_time = 0.15
pickup_settings.end_scale = 0.2
pickup_settings.target_height_offset = -0.2
pickup_settings.placement_arch_height = 0.2

return settings("PickupSettings", pickup_settings)
