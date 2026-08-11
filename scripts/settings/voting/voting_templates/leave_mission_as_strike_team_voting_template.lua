-- chunkname: @scripts/settings/voting/voting_templates/leave_mission_as_strike_team_voting_template.lua

local InputUtils = require("scripts/managers/input/input_utils")
local Promise = require("scripts/foundation/utilities/promise")
local OPTIONS = table.enum("yes", "no")
local RESULTS = table.enum("approved", "rejected")
local highlight_color = {
	255,
	239,
	193,
	82,
}
local _strike_team_peer_ids_for_active_vote

local function _cast_vote(voting_id, vote)
	Managers.voting:cast_vote(voting_id, vote)
end

local function _close_voting_notification(voting_id)
	Managers.voting:unset_notification(voting_id)
end

local function _player_name(peer_id)
	local players_at_peer = Managers.player:players_at_peer(peer_id)

	if players_at_peer then
		local player = players_at_peer[1]

		if player then
			return player:name()
		end
	end

	return "Unknown"
end

local function _description_text()
	local leave_input = InputUtils.input_text_for_current_input_device("View", "notification_option_a", false)
	local stay_input = InputUtils.input_text_for_current_input_device("View", "notification_option_b", false)
	local context = {
		leave_input = InputUtils.apply_color_to_input_text(leave_input, highlight_color),
		stay_input = InputUtils.apply_color_to_input_text(stay_input, highlight_color),
	}

	return Localize("loc_leave_mission_as_strike_team_notification_description", true, context)
end

local function _show_voting_notification(voting_id, initiator_peer_id)
	local player_name = _player_name(initiator_peer_id)
	local context = {
		player_name = InputUtils.apply_color_to_input_text(player_name, highlight_color),
	}
	local data = {
		keep_alive = false,
		show_timer = true,
		title = Localize("loc_leave_mission_as_strike_team_notification_title", true, context),
		description = _description_text(),
		inputs = {
			notification_option_a = callback(_cast_vote, voting_id, OPTIONS.yes),
			notification_option_b = callback(_cast_vote, voting_id, OPTIONS.no),
		},
	}

	Managers.voting:set_notification(voting_id, data)
end

local function _show_initiator_waiting_notification(voting_id)
	local data = {
		keep_alive = false,
		show_timer = true,
		title = Localize("loc_leave_mission_as_strike_team_initiator_notification_title"),
	}

	Managers.voting:set_notification(voting_id, data)
end

local function _is_strike_team_peer(peer_id, strike_team_peer_ids)
	for i = 1, #strike_team_peer_ids do
		if strike_team_peer_ids[i] == peer_id then
			return true
		end
	end

	return false
end

