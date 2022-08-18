require("scripts/extension_systems/weapon/actions/action_weapon_base")

local Attack = require("scripts/utilities/attack/attack")
local Vo = require("scripts/utilities/vo")
local WarpCharge = require("scripts/utilities/warp_charge")
local ActionVentWarpCharge = class("ActionVentWarpCharge", "ActionWeaponBase")
local DEFAULT_WEAPON_VENT_POWER_LEVEL_MODIFIER = {
	1,
	1
}

ActionVentWarpCharge.init = function (self, action_context, action_params, action_settings)
	ActionVentWarpCharge.super.init(self, action_context, action_params, action_settings)

	self._warp_charge_component = self._unit_data_extension:write_component("warp_charge")
	self._archetype_warp_charge_template = WarpCharge.archetype_warp_charge_template(self._player)
	self._buff_extension = ScriptUnit.has_extension(self._player_unit, "buff_system")
end

local vo_threshold = 0.8

ActionVentWarpCharge.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionVentWarpCharge.super.start(self, action_settings, t, time_scale, action_start_params)
	WarpCharge.start_venting(t, self._player, self._warp_charge_component)

	local current_warp_charge = self._warp_charge_component.current_percentage

	if vo_threshold <= current_warp_charge then
		local vo_tag = action_settings.vo_tag

		if vo_tag then
			Vo.play_combat_ability_event(self._player_unit, vo_tag)
		end
	end
end

ActionVentWarpCharge.fixed_update = function (self, dt, t, time_in_action)
	WarpCharge.update_venting(dt, t, self._player, self._warp_charge_component)
end

ActionVentWarpCharge.finish = function (self, reason, data, t, time_in_action)
	WarpCharge.stop_venting(self._warp_charge_component)
end

ActionVentWarpCharge.running_action_state = function (self, t, time_in_action)
	local current_warp_charge = self._warp_charge_component.current_percentage

	if current_warp_charge <= 0 then
		return "fully_vented"
	end

	return nil
end

return ActionVentWarpCharge
