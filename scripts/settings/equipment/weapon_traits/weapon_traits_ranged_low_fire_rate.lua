-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_ranged_low_fire_rate.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local weapon_traits_ranged_low_fire_rate = {}

table.make_unique(weapon_traits_ranged_low_fire_rate)

local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events

weapon_traits_ranged_low_fire_rate.weapon_trait_ranged_low_fire_rate_wield_on_flanking_shot_grant_power_level = {
	format_values = {
		chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_flanking_shot_grant_power_level_buff",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_hit,
				},
			},
		},
		power = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_flanking_shot_grant_power_level_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier,
				},
			},
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_flanking_shot_grant_power_level_buff",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_flanking_shot_grant_power_level_buff",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_on_flanking_shot_grant_power_level_buff = {
			{
				active_duration = 5,
				cooldown_duration = 3.75,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 3.5,
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.2,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 3.25,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.3,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 3,
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_low_fire_rate.weapon_trait_ranged_low_fire_rate_wield_on_hit_restore_toughness = {
	format_values = {
		chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_restore_toughness_buff",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_hit,
				},
			},
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_restore_toughness_buff",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_on_hit_restore_toughness_buff = {
			{
				cooldown_duration = 5.25,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
			},
			{
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
			},
			{
				cooldown_duration = 4.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
			},
			{
				cooldown_duration = 4.5,
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
			},
		},
	},
}
weapon_traits_ranged_low_fire_rate.weapon_trait_ranged_low_fire_rate_wield_on_hit_damage_bonus = {
	format_values = {
		chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_damage_bonus_buff",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_hit,
				},
			},
		},
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_damage_bonus_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage,
				},
			},
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_damage_bonus_buff",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_damage_bonus_buff",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_on_hit_damage_bonus_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.1,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.2,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.3,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_low_fire_rate.weapon_trait_ranged_low_fire_rate_wield_on_hit_power_bonus = {
	format_values = {
		chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_power_bonus_buff",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_hit,
				},
			},
		},
		power = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_power_bonus_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier,
				},
			},
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_power_bonus_buff",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_power_bonus_buff",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_on_hit_power_bonus_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.15,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 1,
				},
			},
		},
	},
}
weapon_traits_ranged_low_fire_rate.weapon_trait_ranged_low_fire_rate_wield_on_hit_impact_bonus = {
	format_values = {
		chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_impact_bonus_buff",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_hit,
				},
			},
		},
		impact = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_impact_bonus_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.ranged_impact_modifier,
				},
			},
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_impact_bonus_buff",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_impact_bonus_buff",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_on_hit_impact_bonus_buff = {
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.ranged_impact_modifier] = 0.1,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.ranged_impact_modifier] = 0.2,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.ranged_impact_modifier] = 0.3,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.ranged_impact_modifier] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_low_fire_rate.weapon_trait_ranged_low_fire_rate_wield_on_hit_increased_unarmored_damage = {
	format_values = {
		chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_unarmored_damage_buff",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_hit,
				},
			},
		},
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_unarmored_damage_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.unarmored_damage,
				},
			},
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_unarmored_damage_buff",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_unarmored_damage_buff",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_on_hit_increased_unarmored_damage_buff = {
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.1,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.2,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.3,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_low_fire_rate.weapon_trait_ranged_low_fire_rate_wield_on_hit_increased_armored_damage = {
	format_values = {
		chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_armored_damage_buff",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_hit,
				},
			},
		},
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_armored_damage_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.armored_damage,
				},
			},
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_armored_damage_buff",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_armored_damage_buff",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_on_hit_increased_armored_damage_buff = {
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.1,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.2,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.3,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_low_fire_rate.weapon_trait_ranged_low_fire_rate_wield_on_hit_increased_resistant_damage = {
	format_values = {
		chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_resistant_damage_buff",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_hit,
				},
			},
		},
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_resistant_damage_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.resistant_damage,
				},
			},
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_resistant_damage_buff",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_resistant_damage_buff",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_on_hit_increased_resistant_damage_buff = {
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.1,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.2,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.3,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_low_fire_rate.weapon_trait_ranged_low_fire_rate_wield_on_hit_increased_berserker_damage = {
	format_values = {
		chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_berserker_damage_buff",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_hit,
				},
			},
		},
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_berserker_damage_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.berserker_damage,
				},
			},
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_berserker_damage_buff",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_berserker_damage_buff",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_on_hit_increased_berserker_damage_buff = {
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.1,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.2,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.3,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_low_fire_rate.weapon_trait_ranged_low_fire_rate_wield_on_hit_increased_super_armor_damage = {
	format_values = {
		chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_super_armor_damage_buff",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_hit,
				},
			},
		},
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_super_armor_damage_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.super_armor_damage,
				},
			},
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_super_armor_damage_buff",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_super_armor_damage_buff",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_on_hit_increased_super_armor_damage_buff = {
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.1,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.2,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.3,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_low_fire_rate.weapon_trait_ranged_low_fire_rate_wield_on_hit_increased_disgustingly_resilient_damage = {
	format_values = {
		chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_disgustingly_resilient_damage_buff",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_hit,
				},
			},
		},
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_disgustingly_resilient_damage_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.disgustingly_resilient_damage,
				},
			},
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_disgustingly_resilient_damage_buff",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_increased_disgustingly_resilient_damage_buff",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_on_hit_increased_disgustingly_resilient_damage_buff = {
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.1,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.2,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.3,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_low_fire_rate.weapon_trait_ranged_low_fire_rate_wield_on_hit_bleed = {
	format_values = {
		chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_bleed_buff",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_hit,
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_on_hit_bleed_buff = {
			{
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
			},
			{
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
			},
			{
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
			},
			{
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
			},
		},
	},
}
weapon_traits_ranged_low_fire_rate.weapon_trait_ranged_low_fire_rate_wield_on_hit_staggered_power_bonus = {
	format_values = {
		chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_staggered_power_bonus_buff",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_hit,
				},
			},
		},
		power = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_staggered_power_bonus_buff",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier,
				},
			},
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_staggered_power_bonus_buff",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_ranged_common_wield_on_hit_staggered_power_bonus_buff",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_ranged_common_wield_on_hit_staggered_power_bonus_buff = {
			{
				active_duration = 5,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.2,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.3,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.4,
				},
			},
		},
	},
}

return weapon_traits_ranged_low_fire_rate
