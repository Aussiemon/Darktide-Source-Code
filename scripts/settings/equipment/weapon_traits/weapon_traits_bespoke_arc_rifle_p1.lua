-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_arc_rifle_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_close_damage = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_close_damage_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_near,
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_close_damage_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_close_damage_parent = {
			{
				stat_buffs = {
					[stat_buffs.damage_near] = 0.01,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_near] = 0.02,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_near] = 0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_near] = 0.04,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_arc_rifle_p1_power_bonus_on_continuous_fire = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_arc_rifle_p1_power_bonus_on_continuous_fire",
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
		weapon_trait_bespoke_arc_rifle_p1_power_bonus_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.01,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.015,
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
		},
	},
}
templates.weapon_trait_bespoke_arc_rifle_p1_stacking_crit_bonus_on_continuous_fire = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_arc_rifle_p1_stacking_crit_bonus_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance,
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
		weapon_trait_bespoke_arc_rifle_p1_stacking_crit_bonus_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.035,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.045,
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
templates.weapon_trait_bespoke_arc_rifle_p1_ammo_from_reserve_on_crit = {
	format_values = {
		bullet_amount = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_arc_rifle_p1_ammo_from_reserve_on_crit",
				find_value_type = "trait_override",
				path = {
					"num_ammmo_to_move",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_arc_rifle_p1_ammo_from_reserve_on_crit = {
			{
				num_ammmo_to_move = 1,
				reload_speed = 0.06,
			},
			{
				num_ammmo_to_move = 1,
				reload_speed = 0.09,
			},
			{
				num_ammmo_to_move = 1,
				reload_speed = 0.12,
			},
			{
				num_ammmo_to_move = 1,
				reload_speed = 0.15,
			},
		},
	},
}
templates.weapon_trait_bespoke_arc_rifle_p1_stagger_count_bonus_damage = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_arc_rifle_p1_stagger_count_bonus_damage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.stagger_count_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_arc_rifle_p1_stagger_count_bonus_damage = {
			{
				stat_buffs = {
					[stat_buffs.stagger_count_damage] = 0.14,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stagger_count_damage] = 0.16,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stagger_count_damage] = 0.18,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stagger_count_damage] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_ranged_power = {
	format_values = {
		power = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_ranged_power_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.ranged_power_level_modifier,
				},
			},
		},
		hit = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_ranged_power_parent",
				find_value_type = "trait_override",
				path = {
					"number_of_hits_per_stack",
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_ranged_power_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_ranged_power_parent",
				find_value_type = "trait_override",
				path = {
					"child_max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_arc_rifle_p1_consecutive_hits_increases_ranged_power_parent = {
			{
				child_duration = 2,
				child_max_stacks = 5,
				number_of_hits_per_stack = 4,
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.015,
				},
			},
			{
				child_duration = 2,
				child_max_stacks = 5,
				number_of_hits_per_stack = 4,
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.025,
				},
			},
			{
				child_duration = 2,
				child_max_stacks = 5,
				number_of_hits_per_stack = 4,
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.03,
				},
			},
			{
				child_duration = 2,
				child_max_stacks = 5,
				number_of_hits_per_stack = 4,
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.04,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_arc_rifle_p1_movement_speed_on_continous_fire = {
	format_values = {
		movement_speed = {
			format_type = "percentage",
			num_decimals = 0,
			prefix = "-",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_arc_rifle_p1_movement_speed_on_continous_fire",
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
		weapon_trait_bespoke_arc_rifle_p1_movement_speed_on_continous_fire = {
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
templates.weapon_trait_bespoke_arc_rifle_p1_enhanced_arc_jumps_angle = {
	format_values = {
		angle = {
			format_type = "number",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_arc_rifle_p1_enhanced_arc_jumps_angle",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					"chain_lightning_arc_rifle_max_angle",
				},
			},
			value_manipulation = function (value)
				return math.floor(math.radians_to_degrees(value))
			end,
		},
		jumps = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_arc_rifle_p1_enhanced_arc_jumps_angle",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					"chain_lightning_arc_rifle_max_jumps",
				},
			},
		},
		radius = {
			format_type = "number",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_arc_rifle_p1_enhanced_arc_jumps_angle",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					"chain_lightning_arc_rifle_max_radius",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_arc_rifle_p1_enhanced_arc_jumps_angle = {
			{
				conditional_stat_buffs = {
					[stat_buffs.chain_lightning_arc_rifle_max_angle] = math.degrees_to_radians(3),
					[stat_buffs.chain_lightning_arc_rifle_max_jumps] = 1,
					[stat_buffs.chain_lightning_arc_rifle_max_radius] = 0.3,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.chain_lightning_arc_rifle_max_angle] = math.degrees_to_radians(5),
					[stat_buffs.chain_lightning_arc_rifle_max_jumps] = 1,
					[stat_buffs.chain_lightning_arc_rifle_max_radius] = 0.5,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.chain_lightning_arc_rifle_max_angle] = math.degrees_to_radians(7.5),
					[stat_buffs.chain_lightning_arc_rifle_max_jumps] = 1,
					[stat_buffs.chain_lightning_arc_rifle_max_radius] = 0.75,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.chain_lightning_arc_rifle_max_angle] = math.degrees_to_radians(10),
					[stat_buffs.chain_lightning_arc_rifle_max_jumps] = 1,
					[stat_buffs.chain_lightning_arc_rifle_max_radius] = 1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_arc_rifle_p1_toughness_on_continuous_fire = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_arc_rifle_p1_toughness_on_continuous_fire",
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
		weapon_trait_bespoke_arc_rifle_p1_toughness_on_continuous_fire = {
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
