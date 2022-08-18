require("scripts/extension_systems/trigger/trigger_conditions/trigger_condition_base")

local TriggerConditionAllPlayersInside = class("TriggerConditionAllPlayersInside", "TriggerConditionBase")

TriggerConditionAllPlayersInside.init = function (self, unit, condition_name, evaluates_bots)
	TriggerConditionAllPlayersInside.super.init(self, condition_name, evaluates_bots)

	self._side_system = Managers.state.extension:system("side_system")
	self._player_side = self._side_system:get_default_player_side_name()
end

TriggerConditionAllPlayersInside.on_volume_enter = function (self, entering_unit, dt, t)
	local side_name = self._player_side

	if self:_unit_is_on_side(entering_unit, side_name) then
		local has_registered = self:register_unit(entering_unit)

		return has_registered
	end

	return false
end

TriggerConditionAllPlayersInside.on_volume_exit = function (self, exiting_unit)
	local has_unregistered = self:unregister_unit(exiting_unit)

	return has_unregistered
end

TriggerConditionAllPlayersInside.is_condition_fulfilled = function (self, volume_id)
	return self:_all_players_inside()
end

TriggerConditionAllPlayersInside._unit_is_on_side = function (self, unit, side_name)
	local side = self._side_system.side_by_unit[unit]

	return side and side:name() == side_name
end

TriggerConditionAllPlayersInside._all_players_inside = function (self)
	local side_system = self._side_system
	local side_name = self._player_side
	local side = side_system:get_side_from_name(side_name)
	local valid_player_units = side.valid_player_units
	local evaluates_bots = self._evaluates_bots
	local registered_units = self._registered_units
	local player_unit_spawn_manager = Managers.state.player_unit_spawn

	for i = 1, #valid_player_units, 1 do
		local player_unit = valid_player_units[i]
		local player = player_unit_spawn_manager:owner(player_unit)

		if player then
			local is_bot = not player:is_human_controlled()
			local should_count = (evaluates_bots and is_bot) or not is_bot

			if should_count and not registered_units[player_unit] then
				return false
			end
		end
	end

	return true
end

return TriggerConditionAllPlayersInside
