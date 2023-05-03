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

		target_to_region[region.pingTarget] = region
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

RegionLatency._convert_decimal_to_int_latency = function (self, decimal)
	return math.ceil(decimal * 1000)
end

RegionLatency._do_refresh = function (self)
	return Managers.backend:title_request("/matchmaker/regions", {
		method = "GET"
	}):next(function (data)
		local regions = data.body.regions
		local expanded_regions = {}

		for i, region in ipairs(regions) do
			if region.fastPingTarget then
				local fast_region = {
					fast = true,
					region = region.region,
					reefs = region.reefs,
					pingTarget = region.fastPingTarget
				}

				table.insert(expanded_regions, fast_region)
			end

			table.insert(expanded_regions, region)
		end

		local promise = Promise:new()
		local results = {}
		local ping_count = 10

		self:_recursive_ping(0.5, ping_count, expanded_regions, results, promise)

		return promise
	end):next(function (ping_responses)
		local region_latencies = {}

		for region, latencies in pairs(ping_responses) do
			local sent = #latencies
			local filtered_latencies = {}
			local lost = 0

			for i, l in ipairs(latencies) do
				if l == -1 then
					lost = lost + 1
				else
					table.insert(filtered_latencies, l)
				end
			end

			latencies = filtered_latencies
			local total_diff = 0
			local total = 0

			for i, l in ipairs(latencies) do
				total = total + l

				if i == #latencies then
					break
				end

				local l2 = latencies[i + 1]
				total_diff = total_diff + math.abs(l - l2)
			end

			local jitter = self:_convert_decimal_to_int_latency(total_diff / #latencies)
			local avg = self:_convert_decimal_to_int_latency(total / #latencies)

			table.sort(latencies)

			local latency = -1
			local min = -1
			local max = -1
			local diff_min_max = -1

			if #latencies > 0 then
				latency = self:_convert_decimal_to_int_latency(latencies[math.ceil(#latencies / 2)])
				min = self:_convert_decimal_to_int_latency(latencies[1])
				max = self:_convert_decimal_to_int_latency(latencies[#latencies])
				diff_min_max = max - min
			end

			local stats = {
				jitter = jitter,
				min = min,
				max = max,
				avg = avg,
				median = latency,
				diff_min_max = diff_min_max,
				sent = sent,
				lost = lost
			}
			local region_latency_entry = nil

			for i, entry in ipairs(region_latencies) do
				if entry.region == region.region then
					region_latency_entry = entry

					break
				end
			end

			if not region_latency_entry then
				region_latency_entry = {
					region = region.region,
					reefs = region.reefs,
					latency = latency
				}

				table.insert(region_latencies, region_latency_entry)
			end

			if region.fast then
				region_latency_entry.fast_latency = latency
				region_latency_entry.fast_stats = stats
			else
				region_latency_entry.latency = latency
				region_latency_entry.stats = stats
			end
		end

		return region_latencies
	end):next(function (result)
		return Promise.resolved(result)
	end):catch(function (e)
		Log.error("RegionLatency", "Could not refresh latencies: %s", table.tostring(e, 3))
	end)
end

implements(RegionLatency, Interface)

return RegionLatency
