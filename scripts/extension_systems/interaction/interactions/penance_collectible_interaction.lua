-- chunkname: @scripts/extension_systems/interaction/interactions/penance_collectible_interaction.lua

require("scripts/extension_systems/interaction/interactions/base_interaction")

local PenanceCollectibleInteraction = class("PenanceCollectibleInteraction", "BaseInteraction")

PenanceCollectibleInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if result == "success" then
		local interactee_unit = unit_data_component.target_unit

		if interactor_is_server then
			Managers.state.collectibles:register_collectible(interactor_unit, "collectible")
		else
			Unit.flow_event(interactee_unit, "lua_collect_penance_collectible")
			Unit.set_visibility(interactee_unit, "main", false)
		end
	end
end

PenanceCollectibleInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	local player = Managers.state.player_unit_spawn:owner(interactor_unit)
	local stat_id = player.remote and player.stat_id or player:local_player_id()
	local stat_value = Managers.stats:read_user_stat(stat_id, "collectibles_picked_up")

	if stat_value and stat_value > 0 then
		Unit.set_visibility(interactee_unit, "main", false)

		return false
	end

	return true
end

PenanceCollectibleInteraction.interactee_show_marker_func = function (self, interactor_unit, interactee_unit)
	return PenanceCollectibleInteraction:interactor_condition_func(interactor_unit, interactee_unit)
end

return PenanceCollectibleInteraction
