-- chunkname: @scripts/backend/player_rewards.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Promise = require("scripts/foundation/utilities/promise")
local PlayerRewards = class("PlayerRewards")

PlayerRewards.get_penance_rewards_by_source = function (self, wrapped, promise, all_rewards)
	if not wrapped then
		local new_promise = Promise.new()

		self:get_rewards_by_source_paged(100, "commendation"):next(function (w)
			self:get_penance_rewards_by_source(w, new_promise, {})
		end):catch(function (error)
			new_promise:reject(error)
		end)

		return new_promise
	else
		for _, item in pairs(wrapped.items) do
			local source_info = item.sourceInfo
			local penance_id = source_info.sourceIdentifier

			all_rewards[#all_rewards + 1] = {
				penance_id = penance_id,
				reward_bundle = item,
			}
		end

		if wrapped.has_next then
			wrapped.next_page():next(function (w)
				self:get_penance_rewards_by_source(w, promise, all_rewards)
			end)
		else
			promise:resolve(all_rewards)
		end
	end
end

PlayerRewards.get_rewards_by_source_paged = function (self, limit, source)
	local promise = BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("/rewards/"):path(source):query("limit", limit))

	return promise:next(function (data)
		local result = BackendUtilities.wrap_paged_response(data.body)

		return result
	end)
end

PlayerRewards.claim_bundle_reward = function (self, bundle_reward_id)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/account/rewards/"):path(bundle_reward_id)
		local options = {
			method = "PUT",
		}

		return Managers.backend:title_request(builder:to_string(), options)
	end)
end

return PlayerRewards
