local Promise = require("scripts/foundation/utilities/promise")
local Interface = require("scripts/backend/social_interface")
local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local SocialLocal = class("SocialLocal")

SocialLocal.init = function (self)
	self._temp_block_list = {}
	self._friends = {}
end

local FriendStatus = SocialConstants.FriendStatus

SocialLocal.fetch_friends = function (self)
	return Promise.delay(2):next(function ()
		local max_number_friends = 10
		local friends = {}

		for _, friend in pairs(self._friends) do
			friends[#friends + 1] = friend
		end

		local response_data = {
			friends = friends,
			maxFriends = max_number_friends
		}

		return response_data
	end)
end

SocialLocal.send_friend_request = function (self, account_id, method)
	return Promise.delay(2):next(function ()
		local t = Managers.time:time("main")
		local server_time = Managers.backend:get_server_time(t)

		if not method or method == "POST" then
			local is_sent = not self._is_sent_friend_request
			self._is_sent_friend_request = is_sent
			local friend = {
				accountName = "DummyData",
				accountId = account_id,
				status = is_sent and FriendStatus.invited or FriendStatus.invite,
				invitedTime = tostring(server_time)
			}
			self._friends[account_id] = friend
		elseif method == "PUT" then
			local friend = self._friends[account_id]
			friend.status = FriendStatus.friend
			friend.friendedTime = tostring(server_time)
		elseif method == "PATCH" or method == "DELETE" then
			self._friends[account_id] = nil
		end
	end)
end

SocialLocal.unfriend_player = function (self, account_id)
	self._friends[account_id] = nil
end

SocialLocal.fetch_recently_played = function (self, character_id)
	assert(character_id, "character_id must be specified")

	return Promise.delay(2):next(function ()
		local response_data = {
			recentParticipants = {}
		}

		return response_data
	end)
end

SocialLocal.add_blocked_account = function (self, account_id)
	assert(account_id, "account_id must be specified")

	return Promise.delay(2):next(function ()
		self._temp_block_list[account_id] = true
	end)
end

SocialLocal.remove_blocked_account = function (self, account_id)
	assert(account_id, "account_id must be specified")

	return Promise.delay(2):next(function ()
		self._temp_block_list[account_id] = nil
	end)
end

SocialLocal.fetch_blocked_accounts = function (self)
	return Promise.delay(2):next(function ()
		local response_data = {
			blockList = table.clone(self._temp_block_list)
		}

		return response_data
	end)
end

SocialLocal.suggested_names_by_archetype = function (self, archetype)
	return Promise.delay(2):next(function ()
		local names = {}
		local main_part = "Generic_" .. archetype .. "_"

		for i = 1, 10 do
			names[i] = main_part .. i
		end

		return names
	end)
end

implements(SocialLocal, Interface)

return SocialLocal
