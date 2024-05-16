-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combataxe_p2.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_combataxe_p2_increase_power_on_hit = {
	weapon_trait_bespoke_combataxe_p2_increase_power_on_hit_parent = {
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.035,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.04,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.045,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.05,
			},
		},
	},
}
templates.weapon_trait_bespoke_combataxe_p2_chained_hits_increases_power = {
	weapon_trait_bespoke_combataxe_p2_chained_hits_increases_power_parent = {
		{
			max_stacks = 10,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.02,
			},
		},
		{
			max_stacks = 10,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.03,
			},
		},
		{
			max_stacks = 10,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.04,
			},
		},
		{
			max_stacks = 10,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.05,
			},
		},
	},
}
templates.weapon_trait_bespoke_combataxe_p2_chained_hits_increases_crit_chance = {
	weapon_trait_bespoke_combataxe_p2_chained_hits_increases_crit_chance_parent = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.025,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.03,
			},
		},
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
	},
}
templates.weapon_trait_bespoke_combataxe_p2_infinite_melee_cleave_on_weakspot_kill = {
	weapon_trait_bespoke_combataxe_p2_infinite_melee_cleave_on_weakspot_kill = {
		{
			stat_buffs = {
				[stat_buffs.melee_weakspot_damage] = 0.075,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_weakspot_damage] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_weakspot_damage] = 0.125,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_weakspot_damage] = 0.15,
			},
		},
	},
}
templates.weapon_trait_bespoke_combataxe_p2_power_bonus_on_first_attack = {
	weapon_trait_bespoke_combataxe_p2_power_bonus_on_first_attack = {
		{
			no_power_duration = 5,
			conditional_switch_stat_buffs = {
				{
					[stat_buffs.melee_power_level_modifier] = 0.6,
				},
			},
		},
		{
			no_power_duration = 4.5,
			conditional_switch_stat_buffs = {
				{
					[stat_buffs.melee_power_level_modifier] = 0.6,
				},
			},
		},
		{
			no_power_duration = 4,
			conditional_switch_stat_buffs = {
				{
					[stat_buffs.melee_power_level_modifier] = 0.6,
				},
			},
		},
		{
			no_power_duration = 3.5,
			conditional_switch_stat_buffs = {
				{
					[stat_buffs.melee_power_level_modifier] = 0.6,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_combataxe_p2_power_bonus_scaled_on_stamina = {
	weapon_trait_bespoke_combataxe_p2_power_bonus_scaled_on_stamina = {
		{
			conditional_switch_stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.05,
			},
		},
		{
			conditional_switch_stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.06,
			},
		},
		{
			conditional_switch_stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.07,
			},
		},
		{
			conditional_switch_stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.08,
			},
		},
	},
}
templates.weapon_trait_bespoke_combataxe_p2_guaranteed_melee_crit_after_crit_weakspot_kill = {
	weapon_trait_bespoke_combataxe_p2_guaranteed_melee_crit_after_crit_weakspot_kill = {
		{},
	},
}

return templates
