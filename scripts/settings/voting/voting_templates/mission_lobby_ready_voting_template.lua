local OPTIONS = table.enum("yes", "no")
local RESULTS = table.enum("approved", "empty")

local function _update_voting_view(context)
	Managers.event:trigger("event_lobby_vote_started", context)
end

local function _open_voting_view(context)
	local transition_time = nil
	local close_previous = false
	local close_all = true
	local close_transition_time = nil

	Managers.ui:open_view("lobby_view", transition_time, close_previous, close_all, close_transition_time, context)
end

local function _close_voting_view()
	local ui_manager = Managers.ui

	if ui_manager:view_active("lobby_view") then
		ui_manager:close_view("lobby_view")
	end
end

local mission_lobby_ready_voting_template = {
	name = "mission_lobby_ready",
	can_change_vote = true,
	force_timeout_option = true,
	abort_on_member_left = false,
	rpc_start_voting = "rpc_start_voting_mission_lobby_ready",
	abort_on_member_joined = false,
	duration = 60,
	voting_impl = "network",
	evaluate_delay = 10,
	options = {
		OPTIONS.yes,
		OPTIONS.no
	},
	results = {
		RESULTS.approved
	},
	timeout_option = OPTIONS.yes,
	required_params = {
		"mission_data"
	},
	pack_params = function (params)
		local mission_data = params.mission_data
		local mission_name = mission_data.mission_name
		local mission_name_id = NetworkLookup.missions[mission_name]
		local circumstance_name = mission_data.circumstance_name
		local circumstance_name_id = NetworkLookup.circumstance_templates[circumstance_name]

		return mission_name_id, circumstance_name_id
	end,
	unpack_params = function (mission_name_id, circumstance_name_id)
		local mission_name = NetworkLookup.missions[mission_name_id]
		local circumstance_name = NetworkLookup.circumstance_templates[circumstance_name_id]

		return {
			mission_data = {
				mission_name = mission_name,
				circumstance_name = circumstance_name
			}
		}
	end,
	evaluate = function (votes)
		for _, option in pairs(votes) do
			if option == StrictNil or option == OPTIONS.no then
				return nil
			end
		end

		if table.size(votes) > 0 then
			return RESULTS.approved
		else
			return RESULTS.empty
		end
	end,
	network_interface = function ()
		return Managers.connection
	end,
	on_started = function (voting_id, template, params)
		if DEDICATED_SERVER then
			return
		end

		local view_context = {
			mission_data = params.mission_data,
			voting_id = voting_id
		}

		if Managers.ui:view_active("lobby_view") then
			_update_voting_view(view_context)
		else
			_open_voting_view(view_context)
		end

		Managers.event:trigger("event_lobby_ready_voting_started", voting_id)
	end,
	on_completed = function (voting_id, template, params, result)
		if DEDICATED_SERVER then
			return
		end

		_close_voting_view()
		Managers.event:trigger("event_lobby_ready_voting_completed")
	end,
	on_aborted = function (voting_id, template, params, abort_reason)
		if DEDICATED_SERVER then
			return
		end

		_close_voting_view()
		Managers.event:trigger("event_lobby_ready_voting_aborted")
	end,
	on_vote_casted = function (voting_id, template, voter_peer_id, vote_option)
		if DEDICATED_SERVER then
			return
		end

		Managers.event:trigger("event_lobby_ready_vote_casted")
	end
}

return mission_lobby_ready_voting_template
