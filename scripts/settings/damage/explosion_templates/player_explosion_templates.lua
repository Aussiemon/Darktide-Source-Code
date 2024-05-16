-- chunkname: @scripts/settings/damage/explosion_templates/player_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local preacher_talent_settings = TalentSettings.zealot_3
local damage_types = DamageSettings.damage_types
local in_melee_range = DamageSettings.in_melee_range
local explosion_templates = {
	warp_charge_overload = {
		close_radius = 1.5,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		radius = 10,
		static_power_level = 500,
		damage_profile = DamageProfileTemplates.plasma_overheat,
		close_damage_profile = DamageProfileTemplates.plasma_overheat,
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
	ogryn_charge_impact = {
		close_radius = 2.5,
		collision_filter = "filter_player_character_lunge",
		min_close_radius = 2,
		min_radius = 1.9,
		radius = 2.5,
		static_power_level = 1000,
		close_damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		close_damage_type = damage_types.ogryn_lunge,
		damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		damage_type = damage_types.ogryn_lunge,
	},
	ogryn_charge_impact_damage = {
		close_radius = 2.5,
		collision_filter = "filter_player_character_lunge",
		min_close_radius = 2,
		min_radius = 1.9,
		radius = 2.5,
		static_power_level = 1000,
		close_damage_profile = DamageProfileTemplates.ogryn_charge_finish_damage,
		damage_profile = DamageProfileTemplates.ogryn_charge_finish_damage,
	},
	ogryn_bonebreaker_passive_aoe_stagger = {
		close_radius = 2.75,
		collision_filter = "filter_player_character_lunge",
		min_close_radius = 2,
		min_radius = 2,
		radius = 3,
		static_power_level = 1000,
		close_damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		close_damage_type = damage_types.ogryn_physical,
		damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		damage_type = damage_types.ogryn_physical,
	},
	zealot_charge_impact_with_burning = {
		close_radius = 2.5,
		collision_filter = "filter_player_character_lunge",
		min_close_radius = 2,
		min_radius = 1.9,
		on_hit_buff_template_name = "debug_burninating_burning",
		radius = 2.5,
		static_power_level = 1000,
		close_damage_profile = DamageProfileTemplates.zealot_dash_impact,
		damage_profile = DamageProfileTemplates.zealot_dash_impact,
		vfx = {
			"content/fx/particles/weapons/grenades/flame_grenade_initial_blast",
		},
		sfx = {
			"wwise/events/weapon/play_explosion_grenade_flame",
			"wwise/events/weapon/play_explosion_refl_small",
		},
	},
	ogryn_carapace_armor_explosion = {
		close_radius = 2.5,
		collision_filter = "filter_player_character_lunge",
		min_close_radius = 2,
		min_radius = 1.9,
		radius = 2.5,
		static_power_level = 1000,
		close_damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		close_damage_type = damage_types.ogryn_physical,
		damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		damage_type = damage_types.ogryn_physical,
	},
}

return explosion_templates
