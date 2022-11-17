local FrameRateManager = class("FrameRateManager")
local INVERTED_FIXED_TIME_STEP = 1 / GameParameters.fixed_time_step

FrameRateManager.init = function (self)
	self._reasons = {}
	self._num_reasons = 0

	Application.set_time_step_policy(unpack(GameParameters.time_step_policy))

	local fps = DEDICATED_SERVER and INVERTED_FIXED_TIME_STEP or 60

	Log.info("FrameRateManager", "Initializing framerate cap to %i fps.", fps)
	Application.set_time_step_policy("throttle", fps)
end

FrameRateManager.relinquish_request = function (self, reason)
	self._reasons[reason] = nil
	self._num_reasons = self._num_reasons - 1

	if self._num_reasons == 0 then
		local fps = DEDICATED_SERVER and INVERTED_FIXED_TIME_STEP or 60

		Log.info("FrameRateManager", "Reason %q relinquished, Setting frame rate to %d", reason, fps)
		Application.set_time_step_policy("throttle", fps)
	else
		Log.info("FrameRateManager", "Reason %q relinquished.", reason)
	end
end

FrameRateManager.request_full_frame_rate = function (self, reason)
	self._reasons[reason] = true

	if self._num_reasons == 0 then
		self._num_reasons = 1
		local fps = DEDICATED_SERVER and INVERTED_FIXED_TIME_STEP or 0

		Log.info("FrameRateManager", "Reason %q requested. Setting frame rate to %d", reason, fps)

		if not DEDICATED_SERVER and not Application.render_caps("reflex_supported") then
			fps = Application.render_config("settings", "nv_framerate_cap")
		end

		Application.set_time_step_policy("throttle", fps)
	else
		self._num_reasons = self._num_reasons + 1

		Log.info("FrameRateManager", "Reason %q requested.", reason)
	end
end

return FrameRateManager
