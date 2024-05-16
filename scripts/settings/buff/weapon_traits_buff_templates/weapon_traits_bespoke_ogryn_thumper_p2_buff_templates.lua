-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_ogryn_thumper_p2_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BuffUtils = require("scripts/settings/buff/buff_utils")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local proc_events = BuffSettings.proc_events
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_thumper_p2_toughness_on_elite_kills = table.clone(BaseWeaponTraitBuffTemplates.toughness_on_elite_kills)
templates.weapon_trait_bespoke_ogryn_thumper_p2_power_bonus_on_continuous_fire = table.merge({
	use_combo = true,
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.02,
	},
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_ogryn_thumper_p2_explosion_radius_bonus_on_continuous_fire = table.merge({
	use_combo = true,
	conditional_stat_buffs = {
		[stat_buffs.explosion_radius_modifier] = 0.03,
	},
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_ogryn_thumper_p2_pass_trough_armor_on_weapon_special = table.clone(BaseWeaponTraitBuffTemplates.pass_trough_armor_on_weapon_special)
templates.weapon_trait_bespoke_ogryn_thumper_p2_targets_receive_rending_debuff = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff)
templates.weapon_trait_bespoke_ogryn_thumper_p2_targets_receive_rending_debuff.check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_ranged_hit)
templates.weapon_trait_bespoke_ogryn_thumper_p2_grenades_stick_to_monsters = table.clone(BaseWeaponTraitBuffTemplates.sticky_projectiles)
templates.weapon_trait_bespoke_ogryn_thumper_p2_close_explosion_applies_bleed = {
	class_name = "proc_buff",
	predicted = false,
	start_func = BuffUtils.add_debuff_on_hit_start,
	proc_func = BuffUtils.add_debuff_on_hit_proc,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		if not CheckProcFunctions.on_damaging_hit then
			return false
		end

		if not CheckProcFunctions.on_non_kill then
			return false
		end

		if not CheckProcFunctions.on_explosion_hit then
			return false
		end

		if not CheckProcFunctions.attacked_unit_is_minion then
			return false
		end

		local damage_profile = params.damage_profile

		if not damage_profile or damage_profile.name ~= "ogryn_thumper_p1_m2_close_instant" then
			return false
		end

		return true
	end,
	target_buff_data = {
		internal_buff_name = "bleed",
		max_stacks = 31,
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_ogryn_thumper_p2_weakspot_projectile_hit_increases_reload_speed = {
	active_duration = 3,
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.reload_speed] = 0.5,
	},
	check_proc_func = CheckProcFunctions.on_weakspot_hit,
}

return templates
