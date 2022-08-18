-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
local PlatformSocialInterface = require("scripts/managers/data_service/services/social/platform_social_interface")
local FriendXboxLive = require("scripts/managers/data_service/services/social/friend_xbox_live")
local Promise = require("scripts/foundation/utilities/promise")
local XboxLiveUtils = require("scripts/foundation/utilities/xbox_live")
local SocialXboxLive = class("SocialXboxLive")

SocialXboxLive.init = function (self)
	self._num_friends = 0
	self._num_blocked = 0
	self._friends_promise = nil
	self._blocked_promise = nil
end

SocialXboxLive.destroy = function (self)
	return
end

SocialXboxLive.friends_list_has_changes = function (self)
	return false
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
		for i = 1, #relationships, 1 do
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

	Managers.xasync:wrap(relationships_async, XSocial.release_block):next(function (async_block)
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

	self._friends_promise = Promise:new()
	local user_id = nil

	XboxLiveUtils.user_id():next(function (result)
		user_id = result
		local relationships_async, error = XSocial.get_relationships(user_id)

		if error then
			self._friends_promise:reject({
				error
			})
		else
			return Managers.xasync:wrap(relationships_async, XSocial.release_block)
		end
	end):next(function (async_block)
		local page_handle, error = XSocial.get_relationships_result(async_block)

		if error then
			self._friends_promise:reject({
				error
			})
		else
			local xuids_promise = Promise:new()

			_process_relationships_page(user_id, page_handle, xuids_promise, {})

			return xuids_promise
		end
	end):next(function (xuids)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-4, warpins: 1 ---
		if #xuids > 0 then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 5-18, warpins: 1 ---
			local profiles_promise = XboxLiveUtils.get_user_profiles(xuids)
			local get_user_presence_data_promise = XboxLiveUtils.get_user_presence_data(xuids)

			return Promise.all(profiles_promise, get_user_presence_data_promise)
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 19-22, warpins: 1 ---
			return Promise.resolved({})
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 23-23, warpins: 2 ---
		return
		--- END OF BLOCK #1 ---



	end):next(function (results)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-8, warpins: 1 ---
		local profiles, user_presence_data = unpack(results)
		local is_blocked = false

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 9-21, warpins: 0 ---
		for i = 1, #profiles, 1 do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 9-21, warpins: 2 ---
			local profile = profiles[i]
			local user_presence_data = user_presence_data[profile.xuid]
			profiles[i] = FriendXboxLive:new(profile.xuid, user_presence_data, profile.gamertag, is_blocked)
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #1 ---

		FLOW; TARGET BLOCK #2



		-- Decompilation error in this vicinity:
		--- BLOCK #2 22-31, warpins: 1 ---
		self._num_friends = #profiles

		self._friends_promise:resolve(profiles)

		return
		--- END OF BLOCK #2 ---



	end):catch(function (error)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-8, warpins: 1 ---
		self._friends_promise:reject({
			error
		})

		return
		--- END OF BLOCK #0 ---



	end)

	return self._friends_promise
end

SocialXboxLive.blocked_list_has_changes = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return false
	--- END OF BLOCK #0 ---



end

SocialXboxLive.fetch_blocked_list = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	local blocked_promise = self._blocked_promise

	if blocked_promise and blocked_promise:is_pending() then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 9-9, warpins: 1 ---
		return blocked_promise
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 10-32, warpins: 2 ---
	self._blocked_promise = Promise:new()

	XboxLiveUtils.get_avoid_list():next(function (xuids)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-4, warpins: 1 ---
		if #xuids > 0 then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 5-9, warpins: 1 ---
			return XboxLiveUtils.get_user_profiles(xuids)
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 10-13, warpins: 1 ---
			return Promise.resolved({})
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 14-14, warpins: 2 ---
		return
		--- END OF BLOCK #1 ---



	end):next(function (profiles)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-5, warpins: 1 ---
		local is_blocked = true

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 6-15, warpins: 0 ---
		for i = 1, #profiles, 1 do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 6-15, warpins: 2 ---
			local profile = profiles[i]
			profiles[i] = FriendXboxLive:new(profile.xuid, profile.gamertag, is_blocked)
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #1 ---

		FLOW; TARGET BLOCK #2



		-- Decompilation error in this vicinity:
		--- BLOCK #2 16-25, warpins: 1 ---
		self._num_blocked = #profiles

		self._blocked_promise:resolve(profiles)

		return
		--- END OF BLOCK #2 ---



	end):catch(function (error)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-8, warpins: 1 ---
		self._blocked_promise:reject({
			error
		})

		return
		--- END OF BLOCK #0 ---



	end)

	return self._blocked_promise
	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 33-33, warpins: 2 ---
	--- END OF BLOCK #2 ---



end

SocialXboxLive.fetch_blocked_list_ids_forced = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	return XboxLiveUtils.get_avoid_list()
	--- END OF BLOCK #0 ---



end

implements(SocialXboxLive, PlatformSocialInterface)

return SocialXboxLive
