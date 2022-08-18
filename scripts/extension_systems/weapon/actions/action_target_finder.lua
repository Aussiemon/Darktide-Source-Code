require("scripts/extension_systems/weapon/actions/action_charge")

local ActionModules = require("scripts/extension_systems/weapon/actions/modules/action_modules")
local ActionTargetFinder = class("ActionTargetFinder", "ActionWeaponBase")

ActionTargetFinder.init = function (self, action_context, action_params, action_settings)
	ActionTargetFinder.super.init(self, action_context, action_params, action_settings)

	local player_unit = self._player_unit
	local unit_data_extension = action_context.unit_data_extension
	local target_finder_module_class_name = action_settings.target_finder_module_class_name
	local targeting_component = unit_data_extension:write_component("action_module_targeting")
	self._targeting_module = ActionModules[target_finder_module_class_name]:new(self._physics_world, player_unit, targeting_component, action_settings)
end

ActionTargetFinder.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionTargetFinder.super.start(self, action_settings, t, time_scale, action_start_params)
	self._targeting_module:start(t)

	local weapon_template = self._weapon_template
	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	weapon_tweak_templates_component.spread_template_name = action_settings.spread_template or weapon_template.spread_template or "none"
	weapon_tweak_templates_component.recoil_template_name = action_settings.recoil_template or weapon_template.recoil_template or "none"
	weapon_tweak_templates_component.sway_template_name = action_settings.sway_template or weapon_template.sway_template or "none"
	weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or weapon_template.charge_template or "none"
end

ActionTargetFinder.fixed_update = function (self, dt, t, time_in_action)
	self._targeting_module:fixed_update(dt, t)
end

ActionTargetFinder.finish = function (self, reason, data, t, time_in_action)
	ActionTargetFinder.super.finish(self, reason, data, t, time_in_action)
	self._targeting_module:finish(reason, data, t)
end

return ActionTargetFinder
