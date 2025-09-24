-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_perks_ranged_buff_templates.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_ranged_common_wield_increased_unarmored_damage_buff = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.unarmored_damage] = 0.15,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_common_wield_increased_armored_damage_buff = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.armored_damage] = 0.15,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_common_wield_increased_resistant_damage_buff = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.resistant_damage] = 0.15,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_common_wield_increased_berserker_damage_buff = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.berserker_damage] = 0.15,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_common_wield_increased_super_armor_damage_buff = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.super_armor_damage] = 0.15,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_common_wield_increased_disgustingly_resilient_damage_buff = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.disgustingly_resilient_damage] = 0.5,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_increase_crit_chance = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.05,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_increase_crit_damage = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_damage] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_increase_stamina = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.stamina_modifier] = 1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_increase_weakspot_damage = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.weakspot_damage] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_increase_damage = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.damage] = 0.04,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_increase_finesse = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.finesse_modifier_bonus] = 0.04,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_increase_power = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.04,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_increase_damage_elites = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.damage_vs_elites] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_increase_damage_hordes = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.damage_vs_horde] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_increase_damage_specials = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.damage_vs_specials] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_ranged_increased_reload_speed = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.reload_speed] = 0.08,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}

return templates
