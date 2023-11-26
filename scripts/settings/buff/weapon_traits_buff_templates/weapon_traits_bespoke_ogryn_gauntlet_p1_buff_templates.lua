-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_ogryn_gauntlet_p1_buff_templates.lua

local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local FixedFrame = require("scripts/utilities/fixed_frame")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

templates.weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_elite_kills = table.clone(BaseWeaponTraitBuffTemplates.toughness_on_elite_kills)
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_crit_kills = table.clone(BaseWeaponTraitBuffTemplates.toughness_on_crit_kills)
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_on_continuous_fire = table.merge({
	use_combo = true,
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.02
	}
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power_parent = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_parent)
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power_parent.child_buff_template = "weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power_child"
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_child)
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_targets_receive_rending_debuff = table.clone(BaseWeaponTraitBuffTemplates.targets_receive_rending_debuff)
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_targets_receive_rending_debuff.check_proc_func = CheckProcFunctions.on_ranged_hit
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power = table.clone(BaseWeaponTraitBuffTemplates.chance_based_on_aim_time)
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power.conditional_stat_buffs = {
	[stat_buffs.power_level_modifier] = 0.05
}

templates.weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power.bonus_step_func = function (template_data, template_context)
	local alternate_fire_component = template_data.alternate_fire_component
	local action_shoot_component = template_data.action_shoot_component
	local is_aiming = alternate_fire_component.is_active
	local alternate_fire_time = alternate_fire_component.start_t
	local last_shoot_time = action_shoot_component.fire_last_t
	local check_time = math.max(alternate_fire_time, last_shoot_time)
	local t = FixedFrame.get_latest_fixed_time()

	if math.abs(t - last_shoot_time) < 0.8 then
		return template_data.old_steps
	end

	local template = template_context.template
	local override_data = template_context.template_override_data
	local time_lapsed = t - check_time
	local duration_per_stack = override_data.duration_per_stack or template.duration_per_stack

	if not is_aiming then
		return 0
	end

	local steps = math.floor(time_lapsed / duration_per_stack)

	template_data.old_steps = steps

	return steps
end

templates.weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power.min_max_step_func = function (template_data, template_context)
	return 0, 5
end

templates.weapon_trait_bespoke_ogryn_gauntlet_p1_crit_chance_bonus_on_melee_kills = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = 2,
	proc_events = {
		[proc_events.on_kill] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.ranged_critical_strike_chance] = 0.05
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(ConditionalFunctions.is_item_slot_wielded, CheckProcFunctions.on_melee_kill)
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_chained_melee_hits_increases_power_parent = {
	stacks_to_remove = 1,
	child_buff_template = "weapon_trait_bespoke_ogryn_gauntlet_p1_chained_melee_hits_increases_power_child",
	child_duration = 1.5,
	predicted = false,
	stack_offset = -1,
	max_stacks = 5,
	class_name = "weapon_trait_parent_proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_first_target_melee_hit
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_chained_melee_hits_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_power_child)

return templates
