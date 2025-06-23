-- chunkname: @scripts/managers/data_service/services/social/social_xbox_live.lua

local PlatformSocialInterface = require("scripts/managers/data_service/services/social/platform_social_interface")
local FriendXboxLive = require("scripts/managers/data_service/services/social/friend_xbox_live")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local Promise = require("scripts/foundation/utilities/promise")
local XboxLiveUtils = require("scripts/foundation/utilities/xbox_live_utils")
local RECENT_PLAYERS_MAX_RETRIES = 10
local RECENT_PLAYERS_RETRY_DELAY = 6
local SocialXboxLive = class("SocialXboxLive")

SocialXboxLive.init = function (self)
	self._num_friends = 0
	self._num_blocked = 0
	self._friends_promise = nil
	self._blocked_promise = nil
	self._recent_players_retry_time = nil
	self._recent_players_retry_queue = {}
	self._recent_players_num_retries = {}
	self._recent_players_promises = {}
end

SocialXboxLive.destroy = function (self)
	self:reset()
end

SocialXboxLive.reset = function (self)
	self._recent_players_retry_time = nil

	table.clear(self._recent_players_retry_queue)
	table.clear(self._recent_players_num_retries)

	for account_id, promise in pairs(self._recent_players_promises) do
		promise:cancel()
	end

	table.clear(self._recent_players_promises)
end

SocialXboxLive.friends_list_has_changes = function (self)
	return Managers.account:friends_list_has_changes()
end

local function _process_relationships_page(user_id, page_handle, promise, xuids)
	local _, relationships, error = XSocial.relationships_result_get_relationships(user_id, page_handle)

	if error then
		XSocial.close_relationships_handle(page_handle)
		promise:reject({
			error
		})

		return
	end

	if relationships then
		for i = 1, #relationships do
			xuids[i] = relationships[i].xuid
		end
	end

	if not XSocial.relationships_result_has_next(page_handle) then
		XSocial.close_relationships_handle(page_handle)
		promise:resolve(xuids)

		return
	end

	local relationships_async, error = XSocial.relationships_result_get_next(user_id, page_handle, 100)

	XSocial.close_relationships_handle(page_handle)

	if error then
		promise:reject({
			error
		})

		return
	end

	Managers.xasync:wrap(relationships_async):next(function (async_block)
		local next_page_handle, error = XSocial.get_relationships_result(async_block)

		if error then
			XSocial.close_relationships_handle(next_page_handle)
			promise:reject({
				error
			})
		else
			_process_relationships_page(user_id, next_page_handle, promise, xuids)
		end
	end)
end

SocialXboxLive.fetch_friends_list = function (self)
	local friends_promise = self._friends_promise

	if friends_promise and friends_promise:is_pending() then
		return friends_promise
	end

	local profiles = {}

	self._friends_promise = Promise:new()

	local friends_list = Managers.account:get_friends()

	for i = 1, #friends_list do
		local friend_data = friends_list[i]

		profiles[#profiles + 1] = FriendXboxLive:new(friend_data)
	end

	self._num_friends = #profiles

	self._friends_promise:resolve(profiles)

	return self._friends_promise
end

SocialXboxLive.blocked_list_has_changes = function (self)
	return false
end

SocialXboxLive.fetch_blocked_list = function (self)
	local blocked_promise = self._blocked_promise

	if blocked_promise and blocked_promise:is_pending() then
		return blocked_promise
	end

	self._blocked_promise = Promise:new()

	Managers.account:xbox_live_block_list():next(function (xuids)
		if #xuids > 0 then
			return XboxLiveUtils.get_user_profiles(xuids)
		else
			return Promise.resolved({})
		end
	end):next(function (profiles)
		local is_blocked = true

		for i = 1, #profiles do
			local profile = profiles[i]

			profiles[i] = FriendXboxLive:new(profile, is_blocked)
		end

		self._num_blocked = #profiles

		self._blocked_promise:resolve(profiles)
	end):catch(function (error)
		self._blocked_promise:reject({
			error
		})
	end)

	return self._blocked_promise
end

SocialXboxLive.fetch_blocked_list_ids_forced = function (self)
	return Managers.account:xbox_live_block_list()
end

SocialXboxLive.update = function (self, dt, t)
	local queue = self._recent_players_retry_queue

	if #queue > 0 and t >= self._recent_players_retry_time then
		for i = 1, #queue do
			local account_id = queue[i]

			Log.info("SocialXboxLive", "[update_recent_players] Retrying %s", account_id)
			self:_update_recent_player(account_id)
		end

		table.clear(queue)
	end
end

SocialXboxLive.update_recent_players = function (self, account_id)
	if self._recent_players_promises[account_id] then
		return
	end

	if table.find(self._recent_players_retry_queue, account_id) then
		return
	end

	self:_update_recent_player(account_id)
end

SocialXboxLive._update_recent_player = function (self, account_id)
	local _, presence_promise = Managers.presence:get_presence(account_id)

	self._recent_players_promises[account_id] = presence_promise

	presence_promise:next(function (presence)
		if not presence then
			return Promise.rejected({
				"Missing presence"
			})
		end

		local platform = presence:platform()

		if platform ~= "xbox" then
			Log.info("SocialXboxLive", "[update_recent_players] Ignoring %s, platform %q ~= \"xbox\"", account_id, platform)

			return nil
		end

		local xuid = presence:platform_user_id()

		if not xuid then
			return Promise.rejected({
				"Missing xuid"
			})
		end

		Log.info("SocialXboxLive", "[update_recent_players] Updating... (account_id: %s, xuid: %s)", account_id, xuid)

		local update_promise = XboxLiveUtils.update_recent_player_teammate(xuid)

		self._recent_players_promises[account_id] = update_promise

		return update_promise
	end):next(function ()
		self._recent_players_promises[account_id] = nil
		self._recent_players_num_retries[account_id] = nil
	end):catch(function (err)
		Log.error("SocialXboxLive", "[update_recent_players] Update Failed %s: %s", account_id, table.tostring(err, 5))

		self._recent_players_promises[account_id] = nil
		self._recent_players_retry_time = Managers.time:time("main") + RECENT_PLAYERS_RETRY_DELAY

		local num_retries = self._recent_players_num_retries[account_id] or 0

		if num_retries < RECENT_PLAYERS_MAX_RETRIES then
			self._recent_players_num_retries[account_id] = num_retries + 1
			self._recent_players_retry_queue[#self._recent_players_retry_queue + 1] = account_id
		else
			self._recent_players_num_retries[account_id] = nil
		end
	end)
end

implements(SocialXboxLive, PlatformSocialInterface)

return SocialXboxLive
