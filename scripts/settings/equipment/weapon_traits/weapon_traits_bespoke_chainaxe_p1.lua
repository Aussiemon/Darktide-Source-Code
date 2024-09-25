-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_chainaxe_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_chainaxe_p1_guaranteed_melee_crit_on_activated_kill = {
	buffs = {
		weapon_trait_bespoke_chainaxe_p1_guaranteed_melee_crit_on_activated_kill = {
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
templates.weapon_trait_bespoke_chainaxe_p1_bleed_on_activated_hit = {
	buffs = {
		weapon_trait_bespoke_chainaxe_p1_bleed_on_activated_hit = {
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
	},
}
templates.weapon_trait_bespoke_chainaxe_p1_movement_speed_on_activation = {
	buffs = {
		weapon_trait_bespoke_chainaxe_p1_movement_speed_on_activation = {
			{
				active_duration = 2,
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.17,
				},
			},
			{
				active_duration = 2,
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.18,
				},
			},
			{
				active_duration = 2,
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.19,
				},
			},
			{
				active_duration = 2,
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_chainaxe_p1_increase_power_on_hit = {
	buffs = {
		weapon_trait_bespoke_chainaxe_p1_increase_power_on_hit_parent = {
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
templates.weapon_trait_bespoke_chainaxe_p1_increase_power_on_kill = {
	buffs = {
		weapon_trait_bespoke_chainaxe_p1_increase_power_on_kill_parent = {
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
	},
}
templates.weapon_trait_bespoke_chainaxe_p1_windup_increases_power = {
	buffs = {
		weapon_trait_bespoke_chainaxe_p1_windup_increases_power_parent = {
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_chainaxe_p1_targets_receive_rending_debuff = {
	buffs = {
		weapon_trait_bespoke_chainaxe_p1_targets_receive_rending_debuff = {
			{
				target_buff_data = {
					num_stacks_on_proc = 1,
				},
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 2,
				},
			},
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
		},
	},
}
templates.weapon_trait_bespoke_chainaxe_p1_rending_vs_staggered = {
	buffs = {
		weapon_trait_bespoke_chainaxe_p1_rending_vs_staggered = {
			{
				conditional_stat_buffs = {
					[stat_buffs.rending_vs_staggered_multiplier] = 0.1,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.rending_vs_staggered_multiplier] = 0.15,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.rending_vs_staggered_multiplier] = 0.2,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.rending_vs_staggered_multiplier] = 0.25,
				},
			},
		},
	},
}

return templates
