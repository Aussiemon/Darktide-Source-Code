local Promise = require("scripts/foundation/utilities/promise")
local PenanceTrackService = class("PenanceTrackService")

PenanceTrackService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
	self._cached_track_data = nil
end

PenanceTrackService.get_track = function (self, trackId)
	local promise = nil

	if self._cached_track_data then
		promise = Promise.resolved(self._cached_track_data):next(function (data)
			return self._cached_track_data
		end)
	else
		promise = self._backend_interface.tracks:get_track(trackId):next(function (data)
			self._cached_track_data = data

			return data
		end):catch(function (error)
			local error_string = tostring(error)

			Log.error("PenanceTrackService", "Error fetching penance track: %s", error_string)

			return {}
		end)
	end

	return promise:next(function (data)
		return data
	end)
end

return PenanceTrackService
