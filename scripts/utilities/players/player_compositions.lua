﻿-- chunkname: @scripts/utilities/players/player_compositions.lua

local PlayerCompositions = {}

PlayerCompositions.players = function (composition_name, result_table, dont_clear_table)
	if not dont_clear_table then
		table.clear(result_table)
	end

	if composition_name == "players" then
		local players = Managers.player:players()

		for unique_id, player in pairs(players) do
			result_table[unique_id] = player
		end
	elseif composition_name == "game_session_players" then
		local game_session_peers = Managers.state.game_session:joined_peers()
		local players = Managers.player:players()

		for unique_id, player in pairs(players) do
			if game_session_peers[player:peer_id()] then
				result_table[unique_id] = player
			end
		end
	elseif composition_name == "party" then
		local local_player_id = 1
		local local_player = Managers.player:player(Network.peer_id(), local_player_id)

		if local_player then
			result_table[local_player:unique_id()] = local_player
		end

		local party_members

		if GameParameters.prod_like_backend then
			party_members = Managers.party_immaterium:other_members()
		end

		if party_members then
			for _, party_member in pairs(party_members) do
				result_table[party_member:unique_id()] = party_member
			end
		end
	end

	return result_table
end

PlayerCompositions.player_composition_changed_event = "player_composition_changed"

PlayerCompositions.trigger_change_event = function (composition_name)
	Managers.event:trigger(PlayerCompositions.player_composition_changed_event, composition_name)
end

PlayerCompositions.player_from_unique_id = function (composition_name, unique_id)
	if composition_name == "players" or composition_name == "game_session_players" then
		return Managers.player:player_from_unique_id(unique_id)
	elseif composition_name == "party" and GameParameters.prod_like_backend then
		return Managers.player:player_from_unique_id(unique_id) or Managers.party_immaterium:other_member_from_unique_id(unique_id)
	end
end

PlayerCompositions.party_member_by_peer_id = function (peer_id)
	if GameParameters.prod_like_backend then
		return Managers.party_immaterium:member_from_peer_id(peer_id)
	end
end

return PlayerCompositions
