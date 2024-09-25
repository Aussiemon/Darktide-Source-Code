-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_thumper_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_thumper_p1_hipfire_while_sprinting = {
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p1_hipfire_while_sprinting = {
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.3,
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.3,
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.09,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.3,
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.12,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.3,
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.15,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_thumper_p1_suppression_on_close_kill = {
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p1_suppression_on_close_kill = {
			{
				suppression_settings = {
					distance = 12,
					instant_aggro = true,
					suppression_falloff = false,
					suppression_value = 15,
				},
			},
			{
				suppression_settings = {
					distance = 12,
					instant_aggro = true,
					suppression_falloff = false,
					suppression_value = 20,
				},
			},
			{
				suppression_settings = {
					distance = 12,
					instant_aggro = true,
					suppression_falloff = false,
					suppression_value = 25,
				},
			},
			{
				suppression_settings = {
					distance = 12,
					instant_aggro = true,
					suppression_falloff = false,
					suppression_value = 30,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_thumper_p1_toughness_on_continuous_fire = {
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p1_toughness_on_continuous_fire = {
			{
				toughness_fixed_percentage = 0.01,
			},
			{
				toughness_fixed_percentage = 0.02,
			},
			{
				toughness_fixed_percentage = 0.03,
			},
			{
				toughness_fixed_percentage = 0.04,
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_continuous_fire = {
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.07,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.08,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.09,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_thumper_p1_crit_chance_based_on_aim_time = {
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p1_crit_chance_based_on_aim_time = {
			{
				duration_per_stack = 0.35,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
			{
				duration_per_stack = 0.3,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
			{
				duration_per_stack = 0.25,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
			{
				duration_per_stack = 0.2,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_thumper_p1_weapon_special_power_bonus_after_one_shots = {
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p1_weapon_special_power_bonus_after_one_shots = {
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.3,
				},
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.34,
				},
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.38,
				},
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.42,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_hitting_single_enemy_with_all = {
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_hitting_single_enemy_with_all = {
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.18,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.22,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.26,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.3,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_thumper_p1_shot_power_bonus_after_weapon_special_cleave = {
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p1_shot_power_bonus_after_weapon_special_cleave = {
			{
				proc_stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.06,
				},
				buff_data = {
					required_num_hits = 3,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.09,
				},
				buff_data = {
					required_num_hits = 3,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.12,
				},
				buff_data = {
					required_num_hits = 3,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.15,
				},
				buff_data = {
					required_num_hits = 3,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_thumper_p1_pass_past_armor_on_weapon_special = {
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p1_pass_past_armor_on_weapon_special = {
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.25,
				},
			},
		},
	},
}

return templates
