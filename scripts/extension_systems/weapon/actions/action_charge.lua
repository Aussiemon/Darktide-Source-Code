-- chunkname: @scripts/extension_systems/weapon/actions/action_charge.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionModules = require("scripts/extension_systems/weapon/actions/modules/action_modules")
local ActionCharge = class("ActionCharge", "ActionWeaponBase")

ActionCharge.init = function (self, action_context, action_params, action_settings)
	ActionCharge.super.init(self, action_context, action_params, action_settings)

	local player_unit = self._player_unit
	local first_person_unit = self._first_person_unit
	local physics_world = self._physics_world
	local unit_data_extension = action_context.unit_data_extension
	local action_module_charge_component = unit_data_extension:write_component("action_module_charge")

	self._action_module_charge_component = action_module_charge_component
	self._charge_module = ActionModules.charge:new(physics_world, player_unit, first_person_unit, action_module_charge_component, action_settings)
	self._action_settings = action_settings

	local weapon = action_params.weapon

	self._fx_sources = weapon.fx_sources
end

ActionCharge.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionCharge.super.start(self, action_settings, t, time_scale, action_start_params)

	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local weapon_template = self._weapon_template

	weapon_tweak_templates_component.spread_template_name = action_settings.spread_template or weapon_template.spread_template or "none"
	weapon_tweak_templates_component.recoil_template_name = action_settings.recoil_template or weapon_template.recoil_template or "none"
	weapon_tweak_templates_component.sway_template_name = action_settings.sway_template or weapon_template.sway_template or "none"
	weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or weapon_template.charge_template or "none"
	self._action_module_charge_component.max_charge = 1

	local charge_template = self._weapon_extension:charge_template()
	local charge_level = self._action_module_charge_component.charge_level
	local have_charge = charge_level > 0
	local keep_charge = action_settings.keep_charge and have_charge

	if charge_template and charge_template.charge_on_action_start and not keep_charge then
		self._charge_module:start(t)
	end
end

ActionCharge.update = function (self, dt, t)
	return
end

ActionCharge.fixed_update = function (self, dt, t, time_in_action, ignore_update_charge_module)
	if not ignore_update_charge_module then
		self._charge_module:fixed_update(dt, t)
	end
end

ActionCharge.finish = function (self, reason, data, t, time_in_action)
	ActionCharge.super.finish(self, reason, data, t, time_in_action)

	local action_settings = self._action_settings
	local ignore_reset = action_settings.ignore_reset
	local reset_charge_action_kinds = action_settings.reset_charge_action_kinds

	self._charge_module:finish(reason, data, t, false, ignore_reset, reset_charge_action_kinds)

	if reason ~= "new_interrupting_action" then
		self._weapon_tweak_templates_component.spread_template_name = self._weapon_template.spread_template or "none"
	end
end

ActionCharge.running_action_state = function (self, t, time_in_action)
	local charge_level = self._action_module_charge_component.charge_level
	local charge_template = self._weapon_extension:charge_template()
	local fully_charged_charge_level = charge_template.fully_charged_charge_level or 1

	if fully_charged_charge_level <= charge_level then
		return "fully_charged"
	end

	return nil
end

return ActionCharge
