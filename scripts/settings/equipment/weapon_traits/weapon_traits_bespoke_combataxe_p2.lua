﻿-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combataxe_p2.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_combataxe_p2_increase_power_on_hit = {
	buffs = {
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
	},
}
templates.weapon_trait_bespoke_combataxe_p2_chained_hits_increases_power = {
	buffs = {
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
	},
}
templates.weapon_trait_bespoke_combataxe_p2_chained_hits_increases_crit_chance = {
	buffs = {
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
	},
}
templates.weapon_trait_bespoke_combataxe_p2_infinite_melee_cleave_on_weakspot_kill = {
	buffs = {
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
	},
}
templates.weapon_trait_bespoke_combataxe_p2_power_bonus_on_first_attack = {
	buffs = {
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
	},
}
templates.weapon_trait_bespoke_combataxe_p2_power_bonus_scaled_on_stamina = {
	buffs = {
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
	},
}
templates.weapon_trait_bespoke_combataxe_p2_guaranteed_melee_crit_after_crit_weakspot_kill = {
	buffs = {
		weapon_trait_bespoke_combataxe_p2_guaranteed_melee_crit_after_crit_weakspot_kill = {
			{
				buff_data = {
					num_stacks_on_proc = 4,
				},
			},
			{
				buff_data = {
					num_stacks_on_proc = 6,
				},
			},
			{
				buff_data = {
					num_stacks_on_proc = 8,
				},
			},
			{
				buff_data = {
					num_stacks_on_proc = 10,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_combataxe_p2_consecutive_melee_hits_same_target_increases_melee_power = {
	buffs = {
		weapon_trait_bespoke_combataxe_p2_consecutive_melee_hits_same_target_increases_melee_power_parent = {
			{
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.04,
				},
			},
			{
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.06,
				},
			},
			{
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.08,
				},
			},
			{
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_combataxe_p2_weakspot_hit_resets_dodge_count = {
	buffs = {
		weapon_trait_bespoke_combataxe_p2_weakspot_hit_resets_dodge_count = {
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.025,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.05,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.075,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.1,
				},
			},
		},
	},
}

return templates
