-- chunkname: @scripts/settings/stats/stat_network_types.lua

StatNetworkTypes = table.enum("u8bit", "u16bit", "u24bit")

return settings("StatNetworkTypes", StatNetworkTypes)
