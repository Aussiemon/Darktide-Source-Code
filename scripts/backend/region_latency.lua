-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
local Promise = require("scripts/foundation/utilities/promise")
local Interface = {
	"refresh_region_latencies",
	"get_cached_region_latencies"
}
local RegionLatency = class("RegionLatency")
local cached = {}

RegionLatency.refresh_region_latencies = function (self)
	return Managers.backend:title_request("/matchmaker/regions", {
		method = "GET"
	}):next(function (data)
		local regions = data.body.regions
		local promises = {}

		for i, region in ipairs(regions) do
			local promise = Managers.backend:url_request(region.httpLatencyUrl, {
				use_curl_multi_handle = false
			}):next(function (r1)
				return Promise.all(Managers.backend:url_request(region.httpLatencyUrl, {
					use_curl_multi_handle = false
				}), Managers.backend:url_request(region.httpLatencyUrl, {
					use_curl_multi_handle = false
				})):next(function (result)
					local result1 = result[1].response_time
					local result2 = result[2].response_time
					local latency = nil

					if not result1 or not result2 then
						Log.error("RegionLatency", "Cant measure latency, response_time is nil")

						latency = -1
					else
						latency = math.ceil((result1 + result2) / 2 * 1000)
					end

					return {
						region = region.region,
						latency = latency
					}
				end)
			end):catch(function (e)
				return {
					latency = -1,
					region = region
				}
			end)

			table.insert(promises, promise)
		end

		return Promise.all(unpack(promises))
	end):next(function (result)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-13, warpins: 1 ---
		Log.info("RegionLatency", "Refreshed region latencies: " .. table.tostring(result, 3))

		cached = result

		return
		--- END OF BLOCK #0 ---



	end):catch(function (e)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-12, warpins: 1 ---
		Log.error("RegionLatency", "Could not refresh latencies: " .. table.tostring(e, 3))

		return
		--- END OF BLOCK #0 ---



	end)
end

RegionLatency.get_cached_region_latencies = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return cached
	--- END OF BLOCK #0 ---



end

implements(RegionLatency, Interface)

return RegionLatency
