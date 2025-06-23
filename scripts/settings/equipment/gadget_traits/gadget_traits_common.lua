-- chunkname: @scripts/settings/equipment/gadget_traits/gadget_traits_common.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local meta_stat_buffs = BuffSettings.meta_stat_buffs
local gadget_traits_common = {}

table.make_unique(gadget_traits_common)

gadget_traits_common.gadget_toughness_increase = {
	format_values = {
		toughness_bonus = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_toughness_increase",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.toughness_bonus
				}
			}
		}
	},
	buffs = {
		gadget_toughness_increase = {
			{
				stat_buffs = {
					[stat_buffs.toughness_bonus] = 0.02
				}
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_bonus] = 0.03
				}
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_bonus] = 0.04
				}
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_bonus] = 0.05
				}
			}
		}
	}
}
gadget_traits_common.gadget_health_increase = {
	format_values = {
		max_health_modifier = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_health_increase",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.max_health_modifier
				}
			}
		}
	},
	buffs = {
		gadget_health_increase = {
			{
				stat_buffs = {
					[stat_buffs.max_health_modifier] = 0.02
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_health_modifier] = 0.03
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_health_modifier] = 0.04
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_health_modifier] = 0.05
				}
			}
		}
	}
}
gadget_traits_common.gadget_toughness_damage_reduction = {
	format_values = {
		toughness_damage_modifier = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_toughness_damage_reduction",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.toughness_damage_taken_multiplier
				}
			},
			value_manipulation = function (value)
				return 100 - value * 100
			end
		}
	},
	buffs = {
		gadget_toughness_damage_reduction = {
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.8
				}
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.7
				}
			}
		}
	}
}
gadget_traits_common.gadget_stamina_increase = {
	buffs = {
		gadget_stamina_increase = {
			{},
			{},
			{},
			{}
		}
	}
}
gadget_traits_common.gadget_innate_ammo_increase = {
	buffs = {
		gadget_innate_ammo_increase = {
			{},
			{},
			{},
			{}
		}
	}
}
gadget_traits_common.gadget_innate_health_increase = {
	buffs = {
		gadget_innate_health_increase = {
			{},
			{},
			{},
			{}
		}
	}
}
gadget_traits_common.gadget_innate_max_wounds_increase = {
	buffs = {
		gadget_innate_max_wounds_increase = {
			{},
			{},
			{},
			{}
		}
	}
}
gadget_traits_common.gadget_innate_toughness_increase = {
	buffs = {
		gadget_innate_toughness_increase = {
			{},
			{},
			{},
			{}
		}
	}
}
gadget_traits_common.gadget_damage_reduction_vs_flamers = {
	format_values = {
		damage_reduction = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_damage_reduction_vs_flamers",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_taken_by_cultist_flamer_multiplier
				}
			},
			value_manipulation = function (value)
				return 100 - value * 100
			end
		}
	},
	buffs = {
		gadget_damage_reduction_vs_flamers = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_flamer_multiplier] = 0.95,
					[stat_buffs.damage_taken_by_renegade_flamer_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_flamer_multiplier] = 0.9,
					[stat_buffs.damage_taken_by_renegade_flamer_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_flamer_multiplier] = 0.85,
					[stat_buffs.damage_taken_by_renegade_flamer_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_flamer_multiplier] = 0.8,
					[stat_buffs.damage_taken_by_renegade_flamer_multiplier] = 0.8
				}
			}
		}
	}
}
gadget_traits_common.gadget_damage_reduction_vs_snipers = {
	format_values = {
		damage_reduction = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_damage_reduction_vs_snipers",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_taken_by_renegade_sniper_multiplier
				}
			},
			value_manipulation = function (value)
				return 100 - value * 100
			end
		}
	},
	buffs = {
		gadget_damage_reduction_vs_snipers = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_renegade_sniper_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_renegade_sniper_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_renegade_sniper_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_renegade_sniper_multiplier] = 0.8
				}
			}
		}
	}
}
gadget_traits_common.gadget_damage_reduction_vs_grenadiers = {
	format_values = {
		damage_reduction = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_damage_reduction_vs_grenadiers",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_taken_by_renegade_grenadier_multiplier
				}
			},
			value_manipulation = function (value)
				return 100 - value * 100
			end
		}
	},
	buffs = {
		gadget_damage_reduction_vs_grenadiers = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_renegade_grenadier_multiplier] = 0.95,
					[stat_buffs.damage_taken_by_cultist_grenadier_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_renegade_grenadier_multiplier] = 0.9,
					[stat_buffs.damage_taken_by_cultist_grenadier_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_renegade_grenadier_multiplier] = 0.85,
					[stat_buffs.damage_taken_by_cultist_grenadier_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_renegade_grenadier_multiplier] = 0.8,
					[stat_buffs.damage_taken_by_cultist_grenadier_multiplier] = 0.8
				}
			}
		}
	}
}
gadget_traits_common.gadget_damage_reduction_vs_hounds = {
	format_values = {
		damage_reduction = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_damage_reduction_vs_hounds",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_taken_by_chaos_hound_multiplier
				}
			},
			value_manipulation = function (value)
				return 100 - value * 100
			end
		}
	},
	buffs = {
		gadget_damage_reduction_vs_hounds = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_chaos_hound_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_chaos_hound_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_chaos_hound_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_chaos_hound_multiplier] = 0.8
				}
			}
		}
	}
}
gadget_traits_common.gadget_damage_reduction_vs_mutants = {
	format_values = {
		damage_reduction = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_damage_reduction_vs_mutants",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_taken_by_cultist_mutant_multiplier
				}
			},
			value_manipulation = function (value)
				return 100 - value * 100
			end
		}
	},
	buffs = {
		gadget_damage_reduction_vs_mutants = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_mutant_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_mutant_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_mutant_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_mutant_multiplier] = 0.8
				}
			}
		}
	}
}
gadget_traits_common.gadget_damage_reduction_vs_gunners = {
	format_values = {
		damage_reduction = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_damage_reduction_vs_gunners",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_taken_by_cultist_gunner_multiplier
				}
			},
			value_manipulation = function (value)
				return 100 - value * 100
			end
		}
	},
	buffs = {
		gadget_damage_reduction_vs_gunners = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_gunner_multiplier] = 0.95,
					[stat_buffs.damage_taken_by_renegade_gunner_multiplier] = 0.95,
					[stat_buffs.damage_taken_by_chaos_ogryn_gunner_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_gunner_multiplier] = 0.9,
					[stat_buffs.damage_taken_by_renegade_gunner_multiplier] = 0.9,
					[stat_buffs.damage_taken_by_chaos_ogryn_gunner_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_gunner_multiplier] = 0.85,
					[stat_buffs.damage_taken_by_renegade_gunner_multiplier] = 0.85,
					[stat_buffs.damage_taken_by_chaos_ogryn_gunner_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_cultist_gunner_multiplier] = 0.8,
					[stat_buffs.damage_taken_by_renegade_gunner_multiplier] = 0.8,
					[stat_buffs.damage_taken_by_chaos_ogryn_gunner_multiplier] = 0.8
				}
			}
		}
	}
}
gadget_traits_common.gadget_damage_reduction_vs_bombers = {
	format_values = {
		damage_reduction = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_damage_reduction_vs_bombers",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_taken_by_chaos_poxwalker_bomber_multiplier
				}
			},
			value_manipulation = function (value)
				return 100 - value * 100
			end
		}
	},
	buffs = {
		gadget_damage_reduction_vs_bombers = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_chaos_poxwalker_bomber_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_chaos_poxwalker_bomber_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_chaos_poxwalker_bomber_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_by_chaos_poxwalker_bomber_multiplier] = 0.8
				}
			}
		}
	}
}
gadget_traits_common.gadget_corruption_resistance = {
	format_values = {
		corruption_taken_multiplier = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_corruption_resistance",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.corruption_taken_multiplier
				}
			},
			value_manipulation = function (value)
				return 100 - value * 100
			end
		}
	},
	buffs = {
		gadget_corruption_resistance = {
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.94
				}
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.91
				}
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.88
				}
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.85
				}
			}
		}
	}
}
gadget_traits_common.gadget_mission_xp_increase = {
	format_values = {
		mission_reward_xp_modifier = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_mission_xp_increase",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					meta_stat_buffs.mission_reward_xp_modifier
				}
			}
		}
	},
	buffs = {
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
	}
}
gadget_traits_common.gadget_mission_credits_increase = {
	format_values = {
		mission_reward_credit_modifier = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_mission_credits_increase",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					meta_stat_buffs.mission_reward_credit_modifier
				}
			}
		}
	},
	buffs = {
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
	}
}
gadget_traits_common.gadget_mission_reward_gear_instead_of_weapon_increase = {
	format_values = {
		mission_reward_gear_instead_of_weapon_modifier = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_mission_reward_gear_instead_of_weapon_increase",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					meta_stat_buffs.mission_reward_gear_instead_of_weapon_modifier
				}
			}
		}
	},
	buffs = {
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
	}
}
gadget_traits_common.gadget_permanent_damage_resistance = {
	format_values = {
		permanent_damage_converter_resistance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_permanent_damage_resistance",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.corruption_taken_grimoire_multiplier
				}
			},
			value_manipulation = function (value)
				return 100 - value * 100
			end
		}
	},
	buffs = {
		gadget_permanent_damage_resistance = {
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_grimoire_multiplier] = 0.95
				}
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_grimoire_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_grimoire_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_grimoire_multiplier] = 0.8
				}
			}
		}
	}
}
gadget_traits_common.gadget_revive_speed_increase = {
	format_values = {
		revive_speed_modifier = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_revive_speed_increase",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.revive_speed_modifier
				}
			}
		}
	},
	buffs = {
		gadget_revive_speed_increase = {
			{
				stat_buffs = {
					[stat_buffs.revive_speed_modifier] = 0.06
				}
			},
			{
				stat_buffs = {
					[stat_buffs.revive_speed_modifier] = 0.08
				}
			},
			{
				stat_buffs = {
					[stat_buffs.revive_speed_modifier] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.revive_speed_modifier] = 0.12
				}
			}
		}
	}
}
gadget_traits_common.gadget_cooldown_reduction = {
	format_values = {
		ability_cooldown_modifier = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_cooldown_reduction",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.ability_cooldown_modifier
				}
			},
			value_manipulation = function (value)
				return -value * 100
			end
		}
	},
	buffs = {
		gadget_cooldown_reduction = {
			{
				stat_buffs = {
					[stat_buffs.ability_cooldown_modifier] = -0.01
				}
			},
			{
				stat_buffs = {
					[stat_buffs.ability_cooldown_modifier] = -0.02
				}
			},
			{
				stat_buffs = {
					[stat_buffs.ability_cooldown_modifier] = -0.03
				}
			},
			{
				stat_buffs = {
					[stat_buffs.ability_cooldown_modifier] = -0.04
				}
			}
		}
	}
}
gadget_traits_common.gadget_sprint_cost_reduction = {
	format_values = {
		sprinting_cost_multiplier = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_sprint_cost_reduction",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.sprinting_cost_multiplier
				}
			},
			value_manipulation = function (value)
				return 100 - value * 100
			end
		}
	},
	buffs = {
		gadget_sprint_cost_reduction = {
			{
				stat_buffs = {
					[stat_buffs.sprinting_cost_multiplier] = 0.94
				}
			},
			{
				stat_buffs = {
					[stat_buffs.sprinting_cost_multiplier] = 0.91
				}
			},
			{
				stat_buffs = {
					[stat_buffs.sprinting_cost_multiplier] = 0.88
				}
			},
			{
				stat_buffs = {
					[stat_buffs.sprinting_cost_multiplier] = 0.85
				}
			}
		}
	}
}
gadget_traits_common.gadget_block_cost_reduction = {
	format_values = {
		block_cost_multiplier = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_block_cost_reduction",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.block_cost_multiplier
				}
			},
			value_manipulation = function (value)
				return 100 - value * 100
			end
		}
	},
	buffs = {
		gadget_block_cost_reduction = {
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.94
				}
			},
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.92
				}
			},
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.88
				}
			}
		}
	}
}
gadget_traits_common.gadget_stamina_regeneration = {
	format_values = {
		stamina_regeneration_modifier = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_stamina_regeneration",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.stamina_regeneration_modifier
				}
			}
		}
	},
	buffs = {
		gadget_stamina_regeneration = {
			{
				stat_buffs = {
					[stat_buffs.stamina_regeneration_modifier] = 0.06
				}
			},
			{
				stat_buffs = {
					[stat_buffs.stamina_regeneration_modifier] = 0.08
				}
			},
			{
				stat_buffs = {
					[stat_buffs.stamina_regeneration_modifier] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.stamina_regeneration_modifier] = 0.12
				}
			}
		}
	}
}
gadget_traits_common.gadget_toughness_regen_delay = {
	format_values = {
		toughness_regen_delay_multiplier = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "gadget_toughness_regen_delay",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.toughness_regen_rate_modifier
				}
			}
		}
	},
	buffs = {
		gadget_toughness_regen_delay = {
			{
				stat_buffs = {
					[stat_buffs.toughness_regen_delay_multiplier] = 0.95,
					[stat_buffs.toughness_regen_rate_modifier] = 0.075
				}
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_regen_delay_multiplier] = 0.9,
					[stat_buffs.toughness_regen_rate_modifier] = 0.15
				}
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_regen_delay_multiplier] = 0.85,
					[stat_buffs.toughness_regen_rate_modifier] = 0.225
				}
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_regen_delay_multiplier] = 0.8,
					[stat_buffs.toughness_regen_rate_modifier] = 0.3
				}
			}
		}
	}
}

return gadget_traits_common
