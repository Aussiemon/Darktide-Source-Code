-- chunkname: @scripts/extension_systems/interaction/interactions/scanning_interaction.lua

require("scripts/extension_systems/interaction/interactions/base_interaction")

local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local ScanningInteraction = class("ScanningInteraction", "BaseInteraction")
local interaction_results = InteractionSettings.results

ScanningInteraction.start = function (self, world, interactor_unit, unit_data_component, t, interactor_is_server)
	local target_unit = unit_data_component.target_unit
	local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")
	local item = interactee_extension:interactor_item_to_equip()

	self:_unequip_slot(t, interactor_unit, "slot_device")
	PlayerUnitVisualLoadout.equip_item_to_slot(interactor_unit, item, "slot_device", nil, t)
end

ScanningInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if interactor_is_server and result == interaction_results.success then
		local target_unit = unit_data_component.target_unit
		local zone_scannable_extension = ScriptUnit.has_extension(target_unit, "mission_objective_zone_scannable_system")

		Unit.flow_event(target_unit, "lua_event_scanned")

		if zone_scannable_extension then
			local mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")
			local zone_scan_extension = mission_objective_zone_system:current_active_zone()

			if zone_scan_extension then
				local player_unit_spawn_manager = Managers.state.player_unit_spawn
				local player = player_unit_spawn_manager:owner(interactor_unit)

				zone_scan_extension:assign_scanned_object_to_player(zone_scannable_extension, player)
			end
		end
	end
end

ScanningInteraction.interactee_condition_func = function (self, interactee_unit)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
	local device_item = interactee_extension:interactor_item_to_equip()

	if device_item ~= nil then
		local mission_objective_zone_scannable_extension = ScriptUnit.has_extension(interactee_unit, "mission_objective_zone_scannable_system")

		if mission_objective_zone_scannable_extension then
			return mission_objective_zone_scannable_extension:is_active()
		end
	end

	return false
end

ScanningInteraction.interactee_show_marker_func = function (self, interactor_unit, interactee_unit)
	return self:interactee_condition_func(interactee_unit) and self:interactor_condition_func(interactor_unit, interactee_unit)
end

ScanningInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	return false
end

return ScanningInteraction
