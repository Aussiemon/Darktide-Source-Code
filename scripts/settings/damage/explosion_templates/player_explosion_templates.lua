local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local preacher_talent_settings = TalentSettings.zealot_3
local damage_types = DamageSettings.damage_types
local in_melee_range = DamageSettings.in_melee_range
local explosion_templates = {
	warp_charge_overload = {
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
	ogryn_charge_impact = {
		static_power_level = 1000,
		radius = 2.5,
		min_radius = 1.9,
		close_radius = 2.5,
		collision_filter = "filter_player_character_lunge",
		min_close_radius = 2,
		close_damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		close_damage_type = damage_types.ogryn_lunge,
		damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		damage_type = damage_types.ogryn_lunge
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
		min_radius = 2,
		close_radius = 2.75,
		collision_filter = "filter_player_character_lunge",
		min_close_radius = 2,
		close_damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		close_damage_type = damage_types.ogryn_physical,
		damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		damage_type = damage_types.ogryn_physical
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
	ogryn_carapace_armor_explosion = {
		static_power_level = 1000,
		radius = 2.5,
		min_radius = 1.9,
		close_radius = 2.5,
		collision_filter = "filter_player_character_lunge",
		min_close_radius = 2,
		close_damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		close_damage_type = damage_types.ogryn_physical,
		damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		damage_type = damage_types.ogryn_physical
	},
	zealot_preacher_shield_explosion = {
		damage_falloff = true,
		scalable_radius = true,
		collision_filter = "filter_player_character_explosion",
		radius = preacher_talent_settings.combat_ability.radius,
		min_radius = preacher_talent_settings.combat_ability.min_radius,
		close_radius = preacher_talent_settings.combat_ability.close_radius,
		min_close_radius = preacher_talent_settings.combat_ability.min_close_radius,
		close_damage_profile = DamageProfileTemplates.zealot_preacher_ability_close,
		close_damage_type = damage_types.kinetic,
		damage_profile = DamageProfileTemplates.zealot_preacher_ability_far,
		damage_type = damage_types.kinetic,
		static_power_level = preacher_talent_settings.combat_ability.static_power_level,
		explosion_area_suppression = preacher_talent_settings.combat_ability.explosion_area_suppression,
		vfx = {
			"content/fx/particles/abilities/preacher/preacher_bubble_shield_explode_3p"
		},
		sfx = {
			"wwise/events/player/play_ability_zealot_preacher_explosion",
			"wwise/events/weapon/play_explosion_refl_gen"
		}
	}
}

return explosion_templates
