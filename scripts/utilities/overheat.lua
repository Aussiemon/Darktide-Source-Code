local SharedOverheatAndWarpChargeFunctions = require("scripts/utilities/shared_overheat_and_warp_charge_functions")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local SharedFunctions = SharedOverheatAndWarpChargeFunctions
local Overheat = {}

Overheat.increase_immediate = function (t, charge_level, inventory_slot_component, charge_template, unit)
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()
	local buff_multiplier = stat_buffs and stat_buffs.overheat_amount * stat_buffs.overheat_immediate_amount or 1
	local current_percentage = inventory_slot_component.overheat_current_percentage
	local current_state = inventory_slot_component.overheat_state
	local use_charge = charge_template.use_charge
	local base_add_percentage = charge_template.overheat_percent or 0
	local add_percentage = buff_multiplier * base_add_percentage
	local new_heat, new_state = SharedFunctions.add_immediate(charge_level, use_charge, add_percentage, current_percentage)
	inventory_slot_component.overheat_last_charge_at_t = t
	inventory_slot_component.overheat_current_percentage = new_heat
	inventory_slot_component.overheat_state = new_state or current_state
end

Overheat.decrease_immediate = function (remove_percentage, inventory_slot_component)
	local current_percentage = inventory_slot_component.overheat_current_percentage
	local current_state = inventory_slot_component.overheat_state
	local new_percentage, new_state = SharedFunctions.remove_immediate(remove_percentage, current_percentage)
	inventory_slot_component.overheat_current_percentage = new_percentage
	inventory_slot_component.overheat_state = new_state or current_state
end

Overheat.increase_over_time = function (dt, t, charge_level, inventory_slot_component, charge_template, unit)
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()
	local buff_multiplier = stat_buffs and stat_buffs.overheat_amount * stat_buffs.overheat_over_time_amount or 1
	local add_percentage = buff_multiplier * charge_template.overheat_percent
	local extra_add_percentage = buff_multiplier * charge_template.extra_overheat_percent
	local duration = charge_template.charge_duration
	local current_percentage = inventory_slot_component.overheat_current_percentage
	local new_heat = SharedFunctions.increase_over_time(dt, charge_level, add_percentage, extra_add_percentage, duration, current_percentage)
	inventory_slot_component.overheat_current_percentage = new_heat
	inventory_slot_component.overheat_last_charge_at_t = t
end

Overheat.update = function (dt, t, inventory_slot_component, overheat_configuration, unit, first_person_unit)
	if not overheat_configuration then
		return
	end

	local current_percentage = inventory_slot_component.overheat_current_percentage
	local current_state = inventory_slot_component.overheat_state
	local last_charge_at_t = inventory_slot_component.overheat_last_charge_at_t
	local auto_vent_delay = overheat_configuration.auto_vent_delay
	local reload_state = inventory_slot_component.reload_state
	local reload_state_overrides = overheat_configuration.reload_state_overrides
	local reload_state_override = reload_state_overrides[reload_state]

	if reload_state_override then
		local remove_percentage = dt * reload_state_override

		Overheat.decrease_immediate(remove_percentage, inventory_slot_component)

		return
	end

	local idle = current_state == "idle"
	local start_decay_at_t = last_charge_at_t + auto_vent_delay
	local waiting_for_decay = t < start_decay_at_t
	local overheat_variable_1p = Unit.animation_find_variable(first_person_unit, "overheat")

	if overheat_variable_1p then
		Unit.animation_set_variable(first_person_unit, overheat_variable_1p, current_percentage)
	end

	local overheat_variable_3p = Unit.animation_find_variable(unit, "overheat")

	if overheat_variable_3p then
		Unit.animation_set_variable(unit, overheat_variable_3p, current_percentage)
	end

	if current_percentage <= 0 or not idle or waiting_for_decay then
		return
	end

	local low_threshold = overheat_configuration.thresholds.low
	local high_threshold = overheat_configuration.thresholds.high
	local critical_threshold = overheat_configuration.thresholds.critical
	local low_threshold_decay_rate_modifier = overheat_configuration.low_threshold_decay_rate_modifier
	local high_threshold_decay_rate_modifier = overheat_configuration.high_threshold_decay_rate_modifier
	local critical_threshold_decay_rate_modifier = overheat_configuration.critical_threshold_decay_rate_modifier
	local auto_vent_duration = overheat_configuration.auto_vent_duration
	local new_heat = SharedFunctions.update(dt, current_percentage, auto_vent_duration, low_threshold, high_threshold, critical_threshold, low_threshold_decay_rate_modifier, high_threshold_decay_rate_modifier, critical_threshold_decay_rate_modifier)
	inventory_slot_component.overheat_current_percentage = new_heat
