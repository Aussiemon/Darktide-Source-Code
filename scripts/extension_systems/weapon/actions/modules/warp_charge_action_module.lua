local WarpCharge = require("scripts/utilities/warp_charge")
local WarpChargeActionModule = class("WarpChargeActionModule")

WarpChargeActionModule.init = function (self, player_unit, action_settings, inventory_slot_component)
	self._player_unit = player_unit
	self._action_settings = action_settings
	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	self._weapon_extension = ScriptUnit.extension(player_unit, "weapon_system")
	self._charge_component = unit_data_extension:read_component("action_module_charge")
	self._warp_charge_component = unit_data_extension:write_component("warp_charge")
	self._first_charge = false
end

WarpChargeActionModule.start = function (self, action_settings, t)
	local warp_charge_component = self._warp_charge_component

	if warp_charge_component.state == "exploding" then
		return
	end

	warp_charge_component.state = "increasing"
	self._first_charge = true
end

WarpChargeActionModule.fixed_update = function (self, dt, t)
	local charge_level = self._charge_component.charge_level
	local charge_template = self._weapon_extension:charge_template()
	local warp_charge_component = self._warp_charge_component
	local player_unit = self._player_unit

	WarpCharge.increase_over_time(dt, t, charge_level, warp_charge_component, charge_template, player_unit, self._first_charge)

	self._first_charge = false
end

WarpChargeActionModule.finish = function (self, reason, data, t)
	local warp_charge_component = self._warp_charge_component

	if warp_charge_component.state == "exploding" then
		return
	end

	warp_charge_component.state = "idle"
end

WarpChargeActionModule.running_action_state = function (self, t, time_in_action)
	local charge_level = self._charge_component.charge_level
	local current_percentage = self._warp_charge_component.current_percentage

	if current_percentage >= 0.99 then
		return "fully_charged"
	end

	if charge_level >= 1 then
		return "fully_charged"
	end

	return nil
end

return WarpChargeActionModule
