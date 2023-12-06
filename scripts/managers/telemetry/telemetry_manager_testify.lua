local TelemetryManagerTestify = {}

TelemetryManagerTestify.send_telemetry_batch = function (telemetry_manager)
	telemetry_manager:post_batch()
end

TelemetryManagerTestify.wait_for_batch_post = function (telemetry_manager)
	if telemetry_manager:batch_in_flight() then
		return Testify.RETRY
	end
end

return TelemetryManagerTestify
