require("scripts/extension_systems/interaction/interactions/base_interaction")

local DoorControlPanelInteraction = class("DoorControlPanelInteraction", "BaseInteraction")

DoorControlPanelInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if interactor_is_server and result == "success" then
		local target_unit = unit_data_component.target_unit
		local door_control_panel_extension = ScriptUnit.extension(target_unit, "door_control_panel_system")

		door_control_panel_extension:toggle_door_state(interactor_unit)
	end
end

DoorControlPanelInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	local door_control_panel_extension = ScriptUnit.extension(interactee_unit, "door_control_panel_system")
	local door_control_panel_interactable = door_control_panel_extension:is_active()

	return door_control_panel_interactable and not self:_interactor_disabled(interactor_unit)
end

return DoorControlPanelInteraction
