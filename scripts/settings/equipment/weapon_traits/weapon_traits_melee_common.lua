﻿-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_melee_common.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local weapon_traits_melee_common = {}

table.make_unique(weapon_traits_melee_common)

local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events

weapon_traits_melee_common.weapon_trait_melee_common_wield_increased_attack = {
	buffs = {
		weapon_trait_melee_common_wield_increased_attack_buff = {
			{
				stat_buffs = {
					[stat_buffs.damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increased_unarmored_damage = {
	buffs = {
		weapon_trait_melee_common_wield_increased_unarmored_damage_buff = {
			{
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.25,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increased_armored_damage = {
	buffs = {
		weapon_trait_melee_common_wield_increased_armored_damage_buff = {
			{
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.25,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increased_resistant_damage = {
	buffs = {
		weapon_trait_melee_common_wield_increased_resistant_damage_buff = {
			{
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.25,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increased_berserker_damage = {
	buffs = {
		weapon_trait_melee_common_wield_increased_berserker_damage_buff = {
			{
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.25,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increased_super_armor_damage = {
	buffs = {
		weapon_trait_melee_common_wield_increased_super_armor_damage_buff = {
			{
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.25,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increased_disgustingly_resilient_damage = {
	buffs = {
		weapon_trait_melee_common_wield_increased_disgustingly_resilient_damage_buff = {
			{
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.25,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_increase_crit_chance = {
	buffs = {
		weapon_trait_increase_crit_chance = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.02,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.04,
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
weapon_traits_melee_common.weapon_trait_increase_crit_damage = {
	buffs = {
		weapon_trait_increase_crit_damage = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_damage] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_damage] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_damage] = 0.08,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_damage] = 0.1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_increase_stamina = {
	buffs = {
		weapon_trait_increase_stamina = {
			{
				stat_buffs = {
					[stat_buffs.stamina_modifier] = 1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stamina_modifier] = 1.25,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stamina_modifier] = 1.5,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stamina_modifier] = 2,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_increase_weakspot_damage = {
	buffs = {
		weapon_trait_increase_weakspot_damage = {
			{
				stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.08,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_increase_attack_speed = {
	buffs = {
		weapon_trait_increase_attack_speed = {
			{
				stat_buffs = {
					[stat_buffs.attack_speed] = 0.02,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.attack_speed] = 0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.attack_speed] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.attack_speed] = 0.05,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_increase_damage = {
	buffs = {
		weapon_trait_increase_damage = {
			{
				stat_buffs = {
					[stat_buffs.damage] = 0.01,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage] = 0.02,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage] = 0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage] = 0.04,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_increase_finesse = {
	buffs = {
		weapon_trait_increase_finesse = {
			{
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.01,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.02,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.04,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_increase_power = {
	buffs = {
		weapon_trait_increase_power = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.01,
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
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.04,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_increase_impact = {
	buffs = {
		weapon_trait_increase_impact = {
			{
				stat_buffs = {
					[stat_buffs.impact_modifier] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.impact_modifier] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.impact_modifier] = 0.07,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.impact_modifier] = 0.08,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_reduced_block_cost = {
	buffs = {
		weapon_trait_reduced_block_cost = {
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.95,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.8,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_increase_damage_elites = {
	buffs = {
		weapon_trait_increase_damage_elites = {
			{
				stat_buffs = {
					[stat_buffs.damage_vs_elites] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_elites] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_elites] = 0.08,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_elites] = 0.1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_increase_damage_hordes = {
	buffs = {
		weapon_trait_increase_damage_hordes = {
			{
				stat_buffs = {
					[stat_buffs.damage_vs_horde] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_horde] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_horde] = 0.08,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_horde] = 0.1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_increase_damage_specials = {
	buffs = {
		weapon_trait_increase_damage_specials = {
			{
				stat_buffs = {
					[stat_buffs.damage_vs_specials] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_specials] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_specials] = 0.08,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_specials] = 0.1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_reduce_sprint_cost = {
	buffs = {
		weapon_trait_reduce_sprint_cost = {
			{
				stat_buffs = {
					[stat_buffs.sprinting_cost_multiplier] = 0.94,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.sprinting_cost_multiplier] = 0.91,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.sprinting_cost_multiplier] = 0.88,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.sprinting_cost_multiplier] = 0.85,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_equip_decrease_corruption_damage_taken = {
	buffs = {
		weapon_trait_melee_common_equip_decrease_corruption_damage_taken_buff = {
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.845,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.835,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.82,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_decrease_corruption_damage_taken = {
	buffs = {
		weapon_trait_melee_common_wield_decrease_corruption_damage_taken_buff = {
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.845,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.835,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.82,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_equip_decrease_toughness_damage_taken = {
	buffs = {
		weapon_trait_melee_common_equip_decrease_toughness_damage_taken_buff = {
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.845,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.835,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.82,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_decrease_toughness_damage_taken = {
	buffs = {
		weapon_trait_melee_common_wield_decrease_toughness_damage_taken_buff = {
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.845,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.835,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.82,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_equip_decrease_damage_taken = {
	buffs = {
		weapon_trait_melee_common_equip_decrease_damage_taken_buff = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_multiplier] = 0.845,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_multiplier] = 0.835,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_multiplier] = 0.82,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_decrease_damage_taken = {
	buffs = {
		weapon_trait_melee_common_wield_decrease_damage_taken_buff = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_multiplier] = 0.845,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_multiplier] = 0.835,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_multiplier] = 0.82,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_equip_increase_movement_speed = {
	buffs = {
		weapon_trait_melee_common_equip_increase_movement_speed_buff = {
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increase_movement_speed = {
	buffs = {
		weapon_trait_melee_common_wield_increase_movement_speed_buff = {
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increase_crit_chance = {
	buffs = {
		weapon_trait_melee_common_wield_increase_crit_chance_buff = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.2,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increase_impact = {
	buffs = {
		weapon_trait_melee_common_wield_increase_impact_buff = {
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_power_modifier_bonus = {
	buffs = {
		weapon_trait_melee_common_wield_power_modifier_bonus_buff = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_finesse_modifier_bonus = {
	buffs = {
		weapon_trait_melee_common_wield_finesse_modifier_bonus_buff = {
			{
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_damage_bonus = {
	buffs = {
		weapon_trait_melee_common_wield_on_hit_damage_bonus_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
				stat_buffs = {
					[stat_buffs.damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_power_bonus = {
	buffs = {
		weapon_trait_melee_common_wield_on_hit_power_bonus_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.15,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_impact_bonus = {
	buffs = {
		weapon_trait_melee_common_wield_on_hit_impact_bonus_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_increased_unarmored_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_hit_increased_unarmored_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_increased_armored_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_hit_increased_armored_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_increased_resistant_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_hit_increased_resistant_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_increased_berserker_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_hit_increased_berserker_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_increased_super_armor_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_hit_increased_super_armor_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_increased_disgustingly_resilient_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_hit_increased_disgustingly_resilient_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_bleed = {
	buffs = {
		weapon_trait_melee_common_wield_on_hit_bleed_buff = {
			{
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
			},
			{
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
			},
			{
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
			},
			{
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_staggered_power_bonus = {
	buffs = {
		weapon_trait_melee_common_wield_on_hit_staggered_power_bonus_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.15,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_attack_grant_power_bonus = {
	buffs = {
		weapon_trait_melee_common_wield_on_heavy_attack_grant_power_bonus_buff = {
			{
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
			},
			{
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
			},
			{
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
			},
			{
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_damage_bonus = {
	buffs = {
		weapon_trait_melee_common_wield_on_heavy_hit_damage_bonus_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_power_bonus = {
	buffs = {
		weapon_trait_melee_common_wield_on_heavy_hit_power_bonus_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.15,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_impact_bonus = {
	buffs = {
		weapon_trait_melee_common_wield_on_heavy_hit_impact_bonus_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_increased_unarmored_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_heavy_hit_increased_unarmored_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_increased_armored_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_heavy_hit_increased_armored_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_increased_resistant_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_heavy_hit_increased_resistant_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_increased_berserker_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_heavy_hit_increased_berserker_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_increased_super_armor_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_heavy_hit_increased_super_armor_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_increased_disgustingly_resilient_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_heavy_hit_increased_disgustingly_resilient_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_power_modifier_bonus_on_full_toughness = {
	buffs = {
		weapon_trait_melee_common_wield_power_modifier_bonus_on_full_toughness_buff = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_supression_immunity_on_full_toughness = {
	buffs = {
		weapon_trait_melee_common_wield_supression_immunity_on_full_toughness_buff = {
			{},
			{},
			{},
			{},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_player_toughness_broken_grant_power_level = {
	buffs = {
		weapon_trait_melee_common_wield_on_player_toughness_broken_grant_power_level_buff = {
			{
				active_duration = 2.5,
				cooldown_duration = 3.75,
				proc_events = {
					[proc_events.on_player_toughness_broken] = 1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1,
				},
			},
			{
				active_duration = 2.5,
				cooldown_duration = 3.5,
				proc_events = {
					[proc_events.on_player_toughness_broken] = 1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.5,
				},
			},
			{
				active_duration = 2.5,
				cooldown_duration = 3.25,
				proc_events = {
					[proc_events.on_player_toughness_broken] = 1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.15,
				},
			},
			{
				active_duration = 2.5,
				cooldown_duration = 3,
				proc_events = {
					[proc_events.on_player_toughness_broken] = 1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_successful_dodge_grant_finesse_bonus = {
	buffs = {
		weapon_trait_melee_common_wield_on_successful_dodge_grant_finesse_bonus_buff = {
			{
				proc_events = {
					[proc_events.on_successful_dodge] = 1,
				},
			},
			{
				proc_events = {
					[proc_events.on_successful_dodge] = 1,
				},
			},
			{
				proc_events = {
					[proc_events.on_successful_dodge] = 1,
				},
			},
			{
				proc_events = {
					[proc_events.on_successful_dodge] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_successful_dodge_grant_crit_chance = {
	buffs = {
		weapon_trait_melee_common_wield_on_successful_dodge_grant_crit_chance_buff = {
			{
				proc_events = {
					[proc_events.on_successful_dodge] = 1,
				},
			},
			{
				proc_events = {
					[proc_events.on_successful_dodge] = 1,
				},
			},
			{
				proc_events = {
					[proc_events.on_successful_dodge] = 1,
				},
			},
			{
				proc_events = {
					[proc_events.on_successful_dodge] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_successful_dodge_grant_bleed = {
	buffs = {
		weapon_trait_melee_common_wield_on_successful_dodge_grant_bleed_buff = {
			{
				proc_events = {
					[proc_events.on_successful_dodge] = 1,
				},
			},
			{
				proc_events = {
					[proc_events.on_successful_dodge] = 1,
				},
			},
			{
				proc_events = {
					[proc_events.on_successful_dodge] = 1,
				},
			},
			{
				proc_events = {
					[proc_events.on_successful_dodge] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_low_health_grant_suppression_immunity = {
	buffs = {
		weapon_trait_melee_common_wield_low_health_grant_suppression_immunity_buff = {
			{},
			{},
			{},
			{},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_low_health_grant_power_modifier = {
	buffs = {
		weapon_trait_melee_common_wield_low_health_grant_power_modifier_buff = {
			{},
			{},
			{},
			{},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_equip_immunity_on_all_allies_down = {
	buffs = {
		weapon_trait_melee_common_equip_immunity_on_all_allies_down_buff = {
			{
				proc_events = {
					[proc_events.on_ally_knocked_down] = 1,
				},
			},
			{
				proc_events = {
					[proc_events.on_ally_knocked_down] = 1,
				},
			},
			{
				proc_events = {
					[proc_events.on_ally_knocked_down] = 1,
				},
			},
			{
				proc_events = {
					[proc_events.on_ally_knocked_down] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_push_hit_grants_increased_attack = {
	buffs = {
		weapon_trait_melee_common_wield_push_hit_grants_increased_attack_buff = {
			{
				proc_events = {
					[proc_events.on_push_hit] = 1,
				},
			},
			{
				proc_events = {
					[proc_events.on_push_hit] = 1,
				},
			},
			{
				proc_events = {
					[proc_events.on_push_hit] = 1,
				},
			},
			{
				proc_events = {
					[proc_events.on_push_hit] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_break_grant_power_bonus = {
	buffs = {
		weapon_trait_melee_common_wield_on_block_break_grant_power_bonus_buff = {
			{
				active_duration = 3,
				cooldown_duration = 4.25,
				proc_events = {
					[proc_events.on_block] = 0.05,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 4,
				proc_events = {
					[proc_events.on_block] = 0.075,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.5,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 3.75,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.15,
				},
			},
			{
				active_duration = 3,
				cooldown_duration = 3.5,
				proc_events = {
					[proc_events.on_block] = 0.125,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_damage_bonus = {
	buffs = {
		weapon_trait_melee_common_wield_on_block_damage_bonus_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_power_bonus = {
	buffs = {
		weapon_trait_melee_common_wield_on_block_power_bonus_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.15,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_impact_bonus = {
	buffs = {
		weapon_trait_melee_common_wield_on_block_impact_bonus_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_increased_unarmored_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_block_increased_unarmored_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_increased_armored_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_block_increased_armored_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.armored_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_increased_resistant_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_block_increased_resistant_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.resistant_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_increased_berserker_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_block_increased_berserker_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.berserker_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_increased_super_armor_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_block_increased_super_armor_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_increased_disgustingly_resilient_damage = {
	buffs = {
		weapon_trait_melee_common_wield_on_block_increased_disgustingly_resilient_damage_buff = {
			{
				active_duration = 5,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.25,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.5,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.75,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_block] = 0.1,
				},
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 1,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_weakspot_grant_power_bonus = {
	buffs = {
		weapon_trait_melee_common_wield_on_weakspot_grant_power_bonus_buff = {
			{
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
			},
			{
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
			},
			{
				proc_events = {
					[proc_events.on_hit] = 0.15,
				},
			},
			{
				proc_events = {
					[proc_events.on_hit] = 0.2,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_weakspot_grant_bleeding = {
	buffs = {
		weapon_trait_melee_common_wield_on_weakspot_grant_bleeding_buff = {
			{
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
			},
			{
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
			},
			{
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_hit] = 0.125,
				},
			},
			{
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_hit] = 0.15,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_attack_kill_increase_attack = {
	buffs = {
		weapon_trait_melee_common_wield_on_heavy_attack_kill_increase_attack_buff = {
			{
				active_duration = 2,
				cooldown_duration = 6.25,
				proc_events = {
					[proc_events.on_kill] = 1,
				},
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.125,
				},
			},
			{
				active_duration = 2,
				cooldown_duration = 6,
				proc_events = {
					[proc_events.on_kill] = 1,
				},
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.15,
				},
			},
			{
				active_duration = 2,
				cooldown_duration = 5.75,
				proc_events = {
					[proc_events.on_kill] = 1,
				},
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.175,
				},
			},
			{
				active_duration = 2.5,
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_kill] = 1,
				},
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.2,
				},
			},
		},
	},
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_attack_kill_increase_attack_speed = {
	buffs = {
		weapon_trait_melee_common_wield_on_heavy_attack_kill_increase_attack_speed_buff = {
			{
				active_duration = 1.5,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_kill] = 1,
				},
				stat_buffs = {
					[stat_buffs.melee_attack_speed] = 0.1,
				},
			},
			{
				active_duration = 2,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_kill] = 1,
				},
				stat_buffs = {
					[stat_buffs.melee_attack_speed] = 0.1,
				},
			},
			{
				active_duration = 2.25,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_kill] = 1,
				},
				stat_buffs = {
					[stat_buffs.melee_attack_speed] = 0.1,
				},
			},
			{
				active_duration = 2.5,
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_kill] = 1,
				},
				stat_buffs = {
					[stat_buffs.melee_attack_speed] = 0.1,
				},
			},
		},
	},
}

return weapon_traits_melee_common
