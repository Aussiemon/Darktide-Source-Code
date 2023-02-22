local ProfileSynchronizationManagerTestify = {}

ProfileSynchronizationManagerTestify.equip_item = function (data, profile_synchronization_manager)
	local player = data.player
	local item = data.item
	local profile_synchronizer_host = profile_synchronization_manager:synchronizer_host()

	profile_synchronizer_host:override_slot(player:peer_id(), player:local_player_id(), item.slots[1], item.name)
end

ProfileSynchronizationManagerTestify.equip_item_backend = function (data, profile_synchronization_manager)
	local item = data.item
	local player = data.player
	local peer_id = player:peer_id()
	local local_player_id = player:local_player_id()
	local is_server = Managers.state.game_session:is_server()

	Managers.data_service.profiles:equip_item_slot_debug(player:character_id(), item.slots[1], item.name):next(function (v)
		if is_server then
			local profile_synchronizer_host = profile_synchronization_manager:synchronizer_host()

			profile_synchronizer_host:profile_changed(peer_id, local_player_id)
		else
			Managers.connection:send_rpc_server("rpc_notify_profile_changed", peer_id, local_player_id)
		end
	end)
end

return ProfileSynchronizationManagerTestify
