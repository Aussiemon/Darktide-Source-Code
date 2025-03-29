-- chunkname: @scripts/settings/damage/explosion_templates/player_weapon_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {
	plasma_rifle_overheat = {
		close_radius = 1.5,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		radius = 10,
		static_power_level = 500,
		damage_profile = DamageProfileTemplates.plasma_overheat,
		close_damage_profile = DamageProfileTemplates.plasma_overheat,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			distance = 15,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 20,
		},
		vfx = {
			"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_large",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_barrel_explosion",
			"wwise/events/weapon/play_explosion_refl_small",
		},
	},
	ogryn_thumper_grenade = {
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		scalable_radius = true,
		static_power_level = 500,
		radius = {
			8,
			12,
		},
		close_radius = {
			1.5,
			3,
		},
		close_damage_profile = DamageProfileTemplates.ogryn_thumper_p1_m2_close,
		close_damage_type = damage_types.laser,
		damage_profile = DamageProfileTemplates.ogryn_thumper_p1_m2_default,
		damage_type = damage_types.laser,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			instant_aggro = true,
			suppression_falloff = true,
			distance = {
				10,
				30,
			},
			suppression_value = {
				20,
				40,
			},
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
	ogryn_thumper_grenade_instant = {
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		scalable_radius = true,
		static_power_level = 500,
		radius = {
			5,
			10,
		},
		close_radius = {
			2,
			3,
		},
		close_damage_profile = DamageProfileTemplates.ogryn_thumper_p1_m2_close_instant,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.ogryn_thumper_p1_m2_default_instant,
		damage_type = damage_types.grenade_frag,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			instant_aggro = true,
			suppression_falloff = true,
			distance = {
				10,
				20,
			},
			suppression_value = {
				10,
				20,
			},
		},
		scalable_vfx = {
			{
				min_radius = 4,
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
	powermaul_activated_impact = {
		collision_filter = "filter_player_character_explosion",
		min_close_radius = 1,
		min_radius = 2,
		override_friendly_fire = false,
		static_power_level = 500,
		radius = {
			4,
			8,
		},
		close_radius = {
			1,
			3,
		},
		close_damage_profile = DamageProfileTemplates.powermaul_explosion,
		close_damage_type = damage_types.blunt_thunder,
		damage_profile = DamageProfileTemplates.powermaul_explosion_outer,
		damage_type = damage_types.blunt_thunder,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			instant_aggro = true,
			suppression_falloff = true,
			distance = {
				10,
				15,
			},
			suppression_value = {
				20,
				50,
			},
		},
		vfx = {
			"content/fx/particles/weapons/power_maul/power_maul_push_shockwave",
		},
		sfx = {
			{
				event_name = "wwise/events/weapon/play_ogryn_powermaul_1h_hit_sparks",
				has_husk_events = true,
			},
		},
	},
	human_powermaul_activated_impact = {
		collision_filter = "filter_player_character_explosion",
		min_close_radius = 1,
		min_radius = 2,
		override_friendly_fire = false,
		static_power_level = 500,
		radius = {
			1,
			3,
		},
		close_radius = {
			1,
			2,
		},
		close_damage_profile = DamageProfileTemplates.powermaul_explosion,
		close_damage_type = damage_types.blunt_thunder,
		damage_profile = DamageProfileTemplates.powermaul_explosion_outer,
		damage_type = damage_types.blunt_thunder,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			instant_aggro = true,
			suppression_falloff = true,
			distance = {
				3,
				6,
			},
			suppression_value = {
				20,
				50,
			},
		},
		vfx = {
			"content/fx/particles/weapons/power_maul/power_maul_push_shockwave",
		},
		sfx = {
			{
				event_name = "wwise/events/weapon/play_ogryn_powermaul_1h_hit_sparks",
				has_husk_events = true,
			},
		},
	},
	human_heavy_powermaul_activated_impact = {
		collision_filter = "filter_player_character_explosion",
		min_close_radius = 1,
		min_radius = 2,
		override_friendly_fire = false,
		static_power_level = 500,
		radius = {
			2.5,
			5,
		},
		close_radius = {
			1,
			2,
		},
		close_damage_profile = DamageProfileTemplates.powermaul_explosion,
		close_damage_type = damage_types.blunt_thunder,
		damage_profile = DamageProfileTemplates.powermaul_explosion_outer,
		damage_type = damage_types.blunt_thunder,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			instant_aggro = true,
			suppression_falloff = true,
			distance = {
				5,
				10,
			},
			suppression_value = {
				20,
				50,
			},
		},
		vfx = {
			"content/fx/particles/weapons/power_maul/power_maul_push_shockwave",
		},
		sfx = {
			{
				event_name = "wwise/events/weapon/play_ogryn_powermaul_1h_hit_sparks",
				has_husk_events = true,
			},
		},
	},
	forcesword_activated_implosion = {
		collision_filter = "filter_player_character_explosion",
		min_close_radius = 2,
		min_radius = 3,
		override_friendly_fire = false,
		static_power_level = 500,
		radius = {
			4,
			8,
		},
		close_radius = {
			1,
			3,
		},
		close_damage_profile = DamageProfileTemplates.forcesword_explosion,
		close_damage_type = damage_types.blunt_thunder,
		damage_profile = DamageProfileTemplates.forcesword_explosion_outer,
		damage_type = damage_types.blunt_thunder,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			instant_aggro = true,
			suppression_falloff = true,
			distance = {
				10,
				15,
			},
			suppression_value = {
				20,
				50,
			},
		},
		vfx = {
			"content/fx/particles/weapons/power_maul/power_maul_push_shockwave",
		},
		sfx = {
			{
				event_name = "wwise/events/weapon/play_explosion_grenade_krak",
				has_husk_events = true,
			},
		},
	},
	trait_buff_flamer_p1_minion_explosion = {
		collision_filter = "filter_player_character_explosion",
		damage_falloff = false,
		min_radius = 0.25,
		radius = 3,
		static_power_level = 1000,
		damage_profile = DamageProfileTemplates.default_grenade,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			distance = 10,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 12,
		},
		vfx = {
			"content/fx/particles/weapon_traits/flamer_minion_explosion",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_buff_flame",
			"wwise/events/weapon/play_explosion_refl_small",
		},
	},
	trait_buff_forcestaff_p2_minion_explosion = {
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_radius = 0.5,
		radius = 4,
		static_power_level = 600,
		damage_profile = DamageProfileTemplates.default_grenade,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			distance = 10,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 12,
		},
		vfx = {
			"content/fx/particles/weapon_traits/flame_staff_minion_explosion",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_buff_flame",
			"wwise/events/weapon/play_explosion_refl_small",
		},
	},
}

