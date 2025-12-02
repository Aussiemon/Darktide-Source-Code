-- chunkname: @scripts/extension_systems/weapon/actions/action_block_aiming.lua

require("scripts/extension_systems/weapon/actions/action_block")

local AimAssist = require("scripts/utilities/aim_assist")
local AlternateFire = require("scripts/utilities/alternate_fire")
local ActionBlockAiming = class("ActionBlockAiming", "ActionBlock")

ActionBlockAiming.init = function (self, action_context, ...)
	ActionBlockAiming.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension

	self._spread_control_component = unit_data_extension:write_component("spread_control")
	self._sway_control_component = unit_data_extension:write_component("sway_control")
	self._sway_component = unit_data_extension:read_component("sway")
	self._alternate_fire_component = unit_data_extension:write_component("alternate_fire")
	self._action_module_charge_component = unit_data_extension:read_component("action_module_charge")
end

ActionBlockAiming.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionBlockAiming.super.start(self, action_settings, t, time_scale, action_start_params)

	if not action_settings.skip_enter_alternate_fire and not self._alternate_fire_component.is_active then
		AlternateFire.start(self._alternate_fire_component, self._weapon_tweak_templates_component, self._spread_control_component, self._sway_control_component, self._sway_component, self._movement_state_component, self._locomotion_component, self._inair_state_component, self._peeking_component, self._first_person_extension, self._animation_extension, self._weapon_extension, self._weapon_template, self._player_unit, t)
	end
end

ActionBlockAiming.running_action_state = function (self, t, time_in_action)
	if self._block_component.has_blocked then
		return "has_blocked"
	end

	return nil
end

ActionBlockAiming.finish = function (self, reason, data, t, time_in_action)
	ActionBlockAiming.super.finish(self, reason, data, t)

	local stop_alternate_fire = true

	if reason == "new_interrupting_action" then
		local new_action_kind = data.new_action_kind

		stop_alternate_fire = new_action_kind ~= "shoot" and new_action_kind ~= "shoot_pellets" and new_action_kind ~= "shoot_projectile" and new_action_kind ~= "windup"
	end

	if stop_alternate_fire then
		if self._alternate_fire_component.is_active then
			AlternateFire.stop(self._alternate_fire_component, self._peeking_component, self._first_person_extension, self._weapon_tweak_templates_component, self._animation_extension, self._weapon_template, self._player_unit, true)
		end

		AimAssist.reset_ramp_multiplier(self._aim_assist_ramp_component)
	end
end

return ActionBlockAiming
