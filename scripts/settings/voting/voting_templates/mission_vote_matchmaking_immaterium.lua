-- chunkname: @scripts/settings/voting/voting_templates/mission_vote_matchmaking_immaterium.lua

local Promise = require("scripts/foundation/utilities/promise")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")

local function _open_voting_view(context)
	local transition_time
	local close_previous = false
	local close_all = false
	local close_transition_time

	if not table.is_empty(Managers.ui:active_views()) then
		Managers.ui:close_all_views()
	end

	Managers.ui:open_view("mission_voting_view", transition_time, close_previous, close_all, close_transition_time, context)
end

local function _close_voting_view()
	local ui_manager = Managers.ui

	if ui_manager:view_active("mission_voting_view") then
		ui_manager:close_view("mission_voting_view")
	end
end

local mission_vote_matchmaking_immaterium = {
	immaterium_party_vote_type = "start_matchmaking",
	name = "mission_vote_matchmaking_immaterium",
	voting_impl = "party_immaterium",
	required_params = {
		"backend_mission_id",
	},
	static_params = {
		matchmaker_type = "mission",
	},
	on_started = function (voting_id, template, params)
		if Managers.ui:view_active("system_view") then
			Managers.ui:close_view("system_view")
		end

		if GameParameters.debug_mission then
			Managers.voting:cast_vote(voting_id, "yes")
		elseif not Managers.voting:has_voted(voting_id, Managers.party_immaterium:get_myself():unique_id()) then
			if params.qp == "true" then
				local view_context = {
					qp = params.qp,
					voting_id = voting_id,
					backend_mission_id = params.backend_mission_id,
				}

				_open_voting_view(view_context)
			else
				local view_context = {
					voting_id = voting_id,
					backend_mission_id = params.backend_mission_id,
					mission_data = cjson.decode(params.mission_data).mission,
				}

				_open_voting_view(view_context)
			end
		end
	end,
	on_completed = function (voting_id, template, vote_state, result)
		_close_voting_view()

		if result == "rejected" then
			Log.info("party declined mission!")
		else
			local ui_manager = Managers.ui

			if ui_manager and ui_manager:has_active_view() then
				ui_manager:close_all_views()
			end
		end
	end,
	fetch_my_vote_params = function (template, params, option)
		if option == "yes" then
			local profile = Managers.player:local_player_backend_profile()
			local character_id = profile and profile.character_id

			return Managers.backend.interfaces.matchmaker:fetch_queue_ticket_mission(params.backend_mission_id, character_id, params.private_session == "true"):next(function (response)
				return {
					ticket = response.ticket,
				}
			end)
		else
			return Promise.resolved({})
		end
	end,
	on_aborted = function (voting_id, template, params, abort_reason)
		_close_voting_view()
	end,
	on_vote_casted = function (voting_id, template, voter_account_id, vote_option)
		if vote_option == "no" then
			if voter_account_id == Managers.party_immaterium:get_myself():account_id() then
				_close_voting_view()
			else
				local _, promise = Managers.presence:get_presence(voter_account_id)

				promise:next(function (presence)
					local message = Localize("loc_party_notification_accept_mission_voting_decline", true, {
						member_character_name = presence:character_name(),
					})
					local sound_event = UISoundEvents.mission_vote_player_declined

					Managers.event:trigger("event_add_notification_message", "default", message, nil, sound_event)
				end)
			end
		end
	end,
}

return mission_vote_matchmaking_immaterium
