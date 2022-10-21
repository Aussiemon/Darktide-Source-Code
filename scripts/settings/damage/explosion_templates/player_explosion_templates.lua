local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {
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
			"content/fx/particles/weapons/grenades/flame_grenade_initial_blast"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_flame",
			"wwise/events/weapon/play_explosion_refl_small"
		}
	},
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
		close_damage_type = damage_types.frag,
		damage_profile = DamageProfileTemplates.frag_grenade,
		damage_type = damage_types.frag,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = 15,
			suppression_value = 20
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
	krak_grenade = {
		damage_falloff = true,
		radius = 5,
		min_radius = 1.5,
		scalable_radius = true,
		close_radius = 1.5,
		collision_filter = "filter_player_character_explosion",
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
	shock_grenade = {
		damage_falloff = true,
		radius = 10,
		min_radius = 5,
		scalable_radius = true,
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		on_hit_buff_template_name = "shock_grenade_interval",
		static_power_level = 100,
		min_close_radius = 2,
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
		vfx = {
			"content/fx/particles/weapons/grenades/stumm_grenade/stumm_grenade"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_frag",
			"wwise/events/weapon/play_explosion_refl_gen"
		}
	},
	ogryn_grenade = {
		damage_falloff = true,
		radius = 12,
		min_radius = 12,
		scalable_radius = true,
		close_radius = 4,
		collision_filter = "filter_player_character_explosion",
		static_power_level = 500,
		min_close_radius = 4,
		close_damage_profile = DamageProfileTemplates.close_ogryn_grenade,
		close_damage_type = damage_types.laser,
		damage_profile = DamageProfileTemplates.ogryn_grenade,
		damage_type = damage_types.laser,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = 15,
			suppression_value = 20
		},
		scalable_vfx = {
			{
				radius_variable_name = "radius",
				min_radius = 5,
				effects = {
					"content/fx/particles/explosions/frag_grenade_ogryn"
				}
			}
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_frag",
			"wwise/events/weapon/play_explosion_refl_gen"
		}
	},
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
			"wwise/events/weapon/play_explosion_plasma_overheat",
			"wwise/events/weapon/play_explosion_refl_small"
		}
	},
	ogryn_charge_impact = {
		static_power_level = 1000,
		radius = 2.5,
		collision_filter = "filter_player_character_lunge",
		min_radius = 1.9,
		close_radius = 2.5,
		min_close_radius = 2,
		close_damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		damage_profile = DamageProfileTemplates.ogryn_charge_finish
	},
	ogryn_charge_impact_damage = {
		static_power_level = 1000,
		radius = 2.5,
		collision_filter = "filter_player_character_lunge",
		min_radius = 1.9,
		close_radius = 2.5,
		min_close_radius = 2,
		close_damage_profile = DamageProfileTemplates.ogryn_charge_finish_damage,
		damage_profile = DamageProfileTemplates.ogryn_charge_finish_damage
	},
	ogryn_bonebreaker_passive_aoe_stagger = {
		static_power_level = 1000,
		radius = 3,
		collision_filter = "filter_player_character_lunge",
		min_radius = 2,
		close_radius = 2.75,
		min_close_radius = 2,
		close_damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		damage_profile = DamageProfileTemplates.ogryn_charge_finish
	},
	zealot_charge_impact_with_burning = {
		static_power_level = 1000,
		radius = 2.5,
		min_radius = 1.9,
		close_radius = 2.5,
		collision_filter = "filter_player_character_lunge",
		on_hit_buff_template_name = "debug_burninating_burning",
		min_close_radius = 2,
		close_damage_profile = DamageProfileTemplates.zealot_dash_impact,
		damage_profile = DamageProfileTemplates.zealot_dash_impact,
		vfx = {
			"content/fx/particles/weapons/grenades/flame_grenade_initial_blast"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_flame",
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
			8,
			12
		},
		close_radius = {
			1.5,
			3
		},
		close_damage_profile = DamageProfileTemplates.ogryn_thumper_p1_m2_close_instant,
		close_damage_type = damage_types.frag,
		damage_profile = DamageProfileTemplates.ogryn_thumper_p1_m2_default_instant,
		damage_type = damage_types.frag,
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
	powermaul_activated_impact = {
		static_power_level = 500,
		radius = 2.6,
		min_radius = 2,
		close_radius = 1,
		collision_filter = "filter_player_character_explosion",
		min_close_radius = 1,
		close_damage_profile = DamageProfileTemplates.powermaul_explosion,
		close_damage_type = damage_types.blunt_thunder,
		damage_profile = DamageProfileTemplates.powermaul_explosion_outer,
		damage_type = damage_types.blunt_thunder,
		explosion_area_suppression = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = {
				10,
				30
			},
			suppression_value = {
				20,
				50
			}
		}
	}
}

return explosion_templates
