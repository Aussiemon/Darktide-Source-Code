local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {
	frag_grenade = {
		damage_falloff = true,
		radius = 10,
		min_radius = 10,
		scalable_radius = true,
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		static_power_level = 500,
		min_close_radius = 2,
		close_damage_profile = DamageProfileTemplates.close_frag_grenade,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.frag_grenade,
		damage_type = damage_types.grenade_frag,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = 15,
			suppression_value = 20
		},
		radius_stat_buffs = {
			"explosion_radius_modifier_frag"
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
	shock_grenade = {
		damage_falloff = true,
		radius = 8,
		scalable_radius = true,
		min_radius = 4,
		close_radius = 2,
		on_hit_buff_template_name = "shock_grenade_interval",
		collision_filter = "filter_player_character_explosion",
		min_close_radius = 2,
		static_power_level = 100,
		close_damage_profile = DamageProfileTemplates.shock_grenade,
		close_damage_type = damage_types.electrocution,
		damage_profile = DamageProfileTemplates.shock_grenade,
		damage_type = damage_types.electrocution,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = 15,
			suppression_value = 20
		},
		radius_stat_buffs = {
			"explosion_radius_modifier_shock"
		},
		vfx = {
			"content/fx/particles/weapons/grenades/stumm_grenade/stumm_grenade"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_shock",
			"wwise/events/weapon/play_explosion_refl_gen"
		}
	},
	fire_grenade = {
		static_power_level = 600,
		radius = 1,
		min_radius = 0.25,
		damage_falloff = true,
		collision_filter = "filter_player_character_explosion",
		damage_profile = DamageProfileTemplates.default_grenade,
		damage_type = damage_types.laser,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = 10,
			suppression_value = 12
		},
		vfx = {
			"content/fx/particles/weapons/grenades/fire_grenade/fire_grenade_player_initial_blast"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_flame",
			"wwise/events/weapon/play_explosion_refl_small"
		}
	},
	krak_grenade = {
		damage_falloff = true,
		radius = 5,
		min_radius = 1.5,
		scalable_radius = true,
		close_radius = 1.5,
		collision_filter = "filter_player_character_explosion",
		boss_power_level_modifier = 0.8,
		static_power_level = 500,
		min_close_radius = 1.5,
		close_damage_profile = DamageProfileTemplates.close_krak_grenade,
		close_damage_type = damage_types.plasma,
		damage_profile = DamageProfileTemplates.krak_grenade,
		damage_type = damage_types.plasma,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = 6,
			suppression_value = 8
		},
		vfx = {
			"content/fx/particles/weapons/grenades/krak_grenade/krak_grenade_explosion"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_krak",
			"wwise/events/weapon/play_explosion_refl_gen"
		}
	},
	smoke_grenade = {
		damage_falloff = true,
		radius = 10,
		min_radius = 5,
		scalable_radius = true,
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		static_power_level = 100,
		min_close_radius = 2,
		close_damage_profile = DamageProfileTemplates.smoke_grenade,
		close_damage_type = damage_types.physical,
		damage_profile = DamageProfileTemplates.smoke_grenade,
		damage_type = damage_types.physical,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = 15,
			suppression_value = 20
		},
		vfx = {
			"content/fx/particles/weapons/grenades/smoke_grenade/smoke_grenade_initial_blast"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_smoke",
			"wwise/events/weapon/play_explosion_refl_small"
		}
	},
	ogryn_grenade_frag = {
		damage_falloff = true,
		radius = 16,
		min_radius = 16,
		scalable_radius = true,
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		static_power_level = 500,
		min_close_radius = 2,
		close_damage_profile = DamageProfileTemplates.close_ogryn_grenade,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.ogryn_grenade,
		damage_type = damage_types.grenade_frag,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = 25,
			suppression_value = 25
		},
		scalable_vfx = {
			{
				radius_variable_name = "radius",
				min_radius = 10,
				effects = {
					"content/fx/particles/explosions/frag_grenade_ogryn"
				}
			}
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_frag_ogryn",
			"wwise/events/weapon/play_explosion_refl_huge"
		}
	},
	ogryn_box_cluster_frag = {
		damage_falloff = true,
		radius = 8,
		min_radius = 5,
		scalable_radius = true,
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		static_power_level = 500,
		min_close_radius = 2,
		close_damage_profile = DamageProfileTemplates.ogryn_box_cluster_close_frag_grenade,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.ogryn_box_cluster_frag_grenade,
		damage_type = damage_types.grenade_frag,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = 15,
			suppression_value = 20
		},
		radius_stat_buffs = {
			"explosion_radius_modifier_frag"
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
	}
}

return explosion_templates
