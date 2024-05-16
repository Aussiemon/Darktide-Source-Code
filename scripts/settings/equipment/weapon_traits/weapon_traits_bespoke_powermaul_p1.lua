-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powermaul_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events

templates.weapon_trait_bespoke_powermaul_p1_stacking_increase_impact_on_hit = {
	weapon_trait_bespoke_powermaul_p1_stacking_increase_impact_on_hit_parent = {
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.19,
			},
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.21,
			},
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.23,
			},
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.25,
			},
		},
	},
}
templates.weapon_trait_bespoke_powermaul_p1_consecutive_hits_increases_stagger = {
	weapon_trait_bespoke_powermaul_p1_consecutive_hits_increases_stagger_parent = {
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.075,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.125,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.15,
			},
		},
	},
}
templates.weapon_trait_bespoke_powermaul_p1_staggered_targets_receive_increased_damage_debuff = {
	weapon_trait_bespoke_powermaul_p1_staggered_targets_receive_increased_damage_debuff = {
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
}
templates.weapon_trait_bespoke_powermaul_p1_staggered_targets_receive_increased_stagger_debuff = {
	weapon_trait_bespoke_powermaul_p1_staggered_targets_receive_increased_stagger_debuff = {
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
}
templates.weapon_trait_bespoke_powermaul_p1_rending_vs_staggered = {
	weapon_trait_bespoke_powermaul_p1_rending_vs_staggered = {
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
}
templates.weapon_trait_bespoke_powermaul_p1_negate_stagger_reduction_on_weakspot = {
	weapon_trait_bespoke_powermaul_p1_negate_stagger_reduction_on_weakspot = {
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.4,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.3,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.2,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.1,
			},
		},
	},
}
templates.weapon_trait_bespoke_powermaul_p1_windup_increases_power = {
	weapon_trait_bespoke_powermaul_p1_windup_increases_power_parent = {
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
}
templates.weapon_trait_bespoke_powermaul_p1_block_has_chance_to_stun = {
	weapon_trait_bespoke_powermaul_p1_block_has_chance_to_stun = {
		{
			proc_events = {
				[proc_events.on_block] = 0.1,
				[proc_events.on_perfect_block] = 0.4,
			},
		},
		{
			proc_events = {
				[proc_events.on_block] = 0.15,
				[proc_events.on_perfect_block] = 0.6,
			},
		},
		{
			proc_events = {
				[proc_events.on_block] = 0.2,
				[proc_events.on_perfect_block] = 0.8,
			},
		},
		{
			proc_events = {
				[proc_events.on_block] = 0.25,
				[proc_events.on_perfect_block] = 1,
			},
		},
	},
}
templates.weapon_trait_bespoke_powermaul_p1_staggering_hits_has_chance_to_stun = {
	weapon_trait_bespoke_powermaul_p1_staggering_hits_has_chance_to_stun = {
		{
			proc_events = {
				[proc_events.on_hit] = 0.1,
			},
		},
		{
			proc_events = {
				[proc_events.on_hit] = 0.15,
			},
		},
		{
			proc_events = {
				[proc_events.on_hit] = 0.2,
			},
		},
		{
			proc_events = {
				[proc_events.on_hit] = 0.25,
			},
		},
	},
}
templates.weapon_trait_bespoke_powermaul_p1_damage_bonus_vs_electrocuted = {
	weapon_trait_bespoke_powermaul_p1_damage_bonus_vs_electrocuted = {
		{
			stat_buffs = {
				[stat_buffs.damage_vs_electrocuted] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.damage_vs_electrocuted] = 0.15,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.damage_vs_electrocuted] = 0.2,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.damage_vs_electrocuted] = 0.25,
			},
		},
	},
}

return templates
