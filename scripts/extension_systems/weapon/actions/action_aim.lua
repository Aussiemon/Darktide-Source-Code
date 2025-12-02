-- chunkname: @scripts/extension_systems/weapon/actions/action_aim.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local AlternateFire = require("scripts/utilities/alternate_fire")
local ActionAim = class("ActionAim", "ActionWeaponBase")

ActionAim.init = function (self, action_context, action_params, action_settings)
	ActionAim.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._spread_control_component = unit_data_extension:write_component("spread_control")
	self._sway_control_component = unit_data_extension:write_component("sway_control")
	self._sway_component = unit_data_extension:read_component("sway")
	self._alternate_fire_component = unit_data_extension:write_component("alternate_fire")
	self._action_module_charge_component = unit_data_extension:read_component("action_module_charge")
end

ActionAim.start = function (self, action_settings, t, ...)
	ActionAim.super.start(self, action_settings, t, ...)
	AlternateFire.start(self._alternate_fire_component, self._weapon_tweak_templates_component, self._spread_control_component, self._sway_control_component, self._sway_component, self._movement_state_component, self._locomotion_component, self._inair_state_component, self._peeking_component, self._first_person_extension, self._animation_extension, self._weapon_extension, self._weapon_template, self._player_unit, t)
end

ActionAim.running_action_state = function (self, t, time_in_action)
	local action_module_charge_component = self._action_module_charge_component

	if action_module_charge_component and action_module_charge_component.charge_level > 0 then
		return "has_charge"
	end
end

return ActionAim