local leave_mission_as_strike_team_voting_template = {
	abort_on_member_joined = false,
	abort_on_member_left = false,
	can_change_vote = false,
	duration = 15,
	evaluate_delay = nil,
	name = "leave_mission_as_strike_team",
	retry_delay = 30,
	rpc_request_voting = "rpc_request_voting_leave_mission_as_strike_team",
	rpc_start_voting = "rpc_start_voting_leave_mission_as_strike_team",
	voting_impl = "network",
	options = {
		OPTIONS.yes,
		OPTIONS.no,
	},
	results = {
		RESULTS.approved,
		RESULTS.rejected,
	},
	timeout_option = OPTIONS.no,
	required_params = {
		"initiator_peer_id",
		"strike_team_peer_ids",
		"new_party_id",
		"new_party_invite_token",
	},
	pack_params = function (params)
		return params.initiator_peer_id, params.strike_team_peer_ids, params.new_party_id, params.new_party_invite_token
	end,
	unpack_params = function (initiator_peer_id, strike_team_peer_ids, new_party_id, new_party_invite_token)
		return {
			initiator_peer_id = initiator_peer_id,
			strike_team_peer_ids = strike_team_peer_ids,
			new_party_id = new_party_id,
			new_party_invite_token = new_party_invite_token,
		}
	end,
	evaluate = function (votes, duration_ended)
		local strike_team_peer_ids = _strike_team_peer_ids_for_active_vote

		if not strike_team_peer_ids then
			return nil
		end

		local any_yes = false
		local any_undecided = false

		for peer_id, option in pairs(votes) do
			if _is_strike_team_peer(peer_id, strike_team_peer_ids) then
				if option == StrictNil then
					any_undecided = true
				elseif option == OPTIONS.yes then
					any_yes = true
				end
			end
		end

		if any_undecided then
			return nil
		end

		return any_yes and RESULTS.approved or RESULTS.rejected
	end,
	network_interface = function ()
		return Managers.connection
	end,
	can_start = function (params)
		local is_in_mission = Managers.data_service.social:is_in_mission()

		if not is_in_mission then
			return false, "not in mission"
		end

		if not params.strike_team_peer_ids or #params.strike_team_peer_ids < 2 then
			return false, "not enough strike team members in mission"
		end

		local initiator_in_list = false

		for i = 1, #params.strike_team_peer_ids do
			if params.strike_team_peer_ids[i] == params.initiator_peer_id then
				initiator_in_list = true

				break
			end
		end

		if not initiator_in_list then
			return false, "initiator not in strike team peer list"
		end

		if not params.new_party_id or params.new_party_id == "" then
			return false, "missing new party id"
		end

		return true
	end,
	initial_votes = function (params, voting_initiator_peer)
		return {
			[voting_initiator_peer] = OPTIONS.yes,
		}
	end,
	on_started = function (voting_id, template, params)
		_strike_team_peer_ids_for_active_vote = params.strike_team_peer_ids

		local my_peer_id = Network.peer_id()

		if my_peer_id == params.initiator_peer_id then
			_show_initiator_waiting_notification(voting_id)

			return
		end

		if not _is_strike_team_peer(my_peer_id, params.strike_team_peer_ids) then
			return
		end

		if not Managers.voting:has_voted(voting_id, my_peer_id) then
			_show_voting_notification(voting_id, params.initiator_peer_id)
		end
	end,
	on_completed = function (voting_id, template, params, result)
		_close_voting_notification(voting_id)

		_strike_team_peer_ids_for_active_vote = nil

		if result == RESULTS.approved then
			local votes = Managers.voting:votes(voting_id)
			local my_peer_id = Network.peer_id()
			local my_vote = votes and votes[my_peer_id]

			if my_vote == OPTIONS.yes then
				local yes_voter_account_ids = {}

				for _, peer_id in ipairs(params.strike_team_peer_ids) do
					if votes[peer_id] == OPTIONS.yes then
						local players_at_peer = Managers.player:players_at_peer(peer_id)

						if players_at_peer then
							for _, player in pairs(players_at_peer) do
								local account_id = player:account_id()

								if account_id and account_id ~= "" then
									yes_voter_account_ids[account_id] = true
								end
							end
						end
					end
				end

				Managers.party_immaterium:mark_leaving_mission_as_strike_team(params.new_party_id, yes_voter_account_ids)
				Managers.party_immaterium:join_party({
					stay_in_party_join = true,
					party_id = params.new_party_id,
					invite_token = params.new_party_invite_token,
				}):next(function ()
					Promise.delay(2):next(function ()
						Managers.party_immaterium:latched_hub_server_matchmaking()
					end)
				end)
				Managers.multiplayer_session:leave("leave_mission_as_strike_team")
			end
		end
	end,
	on_aborted = function (voting_id, template, params, abort_reason)
		_close_voting_notification(voting_id)

		_strike_team_peer_ids_for_active_vote = nil
	end,
	on_vote_casted = function (voting_id, template, voter_peer_id, vote_option, params)
		local my_peer_id = Network.peer_id()

		if voter_peer_id == my_peer_id then
			_close_voting_notification(voting_id)
		end
	end,
}

return leave_mission_as_strike_team_voting_template
