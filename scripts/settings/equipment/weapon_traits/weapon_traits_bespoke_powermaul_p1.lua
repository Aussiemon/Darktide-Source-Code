local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_powermaul_p1_stacking_increase_impact_on_hit = {
	weapon_trait_bespoke_powermaul_p1_stacking_increase_impact_on_hit_parent = {
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.15
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.2
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.25
			}
		}
	}
}
templates.weapon_trait_bespoke_powermaul_p1_consecutive_hits_increases_stagger = {
	weapon_trait_bespoke_powermaul_p1_consecutive_hits_increases_stagger_parent = {
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.05
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.075
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.09
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_powermaul_p1_staggered_targets_receive_increased_damage_debuff = {
	weapon_trait_bespoke_powermaul_p1_staggered_targets_receive_increased_damage_debuff = {
		{
			target_buff_data = {
				num_stacks_on_proc = 1
			}
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 2
			}
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 3
			}
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 4
			}
		}
	}
}
templates.weapon_trait_bespoke_powermaul_p1_staggered_targets_receive_increased_stagger_debuff = {
	weapon_trait_bespoke_powermaul_p1_staggered_targets_receive_increased_stagger_debuff = {
		{
			target_buff_data = {
				num_stacks_on_proc = 1
			}
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 2
			}
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 3
			}
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 4
			}
		}
	}
}
templates.weapon_trait_bespoke_powermaul_p1_taunt_target_on_hit = {
	weapon_trait_bespoke_powermaul_p1_taunt_target_on_hit = {
		{}
	}
}

return templates
