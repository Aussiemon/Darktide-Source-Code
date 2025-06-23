-- chunkname: @scripts/settings/damage/explosion_templates/prop_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local explosion_templates = {
	explosive_barrel = {
		damage_falloff = false,
		radius = 6,
		min_radius = 3,
		scalable_radius = true,
		close_radius = 3,
		collision_filter = "filter_player_character_explosion",
		override_friendly_fire = true,
		static_power_level = 500,
		min_close_radius = 0.5,
		close_damage_profile = DamageProfileTemplates.barrel_explosion_close,
		damage_profile = DamageProfileTemplates.barrel_explosion,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles"
		},
		vfx = {
			"content/fx/particles/explosions/frag_grenade_01"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_barrel_explosion",
			"wwise/events/weapon/play_explosion_refl_gen"
		}
	},
	fire_barrel = {
		damage_falloff = true,
		radius = 5,
		min_radius = 3,
		scalable_radius = true,
		close_radius = 0.5,
		collision_filter = "filter_player_character_explosion",
		override_friendly_fire = true,
		static_power_level = 500,
		min_close_radius = 0.5,
		close_damage_profile = DamageProfileTemplates.fire_barrel_explosion_close,
		damage_profile = DamageProfileTemplates.fire_barrel_explosion,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles"
		},
		vfx = {
			"content/fx/particles/destructibles/explosive_barrel_explosion"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_barrel_flame",
			"wwise/events/weapon/play_explosion_refl_small"
		}
	},
	breach_charge_explosion = {
		damage_falloff = true,
		radius = 5,
		min_radius = 4,
		scalable_radius = true,
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		override_friendly_fire = true,
		min_close_radius = 0.5,
		close_damage_profile = DamageProfileTemplates.breach_charge_explosion,
		damage_profile = DamageProfileTemplates.breach_charge_explosion,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles"
		}
	},
	corruptor_emerge = {
		damage_falloff = false,
		radius = 8,
		min_radius = 6,
		scalable_radius = true,
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		override_friendly_fire = true,
		min_close_radius = 1,
		close_damage_profile = DamageProfileTemplates.corruptor_emerge_explosion,
		damage_profile = DamageProfileTemplates.corruptor_emerge_explosion,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles"
		},
		vfx = {
			"content/fx/particles/enemies/corruptor/corruptor_core_erupt"
		}
	},
	heresy_shield_1_explosion = {
		damage_falloff = false,
		radius = 45,
		min_radius = 38,
		scalable_radius = true,
		close_radius = 2,
		collision_filter = "filter_explosion_player_only",
		override_friendly_fire = true,
		min_close_radius = 1,
		close_damage_profile = DamageProfileTemplates.corruptor_emerge_explosion,
		damage_profile = DamageProfileTemplates.corruptor_emerge_explosion,
		broadphase_explosion_filter = {
			"heroes"
		}
	},
	heresy_shield_2_explosion = {
		damage_falloff = false,
		radius = 36,
		min_radius = 27,
		scalable_radius = true,
		close_radius = 2,
		collision_filter = "filter_explosion_player_only",
		override_friendly_fire = true,
		min_close_radius = 1,
		close_damage_profile = DamageProfileTemplates.corruptor_emerge_explosion,
		damage_profile = DamageProfileTemplates.corruptor_emerge_explosion,
		broadphase_explosion_filter = {
			"heroes"
		}
	},
	heresy_shield_3_explosion = {
		damage_falloff = false,
		radius = 32,
		min_radius = 14,
		scalable_radius = true,
		close_radius = 2,
		collision_filter = "filter_explosion_player_only",
		override_friendly_fire = true,
		min_close_radius = 1,
		close_damage_profile = DamageProfileTemplates.corruptor_emerge_explosion,
		damage_profile = DamageProfileTemplates.corruptor_emerge_explosion,
		broadphase_explosion_filter = {
			"heroes"
		}
	}
}

return explosion_templates
