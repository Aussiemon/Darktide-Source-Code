require("scripts/extension_systems/interaction/interactions/base_interaction")

local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local ServoSkullActivatorInteraction = class("ServoSkullActivatorInteraction", "BaseInteraction")
local interaction_results = InteractionSettings.results

ServoSkullActivatorInteraction.start = function (self, world, interactor_unit, unit_data_component, t, interactor_is_server)
	if interactor_is_server then
		local unit_data_extension = ScriptUnit.extension(interactor_unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")
		local visual_loadout_extension = ScriptUnit.extension(interactor_unit, "visual_loadout_system")
		local target_unit = unit_data_component.target_unit
		local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")
		local item = interactee_extension:interactor_item_to_equip()

		if PlayerUnitVisualLoadout.slot_equipped(inventory_component, visual_loadout_extension, "slot_device") then
			PlayerUnitVisualLoadout.unequip_item_from_slot(interactor_unit, "slot_device", t)
		end

		PlayerUnitVisualLoadout.equip_item_to_slot(interactor_unit, item, "slot_device", nil, t)
	end
end

ServoSkullActivatorInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if result == interaction_results.success then
		local target_unit = unit_data_component.target_unit

		if interactor_is_server then
			local target_unit_position = Unit.local_position(target_unit, 1)
			local target_unit_rotation = Unit.local_rotation(target_unit, 1)
			local unit_data_extension = ScriptUnit.has_extension(interactor_unit, "unit_data_system")

			if unit_data_extension then
				local first_person_component = unit_data_extension:read_component("first_person")
				local first_person_position = first_person_component.position
				local first_person_rotation = first_person_component.rotation
				target_unit_position = first_person_position + Vector3.up() * 0.5
				target_unit_rotation = first_person_rotation
			end

			local mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")
			local servo_skull_activator_extension = ScriptUnit.extension(target_unit, "servo_skull_system")
			local objective_name = servo_skull_activator_extension:objective_name()

			mission_objective_zone_system:spawn_servo_skull(target_unit_position, target_unit_rotation)
			mission_objective_zone_system:start_event(objective_name)
			servo_skull_activator_extension:deactivate()
		end
	end
end

return ServoSkullActivatorInteraction
