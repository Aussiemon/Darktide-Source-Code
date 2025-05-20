-- chunkname: @scripts/managers/mechanism/mechanisms/mechanism_onboarding.lua

local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local MechanismBase = require("scripts/managers/mechanism/mechanisms/mechanism_base")
local Missions = require("scripts/settings/mission/mission_templates")
local StateGameplay = require("scripts/game_states/game/state_gameplay")
local StateLoading = require("scripts/game_states/game/state_loading")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local SINGLEPLAY_TYPES = MatchmakingConstants.SINGLEPLAY_TYPES
local MechanismOnboarding = class("MechanismOnboarding", "MechanismBase")

MechanismOnboarding.init = function (self, ...)
	MechanismOnboarding.super.init(self, ...)

	local context = self._context

	self._singleplay_type = context.singleplay_type

	local mission_name = context.mission_name
	local mission_settings = Missions[mission_name]
	local level_name = mission_settings.level
	local circumstance_name = GameParameters.circumstance

	if not CircumstanceTemplates[circumstance_name] then
		Log.error("MechanismOnboarding", "[init] circumstance_name '%s' does not exists. Fallback to 'default'", circumstance_name)

		circumstance_name = "default"
	end

	local data = self._mechanism_data

	data.challenge = context.challenge_level or DevParameters.challenge
	data.resistance = DevParameters.resistance
	data.level_name = level_name
	data.mission_name = mission_name
	data.circumstance_name = circumstance_name
	data.side_mission = GameParameters.side_mission
	self._init_scenario = context.init_scenario
end

MechanismOnboarding.sync_data = function (self)
	return
end

MechanismOnboarding.game_mode_end = function (self, outcome)
	self:_set_state("game_mode_ended")
end

MechanismOnboarding.all_players_ready = function (self)
	return
end

MechanismOnboarding.client_exit_gameplay = function (self)
	return
end

MechanismOnboarding.wanted_transition = function (self)
	local state = self._state
	local mechanism_data = self._mechanism_data

	if state == "init" then
		self:_set_state("gameplay")

		local mission_name = mechanism_data.mission_name
		local level_name = mechanism_data.level_name
		local challenge = mechanism_data.challenge
		local resistance = mechanism_data.resistance
		local side_mission = mechanism_data.side_mission
		local circumstance_name = mechanism_data.circumstance_name

		Log.info("MechanismOnboarding", "Using dev parameters for challenge and resistance (%s/%s)", challenge, resistance)

		return false, StateLoading, {
			wait_for_despawn = true,
			level = level_name,
			mission_name = mission_name,
			circumstance_name = circumstance_name,
			side_mission = side_mission,
			next_state = StateGameplay,
			next_state_params = {
				mechanism_data = mechanism_data,
			},
		}
	elseif state == "gameplay" then
		if self._init_scenario and Managers.state.game_mode then
			local init_scenario = self._init_scenario

			if init_scenario then
				Managers.state.game_mode:set_init_scenario(init_scenario.alias, init_scenario.name)
			end

			self._init_scenario = nil
		end

		local party_immaterium = Managers.party_immaterium
		local session_in_progress = party_immaterium and party_immaterium:game_session_in_progress()

		if session_in_progress then
			local game_session_id = party_immaterium:current_game_session_id()

			if self._last_auto_joined_game_session_id ~= game_session_id then
				self._last_auto_joined_game_session_id = game_session_id

				self:_retry_join()
			elseif not self._retry_popup_id then
				self:_show_retry_popup()
			end

			return false
		end

		return false
	elseif state == "joining_party_game_session" then
		if self._joining_party_game_session:is_dead() then
			self:_set_state("gameplay")

			self._joining_party_game_session = nil

			return false
		end

		if self._joining_party_game_session:is_booted() then
			self:_set_state("joining_hub_server")

			return false, StateLoading, {}
		end

		return false
	elseif state == "game_mode_ended" then
		local story_name = Managers.narrative.STORIES.onboarding
		local current_chapter = Managers.narrative:current_chapter(story_name)

		if current_chapter then
			local chapter_data = current_chapter.data
			local mission_name = chapter_data.mission_name

			mechanism_data.mission_name = mission_name
			mechanism_data.level_name = Missions[mission_name].level

			self:_set_state("init")

			return false
		else
			Log.info("MechanismOnboarding", "Last onboarding mission ended, joining hub...")
			Managers.multiplayer_session:leave("leave_to_hub")
			self:_set_state("joining_hub_server")

			return false
		end
	elseif state == "joining_hub_server" then
		return false
	end
end

MechanismOnboarding._retry_join = function (self)
	if self._state == "gameplay" and Managers.party_immaterium:game_session_in_progress() then
		self._joining_party_game_session = Managers.party_immaterium:join_game_session()

		self:_set_state("joining_party_game_session")
	end
end

MechanismOnboarding._show_retry_popup = function (self)
	local context = {
		description_text = "loc_popup_description_reconnect_to_session",
		title_text = "loc_popup_header_reconnect_to_session",
		options = {
			{
				close_on_pressed = true,
				text = "loc_popup_reconnect_to_session_reconnect_button",
				callback = function ()
					self._retry_popup_id = nil

					self:_retry_join()
				end,
			},
			{
				close_on_pressed = true,
				hotkey = "back",
				text = "loc_popup_reconnect_to_session_leave_button",
				callback = function ()
					self._retry_popup_id = nil

					Managers.party_immaterium:leave_party()
				end,
			},
		},
	}

	Managers.event:trigger("event_show_ui_popup", context, function (id)
		self._retry_popup_id = id
	end)
end

MechanismOnboarding.is_allowed_to_reserve_slots = function (self, peer_ids)
	return true
end

MechanismOnboarding.peers_reserved_slots = function (self, peer_ids)
	return
end

MechanismOnboarding.peer_freed_slot = function (self, peer_id)
	return
end

MechanismOnboarding.destroy = function (self)
	self._joining_party_game_session = nil

	if self._retry_popup_id then
		Managers.event:trigger("event_remove_ui_popup", self._retry_popup_id)

		self._retry_popup_id = nil
	end
end

MechanismOnboarding.singleplay_type = function (self)
	return self._singleplay_type
end

implements(MechanismOnboarding, MechanismBase.INTERFACE)

return MechanismOnboarding
