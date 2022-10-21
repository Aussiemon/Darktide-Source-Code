require("scripts/extension_systems/weapon/actions/action_weapon_base")

local Scanning = require("scripts/utilities/scanning")
local ActionScanConfirm = class("ActionScanConfirm", "ActionWeaponBase")

ActionScanConfirm.init = function (self, action_context, action_params, action_settings)
	ActionScanConfirm.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension
	self._scanning_compomnent = unit_data_extension:write_component("scanning")
	self._fx_sources_name = self._weapon.fx_sources._speaker
end

ActionScanConfirm.start = function (self, action_settings, ...)
	ActionScanConfirm.super.start(self, action_settings, ...)

	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local weapon_template = self._weapon_template
	weapon_tweak_templates_component.spread_template_name = action_settings.spread_template or weapon_template.spread_template or "none"
	weapon_tweak_templates_component.recoil_template_name = action_settings.recoil_template or weapon_template.recoil_template or "none"
	weapon_tweak_templates_component.sway_template_name = action_settings.sway_template or weapon_template.sway_template or "none"
	weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or weapon_template.charge_template or "none"
	local scan_settings = self._action_settings.scan_settings
	local first_person_component = self._first_person_component
	local scannable_unit, line_of_sight = Scanning.find_scannable_unit(self._physics_world, first_person_component, scan_settings)
	local scanning_compomnent = self._scanning_compomnent
	scanning_compomnent.is_active = true
	scanning_compomnent.scannable_unit = scannable_unit
	scanning_compomnent.line_of_sight = line_of_sight

	if self._is_server and scannable_unit and line_of_sight then
		local mission_objective_target_extension = ScriptUnit.has_extension(scannable_unit, "mission_objective_target_system")

		if mission_objective_target_extension then
			mission_objective_target_extension:add_unit_marker()
		end
	end
end

ActionScanConfirm.fixed_update = function (self, dt, t, time_in_action)
	local scanning_compomnent = self._scanning_compomnent
	local line_of_sight_unit = self:_check_line_of_sight()

	if not line_of_sight_unit then
		scanning_compomnent.line_of_sight = false
		scanning_compomnent.scannable_unit = nil
	end
end

ActionScanConfirm.finish = function (self, reason, data, t, time_in_action)
	ActionScanConfirm.super.finish(self, reason, data, t, time_in_action)

	local completed_scanning = self:_completed_scanning(t, time_in_action)

	if completed_scanning then
		self:_bank_scannable_unit()
	end

	local scanning_compomnent = self._scanning_compomnent
	scanning_compomnent.is_active = false
	scanning_compomnent.line_of_sight = false
	scanning_compomnent.scannable_unit = nil
end

ActionScanConfirm.running_action_state = function (self, t, time_in_action)
	local has_scan_zone = Scanning.has_active_scanning_zone()

	if not has_scan_zone then
		return "no_mission_zone"
	end

	local has_valid_target = self:_has_valid_target()
	local action_settings = self._action_settings
	local scan_settings = action_settings.scan_settings
	local done_time = has_valid_target and scan_settings.confirm_time or scan_settings.fail_time_time
	local enough_time = done_time < time_in_action

	if enough_time then
		return "stop_scanning"
	end

	return nil
end

ActionScanConfirm._check_line_of_sight = function (self)
	local scan_settings = self._action_settings.scan_settings
	local first_person_component = self._first_person_component
	local scanning_compomnent = self._scanning_compomnent
	local scanning_unit = scanning_compomnent.scannable_unit

	if not scanning_unit then
		return false
	end

	local mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")
	local current_scan_mission_zone = mission_objective_zone_system:current_active_zone()

	if current_scan_mission_zone then
		local line_of_sight = Scanning.check_line_of_sight_to_unit(self._physics_world, first_person_component, scanning_unit, scan_settings)

		return line_of_sight
	end

	return false
end

ActionScanConfirm._bank_scannable_unit = function (self)
	local scanning_compomnent = self._scanning_compomnent

	if self._is_server then
		local mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")
		local current_scan_mission_zone = mission_objective_zone_system:current_active_zone()
		local scannable_unit = scanning_compomnent.scannable_unit

		if scannable_unit and current_scan_mission_zone then
			local player = self._player
			local scannable_extension = ScriptUnit.has_extension(scannable_unit, "mission_objective_zone_scannable_system")

			if scannable_extension and player and scannable_extension:is_active() then
				current_scan_mission_zone:assign_scanned_object_to_player_and_bank(scannable_extension, player)
			end
		end

		local mission_objective_target_extension = ScriptUnit.has_extension(scannable_unit, "mission_objective_target_system")

		if mission_objective_target_extension then
			mission_objective_target_extension:remove_unit_marker()
		end
	end

	local sync_to_clients = true
	local include_client = false

	self._fx_extension:trigger_gear_wwise_event_with_source("sfx_scanning_sucess", nil, self._fx_sources_name, sync_to_clients, include_client)

	scanning_compomnent.is_active = false
	scanning_compomnent.line_of_sight = false
	scanning_compomnent.scannable_unit = nil
end

ActionScanConfirm._has_valid_target = function (self)
	local scanning_compomnent = self._scanning_compomnent
	local scan_unit = scanning_compomnent.scannable_unit
	local in_line_of_sight = scanning_compomnent.line_of_sight
	local scannable_extension = ALIVE[scan_unit] and ScriptUnit.has_extension(scan_unit, "mission_objective_zone_scannable_system")
	local is_active = scannable_extension and scannable_extension:is_active()

	return is_active and in_line_of_sight
end

ActionScanConfirm._completed_scanning = function (self, t, time_in_action)
	local has_valid_target = self:_has_valid_target()
	local confirm_time = self._action_settings.scan_settings.confirm_time
	local enough_time = confirm_time < time_in_action

	return enough_time and has_valid_target
end

return ActionScanConfirm
