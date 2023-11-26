-- chunkname: @scripts/managers/loading/profile_synchronization_manager_testify.lua

local ProfileSynchronizationManagerTestify = {
	equip_item = function (profile_synchronization_manager, data)
		local player = data.player
		local item = data.item
		local profile_synchronizer_host = profile_synchronization_manager:synchronizer_host()

		profile_synchronizer_host:override_slot(player:peer_id(), player:local_player_id(), item.slots[1], item.name)
	end,
	equip_item_backend = function (profile_synchronization_manager, data)
		local item = data.item
		local player = data.player
		local peer_id = player:peer_id()
		local local_player_id = player:local_player_id()
		local connection_manager = Managers.connection
		local is_host = connection_manager:is_host()

		Managers.data_service.profiles:equip_item_slot_debug(player:character_id(), item.slots[1], item.name):next(function (v)
			if is_host then
				local profile_synchronizer_host = profile_synchronization_manager:synchronizer_host()

				profile_synchronizer_host:profile_changed(peer_id, local_player_id)
			else
				connection_manager:send_rpc_server("rpc_notify_profile_changed", peer_id, local_player_id)
			end
		end)
	end
}

return ProfileSynchronizationManagerTestify
