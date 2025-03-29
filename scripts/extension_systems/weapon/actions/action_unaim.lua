-- chunkname: @scripts/extension_systems/weapon/actions/action_unaim.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local AimAssist = require("scripts/utilities/aim_assist")
local AlternateFire = require("scripts/utilities/alternate_fire")
local ActionUnaim = class("ActionUnaim", "ActionWeaponBase")

ActionUnaim.init = function (self, action_context, action_params, action_settings)
	ActionUnaim.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._spread_control_component = unit_data_extension:write_component("spread_control")
	self._sway_control_component = unit_data_extension:write_component("sway_control")
	self._aim_assist_ramp_component = unit_data_extension:write_component("aim_assist_ramp")
end

ActionUnaim.start = function (self, action_settings, t, ...)
	ActionUnaim.super.start(self, action_settings, t, ...)

	if self._alternate_fire_component.is_active then
		AlternateFire.stop(self._alternate_fire_component, self._peeking_component, self._first_person_extension, self._weapon_tweak_templates_component, self._animation_extension, self._weapon_template, self._player_unit, true)
	end
end

ActionUnaim.finish = function (self, reason, data, t, time_in_action)
	AimAssist.reset_ramp_multiplier(self._aim_assist_ramp_component)
end

return ActionUnaim
