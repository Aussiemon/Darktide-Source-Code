local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local Promise = require("scripts/foundation/utilities/promise")
local LocalLoader = class("LocalLoader")

function _should_include_item(item)
	return item.workflow_state == "BLOCKOUT" or item.workflow_state == "PROTOTYPE" or item.workflow_state == "FUNCTIONAL" or item.workflow_state == "SHIPPABLE" or item.workflow_state == "RELEASABLE"
end

LocalLoader.QUERY_TIMEOUT_SECONDS = 60
LocalLoader.QUERY_POLL_INTERVAL_SECONDS = 0.1

LocalLoader._wait_for_query = function (query_handle, timeout_s, start_time)
	start_time = start_time or (Managers and Managers.time:time("main")) or 0
	local results = Metadata.claim_results(query_handle)

	if not results then
		local now = (Managers and Managers.time:time("main")) or 0

		if timeout_s < now - start_time then
			Log.error("LocalLoader", "Timed out waiting for RMD data from engine. Query deadlocked?")
			Application.crash("deadlock")
		end

		return Promise.delay(LocalLoader.QUERY_POLL_INTERVAL_SECONDS):next(function ()
			return LocalLoader._wait_for_query(query_handle, timeout_s, start_time)
		end)
	else
		local now = (Managers and Managers.time:time("main")) or 0

		Log.info("LocalLoader", "Query finished, took %f seconds", now - start_time)
	end

	return Promise.resolved(results)
end

LocalLoader.get_items_from_metadata_db = function ()
	Log.debug("LocalLoader", "Reading local items")

	local merged_items = {}

	Log.debug("LocalLoader", "Reading items from RMD")

	local query_handle = Metadata.execute_query_deferred({
		type = "item"
	}, {
		include_properties = true
	})

	return Promise.delay(0):next(function ()
		return LocalLoader._wait_for_query(query_handle, LocalLoader.QUERY_TIMEOUT_SECONDS)
	end):next(function (resources)
		local sorted_items = {}

		for k, v in pairs(resources) do
			table.insert(sorted_items, {
				k,
				v
			})
		end

		table.sort(sorted_items, function (p1, p2)
			return p1[1] < p2[1]
		end)

		local count = 0

		for i, p in ipairs(sorted_items) do
			local k, v = unpack(p)
			local item = nil

			if not v or v == "" then
				Log.error("LocalLoader", "Properties for %s unexpectedly empty", k)

				item = {}
			else
				item = cjson.decode(v)
			end

			if _should_include_item(item) then
				count = count + 1
				merged_items[k] = item
			end
		end

		Log.info("LocalLoader", "Added %i items from RMD", count)

		return merged_items
	end)
end

return LocalLoader
