local PresenceSettings = require("scripts/settings/presence/presence_settings")
local VotingNetworkInterface = require("scripts/managers/voting/voting_network_interface")

local function _info(...)
	Log.info("PartyManagerDummy", ...)
end

local PartyManagerDummy = class("PartyManagerDummy")

PartyManagerDummy.init = function (self, network_hash, platform, event_delegate, approve_channel_delegate, initial_presence_name)
	self:set_presence(initial_presence_name)
end

PartyManagerDummy.destroy = function (self)
	return
end

PartyManagerDummy.leave = function (self)
	return
end

PartyManagerDummy.is_host = function (self)
	return true
end

PartyManagerDummy.is_client = function (self)
	return false
end

PartyManagerDummy.is_booting = function (self)
	return false
end

PartyManagerDummy.state = function (self)
	return "host"
end

PartyManagerDummy.member_peers = function (self)
	return {}
end

PartyManagerDummy.num_members = function (self)
	return 0
end

PartyManagerDummy.members = function (self)
	return {}
end

PartyManagerDummy.member_including_local = function (self)
	return nil
end

PartyManagerDummy.member_from_unique_id = function (self, unique_id)
	return nil
end

PartyManagerDummy.peer_to_channel = function (self, peer_id)
	return nil
end

PartyManagerDummy.channel_to_peer = function (self, peer_id)
	return nil
end

PartyManagerDummy.host_peer = function (self)
	return nil
end

PartyManagerDummy.host_channel = function (self)
	return nil
end

PartyManagerDummy.member = function (self, peer_id)
	return nil
end

PartyManagerDummy.local_member = function (self)
	return nil
end

PartyManagerDummy.engine_lobby_id = function (self)
	return nil
end

PartyManagerDummy.network_event_delegate = function (self)
	return nil
end

PartyManagerDummy.send_rpc_host = function (self, rpc_name, ...)
	return
end

PartyManagerDummy.send_rpc_clients = function (self, rpc_name, ...)
	return
end

PartyManagerDummy.send_rpc_clients_except = function (self, rpc_name, except_channel_id, ...)
	return
end

PartyManagerDummy.register_event_listener = function (self, object, event_name, func)
	return
end

PartyManagerDummy.unregister_event_listener = function (self, object, event_name)
	return
end

PartyManagerDummy.allow_new_members = function (self)
	return false, ""
end

PartyManagerDummy.update = function (self, dt, t)
	return
end

PartyManagerDummy.wanted_mission_selected = function (self, backend_mission_id)
	if Managers.multiplayer_session:is_booting_session() then
		_info("Wanted mission rejected, already in process of booting a multiplayer session")
	else
		local initiator_peer = Network.peer_id()

		Managers.multiplayer_session:party_host_join_mission_server(backend_mission_id, initiator_peer)
	end
end

PartyManagerDummy.set_current_server = function (self, host_type, lobby_id, matched_game_session_id)
	return
end

PartyManagerDummy.follow_party = function (self)
	return false
end

PartyManagerDummy.can_follow_party = function (self)
	return false
end

PartyManagerDummy.mission_matchmaking_started = function (self, mission_id)
	if not Managers.ui:view_active("lobby_view") then
		local transition_time = nil
		local close_previous = false
		local close_all = true
		local close_transition_time = nil
		local mission_name = NetworkLookup.missions[mission_id]
		local view_context = {
			preview = true,
			mission_data = {
				circumstance_name = "default",
				mission_name = mission_name
			}
		}

		Managers.ui:open_view("lobby_view", transition_time, close_previous, close_all, close_transition_time, view_context)
	end
end

PartyManagerDummy.mission_matchmaking_completed = function (self)
	return
end

PartyManagerDummy.mission_matchmaking_aborted = function (self)
	if Managers.ui:view_active("lobby_view") then
		Managers.ui:close_view("lobby_view")
	end
end

PartyManagerDummy.ready_voting_completed = function (self)
	if Managers.ui:view_active("lobby_view") then
		Managers.ui:close_view("lobby_view")
	end
end

PartyManagerDummy.set_presence = function (self, presence_name)
	if presence_name == self._presence_name then
		return
	end

	local settings = PresenceSettings[presence_name]

	fassert(settings, "Presence %q undefined", presence_name)

	self._presence_name = presence_name
	self._presence_id = NetworkLookup.presence_names[presence_name]
	local hud_localization = settings.hud_localization
	self._presence_hud_text = Managers.localization:localize(hud_localization)
end

PartyManagerDummy.presence_name = function (self)
	return self._presence_name
end

PartyManagerDummy.presence_id = function (self)
	return self._presence_id
end

PartyManagerDummy.presence_hud_text = function (self)
	return self._presence_hud_text
end

PartyManagerDummy.are_all_members_in_hub = function (self)
	if self._presence_name ~= "hub" then
		return false
	end

	return true
end

implements(PartyManagerDummy, VotingNetworkInterface)

return PartyManagerDummy
