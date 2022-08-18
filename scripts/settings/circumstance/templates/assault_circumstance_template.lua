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
				default = {
					primary = {
						ammo = {
							large_clip = 16,
							small_clip = 20
						},
						ability = {
							small_grenade = 16
						},
						pocketable = {
							ammo_cache_pocketable = 3,
							medical_crate_pocketable = 4
						}
					},
					secondary = {
						ammo = {
							large_clip = 8,
							small_clip = 20
						},
						ability = {
							small_grenade = 12
						},
						pocketable = {
							ammo_cache_pocketable = 3,
							medical_crate_pocketable = 4
						}
					}
				}
			}
		},
		mutators = {
			"mutator_more_hordes",
			"mutator_more_monsters"
		},
		ui = {
			icon = "content/ui/materials/icons/circumstances/poison",
			display_name = "loc_circumstance_assault_title",
			favourable_to_players = true
		}
	}
}

return circumstance_templates
