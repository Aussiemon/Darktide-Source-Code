local FriendInterface = require("scripts/managers/data_service/services/social/friend_interface")
local PresenceInterface = require("scripts/managers/presence/presence_entry")
local PresenceSettings = require("scripts/settings/presence/presence_settings")
local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local Promise = require("scripts/foundation/utilities/promise")
local PlayerInfo = class("PlayerInfo")
local OnlineStatus = SocialConstants.OnlineStatus
local PartyStatus = SocialConstants.PartyStatus
local FriendStatus = SocialConstants.FriendStatus
local Platforms = SocialConstants.Platforms

PlayerInfo.init = function (self, presence_account_id_change_callback)
	self._presence = nil
	self._platform_social = nil
	self._account_id = nil
	self._account_name = nil
	self._activity_id = nil
	self._friend_status = FriendStatus.none
	self._is_blocked = false
	self._is_party_member = false
	self._is_text_muted = false
	self._is_voice_muted = false
	self._online_status = OnlineStatus.offline
	self._last_time_played_with = nil
	self._presence_account_id_change_callback = presence_account_id_change_callback
end

PlayerInfo.destroy = function (self)
	return
end

PlayerInfo.set_account = function (self, account_id, account_name)
	if account_id ~= self._account_id or account_name ~= self._account_name then
		self._account_id = account_id
		self._account_name = account_id and account_name

		self:_update_presence()
	end
end

PlayerInfo.set_platform_social = function (self, platform_social)
	assert_interface(platform_social, FriendInterface)

	local old_platform_social = self._platform_social

	if platform_social == old_platform_social then
		return
	elseif platform_social and old_platform_social and platform_social:id() == old_platform_social:id() then
		self._platform_social = platform_social

		return
	end

	self._platform_social = platform_social

	self:_update_presence()
end

PlayerInfo.platform_social = function (self)
	return self._platform_social
end

PlayerInfo.account_id = function (self)
	local presence = self:_get_presence()

	return self._account_id or presence and presence:account_id() ~= "" and presence:account_id()
end

PlayerInfo.user_display_name = function (self)
	local presence = self:_get_presence()
	local platform_social = self._platform_social
	local name = presence and presence:platform_persona_name_or_account_name() or platform_social and platform_social:name() or self._account_name or "N/A"
	local platform_icon = self:platform_icon()

	if platform_icon then
		name = string.format("%s %s", platform_icon, name)
	end

	return name
end

PlayerInfo.platform_icon = function (self)
	local presence = self:_get_presence()
	local platform_social = self._platform_social

	return presence and presence:platform_icon() or platform_social and platform_social:platform_icon() or nil
end

PlayerInfo.online_status = function (self)
	local online_status = self._online_status
	local platform_social = self._platform_social
	local presence = self:_get_presence()

	if platform_social then
		online_status = platform_social:online_status()
	elseif presence then
		online_status = presence:is_online() and OnlineStatus.online or OnlineStatus.offline
	end

	if online_status == OnlineStatus.offline and self._is_party_member then
		online_status = OnlineStatus.reconnecting
	end

	if online_status ~= self._online_status then
		self:_update_presence()
	end

	self._online_status = online_status

	return online_status
end

PlayerInfo.is_friend = function (self)
	local platform_social = self._platform_social

	return not self._is_blocked and self._friend_status ~= FriendStatus.friend and platform_social and platform_social:is_friend() or false
end

PlayerInfo.friend_status = function (self)
	return self._friend_status
end

PlayerInfo.set_friend_status = function (self, status)
	assert(FriendStatus[status])

	self._friend_status = status
end

PlayerInfo.is_blocked = function (self)
	local platform_social = self._platform_social

	return self._is_blocked or self._friend_status == FriendStatus.ignored or platform_social and platform_social:is_blocked() or false
end

PlayerInfo.set_is_blocked = function (self, is_blocked)
	self._is_blocked = is_blocked
end

PlayerInfo.is_text_muted = function (self)
	return self._is_text_muted
end

