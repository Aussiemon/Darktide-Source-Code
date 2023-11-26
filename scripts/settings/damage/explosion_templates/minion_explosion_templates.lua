-- chunkname: @scripts/settings/damage/explosion_templates/minion_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {
	renegade_grenadier_fire_grenade_impact = {
		damage_falloff = false,
		radius = 2.5,
		min_radius = 2,
		collision_filter = "filter_minion_explosion",
		close_radius = 1,
		static_power_level = 0,
		scalable_radius = true,
		min_close_radius = 0.5,
		close_damage_profile = DamageProfileTemplates.renegade_grenadier_fire_grenade_impact_close,
		damage_profile = DamageProfileTemplates.renegade_grenadier_fire_grenade_impact,
		vfx = {
			"content/fx/particles/weapons/grenades/flame_grenade_initial_blast"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_flame_minion",
			"wwise/events/weapon/play_explosion_refl_small"
		}
	},
	poxwalker_bomber = {
		damage_falloff = false,
		radius = 6,
		scalable_radius = true,
		min_radius = 3,
		close_radius = 3,
		collision_filter = "filter_minion_explosion",
		override_friendly_fire = true,
		min_close_radius = 0.5,
		close_damage_profile = DamageProfileTemplates.poxwalker_explosion_close,
		damage_profile = DamageProfileTemplates.poxwalker_explosion,
		vfx = {
			"content/fx/particles/explosions/poxwalker_explode"
		},
		sfx = {
			"wwise/events/minions/play_explosion_bomber",
			"wwise/events/weapon/play_explosion_refl_gen"
		}
	},
	beast_of_nurgle_death = {
		damage_falloff = false,
		radius = 6,
		min_radius = 3,
		collision_filter = "filter_minion_explosion",
		close_radius = 3,
		scalable_radius = true,
		min_close_radius = 0.5,
		close_damage_profile = DamageProfileTemplates.poxwalker_explosion_close,
		damage_profile = DamageProfileTemplates.poxwalker_explosion,
		vfx = {
			"content/fx/particles/enemies/beast_of_nurgle/bon_death_splatter"
		},
		sfx = {
			"wwise/events/minions/play_beast_of_nurgle_death_explode"
		}
	},
	renegade_captain_bolt_shell_kill = {
		damage_falloff = true,
		radius = 5,
		scalable_radius = false,
		collision_filter = "filter_minion_explosion",
		damage_profile = DamageProfileTemplates.renegade_captain_bolt_pistol_kill_explosion,
		damage_type = damage_types.boltshell,
		vfx = {
			"content/fx/particles/weapons/rifles/bolter/bolter_burrowed_explode"
		},
		sfx = {
			"wwise/events/weapon/play_bullet_hits_explosive_gen_husk"
		}
	},
	renegade_captain_bolt_shell_stop = {
		damage_falloff = true,
		radius = 3,
		scalable_radius = false,
		collision_filter = "filter_minion_explosion",
		damage_profile = DamageProfileTemplates.renegade_captain_bolt_pistol_stop_explosion,
		damage_type = damage_types.boltshell,
		explosion_area_suppression = {
			distance = 4,
			suppression_value = 4
		},
		vfx = {
			"content/fx/particles/weapons/rifles/bolter/bolter_bullet_surface_explode"
		},
		sfx = {
			"wwise/events/weapon/play_bullet_hits_explosive_gen_husk"
		}
	},
	renegade_captain_plasma_stop = {
		damage_falloff = true,
		radius = 3,
		scalable_radius = false,
		collision_filter = "filter_minion_explosion",
		damage_profile = DamageProfileTemplates.renegade_captain_bolt_pistol_stop_explosion,
		damage_type = damage_types.boltshell,
		explosion_area_suppression = {
			distance = 4,
			suppression_value = 4
		},
		vfx = {
			"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_medium"
		}
	},
	renegade_captain_fire_grenade = {
		damage_falloff = false,
		radius = 5,
		min_radius = 2.5,
		collision_filter = "filter_minion_explosion",
		close_radius = 2.5,
		static_power_level = 500,
		scalable_radius = true,
		min_close_radius = 0.5,
		close_damage_profile = DamageProfileTemplates.renegade_grenadier_fire_grenade_impact_close,
		damage_profile = DamageProfileTemplates.renegade_grenadier_fire_grenade_impact,
		vfx = {
			"content/fx/particles/weapons/grenades/flame_grenade_initial_blast"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_flame_minion",
			"wwise/events/weapon/play_explosion_refl_small"
		}
	},
	renegade_captain_frag_grenade = {
		damage_falloff = true,
		radius = 10,
		min_radius = 5,
		scalable_radius = true,
		close_radius = 2,
		collision_filter = "filter_minion_explosion",
		static_power_level = 500,
		min_close_radius = 2,
		close_damage_profile = DamageProfileTemplates.renegade_captain_frag_grenade_close,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.renegade_captain_frag_grenade,
		damage_type = damage_types.grenade_frag,
		vfx = {
			"content/fx/particles/explosions/frag_grenade_01"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_frag",
			"wwise/events/weapon/play_explosion_refl_gen"
		}
	},
	renegade_shocktrooper_frag_grenade = {
		damage_falloff = true,
		radius = 4,
		min_radius = 3,
		scalable_radius = true,
		close_radius = 2,
		collision_filter = "filter_minion_explosion",
		static_power_level = 500,
		min_close_radius = 3,
		close_damage_profile = DamageProfileTemplates.renegade_shocktrooper_frag_grenade_close,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.renegade_shocktrooper_frag_grenade,
		damage_type = damage_types.grenade_frag,
		vfx = {
			"content/fx/particles/explosions/frag_grenade_01"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_frag",
			"wwise/events/weapon/play_explosion_refl_gen"
		}
	},
	renegade_captain_toughness_depleted = {
		damage_falloff = false,
		radius = 8,
		min_radius = 3,
		collision_filter = "filter_minion_explosion",
		close_radius = 3,
		scalable_radius = true,
		min_close_radius = 0.5,
		close_damage_profile = DamageProfileTemplates.renegade_captain_toughness_depleted,
		damage_profile = DamageProfileTemplates.renegade_captain_toughness_depleted,
		vfx = {
			"content/fx/particles/enemies/renegade_captain/renegade_captain_shield_burst"
		},
		sfx = {
			"wwise/events/minions/play_traitor_captain_shield_break"
		}
	},
	chaos_hound_pounced_explosion = {
		damage_falloff = false,
		radius = 3.5,
		min_radius = 2,
		collision_filter = "filter_minion_explosion",
		close_radius = 2,
		scalable_radius = true,
		min_close_radius = 0.5,
		close_damage_profile = DamageProfileTemplates.chaos_hound_push,
		damage_profile = DamageProfileTemplates.chaos_hound_push,
		vfx = {
			"content/fx/particles/enemies/chaos_hound/chaos_hound_pounce"
		}
	},
	purple_stimmed_explosion = {
		damage_falloff = false,
		radius = 0.2,
		min_radius = 0.1,
		collision_filter = "filter_minion_explosion",
		close_radius = 0.1,
		static_power_level = 0,
		scalable_radius = true,
		min_close_radius = 0.05,
		close_damage_profile = DamageProfileTemplates.chaos_hound_push,
		damage_profile = DamageProfileTemplates.chaos_hound_push,
		vfx = {
			"content/fx/particles/enemies/purple_stimmed_explosion"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_gas",
			"wwise/events/weapon/play_explosion_refl_small"
		}
	}
}

return explosion_templates
