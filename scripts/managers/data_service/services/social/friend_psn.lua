-- chunkname: @scripts/managers/data_service/services/social/friend_psn.lua

local FriendInterface = require("scripts/managers/data_service/services/social/friend_interface")
local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local FriendPSN = class("FriendPSN")

FriendPSN.init = function (self, friend_data, is_blocked)
	self._friend_data = friend_data
	self._account_id = friend_data.accountId
	self._online_id = friend_data.onlineId
	self._name = self._online_id
	self._is_blocked = is_blocked
	self._playing_this_game = friend_data.inContext

	local personal_detail = friend_data.personalDetail

	if friend_data.onlineStatus == "online" or friend_data.is_online then
		self._online_state = SocialConstants.OnlineStatus.platform_online
	else
		self._online_state = SocialConstants.OnlineStatus.offline
	end
end

FriendPSN.id = function (self)
	return self._account_id
end

FriendPSN.platform = function (self)
	return SocialConstants.Platforms.psn
end

FriendPSN.platform_icon = function (self)
	return ""
end

FriendPSN.name = function (self)
	return self._name
end

FriendPSN.is_friend = function (self)
	return not self._is_blocked
end

FriendPSN.is_blocked = function (self)
	return self._is_blocked or Managers.account:is_blocked(self._account_id)
end

FriendPSN.online_status = function (self)
	return self._online_state
end

implements(FriendPSN, FriendInterface)

return FriendPSN
