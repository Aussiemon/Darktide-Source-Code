-- chunkname: @scripts/backend/tracks.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Tracks = class("Tracks")

Tracks.get_all_tracks_state = function (self)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/trackstate/")

		return Managers.backend:title_request(builder:to_string()):next(function (response)
			return response.body
		end):catch(function ()
			return {}
		end)
	end)
end

Tracks.get_track_state = function (self, trackId)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/trackstate/"):path(trackId)

		return Managers.backend:title_request(builder:to_string()):next(function (response)
			return response.body.track
		end):catch(function ()
			return {}
		end)
	end)
end

Tracks.get_track = function (self, trackId)
	local builder = BackendUtilities.url_builder():path("/tracks/"):path(trackId)

	return Managers.backend:title_request(builder:to_string()):next(function (data)
		return data.body
	end):catch(function ()
		return {}
	end)
end

Tracks.claim_track_tier = function (self, trackId, tier)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/tracks/"):path(trackId):path("/tiers/"):path(tier)
		local options = {
			method = "POST",
		}

		return Managers.backend:title_request(builder:to_string(), options)
	end)
end

Tracks.claim_trait_tier_reward = function (self, trackId, tier, rewardId)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/tracks/"):path(trackId):path("/tiers/"):path(tier):path("/rewards/"):path(rewardId)
		local options = {
			method = "POST",
		}

		return Managers.backend:title_request(builder:to_string(), options)
	end)
end

return Tracks
