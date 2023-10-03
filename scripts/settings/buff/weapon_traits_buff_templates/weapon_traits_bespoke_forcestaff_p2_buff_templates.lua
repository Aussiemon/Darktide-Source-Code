local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {
	weapon_trait_bespoke_forcestaff_p2_suppression_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.suppression_on_close_kill),
	weapon_trait_bespoke_forcestaff_p2_hipfire_while_sprinting = table.clone(BaseWeaponTraitBuffTemplates.hipfire_while_sprinting),
	weapon_trait_bespoke_forcestaff_p2_warp_charge_critical_strike_chance_bonus = table.merge({
		conditional_stat_buffs = {
			[stat_buffs.critical_strike_chance] = 0.02
		}
	}, BaseWeaponTraitBuffTemplates.warpcharge_stepped_bonus),
	weapon_trait_bespoke_forcestaff_p2_uninterruptable_while_charging = table.clone(BaseWeaponTraitBuffTemplates.uninterruptable_while_charging)
}
templates.weapon_trait_bespoke_forcestaff_p2_uninterruptable_while_charging.uninteruptable_actions = {
	action_charge_flame = true
}
templates.weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks = table.clone(BaseWeaponTraitBuffTemplates.faster_charge_on_chained_secondary_attacks)
templates.weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks.charge_actions = {
	action_charge_flame = true,
	action_shoot_charged_flame = true
}
templates.weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks_parent = table.clone(BaseWeaponTraitBuffTemplates.faster_charge_on_chained_secondary_attacks_parent)
templates.weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks_parent.child_buff_template = "weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks_child"
templates.weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks_child = table.clone(BaseWeaponTraitBuffTemplates.faster_charge_on_chained_secondary_attacks_child)
templates.weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks_parent.specific_check_proc_funcs = {
	[proc_events.on_action_start] = function (params, template_data, template_context)
		local action_settings = params.action_settings
		local name = action_settings.name

		return name and name == "action_shoot_charged_flame"
	end
}
templates.weapon_trait_bespoke_forcestaff_p2_burned_targets_receive_rending_debuff = table.clone(BaseWeaponTraitBuffTemplates.burned_targets_receive_rending_debuff)
templates.weapon_trait_bespoke_forcestaff_p2_chance_to_explode_elites_on_kill = table.merge(table.clone(BaseWeaponTraitBuffTemplates.chance_to_explode_elites_on_kill), {
	proc_data = {
		fire_buff_id = "warp_fire",
		explosion_template = ExplosionTemplates.trait_buff_forcestaff_p2_minion_explosion,
		validation_keywords = {
			keywords.warpfire_burning
		}
	}
})
templates.internal_forcestaff_p2_bonus_melee_damage_on_burninating = {
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = 20,
	duration = 5,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.melee_damage] = 0.01
	}
}
templates.weapon_trait_bespoke_forcestaff_p2_bonus_melee_damage_on_burninating = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_direct_flamer_hit] = 1
	},
	target_buff_data = {
		max_stacks = 31,
		internal_buff_name = "internal_forcestaff_p2_bonus_melee_damage_on_burninating",
		num_stacks_on_proc = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.attacked_unit_is_minion,
	start_func = function (template_data, template_context)
		local template = template_context.template
		local target_buff_data = template.target_buff_data
		local template_override_data = template_context.template_override_data
		local override_target_buff_data = template_override_data.target_buff_data
		template_data.internal_buff_name = override_target_buff_data and override_target_buff_data.internal_buff_name or target_buff_data.internal_buff_name
		template_data.num_stacks_on_proc = override_target_buff_data and override_target_buff_data.num_stacks_on_proc or target_buff_data.num_stacks_on_proc
		template_data.max_stacks = override_target_buff_data and override_target_buff_data.max_stacks or target_buff_data.max_stacks
	end,
	proc_func = function (params, template_data, template_context, t)
		local owner_unit = template_context.owner_unit

		if not HEALTH_ALIVE[owner_unit] then
			return
		end

		local buff_extension = ScriptUnit.has_extension(owner_unit, "buff_system")

		if buff_extension then
			local internal_buff_name = template_data.internal_buff_name
			local num_stacks_on_proc_func = template_context.template.num_stacks_on_proc_func
			local num_stacks_on_proc = num_stacks_on_proc_func and num_stacks_on_proc_func(t, params, template_data, template_context) or template_data.num_stacks_on_proc
			local max_stacks = template_data.max_stacks
			local current_stacks = buff_extension:current_stacks(internal_buff_name)
			local stacks_to_add = math.min(num_stacks_on_proc, math.max(max_stacks - current_stacks, 0))

			if stacks_to_add == 0 and current_stacks <= max_stacks then
				buff_extension:refresh_duration_of_stacking_buff(internal_buff_name, t)
			else
				local source_item = template_context.source_item

				buff_extension:add_internally_controlled_buff_with_stacks(internal_buff_name, stacks_to_add, t, "owner_unit", owner_unit, "source_item", source_item)
			end
		end
	end
}

return templates
