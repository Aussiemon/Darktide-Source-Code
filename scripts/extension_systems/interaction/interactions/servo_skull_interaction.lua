-- chunkname: @scripts/extension_systems/interaction/interactions/servo_skull_interaction.lua

require("scripts/extension_systems/interaction/interactions/base_interaction")

local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local ServoSkullInteraction = class("ServoSkullInteraction", "BaseInteraction")
local interaction_results = InteractionSettings.results

local function _get_zone(skull_unit)
	local mission_target_extension = ScriptUnit.extension(skull_unit, "mission_objective_target_system")
	local objective_name = mission_target_extension:objective_name()
	local group_id = mission_target_extension:objective_group_id()
	local mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")

	return mission_objective_zone_system:current_active_zone(objective_name, group_id)
end

ServoSkullInteraction.start = function (self, world, interactor_unit, unit_data_component, t, interactor_is_server)
	local target_unit = unit_data_component.target_unit
	local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")
	local item = interactee_extension:interactor_item_to_equip()

	if interactor_is_server then
		local zone_scan_extension = _get_zone(target_unit)

		zone_scan_extension:reset_vo_timer()
	end
end

ServoSkullInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if result == interaction_results.success then
		local zone_scan_extension = _get_zone(unit_data_component.target_unit)

		zone_scan_extension:zone_finished()

		local target_extension = ScriptUnit.extension(unit_data_component.target_unit, "mission_objective_target_system")
		local objective_name = target_extension:objective_name()
		local objective_group = target_extension:objective_group_id()
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")
		local objective = mission_objective_system:active_objective(objective_name, objective_group)

		objective:stage_done()
	end
end

ServoSkullInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	if not PlayerUnitStatus.can_interact_with_objective(interactor_unit) then
		return false
	end

	local zone_scan_extension = _get_zone(interactee_unit)

	if zone_scan_extension then
		local is_waiting_for_player_confirmation = zone_scan_extension:is_waiting_for_player_confirmation()

		return is_waiting_for_player_confirmation
	end

	return false
end

ServoSkullInteraction.interactee_show_marker_func = function (self, interactor_unit, interactee_unit)
	return self:interactor_condition_func(interactor_unit, interactee_unit)
end

return ServoSkullInteraction
