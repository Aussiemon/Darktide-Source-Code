-- chunkname: @scripts/settings/voting/voting_templates/kick_from_mission_voting_template.lua

local InputUtils = require("scripts/managers/input/input_utils")
local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local OPTIONS = table.enum("yes", "no")
local RESULTS = table.enum("approved", "rejected")
local highlight_color = {
	255,
	239,
	193,
	82,
}
local yes_color = {
	yes_color_b = 255,
	yes_color_g = 255,
	yes_color_r = 255,
}

local function _cast_kick_vote(voting_id, vote)
	Managers.voting:cast_vote(voting_id, vote)
end

local function _close_voting_popup(voting_id)
	Managers.voting:remove_notification(voting_id)
end

local function _player_name(kicked_peer_id)
	local player_name = "John Doe"
	local players_at_peer = Managers.player:players_at_peer(kicked_peer_id)

	if players_at_peer then
		local player = players_at_peer[1]

		player_name = player:name()
	end

	return player_name
end

local function _instructions_text()
	local yes_input = InputUtils.input_text_for_current_input_device("View", "notification_option_a", false)
	local no_input = InputUtils.input_text_for_current_input_device("View", "notification_option_b", false)
	local context = {
		yes_input = InputUtils.apply_color_to_input_text(yes_input, highlight_color),
		no_input = InputUtils.apply_color_to_input_text(no_input, highlight_color),
	}

	return Localize("loc_party_kick_instructions_new", true, context)
end

local function _show_voting_popup(voting_id, kicked_peer_id)
	local player_name = _player_name(kicked_peer_id)
	local instructions_text = _instructions_text()
	local context = {
		player_name = InputUtils.apply_color_to_input_text(player_name, highlight_color),
	}
	local data = {
		show_timer = true,
		title = Localize("loc_party_kick_instructions_header", true, context),
		lines = {
			instructions_text,
		},
		inputs = {
			notification_option_a = callback(_cast_kick_vote, voting_id, OPTIONS.yes),
			notification_option_b = callback(_cast_kick_vote, voting_id, OPTIONS.no),
		},
	}

	Managers.voting:create_notification(voting_id, data)
end

local function _update_voting_popup(voting_id, kicked_peer_id)
	local player_name = _player_name(kicked_peer_id)
	local post_vote_message = Localize("loc_party_kick_instructions_yes_vote", true, yes_color)
	local context = {
		player_name = InputUtils.apply_color_to_input_text(player_name, highlight_color),
	}
	local data = {
		show_timer = true,
		title = Localize("loc_party_kick_instructions_header", true, context),
		lines = {
			post_vote_message,
		},
		inputs = {},
	}

	Managers.voting:modify_notification(voting_id, data)
end

local kick_from_mission_voting_template = {
	abort_on_member_joined = true,
	abort_on_member_left = true,
	can_change_vote = false,
	duration = 30,
	name = "kick_from_mission",
	retry_delay = 70,
	rpc_request_voting = "rpc_request_voting_kick_player",
	rpc_start_voting = "rpc_start_voting_kick_player",
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
		"kick_peer_id",
	},
	pack_params = function (params)
		return params.kick_peer_id
	end,
	unpack_params = function (kick_peer_id)
		return {
			kick_peer_id = kick_peer_id,
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
	can_start = function (params)
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

		if num_voters < min_num_voters then
			return false, "not enough players"
		end

		local mission_manager = Managers.mission_server

		if mission_manager then
			local can_kick, denied_reason = mission_manager:can_kick_from_mission(params.kick_peer_id)

			if not can_kick then
				return false, denied_reason
			end
		end

		return true
	end,
	initial_votes = function (params, voting_initiator_peer)
		return {
			[voting_initiator_peer] = OPTIONS.yes,
			[params.kick_peer_id] = OPTIONS.yes,
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
		_close_voting_popup(voting_id)

		local peer_id = Network.peer_id()

		if result == RESULTS.approved then
			local kick_peer_id = params.kick_peer_id
			local connection_manager = Managers.connection
			local is_host = connection_manager:is_host()

			if is_host then
				if Managers.mission_server then
					Managers.mission_server:kick_from_mission(kick_peer_id, "vote_kick")
				else
					connection_manager:kick(kick_peer_id, "vote_kick")
				end
			end
		elseif params.kick_peer_id ~= peer_id then
			Managers.event:trigger("event_add_notification_message", "default", Localize("loc_party_kick_instructions_vote_not_passed"))
		end
	end,
	on_aborted = function (voting_id, template, params, abort_reason)
		_close_voting_popup(voting_id)
	end,
	on_vote_casted = function (voting_id, template, voter_peer_id, vote_option, params)
		local kick_peer_id = params.kick_peer_id

		if voter_peer_id == Network.peer_id() and vote_option == OPTIONS.yes then
			_update_voting_popup(voting_id, kick_peer_id)
		end
	end,
}

return kick_from_mission_voting_template