local function _create_trait_buff_powersword_2h_lockout_proc_explosion_buff(radius, min_radius, close_radius, min_close_radius)
	return {
		collision_filter = "filter_player_character_explosion",
		override_friendly_fire = false,
		static_power_level = 500,
		radius = radius,
		min_radius = min_radius,
		close_radius = close_radius,
		min_close_radius = min_close_radius,
		close_damage_profile = DamageProfileTemplates.powersword_explosion,
		close_damage_type = damage_types.blunt_thunder,
		damage_profile = DamageProfileTemplates.powersword_explosion_outer,
		damage_type = damage_types.blunt_thunder,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			distance = 5,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 10,
		},
		vfx = {
			"content/fx/particles/weapons/power_maul/power_maul_push_shockwave",
		},
		sfx = {
			{
				event_name = "wwise/events/weapon/play_ogryn_powermaul_1h_hit_sparks",
				has_husk_events = true,
			},
		},
	}
end

explosion_templates.trait_buff_powersword_2h_lockout_proc_explosion_1 = _create_trait_buff_powersword_2h_lockout_proc_explosion_buff(3, 3, 2, 2)
explosion_templates.trait_buff_powersword_2h_lockout_proc_explosion_2 = _create_trait_buff_powersword_2h_lockout_proc_explosion_buff(3.5, 3.5, 2.25, 2.25)
explosion_templates.trait_buff_powersword_2h_lockout_proc_explosion_3 = _create_trait_buff_powersword_2h_lockout_proc_explosion_buff(4, 4, 2.5, 2.5)
explosion_templates.trait_buff_powersword_2h_lockout_proc_explosion_4 = _create_trait_buff_powersword_2h_lockout_proc_explosion_buff(4.5, 4.5, 2.75, 2.75)

return explosion_templates
