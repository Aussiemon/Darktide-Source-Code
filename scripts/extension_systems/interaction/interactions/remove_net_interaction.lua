require("scripts/extension_systems/interaction/interactions/base_interaction")

local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local Vo = require("scripts/utilities/vo")
local interaction_results = InteractionSettings.results
local RemoveNetInteraction = class("RemoveNetInteraction", "BaseInteraction")

RemoveNetInteraction.start = function (self, world, interactor_unit, unit_data_component, t, is_server)
	RemoveNetInteraction.super.start(self, world, interactor_unit, unit_data_component, t, is_server)

	local target_unit = unit_data_component.target_unit
	local vo_event = self._template.vo_event

	Vo.player_interaction_vo_event(interactor_unit, target_unit, vo_event)
end

RemoveNetInteraction.interactee_condition_func = function (self, interactee_unit)
	local unit_data_extension = ScriptUnit.extension(interactee_unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")

	return character_state_component.state_name == "netted"
end

RemoveNetInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if interactor_is_server and result == interaction_results.success then
		local target_unit = unit_data_component.target_unit
		local unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
		local assisted_state_input_component = unit_data_extension:write_component("assisted_state_input")
		assisted_state_input_component.success = true
	end
end

return RemoveNetInteraction
