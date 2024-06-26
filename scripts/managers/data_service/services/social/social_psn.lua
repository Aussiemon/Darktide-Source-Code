-- chunkname: @scripts/managers/data_service/services/social/social_psn.lua

local PlatformSocialInterface = require("scripts/managers/data_service/services/social/platform_social_interface")
local Promise = require("scripts/foundation/utilities/promise")
local FriendPSN = require("scripts/managers/data_service/services/social/friend_psn")
local SocialPSN = class("SocialPSN")

SocialPSN.init = function (self)
	self._num_friends = 0
	self._num_blocked = 0
	self._friends_promise = nil
	self._blocked_promise = nil
	self._friends_promise = nil
end

SocialPSN.destroy = function (self)
	return
end

SocialPSN.reset = function (self)
	return
end

SocialPSN.update = function (self, dt, t)
	return
end

SocialPSN.friends_list_has_changes = function (self)
	return false
end

local empty_friend_list = {}

SocialPSN.fetch_friends_list = function (self)
	local friends_promise = self._friends_promise

	if friends_promise and friends_promise:is_pending() then
		return friends_promise
	end

	local return_promise = Promise.new()

	self._friends_promise = Managers.account:get_friends()

	self._friends_promise:next(function (friends)
		friends = friends or empty_friend_list

		local playing_friends = {}
		local online_friends = {}
		local offline_friends = {}

		for id, friend in pairs(friends) do
			friend.id = id

			if friend.onlineStatus == "offline" then
				offline_friends[#offline_friends + 1] = friend
			elseif friend.inContext then
				playing_friends[#playing_friends + 1] = friend
			else
				online_friends[#online_friends + 1] = friend
			end
		end

		local function sort(a, b)
			return a.onlineId < b.onlineId
		end

		table.sort(playing_friends, sort)
		table.sort(online_friends, sort)
		table.sort(offline_friends, sort)

		local profiles = {}

		for id, friend in pairs(friends) do
			profiles[#profiles + 1] = FriendPSN:new(friend)
		end

		self._num_friends = #profiles
		self._friends_promise = nil

		return_promise:resolve(profiles)
	end)

	return return_promise
end

SocialPSN.blocked_list_has_changes = function (self)
	return false
end

SocialPSN.fetch_blocked_list = function (self)
	local blocked_promise = self._blocked_promise

	if blocked_promise and blocked_promise:is_pending() then
		return blocked_promise
	end

	self._blocked_promise = Promise:new()

	Managers.account:get_blocked_profiles():next(function (profiles)
		local is_blocked = true
		local blocked_list = {}

		for i = 1, #profiles do
			local profile = profiles[i]

			blocked_list[i] = FriendPSN:new(profile, is_blocked)
		end

		self._num_blocked = #blocked_list

		self._blocked_promise:resolve(blocked_list)
	end):catch(function (error)
		self._blocked_promise:reject({
			error,
		})
	end)

	return self._blocked_promise
end

SocialPSN.fetch_blocked_list_ids_forced = function (self)
	local result_promise = Promise:new()

	Managers.account:get_blocked_profiles():next(function (profiles)
		local account_ids = {}

		for i = 1, #profiles do
			local profile = profiles[i]

			account_ids[i] = profile.accountId
		end

		result_promise:resolve(account_ids)
	end)

	return result_promise
end

SocialPSN.update_recent_players = function (self, account_id)
	return
end

implements(SocialPSN, PlatformSocialInterface)

return SocialPSN
