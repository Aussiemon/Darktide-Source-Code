-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_thumper_p2.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_thumper_p2_toughness_on_elite_kills = {
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
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_power_bonus_on_continuous_fire = {
	weapon_trait_bespoke_ogryn_thumper_p2_power_bonus_on_continuous_fire = {
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
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_explosion_radius_bonus_on_continuous_fire = {
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
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_weakspot_projectile_hit_increases_reload_speed = {
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
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_pass_trough_armor_on_weapon_special = {
	weapon_trait_bespoke_ogryn_thumper_p2_pass_trough_armor_on_weapon_special = {
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
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_targets_receive_rending_debuff = {
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
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_close_explosion_applies_bleed = {
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
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_grenades_stick_to_monsters = {
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
}

return templates
