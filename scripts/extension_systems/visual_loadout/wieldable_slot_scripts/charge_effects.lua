local Action = require("scripts/utilities/weapon/action")
local ChargeEffects = class("ChargeEffects")

ChargeEffects.init = function (self, context, slot, weapon_template, fx_sources)
	self._wwise_world = context.wwise_world
	self._weapon_actions = weapon_template.actions
	self._fx_sources = fx_sources
	local owner_unit = context.owner_unit
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._action_module_charge_component = unit_data_extension:read_component("action_module_charge")
end

ChargeEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

ChargeEffects.update = function (self, unit, dt, t)
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local charge_effects = action_settings and action_settings.charge_effects
	local charge_sfx_parameter = charge_effects and charge_effects.sfx_parameter

	if charge_sfx_parameter == nil then
		return
	end

	local fx_source_name = charge_effects.sfx_source_name
	local source_name = self._fx_sources[fx_source_name]
	local wwise_world = self._wwise_world
	local source = self._fx_extension:sound_source(source_name)
	local action_module_charge_component = self._action_module_charge_component
	local charge_level = action_module_charge_component.charge_level
	local parameter = charge_sfx_parameter
	local parameter_value = charge_level

	WwiseWorld.set_source_parameter(wwise_world, source, parameter, parameter_value)
end

ChargeEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

ChargeEffects.wield = function (self)
	return
end

ChargeEffects.unwield = function (self)
	return
end

ChargeEffects.destroy = function (self)
	return
end

return ChargeEffects
