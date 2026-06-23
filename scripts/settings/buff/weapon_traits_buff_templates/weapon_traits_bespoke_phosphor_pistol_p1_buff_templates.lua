-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_phosphor_pistol_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BrokerBuffUtils = require("scripts/settings/buff/broker_buff_utils")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local keywords = BuffSettings.keywords
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_phosphor_pistol_p1_crit_chance_based_on_ammo_left = table.clone(BaseWeaponTraitBuffTemplates.crit_chance_based_on_ammo_left)
templates.weapon_trait_bespoke_phosphor_pistol_p1_toughness_on_elite_kills = table.clone(BaseWeaponTraitBuffTemplates.toughness_on_elite_kills)
templates.weapon_trait_bespoke_phosphor_pistol_p1_rending_on_crit = table.clone(BaseWeaponTraitBuffTemplates.rending_on_crit)
templates.weapon_trait_bespoke_phosphor_pistol_p1_burninating_on_crit = table.clone(BaseWeaponTraitBuffTemplates.burninating_on_crit_ranged)
templates.weapon_trait_bespoke_phosphor_pistol_p1_cleave_on_crit = table.clone(BaseWeaponTraitBuffTemplates.infinite_cleave_on_crit)
templates.weapon_trait_bespoke_phosphor_pistol_p1_power_bonus_on_first_shot = table.clone(BaseWeaponTraitBuffTemplates.power_bonus_on_first_shot)
templates.weapon_trait_bespoke_phosphor_pistol_p1_increases_power_while_aiming = table.clone(BaseWeaponTraitBuffTemplates.power_level_on_aim_time)
templates.weapon_trait_bespoke_phosphor_pistol_p1_crit_chance_based_on_aim_time = table.clone(BaseWeaponTraitBuffTemplates.chance_based_on_aim_time)
templates.weapon_trait_bespoke_phosphor_pistol_p1_recoil_reduction_and_suppression_increase_on_close_kills = table.clone(BaseWeaponTraitBuffTemplates.recoil_reduction_and_suppression_increase_on_close_kills)
templates.weapon_trait_bespoke_phosphor_pistol_p1_chance_to_explode_elites_on_kill = table.merge(table.clone(BaseWeaponTraitBuffTemplates.chance_to_explode_elites_on_kill), {
	proc_data = {
		fire_buff_id = "phosphor_burn",
		explosion_template = ExplosionTemplates.trait_buff_phosphor_pistol_p1_minion_explosion,
		validation_keywords = {
			keywords.burning,
		},
	},
})

return templates
