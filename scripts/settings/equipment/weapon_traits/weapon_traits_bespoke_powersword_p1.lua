-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powersword_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_powersword_p1_chained_hits_increases_melee_cleave = {
	weapon_trait_bespoke_powersword_p1_chained_hits_increases_melee_cleave_parent = {
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.35,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.4,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.45,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.5,
			},
		},
	},
}
templates.weapon_trait_bespoke_powersword_p1_increased_melee_damage_on_multiple_hits = {
	weapon_trait_bespoke_powersword_p1_increased_melee_damage_on_multiple_hits = {
		{
			active_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.24,
			},
		},
		{
			active_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.28,
			},
		},
		{
			active_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.32,
			},
		},
		{
			active_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.36,
			},
		},
	},
}
templates.weapon_trait_bespoke_powersword_p1_infinite_melee_cleave_on_weakspot_kill = {
	weapon_trait_bespoke_powersword_p1_infinite_melee_cleave_on_weakspot_kill = {
		{
			stat_buffs = {
				[stat_buffs.melee_weakspot_damage] = 0.075,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_weakspot_damage] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_weakspot_damage] = 0.125,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_weakspot_damage] = 0.15,
			},
		},
	},
}
templates.weapon_trait_bespoke_powersword_p1_increase_power_on_kill = {
	weapon_trait_bespoke_powersword_p1_increase_power_on_kill_parent = {
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
templates.weapon_trait_bespoke_powersword_p1_targets_receive_rending_debuff_on_weapon_special_attacks = {
	weapon_trait_bespoke_powersword_p1_targets_receive_rending_debuff_on_weapon_special_attacks = {
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
templates.weapon_trait_bespoke_powersword_p1_pass_past_armor_on_weapon_special = {
	weapon_trait_bespoke_powersword_p1_pass_past_armor_on_weapon_special = {
		{
			stat_buffs = {
				[stat_buffs.melee_heavy_damage] = 0.05,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_heavy_damage] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_heavy_damage] = 0.15,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_heavy_damage] = 0.2,
			},
		},
	},
}
templates.weapon_trait_bespoke_powersword_p1_extended_activation_duration_on_chained_attacks = {
	weapon_trait_bespoke_powersword_p1_extended_activation_duration_on_chained_attacks = {
		{
			buff_data = {
				extra_hits_max = 1,
			},
		},
		[4] = {
			buff_data = {
				extra_hits_max = 2,
			},
		},
	},
}

return templates
