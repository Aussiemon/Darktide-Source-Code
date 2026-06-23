-- chunkname: @scripts/settings/damage/explosion_templates/player_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local overload_keystone_talent_settings = TalentSettings.cryptic.overload
local damage_types = DamageSettings.damage_types
local explosion_templates = {
	warp_charge_overload = {
		close_radius = 1.5,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		damage_type = nil,
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
		radius_stat_buffs = {
			"overheat_explosion_radius_modifier",
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
		broadphase_explosion_filter = {
			"heroes",
			"villains",
		},
	},
	ogryn_charge_impact_damage = {
		close_damage_type = nil,
		close_radius = 2.5,
		collision_filter = "filter_player_character_lunge",
		damage_type = nil,
		min_close_radius = 2,
		min_radius = 1.9,
		radius = 2.5,
		static_power_level = 1000,
		close_damage_profile = DamageProfileTemplates.ogryn_charge_finish_damage,
		damage_profile = DamageProfileTemplates.ogryn_charge_finish_damage,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
		},
	},
	ogryn_bonebreaker_passive_aoe_stagger = {
		close_radius = 2.75,
		collision_filter = "filter_player_character_lunge",
		min_close_radius = 2,
		min_radius = 2,
		override_friendly_fire = false,
		radius = 3,
		static_power_level = 1000,
		close_damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		close_damage_type = damage_types.ogryn_physical,
		damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		damage_type = damage_types.ogryn_physical,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
		},
	},
	zealot_charge_impact_with_burning = {
		close_damage_type = nil,
		close_radius = 2.5,
		collision_filter = "filter_player_character_lunge",
		damage_type = nil,
		min_close_radius = 2,
		min_radius = 1.9,
		on_hit_buff_template_name = "flamer_assault",
		radius = 2.5,
		static_power_level = 1000,
		close_damage_profile = DamageProfileTemplates.zealot_dash_impact,
		damage_profile = DamageProfileTemplates.zealot_dash_impact,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
		},
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
		override_friendly_fire = false,
		radius = 2.5,
		static_power_level = 1000,
		close_damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		close_damage_type = damage_types.ogryn_physical,
		damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		damage_type = damage_types.ogryn_physical,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
		},
	},
	adamant_forceful_explosion = {
		close_radius = 2.5,
		collision_filter = "filter_player_character_lunge",
		min_close_radius = 2,
		min_radius = 1.9,
		override_friendly_fire = false,
		radius = 2.5,
		static_power_level = 500,
		close_damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		close_damage_type = damage_types.ogryn_physical,
		damage_profile = DamageProfileTemplates.ogryn_charge_finish,
		damage_type = damage_types.ogryn_physical,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
		},
	},
	hordes_buff_critical_kill_explosion = {
		boss_power_level_modifier = 0.8,
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 2,
		min_radius = 3,
		radius = 3,
		scalable_radius = true,
		skip_ragdoll_interaction = true,
		static_power_level = 240,
		close_damage_profile = DamageProfileTemplates.close_krak_grenade,
		close_damage_type = damage_types.plasma,
		damage_profile = DamageProfileTemplates.krak_grenade,
		damage_type = damage_types.plasma,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
		},
		explosion_area_suppression = {
			distance = 6,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 15,
		},
		vfx = {
			"content/fx/particles/player_buffs/buff_critical_explosion",
		},
		sfx = {
			"wwise/events/player/play_horde_mode_buff_critical_blood_explosion",
		},
	},
	hordes_buff_explosion_on_toughness_broken = {
		close_radius = 2,
		collision_filter = "filter_player_character_explosion",
		damage_falloff = true,
		min_close_radius = 2,
		min_radius = 16,
		radius = 16,
		scalable_radius = true,
		skip_ragdoll_interaction = true,
		static_power_level = 400,
		close_damage_profile = DamageProfileTemplates.close_ogryn_grenade,
		close_damage_type = damage_types.grenade_frag,
		damage_profile = DamageProfileTemplates.ogryn_grenade,
		damage_type = damage_types.grenade_frag,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
		explosion_area_suppression = {
			distance = 25,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 25,
		},
		vfx = {
			"content/fx/particles/player_buffs/buff_big_breaking_toughness_explosion_01",
		},
		sfx = {
			"wwise/events/player/play_horde_mode_buff_big_boom",
		},
	},
	broker_vultures_mark_aoe_stagger = {
		collision_filter = "filter_player_character_explosion",
		min_radius = 3,
		radius = 3,
		scalable_radius = true,
		skip_ragdoll_interaction = true,
		damage_profile = DamageProfileTemplates.broker_vultures_mark_aoe_stagger,
		damage_type = damage_types.grenade_frag,
		broadphase_explosion_filter = {
			"villains",
		},
	},
	broker_passive_knockback_on_taking_melee_damage = {
		collision_filter = "filter_player_character_explosion",
		min_radius = 3,
		radius = 3,
		scalable_radius = true,
		skip_ragdoll_interaction = true,
		damage_profile = DamageProfileTemplates.broker_passive_knockback_on_taking_melee_damage,
		damage_type = damage_types.grenade_frag,
		broadphase_explosion_filter = {
			"villains",
		},
	},
	cryptic_discharge_aoe_electrocution_base = {
		collision_filter = "filter_player_character_explosion",
		min_radius = 6,
		on_hit_buff_template_name = "cryptic_discharge_shock",
		radius = 6,
		skip_ragdoll_interaction = true,
		damage_profile = DamageProfileTemplates.cryptic_discharge_explosion,
		damage_type = damage_types.electrocution,
		broadphase_explosion_filter = {
			"villains",
		},
		vfx = {
			"content/fx/particles/abilities/cryptic/voltaic_emitter_size_01",
		},
	},
	cryptic_discharge_weapon_malfunction = {
		collision_filter = "filter_player_character_explosion",
		min_radius = 30,
		radius = 30,
		skip_ragdoll_interaction = true,
		damage_profile = DamageProfileTemplates.cryptic_discharge_weapon_malfunction_explosion,
		damage_type = damage_types.electrocution,
		broadphase_explosion_filter = {
			"villains",
		},
	},
	cryptic_force_field_explosion = {
		collision_filter = "filter_player_character_explosion",
		on_hit_buff_template_name = "cryptic_discharge_shock",
		skip_ragdoll_interaction = false,
		radius = TalentSettings.cryptic.force_field.range,
		min_radius = TalentSettings.cryptic.force_field.range,
		damage_profile = DamageProfileTemplates.force_field_explosion_damage,
		damage_type = damage_types.electrocution,
		broadphase_explosion_filter = {
			"villains",
		},
		vfx = {
			"content/fx/particles/abilities/cryptic/cryptic_force_field_electric_explosion",
		},
		sfx = {
			{
				event_name = "wwise/events/player/play_player_ability_discharge_light",
				has_husk_events = true,
			},
		},
	},
	cryptic_overload_keystone_debuff_explosion = {
		collision_filter = "filter_player_character_explosion",
		on_hit_buff_template_name = "cryptic_overload_keystone_increase_damage_taken_debuff",
		skip_ragdoll_interaction = true,
		radius = overload_keystone_talent_settings.aoe_radius,
		min_radius = overload_keystone_talent_settings.aoe_radius,
		damage_profile = DamageProfileTemplates.cryptic_overload_keystone_debuff_explosion,
		damage_type = damage_types.buff,
		broadphase_explosion_filter = {
			"villains",
		},
		vfx = {
			"content/fx/particles/abilities/cryptic/cryptic_force_field_electric_explosion",
		},
		sfx = {
			{
				event_name = "wwise/events/player/play_player_ability_discharge_light",
				has_husk_events = true,
			},
		},
	},
}

