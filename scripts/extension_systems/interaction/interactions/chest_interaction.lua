-- chunkname: @scripts/extension_systems/interaction/interactions/chest_interaction.lua

require("scripts/extension_systems/interaction/interactions/base_interaction")

local ChestInteraction = class("ChestInteraction", "BaseInteraction")

ChestInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if interactor_is_server and result == "success" then
		local target_unit = unit_data_component.target_unit
		local chest_extension = ScriptUnit.extension(target_unit, "chest_system")

		chest_extension:open(interactor_unit)
	end
end

ChestInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	local chest_extension = ScriptUnit.extension(interactee_unit, "chest_system")
	local is_open = chest_extension:is_open()

	return not is_open and not self:_interactor_disabled(interactor_unit)
end

ChestInteraction.interactee_show_marker_func = function (self, interactor_unit, interactee_unit)
	return ChestInteraction:interactor_condition_func(interactor_unit, interactee_unit)
end

return ChestInteraction
