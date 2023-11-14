local BuffSettings = require("scripts/settings/buff/buff_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local SharedFunctions = require("scripts/utilities/shared_overheat_and_warp_charge_functions")
local buff_keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local EMPTY_TABLE = {}
local WarpCharge = {}

local function _set_current_percentage(warp_charge_component, new_percentage, buff_extension)
	local current_percentage = warp_charge_component.current_percentage
	local percentage_change = current_percentage - new_percentage

	if buff_extension and percentage_change ~= 0 then
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.percentage_change = percentage_change

			buff_extension:add_proc_event(proc_events.on_warp_charge_changed, param_table)
		end
	end

	warp_charge_component.current_percentage = new_percentage
end

WarpCharge.check_new_state = function (warp_charge_component, prevent_explosion)
	local state = warp_charge_component.state
	local starting_percentage = warp_charge_component.starting_percentage
	local current_percentage = warp_charge_component.current_percentage

	if not prevent_explosion and current_percentage >= 1 and starting_percentage >= 1 then
		return "exploding"
	end

	return state
end

WarpCharge.check_and_set_state = function (t, warp_charge_component, prevent_explosion)
	local new_state = WarpCharge.check_new_state(warp_charge_component, prevent_explosion)
	warp_charge_component.state = new_state
end

WarpCharge.start_warp_action = function (t, warp_charge_component)
	local starting_percentage = warp_charge_component.current_percentage
	warp_charge_component.starting_percentage = starting_percentage
end

WarpCharge.increase_immediate = function (t, charge_level, warp_charge_component, charge_template, owner_unit, warp_charge_modifier, prevent_explosion)
	local buff_extension = ScriptUnit.has_extension(owner_unit, "buff_system")
	local stat_buffs = buff_extension and buff_extension:stat_buffs()
	local psyker_smite = charge_template.psyker_smite
	local psyker_smite_multiplier = psyker_smite and stat_buffs and stat_buffs.psyker_smite_cost_multiplier or 1
	local buff_multiplier = stat_buffs and stat_buffs.warp_charge_amount * stat_buffs.warp_charge_immediate_amount * psyker_smite_multiplier or 1

	if charge_template.psyker_smite then
		buff_multiplier = buff_multiplier * stat_buffs.warp_charge_amount_smite
	end

	buff_multiplier = buff_multiplier * (warp_charge_modifier or 1)
	local prevent_overload = buff_extension:has_keyword(buff_keywords.psychic_fortress)
	local current_percentage = warp_charge_component.current_percentage
	local current_state = warp_charge_component.state
	local use_charge = charge_template.use_charge
	local base_add_percentage = charge_template.warp_charge_percent or 0
	local add_percentage = buff_multiplier * base_add_percentage
	local new_charge, new_state = SharedFunctions.add_immediate(charge_level, use_charge, add_percentage, current_percentage, prevent_explosion)

	_set_current_percentage(warp_charge_component, new_charge, buff_extension)

	warp_charge_component.last_charge_at_t = t
	warp_charge_component.state = new_state or current_state
end

WarpCharge.decrease_immediate = function (remove_percentage, warp_charge_component, unit)
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	local current_percentage = warp_charge_component.current_percentage
	local current_state = warp_charge_component.state
	local new_percentage, new_state = SharedFunctions.remove_immediate(remove_percentage, current_percentage)

	_set_current_percentage(warp_charge_component, new_percentage, buff_extension)

	if warp_charge_component.state == "exploding" then
		local t = FixedFrame.get_latest_fixed_time()
		local Interrupt = require("scripts/utilities/attack/interrupt")

		Interrupt.action(t, unit, "psyker_ability", nil, true)

		local player = Managers.state.player_unit_spawn:owner(unit)

		Managers.stats:record_private("hook_psyker_survived_perils", player)
	end

	warp_charge_component.state = new_state or current_state
end

WarpCharge.increase_over_time = function (dt, t, charge_level, warp_charge_component, charge_configuration, owner_unit, first_charge)
	local buff_extension = ScriptUnit.has_extension(owner_unit, "buff_system")
	local stat_buffs = buff_extension and buff_extension:stat_buffs()
	local psyker_smite = charge_configuration.psyker_smite
	local psyker_smite_multiplier = psyker_smite and stat_buffs and stat_buffs.psyker_smite_cost_multiplier or 1
	local buff_multiplier = stat_buffs and stat_buffs.warp_charge_amount * stat_buffs.warp_charge_over_time_amount * psyker_smite_multiplier or 1
	local base_add_percentage = charge_configuration.warp_charge_percent
	local add_percentage = buff_multiplier * base_add_percentage
	local base_extra_add_percentage = charge_configuration.extra_warp_charge_percent
	local extra_add_percentage = buff_multiplier * base_extra_add_percentage
	local duration = charge_configuration.charge_duration
	local current_percentage = warp_charge_component.current_percentage
	local additional_charge_on_start = charge_configuration.start_warp_charge_percent

	if first_charge and additional_charge_on_start then
		local additional_add_percentage = buff_multiplier * additional_charge_on_start
		current_percentage = SharedFunctions.add_immediate(charge_level, false, additional_add_percentage, current_percentage, true)
	end

	local new_charge = SharedFunctions.increase_over_time(dt, charge_level, add_percentage, extra_add_percentage, duration, current_percentage)

	_set_current_percentage(warp_charge_component, new_charge, buff_extension)

	warp_charge_component.last_charge_at_t = t
end

WarpCharge.update_observer = function (dt, t, player, unit, first_person_unit, wwise_world, follow_unit)
	local base_warp_charge_template = WarpCharge.archetype_warp_charge_template(player)

	if not base_warp_charge_template then
		return
	end

	if not follow_unit or not HEALTH_ALIVE[follow_unit] then
		return
	end

	local unit_data_extension = ScriptUnit.extension(follow_unit, "unit_data_system")
	local warp_charge_component = unit_data_extension:read_component("warp_charge")
	local current_percentage = warp_charge_component.current_percentage
	local warp_charge_variable_1p = Unit.animation_find_variable(first_person_unit, "warp_charge")

	if warp_charge_variable_1p then
		Unit.animation_set_variable(first_person_unit, warp_charge_variable_1p, current_percentage)
	end

	local warp_charge_variable_3p = Unit.animation_find_variable(unit, "warp_charge")

	if warp_charge_variable_3p then
		Unit.animation_set_variable(unit, warp_charge_variable_3p, current_percentage)
	end

	local options_peril_slider = Application.user_setting("interface_settings", "psyker_overload_intensity") or 100
	local parameter_value = math.min(current_percentage, options_peril_slider / 100)

	WwiseWorld.set_global_parameter(wwise_world, "psyker_overload_global", parameter_value)
end

WarpCharge.update = function (dt, t, warp_charge_component, player, unit, first_person_unit, is_local_unit, wwise_world)
	local base_warp_charge_template = WarpCharge.archetype_warp_charge_template(player)

	if not base_warp_charge_template then
		return
	end

	local player_unit = player.player_unit
	local weapon_warp_charge_template = WarpCharge.weapon_warp_charge_template(player_unit)
	local current_percentage = warp_charge_component.current_percentage
	local current_state = warp_charge_component.state
	local last_charge_at_t = warp_charge_component.last_charge_at_t
	current_percentage = math.clamp01(current_percentage)
	local base_auto_vent_delay = base_warp_charge_template.auto_vent_delay
	local auto_vent_delay_modifier = weapon_warp_charge_template.auto_vent_delay_modifier or 1
	local auto_vent_delay = base_auto_vent_delay * auto_vent_delay_modifier
	local idle = current_state == "idle"
	local start_decay_at_t = last_charge_at_t + auto_vent_delay
	local waiting_for_decay = t < start_decay_at_t
	local warp_charge_variable_1p = Unit.animation_find_variable(first_person_unit, "warp_charge")

	if warp_charge_variable_1p then
		Unit.animation_set_variable(first_person_unit, warp_charge_variable_1p, current_percentage)
	end

	local warp_charge_variable_3p = Unit.animation_find_variable(unit, "warp_charge")

	if warp_charge_variable_3p then
		Unit.animation_set_variable(unit, warp_charge_variable_3p, current_percentage)
	end

	if is_local_unit then
		local options_peril_slider = Application.user_setting("interface_settings", "psyker_overload_intensity") or 100
		local parameter_value = math.min(current_percentage, options_peril_slider / 100)

		WwiseWorld.set_global_parameter(wwise_world, "psyker_overload_global", parameter_value)
	end

	if current_percentage <= 0 or not idle or waiting_for_decay then
		return
	end

	local low_threshold, high_threshold, critical_threshold = WarpCharge.thresholds(player, warp_charge_component)
	local base_low_threshold_decay_rate = base_warp_charge_template.low_threshold_decay_rate
	local base_high_threshold_decay_rate = base_warp_charge_template.high_threshold_decay_rate
	local base_critical_threshold_decay_rate = base_warp_charge_template.critical_threshold_decay_rate
	local low_threshold_decay_rate_modifier = weapon_warp_charge_template.low_threshold_decay_rate_modifier or 1
	local high_threshold_decay_rate_modifier = weapon_warp_charge_template.high_threshold_decay_rate_modifier or 1
	local critical_threshold_decay_rate_modifier = weapon_warp_charge_template.critical_threshold_decay_rate_modifier or 1
	local default_threshold_decay_rate_modifier = weapon_warp_charge_template.default_threshold_decay_rate_modifier or 1
	local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()
	local warp_charge_dissipation_multiplier = stat_buffs.warp_charge_dissipation_multiplier
	local low_threshold_decay_rate = base_low_threshold_decay_rate * low_threshold_decay_rate_modifier * warp_charge_dissipation_multiplier
	local high_threshold_decay_rate = base_high_threshold_decay_rate * high_threshold_decay_rate_modifier * warp_charge_dissipation_multiplier
	local critical_threshold_decay_rate = base_critical_threshold_decay_rate * critical_threshold_decay_rate_modifier * warp_charge_dissipation_multiplier
	local base_auto_vent_duration = base_warp_charge_template.auto_vent_duration
	local auto_vent_duration_modifier = weapon_warp_charge_template.auto_vent_duration_modifier or 0.75
	local auto_vent_duration = base_auto_vent_duration * auto_vent_duration_modifier
	local new_charge = SharedFunctions.update(dt, current_percentage, auto_vent_duration, low_threshold, high_threshold, critical_threshold, low_threshold_decay_rate, high_threshold_decay_rate, critical_threshold_decay_rate, default_threshold_decay_rate_modifier)

	_set_current_percentage(warp_charge_component, new_charge, buff_extension)
end

WarpCharge.can_vent = function (warp_charge_component, action_settings)
	local warp_charge_state = warp_charge_component.state
	local warp_charge_current_percentage = warp_charge_component.current_percentage
	local new_state = WarpCharge.check_new_state(warp_charge_component)
	local will_explode = action_settings and action_settings.delay_explosion_to_finish and new_state == "exploding"

	return warp_charge_state ~= "exploding" and warp_charge_current_percentage > 0 and not will_explode
end

WarpCharge.start_venting = function (t, player, warp_charge_component)
	local base_warp_charge_template = WarpCharge.archetype_warp_charge_template(player)

	if not base_warp_charge_template then
		return
	end

	if warp_charge_component.state == "exploding" then
		return
	end

	local weapon_warp_charge_template = WarpCharge.weapon_warp_charge_template(player.player_unit)
	local base_vent_interval = base_warp_charge_template.vent_interval
	local vent_interval_modifier = weapon_warp_charge_template.vent_interval_modifier or 1
	local vent_interval = base_vent_interval * vent_interval_modifier
	warp_charge_component.state = "decreasing"
	warp_charge_component.remove_at_t = t + vent_interval
	warp_charge_component.starting_percentage = warp_charge_component.current_percentage
	warp_charge_component.ramping_modifier = 1
end

WarpCharge.update_venting = function (dt, t, player, warp_charge_component)
	local remove_at_t = warp_charge_component.remove_at_t

	if t < remove_at_t then
		return false
	end

	local base_warp_charge_template = WarpCharge.archetype_warp_charge_template(player)

	if not base_warp_charge_template then
		return
	end

	local player_unit = player.player_unit
	local weapon_warp_charge_template = WarpCharge.weapon_warp_charge_template(player.player_unit)
	local current_percentage = warp_charge_component.current_percentage
	local starting_percentage = warp_charge_component.starting_percentage
	local min_vent_time_fraction = base_warp_charge_template.min_vent_time_fraction
	local base_vent_duration = base_warp_charge_template.vent_duration
	base_vent_duration = base_vent_duration * min_vent_time_fraction + base_vent_duration * (1 - min_vent_time_fraction) * starting_percentage
	local base_vent_interval = base_warp_charge_template.vent_interval
	local base_ramping_interval_modifier = base_warp_charge_template.ramping_interval_modifier
	local new_ramping_modifier = warp_charge_component.ramping_modifier * base_ramping_interval_modifier
	local vent_duration_modifier = weapon_warp_charge_template.vent_duration_modifier or 1
	local vent_interval_modifier = weapon_warp_charge_template.vent_interval_modifier or 1
	local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()
	local buff_vent_speed = stat_buffs.vent_warp_charge_speed or 1
	local vent_duration = base_vent_duration * vent_duration_modifier * new_ramping_modifier * buff_vent_speed
	local vent_interval = base_vent_interval * vent_interval_modifier * new_ramping_modifier * buff_vent_speed
	local multiplier = stat_buffs.vent_warp_charge_multiplier
	local next_remove_t, new_percentage = SharedFunctions.update_venting(t, current_percentage, starting_percentage, vent_interval, vent_duration, multiplier)

	_set_current_percentage(warp_charge_component, new_percentage, buff_extension)

	warp_charge_component.remove_at_t = next_remove_t
	warp_charge_component.ramping_modifier = new_ramping_modifier
	local no_damage = weapon_warp_charge_template.no_damage

	Managers.event:trigger("on_vent", player)

	if no_damage then
		return false
	else
		return true
	end
end

WarpCharge.stop_venting = function (warp_charge_component)
	if warp_charge_component.state == "exploding" then
		return
	end

	warp_charge_component.state = "idle"
end

WarpCharge.clear = function (warp_charge_component)
	warp_charge_component.state = "idle"
	warp_charge_component.last_charge_at_t = 0
	warp_charge_component.remove_at_t = 0
	warp_charge_component.starting_percentage = 0
	warp_charge_component.ramping_modifier = 0

	_set_current_percentage(warp_charge_component, 0)
end

WarpCharge.archetype_warp_charge_template = function (player)
	local profile = player:profile()
	local archetype = profile.archetype
	local warp_charge_template = archetype.warp_charge

	return warp_charge_template
end

WarpCharge.weapon_warp_charge_template = function (player_unit)
	local weapon_extension = ScriptUnit.has_extension(player_unit, "weapon_system")
	local charge_template = weapon_extension and weapon_extension:warp_charge_template()

	return charge_template or EMPTY_TABLE
end

WarpCharge.wants_warp_charge_character_state = function (unit, unit_data_extension)
	local warp_charge_component = unit_data_extension:read_component("warp_charge")

	return warp_charge_component.state == "exploding"
end

WarpCharge.thresholds = function (player, warp_charge_component)
	local base_warp_charge_template = WarpCharge.archetype_warp_charge_template(player)

	if not base_warp_charge_template then
		return 0, 0, 0
	end

	local weapon_warp_charge_template = WarpCharge.weapon_warp_charge_template(player.player_unit)
	local base_low_threshold = base_warp_charge_template.low_threshold
	local base_high_threshold = base_warp_charge_template.high_threshold
	local base_critical_threshold = base_warp_charge_template.critical_threshold
	local low_threshold_modifier = weapon_warp_charge_template.low_threshold_modifier or 1
	local high_threshold_modifier = weapon_warp_charge_template.high_threshold_modifier or 1
	local critical_threshold_modifier = weapon_warp_charge_template.critical_threshold_modifier or 1
	local low_threshold = base_low_threshold * low_threshold_modifier
	local high_threshold = base_high_threshold * high_threshold_modifier
	local critical_threshold = base_critical_threshold * critical_threshold_modifier

	return low_threshold, high_threshold, critical_threshold
end

return WarpCharge
