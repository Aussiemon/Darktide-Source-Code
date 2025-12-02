-- chunkname: @scripts/managers/data_service/services/global_stats_service.lua

local Promise = require("scripts/foundation/utilities/promise")
local GlobalStatsService = class("GlobalStatsService")
local REFRESH_INTERVAL = 60
local REFRESH_JITTER = 5

GlobalStatsService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
	self._stats_by_category = {}
	self._backend_promises = {}
	self._delay_promises = {}
	self._subscribers_by_category = {}
end

GlobalStatsService.destroy = function (self)
	for _, promise in pairs(self._backend_promises) do
		promise:cancel()
	end

	self._backend_promises = nil

	for _, promise in pairs(self._delay_promises) do
		promise:cancel()
	end

	self._delay_promises = nil
end

GlobalStatsService._queue_refresh = function (self, category_name, amount)
	if self._delay_promises[category_name] then
		self._delay_promises[category_name]:cancel()
	end

	self._delay_promises[category_name] = Promise.delay(amount)

	self._delay_promises[category_name]:next(function ()
		self._delay_promises[category_name] = nil

		if self._subscribers_by_category[category_name] == nil then
			return
		end

		self:_refresh_category(category_name)
	end)
end

GlobalStatsService._trigger_subscribers = function (self, category_name, old_stats, new_stats)
	local subscribers_by_category = self._subscribers_by_category[category_name] or {}

	for stat_name, subscribers in pairs(subscribers_by_category) do
		local old_value = old_stats and old_stats[stat_name] or 0
		local new_value = new_stats and new_stats[stat_name] or 0

		if old_value == new_value then
			-- Nothing
		else
			for object, function_name in pairs(subscribers) do
				object[function_name](object, stat_name, new_value)
			end
		end
	end
end

GlobalStatsService._refresh_category = function (self, category_name)
	if self._backend_promises[category_name] then
		return self._backend_promises[category_name]:next(function (t)
			return t
		end)
	end

	local backend_promise = self._backend_interface.global_stats:get_category(category_name):next(function (body)
		return body.stats
	end)

	self._backend_promises[category_name] = backend_promise

	backend_promise:catch(function (err)
		Log.warning("GlobalStatsService", "Failed to fetch global stats for category '%s'. Default to current internally.", category_name, err)

		return self._stats_by_category[category_name] or {}
	end):next(function (stats)
		self._backend_promises[category_name] = nil

		local old_stats = self._stats_by_category[category_name] or {}

		self._stats_by_category[category_name] = stats

		self:_trigger_subscribers(category_name, old_stats, stats)

		local refresh_time = REFRESH_INTERVAL + math.random() * REFRESH_JITTER

		self:_queue_refresh(category_name, refresh_time)
	end)

	return backend_promise:next(function (t)
		return t
	end)
end

GlobalStatsService.get = function (self, category_name)
	return self:_refresh_category(category_name)
end

GlobalStatsService.subscribe = function (self, object, function_name, category_name, stat_name, default_value)
	default_value = default_value or 0
	self._subscribers_by_category[category_name] = self._subscribers_by_category[category_name] or {}
	self._subscribers_by_category[category_name][stat_name] = self._subscribers_by_category[category_name][stat_name] or {}
	self._subscribers_by_category[category_name][stat_name][object] = function_name

	local stats = self._stats_by_category[category_name]
	local has_stats = stats ~= nil

	if not has_stats then
		self:_refresh_category(category_name)
	end

	local is_refreshing = self._delay_promises[category_name] ~= nil or self._backend_promises[category_name] ~= nil

	if has_stats and not is_refreshing then
		self:_refresh_category(category_name)
	end

	return has_stats and stats[stat_name] or default_value
end

GlobalStatsService.unsubscribe = function (self, object, category_name, stat_name)
	self._subscribers_by_category[category_name][stat_name][object] = nil

	if next(self._subscribers_by_category[category_name][stat_name]) == nil then
		self._subscribers_by_category[category_name][stat_name] = nil
	end

	if next(self._subscribers_by_category[category_name]) == nil then
		self._subscribers_by_category[category_name] = nil
	end
end

return GlobalStatsService
