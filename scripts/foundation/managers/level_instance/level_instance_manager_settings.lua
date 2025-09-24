-- chunkname: @scripts/foundation/managers/level_instance/level_instance_manager_settings.lua

local CLIENT_RPCS = {
	"rpc_level_instance_spawn",
	"rpc_level_instance_destroy",
}
local SERVER_RPCS = {}
local level_instance_manager_settings = {
	client_rpcs = CLIENT_RPCS,
	server_rpcs = SERVER_RPCS,
}

return settings("LevelInstanceManagerSettings", level_instance_manager_settings)
