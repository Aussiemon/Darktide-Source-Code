-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_heavystubber_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_heavystubber_p1_toughness_on_continuous_fire = {
	weapon_trait_bespoke_ogryn_heavystubber_p1_toughness_on_continuous_fire = {
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
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_power_bonus_on_continuous_fire = {
	weapon_trait_bespoke_ogryn_heavystubber_p1_power_bonus_on_continuous_fire = {
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
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_increased_suppression_on_continuous_fire = {
	weapon_trait_bespoke_ogryn_heavystubber_p1_increased_suppression_on_continuous_fire = {
		{
			stat_buffs = {
				[stat_buffs.suppression_dealt] = 0.08,
				[stat_buffs.damage_vs_suppressed] = 0.03,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.suppression_dealt] = 0.12,
				[stat_buffs.damage_vs_suppressed] = 0.04,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.suppression_dealt] = 0.16,
				[stat_buffs.damage_vs_suppressed] = 0.05,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.suppression_dealt] = 0.2,
				[stat_buffs.damage_vs_suppressed] = 0.06,
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_movement_speed_on_continous_fire = {
	weapon_trait_bespoke_ogryn_heavystubber_p1_movement_speed_on_continous_fire = {
		{
			stat_buffs = {
				[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.93,
				[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.93,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.92,
				[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.92,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.91,
				[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.91,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.9,
				[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.9,
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill = {
	weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill_parent = {
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
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power = {
	weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_parent = {
		{
			child_duration = 2,
			child_max_stacks = 5,
			number_of_hits_per_stack = 4,
			stat_buffs = {
				[stat_buffs.ranged_power_level_modifier] = 0.07,
			},
		},
		{
			child_duration = 2,
			child_max_stacks = 5,
			number_of_hits_per_stack = 4,
			stat_buffs = {
				[stat_buffs.ranged_power_level_modifier] = 0.08,
			},
		},
		{
			child_duration = 2,
			child_max_stacks = 5,
			number_of_hits_per_stack = 4,
			stat_buffs = {
				[stat_buffs.ranged_power_level_modifier] = 0.09,
			},
		},
		{
			child_duration = 2,
			child_max_stacks = 5,
			number_of_hits_per_stack = 4,
			stat_buffs = {
				[stat_buffs.ranged_power_level_modifier] = 0.1,
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_ammo_from_reserve_on_crit = {
	weapon_trait_bespoke_ogryn_heavystubber_p1_ammo_from_reserve_on_crit = {
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
}

return templates
