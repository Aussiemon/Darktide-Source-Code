-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_boltpistol_p1_buff_templates.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local attack_results = AttackSettings.attack_results
local stat_buffs = BuffSettings.stat_buffs
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_boltpistol_p1_crit_chance_bonus_on_melee_kills = table.clone(BaseWeaponTraitBuffTemplates.crit_chance_bonus_on_melee_kills)
templates.weapon_trait_bespoke_boltpistol_p1_hipfire_while_sprinting = table.clone(BaseWeaponTraitBuffTemplates.hipfire_while_sprinting)
templates.weapon_trait_bespoke_boltpistol_p1_crit_chance_based_on_aim_time = table.clone(BaseWeaponTraitBuffTemplates.chance_based_on_aim_time)
templates.weapon_trait_bespoke_boltpistol_p1_suppression_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.suppression_on_close_kill)
templates.weapon_trait_bespoke_boltpistol_p1_toughness_on_elite_kills = table.clone(BaseWeaponTraitBuffTemplates.toughness_on_elite_kills)
templates.weapon_trait_bespoke_boltpistol_p1_rending_on_crit = table.clone(BaseWeaponTraitBuffTemplates.rending_on_crit)
templates.weapon_trait_bespoke_boltpistol_p1_bleed_on_ranged = table.clone(BaseWeaponTraitBuffTemplates.bleed_on_ranged)
templates.weapon_trait_bespoke_boltpistol_p1_stagger_bonus_damage = table.clone(BaseWeaponTraitBuffTemplates.stagger_bonus_damage)
templates.weapon_trait_bespoke_boltpistol_p1_crit_weakspot_finesse = table.clone(BaseWeaponTraitBuffTemplates.crit_weakspot_finesse)
templates.weapon_trait_bespoke_boltpistol_p1_close_explosion = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.explosion_arming_distance_multiplier] = 0,
	},
	stat_buffs = {
		[stat_buffs.explosion_radius_modifier] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}

return templates
