local ServerMetricsManagerDummy = class("DummyServerMetricsManager")
local ServerMetricsManagerInterface = require("scripts/managers/server_metrics/server_metrics_manager_interface")

ServerMetricsManagerDummy.init = function (self)
	return
end

ServerMetricsManagerDummy.destroy = function (self)
	return
end

ServerMetricsManagerDummy.add_annotation = function (self, type_name, metadata)
	return
end

ServerMetricsManagerDummy.set_gauge = function (self, metric_name, value)
	return
end

ServerMetricsManagerDummy.update = function (self, dt)
	return
end

implements(ServerMetricsManagerDummy, ServerMetricsManagerInterface)

return ServerMetricsManagerDummy
