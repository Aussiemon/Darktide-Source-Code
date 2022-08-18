local armor_settings = {}
local armor_types = table.enum("unarmored", "armored", "resistant", "player", "berserker", "super_armor", "disgustingly_resilient", "void_shield", "prop_armor")
local armor_hit_types = table.enum("damage_negated", "damage", "dead", "died", "damage_reduced", "shield_blocked", "blocked", "shove", "stopped", "toughness_absorbed", "weakspot_damage", "weakspot_died")
armor_settings.types = armor_types
armor_settings.hit_types = armor_hit_types
armor_settings.aborts_attack = {
	[armor_types.super_armor] = true
}

return settings("ArmorSettings", armor_settings)
