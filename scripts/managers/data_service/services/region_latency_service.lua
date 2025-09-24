-- chunkname: @scripts/managers/data_service/services/region_latency_service.lua

local BackendError = require("scripts/managers/error/errors/backend_error")
local MasterItems = require("scripts/backend/master_items")
local ParameterResolver = require("scripts/foundation/utilities/parameters/parameter_resolver")
local Promise = require("scripts/foundation/utilities/promise")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local RegionLatencyService = class("RegionLatencyService")

RegionLatencyService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
end

RegionLatencyService.fetch_regions_latency = function (self)
	local backend_latency = self._backend_interface.region_latency

	return backend_latency:get_region_latencies():next(function (regions_data)
		local region_latencies = backend_latency:get_reef_info_based_on_region_latencies(regions_data)
		local currently_preferred_region = BackendUtilities.prefered_mission_region

		if currently_preferred_region and currently_preferred_region ~= "" and region_latencies[currently_preferred_region] then
			return region_latencies
		end

		local fallback_region = regions_data[1].reefs[1]

		return backend_latency:get_preferred_reef():next(function (preferred_region)
			preferred_region = preferred_region or fallback_region
			BackendUtilities.prefered_mission_region = preferred_region

			return region_latencies
		end):catch(function ()
			BackendUtilities.prefered_mission_region = fallback_region

			return region_latencies
		end)
	end):catch(function ()
		Log.error("RegionLatencyService", "Fetching server regions failed")
	end)
end

RegionLatencyService.get_prefered_mission_region = function (self)
	return BackendUtilities.prefered_mission_region
end

RegionLatencyService.set_prefered_mission_region = function (self, value)
	BackendUtilities.prefered_mission_region = value
end

return RegionLatencyService
