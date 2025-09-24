-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_prologue.lua

local GameModeBase = require("scripts/managers/game_mode/game_modes/game_mode_base")
local ProfileUtils = require("scripts/utilities/profile_utils")
local GameModePrologue = class("GameModePrologue", "GameModeBase")

local function _log(...)
	Log.info("GameModePrologue", ...)
end

GameModePrologue.init = function (self, game_mode_context, game_mode_name, network_event_delegate)
	GameModePrologue.super.init(self, game_mode_context, game_mode_name, network_event_delegate)

	local settings = self._settings

	if settings.use_prologue_profile then
		local local_player_id = 1
		local player = Managers.player:local_player(local_player_id)
		local player_profile = player:profile()
		local prologue_profile = ProfileUtils.replace_profile_for_prologue(player_profile)
		local peer_id = player:peer_id()
		local profile_synchronizer_host = Managers.profile_synchronization:synchronizer_host()

		profile_synchronizer_host:override_singleplay_profile(peer_id, local_player_id, prologue_profile)

		self._package_synchronizer_host = Managers.package_synchronization:synchronizer_host()
		self._profile_synchronizer_host = profile_synchronizer_host
		self._peer_id = peer_id
	end

	Managers.event:register(self, "mission_outro_played", "_on_mission_outro_played")
end

GameModePrologue.destroy = function (self)
	Managers.event:unregister(self, "mission_outro_played")
	GameModePrologue.super.destroy(self)

	self._package_synchronizer_host = nil
	self._profile_synchronizer_host = nil
end

GameModePrologue.evaluate_end_conditions = function (self)
	local current_state = self:state()

	if current_state == "running" then
		local completed = self._completed

		if completed then
			self:_change_state("prologue_complete")

			return true, "won"
		end
	end

	return false
end

GameModePrologue.complete = function (self, reason, triggered_from_flow)
	self._completed = true
end

GameModePrologue.game_mode_ready = function (self)
	local settings = self._settings
	local use_prologue_profile = settings.use_prologue_profile

	if use_prologue_profile then
		local peer_id = self._peer_id
		local profile_synced = not self._profile_synchronizer_host._profile_updates[peer_id] or not self._profile_synchronizer_host._profile_updates[peer_id][1]
		local packages_synced = self._package_synchronizer_host:is_peer_synced(peer_id)

		return profile_synced and packages_synced
	end

	return true
end

GameModePrologue._on_mission_outro_played = function (self)
	Log.info("GameModePrologue", ":_on_mission_outro_played")

	self.mission_outro_played = true
end

GameModePrologue.fail = function (self)
	self._failed = true
end

implements(GameModePrologue, GameModeBase.INTERFACE)

return GameModePrologue
