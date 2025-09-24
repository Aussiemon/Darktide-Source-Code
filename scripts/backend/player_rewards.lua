-- chunkname: @scripts/backend/player_rewards.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local PlayerRewards = class("PlayerRewards")

PlayerRewards.get_penance_rewards_by_source = function (self)
	return BackendUtilities.collect_all_paged_data(self:get_rewards_by_source_paged(64, "commendation")):next(function (items)
		return table.map(items, function (item)
			return {
				penance_id = item.sourceInfo.sourceIdentifier,
				reward_bundle = item,
			}
		end)
	end)
end

PlayerRewards.get_rewards_by_source_paged = function (self, limit, source)
	local promise = BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("/rewards/"):path(source):query("limit", limit))

	return promise:next(function (data)
		return BackendUtilities.wrap_paged_response(data.body)
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
