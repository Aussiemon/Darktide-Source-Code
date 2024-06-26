-- chunkname: @scripts/extension_systems/interaction/interactions/ui_interaction.lua

require("scripts/extension_systems/interaction/interactions/base_interaction")

local UIInteraction = class("UIInteraction", "BaseInteraction")

UIInteraction.start = function (self, world, interactor_unit, unit_data_component, t, interactor_is_server)
	local target_unit = unit_data_component.target_unit
	local blocked = self:_is_blocked(interactor_unit, target_unit)

	if not blocked then
		self:_start(interactor_unit, target_unit)
	end

	return false
end

UIInteraction._start = function (self, interactor_unit, interactee_unit)
	return
end

UIInteraction._is_blocked = function (self, interactor_unit, interactee_unit)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(interactor_unit)
	local remote_player = player and player.remote

	if not player or remote_player then
		return true
	end

	if not Managers.ui then
		return true
	end

	local hud = Managers.ui:get_hud()
	local using_tactical_overlay = hud and hud:tactical_overlay_active()
	local has_active_view = Managers.ui:has_active_view()

	if has_active_view or using_tactical_overlay then
		return true
	end

	return false
end

UIInteraction.hud_block_text = function (self, interactor_unit, interactee_unit, target_node)
	local blocked, reason_loc_key, reason_loc_context = self:_is_blocked(interactor_unit, interactee_unit)

	if blocked then
		return reason_loc_key, reason_loc_context
	end

	return UIInteraction.super.hud_block_text(self, interactor_unit, interactee_unit, target_node)
end

UIInteraction.interactee_show_marker_func = function (self, interactor_unit, interactee_unit)
	local blocked, reason_loc_key = self:_is_blocked(interactor_unit, interactee_unit)

	if blocked and not reason_loc_key then
		return false
	end

	return UIInteraction.super.interactee_show_marker_func(self, interactor_unit, interactee_unit)
end

return UIInteraction
