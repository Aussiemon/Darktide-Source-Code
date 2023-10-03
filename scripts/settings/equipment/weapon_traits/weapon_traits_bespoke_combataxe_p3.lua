local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {
	weapon_trait_bespoke_combataxe_p3_chained_hits_increases_power = {
		weapon_trait_bespoke_combataxe_p3_chained_hits_increases_power_parent = {
			{
				max_stacks = 10,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.02
				}
			},
			{
				max_stacks = 10,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.03
				}
			},
			{
				max_stacks = 10,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.04
				}
			},
			{
				max_stacks = 10,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05
				}
			}
		}
	},
	weapon_trait_bespoke_combataxe_p3_consecutive_hits_increases_stagger = {
		weapon_trait_bespoke_combataxe_p3_consecutive_hits_increases_stagger_parent = {
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.075
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.125
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.15
				}
			}
		}
	},
	weapon_trait_bespoke_combataxe_p3_windup_increases_power = {
		weapon_trait_bespoke_combataxe_p3_windup_increases_power_parent = {
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.15
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.2
				}
			}
		}
	},
	weapon_trait_bespoke_combataxe_p3_power_bonus_on_first_attack = {
		weapon_trait_bespoke_combataxe_p3_power_bonus_on_first_attack = {
			{
				conditional_stat_buffs = {
					{
						[stat_buffs.power_level_modifier] = 0.1
					},
					{
						[stat_buffs.power_level_modifier] = -0.1
					}
				}
			},
			{
				conditional_stat_buffs = {
					{
						[stat_buffs.power_level_modifier] = 0.15
					},
					{
						[stat_buffs.power_level_modifier] = -0.1
					}
				}
			},
			{
				conditional_stat_buffs = {
					{
						[stat_buffs.power_level_modifier] = 0.2
					},
					{
						[stat_buffs.power_level_modifier] = -0.1
					}
				}
			},
			{
				conditional_stat_buffs = {
					{
						[stat_buffs.power_level_modifier] = 0.25
					},
					{
						[stat_buffs.power_level_modifier] = -0.1
					}
				}
			}
		}
	},
	weapon_trait_bespoke_combataxe_p3_power_bonus_on_first_attack = {
		weapon_trait_bespoke_combataxe_p3_power_bonus_on_first_attack = {
			{
				no_power_duration = 5,
				conditional_stat_buffs = {
					{
						[stat_buffs.melee_power_level_modifier] = 0.6
					}
				}
			},
			{
				no_power_duration = 4.5,
				conditional_stat_buffs = {
					{
						[stat_buffs.melee_power_level_modifier] = 0.6
					}
				}
			},
			{
				no_power_duration = 4,
				conditional_stat_buffs = {
					{
						[stat_buffs.melee_power_level_modifier] = 0.6
					}
				}
			},
			{
				no_power_duration = 3.5,
				conditional_stat_buffs = {
					{
						[stat_buffs.melee_power_level_modifier] = 0.6
					}
				}
			}
		}
	},
	weapon_trait_bespoke_combataxe_p3_power_bonus_scaled_on_stamina = {
		weapon_trait_bespoke_combataxe_p3_power_bonus_scaled_on_stamina = {
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.06
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.07
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.08
				}
			}
		}
	},
	weapon_trait_bespoke_combataxe_p3_stacking_increase_impact_on_hit = {
		weapon_trait_bespoke_combataxe_p3_stacking_increase_impact_on_hit_parent = {
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.19
				}
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.21
				}
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.23
				}
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.25
				}
			}
		}
	},
	weapon_trait_bespoke_combataxe_p3_stacking_rending_on_weakspot = {
		weapon_trait_bespoke_combataxe_p3_stacking_rending_on_weakspot_parent = {
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.rending_multiplier] = 0.12
				}
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.rending_multiplier] = 0.16
				}
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.rending_multiplier] = 0.2
				}
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.rending_multiplier] = 0.24
				}
			}
		}
	},
	weapon_trait_bespoke_combataxe_p3_staggered_targets_receive_increased_damage_debuff = {
		weapon_trait_bespoke_combataxe_p3_staggered_targets_receive_increased_damage_debuff = {
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
	},
	weapon_trait_bespoke_combataxe_p3_increased_weakspot_damage_on_push = {
		weapon_trait_bespoke_combataxe_p3_increased_weakspot_damage_on_push = {
			{
				proc_stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.45
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.5
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.55
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.6
				}
			}
		}
	},
	weapon_trait_bespoke_combataxe_p3_staggered_targets_receive_increased_stagger_debuff = {
		weapon_trait_bespoke_combataxe_p3_staggered_targets_receive_increased_stagger_debuff = {
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
}

return templates
