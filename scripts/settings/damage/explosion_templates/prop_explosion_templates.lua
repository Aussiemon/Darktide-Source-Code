local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local explosion_templates = {
	explosive_barrel = {
		damage_falloff = false,
		radius = 6,
		scalable_radius = true,
		min_radius = 3,
		close_radius = 3,
		static_power_level = 500,
		collision_filter = "filter_player_character_explosion",
		override_friendly_fire = true,
		min_close_radius = 0.5,
		close_damage_profile = DamageProfileTemplates.barrel_explosion_close,
		damage_profile = DamageProfileTemplates.barrel_explosion,
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
		scalable_radius = true,
		min_radius = 3,
		close_radius = 0.5,
		static_power_level = 500,
		collision_filter = "filter_player_character_explosion",
		override_friendly_fire = true,
		min_close_radius = 0.5,
		close_damage_profile = DamageProfileTemplates.fire_barrel_explosion_close,
		damage_profile = DamageProfileTemplates.fire_barrel_explosion,
		vfx = {
			"content/fx/particles/destructibles/explosive_barrel_explosion"
		},
		sfx = {
			"wwise/events/weapon/play_explosion_barrel_flame",
			"wwise/events/weapon/play_explosion_refl_small"
		}
	},
	corruptor_emerge = {
		damage_falloff = false,
		radius = 8,
		scalable_radius = true,
		min_radius = 6,
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		override_friendly_fire = true,
		min_close_radius = 1,
		close_damage_profile = DamageProfileTemplates.corruptor_emerge_explosion,
		damage_profile = DamageProfileTemplates.corruptor_emerge_explosion,
		vfx = {
			"content/fx/particles/enemies/corruptor/corruptor_core_erupt"
		}
	}
}

return explosion_templates
