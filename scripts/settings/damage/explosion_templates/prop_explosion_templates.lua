-- chunkname: @scripts/settings/damage/explosion_templates/prop_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local explosion_templates = {
	explosive_barrel = {
		close_radius = 3,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = false,
		min_close_radius = 0.5,
		min_radius = 3,
		override_friendly_fire = true,
		radius = 6,
		scalable_radius = true,
		static_power_level = 500,
		close_damage_profile = DamageProfileTemplates.barrel_explosion_close,
		damage_profile = DamageProfileTemplates.barrel_explosion,
		vfx = {
			"content/fx/particles/explosions/frag_grenade_01",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_barrel_explosion",
			"wwise/events/weapon/play_explosion_refl_gen",
		},
	},
	fire_barrel = {
		close_radius = 0.5,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 0.5,
		min_radius = 3,
		override_friendly_fire = true,
		radius = 5,
		scalable_radius = true,
		static_power_level = 500,
		close_damage_profile = DamageProfileTemplates.fire_barrel_explosion_close,
		damage_profile = DamageProfileTemplates.fire_barrel_explosion,
		vfx = {
			"content/fx/particles/destructibles/explosive_barrel_explosion",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_barrel_flame",
			"wwise/events/weapon/play_explosion_refl_small",
		},
	},
	breach_charge_explosion = {
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 0.5,
		min_radius = 4,
		override_friendly_fire = true,
		radius = 5,
		scalable_radius = true,
		close_damage_profile = DamageProfileTemplates.breach_charge_explosion,
		damage_profile = DamageProfileTemplates.breach_charge_explosion,
	},
	corruptor_emerge = {
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = false,
		min_close_radius = 1,
		min_radius = 6,
		override_friendly_fire = true,
		radius = 8,
		scalable_radius = true,
		close_damage_profile = DamageProfileTemplates.corruptor_emerge_explosion,
		damage_profile = DamageProfileTemplates.corruptor_emerge_explosion,
		vfx = {
			"content/fx/particles/enemies/corruptor/corruptor_core_erupt",
		},
	},
}

return explosion_templates
