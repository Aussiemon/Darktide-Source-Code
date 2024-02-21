local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_lasgun_p2_burninating_on_crit = {
	weapon_trait_bespoke_lasgun_p2_burninating_on_crit = {
		{
			target_buff_data = {
				max_stacks = 10,
				num_stacks_on_proc = 4
			}
		},
		[4] = {
			target_buff_data = {
				max_stacks = 12,
				num_stacks_on_proc = 4
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p2_negate_stagger_reduction_on_weakspot = {
	weapon_trait_bespoke_lasgun_p2_negate_stagger_reduction_on_weakspot = {
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.4
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.3
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.2
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p2_crit_chance_based_on_aim_time = {
	weapon_trait_bespoke_lasgun_p2_crit_chance_based_on_aim_time = {
		{
			duration_per_stack = 0.45,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.1
			}
		},
		{
			duration_per_stack = 0.4,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.1
			}
		},
		{
			duration_per_stack = 0.35,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.1
			}
		},
		{
			duration_per_stack = 0.3,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p2_followup_shots_ranged_damage = {
	weapon_trait_bespoke_lasgun_p2_followup_shots_ranged_damage = {
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.14
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.16
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.18
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p2_stagger_count_bonus_damage = {
	weapon_trait_bespoke_lasgun_p2_stagger_count_bonus_damage = {
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.14
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.16
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.18
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p2_faster_charge_on_chained_secondary_attacks = {
	weapon_trait_bespoke_lasgun_p2_faster_charge_on_chained_secondary_attacks = {
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.06
			}
		},
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.08
			}
		},
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.12
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p2_targets_receive_rending_debuff_on_charged_shots = {
	weapon_trait_bespoke_lasgun_p2_targets_receive_rending_debuff_on_charged_shots = {
		{
			target_buff_data = {
				threshold_num_stacks_on_proc = {
					{
						threshold = 0.25,
						num_stacks = 2
					},
					{
						threshold = 0.75,
						num_stacks = 6
					}
				}
			}
		},
		{
			target_buff_data = {
				threshold_num_stacks_on_proc = {
					{
						threshold = 0.25,
						num_stacks = 4
					},
					{
						threshold = 0.75,
						num_stacks = 8
					}
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p2_target_hit_mass_reduction_on_weakspot_hits = {
	weapon_trait_bespoke_lasgun_p2_target_hit_mass_reduction_on_weakspot_hits = {
		{
			stat_buffs = {
				[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.2
			}
		},
		{
			stat_buffs = {
				[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.3
			}
		},
		{
			stat_buffs = {
				[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.4
			}
		},
		{
			stat_buffs = {
				[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.5
			}
		}
	}
}

return templates
