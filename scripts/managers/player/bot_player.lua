-- chunkname: @scripts/managers/player/bot_player.lua

require("scripts/managers/player/human_player")

local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local BotPlayer = class("BotPlayer", "HumanPlayer")

BotPlayer.init = function (self, unique_id, session_id, channel_id, peer_id, local_player_id, profile, slot, ...)
	BotPlayer.super.init(self, unique_id, session_id, channel_id, peer_id, local_player_id, profile, slot, ...)
end

BotPlayer.type = function (self)
	return "BotPlayer"
end

BotPlayer.wanted_spawn_point = function (self)
	return "bots"
end

BotPlayer.is_human_controlled = function (self)
	return false
end

BotPlayer.name = function (self)
	local display_name = self._profile.display_name or self._profile.name

	if display_name then
		return display_name
	end

	return self._debug_name
end

BotPlayer.character_id = function (self)
	return self._local_player_id
end

BotPlayer.set_profile = function (self, profile)
	self._profile = profile
	self._telemetry_subject = {
		bot = true,
		account_id = self._debug_name,
		character_id = self:local_player_id(),
	}

	Managers.event:trigger("event_player_set_profile", self, profile)
end

implements(BotPlayer, PlayerManager.PLAYER_INTERFACE)

return BotPlayer
