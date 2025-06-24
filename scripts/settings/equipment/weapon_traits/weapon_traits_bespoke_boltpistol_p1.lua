-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_boltpistol_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_boltpistol_p1_crit_chance_bonus_on_melee_kills = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_boltpistol_p1_crit_chance_bonus_on_melee_kills",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.ranged_critical_strike_chance,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_boltpistol_p1_crit_chance_bonus_on_melee_kills",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_boltpistol_p1_crit_chance_bonus_on_melee_kills = {
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.14,
				},
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.16,
				},
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.18,
				},
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_boltpistol_p1_hipfire_while_sprinting = {
	format_values = {
		weapon_spread = {
			format_type = "percentage",
			prefix = "",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_boltpistol_p1_hipfire_while_sprinting",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.spread_modifier,
				},
			},
		},
		damage_near = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_boltpistol_p1_hipfire_while_sprinting",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.damage_near,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_boltpistol_p1_hipfire_while_sprinting = {
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.3,
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.3,
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.09,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.3,
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.12,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.3,
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.15,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_boltpistol_p1_crit_weakspot_finesse = {
	format_values = {
		crit_weakspot_damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_boltpistol_p1_crit_weakspot_finesse",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_weakspot_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_boltpistol_p1_crit_weakspot_finesse = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_weakspot_damage] = 0.7,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_weakspot_damage] = 0.8,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_weakspot_damage] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_weakspot_damage] = 1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_boltpistol_p1_crit_chance_based_on_aim_time = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_boltpistol_p1_crit_chance_based_on_aim_time",
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
				buff_template_name = "weapon_trait_bespoke_boltpistol_p1_crit_chance_based_on_aim_time",
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
		weapon_trait_bespoke_boltpistol_p1_crit_chance_based_on_aim_time = {
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
				duration_per_stack = 0.3,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_boltpistol_p1_suppression_on_close_kill = {
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
		weapon_trait_bespoke_boltpistol_p1_suppression_on_close_kill = {
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
templates.weapon_trait_bespoke_boltpistol_p1_toughness_on_elite_kills = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_boltpistol_p1_toughness_on_elite_kills",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_boltpistol_p1_toughness_on_elite_kills = {
			{
				toughness_fixed_percentage = 0.18,
			},
			{
				toughness_fixed_percentage = 0.22,
			},
			{
				toughness_fixed_percentage = 0.26,
			},
			{
				toughness_fixed_percentage = 0.3,
			},
		},
	},
}
templates.weapon_trait_bespoke_boltpistol_p1_rending_on_crit = {
	format_values = {
		rend = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_boltpistol_p1_rending_on_crit",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_rending_multiplier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_boltpistol_p1_rending_on_crit = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_rending_multiplier] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_rending_multiplier] = 0.4,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_rending_multiplier] = 0.5,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_rending_multiplier] = 0.6,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_boltpistol_p1_bleed_on_ranged = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_boltpistol_p1_bleed_on_ranged",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_boltpistol_p1_bleed_on_ranged = {
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
templates.weapon_trait_bespoke_boltpistol_p1_stagger_bonus_damage = {
	format_values = {
		vs_stagger = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_boltpistol_p1_stagger_bonus_damage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_staggered,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_boltpistol_p1_stagger_bonus_damage = {
			{
				stat_buffs = {
					[stat_buffs.damage_vs_staggered] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_staggered] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_staggered] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_staggered] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_boltpistol_p1_close_explosion = {
	format_values = {
		radius = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_boltpistol_p1_close_explosion",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.explosion_radius_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_boltpistol_p1_close_explosion = {
			{
				stat_buffs = {
					[stat_buffs.explosion_radius_modifier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.explosion_radius_modifier] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.explosion_radius_modifier] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.explosion_radius_modifier] = 0.25,
				},
			},
		},
	},
}

return templates
