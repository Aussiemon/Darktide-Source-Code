-- chunkname: @scripts/settings/equipment/gadget_traits/gadget_traits_common.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local meta_stat_buffs = BuffSettings.meta_stat_buffs
local gadget_traits_common = {}

table.make_unique(gadget_traits_common)

gadget_traits_common.gadget_toughness_increase = {
	buffs = {
		gadget_toughness_increase = {
			{
				stat_buffs = {
					[stat_buffs.toughness_bonus] = 0.02,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_bonus] = 0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_bonus] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_bonus] = 0.05,
				},
			},
		},
	},
}
gadget_traits_common.gadget_health_increase = {
	buffs = {
		gadget_health_increase = {
			{
				stat_buffs = {
					[stat_buffs.max_health_modifier] = 0.02,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_health_modifier] = 0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_health_modifier] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_health_modifier] = 0.05,
				},
			},
		},
	},
}
gadget_traits_common.gadget_toughness_damage_reduction = {
	buffs = {
		gadget_toughness_damage_reduction = {
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.95,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.8,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.7,
				},
			},
		},
	},
}
gadget_traits_common.gadget_stamina_increase = {
	buffs = {
		gadget_stamina_increase = {
			{},
			{},
			{},
			{},
		},
	},
}
gadget_traits_common.gadget_damage_reduction_vs_flamers = {
	buffs = {
		gadget_damage_reduction_vs_flamers = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_flamer_multiplier] = 0.95,
					[stat_buffs.damage_taken_by_renegade_flamer_multiplier] = 0.95,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_flamer_multiplier] = 0.9,
					[stat_buffs.damage_taken_by_renegade_flamer_multiplier] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_flamer_multiplier] = 0.85,
					[stat_buffs.damage_taken_by_renegade_flamer_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_flamer_multiplier] = 0.8,
					[stat_buffs.damage_taken_by_renegade_flamer_multiplier] = 0.8,
				},
			},
		},
	},
}
gadget_traits_common.gadget_damage_reduction_vs_snipers = {
	buffs = {
		gadget_damage_reduction_vs_snipers = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_renegade_sniper_multiplier] = 0.95,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_renegade_sniper_multiplier] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_renegade_sniper_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_renegade_sniper_multiplier] = 0.8,
				},
			},
		},
	},
}
gadget_traits_common.gadget_damage_reduction_vs_grenadiers = {
	buffs = {
		gadget_damage_reduction_vs_grenadiers = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_renegade_grenadier_multiplier] = 0.95,
					[stat_buffs.damage_taken_by_cultist_grenadier_multiplier] = 0.95,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_renegade_grenadier_multiplier] = 0.9,
					[stat_buffs.damage_taken_by_cultist_grenadier_multiplier] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_renegade_grenadier_multiplier] = 0.85,
					[stat_buffs.damage_taken_by_cultist_grenadier_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_renegade_grenadier_multiplier] = 0.8,
					[stat_buffs.damage_taken_by_cultist_grenadier_multiplier] = 0.8,
				},
			},
		},
	},
}
gadget_traits_common.gadget_damage_reduction_vs_hounds = {
	buffs = {
		gadget_damage_reduction_vs_hounds = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_chaos_hound_multiplier] = 0.95,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_chaos_hound_multiplier] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_chaos_hound_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_chaos_hound_multiplier] = 0.8,
				},
			},
		},
	},
}
gadget_traits_common.gadget_damage_reduction_vs_mutants = {
	buffs = {
		gadget_damage_reduction_vs_mutants = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_mutant_multiplier] = 0.95,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_mutant_multiplier] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_mutant_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_mutant_multiplier] = 0.8,
				},
			},
		},
	},
}
gadget_traits_common.gadget_damage_reduction_vs_gunners = {
	buffs = {
		gadget_damage_reduction_vs_gunners = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_gunner_multiplier] = 0.95,
					[stat_buffs.damage_taken_by_renegade_gunner_multiplier] = 0.95,
					[stat_buffs.damage_taken_by_chaos_ogryn_gunner_multiplier] = 0.95,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_gunner_multiplier] = 0.9,
					[stat_buffs.damage_taken_by_renegade_gunner_multiplier] = 0.9,
					[stat_buffs.damage_taken_by_chaos_ogryn_gunner_multiplier] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_gunner_multiplier] = 0.85,
					[stat_buffs.damage_taken_by_renegade_gunner_multiplier] = 0.85,
					[stat_buffs.damage_taken_by_chaos_ogryn_gunner_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_gunner_multiplier] = 0.8,
					[stat_buffs.damage_taken_by_renegade_gunner_multiplier] = 0.8,
					[stat_buffs.damage_taken_by_chaos_ogryn_gunner_multiplier] = 0.8,
				},
			},
		},
	},
}
gadget_traits_common.gadget_damage_reduction_vs_bombers = {
	buffs = {
		gadget_damage_reduction_vs_bombers = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_chaos_poxwalker_bomber_multiplier] = 0.95,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_chaos_poxwalker_bomber_multiplier] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_chaos_poxwalker_bomber_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_chaos_poxwalker_bomber_multiplier] = 0.8,
				},
			},
		},
	},
}
gadget_traits_common.gadget_corruption_resistance = {
	buffs = {
		gadget_corruption_resistance = {
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.94,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.91,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.88,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.85,
				},
			},
		},
	},
}
gadget_traits_common.gadget_mission_xp_increase = {
	buffs = {
		gadget_mission_xp_increase = {
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_xp_modifier] = 0.02,
				},
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_xp_modifier] = 0.04,
				},
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_xp_modifier] = 0.06,
				},
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_xp_modifier] = 0.1,
				},
			},
		},
	},
}
gadget_traits_common.gadget_mission_credits_increase = {
	buffs = {
		gadget_mission_credits_increase = {
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_credit_modifier] = 0.04,
				},
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_credit_modifier] = 0.06,
				},
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_credit_modifier] = 0.08,
				},
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_credit_modifier] = 0.1,
				},
			},
		},
	},
}
gadget_traits_common.gadget_mission_reward_gear_instead_of_weapon_increase = {
	buffs = {
		gadget_mission_reward_gear_instead_of_weapon_increase = {
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_gear_instead_of_weapon_modifier] = 0.05,
				},
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_gear_instead_of_weapon_modifier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_gear_instead_of_weapon_modifier] = 0.15,
				},
			},
			{
				stat_buffs = {
					[meta_stat_buffs.mission_reward_gear_instead_of_weapon_modifier] = 0.2,
				},
			},
		},
	},
}
gadget_traits_common.gadget_permanent_damage_resistance = {
	buffs = {
		gadget_permanent_damage_resistance = {
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_grimoire_multiplier] = 0.95,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_grimoire_multiplier] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_grimoire_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_grimoire_multiplier] = 0.8,
				},
			},
		},
	},
}
gadget_traits_common.gadget_revive_speed_increase = {
	buffs = {
		gadget_revive_speed_increase = {
			{
				stat_buffs = {
					[stat_buffs.revive_speed_modifier] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.revive_speed_modifier] = 0.08,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.revive_speed_modifier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.revive_speed_modifier] = 0.12,
				},
			},
		},
	},
}
gadget_traits_common.gadget_cooldown_reduction = {
	buffs = {
		gadget_cooldown_reduction = {
			{
				stat_buffs = {
					[stat_buffs.ability_cooldown_modifier] = -0.01,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.ability_cooldown_modifier] = -0.02,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.ability_cooldown_modifier] = -0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.ability_cooldown_modifier] = -0.04,
				},
			},
		},
	},
}
gadget_traits_common.gadget_sprint_cost_reduction = {
	buffs = {
		gadget_sprint_cost_reduction = {
			{
				stat_buffs = {
					[stat_buffs.sprinting_cost_multiplier] = 0.94,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.sprinting_cost_multiplier] = 0.91,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.sprinting_cost_multiplier] = 0.88,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.sprinting_cost_multiplier] = 0.85,
				},
			},
		},
	},
}
gadget_traits_common.gadget_block_cost_reduction = {
	buffs = {
		gadget_block_cost_reduction = {
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.94,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.92,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.88,
				},
			},
		},
	},
}
gadget_traits_common.gadget_stamina_regeneration = {
	buffs = {
		gadget_stamina_regeneration = {
			{
				stat_buffs = {
					[stat_buffs.stamina_regeneration_modifier] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stamina_regeneration_modifier] = 0.08,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stamina_regeneration_modifier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stamina_regeneration_modifier] = 0.12,
				},
			},
		},
	},
}
gadget_traits_common.gadget_toughness_regen_delay = {
	buffs = {
		gadget_toughness_regen_delay = {
			{
				stat_buffs = {
					[stat_buffs.toughness_regen_delay_multiplier] = 0.95,
					[stat_buffs.toughness_regen_rate_modifier] = 0.075,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_regen_delay_multiplier] = 0.9,
					[stat_buffs.toughness_regen_rate_modifier] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_regen_delay_multiplier] = 0.85,
					[stat_buffs.toughness_regen_rate_modifier] = 0.225,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_regen_delay_multiplier] = 0.8,
					[stat_buffs.toughness_regen_rate_modifier] = 0.3,
				},
			},
		},
	},
}

return gadget_traits_common
