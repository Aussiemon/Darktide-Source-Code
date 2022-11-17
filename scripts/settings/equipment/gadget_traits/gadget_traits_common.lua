local BuffSettings = require("scripts/settings/buff/buff_settings")
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
local meta_stat_buffs = BuffSettings.meta_stat_buffs
local gadget_traits_common = {
	gadget_toughness_increase = {
		gadget_toughness_increase = {
			{
				stat_buffs = {
					[buff_stat_buffs.toughness_bonus] = 0.02
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.toughness_bonus] = 0.03
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.toughness_bonus] = 0.04
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.toughness_bonus] = 0.05
				}
			}
		}
	},
	gadget_health_increase = {
		gadget_health_increase = {
			{
				stat_buffs = {
					[buff_stat_buffs.max_health_modifier] = 0.02
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.max_health_modifier] = 0.03
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.max_health_modifier] = 0.04
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.max_health_modifier] = 0.05
				}
			}
		}
	},
	gadget_toughness_damage_reduction = {
		gadget_toughness_damage_reduction = {
			{
				stat_buffs = {
					[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.8
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.7
				}
			}
		}
	},
	gadget_stamina_increase = {
		gadget_stamina_increase = {
			{
				stat_buffs = {
					[buff_stat_buffs.stamina_modifier] = 1
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.stamina_modifier] = 1
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.stamina_modifier] = 1
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.stamina_modifier] = 1
				}
			}
		}
	},
	gadget_damage_reduction_vs_flamers = {
		gadget_damage_reduction_vs_flamers = {
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_cultist_flamer_multiplier] = 0.95,
					[buff_stat_buffs.damage_taken_by_renegade_flamer_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_cultist_flamer_multiplier] = 0.9,
					[buff_stat_buffs.damage_taken_by_renegade_flamer_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_cultist_flamer_multiplier] = 0.85,
					[buff_stat_buffs.damage_taken_by_renegade_flamer_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_cultist_flamer_multiplier] = 0.8,
					[buff_stat_buffs.damage_taken_by_renegade_flamer_multiplier] = 0.8
				}
			}
		}
	},
	gadget_damage_reduction_vs_snipers = {
		gadget_damage_reduction_vs_snipers = {
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_renegade_sniper_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_renegade_sniper_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_renegade_sniper_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_renegade_sniper_multiplier] = 0.8
				}
			}
		}
	},
	gadget_damage_reduction_vs_grenadiers = {
		gadget_damage_reduction_vs_grenadiers = {
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_renegade_grenadier_multiplier] = 0.95,
					[buff_stat_buffs.damage_taken_by_cultist_grenadier_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_renegade_grenadier_multiplier] = 0.9,
					[buff_stat_buffs.damage_taken_by_cultist_grenadier_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_renegade_grenadier_multiplier] = 0.85,
					[buff_stat_buffs.damage_taken_by_cultist_grenadier_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_renegade_grenadier_multiplier] = 0.8,
					[buff_stat_buffs.damage_taken_by_cultist_grenadier_multiplier] = 0.8
				}
			}
		}
	},
	gadget_damage_reduction_vs_hounds = {
		gadget_damage_reduction_vs_hounds = {
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_chaos_hound_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_chaos_hound_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_chaos_hound_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_chaos_hound_multiplier] = 0.8
				}
			}
		}
	},
	gadget_damage_reduction_vs_mutants = {
		gadget_damage_reduction_vs_mutants = {
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_cultist_mutant_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_cultist_mutant_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_cultist_mutant_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_cultist_mutant_multiplier] = 0.8
				}
			}
		}
	},
	gadget_damage_reduction_vs_gunners = {
		gadget_damage_reduction_vs_gunners = {
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_cultist_gunner_multiplier] = 0.95,
					[buff_stat_buffs.damage_taken_by_renegade_gunner_multiplier] = 0.95,
					[buff_stat_buffs.damage_taken_by_chaos_ogryn_gunner_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_cultist_gunner_multiplier] = 0.9,
					[buff_stat_buffs.damage_taken_by_renegade_gunner_multiplier] = 0.9,
					[buff_stat_buffs.damage_taken_by_chaos_ogryn_gunner_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_cultist_gunner_multiplier] = 0.85,
					[buff_stat_buffs.damage_taken_by_renegade_gunner_multiplier] = 0.85,
					[buff_stat_buffs.damage_taken_by_chaos_ogryn_gunner_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_cultist_gunner_multiplier] = 0.8,
					[buff_stat_buffs.damage_taken_by_renegade_gunner_multiplier] = 0.8,
					[buff_stat_buffs.damage_taken_by_chaos_ogryn_gunner_multiplier] = 0.8
				}
			}
		}
	},
	gadget_damage_reduction_vs_bombers = {
		gadget_damage_reduction_vs_bombers = {
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_chaos_poxwalker_bomber_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_chaos_poxwalker_bomber_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_chaos_poxwalker_bomber_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.damage_taken_by_chaos_poxwalker_bomber_multiplier] = 0.8
				}
			}
		}
	},
	gadget_corruption_resistance = {
		gadget_corruption_resistance = {
			{
				stat_buffs = {
					[buff_stat_buffs.corruption_taken_multiplier] = 0.94
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.corruption_taken_multiplier] = 0.91
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.corruption_taken_multiplier] = 0.88
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.corruption_taken_multiplier] = 0.85
				}
			}
		}
	},
	gadget_mission_xp_increase = {
		gadget_mission_xp_increase = {
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_xp_modifier] = 0.02
				}
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_xp_modifier] = 0.04
				}
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_xp_modifier] = 0.06
				}
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_xp_modifier] = 0.1
				}
			}
		}
	},
	gadget_mission_credits_increase = {
		gadget_mission_credits_increase = {
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_credit_modifier] = 0.04
				}
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_credit_modifier] = 0.06
				}
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_credit_modifier] = 0.08
				}
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_credit_modifier] = 0.1
				}
			}
		}
	},
	gadget_mission_reward_gear_instead_of_weapon_increase = {
		gadget_mission_reward_gear_instead_of_weapon_increase = {
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_gear_instead_of_weapon_modifier] = 0.05
				}
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_gear_instead_of_weapon_modifier] = 0.1
				}
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_gear_instead_of_weapon_modifier] = 0.15
				}
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_gear_instead_of_weapon_modifier] = 0.2
				}
			}
		}
	},
	gadget_permanent_damage_resistance = {
		gadget_permanent_damage_resistance = {
			{
				stat_buffs = {
					[buff_stat_buffs.permanent_damage_converter_resistance] = 0.05
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.permanent_damage_converter_resistance] = 0.1
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.permanent_damage_converter_resistance] = 0.15
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.permanent_damage_converter_resistance] = 0.2
				}
			}
		}
	},
	gadget_revive_speed_increase = {
		gadget_revive_speed_increase = {
			{
				stat_buffs = {
					[buff_stat_buffs.revive_speed_modifier] = 0.06
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.revive_speed_modifier] = 0.08
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.revive_speed_modifier] = 0.1
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.revive_speed_modifier] = 0.12
				}
			}
		}
	},
	gadget_cooldown_reduction = {
		gadget_cooldown_reduction = {
			{
				stat_buffs = {
					[buff_stat_buffs.ability_cooldown_modifier] = -0.01
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.ability_cooldown_modifier] = -0.02
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.ability_cooldown_modifier] = -0.03
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.ability_cooldown_modifier] = -0.04
				}
			}
		}
	},
	gadget_sprint_cost_reduction = {
		gadget_sprint_cost_reduction = {
			{
				stat_buffs = {
					[buff_stat_buffs.sprinting_cost_multiplier] = 0.94
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.sprinting_cost_multiplier] = 0.91
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.sprinting_cost_multiplier] = 0.88
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.sprinting_cost_multiplier] = 0.85
				}
			}
		}
	},
	gadget_block_cost_reduction = {
		gadget_block_cost_reduction = {
			{
				stat_buffs = {
					[buff_stat_buffs.block_cost_multiplier] = 0.94
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.block_cost_multiplier] = 0.92
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.block_cost_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.block_cost_multiplier] = 0.88
				}
			}
		}
	},
	gadget_stamina_regeneration = {
		gadget_stamina_regeneration = {
			{
				stat_buffs = {
					[buff_stat_buffs.stamina_regeneration_modifier] = 0.06
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.stamina_regeneration_modifier] = 0.08
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.stamina_regeneration_modifier] = 0.1
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.stamina_regeneration_modifier] = 0.12
				}
			}
		}
	},
	gadget_toughness_regen_delay = {
		gadget_toughness_regen_delay = {
			{
				stat_buffs = {
					[buff_stat_buffs.toughness_regen_delay_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.toughness_regen_delay_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.toughness_regen_delay_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.toughness_regen_delay_multiplier] = 0.8
				}
			}
		}
	}
}

return gadget_traits_common
