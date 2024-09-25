﻿-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_ranged_common.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local weapon_traits_ranged_common = {}

table.make_unique(weapon_traits_ranged_common)

local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events

weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increased_attack = {
	buffs = {
		weapon_trait_ranged_common_wield_increased_attack_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increased_unarmored_damage = {
	buffs = {
		weapon_trait_ranged_common_wield_increased_unarmored_damage_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increased_armored_damage = {
	buffs = {
		weapon_trait_ranged_common_wield_increased_armored_damage_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increased_resistant_damage = {
	buffs = {
		weapon_trait_ranged_common_wield_increased_resistant_damage_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increased_berserker_damage = {
	buffs = {
		weapon_trait_ranged_common_wield_increased_berserker_damage_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increased_super_armor_damage = {
	buffs = {
		weapon_trait_ranged_common_wield_increased_super_armor_damage_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increased_disgustingly_resilient_damage = {
	buffs = {
		weapon_trait_ranged_common_wield_increased_disgustingly_resilient_damage_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_increase_crit_chance = {
	buffs = {
		weapon_trait_ranged_increase_crit_chance = {
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
weapon_traits_ranged_common.weapon_trait_ranged_increase_crit_damage = {
	buffs = {
		weapon_trait_ranged_increase_crit_damage = {
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
weapon_traits_ranged_common.weapon_trait_ranged_increase_stamina = {
	buffs = {
		weapon_trait_ranged_increase_stamina = {
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
weapon_traits_ranged_common.weapon_trait_ranged_increase_weakspot_damage = {
	buffs = {
		weapon_trait_ranged_increase_weakspot_damage = {
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
weapon_traits_ranged_common.weapon_trait_ranged_increase_damage = {
	buffs = {
		weapon_trait_ranged_increase_damage = {
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
weapon_traits_ranged_common.weapon_trait_ranged_increase_finesse = {
	buffs = {
		weapon_trait_ranged_increase_finesse = {
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
weapon_traits_ranged_common.weapon_trait_ranged_increase_power = {
	buffs = {
		weapon_trait_ranged_increase_power = {
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
weapon_traits_ranged_common.weapon_trait_ranged_increase_damage_elites = {
	buffs = {
		weapon_trait_ranged_increase_damage_elites = {
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
weapon_traits_ranged_common.weapon_trait_ranged_increase_damage_hordes = {
	buffs = {
		weapon_trait_ranged_increase_damage_hordes = {
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
weapon_traits_ranged_common.weapon_trait_ranged_increase_damage_specials = {
	buffs = {
		weapon_trait_ranged_increase_damage_specials = {
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
weapon_traits_ranged_common.weapon_trait_ranged_increased_reload_speed = {
	buffs = {
		weapon_trait_ranged_increased_reload_speed = {
			{
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.07,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.085,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.1,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_common_equip_decrease_corruption_damage_taken = {
	buffs = {
		weapon_trait_ranged_common_equip_decrease_corruption_damage_taken_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_decrease_corruption_damage_taken = {
	buffs = {
		weapon_trait_ranged_common_wield_decrease_corruption_damage_taken_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_equip_decrease_toughness_damage_taken = {
	buffs = {
		weapon_trait_ranged_common_equip_decrease_toughness_damage_taken_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_decrease_toughness_damage_taken = {
	buffs = {
		weapon_trait_ranged_common_wield_decrease_toughness_damage_taken_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_equip_decrease_damage_taken = {
	buffs = {
		weapon_trait_ranged_common_equip_decrease_damage_taken_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_decrease_damage_taken = {
	buffs = {
		weapon_trait_ranged_common_wield_decrease_damage_taken_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_equip_increase_movement_speed = {
	buffs = {
		weapon_trait_ranged_common_equip_increase_movement_speed_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increase_movement_speed = {
	buffs = {
		weapon_trait_ranged_common_wield_increase_movement_speed_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increase_crit_chance = {
	buffs = {
		weapon_trait_ranged_common_wield_increase_crit_chance_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increase_ranged_damage = {
	buffs = {
		weapon_trait_ranged_common_wield_increase_ranged_damage_buff = {
			{
				stat_buffs = {
					[stat_buffs.ranged_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_damage] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_damage] = 0.25,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increase_impact = {
	buffs = {
		weapon_trait_ranged_common_wield_increase_impact_buff = {
			{
				stat_buffs = {
					[stat_buffs.ranged_impact_modifier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_impact_modifier] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_impact_modifier] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_impact_modifier] = 0.4,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_increase_stamina_regen = {
	buffs = {
		weapon_trait_ranged_common_wield_increase_stamina_regen_buff = {
			{
				stat_buffs = {
					[stat_buffs.stamina_regeneration_multiplier] = 1.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stamina_regeneration_multiplier] = 1.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stamina_regeneration_multiplier] = 1.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stamina_regeneration_multiplier] = 1.4,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_power_modifier_bonus = {
	buffs = {
		weapon_trait_ranged_common_wield_power_modifier_bonus_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_finesse_modifier_bonus = {
	buffs = {
		weapon_trait_ranged_common_wield_finesse_modifier_bonus_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_power_modifier_bonus_on_full_toughness = {
	buffs = {
		weapon_trait_ranged_common_wield_power_modifier_bonus_on_full_toughness_buff = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.25,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.35,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.45,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_immunity_on_all_allies_down = {
	buffs = {
		weapon_trait_ranged_common_wield_immunity_on_all_allies_down_buff = {
			{
				active_duration = 5,
				proc_events = {
					[proc_events.on_ally_knocked_down] = 1,
				},
			},
			{
				active_duration = 5.2,
				proc_events = {
					[proc_events.on_ally_knocked_down] = 1,
				},
			},
			{
				active_duration = 5.4,
				proc_events = {
					[proc_events.on_ally_knocked_down] = 1,
				},
			},
			{
				active_duration = 5.6,
				proc_events = {
					[proc_events.on_ally_knocked_down] = 1,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_suppression_immune_while_sprinting = {
	buffs = {
		weapon_trait_ranged_common_wield_suppression_immune_while_sprinting_buff = {
			{},
			{},
			{},
			{},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_low_health_grant_power_modifier = {
	buffs = {
		weapon_trait_ranged_common_wield_low_health_grant_power_modifier_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_equip_last_wound_grant_damage_reduction = {
	buffs = {
		weapon_trait_ranged_common_equip_last_wound_grant_damage_reduction_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_on_player_toughness_broken_grant_power_level = {
	buffs = {
		weapon_trait_ranged_common_wield_on_player_toughness_broken_grant_power_level_buff = {
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
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_on_kill_suppression_immune = {
	buffs = {
		weapon_trait_ranged_common_wield_on_kill_suppression_immune_buff = {
			{
				active_duration = 2.5,
				proc_events = {
					[proc_events.on_hit] = 0.025,
				},
			},
			{
				active_duration = 2.5,
				proc_events = {
					[proc_events.on_hit] = 0.05,
				},
			},
			{
				active_duration = 2.5,
				proc_events = {
					[proc_events.on_hit] = 0.075,
				},
			},
			{
				active_duration = 2.5,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
			},
		},
	},
}
weapon_traits_ranged_common.weapon_trait_ranged_common_wield_reduce_damage_while_reloading = {
	buffs = {
		weapon_trait_ranged_common_wield_reduce_damage_while_reloading_buff = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_multiplier] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_multiplier] = 0.8,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_multiplier] = 0.75,
				},
			},
		},
	},
}

return weapon_traits_ranged_common
