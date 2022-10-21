local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local HumanPlayer = class("HumanPlayer")

HumanPlayer.init = function (self, unique_id, session_id, channel_id, peer_id, local_player_id, profile, slot, account_id, viewport_name, telemetry_game_session)
	self.player_unit = nil
	self.viewport_name = viewport_name
	self.owned_units = {}
	self.sensitivity = 1
	self._telemetry_game_session = telemetry_game_session

	if self:type() == "HumanPlayer" then
		self._debug_name = "Local #" .. peer_id:sub(-3, -1)
	elseif self:type() == "BotPlayer" then
		self._debug_name = string.format("Bot Player %d", local_player_id)
	end

	self._session_id = session_id
	self._unique_id = unique_id
	self._peer_id = peer_id
	self._local_player_id = local_player_id
	self._account_id = account_id
	self._cached_name = nil
	self._orientation = {
		yaw = 0,
		pitch = 0,
		roll = 0
	}
	self._game_state_object = nil
	self._slot = slot
	self._is_spectating = false
	self._spectated_by = {}

	self:set_profile(profile)
end

HumanPlayer.type = function (self)
	return "HumanPlayer"
end

HumanPlayer.set_slot = function (self, slot)
	self._slot = slot
end

HumanPlayer.slot = function (self)
	return self._slot
end

HumanPlayer.session_id = function (self)
	return self._session_id
end

HumanPlayer.connection_channel_id = function (self)
	return
end

HumanPlayer.channel_id = function (self)
	return
end

HumanPlayer.unique_id = function (self)
	return self._unique_id
end

HumanPlayer.peer_id = function (self)
	return self._peer_id
end

HumanPlayer.local_player_id = function (self)
	return self._local_player_id
end

HumanPlayer.account_id = function (self)
	return self._account_id
end

HumanPlayer.character_id = function (self)
	local profile = self._profile

	return profile and profile.character_id
end

HumanPlayer.is_human_controlled = function (self)
	return true
end

HumanPlayer.name = function (self)
	if self._profile and self._profile.name then
		return self._profile.name
	elseif HAS_STEAM then
		local cached_name = self._cached_name

		if cached_name then
			return cached_name
		end

		cached_name = Steam.user_name(Steam.user_id())
		self._cached_name = cached_name

		return cached_name
	else
		return self._debug_name
	end
end

HumanPlayer.set_profile = function (self, profile)
	self._profile = profile

	if self:type() == "HumanPlayer" then
		self._telemetry_subject = {
			account_id = self._account_id,
			character_id = self:character_id()
		}
	elseif self:type() == "BotPlayer" then
		self._telemetry_subject = {
			bot = true,
			account_id = self._debug_name,
			character_id = self:local_player_id()
		}
	end
end

HumanPlayer.profile = function (self)
	return self._profile
end

HumanPlayer.has_placeholder_profile = function (self)
	return self._account_id == PlayerManager.NO_ACCOUNT_ID or type(self:character_id()) == "number"
end

HumanPlayer.archetype_name = function (self)
	return self._profile.archetype.name
end

HumanPlayer.breed_name = function (self)
	return self._profile.archetype.breed
end

HumanPlayer.telemetry_game_session = function (self)
	return self._telemetry_game_session
end

HumanPlayer.telemetry_subject = function (self)
	return self._telemetry_subject
end

HumanPlayer.destroy = function (self)
	return
end

HumanPlayer.set_orientation = function (self, yaw, pitch, roll)
	self._orientation.yaw = math.mod_two_pi(yaw)
	self._orientation.pitch = math.mod_two_pi(pitch)
	self._orientation.roll = math.mod_two_pi(roll)
end

HumanPlayer.get_orientation = function (self)
	return self._orientation
end

HumanPlayer.unit_is_alive = function (self)
	local player_unit = self.player_unit

	return player_unit and Unit.alive(player_unit)
end

implements(HumanPlayer, PlayerManager.PLAYER_INTERFACE)

return HumanPlayer
