local attack_settings = {
	attack_results = table.enum("damaged", "died", "dodged", "blocked", "toughness_absorbed", "toughness_absorbed_melee", "toughness_broken", "shield_blocked", "knock_down", "friendly_fire"),
	stagger_results = table.enum("stagger", "no_stagger")
}
attack_settings.is_damaging_result = {
	[attack_settings.attack_results.damaged] = true,
	[attack_settings.attack_results.died] = true,
	[attack_settings.attack_results.dodged] = true,
	[attack_settings.attack_results.blocked] = false,
	[attack_settings.attack_results.toughness_absorbed] = false,
	[attack_settings.attack_results.toughness_absorbed_melee] = true,
	[attack_settings.attack_results.toughness_broken] = true,
	[attack_settings.attack_results.shield_blocked] = false,
	[attack_settings.attack_results.knock_down] = true,
	[attack_settings.attack_results.friendly_fire] = false
}
attack_settings.attack_types = table.enum("melee", "ranged", "explosion", "shout", "buff")
attack_settings.melee_attack_strength = table.enum("heavy", "light")
local damage_efficiencies = table.enum("full", "reduced", "negated", "push")
attack_settings.damage_efficiencies = damage_efficiencies

attack_settings.armor_damage_modifier_to_damage_efficiency = function (armor_damage_modifier, armor_type)
	if (armor_type == "super_armor" or armor_type == "armored") and armor_damage_modifier <= 0.1 then
		return damage_efficiencies.negated
	elseif armor_damage_modifier > 0.6 then
		return damage_efficiencies.full
	else
		return damage_efficiencies.reduced
	end
end

attack_settings.health_settings = table.enum("player", "minion")
attack_settings.shield_settings = table.enum("block_all")

return settings("AttackSettings", attack_settings)
