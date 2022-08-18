require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_base")

local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local STATES = WwiseGameSyncSettings.state_groups.sfx_combat
local WwiseStateGroupEffects = class("WwiseStateGroupEffects", "WwiseStateGroupBase")

WwiseStateGroupEffects.init = function (self, wwise_world, wwise_state_group_name)
	WwiseStateGroupEffects.super.init(self, wwise_world, wwise_state_group_name)
end

WwiseStateGroupEffects.update = function (self, dt, t)
	WwiseStateGroupEffects.super.update(self)

	local player_unit = self._player_unit

	if not player_unit or not ALIVE[player_unit] then
		return
	end

	local wwise_state = self:_wwise_state()

	self:_set_wwise_state(wwise_state)
end

WwiseStateGroupEffects.set_followed_player_unit = function (self, player_unit)
	if player_unit then
		self._player_unit = player_unit
		self._music_parameter_extension = ScriptUnit.extension(player_unit, "music_parameter_system")
	else
		self._player_unit = nil
		self._music_parameter_extension = nil
	end
end

WwiseStateGroupEffects._wwise_state = function (self)
	local music_parameter_extension = self._music_parameter_extension
	local intensity_percent = music_parameter_extension:intensity_percent()

	if music_parameter_extension:boss_near() then
		return STATES.boss
	elseif music_parameter_extension:ambush_horde_near() then
		return STATES.horde
	elseif music_parameter_extension:vector_horde_near() then
		return STATES.horde
	elseif intensity_percent > 0 then
		return STATES.normal
	end

	return STATES.none
end

return WwiseStateGroupEffects
