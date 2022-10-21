local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {
	weapon_trait_bespoke_combataxe_p3_chained_hits_increases_power = {
		weapon_trait_bespoke_combataxe_p3_chained_hits_increases_power_parent = {
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.15
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.175
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.2
				}
			}
		}
	},
	weapon_trait_bespoke_combataxe_p3_consecutive_hits_increases_stagger = {
		weapon_trait_bespoke_combataxe_p3_consecutive_hits_increases_stagger = {
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
					[stat_buffs.melee_impact_modifier] = 0.14
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
					[stat_buffs.power_level_modifier] = 0.05
				}
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.15
				}
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.2
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
						[stat_buffs.power_level_modifier] = -0.15
					}
				}
			},
			{
				conditional_stat_buffs = {
					{
						[stat_buffs.power_level_modifier] = 0.2
					},
					{
						[stat_buffs.power_level_modifier] = -0.2
					}
				}
			},
			{
				conditional_stat_buffs = {
					{
						[stat_buffs.power_level_modifier] = 0.25
					},
					{
						[stat_buffs.power_level_modifier] = -0.25
					}
				}
			}
		}
	},
	weapon_trait_bespoke_combataxe_p3_power_bonus_scaled_on_stamina = {
		weapon_trait_bespoke_combataxe_p3_power_bonus_scaled_on_stamina = {
			{
				lerped_stat_buffs = {
					[stat_buffs.power_level_modifier] = {
						max = 0.02,
						min = 0
					}
				}
			},
			{
				lerped_stat_buffs = {
					[stat_buffs.power_level_modifier] = {
						max = 0.03,
						min = 0
					}
				}
			},
			{
				lerped_stat_buffs = {
					[stat_buffs.power_level_modifier] = {
						max = 0.04,
						min = 0
					}
				}
			},
			{
				lerped_stat_buffs = {
					[stat_buffs.power_level_modifier] = {
						max = 0.05,
						min = 0
					}
				}
			}
		}
	},
	weapon_trait_bespoke_combataxe_p3_stacking_increase_impact_on_hit = {
		weapon_trait_bespoke_combataxe_p3_stacking_increase_impact_on_hit_parent = {
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
	},
	weapon_trait_bespoke_combataxe_p3_stacking_rending_on_weakspot = {
		weapon_trait_bespoke_combataxe_p3_stacking_rending_on_weakspot_parent = {
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.rending_multiplier] = 0.06
				}
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.rending_multiplier] = 0.12
				}
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.rending_multiplier] = 0.17
				}
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.rending_multiplier] = 0.2
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
					[stat_buffs.weakspot_damage] = 0.1
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.125
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.14
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.15
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
