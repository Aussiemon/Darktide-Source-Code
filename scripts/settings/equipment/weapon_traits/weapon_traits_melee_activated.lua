﻿-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_melee_activated.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local weapon_traits_melee_activated = {}

table.make_unique(weapon_traits_melee_activated)

weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_reduce_damage_taken = {
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_reduce_damage_taken = {
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
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increased_crit_chance = {
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increased_crit_chance = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increased_impact = {
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increased_impact = {
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
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increased_attack = {
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increased_attack = {
			{
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increased_movement_speed = {
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increased_movement_speed = {
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
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_reduce_corruption_taken = {
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_reduce_corruption_taken = {
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
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_reduce_toughness_taken = {
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_reduce_toughness_taken = {
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
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_finesse_bonus = {
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_finesse_bonus = {
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
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_unarmored = {
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_unarmored = {
			{
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_armored = {
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_armored = {
			{
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_resistant = {
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_resistant = {
			{
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_berserker = {
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_berserker = {
			{
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_super_armor = {
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_super_armor = {
			{
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_disgustingly_resilient = {
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_disgustingly_resilient = {
			{
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_increase_impact_of_next_attack = {
	buffs = {
		weapon_trait_melee_activated_wield_on_weapon_special_increase_impact_of_next_attack = {
			{},
			{},
			{},
			{},
		},
	},
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_increase_attack_of_next_attack = {
	buffs = {
		weapon_trait_melee_activated_wield_on_weapon_special_increase_attack_of_next_attack = {
			{},
			{},
			{},
			{},
		},
	},
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_attack = {
	buffs = {
		weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_attack = {
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_events = {
					[proc_events.on_kill] = 0.33,
				},
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.1,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_events = {
					[proc_events.on_kill] = 0.33,
				},
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.2,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_events = {
					[proc_events.on_kill] = 0.33,
				},
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.3,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_events = {
					[proc_events.on_kill] = 0.33,
				},
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_impact = {
	buffs = {
		weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_impact = {
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_events = {
					[proc_events.on_kill] = 0.33,
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.1,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_events = {
					[proc_events.on_kill] = 0.33,
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.2,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_events = {
					[proc_events.on_kill] = 0.33,
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.3,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_events = {
					[proc_events.on_kill] = 0.33,
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_finesse_modifier_bonus = {
	buffs = {
		weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_finesse_modifier_bonus = {
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_events = {
					[proc_events.on_kill] = 0.33,
				},
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.1,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_events = {
					[proc_events.on_kill] = 0.33,
				},
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.2,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_events = {
					[proc_events.on_kill] = 0.33,
				},
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.3,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_events = {
					[proc_events.on_kill] = 0.33,
				},
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.4,
				},
			},
		},
	},
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_replenish_toughness = {
	buffs = {
		weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_replenish_toughness = {
			{
				proc_events = {
					[proc_events.on_kill] = 0.175,
				},
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.2,
				},
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.225,
				},
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.25,
				},
			},
		},
	},
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_remove_corruption = {
	buffs = {
		weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_remove_corruption = {
			{
				proc_events = {
					[proc_events.on_kill] = 0.175,
				},
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.2,
				},
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.225,
				},
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.25,
				},
			},
		},
	},
}

return weapon_traits_melee_activated
