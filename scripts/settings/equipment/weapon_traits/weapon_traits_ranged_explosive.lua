-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_ranged_explosive.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local weapon_traits_ranged_explosive = {}

table.make_unique(weapon_traits_ranged_explosive)

local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events

weapon_traits_ranged_explosive.weapon_traits_ranged_explosive_wield_explosion_restore_toughness = {
	buffs = {
		weapon_traits_ranged_explosive_wield_explosion_restore_toughness_buff = {
			{
				cooldown_duration = 10,
				proc_events = {
					[proc_events.on_explosion_hit] = 1,
				},
			},
			{
				cooldown_duration = 9,
				proc_events = {
					[proc_events.on_explosion_hit] = 1,
				},
			},
			{
				cooldown_duration = 8,
				proc_events = {
					[proc_events.on_explosion_hit] = 1,
				},
			},
			{
				cooldown_duration = 7,
				proc_events = {
					[proc_events.on_explosion_hit] = 1,
				},
			},
		},
	},
}
weapon_traits_ranged_explosive.weapon_traits_ranged_explosive_wield_explosion_heal_corruption = {
	buffs = {
		weapon_traits_ranged_explosive_wield_explosion_heal_corruption_buff = {
			{
				cooldown_duration = 10,
				proc_events = {
					[proc_events.on_explosion_hit] = 1,
				},
			},
			{
				cooldown_duration = 9,
				proc_events = {
					[proc_events.on_explosion_hit] = 1,
				},
			},
			{
				cooldown_duration = 8,
				proc_events = {
					[proc_events.on_explosion_hit] = 1,
				},
			},
			{
				cooldown_duration = 7,
				proc_events = {
					[proc_events.on_explosion_hit] = 1,
				},
			},
		},
	},
}
weapon_traits_ranged_explosive.weapon_traits_ranged_explosive_wield_explosion_increase_damage = {
	buffs = {
		weapon_traits_ranged_explosive_wield_explosion_increase_damage_buff = {
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.1,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.2,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.3,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_explosive.weapon_traits_ranged_explosive_wield_explosion_increase_impact = {
	buffs = {
		weapon_traits_ranged_explosive_wield_explosion_increase_impact_buff = {
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.explosion_impact_modifier] = 0.1,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.explosion_impact_modifier] = 0.2,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.explosion_impact_modifier] = 0.3,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.explosion_impact_modifier] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_explosive.weapon_traits_ranged_explosive_wield_explosion_increased_crit_chance = {
	buffs = {
		weapon_traits_ranged_explosive_wield_explosion_increased_crit_chance_buff = {
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.2,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.3,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_explosive.weapon_traits_ranged_explosive_wield_explosion_increased_unarmored_damage = {
	buffs = {
		weapon_traits_ranged_explosive_wield_explosion_increased_unarmored_damage_buff = {
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.1,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.2,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.3,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_explosive.weapon_traits_ranged_explosive_wield_explosion_increased_armored_damage = {
	buffs = {
		weapon_traits_ranged_explosive_wield_explosion_increased_armored_damage_buff = {
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.1,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.2,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.3,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_explosive.weapon_traits_ranged_explosive_wield_explosion_increased_resistant_damage = {
	buffs = {
		weapon_traits_ranged_explosive_wield_explosion_increased_resistant_damage_buff = {
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.1,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.2,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.3,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_explosive.weapon_traits_ranged_explosive_wield_explosion_increased_berserker_damage = {
	buffs = {
		weapon_traits_ranged_explosive_wield_explosion_increased_berserker_damage_buff = {
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.1,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.2,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.3,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_explosive.weapon_traits_ranged_explosive_wield_explosion_increased_super_armor_damage = {
	buffs = {
		weapon_traits_ranged_explosive_wield_explosion_increased_super_armor_damage_buff = {
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.1,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.2,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.3,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_explosive.weapon_traits_ranged_explosive_wield_explosion_increased_disgustingly_resilient_damage = {
	buffs = {
		weapon_traits_ranged_explosive_wield_explosion_increased_disgustingly_resilient_damage_buff = {
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.1,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.2,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.3,
				},
			},
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_explosion_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_explosive.weapon_traits_ranged_explosive_wield_bleed_on_hit = {
	buffs = {
		weapon_traits_ranged_explosive_wield_bleed_on_hit_buff = {
			{},
			{},
			{},
			{},
		},
	},
}

return weapon_traits_ranged_explosive
