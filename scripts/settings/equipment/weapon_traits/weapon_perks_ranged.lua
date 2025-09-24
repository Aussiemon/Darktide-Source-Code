-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_perks_ranged.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local weapon_traits_ranged_common = {}

table.make_unique(weapon_traits_ranged_common)

local stat_buffs = BuffSettings.stat_buffs

weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increased_unarmored_damage = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_increased_unarmored_damage_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.unarmored_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_increased_unarmored_damage_buff = {
			{
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.25,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increased_armored_damage = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_increased_armored_damage_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.armored_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_increased_armored_damage_buff = {
			{
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.25,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increased_resistant_damage = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_increased_resistant_damage_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.resistant_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_increased_resistant_damage_buff = {
			{
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.25,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increased_berserker_damage = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_increased_berserker_damage_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.berserker_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_increased_berserker_damage_buff = {
			{
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.25,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increased_super_armor_damage = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_increased_super_armor_damage_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.super_armor_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_increased_super_armor_damage_buff = {
			{
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.25,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increased_disgustingly_resilient_damage = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_increased_disgustingly_resilient_damage_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.disgustingly_resilient_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_increased_disgustingly_resilient_damage_buff = {
			{
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.25,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_increase_crit_chance = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_increase_crit_chance",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_increase_crit_chance = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.02,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.05,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_increase_crit_damage = {
	format_values = {
		crit_damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_increase_crit_damage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_increase_crit_damage = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_damage] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_damage] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_damage] = 0.08,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_damage] = 0.1,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_increase_stamina = {
	format_values = {
		stamina = {
			format_type = "number",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_increase_stamina",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.stamina_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_increase_stamina = {
			{
				stat_buffs = {
					[stat_buffs.stamina_modifier] = 1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stamina_modifier] = 1.25,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stamina_modifier] = 1.5,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stamina_modifier] = 2,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_increase_weakspot_damage = {
	format_values = {
		weakspot_damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_increase_weakspot_damage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.weakspot_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_increase_weakspot_damage = {
			{
				stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.08,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.1,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_increase_damage = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_increase_damage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_increase_damage = {
			{
				stat_buffs = {
					[stat_buffs.damage] = 0.01,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage] = 0.02,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage] = 0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage] = 0.04,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_increase_finesse = {
	format_values = {
		finesse_modifier = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_increase_finesse",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.finesse_modifier_bonus,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_increase_finesse = {
			{
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.01,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.02,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.04,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_increase_power = {
	format_values = {
		power_mod = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_increase_power",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_increase_power = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.01,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.02,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.04,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_increase_damage_elites = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_increase_damage_elites",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_elites,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_increase_damage_elites = {
			{
				stat_buffs = {
					[stat_buffs.damage_vs_elites] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_elites] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_elites] = 0.08,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_elites] = 0.1,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_increase_damage_hordes = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_increase_damage_hordes",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_horde,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_increase_damage_hordes = {
			{
				stat_buffs = {
					[stat_buffs.damage_vs_horde] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_horde] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_horde] = 0.08,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_horde] = 0.1,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_increase_damage_specials = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_increase_damage_specials",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_specials,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_increase_damage_specials = {
			{
				stat_buffs = {
					[stat_buffs.damage_vs_specials] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_specials] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_specials] = 0.08,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_specials] = 0.1,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_increased_reload_speed = {
	format_values = {
		reload_speed = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_increased_reload_speed",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.reload_speed,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_increased_reload_speed = {
			{
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.07,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.085,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.1,
				},
			},
		},
	},
}

return weapon_traits_ranged_common
