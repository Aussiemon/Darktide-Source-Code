-- chunkname: @scripts/utilities/player_assist_notifications.lua

local PlayerAssistNotifications = {}

PlayerAssistNotifications.show_notification = function (assisted_unit, assisting_unit, assist_type)
	if assisted_unit == assisting_unit then
		return
	end

	if not assisting_unit or not ALIVE[assisting_unit] then
		return
	end

	local assiting_player = Managers.state.player_unit_spawn:owner(assisting_unit)

	if not assiting_player then
		return
	end

	if not assiting_player:is_human_controlled() then
		return
	end

	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local peer_id = assiting_player:peer_id()
	local assist_type_lookup = NetworkLookup.assist_type_lookup[assist_type]
	local assisted_player = player_unit_spawn_manager:owner(assisted_unit)
	local assisted_player_channel_id = assisted_player:channel_id()

	if assisted_player_channel_id then
		RPC.rpc_player_assisted(assisted_player_channel_id, peer_id, assist_type_lookup)
	elseif not DEDICATED_SERVER and Managers.player:local_player(1).player_unit == assisted_unit then
		Managers.player:_show_assist_notification(peer_id, assist_type)
	end
end

return PlayerAssistNotifications
