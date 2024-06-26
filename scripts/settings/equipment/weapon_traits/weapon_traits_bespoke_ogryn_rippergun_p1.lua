-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_rippergun_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_rippergun_p1_suppression_on_close_kill = {
	weapon_trait_bespoke_ogryn_rippergun_p1_suppression_on_close_kill = {
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
}
templates.weapon_trait_bespoke_ogryn_rippergun_p1_increase_close_damage_on_close_kill = {
	weapon_trait_bespoke_ogryn_rippergun_p1_increase_close_damage_on_close_kill_parent = {
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.damage_near] = 0.07,
			},
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.damage_near] = 0.08,
			},
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.damage_near] = 0.09,
			},
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.damage_near] = 0.1,
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_close_range_kills = {
	weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_close_range_kills = {
		{
			toughness_fixed_percentage = 0.045,
		},
		{
			toughness_fixed_percentage = 0.05,
		},
		{
			toughness_fixed_percentage = 0.055,
		},
		{
			toughness_fixed_percentage = 0.06,
		},
	},
}
templates.weapon_trait_bespoke_ogryn_rippergun_p1_armor_rending_bayonette = {
	weapon_trait_bespoke_ogryn_rippergun_p1_armor_rending_bayonette = {
		{
			target_buff_data = {
				num_stacks_on_proc = 10,
			},
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 12,
			},
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 14,
			},
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 16,
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_rippergun_p1_stacking_crit_bonus_on_continuous_fire = {
	weapon_trait_bespoke_ogryn_rippergun_p1_stacking_crit_bonus_on_continuous_fire = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.035,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.045,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05,
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_continuous_fire = {
	weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_continuous_fire = {
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
}
templates.weapon_trait_bespoke_ogryn_rippergun_p1_power_bonus_on_continuous_fire = {
	weapon_trait_bespoke_ogryn_rippergun_p1_power_bonus_on_continuous_fire = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05,
			},
		},
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
	},
}
templates.weapon_trait_bespoke_ogryn_rippergun_p1_bleed_on_crit = {
	weapon_trait_bespoke_ogryn_rippergun_p1_bleed_on_crit = {
		{
			target_buff_data = {
				num_stacks_on_proc = 3,
			},
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 4,
			},
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 5,
			},
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 6,
			},
		},
	},
}

return templates
