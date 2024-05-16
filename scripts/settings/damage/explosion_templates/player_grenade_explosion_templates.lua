-- chunkname: @scripts/settings/damage/explosion_templates/player_grenade_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {
	frag_grenade = {
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 2,
		min_radius = 10,
		radius = 10,
		scalable_radius = true,
		static_power_level = 500,
		close_damage_profile = DamageProfileTemplates.close_frag_grenade,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.frag_grenade,
		damage_type = damage_types.grenade_frag,
		explosion_area_suppression = {
			distance = 15,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 20,
		},
		radius_stat_buffs = {
			"explosion_radius_modifier_frag",
		},
		scalable_vfx = {
			{
				min_radius = 5,
				radius_variable_name = "radius",
				effects = {
					"content/fx/particles/explosions/frag_grenade_01",
				},
			},
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_frag",
			"wwise/events/weapon/play_explosion_refl_gen",
		},
	},
	shock_grenade = {
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 2,
		min_radius = 4,
		on_hit_buff_template_name = "shock_grenade_interval",
		radius = 8,
		scalable_radius = true,
		static_power_level = 100,
		close_damage_profile = DamageProfileTemplates.shock_grenade,
		close_damage_type = damage_types.electrocution,
		damage_profile = DamageProfileTemplates.shock_grenade,
		damage_type = damage_types.electrocution,
		explosion_area_suppression = {
			distance = 15,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 20,
		},
		radius_stat_buffs = {
			"explosion_radius_modifier_shock",
		},
		vfx = {
			"content/fx/particles/weapons/grenades/stumm_grenade/stumm_grenade",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_shock",
			"wwise/events/weapon/play_explosion_refl_gen",
		},
	},
	fire_grenade = {
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_radius = 0.25,
		radius = 1,
		static_power_level = 600,
		damage_profile = DamageProfileTemplates.default_grenade,
		damage_type = damage_types.laser,
		explosion_area_suppression = {
			distance = 10,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 12,
		},
		vfx = {
			"content/fx/particles/weapons/grenades/fire_grenade/fire_grenade_player_initial_blast",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_flame",
			"wwise/events/weapon/play_explosion_refl_small",
		},
	},
	krak_grenade = {
		boss_power_level_modifier = 0.8,
		close_radius = 1.5,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 1.5,
		min_radius = 1.5,
		radius = 5,
		scalable_radius = true,
		static_power_level = 500,
		close_damage_profile = DamageProfileTemplates.close_krak_grenade,
		close_damage_type = damage_types.plasma,
		damage_profile = DamageProfileTemplates.krak_grenade,
		damage_type = damage_types.plasma,
		explosion_area_suppression = {
			distance = 6,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 8,
		},
		vfx = {
			"content/fx/particles/weapons/grenades/krak_grenade/krak_grenade_explosion",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_krak",
			"wwise/events/weapon/play_explosion_refl_gen",
		},
	},
	smoke_grenade = {
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 2,
		min_radius = 5,
		radius = 10,
		scalable_radius = true,
		static_power_level = 100,
		close_damage_profile = DamageProfileTemplates.smoke_grenade,
		close_damage_type = damage_types.physical,
		damage_profile = DamageProfileTemplates.smoke_grenade,
		damage_type = damage_types.physical,
		explosion_area_suppression = {
			distance = 15,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 20,
		},
		vfx = {
			"content/fx/particles/weapons/grenades/smoke_grenade/smoke_grenade_initial_blast",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_smoke",
			"wwise/events/weapon/play_explosion_refl_small",
		},
	},
	ogryn_grenade_frag = {
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 2,
		min_radius = 16,
		radius = 16,
		scalable_radius = true,
		static_power_level = 500,
		close_damage_profile = DamageProfileTemplates.close_ogryn_grenade,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.ogryn_grenade,
		damage_type = damage_types.grenade_frag,
		explosion_area_suppression = {
			distance = 25,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 25,
		},
		scalable_vfx = {
			{
				min_radius = 10,
				radius_variable_name = "radius",
				effects = {
					"content/fx/particles/explosions/frag_grenade_ogryn",
				},
			},
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_frag_ogryn",
			"wwise/events/weapon/play_explosion_refl_huge",
		},
	},
	ogryn_box_cluster_frag = {
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 2,
		min_radius = 5,
		radius = 8,
		scalable_radius = true,
		static_power_level = 500,
		close_damage_profile = DamageProfileTemplates.ogryn_box_cluster_close_frag_grenade,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.ogryn_box_cluster_frag_grenade,
		damage_type = damage_types.grenade_frag,
		explosion_area_suppression = {
			distance = 15,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 20,
		},
		radius_stat_buffs = {
			"explosion_radius_modifier_frag",
		},
		scalable_vfx = {
			{
				min_radius = 5,
				radius_variable_name = "radius",
				effects = {
					"content/fx/particles/explosions/frag_grenade_01",
				},
			},
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_frag",
			"wwise/events/weapon/play_explosion_refl_gen",
		},
	},
}

return explosion_templates
