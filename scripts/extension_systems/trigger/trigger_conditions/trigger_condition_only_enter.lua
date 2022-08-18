require("scripts/extension_systems/trigger/trigger_conditions/trigger_condition_base")

local TriggerConditionOnlyEnter = class("TriggerConditionOnlyEnter", "TriggerConditionBase")

TriggerConditionOnlyEnter.init = function (self, unit, condition_name, evaluates_bots)
	TriggerConditionOnlyEnter.super.init(self, unit, condition_name, evaluates_bots)

	self._active = false
end

TriggerConditionOnlyEnter.on_volume_enter = function (self, entering_unit, dt, t)
	if self:_is_player(entering_unit) then
		local has_registered = self:register_unit(entering_unit)
		self._active = true

		return has_registered
	end

	return false
end

TriggerConditionOnlyEnter.on_volume_exit = function (self, exiting_unit)
	local has_unregistered = self:unregister_unit(exiting_unit)

	if has_unregistered then
		self._active = false
	end

	return has_unregistered
end

TriggerConditionOnlyEnter.is_condition_fulfilled = function (self)
	return self._active
end

TriggerConditionOnlyEnter._is_player = function (self, unit)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(unit)

	if player then
		local is_bot = not player:is_human_controlled()
		local evaluates_bots = self._evaluates_bots
		local valid_player = evaluates_bots and is_bot or not is_bot

		return valid_player
	end

	return false
end

return TriggerConditionOnlyEnter
