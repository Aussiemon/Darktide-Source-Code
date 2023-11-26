-- chunkname: @scripts/settings/presence/presence_settings.lua

local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local PartyConstants = require("scripts/settings/network/party_constants")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local PartyState = PartyConstants.State
local presence_settings = {}

presence_settings.settings = {
	splash_screen = {
		advertise_playing = false,
		can_be_joined = false,
		hud_localization = "loc_hud_presence_main_menu",
		can_be_invited = false
	},
	title_screen = {
		advertise_playing = false,
		can_be_joined = false,
		hud_localization = "loc_hud_presence_main_menu",
		can_be_invited = false
	},
	main_menu = {
		advertise_playing = true,
		can_be_joined = true,
		hud_localization = "loc_hud_presence_main_menu",
		can_be_invited = true
	},
	loading = {
		advertise_playing = false,
		can_be_joined = false,
		hud_localization = "loc_hud_presence_loading",
		can_be_invited = false
	},
	onboarding = {
		split_party = true,
		can_be_joined = false,
		hud_localization = "loc_hud_presence_prologue",
		can_be_invited = false,
		advertise_playing = false
	},
	hub = {
		advertise_playing = true,
		can_be_joined = true,
		hud_localization = "loc_hud_presence_hub",
		can_be_invited = true
	},
	cinematic = {
		advertise_playing = false,
		can_be_joined = false,
		hud_localization = "loc_hud_presence_cinematic",
		can_be_invited = false
	},
	matchmaking = {
		advertise_playing = true,
		can_be_joined = true,
		hud_localization = "loc_hud_presence_matchmaking",
		can_be_invited = true,
		fail_reason_myself = "loc_social_party_join_rejection_reason_you_are_in_matchmaking",
		fail_reason_other = "loc_social_party_join_rejection_reason_player_in_matchmaking"
	},
	mission = {
		advertise_playing = true,
		can_be_joined = true,
		hud_localization = "loc_hud_presence_mission",
		can_be_invited = true,
		fail_reason_myself = "loc_social_party_join_rejection_reason_you_are_in_mission",
		fail_reason_other = "loc_social_party_join_rejection_reason_player_in_mission"
	},
	training_grounds = {
		split_party = false,
		can_be_joined = true,
		hud_localization = "loc_hud_presence_training_grounds",
		can_be_invited = true,
		advertise_playing = true
	},
	end_of_round = {
		advertise_playing = false,
		can_be_joined = true,
		hud_localization = "loc_hud_presence_end_of_round",
		can_be_invited = true
	}
}

presence_settings.evaluate_presence = function (game_state)
	if game_state == "StateSplash" then
		return "splash_screen"
	elseif game_state == "StateTitle" or game_state == "StateError" then
		return "title_screen"
	elseif game_state == "StateMainMenu" or game_state == "StateExitToMainMenu" then
		return "main_menu"
	elseif game_state == "StateVictoryDefeat" or game_state == "StateGameScore" or game_state == "StateMissionServerExit" then
		return "end_of_round"
	end

	local host_type = Managers.multiplayer_session:host_type()

	if host_type == HOST_TYPES.hub_server then
		local player = Managers.player:local_player(1)

		if player:unit_is_alive() then
			local immaterium_party_manager = Managers.party_immaterium

			if immaterium_party_manager then
				local matchmaking_state = immaterium_party_manager:current_state()

				if matchmaking_state == PartyState.matchmaking or matchmaking_state == PartyState.matchmaking_acceptance_vote then
					return "matchmaking"
				end
			end

			if Managers.multiplayer_session:is_booting_session() then
				return "matchmaking"
			end

			local cinematic_manager = Managers.state and Managers.state.cinematic

			if cinematic_manager and (cinematic_manager:waiting_for_player_input() or cinematic_manager:is_playing()) then
				return "cinematic"
			end

			return "hub"
		end
	elseif host_type == HOST_TYPES.mission_server then
		return "mission"
	elseif host_type == HOST_TYPES.singleplay then
		local is_onboarding = not Managers.narrative:is_story_complete("onboarding")

		if is_onboarding then
			return "onboarding"
		else
			return "training_grounds"
		end
	end

	return "loading"
end

return settings("PresenceSettings", presence_settings)
