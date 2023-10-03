local TelemetryManagerTestify = {}

TelemetryManagerTestify.send_telemetry_batch = function (telemetry_manager)
	telemetry_manager:post_batch()
end

return TelemetryManagerTestify
