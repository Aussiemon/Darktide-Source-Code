local FriendInterface = require("scripts/managers/data_service/services/social/friend_interface")
local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local FriendXboxLive = class("FriendXboxLive")

FriendXboxLive.init = function (self, friend_data, is_blocked)
	self._id = friend_data.xuid
	self._name = friend_data.gamertag
	self._is_blocked = is_blocked
	self._friend_data = friend_data

	if friend_data.is_online then
		self._online_state = SocialConstants.OnlineStatus.platform_online
	else
		self._online_state = SocialConstants.OnlineStatus.offline
	end
end

FriendXboxLive.id = function (self)
	return self._id
end

FriendXboxLive.platform = function (self)
	return SocialConstants.Platforms.xbox
end

FriendXboxLive.platform_icon = function (self)
	return ""
end

FriendXboxLive.name = function (self)
	return self._name
end

FriendXboxLive.is_friend = function (self)
	return not self._is_blocked
end

FriendXboxLive.is_blocked = function (self)
	return self._is_blocked or Managers.account:is_blocked(self._id)
end

FriendXboxLive.online_status = function (self)
	return self._online_state
end

implements(FriendXboxLive, FriendInterface)

return FriendXboxLive
