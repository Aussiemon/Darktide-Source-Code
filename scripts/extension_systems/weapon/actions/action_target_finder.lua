-- chunkname: @scripts/extension_systems/weapon/actions/action_target_finder.lua

require("scripts/extension_systems/weapon/actions/action_charge")

local ActionModules = require("scripts/extension_systems/weapon/actions/modules/action_modules")
local AlternateFire = require("scripts/utilities/alternate_fire")
local ActionTargetFinder = class("ActionTargetFinder", "ActionWeaponBase")

ActionTargetFinder.init = function (self, action_context, action_params, action_settings)
	ActionTargetFinder.super.init(self, action_context, action_params, action_settings)

	local player_unit = self._player_unit
	local unit_data_extension = action_context.unit_data_extension
	local target_finder_module_class_name = action_settings.target_finder_module_class_name
	local targeting_component = unit_data_extension:write_component("action_module_targeting")

	self._target_finder_module = ActionModules[target_finder_module_class_name]:new(self._is_server, self._physics_world, player_unit, targeting_component, action_settings)

	if action_settings.use_alternate_fire then
		self._spread_control_component = unit_data_extension:write_component("spread_control")
		self._sway_control_component = unit_data_extension:write_component("sway_control")
		self._sway_component = unit_data_extension:read_component("sway")
	end
end

ActionTargetFinder.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionTargetFinder.super.start(self, action_settings, t, time_scale, action_start_params)
	self._target_finder_module:start(t)

	local weapon_template = self._weapon_template
	local weapon_tweak_templates_component = self._weapon_tweak_templates_component

	weapon_tweak_templates_component.spread_template_name = action_settings.spread_template or weapon_template.spread_template or "none"
	weapon_tweak_templates_component.recoil_template_name = action_settings.recoil_template or weapon_template.recoil_template or "none"
	weapon_tweak_templates_component.sway_template_name = action_settings.sway_template or weapon_template.sway_template or "none"
	weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or weapon_template.charge_template or "none"

	if action_settings.use_alternate_fire then
		AlternateFire.start(self._alternate_fire_component, self._weapon_tweak_templates_component, self._spread_control_component, self._sway_control_component, self._sway_component, self._movement_state_component, self._peeking_component, self._first_person_extension, self._animation_extension, self._weapon_extension, self._weapon_template, self._player_unit, t)
	end
end

ActionTargetFinder.fixed_update = function (self, dt, t, time_in_action)
	self._target_finder_module:fixed_update(dt, t)
end

ActionTargetFinder.finish = function (self, reason, data, t, time_in_action)
	ActionTargetFinder.super.finish(self, reason, data, t, time_in_action)
	self._target_finder_module:finish(reason, data, t)

	local action_settings = self._action_settings

	if action_settings.use_alternate_fire and self._alternate_fire_component.is_active then
		local from_action_input = reason == "new_interrupting_action"

		AlternateFire.stop(self._alternate_fire_component, self._peeking_component, self._first_person_extension, self._weapon_tweak_templates_component, self._animation_extension, self._weapon_template, self._player_unit, from_action_input)
	end
end

return ActionTargetFinder
