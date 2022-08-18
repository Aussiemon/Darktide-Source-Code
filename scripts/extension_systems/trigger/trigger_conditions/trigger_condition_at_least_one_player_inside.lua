require("scripts/extension_systems/trigger/trigger_conditions/trigger_condition_base")

local TriggerConditionAtLeastOnePlayerInside = class("TriggerConditionAtLeastOnePlayerInside", "TriggerConditionBase")

TriggerConditionAtLeastOnePlayerInside.on_volume_enter = function (self, entering_unit, dt, t)
	if self:_is_player(entering_unit) then
		local has_registered = self:register_unit(entering_unit)

		return has_registered
	end

	return false
end

TriggerConditionAtLeastOnePlayerInside.on_volume_exit = function (self, exiting_unit)
	local has_unregistered = self:unregister_unit(exiting_unit)

	return has_unregistered
end

TriggerConditionAtLeastOnePlayerInside.is_condition_fulfilled = function (self, volume_id)
	return self:_has_players()
end

TriggerConditionAtLeastOnePlayerInside._has_players = function (self)
	return self._num_registered_units > 0
end

TriggerConditionAtLeastOnePlayerInside._is_player = function (self, unit)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(unit)

	if player then
		local is_bot = not player:is_human_controlled()
		local evaluates_bots = self._evaluates_bots
		local valid_player = (evaluates_bots and is_bot) or not is_bot

		return valid_player
	end

	return false
end

return TriggerConditionAtLeastOnePlayerInside
