-- chunkname: @scripts/extension_systems/interaction/interactions/player_hub_inspect_interaction.lua

require("scripts/extension_systems/interaction/interactions/ui_interaction")

local PlayerHubInspectInteraction = class("PlayerHubInspectInteraction", "UIInteraction")

PlayerHubInspectInteraction._start = function (self, interactor_unit, interactee_unit)
	local player = Managers.state.player_unit_spawn:owner(interactee_unit)

	Managers.ui:open_view("player_character_options_view", nil, nil, nil, nil, {
		is_readonly = true,
		player = player,
	})
end

PlayerHubInspectInteraction._is_blocked = function (self, interactor_unit, interactee_unit)
	local super_blocked, super_block_reason, super_block_context = PlayerHubInspectInteraction.super._is_blocked(self, interactor_unit, interactee_unit)

	if super_blocked then
		return super_blocked, super_block_reason, super_block_context
	end

	local player = Managers.state.player_unit_spawn:owner(interactee_unit)

	if not player then
		return true
	end

	return false
end

return PlayerHubInspectInteraction
