-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_phosphor_pistol_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}
local proc_events = BuffSettings.proc_events

table.make_unique(templates)

templates.weapon_trait_bespoke_phosphor_pistol_p1_crit_chance_based_on_ammo_left = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_phosphor_pistol_p1_crit_chance_based_on_ammo_left",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.critical_strike_chance,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_phosphor_pistol_p1_crit_chance_based_on_ammo_left = {
			{
				conditional_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.045,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.05,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.055,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.06,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_phosphor_pistol_p1_toughness_on_elite_kills = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_phosphor_pistol_p1_toughness_on_elite_kills",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_phosphor_pistol_p1_toughness_on_elite_kills = {
			{
				toughness_fixed_percentage = 0.175,
			},
			{
				toughness_fixed_percentage = 0.2,
			},
			{
				toughness_fixed_percentage = 0.225,
			},
			{
				toughness_fixed_percentage = 0.25,
			},
		},
	},
}
templates.weapon_trait_bespoke_phosphor_pistol_p1_rending_on_crit = {
	format_values = {
		rend = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_phosphor_pistol_p1_rending_on_crit",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_rending_multiplier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_phosphor_pistol_p1_rending_on_crit = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_rending_multiplier] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_rending_multiplier] = 0.075,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_rending_multiplier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_rending_multiplier] = 0.15,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_phosphor_pistol_p1_burninating_on_crit = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_phosphor_pistol_p1_burninating_on_crit",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc",
				},
			},
		},
		max_stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_phosphor_pistol_p1_burninating_on_crit",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_phosphor_pistol_p1_burninating_on_crit = {
			{
				target_buff_data = {
					max_stacks = 4,
					num_stacks_on_proc = 2,
				},
			},
			{
				target_buff_data = {
					max_stacks = 9,
					num_stacks_on_proc = 3,
				},
			},
			{
				target_buff_data = {
					max_stacks = 12,
					num_stacks_on_proc = 4,
				},
			},
			{
				target_buff_data = {
					max_stacks = 15,
					num_stacks_on_proc = 5,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_phosphor_pistol_p1_cleave_on_crit = {
	format_values = {
		stagger = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_phosphor_pistol_p1_cleave_on_crit",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_impact_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_phosphor_pistol_p1_cleave_on_crit = {
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_impact_modifier] = 0.1,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_impact_modifier] = 0.15,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_impact_modifier] = 0.2,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_impact_modifier] = 0.25,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_phosphor_pistol_p1_power_bonus_on_first_shot = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_phosphor_pistol_p1_power_bonus_on_first_shot",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.ranged_power_level_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_phosphor_pistol_p1_power_bonus_on_first_shot = {
			{
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.14,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.16,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.18,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.2,
				},
			},
		},
	},
}

local windup_increases_power_trait_num_steps = 5

templates.weapon_trait_bespoke_phosphor_pistol_p1_increases_power_while_aiming = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_phosphor_pistol_p1_increases_power_while_aiming",
				find_value_type = "trait_override",
				path = {
					"lerped_stat_buffs",
					stat_buffs.power_level_modifier,
					"max",
				},
			},
			value_manipulation = function (value)
				local value_per_stack = value / windup_increases_power_trait_num_steps

				return math.round(value_per_stack * 100)
			end,
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_phosphor_pistol_p1_increases_power_while_aiming",
				find_value_type = "trait_override",
				path = {
					"duration_per_step",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_phosphor_pistol_p1_increases_power_while_aiming",
				find_value_type = "trait_override",
				path = {
					"num_steps_for_max_stat",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_phosphor_pistol_p1_increases_power_while_aiming = {
			{
				duration_per_step = 0.4,
				num_steps_for_max_stat = windup_increases_power_trait_num_steps,
				lerped_stat_buffs = {
					[stat_buffs.power_level_modifier] = {
						max = 0.05,
						min = 0,
					},
				},
			},
			{
				duration_per_step = 0.4,
				num_steps_for_max_stat = windup_increases_power_trait_num_steps,
				lerped_stat_buffs = {
					[stat_buffs.power_level_modifier] = {
						max = 0.1,
						min = 0,
					},
				},
			},
			{
				duration_per_step = 0.4,
				num_steps_for_max_stat = windup_increases_power_trait_num_steps,
				lerped_stat_buffs = {
					[stat_buffs.power_level_modifier] = {
						max = 0.15,
						min = 0,
					},
				},
			},
			{
				duration_per_step = 0.4,
				num_steps_for_max_stat = windup_increases_power_trait_num_steps,
				lerped_stat_buffs = {
					[stat_buffs.power_level_modifier] = {
						max = 0.2,
						min = 0,
					},
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_phosphor_pistol_p1_crit_chance_based_on_aim_time = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_phosphor_pistol_p1_crit_chance_based_on_aim_time",
				find_value_type = "trait_override",
				path = {
					"duration_per_stack",
				},
			},
		},
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_phosphor_pistol_p1_crit_chance_based_on_aim_time",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance,
				},
			},
		},
		stacks = {
			format_type = "string",
			value = "10",
		},
	},
	buffs = {
		weapon_trait_bespoke_phosphor_pistol_p1_crit_chance_based_on_aim_time = {
			{
				duration_per_stack = 0.45,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
			{
				duration_per_stack = 0.4,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
			{
				duration_per_stack = 0.35,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
			{
				duration_per_stack = 0.325,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_phosphor_pistol_p1_recoil_reduction_and_suppression_increase_on_close_kills = {
	format_values = {
		recoil_reduction = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_phosphor_pistol_p1_recoil_reduction_and_suppression_increase_on_close_kills",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.recoil_modifier,
				},
			},
		},
		suppression = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_phosphor_pistol_p1_recoil_reduction_and_suppression_increase_on_close_kills",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.suppression_dealt,
				},
			},
		},
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_phosphor_pistol_p1_recoil_reduction_and_suppression_increase_on_close_kills",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.damage_vs_suppressed,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_phosphor_pistol_p1_recoil_reduction_and_suppression_increase_on_close_kills = {
			{
				proc_stat_buffs = {
					[stat_buffs.recoil_modifier] = -0.28,
					[stat_buffs.suppression_dealt] = 0.28,
					[stat_buffs.damage_vs_suppressed] = 0.14,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.recoil_modifier] = -0.32,
					[stat_buffs.suppression_dealt] = 0.32,
					[stat_buffs.damage_vs_suppressed] = 0.16,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.recoil_modifier] = -0.36,
					[stat_buffs.suppression_dealt] = 0.36,
					[stat_buffs.damage_vs_suppressed] = 0.18,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.recoil_modifier] = -0.4,
					[stat_buffs.suppression_dealt] = 0.4,
					[stat_buffs.damage_vs_suppressed] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_phosphor_pistol_p1_chance_to_explode_elites_on_kill = {
	format_values = {
		proc_chance = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_phosphor_pistol_p1_chance_to_explode_elites_on_kill",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_kill,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_phosphor_pistol_p1_chance_to_explode_elites_on_kill = {
			{
				proc_events = {
					[proc_events.on_kill] = 0.14,
				},
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.16,
				},
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.18,
				},
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.2,
				},
			},
		},
	},
}

return templates
