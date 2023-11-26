-- chunkname: @scripts/extension_systems/interaction/interactions/player_hub_inspect_interaction.lua

require("scripts/extension_systems/interaction/interactions/base_interaction")

local PlayerHubInspectInteraction = class("PlayerHubInspectInteraction", "BaseInteraction")

PlayerHubInspectInteraction.start = function (self, world, interactor_unit, unit_data_component, t, interactor_is_server)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local target_unit = unit_data_component.target_unit
	local player = player_unit_spawn_manager:owner(target_unit)

	if not player then
		return
	end

	local ui_manager = Managers.ui

	if ui_manager and not ui_manager:has_active_view() then
		Managers.ui:open_view("player_character_options_view", nil, nil, nil, nil, {
			is_readonly = true,
			player = player
		})
	end
end

return PlayerHubInspectInteraction
