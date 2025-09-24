-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_autogun_p2.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_autogun_p2_increase_power_on_close_kill = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p2_increase_power_on_close_kill_parent",
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
				buff_template_name = "weapon_trait_bespoke_autogun_p2_increase_power_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p2_increase_power_on_close_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p2_increase_power_on_close_kill_parent = {
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.055,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.06,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.065,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p2_increase_close_damage_on_close_kill = {
	format_values = {
		close_damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p2_increase_close_damage_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_near,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p2_increase_close_damage_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p2_increase_close_damage_on_close_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p2_increase_close_damage_on_close_kill_parent = {
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.damage_near] = 0.07,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.damage_near] = 0.08,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.damage_near] = 0.09,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.damage_near] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p2_count_as_dodge_vs_ranged_on_close_kill = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p2_count_as_dodge_vs_ranged_on_close_kill",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p2_count_as_dodge_vs_ranged_on_close_kill = {
			{
				active_duration = 0.7,
			},
			{
				active_duration = 0.8,
			},
			{
				active_duration = 0.9,
			},
			{
				active_duration = 1,
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p2_suppression_on_close_kill = {
	format_values = {
		range = {
			format_type = "string",
			find_value = {
				find_value_type = "rarity_value",
				trait_value = {
					"5m",
					"6m",
					"7m",
					"8m",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p2_suppression_on_close_kill = {
			{
				suppression_settings = {
					distance = 12,
					instant_aggro = true,
					suppression_falloff = false,
					suppression_value = 15,
				},
			},
			{
				suppression_settings = {
					distance = 12,
					instant_aggro = true,
					suppression_falloff = false,
					suppression_value = 20,
				},
			},
			{
				suppression_settings = {
					distance = 12,
					instant_aggro = true,
					suppression_falloff = false,
					suppression_value = 25,
				},
			},
			{
				suppression_settings = {
					distance = 12,
					instant_aggro = true,
					suppression_falloff = false,
					suppression_value = 30,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p2_reload_speed_on_slide = {
	format_values = {
		reload_speed = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p2_reload_speed_on_slide_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.reload_speed,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p2_reload_speed_on_slide_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p2_reload_speed_on_slide_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p2_reload_speed_on_slide_parent = {
			{
				child_duration = 2.5,
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.07,
				},
			},
			{
				child_duration = 2.5,
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.08,
				},
			},
			{
				child_duration = 2.5,
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.09,
				},
			},
			{
				child_duration = 2.5,
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p2_increased_sprint_speed = {
	format_values = {
		stamina = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p2_increased_sprint_speed",
				find_value_type = "trait_override",
				path = {
					"conditional_threshold",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p2_increased_sprint_speed = {
			{
				conditional_threshold = 0.8,
			},
			{
				conditional_threshold = 0.7,
			},
			{
				conditional_threshold = 0.6,
			},
			{
				conditional_threshold = 0.5,
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p2_increased_suppression_on_continuous_fire = {
	format_values = {
		suppression = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p2_increased_suppression_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.suppression_dealt,
				},
			},
		},
		damage_vs_suppressed = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p2_increased_suppression_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_suppressed,
				},
			},
		},
		ammo = {
			format_type = "string",
			value = "2.5%",
		},
		stacks = {
			format_type = "string",
			value = "5",
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p2_increased_suppression_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.suppression_dealt] = 0.125,
					[stat_buffs.damage_vs_suppressed] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.suppression_dealt] = 0.15,
					[stat_buffs.damage_vs_suppressed] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.suppression_dealt] = 0.175,
					[stat_buffs.damage_vs_suppressed] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.suppression_dealt] = 0.2,
					[stat_buffs.damage_vs_suppressed] = 0.07,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p2_movement_speed_on_continous_fire = {
	format_values = {
		movement_speed = {
			format_type = "percentage",
			num_decimals = 0,
			prefix = "-",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p2_movement_speed_on_continous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.alternate_fire_movement_speed_reduction_modifier,
				},
			},
			value_manipulation = function (value)
				return 100 - math.round(value * 100)
			end,
		},
		ammo = {
			format_type = "string",
			value = "5%",
		},
		stacks = {
			format_type = "string",
			value = "5",
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p2_movement_speed_on_continous_fire = {
			{
				stat_buffs = {
					[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.9,
					[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.85,
					[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.8,
					[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.8,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.75,
					[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.75,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p2_toughness_on_continuous_fire = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p2_toughness_on_continuous_fire",
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
		weapon_trait_bespoke_autogun_p2_toughness_on_continuous_fire = {
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

return templates
