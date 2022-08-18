local ProfileSynchronizationManagerTestify = {
	equip_item = function (data, profile_synchronization_manager)
		local player = data.player
		local weapon = data.weapon
		local profile_synchronizer_host = profile_synchronization_manager:synchronizer_host()

		profile_synchronizer_host:override_slot(player:peer_id(), player:local_player_id(), weapon.slots[1], weapon.name)
	end,
	equip_item_backend = function (data, profile_synchronization_manager)
		local player = data.player
		local weapon = data.weapon

		Managers.backend.interfaces.characters:equip_item_slot_debug(player:character_id(), weapon.slots[1], weapon.name):next(function (v)
			local profile_synchronizer_host = profile_synchronization_manager:synchronizer_host()

			profile_synchronizer_host:profile_changed(player:peer_id(), player:local_player_id())
		end)
	end
}

return ProfileSynchronizationManagerTestify
