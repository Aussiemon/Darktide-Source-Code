-- chunkname: @scripts/managers/data_service/services/penance_track_service.lua

local Promise = require("scripts/foundation/utilities/promise")
local PenanceTrackService = class("PenanceTrackService")

PenanceTrackService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
	self._promise_cache = {}
end

PenanceTrackService.get_track = function (self, track_id)
	local promise_cache = self._promise_cache

	if not promise_cache[track_id] then
		promise_cache[track_id] = self._backend_interface.tracks:get_track(track_id):catch(function (error)
			promise_cache[track_id] = nil

			return Promise.rejected(error)
		end)
	end

	return promise_cache[track_id]:next(function (data)
		return data
	end)
end

return PenanceTrackService
