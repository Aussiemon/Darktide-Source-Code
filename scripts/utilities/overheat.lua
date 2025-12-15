-- chunkname: @scripts/utilities/overheat.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local SharedOverheatAndWarpChargeFunctions = require("scripts/utilities/shared_overheat_and_warp_charge_functions")
local buff_keywords = BuffSettings.keywords
local SharedFunctions = SharedOverheatAndWarpChargeFunctions
local Overheat = {}

local function _try_enter_lockout(unit, new_heat, inventory_slot_component)
	if new_heat >= 1 then
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local overheat_configuration = Overheat.configuration(visual_loadout_extension, inventory_slot_component.__name)

		if overheat_configuration.lockout_enabled and inventory_slot_component.overheat_state ~= "exploding" then
			local buff_extension = ScriptUnit.extension(unit, "buff_system")
			local use_overheat_soft_lockout = buff_extension:has_keyword(buff_keywords.use_overheat_soft_lockout)

			if use_overheat_soft_lockout then
				Overheat.track_heat_change(inventory_slot_component, "soft_lockout", "_try_enter_lockout")

				inventory_slot_component.overheat_state = "soft_lockout"
			else
				Overheat.track_heat_change(inventory_slot_component, "lockout", "_try_enter_lockout")

				inventory_slot_component.overheat_state = "lockout"
			end
		end
	end
end

Overheat.increase_immediate = function (t, charge_level, inventory_slot_component, charge_template, unit, is_critical_strike)
	local current_state = inventory_slot_component.overheat_state

	if current_state == "lockout" or current_state == "soft_lockout" then
		return
	end

	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()
	local buff_multiplier = stat_buffs and stat_buffs.overheat_amount * stat_buffs.overheat_immediate_amount or 1

	if is_critical_strike and stat_buffs then
		buff_multiplier = buff_multiplier * (stat_buffs.overheat_immediate_amount_critical_strike or 1)
	end

	local current_percentage = inventory_slot_component.overheat_current_percentage
	local use_charge = charge_template.use_charge
	local base_add_percentage = charge_template.overheat_percent or 0
	local add_percentage = buff_multiplier * base_add_percentage
	local new_heat, new_state = SharedFunctions.add_immediate(charge_level, use_charge, add_percentage, current_percentage, false, charge_template, inventory_slot_component)

	inventory_slot_component.overheat_last_charge_at_t = t
	inventory_slot_component.overheat_current_percentage = new_heat

	if new_state and current_state ~= new_state then
		Overheat.track_heat_change(inventory_slot_component, new_state, "Overheat.increase_immediate")
	end

	inventory_slot_component.overheat_state = new_state or current_state

	_try_enter_lockout(unit, new_heat, inventory_slot_component)
end

Overheat.decrease_immediate = function (remove_percentage, inventory_slot_component)
	local current_percentage = inventory_slot_component.overheat_current_percentage
	local current_state = inventory_slot_component.overheat_state
	local new_percentage, new_state = SharedFunctions.remove_immediate(remove_percentage, current_percentage)

	inventory_slot_component.overheat_current_percentage = new_percentage

	if inventory_slot_component.overheat_state ~= "lockout" or new_percentage ~= 0 then
		return
	end

	if current_state ~= new_state then
		Overheat.track_heat_change(inventory_slot_component, new_state, "Overheat.decrease_immediate")
	end

	inventory_slot_component.overheat_state = new_state or current_state
end

Overheat.increase_over_time = function (dt, t, charge_level, inventory_slot_component, charge_template, unit)
	if inventory_slot_component.overheat_state == "lockout" then
		return
	end

	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()
	local buff_multiplier = stat_buffs and stat_buffs.overheat_amount * stat_buffs.overheat_over_time_amount or 1
	local add_percentage = buff_multiplier * charge_template.overheat_percent
	local full_charge_add_percentage = buff_multiplier * charge_template.full_charge_overheat_percent
	local duration = charge_template.charge_duration
	local current_percentage = inventory_slot_component.overheat_current_percentage
	local new_heat = SharedFunctions.increase_over_time(dt, charge_level, add_percentage, full_charge_add_percentage, duration, current_percentage)

	inventory_slot_component.overheat_current_percentage = new_heat
	inventory_slot_component.overheat_last_charge_at_t = t

	_try_enter_lockout(unit, new_heat, inventory_slot_component)
end

