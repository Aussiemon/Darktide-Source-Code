-- chunkname: @scripts/backend/havoc.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Promise = require("scripts/foundation/utilities/promise")
local Havoc = class("Havoc")

Havoc.latest = function (self, optional_account_id)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/havoc"):path("/latest")
		local options = {
			method = "GET",
		}

		return Managers.backend:title_request(builder:to_string(), options):next(function (data)
			if data.status == 200 then
				local parsed_data = {}
				local havoc_status = data.body.havocStatus

				if havoc_status then
					parsed_data.is_rewarded = havoc_status.isRewarded
					parsed_data.start_time = tonumber(havoc_status.start)
					parsed_data.end_time = tonumber(havoc_status["end"])
					parsed_data.id = havoc_status.id
					parsed_data.rank = havoc_status.rank
					parsed_data.is_active = havoc_status.isActive
				end

				local havoc_stats = data.body.havocStats

				if havoc_stats then
					parsed_data.rank_all_time = havoc_stats.rank and havoc_stats.rank.allTime
					parsed_data.rank_week = havoc_stats.rank and havoc_stats.rank.week
				end

				local rewards = data.body.rewards

				if rewards then
					parsed_data.amount = rewards.amount
					parsed_data.type = rewards.type
				end

				return parsed_data
			else
				return Promise.rejected(data)
			end
		end)
	end):catch(function (err)
		return Promise.rejected(err)
	end)
end

Havoc.summary = function (self, optional_account_id)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/havoc"):path("/summary")
		local options = {
			method = "GET",
		}

		return Managers.backend:title_request(builder:to_string(), options):next(function (data)
			if data.status == 200 then
				local parsed_data = {}

				if data.body.highestRank then
					parsed_data.highest_rank = tonumber(data.body.highestRank)
				end

				if data.body.currentOrder then
					local local_blueprint = {}

					if data.body.currentOrder.blueprint then
						local_blueprint.map = data.body.currentOrder.blueprint.map
						local_blueprint.challenge = tonumber(data.body.currentOrder.blueprint.challenge)
						local_blueprint.resistance = tonumber(data.body.currentOrder.blueprint.resistance)
						local_blueprint.flags = data.body.currentOrder.blueprint.flags
					end

					parsed_data.current_order = {
						id = data.body.currentOrder.id,
						rank = tonumber(data.body.currentOrder.rank),
						state = data.body.currentOrder.state,
						blueprint = local_blueprint,
					}
				end

				return parsed_data
			else
				return Promise.rejected(data)
			end
		end)
	end):catch(function (err)
		return Promise.rejected(err)
	end)
end

Havoc.fetch_paged_history = function (self, status_id, size)
	return Managers.backend:authenticate():next(function (account)
		local builder = BackendUtilities.url_builder():path("/data/"):path(account.sub):path("/havoc/status/"):path(status_id):path("/history"):query("limit", size or 2)

		return builder:to_string()
	end):next(function (path)
		return Managers.backend:title_request(path)
	end):next(function (data)
		return BackendUtilities.wrap_paged_response(data.body)
	end)
end

Havoc.sync = function (self, optional_account_id)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/havoc"):path("/synchronize")
		local options = {
			method = "PUT",
		}

		return Managers.backend:title_request(builder:to_string(), options):next(function (data)
			if data.status ~= 200 then
				return Promise.rejected(data)
			end

			return {
				highest_rank = data.body.highestRank or 1,
				rewards = data.body.rewards,
			}
		end)
	end):catch(function (error)
		return Promise.rejected(error)
	end)
end

Havoc.status_by_id = function (self, week_id, optional_account_id)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/havoc/status/"):path(week_id)
		local options = {
			method = "GET",
		}

		return Managers.backend:title_request(builder:to_string(), options):next(function (data)
			if data.status ~= 200 then
				return Promise.rejected(data)
			end

			return {
				havoc_status = data.body.havocStatus,
				rewards = data.body.rewards,
				havoc_stats = data.body.havocStats,
			}
		end)
	end)
end

Havoc.eligible = function (self)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/havoc"):path("/eligible")
		local options = {
			method = "GET",
		}

		return Managers.backend:title_request(builder:to_string(), options):next(function (data)
			if data.status ~= 200 then
				return Promise.rejected(data)
			end

			return {
				eligible = data.body.eligible,
				status_code = data.body.statusCode,
			}
		end)
	end)
end

Havoc.refresh_settings = function (self)
	local builder = BackendUtilities.url_builder():path("/data"):path("/havoc"):path("/settings")
	local options = {
		method = "GET",
	}

	return Managers.backend:title_request(builder:to_string(), options):next(function (data)
		local havoc_settings = data and data.body

		if havoc_settings then
			self._havoc_settings = {
				min_participants = havoc_settings.minPrivateParticipants,
				max_rank = havoc_settings.rankSystem.maxRank,
				max_charges = havoc_settings.rankSystem.charges,
			}

			return self._havoc_settings
		end

		return {}
	end):catch(function (error)
		return
	end)
end

Havoc.settings = function (self)
	return self._havoc_settings
end

return Havoc
