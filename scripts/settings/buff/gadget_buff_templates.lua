-- chunkname: @scripts/settings/buff/gadget_buff_templates.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local meta_stat_buffs = BuffSettings.meta_stat_buffs

local function value_lerp_2dp(min, max, lerp_t)
	local value = math.lerp(min, max, lerp_t)

	value = math.round_with_precision(value, 2)

	return value
end

local templates = {}

table.make_unique(templates)

local DISPLAY = table.enum("number", "percentage")

templates.gadget_toughness_regen_delay = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_regen_delay_multiplier] = 0.7,
		[stat_buffs.toughness_regen_rate_modifier] = 0.3,
	},
}
templates.gadget_innate_toughness_increase = {
	class_name = "buff",
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.toughness_bonus] = {
			max = 0.2,
			min = 0.05,
			lerp_value_func = value_lerp_2dp,
		},
	},
	localization_info = {
		[stat_buffs.toughness_bonus] = DISPLAY.percentage,
	},
}
templates.gadget_toughness_increase = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_bonus] = 0.05,
	},
}
templates.gadget_innate_health_increase = {
	class_name = "buff",
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.max_health_modifier] = {
			max = 0.25,
			min = 0.05,
			lerp_value_func = value_lerp_2dp,
		},
	},
	localization_info = {
		[stat_buffs.max_health_modifier] = DISPLAY.percentage,
	},
}
templates.gadget_health_increase = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.max_health_modifier] = 0.05,
	},
}
templates.gadget_innate_max_wounds_increase = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.extra_max_amount_of_wounds] = 1,
	},
	localization_info = {
		[stat_buffs.extra_max_amount_of_wounds] = DISPLAY.number,
	},
}
templates.gadget_stamina_increase = {
	class_name = "stepped_range_buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.stamina_modifier] = {
			1,
			2,
			3,
		},
	},
	localization_info = {
		[stat_buffs.stamina_modifier] = DISPLAY.number,
	},
}
templates.gadget_corruption_resistance = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.corruption_taken_multiplier] = 0.8,
	},
}
templates.gadget_mission_xp_increase = {
	meta_buff = true,
	predicted = false,
	meta_stat_buffs = {
		[meta_stat_buffs.mission_reward_xp_modifier] = 0.15,
	},
}
templates.gadget_mission_credits_increase = {
	meta_buff = true,
	predicted = false,
	meta_stat_buffs = {
		[meta_stat_buffs.mission_reward_credit_modifier] = 0.15,
	},
}
templates.gadget_mission_reward_gear_instead_of_weapon_increase = {
	meta_buff = true,
	predicted = false,
	meta_stat_buffs = {
		[meta_stat_buffs.mission_reward_gear_instead_of_weapon_modifier] = 0.25,
	},
}
templates.gadget_permanent_damage_resistance = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.corruption_taken_grimoire_multiplier] = 0.8,
	},
}
templates.gadget_revive_speed_increase = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.revive_speed_modifier] = 0.2,
	},
}
templates.gadget_cooldown_reduction = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ability_cooldown_modifier] = -0.05,
	},
}
templates.gadget_sprint_cost_reduction = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.sprinting_cost_multiplier] = 0.8,
	},
}
templates.gadget_block_cost_reduction = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.block_cost_multiplier] = 0.8,
	},
}
templates.gadget_stamina_regeneration = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.stamina_regeneration_modifier] = 0.2,
	},
}
templates.gadget_damage_reduction_vs_flamers = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_taken_by_cultist_flamer_multiplier] = 0.8,
		[stat_buffs.damage_taken_by_renegade_flamer_multiplier] = 0.8,
		[stat_buffs.damage_taken_by_renegade_flamer_mutator_multiplier] = 0.8,
	},
}
templates.gadget_damage_reduction_vs_snipers = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_taken_by_renegade_sniper_multiplier] = 0.8,
	},
}
templates.gadget_damage_reduction_vs_grenadiers = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_taken_by_renegade_grenadier_multiplier] = 0.8,
		[stat_buffs.damage_taken_by_cultist_grenadier_multiplier] = 0.8,
	},
}
templates.gadget_damage_reduction_vs_hounds = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_taken_by_chaos_hound_multiplier] = 0.8,
		[stat_buffs.damage_taken_by_chaos_hound_mutator_multiplier] = 0.8,
	},
}
templates.gadget_damage_reduction_vs_mutants = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_taken_by_cultist_mutant_multiplier] = 0.8,
		[stat_buffs.damage_taken_by_cultist_mutant_mutator_multiplier] = 0.8,
	},
}
templates.gadget_damage_reduction_vs_gunners = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_taken_by_cultist_gunner_multiplier] = 0.8,
		[stat_buffs.damage_taken_by_renegade_gunner_multiplier] = 0.8,
		[stat_buffs.damage_taken_by_chaos_ogryn_gunner_multiplier] = 0.8,
	},
}
templates.gadget_damage_reduction_vs_bombers = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_taken_by_chaos_poxwalker_bomber_multiplier] = 0.8,
	},
}

return templates