explosion_templates.cryptic_discharge_aoe_electrocution_base_two = table.clone(explosion_templates.cryptic_discharge_aoe_electrocution_base)
explosion_templates.cryptic_discharge_aoe_electrocution_base_two.radius = 9
explosion_templates.cryptic_discharge_aoe_electrocution_base_two.min_radius = 9
explosion_templates.cryptic_discharge_aoe_electrocution_base_two.vfx = {
	"content/fx/particles/abilities/cryptic/voltaic_emitter_size_02",
}
explosion_templates.cryptic_discharge_aoe_electrocution_base_three = table.clone(explosion_templates.cryptic_discharge_aoe_electrocution_base)
explosion_templates.cryptic_discharge_aoe_electrocution_base_three.radius = 12
explosion_templates.cryptic_discharge_aoe_electrocution_base_three.min_radius = 12
explosion_templates.cryptic_discharge_aoe_electrocution_base_three.vfx = {
	"content/fx/particles/abilities/cryptic/voltaic_emitter_01",
}
explosion_templates.cryptic_discharge_aoe_electrocution = table.clone(explosion_templates.cryptic_discharge_aoe_electrocution_base_three)
explosion_templates.cryptic_discharge_aoe_electrocution.vfx = {
	"content/fx/particles/abilities/cryptic/voltaic_emitter_01",
}

return explosion_templates
