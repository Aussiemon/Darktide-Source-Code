-- chunkname: @scripts/settings/equipment/local_items_loader.lua

local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local Promise = require("scripts/foundation/utilities/promise")
local LocalLoader = class("LocalLoader")
local strip_tags = Application.get_strip_tags_table()

local function _should_include_item(item, item_name)
	local feature_flag_on = false
	local accepted_workflow = item.workflow_state == "RELEASABLE"
	local is_fallback_item = item.is_fallback_item == true

	if table.size(item.feature_flags) == 0 then
		feature_flag_on = true
	else
		for _, feature_flag in pairs(item.feature_flags) do
			if strip_tags[feature_flag] == true then
				feature_flag_on = true

				break
			end
		end
	end

	return is_fallback_item or feature_flag_on and accepted_workflow
end

LocalLoader.QUERY_TIMEOUT_SECONDS = 60
LocalLoader.QUERY_POLL_INTERVAL_SECONDS = 0.1

if VIRTUAL_MACHINE then
	LocalLoader.QUERY_TIMEOUT_SECONDS = 120
end

LocalLoader._wait_for_query = function (query_handle, timeout_s, start_time)
	start_time = start_time or Managers and Managers.time:time("main") or 0

	local results = Metadata.claim_results(query_handle)

	if not results then
		local now = Managers and Managers.time:time("main") or 0

		if timeout_s < now - start_time then
			Log.error("LocalLoader", "Timed out waiting for RMD data from engine. Query deadlocked?")
			error("Timed out waiting for RMD data from engine. Query deadlocked?")
		end

		return Promise.delay(LocalLoader.QUERY_POLL_INTERVAL_SECONDS):next(function ()
			return LocalLoader._wait_for_query(query_handle, timeout_s, start_time)
		end)
	else
		local now = Managers and Managers.time:time("main") or 0

		Log.info("LocalLoader", "Query finished, took %f seconds", now - start_time)
	end

	return Promise.resolved(results)
end

LocalLoader.get_items_from_metadata_db = function ()
	Log.debug("LocalLoader", "Reading local items")

	local merged_items = {}

	Log.debug("LocalLoader", "Reading items from RMD")

	local query_handle = Metadata.execute_query_deferred({
		type = "item",
	}, {
		include_properties = true,
	})

	return Promise.delay(0):next(function ()
		return LocalLoader._wait_for_query(query_handle, LocalLoader.QUERY_TIMEOUT_SECONDS)
	end):next(function (resources)
		local sorted_items = {}

		for k, v in pairs(resources) do
			table.insert(sorted_items, {
				k,
				v,
			})
		end

		table.sort(sorted_items, function (p1, p2)
			return p1[1] < p2[1]
		end)

		local count = 0

		for i, p in ipairs(sorted_items) do
			local k, v = unpack(p)
			local item

			if not v or v == "" then
				Log.error("LocalLoader", "Properties for %s unexpectedly empty", k)

				item = {}
			else
				item = cjson.decode(v)
			end

			table.set_readonly(item)

			if _should_include_item(item, k) then
				count = count + 1
				merged_items[k] = item
			end
		end

		Log.info("LocalLoader", "Added %i items from RMD", count)

		return merged_items
	end)
end

return LocalLoader
