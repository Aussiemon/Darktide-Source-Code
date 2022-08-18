local FriendInterface = require("scripts/managers/data_service/services/social/friend_interface")
local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local FriendXboxLive = class("FriendXboxLive")

FriendXboxLive.init = function (self, xuid, user_presence_data, name, is_blocked)
	self._id = xuid
	self._name = name
	self._is_blocked = is_blocked
	self._user_presence_data = user_presence_data
	local online_state = user_presence_data.online_state
	local title_active = user_presence_data.title_active

	if online_state == XSocialState.Online then
		if title_active then
			self._online_state = SocialConstants.OnlineStatus.online
		else
			self._online_state = SocialConstants.OnlineStatus.platform_online
		end
	elseif online_state == XSocialState.Offline then
		self._online_state = SocialConstants.OnlineStatus.offline
	elseif online_state == XSocialState.Away then
		self._online_state = SocialConstants.OnlineStatus.offline
	elseif online_state == XSocialState.Unkown then
		self._online_state = SocialConstants.OnlineStatus.offline
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
	return "\ue06c"
end

FriendXboxLive.name = function (self)
	return self._name
end

FriendXboxLive.is_friend = function (self)
	return not self._is_blocked
end

FriendXboxLive.is_blocked = function (self)
	return self._is_blocked
end

FriendXboxLive.online_status = function (self)
	return self._online_state
end

implements(FriendXboxLive, FriendInterface)

return FriendXboxLive
