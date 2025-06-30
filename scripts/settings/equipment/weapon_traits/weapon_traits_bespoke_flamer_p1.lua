-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_flamer_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events

templates.weapon_trait_bespoke_flamer_p1_toughness_on_continuous_fire = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_flamer_p1_toughness_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
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
		weapon_trait_bespoke_flamer_p1_toughness_on_continuous_fire = {
			{
				toughness_fixed_percentage = 0.01,
			},
			{
				toughness_fixed_percentage = 0.02,
			},
			{
				toughness_fixed_percentage = 0.03,
			},
			{
				toughness_fixed_percentage = 0.04,
			},
		},
	},
}
templates.weapon_trait_bespoke_flamer_p1_power_bonus_on_continuous_fire = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_flamer_p1_power_bonus_on_continuous_fire",
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
		weapon_trait_bespoke_flamer_p1_power_bonus_on_continuous_fire = {
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
templates.weapon_trait_bespoke_flamer_p1_faster_reload_on_empty_clip = {
	format_values = {
		reload_speed = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_flamer_p1_faster_reload_on_empty_clip",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.reload_speed,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_flamer_p1_faster_reload_on_empty_clip = {
			{
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.24,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.28,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.32,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.36,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_flamer_p1_power_scales_with_clip_percentage = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_flamer_p1_power_scales_with_clip_percentage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier,
				},
			},
		},
		stacks = {
			format_type = "string",
			value = "5",
		},
	},
	buffs = {
		weapon_trait_bespoke_flamer_p1_power_scales_with_clip_percentage = {
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
templates.weapon_trait_bespoke_flamer_p1_negate_stagger_reduction_with_primary_on_burning = {
	format_values = {
		stagger_reduction = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_flamer_p1_negate_stagger_reduction_with_primary_on_burning",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.stagger_burning_reduction_modifier,
				},
			},
			value_manipulation = function (value)
				return 100 * (1 - value)
			end,
		},
		impact_modifier = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_flamer_p1_negate_stagger_reduction_with_primary_on_burning",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_impact_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_flamer_p1_negate_stagger_reduction_with_primary_on_burning = {
			{
				conditional_stat_buffs = {
					[stat_buffs.stagger_burning_reduction_modifier] = 0.6,
					[stat_buffs.ranged_impact_modifier] = 0.3,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.stagger_burning_reduction_modifier] = 0.5,
					[stat_buffs.ranged_impact_modifier] = 0.35,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.stagger_burning_reduction_modifier] = 0.4,
					[stat_buffs.ranged_impact_modifier] = 0.4,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.stagger_burning_reduction_modifier] = 0.3,
					[stat_buffs.ranged_impact_modifier] = 0.45,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_flamer_p1_chance_to_explode_elites_on_kill = {
	format_values = {
		proc_chance = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_flamer_p1_chance_to_explode_elites_on_kill",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_kill,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_flamer_p1_chance_to_explode_elites_on_kill = {
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
templates.weapon_trait_bespoke_flamer_p1_ammo_from_reserve_on_crit = {
	format_values = {
		ammo_amount = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_flamer_p1_ammo_from_reserve_on_crit",
				find_value_type = "trait_override",
				path = {
					"num_ammmo_to_move",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_flamer_p1_ammo_from_reserve_on_crit = {
			{
				num_ammmo_to_move = 2,
			},
			{
				num_ammmo_to_move = 3,
			},
			{
				num_ammmo_to_move = 4,
			},
			{
				num_ammmo_to_move = 5,
			},
		},
	},
}
templates.weapon_trait_bespoke_flamer_p1_burned_targets_receive_rending_debuff = {
	format_values = {
		num_stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_flamer_p1_burned_targets_receive_rending_debuff",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc",
				},
			},
		},
		rending_percentage = {
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
		duration = {
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
		weapon_trait_bespoke_flamer_p1_burned_targets_receive_rending_debuff = {
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

return templates
