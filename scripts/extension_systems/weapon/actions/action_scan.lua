require("scripts/extension_systems/weapon/actions/action_weapon_base")

local AlternateFire = require("scripts/utilities/alternate_fire")
local Scanning = require("scripts/utilities/scanning")
local ActionScan = class("ActionScan", "ActionWeaponBase")

ActionScan.init = function (self, action_context, action_params, action_settings)
	ActionScan.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension
	self._scanning_compomnent = unit_data_extension:write_component("scanning")
	self._spread_control_component = unit_data_extension:write_component("spread_control")
	self._sway_control_component = unit_data_extension:write_component("sway_control")
	self._sway_component = unit_data_extension:read_component("sway")
	self._alternate_fire_component = unit_data_extension:write_component("alternate_fire")
end

ActionScan.start = function (self, action_settings, t, ...)
	ActionScan.super.start(self, action_settings, t, ...)

	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local weapon_template = self._weapon_template
	weapon_tweak_templates_component.spread_template_name = action_settings.spread_template or weapon_template.spread_template or "none"
	weapon_tweak_templates_component.recoil_template_name = action_settings.recoil_template or weapon_template.recoil_template or "none"
	weapon_tweak_templates_component.sway_template_name = action_settings.sway_template or weapon_template.sway_template or "none"
	weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or weapon_template.charge_template or "none"
	local scanning_compomnent = self._scanning_compomnent
	scanning_compomnent.is_active = true

	if not self._alternate_fire_component.is_active then
		AlternateFire.start(self._alternate_fire_component, self._weapon_tweak_templates_component, self._spread_control_component, self._sway_control_component, self._sway_component, self._movement_state_component, self._first_person_extension, self._animation_extension, self._weapon_extension, self._weapon_template, self._player_unit, t)
	end
end

ActionScan.fixed_update = function (self, dt, t, time_in_action)
	local scanning_compomnent = self._scanning_compomnent
	local scan_settings = self._action_settings.scan_settings
	local first_person_component = self._first_person_component
	local previous_unit = scanning_compomnent.scannable_unit
	local scannable_unit, line_of_sight = Scanning.find_scannable_unit(self._physics_world, first_person_component, scan_settings)
	scanning_compomnent.scannable_unit = scannable_unit
	scanning_compomnent.line_of_sight = line_of_sight

	if self._is_server then
		if previous_unit == scannable_unit and line_of_sight then
			self._scanning_time = (self._scanning_time or 0) + dt
		else
			self._scanning_time = 0
		end

		if scan_settings.outline_time < self._scanning_time and scannable_unit then
			local mission_objective_target_extension = ScriptUnit.has_extension(scannable_unit, "mission_objective_target_system")

			if mission_objective_target_extension then
				mission_objective_target_extension:add_unit_marker()
			end
		end
	end
end

ActionScan.running_action_state = function (self, t, time_in_action)
	local has_scan_zone = Scanning.has_active_scanning_zone()

	if not has_scan_zone then
		return "no_mission_zone"
	end

	return nil
end

ActionScan.finish = function (self, reason, data, t, time_in_action)
	ActionScan.super.finish(self, reason, data, t, time_in_action)

	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local weapon_template = self._weapon_template
	weapon_tweak_templates_component.spread_template_name = weapon_template.spread_template or "none"
	weapon_tweak_templates_component.sway_template_name = weapon_template.sway_template or "none"
	local scanning_compomnent = self._scanning_compomnent
	scanning_compomnent.is_active = false
	scanning_compomnent.line_of_sight = false
	scanning_compomnent.scannable_unit = nil
end

return ActionScan
