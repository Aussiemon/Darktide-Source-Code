-- chunkname: @scripts/managers/data_service/services/social/friends_dummy.lua

local FriendsInterface = require("scripts/managers/data_service/services/friends/friends_interface")
local FriendsDummy = class("FriendsDummy")

FriendsDummy.init = function (self)
	return
end

FriendsDummy.destroy = function (self)
	return
end

local temp_friend_data = {}

FriendsDummy.fetch = function (self)
	return temp_friend_data
end

implements(FriendsDummy, FriendsInterface)

return FriendsDummy
