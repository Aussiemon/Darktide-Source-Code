-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_thumper_p2.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_thumper_p2_toughness_on_elite_kills = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p2_toughness_on_elite_kills",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p2_toughness_on_elite_kills = {
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
templates.weapon_trait_bespoke_ogryn_thumper_p2_power_bonus_on_continuous_fire = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p2_power_bonus_on_continuous_fire",
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
		weapon_trait_bespoke_ogryn_thumper_p2_power_bonus_on_continuous_fire = {
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
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.09,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_explosion_radius_bonus_on_continuous_fire = {
	format_values = {
		radius = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p2_explosion_radius_bonus_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.explosion_radius_modifier,
				},
			},
		},
		stacks = {
			format_type = "string",
			value = "5",
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p2_explosion_radius_bonus_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.explosion_radius_modifier] = 0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.explosion_radius_modifier] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.explosion_radius_modifier] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.explosion_radius_modifier] = 0.06,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_weakspot_projectile_hit_increases_reload_speed = {
	format_values = {
		reload_speed = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p2_weakspot_projectile_hit_increases_reload_speed",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.reload_speed,
				},
			},
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p2_weakspot_projectile_hit_increases_reload_speed",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p2_weakspot_projectile_hit_increases_reload_speed = {
			{
				proc_stat_buffs = {
					[stat_buffs.reload_speed] = 0.15,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.reload_speed] = 0.2,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.reload_speed] = 0.25,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.reload_speed] = 0.3,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_pass_past_armor_on_weapon_special = {
	format_values = {
		stagger = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p2_pass_past_armor_on_weapon_special",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_impact_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p2_pass_past_armor_on_weapon_special = {
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.25,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_targets_receive_rending_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p2_targets_receive_rending_debuff",
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
		weapon_trait_bespoke_ogryn_thumper_p2_targets_receive_rending_debuff = {
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
templates.weapon_trait_bespoke_ogryn_thumper_p2_close_explosion_applies_bleed = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p2_close_explosion_applies_bleed",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p2_close_explosion_applies_bleed = {
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
templates.weapon_trait_bespoke_ogryn_thumper_p2_grenades_stick_to_monsters = {
	format_values = {
		dmg_vs_ogryn_monster = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p2_grenades_stick_to_monsters",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_ogryn_and_monsters,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p2_grenades_stick_to_monsters = {
			{
				stat_buffs = {
					[stat_buffs.damage_vs_ogryn_and_monsters] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_ogryn_and_monsters] = 0.09,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_ogryn_and_monsters] = 0.12,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_ogryn_and_monsters] = 0.15,
				},
			},
		},
	},
}

return templates
