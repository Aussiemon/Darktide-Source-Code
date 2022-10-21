local FriendInterface = require("scripts/managers/data_service/services/social/friend_interface")
local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local FriendSteam = class("FriendsSteam")

FriendSteam.init = function (self, id, app_id)
	self._id = id
	self._app_id = app_id
end

FriendSteam.id = function (self)
	return self._id
end

FriendSteam.platform = function (self)
	return "steam"
end

FriendSteam.platform_icon = function (self)
	return ""
end

FriendSteam.name = function (self)
	return Friends.name(self._id)
end

FriendSteam.is_friend = function (self)
	return Friends.relationship(self._id) == Friends.FRIEND
end

FriendSteam.is_blocked = function (self)
	return Friends.relationship(self._id) == Friends.IGNORED_FRIEND
end

FriendSteam.online_status = function (self)
	local status = Friends.status(self._id)

	if status then
		local game_info = Friends.playing_game(self._id)

		if game_info and game_info.app_id == self._app_id then
			return SocialConstants.OnlineStatus.online
		end

		if status == Friends.ONLINE or status == Friends.LOOKING_TO_PLAY then
			return SocialConstants.OnlineStatus.platform_online
		end
	end

	return SocialConstants.OnlineStatus.offline
end

implements(FriendSteam, FriendInterface)

return FriendSteam
