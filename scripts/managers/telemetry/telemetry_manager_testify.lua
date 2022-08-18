local TelemetryManagerTestify = {
	send_telemetry_batch = function (_, telemetry_manager)
		telemetry_manager:post_batch()
	end
}

return TelemetryManagerTestify