PlayerInfo.set_is_text_muted = function (self, is_muted)
	self._is_text_muted = is_muted
end

PlayerInfo.is_voice_muted = function (self)
	return self._is_voice_muted
end

PlayerInfo.set_is_voice_muted = function (self, is_muted)
	self._is_voice_muted = is_muted
end

PlayerInfo.last_time_played_with = function (self)
	return self._last_time_played_with
end

PlayerInfo.set_last_time_played_with = function (self, time)
	self._last_time_played_with = time
end

PlayerInfo.platform = function (self)
	local platform_social = self._platform_social
	local presence = self:_get_presence()

	return platform_social and platform_social:platform() or presence and presence:platform() or "Unknown"
end

PlayerInfo.platform_user_id = function (self)
	local platform_social = self._platform_social
	local presence = self:_get_presence()

	return platform_social and platform_social:id() or presence and presence:platform_user_id() or ""
end

PlayerInfo.player_activity_id = function (self)
	local presence = self:_get_presence()

	return presence and presence:activity_id()
end

PlayerInfo.player_activity_loc_string = function (self)
	local activity_id = self:player_activity_id()

	if activity_id then
		return PresenceSettings[activity_id].hud_localization
	end

	return nil
end

PlayerInfo.character_name = function (self)
	local profile = self:profile()

	return profile and profile.name or ""
end

PlayerInfo.character_level = function (self)
	local profile = self:profile()

	return profile and profile.current_level or 0
end

PlayerInfo.is_own_player = function (self)
	return Managers.presence:presence_entry_myself():account_id() == self._account_id
end

PlayerInfo.num_party_members = function (self)
	local presence = self:_get_presence()

	return presence and presence:num_party_members() or 1
end

PlayerInfo.num_mission_members = function (self)
	local presence = self:_get_presence()

	return presence and presence:num_mission_members() or 1
end

PlayerInfo.party_status = function (self)
	local presence = self:_get_presence()
	local party_manager = Managers.party_immaterium

	if presence and party_manager then
		local account_id = self:account_id()
		local party_member = party_manager:member_from_account_id(account_id)

		if party_member and party_member:is_invited() then
			return PartyStatus.invite_pending
		elseif party_member and presence:num_party_members() > 1 then
			return PartyStatus.mine
		elseif self._is_party_member then
			return PartyStatus.same_mission
		elseif presence:num_party_members() > 1 then
			return PartyStatus.other
		end
	end

	return PartyStatus.none
end

PlayerInfo.set_is_party_member = function (self, is_member)
	self._is_party_member = is_member
end

PlayerInfo.party_id = function (self)
	local presence = self:_get_presence()

	return presence and presence:party_id()
end

PlayerInfo.peer_id = function (self)
	local presence = self:_get_presence()

	if presence then
		local account_id = self:account_id()
		local players = Managers.player:players()

		for _, player in pairs(players) do
			if player:account_id() == account_id then
				return player:peer_id()
			end
		end
	end

	return nil
end

PlayerInfo.profile = function (self)
	local presence = self:_get_presence()
	local profile = presence and presence:character_profile()

	return profile
end

PlayerInfo._update_presence = function (self)
	local platform_social = self._platform_social

	if self._account_id then
		self._presence = Managers.presence:get_presence(self._account_id)
	elseif platform_social and (platform_social:online_status() == OnlineStatus.online or platform_social:platform() == Platforms.xbox) then
		local promise = nil
		self._presence, promise = Managers.presence:get_presence_by_platform(self._platform_social:platform(), self._platform_social:id())

		promise:next(function ()
			local presence = self._presence
			local account_id = self._account_id or ""

			if presence:account_id() ~= account_id then
				self._account_id = presence:account_id()
				self._account_name = presence:account_name()

				self:_presence_account_id_change_callback()
			end
		end)
	end
end

PlayerInfo._get_presence = function (self)
	local presence = self._presence

	if presence and presence:is_alive() then
		return presence
	else
		self._presence = nil

		self:_update_presence()

		return self._presence
	end
end

return PlayerInfo
