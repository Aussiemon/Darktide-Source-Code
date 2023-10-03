require("scripts/extension_systems/interaction/interactions/base_interaction")

local MoveablePlatformQueries = require("scripts/extension_systems/moveable_platform/utilities/moveable_platform_queries")
local MoveablePlatformInteraction = class("MoveablePlatformInteraction", "BaseInteraction")

MoveablePlatformInteraction.interactee_condition_func = function (self, interactee_unit)
	local moveable_platform_extension = ScriptUnit.extension(interactee_unit, "moveable_platform_system")
	local can_interact = moveable_platform_extension:can_move()

	return can_interact
end

MoveablePlatformInteraction.hud_block_text = function (self, interactor_unit, interactee_unit, interactable_actor_node_index)
	local moveable_platform_extension = ScriptUnit.extension(interactee_unit, "moveable_platform_system")
	local extension_block_text = moveable_platform_extension:block_text()

	if extension_block_text then
		return extension_block_text
	end

	return MoveablePlatformInteraction.super.hud_block_text(self, interactor_unit, interactee_unit, interactable_actor_node_index)
end

MoveablePlatformInteraction.hud_description = function (self, interactor_unit, interactee_unit, interactable_actor_node_index)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
	local description = interactee_extension:description()

	if interactable_actor_node_index then
		local moveable_platform_extension = ScriptUnit.extension(interactee_unit, "moveable_platform_system")
		local platform_description = MoveablePlatformQueries.interaction_hud_description(moveable_platform_extension, interactable_actor_node_index)

		if platform_description and platform_description ~= "" then
			description = platform_description
		end
	end

	return description
end

MoveablePlatformInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if interactor_is_server and result == "success" then
		local target_unit = unit_data_component.target_unit
		local target_actor_node_index = unit_data_component.target_actor_node_index
		local moveable_platform_extension = ScriptUnit.extension(target_unit, "moveable_platform_system")

		if target_actor_node_index then
			MoveablePlatformQueries.activate_platform(moveable_platform_extension, target_actor_node_index)
		end
	end
end

return MoveablePlatformInteraction
