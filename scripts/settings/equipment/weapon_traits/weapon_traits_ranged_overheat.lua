﻿-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_ranged_overheat.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local weapon_traits_ranged_overheat = {}

table.make_unique(weapon_traits_ranged_overheat)

local stat_buffs = BuffSettings.stat_buffs

weapon_traits_ranged_overheat.weapon_trait_ranged_overheat_wield_increased_vent_speed = {
	buffs = {
		weapon_trait_ranged_overheat_wield_increased_vent_speed = {
			{
				stat_buffs = {
					[stat_buffs.vent_overheat_speed] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.vent_overheat_speed] = 0.88,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.vent_overheat_speed] = 0.86,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.vent_overheat_speed] = 0.84,
				},
			},
		},
	},
}
weapon_traits_ranged_overheat.weapon_trait_ranged_overheat_wield_reduced_vent_damage_taken = {
	buffs = {
		weapon_trait_ranged_overheat_wield_reduced_vent_damage_taken = {
			{
				stat_buffs = {
					[stat_buffs.vent_overheat_damage_multiplier] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.vent_overheat_damage_multiplier] = 0.88,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.vent_overheat_damage_multiplier] = 0.86,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.vent_overheat_damage_multiplier] = 0.84,
				},
			},
		},
	},
}
weapon_traits_ranged_overheat.weapon_trait_ranged_overheat_wield_reduced_overheat_generation_firing = {
	buffs = {
		weapon_trait_ranged_overheat_wield_reduced_overheat_generation_firing = {
			{
				stat_buffs = {
					[stat_buffs.overheat_immediate_amount] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.overheat_immediate_amount] = 0.88,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.overheat_immediate_amount] = 0.86,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.overheat_immediate_amount] = 0.84,
				},
			},
		},
	},
}
weapon_traits_ranged_overheat.weapon_trait_ranged_overheat_wield_reduced_overheat_generation_charging = {
	buffs = {
		weapon_trait_ranged_overheat_wield_reduced_overheat_generation_charging = {
			{
				stat_buffs = {
					[stat_buffs.overheat_over_time_amount] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.overheat_over_time_amount] = 0.88,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.overheat_over_time_amount] = 0.86,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.overheat_over_time_amount] = 0.84,
				},
			},
		},
	},
}
weapon_traits_ranged_overheat.weapon_trait_ranged_overheat_wield_increased_charge_speed = {
	buffs = {
		weapon_trait_ranged_overheat_wield_increased_charge_speed = {
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.12,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.14,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.16,
				},
			},
		},
	},
}
weapon_traits_ranged_overheat.weapon_trait_ranged_overheat_wield_increased_damage_on_full_charge = {
	buffs = {
		weapon_trait_ranged_overheat_wield_increased_damage_on_full_charge = {
			{
				stat_buffs = {
					[stat_buffs.fully_charged_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.fully_charged_damage] = 0.12,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.fully_charged_damage] = 0.14,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.fully_charged_damage] = 0.16,
				},
			},
		},
	},
}
weapon_traits_ranged_overheat.weapon_trait_ranged_overheat_wield_high_overheat_increased_charge_speed = {
	buffs = {
		weapon_trait_ranged_overheat_wield_high_overheat_increased_charge_speed = {
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.24,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.28,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.32,
				},
			},
		},
	},
}
weapon_traits_ranged_overheat.weapon_trait_ranged_overheat_wield_high_overheat_increased_damage_on_full_charge = {
	buffs = {
		weapon_trait_ranged_overheat_wield_high_overheat_increased_damage_on_full_charge = {
			{
				stat_buffs = {
					[stat_buffs.fully_charged_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.fully_charged_damage] = 0.24,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.fully_charged_damage] = 0.28,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.fully_charged_damage] = 0.32,
				},
			},
		},
	},
}

return weapon_traits_ranged_overheat
