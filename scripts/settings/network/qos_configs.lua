-- chunkname: @scripts/settings/network/qos_configs.lua

local QoSConfigs = {}

QoSConfigs.default = {
	enable = true,
}
QoSConfigs.tolerant = {
	["congestion_signals.loss_ratio.full_congestion"] = 0.08,
	["congestion_signals.loss_ratio.noise"] = 0.02,
	enable = true,
	min_fill_rate_kbps = 256,
}

return QoSConfigs
