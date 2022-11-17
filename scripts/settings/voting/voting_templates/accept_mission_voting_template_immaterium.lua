local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local _voting_popup_ids = {}

local function _open_voting_view(voting_id)
	local context = {
		title_text = "loc_accept_mission_voting_title_header",
		description_text = "loc_accept_mission_voting_title_description",
		description_text_params = {},
		options = {
			{
				text = "loc_accept_mission_voting_title_accept_button",
				close_on_pressed = true,
				callback = function ()
					Managers.voting:cast_vote(voting_id, "yes")

					_voting_popup_ids[voting_id] = nil
				end
			},
			{
				text = "loc_accept_mission_voting_title_decline_button",
				close_on_pressed = true,
				hotkey = "back",
				callback = function ()
					Managers.voting:cast_vote(voting_id, "no")

					_voting_popup_ids[voting_id] = nil
				end
			}
		}
	}

	Managers.event:trigger("event_show_ui_popup", context, function (id)
		_voting_popup_ids[voting_id] = id
	end)
end

local function _close_voting_view(voting_id)
	local popup_id = _voting_popup_ids[voting_id]

	if popup_id then
		Managers.event:trigger("event_remove_ui_popup", popup_id)

		_voting_popup_ids[voting_id] = nil
	end
end

local accept_mission_voting_template_immaterium = {
	name = "accept_mission_immaterium",
	immaterium_party_vote_type = "accept_matchmaking",
	voting_impl = "party_immaterium",
	initiated_by_server = true,
	on_started = function (voting_id, template, params)
		if Managers.ui:view_active("system_view") then
			Managers.ui:close_view("system_view")
		end

		Managers.voting:cast_vote(voting_id, "yes")
	end
}

accept_mission_voting_template_immaterium.on_completed = function (voting_id, template, vote_state, result)
	_close_voting_view(voting_id)

	if result == "rejected" then
		Log.info("party declined mission!")
	else
		local ui_manager = Managers.ui

		if ui_manager and ui_manager:has_active_view() then
			ui_manager:close_all_views()
		end
	end
end

accept_mission_voting_template_immaterium.on_aborted = function (voting_id, template, params, abort_reason)
	_close_voting_view(voting_id)
end

accept_mission_voting_template_immaterium.on_vote_casted = function (voting_id, template, voter_account_id, vote_option)
	if vote_option == "no" then
		if voter_account_id == Managers.party_immaterium:get_myself():account_id() then
			_close_voting_view(voting_id)
		else
			local _, promise = Managers.presence:get_presence(voter_account_id)

			promise:next(function (presence)
				local message = Localize("loc_party_notification_accept_mission_voting_decline", true, {
					member_character_name = presence:character_name()
				})
				local sound_event = UISoundEvents.mission_vote_player_declined

				Managers.event:trigger("event_add_notification_message", "default", message, nil, sound_event)
			end)
		end
	end
end

return accept_mission_voting_template_immaterium
