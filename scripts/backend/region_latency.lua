local Promise = require("scripts/foundation/utilities/promise")
local Interface = {
	"pre_get_region_latencies",
	"get_region_latencies"
}
local RegionLatency = class("RegionLatency")

RegionLatency.pre_get_region_latencies = function (self)
	if not self._promise then
		self._promise = self:_do_refresh()
	end
end

RegionLatency.get_region_latencies = function (self)
	if not self._promise then
		self._promise = self:_do_refresh()
	end

	return self._promise
end

RegionLatency._ping_targets = function (self, timeout, regions)
	local targets = {}
	local target_to_region = {}

	for i, region in ipairs(regions) do
		table.insert(targets, region.pingTarget)

		target_to_region[region.pingTarget] = region.region
	end

	return Managers.ping:ping(timeout, targets):next(function (ping_result)
		local processed = {}

		for target, result in pairs(ping_result) do
			local region = target_to_region[target]

			if region then
				processed[region] = result
			else
				Log.error("RegionLatency", "Could not find region for target %s", target)
			end
		end

		return Promise.resolved(processed)
	end)
end

RegionLatency._recursive_ping = function (self, timeout, ping_count, regions, ping_responses, promise)
	self:_ping_targets(timeout, regions):next(function (ping_response)
		for region, result in pairs(ping_response) do
			if timeout < 2 and not result.failed and result.latency == -1 then
				timeout = timeout + 0.5
			end

			local pings = ping_responses[region]

			if not pings then
				pings = {}
				ping_responses[region] = pings
			end

			table.insert(pings, result.latency)
		end

		ping_count = ping_count - 1

		if ping_count <= 0 then
			promise:resolve(ping_responses)
		else
			self:_recursive_ping(timeout, ping_count, regions, ping_responses, promise)
		end
	end):catch(function (error)
		promise:reject(error)
	end)
end

RegionLatency._do_refresh = function (self)
	return Managers.backend:title_request("/matchmaker/regions", {
		method = "GET"
	}):next(function (data)
		local regions = data.body.regions
		local promise = Promise:new()
		local results = {}
		local ping_count = 7

		self:_recursive_ping(0.5, ping_count, regions, results, promise)

		return promise
	end):next(function (ping_responses)
		Log.info("RegionLatency", "Ping responses: " .. table.tostring(ping_responses, 3))

		local region_latencies = {}

		for region, latencies in pairs(ping_responses) do
			table.sort(latencies)

			local latency = nil

			if latencies[4] ~= -1 then
				latency = math.floor(latencies[4] * 1000)
			else
				latency = -1
			end

			table.insert(region_latencies, {
				region = region,
				latency = latency
			})
		end

		return region_latencies
	end):next(function (result)
		Log.info("RegionLatency", "Refreshed region latencies: " .. table.tostring(result, 3))

		return Promise.resolved(result)
	end):catch(function (e)
		Log.error("RegionLatency", "Could not refresh latencies: " .. table.tostring(e, 3))
	end)
end

implements(RegionLatency, Interface)

return RegionLatency
