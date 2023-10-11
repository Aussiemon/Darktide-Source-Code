local PlatformSocialInterface = require("scripts/managers/data_service/services/social/platform_social_interface")
local FriendSteam = require("scripts/managers/data_service/services/social/friend_steam")
local Promise = require("scripts/foundation/utilities/promise")
local SocialSteam = class("SocialSteam")

SocialSteam.init = function (self)
	self._num_friends = 0
	self._num_blocked = 0
	self._updated_recent_players = {}
end

SocialSteam.destroy = function (self)
	return
end

SocialSteam.reset = function (self)
	return
end

SocialSteam.update = function (self, dt, t)
	return
end

SocialSteam.friends_list_has_changes = function (self)
	local num_friends = Friends.num_friends(Friends.FRIEND_FLAG)

	return self._num_friends ~= num_friends
end

SocialSteam.fetch_friends_list = function (self)
	local friend_list = {}
	local promise = Promise:new()
	local app_id = Steam.app_id()
	local num_friends = Friends.num_friends(Friends.FRIEND_FLAG)

	for i = 1, num_friends do
		local id = Friends.id(i)
		local friend = FriendSteam:new(id, app_id)
		friend_list[i] = friend
	end

	promise:resolve(friend_list)

	self._num_friends = num_friends

	return promise
end

SocialSteam.blocked_list_has_changes = function (self)
	local num_blocked = Friends.num_friends(Friends.IGNORED_FRIEND_FLAG)

	return self._num_blocked ~= num_blocked
end

SocialSteam.fetch_blocked_list = function (self)
	local blocked_list = {}
	local app_id = Steam.app_id()
	local promise = Promise:new()
	local num_blocked = Friends.num_friends(Friends.IGNORED_FRIEND_FLAG)

	for i = 1, num_blocked do
		local id = Friends.id(i)
		local blocked = FriendSteam:new(id, app_id)
		blocked_list[i] = blocked
	end

	promise:resolve(blocked_list)

	self._num_blocked = num_blocked

	return promise
end

SocialSteam.fetch_blocked_list_ids_forced = function (self)
	local blocked_list = {}
	local promise = Promise:new()
	local num_blocked = Friends.num_friends(Friends.IGNORED_FRIEND_FLAG)

	for i = 1, num_blocked do
		local id = Friends.id(i)
		blocked_list[i] = id
	end

	promise:resolve(blocked_list)

	return promise
end

SocialSteam.update_recent_players = function (self, account_id)
	if self._updated_recent_players[account_id] then
		return
	end

	self._updated_recent_players[account_id] = true
	local _, promise = Managers.presence:get_presence(account_id)

	promise:next(function (presence)
		if presence and presence:platform() == "steam" then
			local steam_id = presence:platform_user_id()

			if steam_id then
				Log.info("SocialSteam", "Updating recent player (account_id: %s, steam_id: %s)", account_id, steam_id)
				Friends.set_played_with(steam_id)
			end
		end
	end):catch(function (err)
		Log.info("SocialSteam", "Couldn't update recent player, presence error: %s", table.tostring(err))
	end)
end

implements(SocialSteam, PlatformSocialInterface)

return SocialSteam
