-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_gauntlet_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_on_continuous_fire = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier,
				},
			},
		},
		ammo = {
			format_type = "string",
			value = "10%",
		},
		stacks = {
			format_type = "string",
			value = "5",
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.07,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.08,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_elite_kills = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_elite_kills",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_elite_kills = {
			{
				toughness_fixed_percentage = 0.2,
			},
			{
				toughness_fixed_percentage = 0.25,
			},
			{
				toughness_fixed_percentage = 0.3,
			},
			{
				toughness_fixed_percentage = 0.35,
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_crit_kills = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_crit_kills",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_crit_kills = {
			{
				toughness_fixed_percentage = 0.24,
			},
			{
				toughness_fixed_percentage = 0.28,
			},
			{
				toughness_fixed_percentage = 0.32,
			},
			{
				toughness_fixed_percentage = 0.36,
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_targets_receive_rending_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_targets_receive_rending_debuff",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc",
				},
			},
		},
		rending = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "rending_debuff",
				find_value_type = "buff_template",
				path = {
					"stat_buffs",
					stat_buffs.rending_multiplier,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "rending_debuff",
				find_value_type = "buff_template",
				path = {
					"duration",
				},
			},
		},
		max_stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "rending_debuff",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_targets_receive_rending_debuff = {
			{
				target_buff_data = {
					num_stacks_on_proc = 1,
				},
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 2,
				},
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 3,
				},
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 4,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power",
				find_value_type = "trait_override",
				path = {
					"duration_per_stack",
				},
			},
		},
		stacks = {
			format_type = "string",
			value = "5",
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power = {
			{
				duration_per_stack = 0.4,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05,
				},
			},
			{
				duration_per_stack = 0.4,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.06,
				},
			},
			{
				duration_per_stack = 0.4,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.07,
				},
			},
			{
				duration_per_stack = 0.4,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.08,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_crit_chance_bonus_on_melee_kills = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_crit_chance_bonus_on_melee_kills",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.critical_strike_chance,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_crit_chance_bonus_on_melee_kills",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_crit_chance_bonus_on_melee_kills = {
			{
				active_duration = 3,
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
			{
				active_duration = 3,
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.15,
				},
			},
			{
				active_duration = 3,
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.2,
				},
			},
			{
				active_duration = 3,
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.25,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_chained_melee_hits_increases_power = {
	format_values = {
		power = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_chained_melee_hits_increases_power_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier,
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_chained_melee_hits_increases_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_chained_melee_hits_increases_power_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_chained_melee_hits_increases_power_parent = {
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
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_melee_power_after_ranged_explosion = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_melee_power_after_ranged_explosion",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.melee_power_level_modifier,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_melee_power_after_ranged_explosion",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
		num_hits = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_melee_power_after_ranged_explosion",
				find_value_type = "buff_template",
				path = {
					"buff_data",
					"required_num_hits",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_melee_power_after_ranged_explosion = {
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.15,
				},
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.2,
				},
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.25,
				},
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.3,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_after_weapon_special_multiple = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_after_weapon_special_multiple",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.power_level_modifier,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_after_weapon_special_multiple",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
		num_hits = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_gauntlet_p1_melee_power_after_ranged_explosion",
				find_value_type = "buff_template",
				path = {
					"buff_data",
					"required_num_hits",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_after_weapon_special_multiple = {
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.06,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.09,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.12,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.15,
				},
			},
		},
	},
}

return templates
