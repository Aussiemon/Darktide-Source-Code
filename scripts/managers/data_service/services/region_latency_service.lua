-- chunkname: @scripts/managers/data_service/services/region_latency_service.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local RegionLatencyService = class("RegionLatencyService")

RegionLatencyService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
	self._promise = nil
end

RegionLatencyService.destroy = function (self)
	self:reset()
end

RegionLatencyService.reset = function (self)
	if self._promise and self._promise:is_pending() then
		self._promise:cancel()
	end

	self._promise = nil
end

RegionLatencyService._backend_data = function (self)
	if self._promise and not self._promise:is_rejected() then
		return self._promise
	end

	self._promise = self._backend_interface.region_latency:matchmaker_regions()

	return self._promise
end

RegionLatencyService.reload_cache = function (self)
	self:reset()

	return self:_backend_data()
end

RegionLatencyService.get_region_latencies = function (self)
	return self:_backend_data():next(function (result)
		return result.region_latencies
	end)
end

RegionLatencyService.get_preferred_reef = function (self)
	return self:_backend_data():next(function (result)
		return result.preferred_reef
	end)
end

RegionLatencyService._get_reef_info_based_on_region_latencies = function (self, region_latencies)
	local reefs = {}

	for i, region_latency in ipairs(region_latencies) do
		for _, reef_name in ipairs(region_latency.reefs) do
			local reef = reefs[reef_name]

			if not reef then
				reef = {}
				reefs[reef_name] = reef
			end

			if not reef.min_latency or reef.min_latency > region_latency.latency then
				reef.min_latency = region_latency.latency
			end

			if not reef.max_latency or reef.max_latency < region_latency.latency then
				reef.max_latency = region_latency.latency
			end
		end
	end

	return reefs
end

RegionLatencyService.fetch_regions_latency = function (self)
	return self:get_region_latencies():next(function (regions_data)
		local region_latencies = self:_get_reef_info_based_on_region_latencies(regions_data)
		local currently_preferred_region = BackendUtilities.prefered_mission_region

		if currently_preferred_region and currently_preferred_region ~= "" and region_latencies[currently_preferred_region] then
			return region_latencies
		end

		local fallback_region = regions_data[1].reefs[1]

		return self:get_preferred_reef():next(function (preferred_region)
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
