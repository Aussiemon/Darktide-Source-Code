-- chunkname: @scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_suppression_state.lua

require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_base")

local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local STATES = WwiseGameSyncSettings.state_groups.suppression_state
local FAST_PARAMETER_UPDATE_RATE = 1 / GameParameters.tick_rate * 4
local WwiseStateGroupSuppression = class("WwiseStateGroupSuppression", "WwiseStateGroupBase")

WwiseStateGroupSuppression.init = function (self, wwise_world, wwise_game_sync_name)
	WwiseStateGroupSuppression.super.init(self, wwise_world, wwise_game_sync_name)

	self._next_fast_parameter_update = 0
end

WwiseStateGroupSuppression.update = function (self, dt, t)
	WwiseStateGroupSuppression.super.update(self)

	local player_unit = self._player_unit

	if not player_unit or not ALIVE[player_unit] then
		return
	end

	if t > self._next_fast_parameter_update then
		local wwise_state = self:_wwise_state()

		self:_set_wwise_state(wwise_state)

		self._next_fast_parameter_update = t + FAST_PARAMETER_UPDATE_RATE
	end
end

WwiseStateGroupSuppression.set_followed_player_unit = function (self, player_unit)
	local suppression_extension = player_unit and ScriptUnit.has_extension(player_unit, "suppression_system")

	if suppression_extension then
		self._player_unit = player_unit
		self._suppression_extension = suppression_extension
	else
		self._player_unit = nil
		self._suppression_extension = nil
	end
end

WwiseStateGroupSuppression._wwise_state = function (self)
	local suppression_extension = self._suppression_extension
	local has_low_suppression = suppression_extension:has_low_suppression()
	local has_high_suppression = suppression_extension:has_high_suppression()

	if has_high_suppression then
		return STATES.high
	elseif has_low_suppression then
		return STATES.low
	end

	return STATES.none
end

return WwiseStateGroupSuppression
