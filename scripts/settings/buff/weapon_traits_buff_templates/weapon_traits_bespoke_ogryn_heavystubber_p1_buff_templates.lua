local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local heavystubber_fire_step = 25
local templates = {
	weapon_trait_bespoke_ogryn_heavystubber_p1_toughness_on_continuous_fire = table.merge({
		stat_buffs = {
			[stat_buffs.toughness_extra_regen_rate] = 0.1
		},
		continuous_fire_step = heavystubber_fire_step
	}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire),
	weapon_trait_bespoke_ogryn_heavystubber_p1_power_bonus_on_continuous_fire = table.merge({
		stat_buffs = {
			[stat_buffs.power_level_modifier] = 0.02
		},
		continuous_fire_step = heavystubber_fire_step
	}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire),
	weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill = table.clone(BaseWeaponTraitBuffTemplates.increase_power_on_close_kill),
	weapon_trait_bespoke_ogryn_heavystubber_p1_increased_suppression_on_continuous_fire = table.merge({
		stat_buffs = {
			[stat_buffs.increased_suppression] = 0.02
		},
		continuous_fire_step = heavystubber_fire_step
	}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire),
	weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_parent = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_ranged_power_parent),
	weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_child = table.clone(BaseWeaponTraitBuffTemplates.consecutive_hits_increases_ranged_power_child)
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_parent.child_buff_template = "weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_child"
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_parent.number_of_hits_per_stack = 10
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_movement_speed_on_continous_fire = table.merge({
	conditional_stat_buffs = {
		[stat_buffs.movement_speed] = 1.1
	},
	continuous_fire_step = heavystubber_fire_step
}, BaseWeaponTraitBuffTemplates.conditional_buff_on_continuous_fire)
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_ammo_from_reserve_on_crit = {
	number_of_ammmo_from_reserve = 5,
	force_predicted_proc = true,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_critical_strike] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local item_slot_name = template_context.item_slot_name
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")
		template_data.inventory_slot_component = unit_data_extension:write_component(item_slot_name)
	end,
	proc_func = function (params, template_data, template_context)
		local inventory_slot_component = template_data.inventory_slot_component
		local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
		local current_ammunition_reserve = inventory_slot_component.current_ammunition_reserve
		local max_ammunition_clip = inventory_slot_component.max_ammunition_clip
		local override_data = template_context.template_override_data
		local number_of_bullets_to_move = override_data and override_data.number_of_ammmo_from_reserve or template_context.template.number_of_ammmo_from_reserve
		local number_of_bullets_missing_from_clip = max_ammunition_clip - current_ammunition_clip
		number_of_bullets_to_move = math.min(number_of_bullets_to_move, number_of_bullets_missing_from_clip, current_ammunition_reserve)
		inventory_slot_component.current_ammunition_clip = current_ammunition_clip + number_of_bullets_to_move
		inventory_slot_component.current_ammunition_reserve = current_ammunition_reserve - number_of_bullets_to_move
	end
}

return templates
