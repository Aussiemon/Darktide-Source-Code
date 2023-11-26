-- chunkname: @scripts/managers/telemetry/telemetry_manager_testify.lua

local TelemetryManagerTestify = {
	send_telemetry_batch = function (telemetry_manager)
		telemetry_manager:post_batch()
	end
}

return TelemetryManagerTestify