Overheat.update = function (dt, t, inventory_slot_component, weapon_template, unit, first_person_unit, charge_weapon_tweak_templates)
	local overheat_decay

	if weapon_template.use_special_charge_template_for_overheat_decay then
		overheat_decay = charge_weapon_tweak_templates[weapon_template.special_charge_template].overheat_decay
	else
		overheat_decay = weapon_template.overheat_configuration
	end

	if not overheat_decay then
		return
	end

	local current_percentage = inventory_slot_component.overheat_current_percentage
	local current_state = inventory_slot_component.overheat_state
	local last_charge_at_t = inventory_slot_component.overheat_last_charge_at_t
	local auto_vent_delay = overheat_decay.auto_vent_delay
	local reload_state = inventory_slot_component.reload_state

	if reload_state ~= "none" then
		local reload_state_overrides = overheat_decay.reload_state_overrides
		local reload_state_override = reload_state_overrides[reload_state]

		if reload_state_override then
			local remove_percentage = dt * reload_state_override

			Overheat.decrease_immediate(remove_percentage, inventory_slot_component)

			return
		end
	end

	local idle = current_state == "idle" or current_state == "lockout"
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

	local low_threshold = overheat_decay.thresholds.low
	local high_threshold = overheat_decay.thresholds.high
	local critical_threshold = overheat_decay.thresholds.critical
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()
	local overheat_dissipation_multiplier = stat_buffs.overheat_dissipation_multiplier or 1
	local low_threshold_decay_rate_modifier = overheat_decay.low_threshold_decay_rate_modifier * overheat_dissipation_multiplier
	local high_threshold_decay_rate_modifier = overheat_decay.high_threshold_decay_rate_modifier * overheat_dissipation_multiplier
	local critical_threshold_decay_rate_modifier = overheat_decay.critical_threshold_decay_rate_modifier * overheat_dissipation_multiplier
	local auto_vent_duration = overheat_decay.auto_vent_duration
	local new_heat = SharedFunctions.update(dt, current_percentage, auto_vent_duration, low_threshold, high_threshold, critical_threshold, low_threshold_decay_rate_modifier, high_threshold_decay_rate_modifier, critical_threshold_decay_rate_modifier)

	inventory_slot_component.overheat_current_percentage = new_heat

	if inventory_slot_component.overheat_state == "lockout" and new_heat == 0 then
		Overheat.track_heat_change(inventory_slot_component, "idle", "Overheat.update")

		inventory_slot_component.overheat_state = "idle"
	end
end

Overheat.can_vent = function (inventory_slot_component)
	local overheat_state = inventory_slot_component.overheat_state
	local overheat_current_percentage = inventory_slot_component.overheat_current_percentage

	return overheat_state == "idle" and overheat_current_percentage > 0
end

Overheat.start_venting = function (t, inventory_slot_component, vent_configuration)
	local vent_interval = vent_configuration.vent_interval

	Overheat.track_heat_change(inventory_slot_component, "decreasing", "Overheat.start_venting")

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
	local buff_vent_speed = stat_buffs.vent_overheat_speed or 1
	local vent_duration = vent_configuration.vent_duration * buff_vent_speed
	local vent_interval = vent_configuration.vent_interval * buff_vent_speed
	local fixed_starting_percentage = vent_configuration.fixed_starting_percentage or starting_percentage
	local next_remove_t, new_percentage = SharedOverheatAndWarpChargeFunctions.update_venting(t, current_percentage, fixed_starting_percentage, vent_interval, vent_duration)

	inventory_slot_component.overheat_remove_at_t = next_remove_t
	inventory_slot_component.overheat_current_percentage = new_percentage

	return true
end

Overheat.stop_venting = function (inventory_slot_component)
	Overheat.track_heat_change(inventory_slot_component, "idle", "Overheat.stop_venting")

	inventory_slot_component.overheat_state = "idle"
end

Overheat.clear = function (inventory_slot_component)
	Overheat.track_heat_change(inventory_slot_component, "idle", "Overheat.clear")

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
		local inventory_slot_component = unit_data_extension:read_component(slot_name)
		local current_overheat = inventory_slot_component.overheat_current_percentage
		local threshold = overheat_configuration[threshold_type]
		local percentage = current_overheat / threshold

		return percentage
	else
		return 0
	end
end

Overheat.configuration = function (visual_loadout_extension, slot_name)
	local weapon_template, slot = visual_loadout_extension:weapon_template_from_slot(slot_name)
	local slot_item = slot and slot.item
	local overheat_configuration = weapon_template.overheat_configuration

	return overheat_configuration
end

Overheat.wants_overheat_character_state = function (unit, unit_data_extension)
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")

	for slot_name in pairs(slot_configuration) do
		local inventory_slot_component = unit_data_extension:read_component(slot_name)

		if inventory_slot_component.overheat_state == "exploding" then
			return true, slot_name
		end
	end

	return false, nil
end

local tracks = {}
local track_index = 0
local track_size = 10

Overheat.track_heat_change = function (inventory_slot_component, to_state, source)
	track_index = math.index_wrapper(track_index + 1, track_size)

	local track = tracks[track_index]

	if not track then
		track = {
			"frame: ",
			"",
			"from state: ",
			"",
			"to state: ",
			"",
			"percentage: ",
			"",
			"source: ",
			"",
		}
		tracks[track_index] = track
	end

	local FixedFrame = require("scripts/utilities/fixed_frame")

	track[2] = FixedFrame.get_latest_fixed_frame()
	track[4] = inventory_slot_component.overheat_state
	track[6] = to_state or "no state?"
	track[8] = inventory_slot_component.overheat_current_percentage
	track[10] = source
end

Overheat.dump_heat_changes = function ()
	local dump = {}

	for i = track_index + 1, track_index + track_size do
		local track = tracks[math.index_wrapper(i, track_size)]

		if track then
			for track_i = 1, #track, 2 do
				dump[track_i] = track[track_i]
				dump[track_i + 1] = string.pad_right(tostring(track[track_i + 1]) .. ", ", 14, " ")
			end

			Log.info("OverheatDebug", table.concat(dump, ""))
		end
	end
end

return Overheat