end

Overheat.can_vent = function (inventory_slot_component)
	local overheat_state = inventory_slot_component.overheat_state
	local overheat_current_percentage = inventory_slot_component.overheat_current_percentage

	return overheat_state == "idle" and overheat_current_percentage > 0
end

Overheat.start_venting = function (t, inventory_slot_component, vent_configuration)
	local vent_interval = vent_configuration.vent_interval
	inventory_slot_component.overheat_state = "decreasing"
	inventory_slot_component.overheat_remove_at_t = t + vent_interval
	inventory_slot_component.overheat_starting_percentage = inventory_slot_component.overheat_current_percentage
end

Overheat.update_venting = function (dt, t, player, inventory_slot_component, vent_configuration)
	local remove_at_t = inventory_slot_component.overheat_remove_at_t

	if t < remove_at_t then
		return false
	end

	local current_percentage = inventory_slot_component.overheat_current_percentage
	local starting_percentage = inventory_slot_component.overheat_starting_percentage
	local player_unit = player.player_unit
	local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()
	local vent_duration = vent_configuration.vent_duration * stat_buffs.vent_overheat_speed
	local vent_interval = vent_configuration.vent_interval * stat_buffs.vent_overheat_speed
	local next_remove_t, new_percentage = SharedOverheatAndWarpChargeFunctions.update_venting(t, current_percentage, starting_percentage, vent_interval, vent_duration)
	inventory_slot_component.overheat_remove_at_t = next_remove_t
	inventory_slot_component.overheat_current_percentage = new_percentage

	return true
end

Overheat.stop_venting = function (inventory_slot_component)
	inventory_slot_component.overheat_state = "idle"
end

Overheat.clear = function (inventory_slot_component)
	inventory_slot_component.overheat_state = "idle"
	inventory_slot_component.overheat_last_charge_at_t = 0
	inventory_slot_component.overheat_remove_at_t = 0
	inventory_slot_component.overheat_current_percentage = 0
	inventory_slot_component.overheat_starting_percentage = 0
end

Overheat.slot_percentage = function (unit, slot_name, threshold_type)
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local overheat_configuration = Overheat.configuration(visual_loadout_extension, slot_name)

	if overheat_configuration then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local wieldable_component = unit_data_extension:read_component(slot_name)
		local current_overheat = wieldable_component.overheat_current_percentage
		local threshold = overheat_configuration[threshold_type]
		local percentage = current_overheat / threshold

		return percentage
	else
		return 0
	end
end

Overheat.configuration = function (visual_loadout_extension, slot_name)
	local weapon_template = visual_loadout_extension:weapon_template_from_slot(slot_name)
	local overheat_configuration = weapon_template.overheat_configuration

	return overheat_configuration
end

Overheat.wants_overheat_character_state = function (unit, unit_data_extension)
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local slot_configuration = visual_loadout_extension:slot_configuration()
	local inventory_component = unit_data_extension:read_component("inventory")

	for slot_name, config in pairs(slot_configuration) do
		if config.slot_type == "weapon" and PlayerUnitVisualLoadout.slot_equipped(inventory_component, visual_loadout_extension, slot_name) then
			local inventory_slot_component = unit_data_extension:read_component(slot_name)

			if inventory_slot_component.overheat_state == "exploding" then
				return true, slot_name
			end
		end
	end

	return false, nil
end

return Overheat
