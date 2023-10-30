local armor_settings = {}
local armor_types = table.enum("unarmored", "armored", "resistant", "player", "berserker", "super_armor", "disgustingly_resilient", "void_shield", "prop_armor")
local minion_armor_types = table.enum(armor_types.unarmored, armor_types.armored, armor_types.resistant, armor_types.berserker, armor_types.super_armor, armor_types.disgustingly_resilient)
local armor_hit_types = table.enum("damage_negated", "damage", "dead", "died", "damage_reduced", "shield_blocked", "blocked", "shove", "stopped", "toughness_absorbed", "toughness_absorbed_melee", "weakspot_damage", "weakspot_died")
local overdamage_rending_multipliers = {
	[armor_types.armored] = 0.25,
	[armor_types.super_armor] = 0.25,
	[armor_types.resistant] = 0.25,
	[armor_types.berserker] = 0.25
}
local rending_armor_type_multipliers = {
	[armor_types.armored] = 1,
	[armor_types.super_armor] = 1,
	[armor_types.resistant] = 1,
	[armor_types.berserker] = 1
}
armor_settings.types = armor_types
armor_settings.overdamage_rending_multipliers = overdamage_rending_multipliers
armor_settings.rending_armor_type_multipliers = rending_armor_type_multipliers
armor_settings.minion_armor_types = minion_armor_types
armor_settings.hit_types = armor_hit_types
armor_settings.aborts_attack = {
	[armor_types.super_armor] = true
}

return settings("ArmorSettings", armor_settings)
