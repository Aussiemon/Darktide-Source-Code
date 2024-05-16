-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combatsword_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_combatsword_p1_chained_hits_increases_melee_cleave = {
	weapon_trait_bespoke_combatsword_p1_chained_hits_increases_melee_cleave_parent = {
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.25,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.3,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.35,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.4,
			},
		},
	},
}
templates.weapon_trait_bespoke_combatsword_p1_chained_hits_increases_crit_chance = {
	weapon_trait_bespoke_combatsword_p1_chained_hits_increases_crit_chance_parent = {
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
templates.weapon_trait_bespoke_combatsword_p1_increased_attack_cleave_on_multiple_hits = {
	weapon_trait_bespoke_combatsword_p1_increased_attack_cleave_on_multiple_hits = {
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 1.4,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 1.6,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 1.8,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 2,
			},
		},
	},
}
templates.weapon_trait_bespoke_combatsword_p1_increased_melee_damage_on_multiple_hits = {
	weapon_trait_bespoke_combatsword_p1_increased_melee_damage_on_multiple_hits = {
		{
			active_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.24,
			},
		},
		{
			active_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.28,
			},
		},
		{
			active_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.32,
			},
		},
		{
			active_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.36,
			},
		},
	},
}
templates.weapon_trait_bespoke_combatsword_p1_infinite_melee_cleave_on_crit = {
	weapon_trait_bespoke_combatsword_p1_infinite_melee_cleave_on_crit = {
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.65,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.7,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.75,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.8,
			},
		},
	},
}
templates.weapon_trait_bespoke_combatsword_p1_stacking_increase_impact_on_hit = {
	weapon_trait_bespoke_combatsword_p1_stacking_increase_impact_on_hit_parent = {
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
templates.weapon_trait_bespoke_combatsword_p1_staggered_targets_receive_increased_stagger_debuff = {
	weapon_trait_bespoke_combatsword_p1_staggered_targets_receive_increased_stagger_debuff = {
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
templates.weapon_trait_bespoke_combatsword_p1_staggered_targets_receive_increased_damage_debuff = {
	weapon_trait_bespoke_combatsword_p1_staggered_targets_receive_increased_damage_debuff = {
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
templates.weapon_trait_bespoke_combatsword_p1_increase_stagger_per_hit_in_sweep = {
	weapon_trait_bespoke_combatsword_p1_increase_stagger_per_hit_in_sweep_parent = {
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.14,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.16,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.18,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.2,
			},
		},
	},
}
templates.weapon_trait_bespoke_combatsword_p1_consecutive_hits_increases_stagger = {
	weapon_trait_bespoke_combatsword_p1_consecutive_hits_increases_stagger_parent = {
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
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.2,
			},
		},
	},
}

return templates
