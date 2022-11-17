local circumstance_templates = {
	assault_01 = {
		wwise_state = "assault_01",
		theme_tag = "default",
		mission_overrides = {
			hazard_prop_settings = {
				explosion = 1,
				fire = 1,
				none = 0
			},
			health_station = {
				charges_to_distribute = 0
			},
			pickup_settings = {
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
							-2,
							-2,
							-2,
							-2,
							-2
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
					},
					health = {
						medical_crate_pocketable = {
							-2,
							-2,
							-2,
							-2,
							-2
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
					},
					health = {
						medical_crate_pocketable = {
							-2,
							-2,
							-2,
							-2,
							-2
						}
					}
				},
				primary = {
					ammo = {
						small_clip = {
							3,
							3,
							3,
							3,
							3
						},
						large_clip = {
							1,
							1,
							1,
							1,
							1
						}
					},
					grenade = {
						small_grenade = {
							4,
							4,
							4,
							4,
							4
						}
					},
					health = {
						medical_crate_pocketable = {
							-2,
							-2,
							-2,
							-2,
							-2
						}
					}
				},
				secondary = {
					ammo = {
						small_clip = {
							3,
							3,
							3,
							3,
							3
						},
						large_clip = {
							2,
							2,
							2,
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
					}
				}
			}
		},
		mutators = {
			"mutator_more_hordes",
			"mutator_more_specials"
		},
		ui = {
			description = "loc_circumstance_assault_description",
			icon = "content/ui/materials/icons/circumstances/assault_01",
			display_name = "loc_circumstance_assault_title",
			favourable_to_players = true
		}
	}
}

return circumstance_templates
