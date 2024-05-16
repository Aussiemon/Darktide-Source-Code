-- chunkname: @scripts/managers/player/remote_player.lua

local AuthoritativePlayerInputHandler = require("scripts/managers/player/player_game_states/authoritative_player_input_handler")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local Missions = require("scripts/settings/mission/mission_templates")
local RemotePlayer = class("RemotePlayer")

RemotePlayer.init = function (self, unique_id, session_id, channel_id, peer_id, local_player_id, profile, slot, account_id, human_controlled, is_server, telemetry_game_session, last_mission_id)
	self.player_unit = nil
	self.owned_units = {}
	self.is_server = is_server
	self.remote = true
	self._telemetry_game_session = telemetry_game_session
	self.stat_id = string.format("%s:%s", peer_id, local_player_id)
	self._unique_id = unique_id
	self._session_id = session_id
	self._connection_channel_id = channel_id
	self._session_channel_id = nil
	self._peer_id = peer_id
	self._local_player_id = local_player_id
	self._account_id = account_id
	self._slot = slot

	if last_mission_id then
		local mission_name = NetworkLookup.missions[last_mission_id]
		local mission_settings = Missions[mission_name]

		if rawget(mission_settings, "spawn_settings") then
			local spawn_settings = mission_settings.spawn_settings

			self._wanted_spawn_point = spawn_settings.next_mission
		end
	end

	if human_controlled then
		self._debug_name = "Remote #" .. peer_id:sub(-3, -1)
	else
		self._debug_name = string.format("Bot Player %d", local_player_id)
	end

	self._cached_name = nil
	self._human_controlled = human_controlled
	self._game_state_object = nil

	self:set_profile(profile)
end

RemotePlayer.set_wanted_spawn_point = function (self, wanted_spawn_point)
	self._wanted_spawn_point = wanted_spawn_point
end

RemotePlayer.wanted_spawn_point = function (self)
	return self._wanted_spawn_point
end

RemotePlayer.type = function (self)
	return "RemotePlayer"
end

RemotePlayer.set_slot = function (self, slot)
	self._slot = slot
end

RemotePlayer.slot = function (self)
	return self._slot
end

RemotePlayer.set_session_channel_id = function (self, channel_id)
	self._session_channel_id = channel_id
end

RemotePlayer.connection_channel_id = function (self)
	return self._connection_channel_id
end

RemotePlayer.channel_id = function (self)
	return self._session_channel_id
end

RemotePlayer.session_id = function (self)
	return self._session_id
end

RemotePlayer.unique_id = function (self)
	return self._unique_id
end

RemotePlayer.peer_id = function (self)
	return self._peer_id
end

RemotePlayer.local_player_id = function (self)
	return self._local_player_id
end

RemotePlayer.account_id = function (self)
	return self._account_id
end

RemotePlayer.character_id = function (self)
	return self._profile.character_id
end

RemotePlayer.character_name = function (self)
	return self._profile.name
end

RemotePlayer.is_human_controlled = function (self)
	return self._human_controlled
end

RemotePlayer.name = function (self)
	if self._profile and self._profile.name then
		return self._profile.name
	elseif HAS_STEAM and self._human_controlled then
		local cached_name = self._cached_name

		if cached_name then
			return cached_name
		end

		cached_name = Steam.user_name(self._peer_id)
		self._cached_name = cached_name

		return cached_name
	else
		return self._debug_name
	end
end

RemotePlayer.destroy = function (self)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn

	if self.is_server and player_unit_spawn_manager then
		player_unit_spawn_manager:despawn(self)
	end
end

RemotePlayer.lag_compensation_rewind_ms = function (self)
	local input_handler = self.input_handler

	if input_handler then
		return input_handler:rewind_ms()
	else
		return 0
	end
end

local MILLISECONDS_TO_SECONDS = 0.001

RemotePlayer.lag_compensation_rewind_s = function (self)
	local ms = self:lag_compensation_rewind_ms()

	return ms and ms * MILLISECONDS_TO_SECONDS or nil
end

RemotePlayer.create_input_handler = function (self, fixed_time_step)
	if self.is_server then
		self.input_handler = AuthoritativePlayerInputHandler:new(self, self.is_server, fixed_time_step)
	end
end

RemotePlayer.destroy_input_handler = function (self)
	if self.is_server then
		self.input_handler:delete()

		self.input_handler = nil
	end
end

RemotePlayer.set_profile = function (self, profile)
	self._profile = profile
	self._telemetry_subject = {
		account_id = self._account_id,
		character_id = profile.character_id,
	}
end

RemotePlayer.profile = function (self)
	return self._profile
end

RemotePlayer.archetype_name = function (self)
	return self._profile.archetype.name
end

RemotePlayer.breed_name = function (self)
	return self._profile.archetype.breed
end

RemotePlayer.telemetry_game_session = function (self)
	return self._telemetry_game_session
end

RemotePlayer.telemetry_subject = function (self)
	return self._telemetry_subject
end

RemotePlayer.unit_is_alive = function (self)
	local player_unit = self.player_unit

	return player_unit and Unit.alive(player_unit)
end

implements(RemotePlayer, PlayerManager.PLAYER_INTERFACE)

return RemotePlayer
