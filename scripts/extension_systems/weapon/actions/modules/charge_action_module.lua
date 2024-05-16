﻿-- chunkname: @scripts/extension_systems/weapon/actions/modules/charge_action_module.lua

local ChargeActionModule = class("ChargeActionModule")

ChargeActionModule.init = function (self, physics_world, player_unit, first_person_unit, action_module_charge_component, action_settings)
	self._physics_world = physics_world
	self._player_unit = player_unit
	self._first_person_unit = first_person_unit
	self._action_module_charge_component = action_module_charge_component
	self._action_settings = action_settings
	self._weapon_extension = ScriptUnit.extension(player_unit, "weapon_system")
	self._buff_extension = ScriptUnit.extension(player_unit, "buff_system")
end

ChargeActionModule.start = function (self, t)
	self:reset(t)
end

ChargeActionModule.reset = function (self, t, charge_duration_override)
	local action_module_charge_component = self._action_module_charge_component

	action_module_charge_component.charge_start_time = t
	action_module_charge_component.charge_level = 0
end

ChargeActionModule.fixed_update = function (self, dt, t, charge_duration_override, chained_charge_value)
	local first_person_unit = self._first_person_unit
	local action_module_charge_component = self._action_module_charge_component
	local charge_start_time = action_module_charge_component.charge_start_time

	if chained_charge_value then
		local charge_template = self._weapon_extension:charge_template()
		local stat_buffs = self._buff_extension:stat_buffs()
		local charge_duration = charge_duration_override or charge_template.charge_duration

		charge_duration = charge_duration * stat_buffs.charge_up_time

		local charge_delay = charge_template.charge_delay or 0
		local max_charge = action_module_charge_component.max_charge
		local time_charged = math.max(0, t - (charge_start_time + charge_delay))
		local min_charge = time_charged > 0 and charge_template.min_charge or 0
		local charge_time_percentage = time_charged / charge_duration
		local charge_level = math.min(math.clamp(min_charge + (1 - min_charge) * charge_time_percentage, min_charge, 1), max_charge)
		local multiplier = chained_charge_value / charge_level
		local time_since_start = t - charge_start_time
		local new_time_since_start = time_since_start * multiplier

		action_module_charge_component.charge_start_time = t - new_time_since_start
		charge_start_time = action_module_charge_component.charge_start_time
	end

	local charge_template = self._weapon_extension:charge_template()
	local stat_buffs = self._buff_extension:stat_buffs()
	local charge_duration = charge_duration_override or charge_template.charge_duration

	charge_duration = charge_duration * stat_buffs.charge_up_time

	local charge_delay = charge_template.charge_delay or 0
	local max_charge = action_module_charge_component.max_charge
	local time_charged = math.max(0, t - (charge_start_time + charge_delay))
	local min_charge = time_charged > 0 and charge_template.min_charge or 0
	local charge_time_percentage = time_charged / charge_duration
	local charge_level = math.min(math.clamp(min_charge + (1 - min_charge) * charge_time_percentage, min_charge, 1), max_charge)

	action_module_charge_component.charge_level = charge_level

	local charge_variable = Unit.animation_find_variable(first_person_unit, "charge")

	if charge_variable then
		Unit.animation_set_variable(first_person_unit, charge_variable, charge_level)
	end
end

ChargeActionModule.complete_time = function (self, charge_duration_override)
	local action_module_charge_component = self._action_module_charge_component
	local start_time = action_module_charge_component.charge_start_time
	local charge_template = self._weapon_extension:charge_template()
	local stat_buffs = self._buff_extension:stat_buffs()
	local charge_duration = charge_duration_override or charge_template.charge_duration

	charge_duration = charge_duration * stat_buffs.charge_up_time

	local complete_time = start_time + charge_duration

	return complete_time
end

local DEFAULT_RESET_CHARGE_ACTION_KINDS = {
	reload_shotgun = true,
	reload_state = true,
	unaim = true,
	unwield = true,
	unwield_to_specific = true,
	vent_warp_charge = true,
}
local DEFAULT_INTERUPT_REASONS = {
	catapulted = true,
	dead = true,
	hold_input_released = true,
	interacting = true,
	knocked_down = true,
	ledge_hanging = true,
	pounced = true,
	stunned = true,
	unwield = true,
}

ChargeActionModule.finish = function (self, reason, data, t, force_reset, ignore_reset, reset_action_kinds)
	if ignore_reset then
		return
	end

	local new_action_kind = data and data.new_action_kind

	reset_action_kinds = reset_action_kinds or DEFAULT_RESET_CHARGE_ACTION_KINDS

	local action_kind_reset = reason == "new_interrupting_action" and new_action_kind and reset_action_kinds[new_action_kind]
	local reason_reset = DEFAULT_INTERUPT_REASONS[reason]

	if force_reset or action_kind_reset or reason_reset then
		local action_module_charge_component = self._action_module_charge_component

		action_module_charge_component.charge_start_time = 0
		action_module_charge_component.charge_level = 0
	end
end

return ChargeActionModule
