local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {
	plasma_rifle_overheat = {
		static_power_level = 500,
		radius = 10,
		damage_falloff = true,
		close_radius = 1.5,
		collision_filter = "filter_player_character_explosion",
		damage_profile = DamageProfileTemplates.plasma_overheat,
		close_damage_profile = DamageProfileTemplates.plasma_overheat,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = 15,
			suppression_value = 20
		},
		vfx = {
			"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_large"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_barrel_explosion",
			"wwise/events/weapon/play_explosion_refl_small"
		}
	},
	ogryn_thumper_grenade = {
		damage_falloff = true,
		collision_filter = "filter_player_character_explosion",
		static_power_level = 500,
		scalable_radius = true,
		radius = {
			8,
			12
		},
		close_radius = {
			1.5,
			3
		},
		close_damage_profile = DamageProfileTemplates.ogryn_thumper_p1_m2_close,
		close_damage_type = damage_types.laser,
		damage_profile = DamageProfileTemplates.ogryn_thumper_p1_m2_default,
		damage_type = damage_types.laser,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = {
				10,
				30
			},
			suppression_value = {
				20,
				40
			}
		},
		scalable_vfx = {
			{
				radius_variable_name = "radius",
				min_radius = 5,
				effects = {
					"content/fx/particles/explosions/frag_grenade_01"
				}
			}
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_frag",
			"wwise/events/weapon/play_explosion_refl_gen"
		}
	},
	ogryn_thumper_grenade_instant = {
		damage_falloff = true,
		collision_filter = "filter_player_character_explosion",
		static_power_level = 500,
		scalable_radius = true,
		radius = {
			5,
			10
		},
		close_radius = {
			2,
			3
		},
		close_damage_profile = DamageProfileTemplates.ogryn_thumper_p1_m2_close_instant,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.ogryn_thumper_p1_m2_default_instant,
		damage_type = damage_types.grenade_frag,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = {
				10,
				20
			},
			suppression_value = {
				10,
				20
			}
		},
		scalable_vfx = {
			{
				radius_variable_name = "radius",
				min_radius = 4,
				effects = {
					"content/fx/particles/explosions/frag_grenade_01"
				}
			}
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_frag",
			"wwise/events/weapon/play_explosion_refl_gen"
		}
	},
	powermaul_activated_impact = {
		static_power_level = 500,
		min_radius = 2,
		collision_filter = "filter_player_character_explosion",
		min_close_radius = 1,
		radius = {
			4,
			8
		},
		close_radius = {
			1,
			3
		},
		close_damage_profile = DamageProfileTemplates.powermaul_explosion,
		close_damage_type = damage_types.blunt_thunder,
		damage_profile = DamageProfileTemplates.powermaul_explosion_outer,
		damage_type = damage_types.blunt_thunder,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = {
				10,
				15
			},
			suppression_value = {
				20,
				50
			}
		},
		vfx = {
			"content/fx/particles/weapons/power_maul/power_maul_push_shockwave"
		},
		sfx = {
			{
				event_name = "wwise/events/weapon/play_ogryn_powermaul_1h_hit_sparks",
				has_husk_events = true
			}
		}
	},
	human_powermaul_activated_impact = {
		static_power_level = 500,
		min_radius = 2,
		collision_filter = "filter_player_character_explosion",
		min_close_radius = 1,
		radius = {
			1,
			3
		},
		close_radius = {
			1,
			2
		},
		close_damage_profile = DamageProfileTemplates.powermaul_explosion,
		close_damage_type = damage_types.blunt_thunder,
		damage_profile = DamageProfileTemplates.powermaul_explosion_outer,
		damage_type = damage_types.blunt_thunder,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = {
				3,
				6
			},
			suppression_value = {
				20,
				50
			}
		},
		vfx = {
			"content/fx/particles/weapons/power_maul/power_maul_push_shockwave"
		},
		sfx = {
			{
				event_name = "wwise/events/weapon/play_ogryn_powermaul_1h_hit_sparks",
				has_husk_events = true
			}
		}
	},
	human_heavy_powermaul_activated_impact = {
		static_power_level = 500,
		min_radius = 2,
		collision_filter = "filter_player_character_explosion",
		min_close_radius = 1,
		radius = {
			2.5,
			5
		},
		close_radius = {
			1,
			2
		},
		close_damage_profile = DamageProfileTemplates.powermaul_explosion,
		close_damage_type = damage_types.blunt_thunder,
		damage_profile = DamageProfileTemplates.powermaul_explosion_outer,
		damage_type = damage_types.blunt_thunder,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = {
				5,
				10
			},
			suppression_value = {
				20,
				50
			}
		},
		vfx = {
			"content/fx/particles/weapons/power_maul/power_maul_push_shockwave"
		},
		sfx = {
			{
				event_name = "wwise/events/weapon/play_ogryn_powermaul_1h_hit_sparks",
				has_husk_events = true
			}
		}
	},
	trait_buff_flamer_p1_minion_explosion = {
		static_power_level = 1000,
		radius = 3,
		damage_falloff = false,
		min_radius = 0.25,
		collision_filter = "filter_player_character_explosion",
		damage_profile = DamageProfileTemplates.default_grenade,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = 10,
			suppression_value = 12
		},
		vfx = {
			"content/fx/particles/weapon_traits/flamer_minion_explosion"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_buff_flame",
			"wwise/events/weapon/play_explosion_refl_small"
		}
	},
	trait_buff_forcestaff_p2_minion_explosion = {
		static_power_level = 600,
		radius = 2,
		damage_falloff = true,
		min_radius = 0.25,
		collision_filter = "filter_player_character_explosion",
		damage_profile = DamageProfileTemplates.default_grenade,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = 10,
			suppression_value = 12
		},
		vfx = {
			"content/fx/particles/weapon_traits/flame_staff_minion_explosion"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_buff_flame",
			"wwise/events/weapon/play_explosion_refl_small"
		}
	}
}

return explosion_templates
