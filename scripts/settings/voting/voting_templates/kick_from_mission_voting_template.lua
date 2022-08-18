local PlayerCompositions = require("scripts/utilities/players/player_compositions")
local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local OPTIONS = table.enum("yes", "no")
local RESULTS = table.enum("approved", "rejected")
local popup_id = StrictNil

local function _cast_kick_vote(voting_id, vote)
	Managers.voting:cast_vote(voting_id, vote)
end

local function _close_voting_popup()
	if popup_id ~= StrictNil then
		Managers.event:trigger("event_remove_ui_popup", popup_id)

		popup_id = StrictNil
	end
end

local function _show_voting_popup(voting_id, peer_id)
	if popup_id ~= StrictNil then
		_close_voting_popup()
	end

	local players_at_peer = Managers.player:players_at_peer(peer_id)
	local player_name = "John Doe"

	if players_at_peer then
		local player = players_at_peer[1]
		player_name = player:name()
	else
		local human_players = Managers.player:human_players()
		player_name = "John Doe"
	end

	local context = {
		title_text = "loc_party_kick_vote_header",
		description_text = "loc_party_kick_vote_description",
		description_text_params = {
			player_name = player_name
		},
		options = {
			{
				text = "loc_party_kick_vote_vote_to_kick",
				close_on_pressed = true,
				hotkey = "confirm_pressed",
				callback = function ()
					_cast_kick_vote(voting_id, OPTIONS.yes)
				end
			},
			{
				text = "loc_party_kick_vote_vote_to_keep",
				close_on_pressed = true,
				hotkey = "back",
				callback = function ()
					_cast_kick_vote(voting_id, OPTIONS.no)
				end
			}
		}
	}

	Managers.event:trigger("event_show_ui_popup", context, function (id)
		popup_id = id
	end)
end

local kick_from_mission_voting_template = {
	rpc_start_voting = "rpc_start_voting_kick_player",
	can_change_vote = false,
	name = "kick_from_mission",
	duration = 30,
	voting_impl = "network",
	abort_on_member_joined = true,
	abort_on_member_left = true,
	rpc_request_voting = "rpc_request_voting_kick_player",
	options = {
		OPTIONS.yes,
		OPTIONS.no
	},
	results = {
		RESULTS.approved,
		RESULTS.rejected
	},
	timeout_option = OPTIONS.no,
	required_params = {
		"kick_peer_id"
	},
	pack_params = function (params)
		return params.kick_peer_id
	end,
	unpack_params = function (kick_peer_id)
		return {
			kick_peer_id = kick_peer_id
		}
	end,
	evaluate = function (votes)
		local waiting_for_vote = false

		for _, option in pairs(votes) do
			if option == OPTIONS.no then
				return RESULTS.rejected
			elseif option == StrictNil then
				waiting_for_vote = true
			end
		end

		if waiting_for_vote then
			return nil
		else
			return RESULTS.approved
		end
	end,
	network_interface = function ()
		return Managers.connection
	end,
	can_start = function ()
		local min_num_voters = SocialConstants.min_num_party_members_to_vote
		local is_in_mission = Managers.data_service.social:is_in_mission()

		if not is_in_mission then
			return false, "not in mission"
		end

		local connection_manager = Managers.connection
		local num_voters = connection_manager:num_members()

		if not connection_manager:host_is_dedicated_server() then
			num_voters = num_voters + 1
		end

		if min_num_voters > num_voters then
			return false, "not enough players"
		end

		return true
	end,
	initial_votes = function (params, voting_initiator_peer)
		return {
			[voting_initiator_peer] = OPTIONS.yes,
			[params.kick_peer_id] = OPTIONS.yes
		}
	end,
	on_started = function (voting_id, template, params)
		local my_peer_id = Network.peer_id()

		if not Managers.voting:has_voted(voting_id, my_peer_id) then
			local peer_id = params.kick_peer_id

			_show_voting_popup(voting_id, peer_id)
		end
	end,
	on_completed = function (voting_id, template, params, result)
		_close_voting_popup()

		if result == RESULTS.approved then
			local kick_peer_id = params.kick_peer_id
			local is_kicked_peer = kick_peer_id == Network.peer_id()
			local connection_manager = Managers.connection
			local is_host = connection_manager:is_host()

			if is_host then
				if Managers.mission_server then
					Managers.mission_server:kick_from_mission(kick_peer_id)
				else
					connection_manager:disconnect(kick_peer_id)
				end
			end

			if is_kicked_peer then
				Managers.party_immaterium:leave_party()
			end
		end
	end,
	on_aborted = function (voting_id, template, params, abort_reason)
		_close_voting_popup()
	end,
	on_vote_casted = function (voting_id, template, voter_peer_id, vote_option)
		return
	end
}

return kick_from_mission_voting_template
