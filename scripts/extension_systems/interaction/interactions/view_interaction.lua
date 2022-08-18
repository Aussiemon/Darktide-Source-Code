require("scripts/extension_systems/interaction/interactions/base_interaction")

local ViewInteraction = class("ViewInteraction", "BaseInteraction")

ViewInteraction.start = function (self, world, interactor_unit, unit_data_component, t, interactor_is_server)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(interactor_unit)
	local is_local_player = not player.remote

	if is_local_player then
		local target_unit = unit_data_component.target_unit

		fassert(target_unit, "[ViewInteraction] - Interaction target unit does not exist. Why?")

		local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")
		local ui_interaction = interactee_extension:ui_interaction()

		fassert(ui_interaction, "[ViewInteraction] - No view interaction has been defined for tamplate name: %s.", interactee_extension:interaction_type())

		local ui_manager = Managers.ui

		if not ui_manager:view_active(ui_interaction) and not ui_manager:is_view_closing(ui_interaction) then
			ui_manager:open_view(ui_interaction)
		end
	end
end

return ViewInteraction
