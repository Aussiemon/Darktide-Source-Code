-- chunkname: @scripts/settings/voting/voting_templates/flow_voting_template.lua

local InputUtils = require("scripts/managers/input/input_utils")
local VotingFlowSettings = require("scripts/settings/voting/voting_flow_settings")
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

local function _cast_vote(voting_id, vote)
	Managers.voting:cast_vote(voting_id, vote)
end

local function _close_voting_popup(voting_id)
	Managers.voting:unset_notification(voting_id)
end

local function _finish_vote(params, result)
	if not Managers.state.game_session or not Managers.state.game_session:is_server() then
		return
	end

	local level = params.level
	local unit = params.unit
	local node_id = params.node_id

	if unit then
		Unit.flow_script_node_event(unit, node_id, result, true)
	else
		Level.trigger_script_node_event(level, node_id, result, true)
	end
end

local function _instructions_text(params)
	local yes_input = InputUtils.input_text_for_current_input_device("View", "notification_option_a", false)
	local no_input = InputUtils.input_text_for_current_input_device("View", "notification_option_b", false)
	local context = {
		yes_input = InputUtils.apply_color_to_input_text(yes_input, highlight_color),
		no_input = InputUtils.apply_color_to_input_text(no_input, highlight_color),
	}

	return Localize(VotingFlowSettings[params.flow_settings_name].instructions_text, true, context)
end

local function _show_voting_popup(voting_id, params)
	local instructions_text = _instructions_text(params)
	local data = {
		keep_alive = false,
		show_timer = true,
		title = Localize(VotingFlowSettings[params.flow_settings_name].title),
		description = instructions_text,
		inputs = {
			notification_option_a = callback(_cast_vote, voting_id, OPTIONS.yes),
			notification_option_b = callback(_cast_vote, voting_id, OPTIONS.no),
		},
	}

	Managers.voting:set_notification(voting_id, data)
end

local function _update_voting_popup(voting_id, params)
	local post_vote_message = Localize(VotingFlowSettings[params.flow_settings_name].post_vote_message, true, yes_color)
	local data = {
		keep_alive = false,
		show_timer = true,
		title = Localize(VotingFlowSettings[params.flow_settings_name].title),
		description = post_vote_message,
		inputs = {},
	}

	Managers.voting:set_notification(voting_id, data)
end

local flow_voting_template = {
	abort_on_member_joined = false,
	abort_on_member_left = false,
	can_change_vote = false,
	duration = 15,
	evaluate_delay = nil,
	name = "flow",
	rpc_request_voting = nil,
	rpc_start_voting = "rpc_start_voting_flow",
	voting_impl = "network",
	options = {
		OPTIONS.yes,
		OPTIONS.no,
	},
	results = {
		RESULTS.approved,
		RESULTS.rejected,
	},
	timeout_option = OPTIONS.yes,
	required_params = {
		"node_id",
		"flow_settings_name",
	},
	pack_params = function (params)
		return NetworkLookup.voting_flow_settings[params.flow_settings_name]
	end,
	unpack_params = function (flow_template_id)
		return {
			flow_settings_name = NetworkLookup.voting_flow_settings[flow_template_id],
		}
	end,
	evaluate = function (votes)
		local votes_for = 0
		local votes_against = 0
		local total_voters = 0

		for _, option in pairs(votes) do
			if option == OPTIONS.yes then
				votes_for = votes_for + 1
			elseif option == OPTIONS.no then
				votes_against = votes_against + 1
			end

			total_voters = total_voters + 1
		end

		if votes_for / total_voters > 0.5 then
			return RESULTS.approved
		elseif votes_against / total_voters > 0.5 then
			return RESULTS.rejected
		elseif total_voters <= votes_against + votes_for then
			return votes_against <= votes_for and RESULTS.approved or RESULTS.rejected
		end
	end,
	network_interface = function ()
		return Managers.connection
	end,
	can_start = function (params)
		return true
	end,
	initial_votes = function (params, voting_initiator_peer)
		local initiator_peer = params.initiator_peer

		if initiator_peer then
			return {
				[initiator_peer] = OPTIONS.yes,
			}
		else
			return {}
		end
	end,
	on_started = function (voting_id, template, params)
		local my_peer_id = Network.peer_id()

		if not Managers.voting:has_voted(voting_id, my_peer_id) then
			_show_voting_popup(voting_id, params)
		end
	end,
	on_completed = function (voting_id, template, params, result)
		_close_voting_popup(voting_id)

		if result == RESULTS.approved then
			_finish_vote(params, "yes")

			if params.flow_settings_name == "expeditions_extract" then
				Managers.event:trigger("expedition_extraction_music_trigger")
			end
		else
			_finish_vote(params, "no")
		end
	end,
	on_aborted = function (voting_id, template, params, abort_reason)
		_close_voting_popup(voting_id)
		_finish_vote(params, "no")
	end,
	on_vote_casted = function (voting_id, template, voter_peer_id, vote_option, params)
		if voter_peer_id == Network.peer_id() and vote_option == OPTIONS.yes then
			_update_voting_popup(voting_id, params)
		end
	end,
}

return flow_voting_template
