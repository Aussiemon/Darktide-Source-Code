-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_ranged_warp_charge.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local weapon_traits_ranged_warp_charge = {}

table.make_unique(weapon_traits_ranged_warp_charge)

local buff_stat_buffs = BuffSettings.stat_buffs

weapon_traits_ranged_warp_charge.weapon_trait_ranged_warp_charge_wield_increased_vent_speed = {
	weapon_trait_ranged_warp_charge_wield_increased_vent_speed = {
		{
			stat_buffs = {
				[buff_stat_buffs.vent_warp_charge_speed] = 0.9,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.vent_warp_charge_speed] = 0.88,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.vent_warp_charge_speed] = 0.86,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.vent_warp_charge_speed] = 0.84,
			},
		},
	},
}
weapon_traits_ranged_warp_charge.weapon_trait_ranged_warp_charge_wield_reduced_vent_damage_taken = {
	weapon_trait_ranged_warp_charge_wield_reduced_vent_damage_taken = {
		{
			stat_buffs = {
				[buff_stat_buffs.vent_warp_charge_damage_multiplier] = 0.9,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.vent_warp_charge_damage_multiplier] = 0.88,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.vent_warp_charge_damage_multiplier] = 0.86,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.vent_warp_charge_damage_multiplier] = 0.84,
			},
		},
	},
}
weapon_traits_ranged_warp_charge.weapon_trait_ranged_warp_charge_wield_reduced_warp_charge_generation_firing = {
	weapon_trait_ranged_warp_charge_wield_reduced_warp_charge_generation_firing = {
		{
			stat_buffs = {
				[buff_stat_buffs.warp_charge_immediate_amount] = 0.9,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.warp_charge_immediate_amount] = 0.88,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.warp_charge_immediate_amount] = 0.86,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.warp_charge_immediate_amount] = 0.84,
			},
		},
	},
}
weapon_traits_ranged_warp_charge.weapon_trait_ranged_warp_charge_wield_reduced_warp_charge_generation_charging = {
	weapon_trait_ranged_warp_charge_wield_reduced_warp_charge_generation_charging = {
		{
			stat_buffs = {
				[buff_stat_buffs.warp_charge_over_time_amount] = 0.9,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.warp_charge_over_time_amount] = 0.88,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.warp_charge_over_time_amount] = 0.86,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.warp_charge_over_time_amount] = 0.84,
			},
		},
	},
}
weapon_traits_ranged_warp_charge.weapon_trait_ranged_warp_charge_wield_increased_charge_speed = {
	weapon_trait_ranged_warp_charge_wield_increased_charge_speed = {
		{
			stat_buffs = {
				[buff_stat_buffs.charge_up_time] = -0.1,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.charge_up_time] = -0.12,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.charge_up_time] = -0.14,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.charge_up_time] = -0.16,
			},
		},
	},
}
weapon_traits_ranged_warp_charge.weapon_trait_ranged_warp_charge_wield_increased_damage_on_full_charge = {
	weapon_trait_ranged_warp_charge_wield_increased_damage_on_full_charge = {
		{
			stat_buffs = {
				[buff_stat_buffs.fully_charged_damage] = 0.1,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.fully_charged_damage] = 0.12,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.fully_charged_damage] = 0.14,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.fully_charged_damage] = 0.16,
			},
		},
	},
}
weapon_traits_ranged_warp_charge.weapon_trait_ranged_warp_charge_wield_high_warp_charge_increased_charge_speed = {
	weapon_trait_ranged_warp_charge_wield_high_warp_charge_increased_charge_speed = {
		{
			stat_buffs = {
				[buff_stat_buffs.charge_up_time] = -0.2,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.charge_up_time] = -0.24,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.charge_up_time] = -0.28,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.charge_up_time] = -0.32,
			},
		},
	},
}
weapon_traits_ranged_warp_charge.weapon_trait_ranged_warp_charge_wield_high_warp_charge_increased_damage_on_full_charge = {
	weapon_trait_ranged_warp_charge_wield_high_warp_charge_increased_damage_on_full_charge = {
		{
			stat_buffs = {
				[buff_stat_buffs.fully_charged_damage] = 0.2,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.fully_charged_damage] = 0.24,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.fully_charged_damage] = 0.28,
			},
		},
		{
			stat_buffs = {
				[buff_stat_buffs.fully_charged_damage] = 0.32,
			},
		},
	},
}

return weapon_traits_ranged_warp_charge
