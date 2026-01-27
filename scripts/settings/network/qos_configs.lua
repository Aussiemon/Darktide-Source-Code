-- chunkname: @scripts/settings/network/qos_configs.lua

local QoSConfigs = {}

QoSConfigs.default = {
	enable = true,
}
QoSConfigs.lowest = {
	enable = true,
	max_fill_rate_kbps = 128,
	min_fill_rate_kbps = 128,
}
QoSConfigs.low = {
	enable = true,
	max_fill_rate_kbps = 256,
	min_fill_rate_kbps = 128,
}
QoSConfigs.medium = {
	enable = true,
	max_fill_rate_kbps = 512,
	min_fill_rate_kbps = 128,
}
QoSConfigs.high = {
	enable = true,
	max_fill_rate_kbps = 1024,
	min_fill_rate_kbps = 256,
}
QoSConfigs.highest = {
	enable = true,
	max_fill_rate_kbps = 1536,
	min_fill_rate_kbps = 512,
}

return QoSConfigs
