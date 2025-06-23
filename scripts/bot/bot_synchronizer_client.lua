-- chunkname: @scripts/bot/bot_synchronizer_client.lua

local RemotePlayer = require("scripts/managers/player/remote_player")
local ProfileUtils = require("scripts/utilities/profile_utils")
local BotSynchronizerClient = class("BotSynchronizerClient")
local RPCS = {
	"rpc_add_bot_player",
	"rpc_remove_bot_player"
}

BotSynchronizerClient.DEBUG_TAG = "Bot Sync Client"

local function _debug_print(str, ...)
	Log.info(BotSynchronizerClient.DEBUG_TAG, str, ...)
end

BotSynchronizerClient.init = function (self, peer_id, network_delegate, host_channel_id)
	self._network_delegate = network_delegate
	self._host_channel_id = host_channel_id

	network_delegate:register_connection_channel_events(self, host_channel_id, unpack(RPCS))
end

BotSynchronizerClient.destroy = function (self)
	self._network_delegate:unregister_channel_events(self._host_channel_id, unpack(RPCS))
end

BotSynchronizerClient.rpc_add_bot_player = function (self, channel_id, local_player_id, slot)
	local peer_id = Network.peer_id(channel_id)
	local player_manager = Managers.player

	if player_manager:player_exists(peer_id, local_player_id) then
		return
	end

	local profile_synchronizer_client = Managers.profile_synchronization:synchronizer_client()
	local profile_json = profile_synchronizer_client:player_profile_json(peer_id, local_player_id)
	local profile = ProfileUtils.unpack_profile(profile_json)
	local human_controlled = false
	local is_server = false

	player_manager:add_bot_player(RemotePlayer, nil, peer_id, local_player_id, profile, slot, human_controlled, is_server)

	local package_synchronizer_client = Managers.package_synchronization:synchronizer_client()

	package_synchronizer_client:add_bot(peer_id, local_player_id)
end

BotSynchronizerClient.rpc_remove_bot_player = function (self, channel_id, local_player_id)
	local peer_id = Network.peer_id(channel_id)
	local player_manager = Managers.player

	if not player_manager:player_exists(peer_id, local_player_id) then
		return
	end

	player_manager:remove_player(peer_id, local_player_id)

	local package_synchronizer_client = Managers.package_synchronization:synchronizer_client()

	package_synchronizer_client:remove_bot(peer_id, local_player_id)
end

return BotSynchronizerClient
