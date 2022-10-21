require("scripts/extension_systems/interaction/interactions/base_interaction")

local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")
local ViewInteraction = class("ViewInteraction", "BaseInteraction")
local ui_view_level_requirement = {
	credits_vendor_background_view = PlayerProgressionUnlocks.credits_vendor,
	contracts_background_view = PlayerProgressionUnlocks.contracts
}

ViewInteraction.start = function (self, world, interactor_unit, unit_data_component, t, interactor_is_server)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(interactor_unit)
	local is_local_player = not player.remote

	if is_local_player then
		local target_unit = unit_data_component.target_unit
		local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")
		local ui_interaction = interactee_extension:ui_interaction()
		local ui_manager = Managers.ui

		if not ui_manager:view_active(ui_interaction) and not ui_manager:is_view_closing(ui_interaction) then
			ui_manager:open_view(ui_interaction)
		end
	end
end

ViewInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(interactor_unit)
	local player_profile = player:profile()
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
	local ui_interaction = interactee_extension:ui_interaction()
	local level_requirement = ui_view_level_requirement[ui_interaction]

	if level_requirement and player_profile.current_level < level_requirement then
		return false
	end

	return ViewInteraction.super.interactor_condition_func(self, interactor_unit, interactee_unit)
end

ViewInteraction.interactee_show_marker_func = function (self, interactor_unit, interactee_unit)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
	local ui_interaction = interactee_extension:ui_interaction()
	local ui_manager = Managers.ui

	if not ui_manager or ui_manager:view_active(ui_interaction) or ui_manager:is_view_closing(ui_interaction) then
		return false
	end

	return ViewInteraction.super.interactee_show_marker_func(self, interactor_unit, interactee_unit)
end

local block_context = {}

ViewInteraction.hud_block_text = function (self, interactor_unit, interactee_unit, interactable_actor_node_index)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(interactor_unit)
	local player_profile = player:profile()

	if player.remote then
		return false
	end

	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
	local ui_interaction = interactee_extension:ui_interaction()
	local level_requirement = ui_view_level_requirement[ui_interaction]

	if level_requirement and player_profile.current_level < level_requirement then
		table.clear(block_context)

		block_context.level = level_requirement

		return "loc_requires_level", block_context
	end

	return ViewInteraction.super.hud_block_text(self, interactor_unit, interactee_unit, interactable_actor_node_index)
end

return ViewInteraction
